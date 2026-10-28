-- Core cleaning logic: raycasts, UV mapping, delta accumulation, and server sync

local WashCleaner = {
    activeWashAreas    = {},    -- wash areas currently loaded for this client
    isCleaning         = false, -- true while the player is spraying
    serverDelta        = {},    -- accumulated cleaning data to send to server
    localDelta         = {},    -- cleaning data pending local renderer update
    lastServerSyncTime = 0,
    lastLocalSyncTime  = 0,
    particleFx         = nil,   -- handle for the looped water-jet particle effect
}



-- ============================================================
-- UV / plane intersection math
-- ============================================================

-- ProjectPointOntoQuad: given a world point and 4 quad corners, returns (u, v) coords (0–1)
-- or nil if the point does not lie on the quad plane within tolerance.
local function ProjectPointOntoQuad(worldPoint, corners)
    local p0 = vector3(corners[1].x, corners[1].y, corners[1].z)
    local p1 = vector3(corners[2].x, corners[2].y, corners[2].z)
    local p2 = vector3(corners[3].x, corners[3].y, corners[3].z)
    local p3 = vector3(corners[4].x, corners[4].y, corners[4].z)

    local e1 = p1 - p0   -- edge along u
    local e2 = p3 - p0   -- edge along v
    local diag = (p0 - p1) + p2 - p3

    -- Plane normal via cross product of e1 and e2
    local cross = vector3(
        e1.y * e2.z - e1.z * e2.y,
        e1.z * e2.x - e1.x * e2.z,
        e1.x * e2.y - e1.y * e2.x
    )
    local crossLen = math.sqrt(cross.x*cross.x + cross.y*cross.y + cross.z*cross.z)
    if crossLen < 1e-4 then return nil, nil end

    local normal = vector3(cross.x/crossLen, cross.y/crossLen, cross.z/crossLen)

    -- Check point is on the plane
    local relPoint = worldPoint - p0
    local planeDist = relPoint.x*normal.x + relPoint.y*normal.y + relPoint.z*normal.z
    if math.abs(planeDist) > Config.planeDetectionTolerance then return nil, nil end

    -- Project onto quad plane
    local projected = vector3(
        relPoint.x - normal.x * planeDist,
        relPoint.y - normal.y * planeDist,
        relPoint.z - normal.z * planeDist
    )

    -- Normalise e1
    local e1len = math.sqrt(e1.x*e1.x + e1.y*e1.y + e1.z*e1.z)
    if e1len < 1e-4 then return nil, nil end
    local e1n = vector3(e1.x/e1len, e1.y/e1len, e1.z/e1len)

    -- Compute e2-perpendicular via cross(normal, e1n)
    local e2p = vector3(
        normal.y*e1n.z - normal.z*e1n.y,
        normal.z*e1n.x - normal.x*e1n.z,
        normal.x*e1n.y - normal.y*e1n.x
    )

    -- Dot products for the bilinear solve
    local d11 = e1.x*e1n.x + e1.y*e1n.y + e1.z*e1n.z
    local d12 = e1.x*e2p.x + e1.y*e2p.y + e1.z*e2p.z
    local d21 = e2.x*e1n.x + e2.y*e1n.y + e2.z*e1n.z
    local d22 = e2.x*e2p.x + e2.y*e2p.y + e2.z*e2p.z
    local d31 = diag.x*e1n.x + diag.y*e1n.y + diag.z*e1n.z
    local d32 = diag.x*e2p.x + diag.y*e2p.y + diag.z*e2p.z
    local px  = projected.x*e1n.x + projected.y*e1n.y + projected.z*e1n.z
    local py  = projected.x*e2p.x + projected.y*e2p.y + projected.z*e2p.z

    -- Solve bilinear equation for u (coefficients from original bytecode)
    local coeffA = d12*d31 - d11*d32
    local coeffB = (d12*d21 - d11*d22) + (px*d32 - py*d31)
    local coeffC = px*d22 - py*d21

    local u, v

    if math.abs(coeffA) < 1e-4 then
        if math.abs(coeffB) < 1e-4 then return nil, nil end
        u = -coeffC / coeffB
    else
        local disc = coeffB*coeffB - 4*coeffA*coeffC
        if disc < 0 then return nil, nil end
        local sqrtDisc = math.sqrt(disc)
        local u1 = (-coeffB + sqrtDisc) / (2*coeffA)
        local u2 = (-coeffB - sqrtDisc) / (2*coeffA)
        local valid1 = u1 >= -0.01
        local valid2 = u2 >= -0.01

        if valid1 and valid2 then
            -- Pick the root closer to 0.5
            if math.abs(u1 - 0.5) < math.abs(u2 - 0.5) then
                u = u1
            else
                u = u2
            end
        elseif valid1 then
            u = u1
        elseif valid2 then
            u = u2
        else
            return nil, nil
        end
    end

    -- Solve for v using whichever denominator is larger
    local denom1 = d21 + u*d31
    local denom2 = d22 + u*d32

    if math.abs(denom1) > math.abs(denom2) then
        if math.abs(denom1) < 1e-4 then return nil, nil end
        v = (px - u*d11) / denom1
    else
        if math.abs(denom2) < 1e-4 then return nil, nil end
        v = (py - u*d12) / denom2
    end

    -- Bounds check with small tolerance
    if u < -0.01 or u > 1.01 or v < -0.01 or v > 1.01 then
        return nil, nil
    end

    u = math.max(0, math.min(1, u))
    v = math.max(0, math.min(1, v))

    -- Final: confirm the interpolated surface point is close to worldPoint
    local interpX = (1-u)*(1-v)*p0.x + u*(1-v)*p1.x + u*v*p2.x + (1-u)*v*p3.x
    local interpY = (1-u)*(1-v)*p0.y + u*(1-v)*p1.y + u*v*p2.y + (1-u)*v*p3.y
    local interpZ = (1-u)*(1-v)*p0.z + u*(1-v)*p1.z + u*v*p2.z + (1-u)*v*p3.z

    local dx = worldPoint.x - interpX
    local dy = worldPoint.y - interpY
    local dz = worldPoint.z - interpZ
    if math.sqrt(dx*dx + dy*dy + dz*dz) > Config.planeDetectionTolerance then
        return nil, nil
    end

    return u, v
