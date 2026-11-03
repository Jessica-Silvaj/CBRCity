-----------------------------------------------------------------------------------------
--                                                                                     --
--    ███████╗██╗██╗   ██╗███████╗██╗   ██╗ █████╗ ██╗   ██╗██╗  ████████╗             --
--    ██╔════╝██║██║   ██║██╔════╝██║   ██║██╔══██╗██║   ██║██║  ╚══██╔══╝             --
--    █████╗  ██║██║   ██║█████╗  ██║   ██║███████║██║   ██║██║     ██║                --
--    ██╔══╝  ██║╚██╗ ██╔╝██╔══╝  ╚██╗ ██╔╝██╔══██║██║   ██║██║     ██║                --
--    ██║     ██║ ╚████╔╝ ███████╗ ╚████╔╝ ██║  ██║╚██████╔╝███████╗██║                --
--    ╚═╝     ╚═╝  ╚═══╝  ╚══════╝  ╚═══╝  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝                --
--                                                                                     --
-----------------------------------------------------------------------------------------
--  FiveVault                                                                          --
--  [ Website ] : https://fivevault.net                                                --
--  [ Discord ] : discord.gg/fivevault                                                 --
--  [ Notice ]  : Dumped / Fixed / Cleaned by FiveVault                                --
-----------------------------------------------------------------------------------------

-- =================================================================
-- Utility Functions
-- =================================================================

-- Returns the value if it exists, otherwise returns the default value
local function GetOrDefault(value, defaultValue)
    if value == nil then
        return defaultValue
    end
    return value
end

-- Checks if a value is not null
local function IsNotNull(value)
    return value ~= nil
end

-- =================================================================
-- Effect Validation & Management (Particles)
-- =================================================================

-- Validates an effect's configuration
local function ValidateEffect(effect, index)
    local label = effect.label
    if not label then
        label = "Effect #" .. tostring(index)
    end

    local function logMissingField(fieldName)
        print(string.format("[ptfx][ERROR] %s: missing mandatory field: %s", label, fieldName))
    end

    local isValid = true

    if type(effect) ~= "table" then
        print(string.format("[ptfx][ERROR] Effect #%d: effect is not a table (type=%s).", index, type(effect)))
        return false
    end

    -- Dictionary (dict) validation
    if effect.dict == nil or effect.dict == "" then
        logMissingField("dict")
        isValid = false
    end

    -- Particle name validation
    if effect.particle == nil or effect.particle == "" then
        logMissingField("particle")
        isValid = false
    end

    -- Coordinates validation
    if effect.coords == nil then
        logMissingField("coords")
        isValid = false
    else
        if not IsNotNull(effect.coords) then
            print(string.format("[ptfx][ERROR] %s: invalid coords (expected vector3, received %s).", label, type(effect.coords)))
            isValid = false
        end
    end

    -- Scale validation
    if effect.scale ~= nil and type(effect.scale) == "number" then
        if effect.scale <= 0.0 then
            print(string.format("[ptfx][ERROR] %s: scale must be > 0.", label))
            isValid = false
        end
    else
        print(string.format("[ptfx][ERROR] %s: scale is mandatory and must be a number.", label))
        isValid = false
    end

    -- Render distance validation
    if effect.renderDistance ~= nil and type(effect.renderDistance) ~= "number" then
        print(string.format("[ptfx][WARN] %s: renderDistance must be a number; using default.", label))
        effect.renderDistance = nil
    end

    -- Alpha (transparency) validation
    if effect.alpha ~= nil and type(effect.alpha) ~= "number" then
        print(string.format("[ptfx][WARN] %s: alpha must be a number; ignoring alpha for this effect.", label))
        effect.alpha = nil
    end

    -- Colour validation
    if effect.colour ~= nil then
        if type(effect.colour) == "table" and effect.colour[1] ~= nil and effect.colour[2] ~= nil and effect.colour[3] ~= nil then
            -- Colour is valid
        else
            print(string.format("[ptfx][WARN] %s: colour must be {r,g,b}; ignoring colour for this effect.", label))
            effect.colour = nil
        end
    end

    -- Interval validation
    if effect.interval ~= nil and type(effect.interval) ~= "number" then
        print(string.format("[ptfx][WARN] %s: interval must be a number (ms); disabling restart for this effect.", label))
        effect.interval = 0
    end

    return isValid
end

-- Loads particle dictionaries into memory
local function LoadDictionaries(effects)
    local dictsToLoad = {}
    
    -- Retrieve unique dictionaries
    for _, effect in ipairs(effects) do
        if effect.dict and not dictsToLoad[effect.dict] then
            dictsToLoad[effect.dict] = true
        end
    end

    -- Request dictionaries to load
    for dict, _ in pairs(dictsToLoad) do
        RequestNamedPtfxAsset(dict)
    end

    -- Wait for all dictionaries to be loaded
    local allLoaded = false
    while not allLoaded do
        allLoaded = true
        for dict, _ in pairs(dictsToLoad) do
            if not HasNamedPtfxAssetLoaded(dict) then
                allLoaded = false
                break
            end
        end
        Wait(0)
    end
