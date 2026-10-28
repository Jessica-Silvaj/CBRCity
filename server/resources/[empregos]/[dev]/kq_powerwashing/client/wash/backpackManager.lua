-- Manages the physical backpack prop attached to peds holding the power washer

local attachedBackpacks = {}        -- [ped] = { backpack = entityHandle }
local backpackModelName = "kq_powerwasher_bag"
local updateInterval    = 500       -- ms between backpack update ticks
local maxBackpackRange  = 100.0     -- max distance to spawn backpacks for other players

-- Backpack attachment offset and rotation (relative to SKEL_Spine2 bone)
local backpackOffset   = vector3(0.05, -0.17, 0.0)
local backpackRotation = vector3(180.0, 90.0, 0.0)


-- Build a set of peds that should display a backpack:
-- the local player + nearby players within maxBackpackRange
local function GetPedsInRange()
    local result    = {}
    local localPed  = PlayerPedId()
    local localPos  = GetEntityCoords(localPed)

    result[localPed] = true

    for _, playerId in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(playerId)
        if DoesEntityExist(ped) then
            local dist = #(localPos - GetEntityCoords(ped))
            if dist <= maxBackpackRange then
                result[ped] = true
            end
        end
    end

    return result
end

-- Returns true if the ped exists, is on foot, and has the power washer selected
local function IsPedHoldingWasher(ped)
    if not DoesEntityExist(ped) then
        return false
    end
    if IsPedInAnyVehicle(ped, false) then
        return false
    end
    return GetSelectedPedWeapon(ped) == GetHashKey(Config.powerWasherWeapon)
end

-- Spawn and attach the backpack prop to a ped
local function AttachBackpack(ped)
    if attachedBackpacks[ped] then return end

    local modelHash = GetHashKey(backpackModelName)
    if not DoRequestModel(backpackModelName) then return end

    local pos = GetEntityCoords(ped)
    local obj = CreateObject(modelHash, pos.x, pos.y, pos.z, false, false, false)
    if not DoesEntityExist(obj) then return end

    local boneIndex = GetPedBoneIndex(ped, 24818)   -- SKEL_Spine2
    AttachEntityToEntity(
        obj, ped, boneIndex,
        backpackOffset.x, backpackOffset.y, backpackOffset.z,
        backpackRotation.x, backpackRotation.y, backpackRotation.z,
        true, true, false, false, 2, true
    )
    SetModelAsNoLongerNeeded(modelHash)

    attachedBackpacks[ped] = { backpack = obj }

    -- Sync water tank level for the local player's own backpack
    if ped == PlayerPedId() then
        WaterTank.SetBackpackLevel(WaterTank)
    end
end

-- Detach and delete the backpack prop from a ped
local function RemoveBackpack(ped)
    local entry = attachedBackpacks[ped]
    if entry then
        local obj = entry.backpack
        if obj and DoesEntityExist(obj) then
            DetachEntity(obj, false, false)
            DeleteEntity(obj)
        end
    end
    attachedBackpacks[ped] = nil
end

-- Remove backpacks for peds no longer in the valid set
local function CleanupStaleBackpacks(validPeds)
    for ped in pairs(attachedBackpacks) do
        if not (DoesEntityExist(ped) and validPeds[ped]) then
            RemoveBackpack(ped)
        end
    end
end

-- Main loop: every updateInterval ms, attach/remove backpacks based on washer state
Citizen.CreateThread(function()
    while true do
        local inRangePeds = GetPedsInRange()

        for ped in pairs(inRangePeds) do
            if IsPedHoldingWasher(ped) then
                AttachBackpack(ped)
            else
                RemoveBackpack(ped)
            end
        end

        CleanupStaleBackpacks(inRangePeds)

        Citizen.Wait(updateInterval)
    end
end)

-- Show or hide the local player's own backpack (fade animation)
function SetOwnBackpackVisible(visible)
    local ped   = Data.ped()
    local entry = attachedBackpacks[ped]
    if entry and entry.backpack and DoesEntityExist(entry.backpack) then
        if visible then
            FadeInEntity(entry.backpack, 300)
        else
            FadeOutEntity(entry.backpack, 300)
        end
    end
end

-- Set the backpack water tint variation and broadcast it via state bag
function SetOwnBackpackTint(tintIndex)
    local ped   = Data.ped()
    local entry = attachedBackpacks[ped]
    if entry and entry.backpack and DoesEntityExist(entry.backpack) then
        if GetObjectTextureVariation(entry.backpack) == tintIndex then return end
        SetObjectTextureVariation(entry.backpack, tintIndex)
        LocalPlayer.state:set("kq_powerwashing_waterTint", tintIndex, true)
    end
end

-- React to another player's water tint state bag change and update their backpack
AddStateBagChangeHandler("kq_powerwashing_waterTint", nil, function(bagName, _, tintIndex)
    Debug("Statebag change on kq_powerwashing_waterTint detected", bagName, tintIndex)

    local player = GetPlayerFromStateBagName(bagName)
    if player == PlayerId() then return end     -- ignore own state bag

    local ped = GetPlayerPed(player)
    if ped == 0 then return end

    local entry = attachedBackpacks[ped]
    if entry and entry.backpack and DoesEntityExist(entry.backpack) then
        if GetObjectTextureVariation(entry.backpack) ~= tintIndex then
            SetObjectTextureVariation(entry.backpack, tintIndex)
        end
    end
end)

-- Clean up all backpacks when this resource stops
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for ped in pairs(attachedBackpacks) do
        RemoveBackpack(ped)
    end
end)