end

-- ============================================================
-- Raycast + hit detection
-- ============================================================

local lastDebugLogTime = 0
local debugLogInterval = 2000
local lastHitPos       = nil   -- cached last raycast hit position

-- Cast a ray from the camera into the scene and return which wash areas it hits.
-- Returns: hitList, hitDist, hitPos  (or nil)
local function RaycastWashArea()
    return UseCache("RaycastWashArea", function()
        local ped       = Data.ped()
        local pedPos    = GetEntityCoords(ped)
        local camPos    = GetGameplayCamCoord()
        local camRot    = GetGameplayCamRot(2)

        -- Convert camera angles to direction vector
        local pitch   = camRot.x * (math.pi / 180.0)
        local yaw     = camRot.z * (math.pi / 180.0)
        local dirX    = -math.sin(yaw)  * math.abs(math.cos(pitch))
        local dirY    =  math.cos(yaw)  * math.abs(math.cos(pitch))
        local dirZ    =  math.sin(pitch)

        local rayEnd  = vector3(camPos.x + dirX*12, camPos.y + dirY*12, camPos.z + dirZ*12)
        local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, rayEnd.x, rayEnd.y, rayEnd.z, -1, ped, 0)
        local _, hit, hitPos, _, hitEntity = GetShapeTestResult(rayHandle)

        if hit ~= 1 then
            lastHitPos = nil
            return nil
        end

        -- Optional: push objects/peds with the water jet
        if Config.misc.allowObjectPushing or Config.misc.allowNpcPushing then
            UseCache("applyPowerWashForce", function()
                if hitEntity and hitEntity > 1 then
                    if Config.misc.allowObjectPushing and DoesEntityHavePhysics(hitEntity) and IsEntityAnObject(hitEntity) then
                        local fwd      = GetEntityForwardVector(PlayerPedId())
                        local force    = 150
                        local pedCoords = GetEntityCoords(PlayerPedId())
                        if IsWithinDistance(pedCoords, hitPos, 2.5) then force = 300 end
                        ApplyForceToEntityCenterOfMass(hitEntity, 1, fwd * force, 0, false, false, true)
                    elseif Config.misc.allowNpcPushing and IsEntityAPed(hitEntity) then
                        SetPedWetnessHeight(hitEntity, 0.5)
                        if NetworkHasControlOfEntity(hitEntity) and not IsPedRagdoll() then
                            if math.random(0, 3) == 1 then
                                SetPedToRagdoll(hitEntity, 1000, 2500, 0, false, true, true)
                                local fwd = GetEntityForwardVector(PlayerPedId())
                                if IsWithinDistance(GetEntityCoords(PlayerPedId()), hitPos, 3.0) then
                                    ApplyForceToEntityCenterOfMass(hitEntity, 1, fwd * 300, 0, false, false, true)
                                end
                            end
                        end
                    end
                end
                return 1
            end, 120)
        end

        lastHitPos = hitPos

        local hitDist = #(hitPos - pedPos)
        local now     = GetGameTimer()

        -- Optional: clean vehicles
        if Config.misc.allowCarCleaning and hitEntity and hitEntity > 0 and IsEntityAVehicle(hitEntity) then
            UseCache("cleanVehicle_" .. hitEntity, function()
                local dirtLevel = GetVehicleDirtLevel(hitEntity)
                if dirtLevel > 0.0 then
                    SetVehicleDirtLevel(hitEntity, math.max(0.0, dirtLevel - 0.1))
                end
                return 1
            end, 100)
        end

        if hitDist > Config.maxWashDistance then
            -- Log when out of range (throttled)
            if now - lastDebugLogTime > debugLogInterval and Config.debug then
                lastDebugLogTime = now
            end
            return nil
        end

        -- Map hit position onto each active wash area using UV projection
        local hits = {}
        for _, area in ipairs(WashCleaner.activeWashAreas) do
            local u, v = ProjectPointOntoQuad(hitPos, area.corners)
            if u and v then
                local pixelX = math.floor(u * area.gridWidth)  + 1
                local pixelY = math.floor(v * area.gridHeight) + 1

                -- Throttled debug log
                if now - lastDebugLogTime > debugLogInterval and Config.debug then
                    Debug(string.format(
                        "[RaycastWashArea] UV: %.3f, %.3f -> Pixel: [%d, %d], Distance: %.2fm",
                        u, v, pixelX, pixelY, hitDist
                    ))
                    lastDebugLogTime = now
                end

                if pixelX >= 1 and pixelX <= area.gridWidth and pixelY >= 1 and pixelY <= area.gridHeight then
                    table.insert(hits, {
                        washAreaId = area.id,
                        pixelX     = pixelX,
                        pixelY     = pixelY,
                        washArea   = area,
                    })
                end
            end
        end

        -- Notify optional Dummy module
        if Dummy and Dummy.OnPowerwasherHit then
            Dummy.OnPowerwasherHit(hitPos, hitEntity)
        end

        if #hits > 0 then
            return hits, hitDist, hitPos
        end
        return nil
    end, 30)
