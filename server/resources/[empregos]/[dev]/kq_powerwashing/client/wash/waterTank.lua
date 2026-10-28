-- Manages the player's water tank level, drain logic, and refill interactions

local backpackModelName = "kq_powerwasher_bag"

-- WaterTank object: holds state and all water-related methods
WaterTank = {
    currentWater      = 100,    -- current water level (0–100)
    notifiedEmpty     = false,  -- true once the "tank empty" notification has fired
    refillInteraction = nil,    -- active kq_link interaction handle
    trackedVehicle    = nil,    -- entity handle of the nearby job vehicle
    trackedVehicleKey = nil,    -- config key of that vehicle
}


-- Reset water level to full
function WaterTank:Init()
    self.currentWater   = 100
    self.notifiedEmpty  = false
end

-- Drain water by drainRate each second (approx), applying upgrade multiplier
-- Does nothing if drainRate <= 0 or not enough time has passed (~990ms)
function WaterTank:Drain()
    if Config.waterTank.drainRate <= 0 then return end

    local nextDrainTime = (self.lastDrain or 0) + 990
    if nextDrainTime > GetGameTimer() then return end

    self.lastDrain = GetGameTimer()

    -- Cache a random drain multiplier for 35s to avoid per-tick randomness
    local randomMulti = UseCache("RandomDrainMulti", function()
        return math.random(95, 105) / 100
    end, 35000)

    local drainAmount    = Config.waterTank.drainRate * randomMulti * self:GetDrainUpgradeMulti()
    self.currentWater    = math.max(0, self.currentWater - drainAmount)
    WaterTank:SetBackpackLevel()

    -- Notify once when tank runs empty
    if self.currentWater <= 0 and not self.notifiedEmpty then
        self.notifiedEmpty = true
        exports.kq_link:Notify(L("water_tank.empty"), "error")
    end
end

-- Returns the drain multiplier granted by the player's current upgrade level (cached 30s)
function WaterTank:GetDrainUpgradeMulti()
    return UseCache("GetDrainUpgradeMulti", function()
        local stats       = exports.kq_jobcontracts:GetPlayerJobStats("powerwashing")
        local playerLevel = stats.level or 1
        local bestMulti   = 1

        -- Find the best waterUsageMulti upgrade the player qualifies for
        for _, upgrade in pairs(Config.levelUpgrades or {}) do
            if upgrade.waterUsageMulti and bestMulti > upgrade.waterUsageMulti then
                if playerLevel >= upgrade.level then
                    bestMulti = upgrade.waterUsageMulti
                end
            end
        end

        Debug("GetDrainUpgradeMulti", bestMulti)
        return bestMulti
    end, 30000)
end

-- Refill water to full and update the backpack visual
function WaterTank:Refill()
    self.currentWater  = 100
    self.notifiedEmpty = false
    WaterTank:SetBackpackLevel()
end

-- Returns the effective water level:
-- 0 if the powerwasher is disabled outside of a job and no contract is active
function WaterTank:GetLevel()
    if not CONTRACT_ACTIVE and Config.disablePowerwasherOutsideOfJob then
        return 0
    end
    return self.currentWater
end

-- Sync the backpack prop's texture tint to represent the current water level
-- Tint index 0 = full, 8 = empty
function WaterTank:SetBackpackLevel()
    local level = WaterTank:GetLevel()
    local tint

    if level <= 0 then
        tint = 8
    else
        tint = math.min(7, math.floor((100 - level) / 12.5))
    end

    SetOwnBackpackTint(tint)
end

-- Returns true if the tank has any water remaining
function WaterTank:HasWater()
    return self.currentWater > 0
end

-- Initialise on load
WaterTank:Init()

-- Find the closest job vehicle (from Config.jobVehicles) within `searchRadius` metres
local function FindClosestJobVehicle(searchRadius)
    local playerPos  = GetEntityCoords(PlayerPedId())
    local bestVehicle, bestDist, bestKey = nil, searchRadius, nil

    for vehicleKey, vehicleCfg in pairs(Config.jobVehicles) do
        local vehicle = GetClosestVehicleWithModel(vehicleCfg.model, searchRadius)
        if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
            local dist = #(playerPos - GetEntityCoords(vehicle))
            if dist < bestDist then
                bestVehicle = vehicle
                bestDist    = dist
                bestKey     = vehicleKey
            end
        end
    end

    return bestVehicle, bestKey
end

