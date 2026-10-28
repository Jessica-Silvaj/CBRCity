-- WashManager: server-side tracking of all active wash areas, player proximity,
-- cleaning deltas, and task completion detection.

WashManager = {
    activeWashAreas    = {},  -- washAreaId -> WashArea object
    contractWashAreas  = {},  -- contractId -> { washAreaId, ... }
    taskWashAreas      = {},  -- taskId     -> { washAreaId, ... }
    playerStats        = {},  -- contractId -> { serverId -> pixelsCleaned }
    playerNearbyAreas  = {},  -- serverId   -> { washAreaId, ... }
    lastPlayerUpdate   = {},  -- serverId   -> lastUpdateTimestamp
    pendingDeltas      = {},  -- washAreaId -> { pixelId -> { x, y, amount } }
}

-- Minimum ms between proximity updates per player
local PROXIMITY_UPDATE_COOLDOWN_MS = 500

-- Server sync interval (clamped to at least 1000ms)
local SYNC_INTERVAL_MS = math.max(1000, Config.syncInterval or 2500)

-- Helper: send wash area updates to a player via the configured sync method
local function SendWashAreasToPlayer(serverId, areasData)
    if Config.syncMethod == "latent_event" or Config.syncMethod == "event" then
        TriggerClientEvent("kq_powerwashing:client:washAreasUpdate", serverId, areasData)
    else
        local player = Player(serverId)
        if player then
            player.state:set("kq_powerwashing_washAreas", areasData, true)
        end
    end
end

-- ============================================================
-- Init
-- ============================================================

function WashManager.Init(self)
    self.activeWashAreas   = {}
    self.contractWashAreas = {}
    self.taskWashAreas     = {}
    self.playerNearbyAreas = {}
    self.lastPlayerUpdate  = {}
    self.pendingDeltas     = {}
    GlobalState.washAreas  = {}
    Debug("WashManager initialized")
end

-- ============================================================
-- Area creation / registration
-- ============================================================