end

-- Starts the particle effect
local function StartEffect(effect)
    UseParticleFxAssetNextCall(effect.dict)
    
    local handle = StartParticleFxLoopedAtCoord(
        effect.particle, 
        effect.coords.x, 
        effect.coords.y, 
        effect.coords.z, 
        0.0, 
        0.0, 
        0.0, 
        effect.scale, 
        false, 
        false, 
        false, 
        false
    )
    
    if effect.alpha ~= nil then
        SetParticleFxLoopedAlpha(handle, effect.alpha)
    end
    
    if effect.colour ~= nil then
        SetParticleFxLoopedColour(handle, effect.colour[1], effect.colour[2], effect.colour[3], false)
    end
    
    return handle
end

-- Stops the particle effect
local function StopEffect(state)
    if state.handle then
        StopParticleFxLooped(state.handle, false)
        state.handle = nil
    end
end

-- =================================================================
-- Main Loop
-- =================================================================

CreateThread(function()
    -- Basic configuration check
    if not Config or not Config.Effects then
        print("[ptfx][ERROR] Config or Config.Effects doesn't exist. Check if config.lua is loaded as shared_script.")
        return
    end

    if type(Config.Effects) ~= "table" or #Config.Effects == 0 then
        print("[ptfx][ERROR] Config.Effects is empty or invalid.")
        return
    end

    if not Config.Defaults then
        Config.Defaults = {}
    end

    -- Initialize default values
    Config.Defaults.renderDistance = GetOrDefault(Config.Defaults.renderDistance, 50.0)
    Config.Defaults.interval = GetOrDefault(Config.Defaults.interval, 0)

    local validEffects = {}
    
    -- Prepare and validate effects
    for i, effect in ipairs(Config.Effects) do
        local label = effect.label
        
        if type(effect) == "table" and not label then
            label = "Effect #" .. tostring(i)
        end

        if type(effect) == "table" then
            effect.renderDistance = GetOrDefault(effect.renderDistance, Config.Defaults.renderDistance)
            
            if effect.alpha == nil then
                effect.alpha = Config.Defaults.alpha
            end
            
            if effect.colour == nil then
                effect.colour = Config.Defaults.colour
            end
            
            effect.interval = GetOrDefault(effect.interval, Config.Defaults.interval)
            
            if effect.interval < 0 then
                effect.interval = 0
            end
        end

        if ValidateEffect(effect, i) then
            table.insert(validEffects, effect)
        else
            print(string.format("[ptfx][INFO] %s ignored due to invalid configuration.", label))
        end
    end

    -- If there are no valid effects, stop the script
    if #validEffects == 0 then
        print("[ptfx][ERROR] No valid effects found. Nothing will be started.")
        return
    end

    print(string.format("[ptfx][INFO] Starting %d valid effects. (interval=0 = lightweight mode; interval>0 = optional restart)", #validEffects))
    
    -- Load particle dictionaries
    LoadDictionaries(validEffects)

    -- Initialize the state of each particle
    local effectStates = {}
    for i = 1, #validEffects do
        effectStates[i] = {
            handle = nil,
            nextRestartAt = 0
        }
    end

    -- Distance management loop (Optimization)
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local currentTime = GetGameTimer()
        local anyInRange = false

        for i, effect in ipairs(validEffects) do
            local state = effectStates[i]
            local dist = #(playerCoords - effect.coords)

            -- If the player is within render distance
            if dist <= effect.renderDistance then
                anyInRange = true
                
                -- The effect hasn't started yet
                if state.handle == nil then
                    state.handle = StartEffect(effect)
                    
                    if effect.interval > 0 then
                        state.nextRestartAt = currentTime + effect.interval
                    else
                        state.nextRestartAt = 0
                    end
                else
                    -- The effect is running, handle optional restarts
                    if effect.interval > 0 and state.nextRestartAt > 0 then
                        if currentTime >= state.nextRestartAt then
                            StopEffect(state)
                            state.handle = StartEffect(effect)
                            state.nextRestartAt = currentTime + effect.interval
                        end
                    end
                end
            else
                -- Out of render range, stop the effect
                if state.handle ~= nil then
                    StopEffect(state)
                end
                state.nextRestartAt = 0
            end
        end

        -- Wait optimization: runs faster if near a particle
        if anyInRange then
            Wait(200)
        else
            Wait(1000)
        end
    end
end)