end

-- ============================================================
-- Delta accumulation
-- ============================================================

-- Accumulate a cleaning amount for pixel (x, y) in the given wash area
local function AccumulateLocalDelta(washAreaId, x, y, amount)
    if not WashCleaner.localDelta[washAreaId] then
        WashCleaner.localDelta[washAreaId] = {}
    end
    local key = x .. "_" .. y
    if not WashCleaner.localDelta[washAreaId][key] then
        WashCleaner.localDelta[washAreaId][key] = { x = x, y = y, amount = 0 }
    end
    WashCleaner.localDelta[washAreaId][key].amount = WashCleaner.localDelta[washAreaId][key].amount + amount
end

-- Flush localDelta into the renderer and then into serverDelta, then reset
local function FlushLocalDelta()
    local now = GetGameTimer()
    if now - WashCleaner.lastLocalSyncTime < Config.localSyncInterval then return end

    if next(WashCleaner.localDelta) then
        local applied = WashRenderer.ApplyLocalDelta(WashCleaner.localDelta)

        for areaId, pixels in pairs(applied or {}) do
            if not WashCleaner.serverDelta[areaId] then
                WashCleaner.serverDelta[areaId] = {}
            end
            for key, pixel in pairs(pixels) do
                if not WashCleaner.serverDelta[areaId][key] then
                    WashCleaner.serverDelta[areaId][key] = { x = pixel.x, y = pixel.y, amount = 0 }
                end
                WashCleaner.serverDelta[areaId][key].amount = WashCleaner.serverDelta[areaId][key].amount + pixel.amount
            end
        end

        WashCleaner.localDelta      = {}
        WashCleaner.lastLocalSyncTime = now
    end
