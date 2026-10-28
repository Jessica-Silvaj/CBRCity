-- client/utils.lua: client-side utility functions for kq_powerwashing

-- ============================================================
-- Cooldown helpers
-- ============================================================

COOLDOWN = 0  -- timestamp of last cooldown set

-- Returns true if we are still within a cooldown period (default 1500ms)
function IsCooldown(durationMs)
    return COOLDOWN + (durationMs or 1500) > GetGameTimer()
end

-- Start a cooldown from now
function SetCooldown()
    COOLDOWN = GetGameTimer()
end

-- ============================================================
-- Cached getters
-- ============================================================

-- Return the current network server time (cached 1s)
function GetServerTimer()
    return UseCache("getServerTimer", function()
        return GetNetworkTime()
    end, 1000)
end

-- Return the player's currently selected weapon hash (cached 500ms)
function GetCurrentWeapon()
    return UseCache("GetCurrentWeapon", function()
        return GetSelectedPedWeapon(Data.ped())
    end, 500)
end

-- Return the player ped's current weapon entity (cached 1s)
function GetPlayerPedWeapon()
    return UseCache("GetPlayerPedWeapon", function()
        return GetCurrentPedWeaponEntityIndex(Data.ped())
    end, 1000)
end

-- Return the player ped's world coords (cached 1s)
function GetPlayerCoords()
    return UseCache("GetPlayerCoords", function()
        return GetEntityCoords(PlayerPedId())
    end, 1000)
end

-- Return all players within `radius` metres of the local player as an array of server IDs
function GetPlayersInRange(radius)
    local myPos  = GetEntityCoords(PlayerPedId())
    local result = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        local pos  = GetEntityCoords(GetPlayerPed(playerId))
        local dist = #(myPos - pos)
        if dist <= radius then
            table.insert(result, GetPlayerServerId(playerId))
        end
    end
    return result
end

-- Return the nearest vehicle and its distance, nil if none exists (cached 1s)
function GetNearestVehicle(maxDist)
    local veh, dist = UseCache("GetNearestVehicle" .. maxDist, function()
        local myPos   = GetEntityCoords(PlayerPedId())
        local nearest = nil
        local minDist = maxDist

        for _, v in pairs(GetGamePool("CVehicle")) do
            local d = #(myPos - GetEntityCoords(v))
            if d < minDist then
                minDist  = d
                nearest  = v
            end
        end
        return nearest, minDist
    end, 1000)

    if not DoesEntityExist(veh) then return nil, dist end
    return veh, dist
end

-- Return all networked vehicles within `radius` metres of optionally given `origin` (cached 1s)
function GetNetworkedVehiclesInRange(radius, origin)
    local cacheKey = "GetNetworkedVehiclesInRange" .. radius .. json.encode(origin or {})
    return UseCache(cacheKey, function()
        local pos = origin or GetEntityCoords(PlayerPedId())
        local result = {}
        for _, v in pairs(GetGamePool("CVehicle")) do
            if NetworkGetEntityIsNetworked(v) then
                local d = #(pos - GetEntityCoords(v))
                if d < radius then
                    table.insert(result, v)
                end
            end
        end
        return result
    end, 1000)
end

-- Return the closest vehicle with a given model name and its distance (cached 1s)
function GetClosestVehicleWithModel(modelName, maxDist)
    local cacheKey = "GetClosestVehicleWithModel" .. modelName .. maxDist
    local veh, dist = UseCache(cacheKey, function()
        local myPos   = GetEntityCoords(PlayerPedId())
        local nearest = nil
        local minDist = maxDist
        local modelHash = GetHashKey(modelName)

        for _, v in pairs(GetGamePool("CVehicle")) do
            if GetEntityModel(v) == modelHash then
                local d = #(myPos - GetEntityCoords(v))
                if d < minDist then
                    minDist = d
                    nearest = v
                end
            end
        end
        return nearest, minDist
    end, 1000)

    if not DoesEntityExist(veh) then return nil, dist end
    return veh, dist
end

-- ============================================================
-- Entity helpers
-- ============================================================

-- Count how many extras (1–14) exist on a vehicle
function GetVehicleExtrasCount(veh)
    local count = 0
    for i = 1, 14 do
        if DoesExtraExist(veh, i) then
            count = count + 1
        end
    end
    return count
end

-- Fade an entity in from alpha 50 → 255 over `durationMs` (default 500ms)
function FadeInEntity(entity, durationMs)
    local stepMs = math.ceil((durationMs or 500) / 5)
    SetEntityAlpha(entity, 50)   Citizen.Wait(stepMs)
    SetEntityAlpha(entity, 101)  Citizen.Wait(stepMs)
    SetEntityAlpha(entity, 152)  Citizen.Wait(stepMs)
    SetEntityAlpha(entity, 203)  Citizen.Wait(stepMs)
    ResetEntityAlpha(entity)     Citizen.Wait(stepMs)
end

