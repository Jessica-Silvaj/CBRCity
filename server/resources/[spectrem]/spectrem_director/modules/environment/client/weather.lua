-- ============================
-- Weather & Time Controller for Spectrem Director
-- Interfaces with Renewed-Weathersync via GlobalState
-- All changes are server-wide via Renewed-Weathersync
-- ============================

local localTimeAccumulator = nil

WeatherControl = {
    freezeTime = false,
    blackout = false,
    
    -- Local Override System
    localOverride = false,
    localWeather = "CLEAR",
    localHour = 12,
    localMinute = 0,
    localFreezeTime = false,
    localBlackout = false,
    localRainEnabled = false,
    localRainLevel = 0.0,
    localWindSpeed = 0.0,
    localCityLights = false,
    localTimeSpeedMultiplier = 1.0,
}

-- All available weather types (matches Renewed-Weathersync)
WeatherTypes = {
    { label = "Muito ensolarado",  value = "EXTRASUNNY", icon = "sun" },
    { label = "Céu limpo",        value = "CLEAR",      icon = "sun" },
    { label = "Nuvens",       value = "CLOUDS",     icon = "cloud" },
    { label = "Encoberto",     value = "OVERCAST",   icon = "cloud" },
    { label = "Abrindo o tempo",     value = "CLEARING",   icon = "cloud-sun" },
    { label = "Chuva",         value = "RAIN",       icon = "cloud-rain" },
    { label = "Tempestade",      value = "THUNDER",    icon = "cloud-bolt" },
    { label = "Poluição",         value = "SMOG",       icon = "smog" },
    { label = "Neblina",        value = "FOGGY",      icon = "smog" },
    { label = "Neutro",      value = "NEUTRAL",    icon = "cloud-sun" },
    { label = "Neve",         value = "SNOW",       icon = "snowflake" },
    { label = "Neve leve",   value = "SNOWLIGHT",  icon = "snowflake" },
    { label = "Nevasca",     value = "BLIZZARD",   icon = "snowflake" },
    { label = "Natal",         value = "XMAS",       icon = "snowflake" },
}

-- ============================
-- Server weather change (affects all players)
-- Sends to server which sets GlobalState
-- ============================

local function DispatchWeatherAction(action, fallbackEvent, ...)
    local bridge = type(EDIT) == "table" and EDIT.WeatherBridge or nil
    if type(bridge) == "table" and bridge.Enabled == true and type(bridge.Emit) == "function" then
        local ok, handled = pcall(bridge.Emit, action, ...)
        if ok and handled == true then return true end
        if not ok and Config.Debug and Config.Debug.Enabled then
            print(("^1[Spectrem Director] Weather bridge '%s' failed: %s^7"):format(
                tostring(action), tostring(handled)
            ))
        end
    end

    TriggerServerEvent(fallbackEvent, ...)
    return false
end

function SetServerWeather(weatherType)
    DispatchWeatherAction("SetWeather", "spectrem:server:setWeather", weatherType)
end

-- ============================
-- Time control (server-wide)
-- ============================

function SetServerTime(hour, minute)
    DispatchWeatherAction("SetTime", "spectrem:server:setTime", hour, minute or 0)
end

function SetFreezeTime(freeze, weatherType)
    WeatherControl.freezeTime = freeze
    DispatchWeatherAction("FreezeTime", "spectrem:server:freezeTime", freeze, weatherType)
end

-- ============================
-- Blackout
-- ============================

function SetBlackout(enabled)
    WeatherControl.blackout = enabled
    DispatchWeatherAction("SetBlackout", "spectrem:server:setBlackout", enabled)
end

-- ============================
-- Wind control
-- ============================

function SetLocalWind(speed)
    SetWind(speed)
end

-- ============================
-- Local Override Controllers
-- ============================

function SetLocalOverride(enabled)
    WeatherControl.localOverride = enabled == true
    if not WeatherControl.localOverride then
        ClearOverrideWeather()
        SetRainLevel(-1.0)
        SetWindSpeed(-1.0)
        SetArtificialLightsState(false)
    end
end

function SetLocalWeather(weatherType)
    WeatherControl.localWeather = weatherType
end

function SetLocalTime(hour, minute)
    WeatherControl.localHour = hour
    WeatherControl.localMinute = minute or 0
    localTimeAccumulator = hour + (WeatherControl.localMinute / 60.0)
end

function SetLocalTimeSpeed(speed)
    WeatherControl.localTimeSpeedMultiplier = tonumber(speed) or 1.0
end

function SetLocalFreezeTime(freeze)
    WeatherControl.localFreezeTime = freeze == true
end

function SetLocalBlackout(enabled)
    WeatherControl.localBlackout = enabled == true
end

function SetLocalRain(enabled, level)
    WeatherControl.localRainEnabled = enabled == true
    WeatherControl.localRainLevel = tonumber(level) or 0.0
end

function SetLocalWindSpeed(speed)
    WeatherControl.localWindSpeed = tonumber(speed) or 0.0
end