-- Create WashArea objects for all spots in a contract and publish them to GlobalState
function WashManager.CreateWashAreasForContract(self, contract, spots, onlineServerIds)
    local areaIds       = {}  -- ordered list of area IDs for this contract
    local lightweightData = {} -- lightweight snapshots for GlobalState

    Debug(string.format("Creating wash areas from %d spots", #spots))

    -- Resolve server IDs → identifiers
    local identifiers = {}
    for _, serverId in pairs(onlineServerIds) do
        table.insert(identifiers, GetPlayerUniqueIdentifier(serverId))
    end

    -- Create a WashArea for each spot
    for i, spot in ipairs(spots) do
        local area, err = WashArea.new(
            contract.id,
            spot.taskId,
            spot.corners,
            spot.edgeFadeout,
            spot.dirtColor,
            spot.cleaningMultiplier,
            spot.flipped,
            spot.opacityMultiplier,
            spot.completionThreshold,
            identifiers
        )

        if not area then
            Debug(string.format("ERROR: Failed to create WashArea %d: %s", i, tostring(err)))
        else
            Debug(string.format(
                "Created WashArea %d: id=%s, taskId=%s, center=(%.1f, %.1f, %.1f)",
                i, area.id, spot.taskId, area.center.x, area.center.y, area.center.z))

            self.activeWashAreas[area.id] = area
            table.insert(areaIds, area.id)
            table.insert(lightweightData, area:GetLightweightData())

            -- Index by task ID
            if not self.taskWashAreas[spot.taskId] then
                self.taskWashAreas[spot.taskId] = {}
            end
            table.insert(self.taskWashAreas[spot.taskId], area.id)
        end
    end

    -- Publish all new areas to GlobalState
    Debug(string.format("Adding %d areas to GlobalState", #lightweightData))
    if #lightweightData > 0 then
        local existing = GlobalState.washAreas or {}
        Debug(string.format("GlobalState had %d areas before", #existing))
        for _, areaData in ipairs(lightweightData) do
            table.insert(existing, areaData)
        end
        GlobalState.washAreas = existing
        Debug(string.format("GlobalState now has %d areas", #GlobalState.washAreas))
    end

    self.contractWashAreas[contract.id] = areaIds
    Debug(string.format("[kq_powerwashing] Created %d WashAreas for contract %s",
        #areaIds, contract.id))

    return areaIds
end

-- Register a single WashArea (used externally if needed)
function WashManager.RegisterWashArea(self, area)
    self.activeWashAreas[area.id] = area
    GlobalState.washAreas = GlobalState.washAreas or {}
end

-- Remove a WashArea from active tracking and GlobalState
function WashManager.UnregisterWashArea(self, areaId)
    self.activeWashAreas[areaId] = nil

    local existing = GlobalState.washAreas or {}
    for i, areaData in ipairs(existing) do
        if areaData.id == areaId then
            table.remove(existing, i)
            break
        end
    end
    GlobalState.washAreas = existing
end

-- ============================================================
-- Contract cleanup
-- ============================================================

function WashManager.CleanupContract(self, contractId)
    local areaIds = self.contractWashAreas[contractId]
    if not areaIds then
        Debug("wash areas not found")
        return
    end

    for _, areaId in ipairs(areaIds) do
        local area = self.activeWashAreas[areaId]
        if area then
            -- Remove this area from its task's tracking list
            local taskId    = area:GetTaskId()
            local taskAreas = self.taskWashAreas[taskId]
            if taskAreas then
                for i, id in ipairs(taskAreas) do
                    if id == areaId then
                        table.remove(taskAreas, i)
                        break
                    end
                end
                if #self.taskWashAreas[taskId] == 0 then
                    self.taskWashAreas[taskId] = nil
                end
            end
        end
        self:UnregisterWashArea(areaId)
    end

    self.playerStats[contractId]      = {}
    self.contractWashAreas[contractId] = nil
end

-- ============================================================
-- Cleaning delta processing
-- ============================================================

-- Buffer an incoming cleaning delta from a player into pendingDeltas
function WashManager.BufferCleaningDelta(self, serverId, deltasByArea)
    if type(deltasByArea) ~= "table" then return end

    for areaId, pixels in pairs(deltasByArea) do
        if not self.pendingDeltas[areaId] then
            self.pendingDeltas[areaId] = {}
        end

        local pixelsCleaned = 0
        for pixelId, pixel in pairs(pixels) do
            if not self.pendingDeltas[areaId][pixelId] then
                self.pendingDeltas[areaId][pixelId] = { x = pixel.x, y = pixel.y, amount = 0 }
            end
            self.pendingDeltas[areaId][pixelId].amount =
                self.pendingDeltas[areaId][pixelId].amount + pixel.amount
            pixelsCleaned = pixelsCleaned + 1
        end

        -- Track pixels cleaned per player (for top-washer bonus)
        if Config.bonuses.topWasher > 0 then
            if not self.playerStats[areaId] then self.playerStats[areaId] = {} end
            self.playerStats[areaId][serverId] =
                (self.playerStats[areaId][serverId] or 0) + pixelsCleaned
            Debug(serverId, "has now has washed " ..
                self.playerStats[areaId][serverId] .. " pixels")
        end
    end

    Debug(string.format("[WashManager] Buffered delta from player %d", serverId))
end

-- Apply all pending deltas to WashArea objects; broadcast updates; finish completed tasks
-- Returns true if any updates were applied, false otherwise
function WashManager.ProcessPendingDeltas(self)
    if not next(self.pendingDeltas) then return false end

    local updatedAreaIds = {}  -- areas that changed this cycle
    local completedTasks = {}  -- taskId -> true, for tasks that became fully clean

    for areaId, pixelDeltas in pairs(self.pendingDeltas) do
        local area = self.activeWashAreas[areaId]
        if area then
            local changed = area:ApplyCleaningDelta(pixelDeltas)
            if changed then
                table.insert(updatedAreaIds, areaId)
                completedTasks[area:GetTaskId()] = true
            end
        end
    end

    self.pendingDeltas = {}

    -- Finish any tasks that are now fully clean
    for taskId in pairs(completedTasks) do
        if self:IsTaskFullyClean(taskId) then
            Debug(string.format("[WashManager] Task %s complete, finishing", taskId))
            exports.kq_jobcontracts:FinishTask(taskId)
        end
    end

    if #updatedAreaIds > 0 then
        Debug(string.format("[WashManager] Broadcasting updates for %d areas", #updatedAreaIds))
        self:UpdateNearbyPlayers(updatedAreaIds)
        return true
    end

    return false
end

-- Apply a delta directly (synchronous path, used by latent events)
function WashManager.ApplyCleaningDelta(self, serverId, deltasByArea)
    if type(deltasByArea) ~= "table" then return end

    local updatedAreaIds = {}
    local completedTasks = {}

    for areaId, pixelDeltas in pairs(deltasByArea) do
        local area = self.activeWashAreas[areaId]
        if area then
            local changed = area:ApplyCleaningDelta(pixelDeltas)
            if changed then
                table.insert(updatedAreaIds, areaId)
                completedTasks[area:GetTaskId()] = true
            end
        end
    end

    for taskId in pairs(completedTasks) do
        if self:IsTaskFullyClean(taskId) then
            Debug(string.format("[WashManager] Task %s complete, finishing", taskId))
            exports.kq_jobcontracts:FinishTask(taskId)
        end
    end

    if #updatedAreaIds > 0 then
        self:UpdateNearbyPlayers(updatedAreaIds)
    end
end

-- ============================================================
-- Task / cleanliness queries
-- ============================================================

-- Return true if all WashAreas for a task meet their completion threshold
function WashManager.IsTaskFullyClean(self, taskId)
    local areaIds = self.taskWashAreas[taskId]
    if not areaIds then return false end

    local totalClean       = 0
    local totalMax         = 0
    local totalThreshold   = 0
    local areaCount        = 0

    for _, areaId in ipairs(areaIds) do
        local area = self.activeWashAreas[areaId]
        if area then
            -- GetCleanlinessPercentage devuelve (percentage 0-100, totalPixels, cleanPixels)
            -- Usamos cleanPixels y totalPixels para acumular correctamente entre areas
            local _pct, total, clean = area:GetCleanlinessPercentage()
            totalClean     = totalClean     + (clean or 0)
            totalMax       = totalMax       + (total or 0)
            totalThreshold = totalThreshold + (area.completionThreshold or 100)
            areaCount      = areaCount      + 1
        end
    end

    if totalMax == 0 or areaCount == 0 then return false end

    -- cleanPixels es fraccion 0-1 por pixel, totalMax es numero de pixeles
    -- => cleanPixels/totalMax ya es 0-1, multiplicamos por 100 para comparar con threshold
    -- Arredonda para cima igual ao cliente (washRenderer usa math.ceil): se a tela mostra 100%, conclui.
    -- Antes 99,x% aparecia como 100% mas nunca atingia o limite de 100 e a tarefa não avançava.
    local avgCleanPct       = math.ceil((totalClean / totalMax) * 100)
    local avgThresholdPct   = totalThreshold / areaCount
    return avgCleanPct >= avgThresholdPct
end

-- Return the server ID (as a number) of the player who cleaned the most pixels
-- across all WashAreas for the given contract, or nil if unknown
function WashManager.GetTopPlayer(self, contractId)
    local areaIds = self.contractWashAreas[contractId]
    if not areaIds then return nil end

    -- Aggregate pixel counts across all areas for this contract
    local pixelsPerPlayer = {}
    for _, areaId in ipairs(areaIds) do
        local area = self.activeWashAreas[areaId]
        if area then
            local statsForArea = (self.playerStats[areaId]) or {}
            for serverId, count in pairs(statsForArea) do
                pixelsPerPlayer[serverId] = (pixelsPerPlayer[serverId] or 0) + count
            end
        end
    end

    Debug("pixelsPerPlayers", json.encode(pixelsPerPlayer))

    local topPlayer = nil
    local topCount  = 0
    for serverId, count in pairs(pixelsPerPlayer) do
        if count > topCount then
            topPlayer = serverId
            topCount  = count
        end
    end

    return tonumber(topPlayer)
end

-- ============================================================
-- Proximity / streaming
-- ============================================================

-- Update the list of nearby areas for a player, throttled to PROXIMITY_UPDATE_COOLDOWN_MS
function WashManager.UpdatePlayerProximity(self, serverId, nearbyAreaIds)
    local now     = GetGameTimer()
    local lastMs  = self.lastPlayerUpdate[serverId] or 0

    if (now - lastMs) < PROXIMITY_UPDATE_COOLDOWN_MS then return end

    self.lastPlayerUpdate[serverId]  = now
    self.playerNearbyAreas[serverId] = nearbyAreaIds

    -- Build full data payloads for each nearby area
    local fullData = {}
    for _, areaId in ipairs(nearbyAreaIds) do
        local area = self.activeWashAreas[areaId]
        if area then
            table.insert(fullData, area:GetFullData())
        end
    end

    SendWashAreasToPlayer(serverId, fullData)
end

-- Clear proximity state when a player disconnects
function WashManager.ClearPlayerProximity(self, serverId)
    self.playerNearbyAreas[serverId] = nil
    self.lastPlayerUpdate[serverId]  = nil
end

-- Push updated area data to all players who have any of the changed areas in proximity
function WashManager.UpdateNearbyPlayers(self, changedAreaIds)
    -- Find which players need an update
    local playersToUpdate = {}
    for serverId, nearbyAreas in pairs(self.playerNearbyAreas) do
        for _, nearbyId in ipairs(nearbyAreas) do
            for _, changedId in ipairs(changedAreaIds) do
                if nearbyId == changedId then
                    playersToUpdate[serverId] = true
                    break
                end
            end
        end
    end

    -- Send each affected player their nearby area data
    for serverId in pairs(playersToUpdate) do
        local nearby = self.playerNearbyAreas[serverId]
        if nearby then
            local fullData = {}
            for _, areaId in ipairs(nearby) do
                local area = self.activeWashAreas[areaId]
                if area then
                    table.insert(fullData, area:GetFullData())
                end
            end
            SendWashAreasToPlayer(serverId, fullData)
            Citizen.Wait(100) -- stagger sends to avoid bandwidth spike
        end
    end
end

-- ============================================================
-- Net events and state bag handler
-- ============================================================

-- Player reports which wash areas are nearby
RegisterNetEvent("kq_powerwashing:server:updateProximity")
AddEventHandler("kq_powerwashing:server:updateProximity", function(nearbyAreaIds)
    WashManager:UpdatePlayerProximity(source, nearbyAreaIds)
end)

-- Clean up proximity data when a player disconnects
AddEventHandler("playerDropped", function()
    WashManager:ClearPlayerProximity(source)
end)

-- State bag handler: player sets washDelta on their own state bag
AddStateBagChangeHandler("washDelta", nil, function(bagName, _, deltaData)
    if not deltaData then return end
    if not string.match(bagName, "^player:") then return end

    local serverIdStr = string.gsub(bagName, "player:", "")
    local serverId    = tonumber(serverIdStr)
    if not serverId then return end

    WashManager:BufferCleaningDelta(serverId, deltaData)
end)

-- Direct net event path for wash delta (alternative to state bag)
RegisterNetEvent("kq_powerwashing:server:washDelta")
AddEventHandler("kq_powerwashing:server:washDelta", function(deltaData)
    WashManager:BufferCleaningDelta(source, deltaData)
end)

-- Background loop: flush pending deltas on the sync interval
CreateThread(function()
    while true do
        Citizen.Wait(SYNC_INTERVAL_MS)
        local hadUpdates = WashManager:ProcessPendingDeltas()
        if not hadUpdates then
            Citizen.Wait(3000)  -- back off if nothing to process
        end
    end
end)