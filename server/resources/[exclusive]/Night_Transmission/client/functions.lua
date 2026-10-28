-- Helper Functions
function GetVehicleGearRatio(vehicle, gear)
    local model = GetEntityModel(vehicle)
    local spawnName = string.lower(GetDisplayNameFromVehicleModel(model))
    
    local ratios = Config.DefaultGearRatios["default"]
    
    if Config.CustomGearRatios[spawnName] then
        ratios = Config.CustomGearRatios[spawnName]
    else
        local class = GetVehicleClass(vehicle)
        if class == 8 then
            ratios = Config.DefaultGearRatios["motorcycles"]
        elseif class == 6 or class == 7 then
            ratios = Config.DefaultGearRatios["sports"]
        elseif class == 20 or class == 10 then
            ratios = Config.DefaultGearRatios["trucks"]
        end
    end
    
    if gear == 0 then return ratios.Reverse end
    if gear == 1 then return ratios.First end
    if gear == 2 then return ratios.Second end
    if gear == 3 then return ratios.Third end
    if gear == 4 then return ratios.Fourth end
    if gear == 5 then return ratios.Fifth end
    if gear >= 6 then return ratios.Sixth end
    
    return ratios.First
end

function GetVehicleFinalDrive(vehicle)
    local model = GetEntityModel(vehicle)
    local spawnName = string.lower(GetDisplayNameFromVehicleModel(model))
    
    if Config.CustomGearRatios[spawnName] and Config.CustomGearRatios[spawnName].FinalDrive then
        return Config.CustomGearRatios[spawnName].FinalDrive
    else
        local class = GetVehicleClass(vehicle)
        if class == 8 then return Config.DefaultGearRatios["motorcycles"].FinalDrive end
        if class == 6 or class == 7 then return Config.DefaultGearRatios["sports"].FinalDrive end
        if class == 20 or class == 10 then return Config.DefaultGearRatios["trucks"].FinalDrive end
    end
    
    return Config.DefaultGearRatios["default"].FinalDrive
end

function PlayShiftSound(vehicle)
    -- Som nativo do GTA para quando tira a foto, é parecido com um engate suave
    PlaySoundFromEntity(-1, "SHUTTER_FLASH", vehicle, "CAMERA_FLASH_SOUNDSET", 0, 0)
end

function PlayGrindSound(vehicle)
    if Config.PlayGrindSounds then
        -- Som de arranhão de metal do GTA
        PlaySoundFromEntity(-1, "Crash", vehicle, "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0, 0)
    end
end

function PlayBackfireSound(vehicle)
    if Config.PlayBackfireSounds then
        local exhausts = { "exhaust", "exhaust_2", "exhaust_3", "exhaust_4" }
        for _, bone in ipairs(exhausts) do
            local boneIdx = GetEntityBoneIndexByName(vehicle, bone)
            if boneIdx ~= -1 then
                local coords = GetWorldPositionOfEntityBone(vehicle, boneIdx)
                UseParticleFxAssetNextCall("core")
                StartParticleFxNonLoopedAtCoord("veh_backfire", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.2, false, false, false)
            end
        end
        PlaySoundFromEntity(-1, "CAR_BIKE_WHOOSH", vehicle, "MP_LOBBY_SOUNDS", 0, 0)
    end
end

function IsVehicleIgnored(vehicle)
    if not DoesEntityExist(vehicle) then return true end
    
    local model = GetEntityModel(vehicle)
    local spawnName = string.lower(GetDisplayNameFromVehicleModel(model))
    
    if Config.IgnoredVehicles then
        for _, v in ipairs(Config.IgnoredVehicles) do
            if v == spawnName then return true end
        end
    end
    
    local class = GetVehicleClass(vehicle)
    if class == 13 or class == 14 or class == 15 or class == 16 or class == 21 then 
        return true -- Cycles, Boats, Helis, Planes, Trains
    end
    
    return false
end