end

-- Sync counter used to occasionally extend the sync interval for buffering
local syncCounter = 0

-- Send accumulated serverDelta to the server and reset it
local function SyncCleaningData()
    local now          = GetGameTimer()
    local syncInterval = Config.syncInterval

    -- Every 5th sync, extend the interval by 60% for network buffering
    if syncCounter % 5 == 1 then
        syncInterval = math.floor(syncInterval * 1.6)
    end

    if now - WashCleaner.lastServerSyncTime < syncInterval then return end

    if syncCounter % 5 == 1 then
        Debug("Added interval time for buffer")
    end
    syncCounter = syncCounter + 1

    if not next(WashCleaner.serverDelta) then return end

    if Config.debug then
        local pixelCount, totalAmount = 0, 0
        for _, pixels in pairs(WashCleaner.serverDelta) do
            for _, pixel in pairs(pixels) do
                pixelCount   = pixelCount + 1
                totalAmount  = totalAmount + pixel.amount
            end
        end
        Debug(string.format("[SyncCleaningData] Sending %d pixels to server, total amount: %.2f", pixelCount, totalAmount))
    end

    WashCleaner.lastServerSyncTime = now

    if Config.deltaSyncMethod == "event" then
        TriggerServerEvent("kq_powerwashing:server:washDelta", WashCleaner.serverDelta)
    else
        LocalPlayer.state:set("washDelta", WashCleaner.serverDelta, true)
    end

    WashCleaner.serverDelta = {}
end

-- ============================================================
-- Active area management
-- ============================================================

-- Replace the active wash areas list and clear pending local deltas
local function UpdateActiveWashAreas(newAreas)
    WashCleaner.activeWashAreas = newAreas or {}
    WashCleaner.localDelta      = {}
    if CleanExpiredCache then
        CleanExpiredCache()
    end
end

-- Server event: server pushes a new set of wash areas
RegisterNetEvent("kq_powerwashing:client:washAreasUpdate", function(areas)
    UpdateActiveWashAreas(areas)
end)

-- State bag: server sets wash areas via player state (alternative delivery method)
local myPlayerBag = string.format("player:%s", GetPlayerServerId(PlayerId()))
AddStateBagChangeHandler("kq_powerwashing_washAreas", myPlayerBag, function(_, _, newAreas)
    UpdateActiveWashAreas(newAreas)
end)

-- ============================================================
-- Particle FX management for other players
-- ============================================================

local otherPlayerFx = {}   -- [serverIdNumber] = particleFx handle

-- React to any player's isPowerWashing state change and show/hide their water jet FX
AddStateBagChangeHandler("isPowerWashing", nil, function(bagName, _, isWashing)
    local serverIdNum = tonumber(bagName:match("player:(%d+)"))
    if not serverIdNum then return end

    -- Ignore own state bag
    if serverIdNum == GetPlayerServerId(PlayerId()) then return end

    if isWashing then
        local player = GetPlayerFromServerId(serverIdNum)
        if player == -1 then return end
        local ped = GetPlayerPed(player)
        if not DoesEntityExist(ped) then return end

        local weaponEntity = GetCurrentPedWeaponEntityIndex(ped, 0)
        if weaponEntity and DoesEntityExist(weaponEntity) then
            UseParticleFxAssetNextCall("core")
            otherPlayerFx[serverIdNum] = StartParticleFxLoopedOnEntity(
                "water_cannon_jet", weaponEntity,
                0.73, 0.02, 0.06,
                0.0, 0.0, 270.0,
                0.5, false, false, false
            )
        end
    else
        if otherPlayerFx[serverIdNum] then
            StopParticleFxLooped(otherPlayerFx[serverIdNum], false)
            otherPlayerFx[serverIdNum] = nil
        end
    end
end)

