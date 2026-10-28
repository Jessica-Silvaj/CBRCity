-- server.lua: main server logic for kq_powerwashing
-- Manages contract creation, replenishment, vehicle spawning, and reward calculation

-- Tracks which config indices are currently active (index -> true)
local activeConfigIndices = {}
-- Maps contractId -> config index (so we know which index to free on end)
local contractToConfigIndex = {}
-- Tracks cancellation ban expiry timestamps (identifier -> expireAtMs)
local cancellationBans = {}

-- ============================================================
-- Helpers
-- ============================================================

-- Return a table of level-upgrade labels for the job board UI
local function GetLevelUpgradesForBoard()
    local list = {}
    for _, upgrade in pairs(Config.levelUpgrades) do
        table.insert(list, { label = upgrade.label, level = upgrade.level })
    end
    return list
end

-- Return a contract settings config for a player (vehicle selector if >1 unlocked vehicle)
local function GetContractSettingsConfig(serverId)
    local unlockedVehicles = {}
    for vehicleKey, vehicleCfg in pairs(Config.jobVehicles) do
        local unlocked = true
        if vehicleCfg.unlockRequired then
            local upgradeCfg = Config.levelUpgrades and Config.levelUpgrades[vehicleCfg.unlockRequired]
            if upgradeCfg then
                local stats      = exports.kq_jobcontracts:GetPlayerJobStats(serverId, "powerwashing")
                local playerLevel = (stats and stats.level) or 1
                if upgradeCfg.level > playerLevel then
                    unlocked = false
                end
            end
        end
        if unlocked then
            table.insert(unlockedVehicles, { label = vehicleCfg.label, value = vehicleKey })
        end
    end

    -- Only show the vehicle selector if there's more than one choice
    if table.count(unlockedVehicles) <= 1 then return {} end

    return {
        {
            id      = "vehicle",
            label   = L("settings.vehicle"),
            type    = "select",
            options = unlockedVehicles,
        }
    }
end

-- Get remaining cancellation ban time (ms) for an identifier; cleans up expired bans
local function GetCancellationBanRemaining(identifier)
    local expireAt = cancellationBans[identifier]
    if not expireAt then return 0 end

    local remaining = expireAt - GetGameTimer()
    if remaining <= 0 then
        cancellationBans[identifier] = nil
        return 0
    end
    return remaining
end

-- Apply a cancellation ban to a player and notify them
local function ApplyCancellationBan(identifier, serverId)
    if not Config.cancellationBan or not Config.cancellationBan.enabled then return end

    local durationMs = Config.cancellationBan.duration * 60 * 1000
    cancellationBans[identifier] = GetGameTimer() + durationMs

    TriggerClientEvent("kq_link:client:notify", serverId,
        L("cancellation_ban.applied", { time = Config.cancellationBan.duration }),
        "error"
    )
end

-- Return config indices that do not yet have an active contract
local function GetAvailableConfigIndices()
    local available = {}
    for i = 1, #Config.contracts do
        if not activeConfigIndices[i] then
            table.insert(available, i)
        end
    end
    return available
end