function SetLocalCityLights(enabled)
    WeatherControl.localCityLights = enabled == true
end

-- ============================
-- Get current weather status for NUI
-- ============================

function GetWeatherStatus()
    local serverWeather = GlobalState.weather
    local currentTime = GlobalState.currentTime
    local freezeTime = GlobalState.freezeTime

    return {
        serverWeather = serverWeather and serverWeather.weather or "EXTRASUNNY",
        currentTime = currentTime or { hour = 12, minute = 0 },
        freezeTime = freezeTime or false,
        blackout = GlobalState.blackOut or false,
        weatherTypes = WeatherTypes,
        timeSpeed = WeatherControl.timeSpeed,
        
        -- Local override properties
        localOverride = WeatherControl.localOverride,
        localWeather = WeatherControl.localWeather,
        localHour = WeatherControl.localHour,
        localMinute = WeatherControl.localMinute,
        localFreezeTime = WeatherControl.localFreezeTime,
        localBlackout = WeatherControl.localBlackout,
        localRainEnabled = WeatherControl.localRainEnabled,
        localRainLevel = WeatherControl.localRainLevel,
        localWindSpeed = WeatherControl.localWindSpeed,
        localCityLights = WeatherControl.localCityLights,
        localTimeSpeedMultiplier = WeatherControl.localTimeSpeedMultiplier or 1.0,
    }
end

-- ============================
-- Time Speed
-- ============================

WeatherControl.timeSpeed = {
    active = false,
    speed = 1.0,
}

function SetTimeSpeed(speed)
    DispatchWeatherAction("SetTimeSpeed", "spectrem:server:setTimeSpeed", speed)
end

-- Listen for time speed updates from server
RegisterNetEvent("spectrem:client:timeSpeedUpdate", function(data)
    WeatherControl.timeSpeed = {
        active = data.active,
        speed = data.speed or 1.0,
    }

    -- Push update to NUI if menu is open
    SendNUIMessage({
        source = "synched_scenes_devtool",
        type = "timeSpeedUpdate",
        timeSpeed = WeatherControl.timeSpeed,
    })
end)

-- ============================
-- Local Override Thread Loop
-- Enforces settings on tick to beat server sync resources
-- ============================

local lastLocalOverride = false
CreateThread(function()
    while true do
        if IsCutsceneActive() or IsCutscenePlaying() then
            -- Leave cutscene lighting and time untouched until playback ends.
            Wait(100)
        elseif WeatherControl.timelineControlled then
            -- Timeline World & Time owns the local weather/clock natives while
            -- its controller clip is active. Do not fight its transitions.
            Wait(0)
        elseif WeatherControl.localOverride then
            lastLocalOverride = true
            
            -- Apply weather override
            SetOverrideWeather(WeatherControl.localWeather)
            
            -- Apply rain
            if WeatherControl.localRainEnabled then
                SetRainLevel(WeatherControl.localRainLevel)
            else
                SetRainLevel(0.0)
            end
            
            -- Apply wind
            SetWindSpeed(WeatherControl.localWindSpeed)
            
            -- Apply city lights/blackout
            if WeatherControl.localBlackout then
                SetArtificialLightsState(true)
            elseif WeatherControl.localCityLights then
                SetArtificialLightsState(false)
            else
                SetArtificialLightsState(false)
            end
            
            -- Initialize local time accumulator if needed
            if not localTimeAccumulator then
                localTimeAccumulator = WeatherControl.localHour + (WeatherControl.localMinute / 60.0)
            end

            -- Advance local time if not frozen
            if not WeatherControl.localFreezeTime then
                -- Config.TimeSpeed.BaseRate is in game-minutes per real second.
                -- So game-minutes to add: (BaseRate * localTimeSpeedMultiplier) * frameTime
                local rate = (Config.TimeSpeed and Config.TimeSpeed.BaseRate or 0.5) * (WeatherControl.localTimeSpeedMultiplier or 1.0)
                local deltaMinutes = rate * GetFrameTime()
                local deltaHours = deltaMinutes / 60.0
                
                localTimeAccumulator = localTimeAccumulator + deltaHours
                while localTimeAccumulator >= 24.0 do
                    localTimeAccumulator = localTimeAccumulator - 24.0
                end
                while localTimeAccumulator < 0.0 do
                    localTimeAccumulator = localTimeAccumulator + 24.0
                end
                
                WeatherControl.localHour = math.floor(localTimeAccumulator)
                WeatherControl.localMinute = math.floor((localTimeAccumulator - WeatherControl.localHour) * 60)
            end

            -- Always enforce local override clock time every frame when local override is active
            NetworkOverrideClockTime(WeatherControl.localHour, WeatherControl.localMinute, 0)
            
            Wait(0)
        else
            if lastLocalOverride then
                lastLocalOverride = false
                localTimeAccumulator = nil
                ClearOverrideWeather()
                SetRainLevel(-1.0)
                SetWindSpeed(-1.0)
                SetArtificialLightsState(false)
            end
            Wait(250)
        end
    end
end)