-- ============================================================
-- Dirt-highlight pulse (washer vision)
-- ============================================================

-- Pulse the dirt highlight overlay: fade in rapido, mantener 3s, fade out suave
local function PulseDirtHighlight()
    Renderer.extraLayerLastUse          = GetGameTimer()
    Renderer.washerVisionHintsRemaining = Renderer.washerVisionHintsRemaining - 1

    Citizen.CreateThread(function()
        local maxOpacity  = 250
        local holdMs      = 3000   -- tiempo visible en ms
        local fadeInStep  = 40     -- velocidad de entrada (opacity por tick)
        local fadeOutStep = 8      -- velocidad de salida (opacity por tick)
        local tickMs      = 30

        -- Fade in
        while Renderer.extraLayerOpacity < maxOpacity do
            Renderer.extraLayerOpacity = math.min(maxOpacity, Renderer.extraLayerOpacity + fadeInStep)
            Citizen.Wait(tickMs)
        end

        -- Mantener visible
        Citizen.Wait(holdMs)

        -- Fade out suave
        while Renderer.extraLayerOpacity > 0 do
            Renderer.extraLayerOpacity = math.max(0, Renderer.extraLayerOpacity - fadeOutStep)
            Citizen.Wait(tickMs)
        end
    end)
end

-- ============================================================
-- Input handling thread (dirt highlight + aim control disabling)
-- ============================================================

local washerWeaponHash = GetHashKey(Config.powerWasherWeapon)

Citizen.CreateThread(function()
    while true do
        local waitMs = 2500

        if GetCurrentWeapon() == washerWeaponHash then
            waitMs = 1

            -- Disable default fire/aim controls to replace with cleaning behaviour
            DisableControlAction(0, 24, true)   -- attack
            DisableControlAction(0, 45, true)   -- aim
            DisableControlAction(0, 53, true)   -- melee attack 1
            DisableControlAction(0, 69, true)   -- special ability

            -- While aiming: disable extra camera rotation controls
            if IsControlPressed(0, 25, true) then
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 257, true)
            end

            -- Dirt highlight toggle (Q key by default)
            if Config.dirtHighlight.enabled and IsDisabledControlPressed(0, 45) then
                if Renderer then
                    local cooldown  = Config.dirtHighlight.cooldown or 9000
                    local lastUse   = Renderer.extraLayerLastUse or 0
                    if lastUse + cooldown < GetGameTimer() then
                        Renderer.extraLayerLastUse = GetGameTimer()
                        PulseDirtHighlight()
                    end
                end
            end
        end

        Citizen.Wait(waitMs)
    end
end)

-- ============================================================
-- Main cleaning loop
-- ============================================================

local lastWeaponLogTime = 0