-- Fade an entity out from alpha 203 → 0 over `durationMs` (default 500ms)
function FadeOutEntity(entity, durationMs)
    local stepMs = math.ceil((durationMs or 500) / 5)
    SetEntityAlpha(entity, 203)  Citizen.Wait(stepMs)
    SetEntityAlpha(entity, 152)  Citizen.Wait(stepMs)
    SetEntityAlpha(entity, 101)  Citizen.Wait(stepMs)
    SetEntityAlpha(entity, 50)   Citizen.Wait(stepMs)
    SetEntityAlpha(entity, 0)    Citizen.Wait(stepMs)
end

-- Draw a wireframe bounding box around an entity with RGBA colour
function DrawEntityBox(entity, r, g, b, a)
    r = r or 255; g = g or 0; b = b or 0; a = a or 255

    local model  = GetEntityModel(entity)
    local minBB, maxBB = GetModelDimensions(model)

    -- Eight bounding-box corners in local space → world space
    local corners = {
        { minBB.x, minBB.y, minBB.z }, { maxBB.x, minBB.y, minBB.z },
        { maxBB.x, maxBB.y, minBB.z }, { minBB.x, maxBB.y, minBB.z },
        { minBB.x, minBB.y, maxBB.z }, { maxBB.x, minBB.y, maxBB.z },
        { maxBB.x, maxBB.y, maxBB.z }, { minBB.x, maxBB.y, maxBB.z },
    }
    local world = {}
    for i, c in ipairs(corners) do
        world[i] = GetOffsetFromEntityInWorldCoords(entity, c[1], c[2], c[3])
    end

    -- 12 edges of the box
    local edges = {
        {1,2},{2,3},{3,4},{4,1},  -- bottom face
        {5,6},{6,7},{7,8},{8,5},  -- top face
        {1,5},{2,6},{3,7},{4,8},  -- vertical edges
    }
    for _, e in ipairs(edges) do
        local a1, a2 = world[e[1]], world[e[2]]
        DrawLine(a1.x, a1.y, a1.z, a2.x, a2.y, a2.z, r, g, b, a)
    end
end

-- Return the world-space centre of an entity's bounding box
function GetEntityCenter(entity)
    local model = GetEntityModel(entity)
    local minBB, maxBB = GetModelDimensions(model)
    return GetOffsetFromEntityInWorldCoords(entity,
        (minBB.x + maxBB.x) / 2,
        (minBB.y + maxBB.y) / 2,
        (minBB.z + maxBB.z) / 2
    )
end

-- Request a named particle effect dictionary and wait until loaded
function RequireParticleDict(dictName)
    if not HasNamedPtfxAssetLoaded(dictName) then
        RequestNamedPtfxAsset(dictName)
        while not HasNamedPtfxAssetLoaded(dictName) do
            Citizen.Wait(1)
        end
    end
end

-- Scale an entity uniformly by `scale` factor, adjusting its matrix
function SetEntityScale(entity, scale)
    local right, forward, up, pos = GetEntityMatrix(entity)
    local minBB = GetModelDimensions(GetEntityModel(entity))
    local baseZ  = pos + up * minBB.z
    right   = right   * scale
    forward = forward * scale
    up      = up      * scale
    local newPos = baseZ - up * (minBB.z * scale)
    SetEntityMatrix(entity, right, forward, up, newPos)
end

-- Walk the local player ped straight to `coords`, finishing after `timeoutMs` or on arrival
function SyncWalkToCoords(coords, timeoutMs, _unused)
    local ped     = PlayerPedId()
    local dist    = #(GetEntityCoords(ped) - coords)
    local timeout = GetGameTimer() + timeoutMs

    TaskGoStraightToCoord(ped, coords, 1.0, timeoutMs, _unused, 0.45)

    while dist > 0.4 and GetGameTimer() < timeout do
        dist = #(GetEntityCoords(ped) - coords)
        Citizen.Wait(50)
    end
end

-- Turn the local player ped to face `coords` if not already aligned (within 15°)
function FaceCoordinates(coords)
    local ped     = PlayerPedId()
    local myPos   = GetEntityCoords(ped)
    local heading = GetHeadingFromVector_2d(coords.x - myPos.x, coords.y - myPos.y)
    local myHeading = GetEntityHeading(ped)

    if myHeading > heading + 15 or myHeading < heading - 15 then
        TaskTurnPedToFaceCoord(ped, coords, 1000)
        Citizen.Wait(1300)
    end
end

-- Unequip hand weapons (switch to unarmed)
function RemoveHandWeapons()
    SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)  -- WEAPON_UNARMED hash
end

-- Request a model by name or hash; returns true on success, false on timeout
function DoRequestModel(modelNameOrHash)
    local hash = (type(modelNameOrHash) == "number") and modelNameOrHash
                 or GetHashKey(modelNameOrHash)
    RequestModel(hash)

    local timeout = 2000
    while not HasModelLoaded(hash) and timeout > 0 do
        Citizen.Wait(50)
        RequestModel(hash)
        timeout = timeout - 20
    end

    if timeout <= 0 then
        print("^1Requesting of a model timed out \"" .. hash .. ":" .. tostring(modelNameOrHash) .. "\"")
        return false
    end
    return true