-- Main loop: scan for a nearby job vehicle every 3 s and create/remove the refill interaction
CreateThread(function()
    while true do
        local scanRadius = 20
        local vehicle, vehicleKey = FindClosestJobVehicle(scanRadius)

        if vehicle and vehicleKey then
            -- Same vehicle still tracked and interaction already exists — nothing to do
            if WaterTank.trackedVehicle == vehicle and WaterTank.refillInteraction then
                -- skip recreating
            else
                -- Remove stale interaction if the vehicle changed
                if WaterTank.refillInteraction then
                    WaterTank.refillInteraction.Delete()
                    WaterTank.refillInteraction = nil
                end

                -- Resolve config offsets with fallbacks
                local cfg              = Config.jobVehicles[vehicleKey]
                local tankOffset       = (cfg and cfg.waterTankOffset)       or vec3(0.0, -2.35, 0.5)
                local playerOffset     = (cfg and cfg.playerOffset)
                    and (tankOffset + cfg.playerOffset)
                    or  (tankOffset + vec3(0, -0.95, 0))
                local bedDoorIndex     = (cfg and cfg.bedDoorIndex)          or 5
                local backpackRotOff   = (cfg and cfg.backpackRotationOffset) or 205

                WaterTank.trackedVehicle    = vehicle
                WaterTank.trackedVehicleKey = vehicleKey

                -- Refill action: plays animation, swaps backpack prop, fills tank
                local function OnRefill()
                    local tankWorldPos   = GetOffsetFromEntityInWorldCoords(vehicle, tankOffset)
                    local playerWorldPos = GetOffsetFromEntityInWorldCoords(vehicle, playerOffset)

                    NetworkRequestControlOfEntity(vehicle)
                    TaskPedSlideToCoord(Data.ped(), playerWorldPos, GetEntityHeading(vehicle), 500)
                    Citizen.Wait(600)
                    SetVehicleDoorOpen(vehicle, bedDoorIndex, false, false)
                    Citizen.Wait(300)
                    FaceCoordinates(tankWorldPos)
                    Citizen.Wait(400)
                    local ped1 = Data.ped()
                    RequestAnimDict("swimming@scuba")
                    while not HasAnimDictLoaded("swimming@scuba") do Citizen.Wait(1) end
                    TaskPlayAnim(ped1, "swimming@scuba", "scuba_tank_off", 8.0, -8.0, -1, 1048601, 0, false, false, false)
                    Citizen.Wait(1000)
                    SetOwnBackpackVisible(false)

                    -- Request backpack model for the refill prop
                    local modelHash = GetHashKey(backpackModelName)
                    if not DoRequestModel(backpackModelName) then return end
                    if RESTARTING then return end

                    -- Place the detached backpack prop at the tank
                    local propPos = tankWorldPos + vec3(0, 0, -0.15)
                    local prop    = CreateObject(modelHash, propPos, false, false, false)
                    local propRot = GetEntityRotation(vehicle) + vec3(0, 0, backpackRotOff)
                    SetEntityRotation(prop, propRot)
                    SetObjectTextureVariation(prop, 8)   -- start at empty tint
                    FadeInEntity(prop, 300)

                    -- Filling animation: step tint from 8 → 0 over refillTime seconds
                    local ped2 = Data.ped()
                    RequestAnimDict("anim@amb@business@meth@meth_smash_weight_check@")
                    while not HasAnimDictLoaded("anim@amb@business@meth@meth_smash_weight_check@") do Citizen.Wait(1) end
                    TaskPlayAnim(ped2, "anim@amb@business@meth@meth_smash_weight_check@", "break_weigh_v1_char01", 8.0, -8.0, -1, 1048601, 0, false, false, false)
                    local steps       = 8
                    local stepWaitMs  = math.floor(Config.waterTank.refillTime * 1000 / steps)
                    for tint = steps - 1, 0, -1 do
                        Citizen.Wait(stepWaitMs)
                        SetObjectTextureVariation(prop, tint)
                    end

                    WaterTank:Refill()
                    exports.kq_link:Notify(L("water_tank.refilled"), "success")

                    SetVehicleDoorShut(vehicle, bedDoorIndex, false)
                    ClearPedTasks(Data.ped())
                    FadeOutEntity(prop, 300)
                    DeleteEntity(prop)
                    SetOwnBackpackVisible(true)
                end

                -- Condition: only show interaction when player is close, holding washer, and tank < 90
                local function CanRefill()
                    if IsPlayerUnreachable() then return false end
                    if GetCurrentWeapon() ~= GetHashKey(Config.powerWasherWeapon) then
                        Debug("Not holding powerwasher gun")
                        return false
                    end
                    local tankWorldPos = GetOffsetFromEntityInWorldCoords(vehicle, tankOffset)
                    Debug(function()
                        print(WaterTank.currentWater, IsWithinDistance(tankWorldPos, GetEntityCoords(PlayerPedId()), 3.0))
                    end)
                    return WaterTank.currentWater < 90
                        and IsWithinDistance(tankWorldPos, GetEntityCoords(PlayerPedId()), 3.0)
                end

                WaterTank.refillInteraction = exports.kq_link:AddInteractionEntity(
                    vehicle,
                    tankOffset,
                    L("water_tank.refill_3d"),
                    L("water_tank.refill_target"),
                    38,         -- interaction key
                    OnRefill,
                    CanRefill,
                    {},
                    3.5,        -- interaction radius
                    "fas fa-faucet"
                )
            end
        else
            -- No vehicle nearby — remove any existing interaction
            if WaterTank.refillInteraction then
                WaterTank.refillInteraction.Delete()
                WaterTank.refillInteraction = nil
            end
            if WaterTank.trackedVehicle then
                WaterTank.trackedVehicle    = nil
                WaterTank.trackedVehicleKey = nil
            end
        end

        Citizen.Wait(3000)
    end
end)