CreateThread(function()
    local waitMs = 0

    while true do
        local currentWeapon = GetCurrentWeapon()
        local now           = GetGameTimer()

        if currentWeapon == washerWeaponHash then
            waitMs = 500

            local isFiring = IsDisabledControlPressed(0, 24)

            if isFiring and not IsPauseMenuActive() then
                -- Skip if powerwasher is disabled outside of a contract
                local blockedByJob = not CONTRACT_ACTIVE and Config.disablePowerwasherOutsideOfJob
                if not blockedByJob then
                    waitMs = 25

                    if not WaterTank:HasWater() then
                        -- Tank is empty: stop cleaning state
                        if WashCleaner.isCleaning then
                            WashCleaner.isCleaning = false
                            LocalPlayer.state:set("isPowerWashing", false, true)
                            if WashCleaner.particleFx then
                                StopParticleFxLooped(WashCleaner.particleFx, false)
                                WashCleaner.particleFx = nil
                            end
                        end
                    else
                        -- Drain tank on each cleaning tick
                        WaterTank:Drain()

                        -- Start cleaning state if not already active
                        if not WashCleaner.isCleaning then
                            WashCleaner.isCleaning = true
                            LocalPlayer.state:set("isPowerWashing", true, true)
                            UseParticleFxAssetNextCall("core")
                            WashCleaner.particleFx = StartNetworkedParticleFxLoopedOnEntity(
                                "water_cannon_jet", GetPlayerPedWeapon(),
                                0.73, 0.02, 0.06,
                                0.0, 0.0, 270.0,
                                0.5, false, false, false
                            )
                        end

                        -- Raycast and clean hit pixels
                        local hits, hitDist, hitPos = RaycastWashArea()
                        if hits and hitPos then
                            -- Splash particle at hit point
                            UseParticleFxAssetNextCall("core")
                            StartParticleFxNonLoopedAtCoord("ent_dst_gen_water_spray",
                                hitPos.x, hitPos.y, hitPos.z,
                                0.0, 0.0, 0.0,
                                0.7, false, false, false
                            )

                            -- Distance falloff: closer = more cleaning power
                            local distT       = (hitDist - Config.minCleanDistance) / (Config.maxCleanDistance - Config.minCleanDistance)
                            local distNorm    = math.max(0, math.min(1, distT))
                            local falloff     = math.pow(1.0 - distNorm, Config.distanceFalloffPower)
                            local baseAmount  = Config.cleaningRate * GetFrameTime() * falloff

                            for _, hit in ipairs(hits) do
                                local area       = hit.washArea
                                local multi      = area.cleaningMultiplier or 1.0

                                if not area.pixelSize then
                                    Debug("[WashCleaner] ERROR: washArea.pixelSize is nil! WashArea data:", json.encode(area))
                                else
                                    -- Radius in pixels of the cleaning circle
                                    local radiusMeters = Config.minCleanRadiusMeters
                                        + (Config.maxCleanRadiusMeters - Config.minCleanRadiusMeters) * distNorm
                                    local radiusAdjusted = radiusMeters * multi
                                    local radiusPx       = math.max(0, math.floor(radiusAdjusted / area.pixelSize))
                                    local radiusPlus1    = radiusPx + 1

                                    -- Paint a circular region of pixels
                                    for dx = -radiusPx, radiusPx do
                                        for dy = -radiusPx, radiusPx do
                                            if dx*dx + dy*dy <= radiusPx*radiusPx then
                                                local dist2 = math.sqrt(dx*dx + dy*dy)
                                                local edge  = 1.0 - (dist2 / radiusPlus1)
                                                local amount = baseAmount * edge * multi
                                                AccumulateLocalDelta(hit.washAreaId, hit.pixelX + dx, hit.pixelY + dy, amount)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                -- Not firing or firing is blocked: stop cleaning state
                if WashCleaner.isCleaning then
                    WashCleaner.isCleaning = false
                    LocalPlayer.state:set("isPowerWashing", false, true)
                    if WashCleaner.particleFx then
                        StopParticleFxLooped(WashCleaner.particleFx, false)
                        WashCleaner.particleFx = nil
                    end
                    Debug("[WashCleaner] Stopped cleaning")
                end
            end

            FlushLocalDelta()
            SyncCleaningData()

        else
            -- Wrong weapon equipped: periodically log in debug mode
            if Config.debug and (now - lastWeaponLogTime) > 2000 then
                local unarmedHash = GetHashKey("WEAPON_UNARMED")
                if currentWeapon ~= unarmedHash then
                    Debug("[WashCleaner] Different weapon equipped: " .. currentWeapon
                        .. " (expected: " .. Config.powerWasherWeapon .. ")")
                end
                lastWeaponLogTime = now
            end

            -- Stop cleaning if we switched away from the washer
            if WashCleaner.isCleaning then
                WashCleaner.isCleaning = false
                LocalPlayer.state:set("isPowerWashing", false, true)
                if WashCleaner.particleFx then
                    StopParticleFxLooped(WashCleaner.particleFx, false)
                    WashCleaner.particleFx = nil
                end
            end
        end

        Citizen.Wait(waitMs)
    end
end)