end

-- Smoothly teleport an entity to `coords` (fades screen out/in)
function SmoothTeleport(entity, coords, heading)
    Citizen.CreateThread(function()
        -- If entity is a ped in a vehicle, teleport the vehicle
        if IsEntityAPed(entity) and IsPedInAnyVehicle(entity) then
            entity = GetVehiclePedIsUsing(entity)
        end

        DoScreenFadeOut(500)
        Citizen.Wait(600)
        FreezeEntityPosition(entity, true)
        SetEntityCoordsNoOffset(entity, coords, true, false, false)
        if heading ~= nil then
            SetEntityHeading(entity, heading)
        end
        Citizen.Wait(600)
        FreezeEntityPosition(entity, false)
        DoScreenFadeIn(500)

        -- For vehicles: ground them and correct if placement failed
        if IsEntityAVehicle(entity) then
            SetVehicleOnGroundProperly(entity)
            local placed = GetEntityCoords(entity)
            if #(placed - coords) >= 2 then
                SetEntityCoordsNoOffset(entity, coords, true, false, false)
            end
        end
    end)
end

-- Delete the nearest object of a given hash within `radius` (default 2m), repeatedly
function DeleteNearestOfType(coords, modelHash, radius)
    radius = radius or 2.0
    local obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, radius, modelHash, 0, 0, 0)
    while obj ~= 0 do
        SetEntityAsMissionEntity(obj, 1, 1)
        DeleteEntity(obj)
        Citizen.Wait(10)
        obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, radius, modelHash, 0, 0, 0)
    end
end

-- Delete all CObject pool objects within `radius` metres of `coords`
function ClearAreaOfObjects(coords, radius)
    for _, obj in pairs(GetGamePool("CObject")) do
        local dist = #(GetEntityCoords(obj) - coords)
        if dist <= radius then
            SetEntityAsMissionEntity(obj, 1, 1)
            DeleteEntity(obj)
        end
    end
end

-- Get the local-space offset and rotation delta between an entity's origin and a named/indexed bone
function GetAttachmentOffset(entity, boneNameOrIndex, attachedEntity)
    if not DoesEntityExist(entity) or not DoesEntityExist(attachedEntity) then
        return nil
    end

    local boneIndex = boneNameOrIndex
    if type(boneNameOrIndex) == "string" then
        boneIndex = GetEntityBoneIndexByName(entity, boneNameOrIndex)
        if boneIndex == -1 then return nil end
    end

    local entPos  = GetEntityCoords(attachedEntity)
    local entRot  = GetEntityRotation(attachedEntity)
    local bonePos = GetWorldPositionOfEntityBone(entity, boneIndex)
    local boneRot = GetEntityBoneRotation(entity, boneIndex)

    local posOffset = vec3(
        GetOffsetFromEntityGivenWorldCoords(entity, entPos.x,  entPos.y,  entPos.z).x -
        GetOffsetFromEntityGivenWorldCoords(entity, bonePos.x, bonePos.y, bonePos.z).x,
        GetOffsetFromEntityGivenWorldCoords(entity, entPos.x,  entPos.y,  entPos.z).y -
        GetOffsetFromEntityGivenWorldCoords(entity, bonePos.x, bonePos.y, bonePos.z).y,
        GetOffsetFromEntityGivenWorldCoords(entity, entPos.x,  entPos.y,  entPos.z).z -
        GetOffsetFromEntityGivenWorldCoords(entity, bonePos.x, bonePos.y, bonePos.z).z
    )
    local rotOffset = vec3(
        entRot.x - boneRot.x,
        entRot.y - boneRot.y,
        entRot.z - boneRot.z
    )
    return { position = posOffset, rotation = rotOffset }
end

-- Register a key binding with press/hold/release callbacks
-- onPress: called when key is pressed; onHold(elapsedMs): called every frame while held;
-- onRelease(elapsedMs): called when key is released
function RegisterKeyWithCallbacks(key, label, onPress, onHold, onRelease)
    local resourceName = GetCurrentResourceName()
    local cmdName      = resourceName .. "_key_" .. Slugify(key)
    local pressedAt    = nil
    local holdThread   = nil

    RegisterKeyMapping("+" .. cmdName, label or ("Press " .. key), "keyboard", key)

    RegisterCommand("+" .. cmdName, function()
        if onPress then onPress() end
        pressedAt = GetGameTimer()

        if onHold and not holdThread then
            holdThread = CreateThread(function()
                while pressedAt do
                    onHold(GetGameTimer() - pressedAt)
                    Wait(0)
                end
            end)
        end
    end, false)

    RegisterCommand("-" .. cmdName, function()
        if pressedAt then
            local elapsed = GetGameTimer() - pressedAt
            if onRelease then onRelease(elapsed) end
            pressedAt  = nil
            holdThread = nil
        end
    end, false)
end

-- ============================================================
-- Internal DRM-related stubs (Prot table, used by other files)
-- Stripped of anti-piracy logic — kept as no-ops for compatibility
-- ============================================================
Prot = {}