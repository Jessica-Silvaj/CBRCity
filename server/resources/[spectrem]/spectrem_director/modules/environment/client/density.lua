-- User settings survive temporary recording/playback population overrides.
DensityControl = {
    enabled = false,
    config = { peds = Config.Density.Peds, vehicle = Config.Density.Vehicle,
        parked = Config.Density.Parked, randomVehicles = Config.Density.RandomVehicles,
        scenario = Config.Density.Scenario },
    locks = {}, thread = nil,
}
local function effectiveOverride()
    local value
    for _, override in pairs(DensityControl.locks) do
        if override == 1 then return 1 end
        value = 0
    end
    return value
end
function GetDensityStatus()
    local value, cfg = effectiveOverride(), {}
    for key, setting in pairs(DensityControl.config) do cfg[key] = value or setting end
    return { enabled = value ~= nil or DensityControl.enabled, config = cfg,
        locked = value ~= nil, reason = value == 1 and "capture" or value == 0 and "advancedRecord" or nil }
end
local function publish()
    SendNUIMessage({ source = "synched_scenes_devtool", type = "densityStatus", status = GetDensityStatus() })
end
local function startThread()
    if DensityControl.thread then return end
    DensityControl.thread = true
    CreateThread(function()
        local ambient, nextScan = {}, 0
        while DensityControl.enabled or next(DensityControl.locks) do
            local value, cfg = effectiveOverride(), DensityControl.config
            SetPedDensityMultiplierThisFrame(value or cfg.peds)
            SetVehicleDensityMultiplierThisFrame(value or cfg.vehicle)
            SetParkedVehicleDensityMultiplierThisFrame(value or cfg.parked)
            SetRandomVehicleDensityMultiplierThisFrame(value or cfg.randomVehicles)
            SetScenarioPedDensityMultiplierThisFrame(value or cfg.scenario, value or cfg.scenario)
            -- Density alone does not hide existing population. Never delete placed
            -- mission entities or hide vehicles occupied by another player.
            if value == 0 then
                local player, now = PlayerPedId(), GetGameTimer()
                local playerVehicle = GetVehiclePedIsIn(player, false)
                if now >= nextScan then
                    ambient, nextScan = {}, now + 500
                    for _, pool in ipairs({ "CVehicle", "CPed" }) do
                        for _, entity in ipairs(GetGamePool(pool)) do
                            local population = GetEntityPopulationType(entity)
                            if entity ~= player and entity ~= playerVehicle and population >= 1 and population <= 5
                                and not (pool == "CPed" and IsPedAPlayer(entity)) then
                                local hasPlayer = false
                                if pool == "CVehicle" then
                                    for seat = -1, GetVehicleMaxNumberOfPassengers(entity) - 1 do
                                        local ped = GetPedInVehicleSeat(entity, seat)
                                        if ped ~= 0 and IsPedAPlayer(ped) then hasPlayer = true break end
                                    end
                                end
                                if not hasPlayer then ambient[entity] = GetEntityModel(entity) end
                            end
                        end
                    end
                end
                for entity, model in pairs(ambient) do
                    if entity ~= playerVehicle and DoesEntityExist(entity) and GetEntityModel(entity) == model then
                        SetEntityLocallyInvisible(entity)
                        SetEntityNoCollisionEntity(entity, player, true)
                        if playerVehicle ~= 0 then SetEntityNoCollisionEntity(entity, playerVehicle, true) end
                    end
                end
            else ambient, nextScan = {}, 0 end
            Wait(0)
        end
        DensityControl.thread = nil
    end)
end
function Density_SetLock(owner, value)
    if type(owner) ~= "string" then return end
    value = value == 1 and 1 or value == 0 and 0 or nil
    if DensityControl.locks[owner] == value then return end
    DensityControl.locks[owner] = value
    if value ~= nil then startThread() end
    publish()
end
function SetDensityEnabled(enabled)
    if effectiveOverride() ~= nil then return false end
    DensityControl.enabled = enabled == true
    if DensityControl.enabled then startThread() end
    return true
end
function UpdateDensityConfig(config)
    if effectiveOverride() ~= nil or type(config) ~= "table" then return false end
    for key in pairs(DensityControl.config) do
        if config[key] ~= nil then
            DensityControl.config[key] = math.max(0.0, math.min(1.0, tonumber(config[key]) or 0.8))
        end
    end
    return true
end
AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    DensityControl.enabled, DensityControl.locks = false, {}
end)