-- ============================================================
-- Contract builder: converts a Config.contracts[index] entry into
-- a kq_jobcontracts contract definition with all tasks and metadata
-- ============================================================
local function BuildContract(configIndex)
    local contractCfg = Config.contracts[configIndex]
    if not contractCfg then return nil end

    local taskList       = {}   -- ordered task definitions passed to kq_jobcontracts
    local areaMapping    = {}   -- flat list of wash area definitions with taskIndex
    local washTaskIndex  = 0    -- running index of wash_area tasks

    -- Step 0: always start with a hidden "enter_vehicle" task
    table.insert(taskList, {
        type   = "enter_vehicle",
        name   = L("tasks.enter_vehicle"),
        vars   = {},
        hidden = true,
    })

    -- Build one step group per location
    for _, location in ipairs(contractCfg.locations) do
        -- Navigation task (hidden): go to this location
        table.insert(taskList, {
            type   = "go_to_area",
            name   = L("tasks.go_to_prefix") .. location.name,
            vars   = {
                coords       = location.coords,
                locationName = location.name,
                tickDelay    = 1000,
            },
            hidden = true,
        })

        -- Collect wash tasks for this location's spots
        local locationWashTasks = {}
        for _, spot in ipairs(location.spots) do
            washTaskIndex = washTaskIndex + 1

            -- Use the midpoint of the first area's corners as a blip coord
            local firstCorners = spot.areas[1].corners or spot.areas[1]
            local midCoord     = (firstCorners[1] + firstCorners[3]) / 2

            table.insert(locationWashTasks, {
                type = "wash_area",
                name = L("tasks.clean_prefix") .. spot.name,
                vars = { coords = midCoord },
            })

            -- Register each sub-area in the mapping
            for _, area in ipairs(spot.areas) do
                local corners = area.corners or area
                table.insert(areaMapping, {
                    corners             = corners,
                    edgeFadeout         = area.edgeFadeout,
                    dirtColor           = area.dirtColor,
                    cleaningMultiplier  = area.cleaningMultiplier,
                    flipped             = area.flipped,
                    opacityMultiplier   = area.opacityMultiplier,
                    completionThreshold = area.completionThreshold,
                    locationName        = location.name,
                    spotName            = spot.name,
                    taskIndex           = washTaskIndex,
                })
            end
        end

        -- Add as a parallel step if >1 wash task, or flat if just one
        if #locationWashTasks > 1 then
            table.insert(taskList, locationWashTasks)
        elseif #locationWashTasks == 1 then
            table.insert(taskList, locationWashTasks[1])
        end
    end

    -- Final step: return to HQ (hidden) + report to supervisor
    table.insert(taskList, {
        {
            type   = "go_to_area",
            name   = L("tasks.return_to_hq"),
            vars   = {
                coords       = Config.headquarters.coords,
                locationName = L("headquarters.name"),
                tickDelay    = 1000,
            },
            hidden = true,
        },
        {
            type   = "finish_at_npc",
            name   = L("tasks.report_to_supervisor"),
            vars   = {},
            hidden = true,
        },
    })

    local estimatedMinutes = math.round(EstimateContractDuration(contractCfg).totalMs / 1000 / 60)
    Debug("Estimated duration", contractCfg.name, estimatedMinutes)

    -- ── onStart ──────────────────────────────────────────────────────────────
    local function onContractStart(contract, onlineServerIds)
        local spotTaskMapping = contract.metadata.spotTaskMapping
        if not spotTaskMapping then
            print("ERROR: No spotTaskMapping in contract metadata!")
            return
        end

        -- Mark this config index as in-use and schedule a replenishment
        contractToConfigIndex[contract.id] = true
        Citizen.CreateThread(function()
            Citizen.Wait(Config.contractReplenishDelay * 1000)
            ReplenishContract()
        end)

        -- Resolve vehicle type from player's settings choice or the default
        local spawnPoint = FindFreeSpawnPoint()
        local vehicleKey = (contract.settings and contract.settings.vehicle) or Config.defaultVehicle
        local vehicleCfg = Config.jobVehicles[vehicleKey]
        if not vehicleCfg then
            vehicleCfg = Config.jobVehicles[Config.defaultVehicle]
            vehicleKey = Config.defaultVehicle
        end

        -- Spawn the work vehicle
        local modelHash = GetHashKey(vehicleCfg.model)
        local veh       = SpawnJobVehicle(modelHash, spawnPoint)
        Citizen.Wait(50)
        while not DoesEntityExist(veh) do Wait(100) end

        -- Assign a random flavour plate
        local plateRoll = math.random(0, 30)
        if plateRoll == 1 then
            SetVehicleNumberPlateText(veh,
                math.random(10, 99) .. "KQ" .. math.random(1000, 9999))
        elseif math.random(0, 2) == 0 then
            SetVehicleNumberPlateText(veh, math.random(100, 999) .. "DIRTY")
        else
            SetVehicleNumberPlateText(veh, "HOSE" .. math.random(1000, 9999))
        end

        local netId = NetworkGetNetworkIdFromEntity(veh)
        contract.vars = contract.vars or {}
        contract.vars.vehicleNetId   = netId
        contract.data.vehicleEntity  = veh

        Debug(string.format("Spawned vehicle at %.2f, %.2f, %.2f (NetID: %d)",
            spawnPoint.x, spawnPoint.y, spawnPoint.z, netId))

        -- Map wash areas to contract task IDs
        local washSpots  = {}
        local taskCursor = 1

        Debug(string.format("[DEBUG] Mapping has %d areas", #spotTaskMapping))
        Debug(string.format("[DEBUG] Contract has %d tasks", #contract.tasks))

        for i, taskIdx in ipairs(contract.tasks) do
            local t = contract.tasks[i]
            Debug(string.format("[DEBUG] Task %d: type=%s, id=%s",
                i, t.type or "nil", t.id or "nil"))
        end

        for areaIdx, area in ipairs(spotTaskMapping) do
            -- Advance cursor to the next wash_area task
            while true do
                local t = contract.tasks[taskCursor]
                if not t then break end
                if t.type == "kq_powerwashing:wash_area" then break end
                taskCursor = taskCursor + 1
            end

            local matchedTask = contract.tasks[taskCursor]
            if matchedTask then
                local taskId = matchedTask.id
                Debug(string.format(
                    "[DEBUG] Mapped area %d (%s/%s) areaTaskIndex=%d -> contractTaskIndex=%d -> taskId=%s",
                    areaIdx, area.locationName or "?", area.spotName or "?",
                    area.taskIndex, taskCursor, taskId))

                table.insert(washSpots, {
                    taskId              = taskId,
                    corners             = area.corners,
                    edgeFadeout         = area.edgeFadeout,
                    dirtColor           = area.dirtColor,
                    cleaningMultiplier  = area.cleaningMultiplier,
                    flipped             = area.flipped,
                    opacityMultiplier   = area.opacityMultiplier,
                    completionThreshold = area.completionThreshold,
                })

                -- Advance cursor if next area belongs to a different task
                local nextArea = spotTaskMapping[areaIdx + 1]
                local nextTaskIndex = nextArea and nextArea.taskIndex
                if nextTaskIndex == nil then nextTaskIndex = -1 end
                if area.taskIndex ~= nextTaskIndex then
                    taskCursor = taskCursor + 1
                end
            else
                print(string.format(
                    "[DEBUG] ERROR: No task found at taskIndex=%d for area %d (%s/%s)",
                    taskCursor, areaIdx, area.locationName or "?", area.spotName or "?"))
            end
        end

        Debug(string.format("[DEBUG] Created %d washSpots total", #washSpots))

        WashManager:CreateWashAreasForContract(contract, washSpots, onlineServerIds)

        -- Give each player the power washer weapon and apply vehicle upgrades for leader
        for _, serverId in pairs(onlineServerIds) do
            if not exports.kq_link:DoesPlayerHaveWeapon(serverId, Config.powerWasherWeapon) then
                exports.kq_link:AddPlayerWeapon(serverId, Config.powerWasherWeapon, 1, 0)
            end

            local playerIdentifier = GetPlayerUniqueIdentifier(serverId)
            if playerIdentifier == contract.leaderId then
                local stats = exports.kq_jobcontracts:GetPlayerJobStats(serverId, "powerwashing")
                Entity(veh).state.kq_powerwashing_level = (stats and stats.level) or 0
            end

            if Dummy and Dummy.OnContractStarted then
                Citizen.CreateThread(function() Dummy.OnContractStarted(serverId) end)
            end
        end

        if Dummy and Dummy.OnVehicleSpawned then
            Citizen.SetTimeout(1500, function()
                Dummy.OnVehicleSpawned(veh, onlineServerIds)
            end)
        end

        contract.data.startedAtMs = GetGameTimer()
        return contract
    end

    -- ── onComplete ───────────────────────────────────────────────────────────
    local function onContractComplete(contract, onlineServerIds)
        local rewardData    = {}
        local playerCount   = table.count(onlineServerIds)
        local estimated     = EstimateContractDuration(contractCfg, playerCount)
        local startedAtMs   = contract.data.startedAtMs or GetGameTimer()
        local elapsedMs     = GetGameTimer() - startedAtMs
        local rating        = CalculateContractRating(estimated.totalMs, elapsedMs)
        local baseReward    = contract.reward or 0
        local perPlayerPay  = Config.splitProfitsBetweenTeam
            and math.ceil(baseReward / playerCount)
            or baseReward

        -- Base XP from contract duration (16 XP per estimated minute)
        local baseXp = math.floor(estimated.totalMs / 1000 / 60 * 16)

        -- Check vehicle condition
        local veh           = contract.data.vehicleEntity
        local vehicleStatus = "missing"

        local bonusList  = {}
        local bonusTotal = 0

        if veh and DoesEntityExist(veh) then
            local vehPos = GetEntityCoords(veh)
            if IsWithinDistance(Config.headquarters.coords, vehPos, 100) then
                local health = GetEntityHealth(veh)
                local damage = math.max(0, (1000 - health) / 1000)

                if health >= 997 then
                    -- Perfect condition bonus
                    vehicleStatus = "perfect"
                    local bonus = math.floor(baseReward * (Config.bonuses.vehicleCare / 100) * perPlayerPay / baseReward)
                    table.insert(bonusList, {
                        message = L("bonuses.vehicle_care"),
                        tip     = L("bonuses.vehicle_care_tip"),
                        amount  = bonus,
                    })
                    bonusTotal = bonusTotal + bonus
                    baseXp     = math.floor(baseXp * 1.05)

                elseif health < 960 then
                    -- Vehicle damaged penalty
                    vehicleStatus = "damaged"
                    local maxPenalty = Config.bonuses.maxVehicleDamagePenalty
                    local penalty    = -math.min(maxPenalty, math.min(perPlayerPay * 0.5, math.floor(perPlayerPay * damage)))
                    table.insert(bonusList, {
                        message = L("bonuses.vehicle_damage"),
                        tip     = L("bonuses.vehicle_damage_tip"),
                        amount  = penalty,
                    })
                    bonusTotal = bonusTotal + penalty
                    baseXp     = math.floor(baseXp * 0.9)
                    rating     = math.min(4, rating)
                end
            end
        else
            -- Vehicle missing penalty
            local missingPenalty = Config.bonuses.missingVehiclePenalty or 1500
            table.insert(bonusList, {
                message = L("bonuses.missing_vehicle"),
                tip     = L("bonuses.missing_vehicle_tip"),
                amount  = -missingPenalty,
            })
            bonusTotal = bonusTotal - missingPenalty
            baseXp     = math.floor(baseXp * 0.7)
            rating     = math.min(3, math.max(2, rating - 1))
        end

        -- Time-based bonus
        if rating == 5 then
            local bonus = math.floor(perPlayerPay * (Config.bonuses.perfectTime / 100))
            table.insert(bonusList, {
                message = L("bonuses.perfect_time"),
                tip     = L("bonuses.perfect_time_tip"),
                amount  = bonus,
            })
            bonusTotal = bonusTotal + bonus
            baseXp     = math.floor(baseXp * 1.1)
        elseif rating >= 4 then
            local bonus = math.floor(perPlayerPay * (Config.bonuses.goodTime / 100))
            table.insert(bonusList, {
                message = L("bonuses.good_time"),
                tip     = L("bonuses.good_time_tip"),
                amount  = bonus,
            })
            bonusTotal = bonusTotal + bonus
            baseXp     = math.floor(baseXp * 1.05)
        end

        -- Teamwork bonus
        if Config.bonuses.teamWorkBonuses and Config.bonuses.teamWorkBonuses.enabled then
            local teamBonusPct = Config.bonuses.teamWorkBonuses.memberCounts[playerCount]
            if teamBonusPct and teamBonusPct > 0 then
                local bonus = math.floor(perPlayerPay * (teamBonusPct / 100))
                table.insert(bonusList, {
                    message = L("bonuses.team_size_bonus"),
                    tip     = L("bonuses.team_size_bonus_tip"),
                    amount  = bonus,
                })
                bonusTotal = bonusTotal + bonus
                baseXp     = math.floor(baseXp * (1 + 0.05 * playerCount))
            end
        end

        -- Find the top washer (most surface cleaned)
        local topWasher = playerCount > 1 and WashManager:GetTopPlayer(contract.id) or nil
        Debug("Got top player", topWasher)

        local jobSizeCategory     = GetJobSizeCategory(estimated.totalMs)
        local supervisorMessage   = GenerateSupervisorMessage(rating, vehicleStatus, jobSizeCategory)

        -- Pay each player and build their reward summary
        for _, serverId in ipairs(onlineServerIds) do
            local playerBonuses = table.clone(bonusList)
            local totalPay      = perPlayerPay + bonusTotal

            -- Top washer bonus
            if Config.bonuses.topWasher > 0 and topWasher == serverId then
                local bonus = math.floor(perPlayerPay * (Config.bonuses.topWasher / 100))
                table.insert(playerBonuses, {
                    message = L("bonuses.top_washer"),
                    tip     = L("bonuses.top_washer_tip"),
                    amount  = bonus,
                })
                totalPay = totalPay + bonus
                baseXp   = math.floor(baseXp * 1.1)
            end

            -- Level experience income bonus (highest applicable)
            local maxLevelBonus = 0
            local playerLevel   = nil
            for _, upgrade in pairs(Config.levelUpgrades) do
                if upgrade.bonusPercentage and upgrade.bonusPercentage > 0 then
                    if not playerLevel then
                        local stats = exports.kq_jobcontracts:GetPlayerJobStats(serverId, "powerwashing")
                        playerLevel = stats and stats.level or 1
                    end
                    if playerLevel >= upgrade.level and upgrade.bonusPercentage > maxLevelBonus then
                        maxLevelBonus = upgrade.bonusPercentage
                    end
                end
            end
            if maxLevelBonus > 0 then
                local bonus = math.floor(perPlayerPay * (maxLevelBonus / 100))
                table.insert(playerBonuses, {
                    message = L("bonuses.experience"),
                    tip     = L("bonuses.experience_tip"),
                    amount  = bonus,
                })
                totalPay = totalPay + bonus
            end

            -- Pay the player
            exports.kq_link:AddPlayerMoney(serverId, totalPay)

            rewardData[serverId] = {
                data           = playerBonuses,
                stars          = rating,
                totalAmount    = totalPay,
                notes          = supervisorMessage,
                rewardPerPlayer = not Config.splitProfitsBetweenTeam,
                xp             = math.floor(baseXp * (Config.xpGainMultiplier or 1.0)),
            }

            if Dummy and Dummy.OnContractCompleted then
                Citizen.CreateThread(function()
                    Dummy.OnContractCompleted(serverId, rewardData[serverId])
                end)
            end
        end

        return rewardData
    end

    -- ── onEnd ────────────────────────────────────────────────────────────────
    local function onContractEnd(contract, reason, onlineServerIds)
        if not contract then
            Debug("Contract ended, but missing info")
            return
        end
        Debug("contract ended", contract.id)

        -- Handle vehicle deletion or release
        local veh = contract.data and contract.data.vehicleEntity
        if veh and DoesEntityExist(veh) then
            local vehPos = GetEntityCoords(veh)
            if IsWithinDistance(Config.headquarters.coords, vehPos, 50.0) then
                if Dummy and Dummy.BeforeVehicleDelete then
                    Citizen.CreateThread(function()
                        Dummy.BeforeVehicleDelete(veh, onlineServerIds)
                    end)
                end
                Citizen.SetTimeout(1600, function() DeleteEntity(veh) end)
                Debug("Deleted job vehicle for contract: " .. contract.id)
            else
                SetEntityOrphanMode(veh, 0)
                Debug("Released job vehicle for contract: " .. contract.id)
            end
        end

        WashManager:CleanupContract(contract.id)

        -- Free the config index slot
        contractToConfigIndex[contract.id] = nil
        local cfgIndex = contractToConfigIndex[contract.id]
        if cfgIndex then
            activeConfigIndices[cfgIndex] = nil
            contractToConfigIndex[contract.id] = nil
            Debug(string.format("Contract '%s' ended, config index %d returned to pool",
                contract.name or contract.id, cfgIndex))
        end

        -- Remove power washer from all online players
        for _, serverId in pairs(onlineServerIds) do
            if exports.kq_link:DoesPlayerHaveWeapon(serverId, Config.powerWasherWeapon) then
                exports.kq_link:RemovePlayerWeapon(serverId, Config.powerWasherWeapon, 1)
            end
        end
    end

    -- ── onLeave ──────────────────────────────────────────────────────────────
    local function onPlayerLeave(contract, serverId, identifier)
        ApplyCancellationBan(identifier, serverId)

        if exports.kq_link:DoesPlayerHaveWeapon(serverId, Config.powerWasherWeapon) then
            exports.kq_link:RemovePlayerWeapon(serverId, Config.powerWasherWeapon, 1)
        end
    end

    -- Build and create the contract
    local contractDef = {
        name           = contractCfg.name,
        job            = "powerwashing",
        description    = contractCfg.description,
        minPlayers     = contractCfg.minPlayers,
        maxPlayers     = contractCfg.maxPlayers,
        reward         = contractCfg.reward,
        rewardPerPlayer = not Config.splitProfitsBetweenTeam,
        tasks          = taskList,
        metadata       = { spotTaskMapping = areaMapping },
        onStart        = onContractStart,
        onComplete     = onContractComplete,
        onEnd          = onContractEnd,
        onLeave        = onPlayerLeave,
    }

    local contract, err = exports.kq_jobcontracts:CreateContract(contractDef)
    if contract then
        activeConfigIndices[configIndex] = true
        contractToConfigIndex[contract.id] = configIndex
    else
        print(string.format("Failed to create contract %s: %s",
            contractCfg.name, err or "unknown error"))
    end

    return contract
end

-- ============================================================
-- ReplenishContract: create one new contract from an available config slot
-- ============================================================
function ReplenishContract()
    local available = GetAvailableConfigIndices()
    if #available == 0 then
        Debug("No available contract configs to replenish from")
        return
    end

    -- Count how many contracts are currently waiting (not started)
    local waitingCount = 0
    for contractId in pairs(contractToConfigIndex) do
        if not contractToConfigIndex[contractId] then
            waitingCount = waitingCount + 1
        end
    end

    if waitingCount >= Config.maxAvailableContracts then
        Debug(string.format("Board full (%d/%d), skipping replenish",
            waitingCount, Config.maxAvailableContracts))
        return
    end

    -- Pick a random available config
    local pick      = available[math.random(#available)]
    local pickName  = Config.contracts[pick] and Config.contracts[pick].name or "?"
    Debug(string.format("Replenishing contract pool with config index %d (%s)", pick, pickName))
    BuildContract(pick)
end

-- ============================================================
-- Net events
-- ============================================================

RegisterNetEvent("kq_powerwashing:server:openJobBoard")
AddEventHandler("kq_powerwashing:server:openJobBoard", function()
    local serverId     = source
    local identifier   = GetPlayerUniqueIdentifier(serverId)

    -- Check cancellation ban
    local banRemaining = GetCancellationBanRemaining(identifier)
    if banRemaining > 0 then
        local minutesLeft = math.ceil(banRemaining / 1000 / 60)
        TriggerClientEvent("kq_link:client:notify", serverId,
            L("cancellation_ban.blocked", { time = minutesLeft }), "error")
        return
    end

    if not DoesPlayerHavePowerwashingJob(serverId) then
        Debug("Player should not have access to open the job board. Invalid job.", serverId)
        return
    end

    if not CanPlayerOpenJobBoard(serverId) then
        Debug("Player should not have access to open the job board. CanPlayerOpenJobBoard returned false.", serverId)
        return
    end

    exports.kq_jobcontracts:OpenBoardForPlayer(
        serverId,
        "powerwashing",
        L("job_board.title"),
        GetLevelUpgradesForBoard(),
        GetContractSettingsConfig(serverId)
    )
end)

-- Client reports that a wash area has been fully cleaned
RegisterNetEvent("kq_powerwashing:server:washAreaCleaned")
AddEventHandler("kq_powerwashing:server:washAreaCleaned", function(washAreaId)
    local serverId = source
    Debug("Player " .. serverId .. " cleaned WashArea: " .. washAreaId)

    local washArea = WashManager.activeWashAreas[washAreaId]
    if not washArea then
        print("ERROR: WashArea not found: " .. washAreaId)
        return
    end

    local taskId = washArea:GetTaskId()
    Debug("Finishing task: " .. taskId)
    exports.kq_jobcontracts:FinishTask(taskId)
end)

-- ============================================================
-- Resource lifecycle
-- ============================================================

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    print("Resource starting...")
    WashManager:Init()
    Wait(2000)

    -- Shuffle all config indices, then create up to maxAvailableContracts
    print("Creating initial contracts...")
    local indices = {}
    for i = 1, #Config.contracts do table.insert(indices, i) end

    -- Fisher-Yates shuffle
    for i = #indices, 2, -1 do
        local j = math.random(i)
        indices[i], indices[j] = indices[j], indices[i]
    end

    local count = math.min(Config.maxAvailableContracts, #indices)
    for i = 1, count do
        Citizen.Wait(20)
        BuildContract(indices[i])
    end

    print(string.format("Created %d/%d initial contracts (max available: %d)",
        count, #Config.contracts, Config.maxAvailableContracts))
    print("Resource started successfully")
end)

-- ============================================================
-- Debug commands
-- ============================================================

if Config.debug then
    RegisterCommand("pwboard", function(source)
        exports.kq_jobcontracts:OpenBoardForPlayer(
            source,
            "powerwashing",
            L("job_board.title"),
            GetLevelUpgradesForBoard(),
            GetContractSettingsConfig(source)
        )
    end, false)
end