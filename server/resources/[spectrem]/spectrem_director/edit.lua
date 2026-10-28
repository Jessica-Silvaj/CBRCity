-- ============================
-- Spectrem Director - User Editable Configuration
-- Edit this file to customize behaviors
-- This file will NOT be obfuscated and can be modified
-- ============================

-- ============================
-- User Configuration
-- ============================

-- Custom configuration changes
EDIT = {}

-- Example: Disable certain features
-- EDIT.DisablePoliceChase = false
-- EDIT.DisableCutscenes = false
-- EDIT.DisableDensity = false

-- Example: Enable Debug Mode (see detailed logs in console)
-- Config.Debug.Enabled = true
-- Config.Debug.LogSceneStart = true
-- Config.Debug.LogSceneStop = true
-- Config.Debug.LogAnimationPlay = true
-- Config.Debug.LogNetwork = false

-- Example: Customize access keys
-- EDIT.CustomKeys = {
--     Director = 'F5',
--     Cutscenes = 'F6',
-- }

-- ============================
-- Custom Functions
-- ============================

-- Add your own functions and custom logic here
-- which will run when the resource loads

function EDIT.OnResourceStart()
    -- Code that runs when the resource starts
end

function EDIT.OnResourceStop()
    -- Code that runs when the resource stops
end

-- ============================
-- Custom Events
-- ============================

-- Add custom event listeners here if needed
-- AddEventHandler('eventName', function()
--     -- Your code
-- end)

-- ============================================================================
-- EXTERNAL WEATHER / TIME BRIDGE
-- ============================================================================
-- Keep framework/core imports in a SEPARATE resource. Do not add @core/init.lua
-- or a framework server file to Spectrem Director: some cores replace globals
-- such as RegisterNetEvent inside the importing resource, which can alter the
-- callback signature of every Spectrem event.
--
-- The separate bridge may register the events below using its own framework.
-- Spectrem only emits the selected values from the client, so no framework code
-- has to run inside this resource.
--
-- Permission example for a bridge that assigns group.spectrem_director:
--   add_ace group.spectrem_director spectrem_director.use allow
-- ============================================================================
EDIT.WeatherBridge = {
    Enabled = false,
    Resource = "spectrem_pscore_bridge",
    Events = {
        SetWeather = "spectrem:server:psCoreSetWeather",
        SetTime = "spectrem:server:psCoreSetTime",
        FreezeTime = "spectrem:server:psCoreFreezeTime",
        SetBlackout = "spectrem:server:psCoreSetBlackout",
        SetTimeSpeed = "spectrem:server:psCoreSetTimeSpeed",
    },
}

-- Return true when the action was sent to the external bridge. Override this
-- function if a provider uses an export or a single generic event instead.
function EDIT.WeatherBridge.Emit(action, ...)
    if EDIT.WeatherBridge.Enabled ~= true then return false end
    if type(IsDuplicityVersion) == "function" and IsDuplicityVersion() then
        return false
    end

    local resource = tostring(EDIT.WeatherBridge.Resource or "")
    if resource ~= "" and GetResourceState(resource) ~= "started" then
        return false
    end

    local events = EDIT.WeatherBridge.Events
    local eventName = type(events) == "table" and events[action] or nil
    if type(eventName) ~= "string" or eventName == "" then return false end

    TriggerServerEvent(eventName, ...)
    return true
end

-- ============================================================================
-- CLOTHING / APPEARANCE CONFIGURATION
-- ============================================================================
-- Select your clothing system:
-- "native"              : Built-in Spectrem Director editor (Default)
-- "illenium-appearance" : Optional illenium-appearance / fivem-appearance provider
-- "ped"                 : Custom "ped" resource (using character data and custom exports)
-- "custom"              : Implement your own logic manually inside the functions below
--
-- The protected modules/peds/client/appearance_native.lua module installs a compatibility
-- facade over EDIT.Appearance. Existing custom implementations remain usable:
-- the facade keeps these functions as the external-provider hooks.
-- ============================================================================
EDIT.ClothingSystem = "native"

EDIT.Appearance = {}

-- Checks if the clothing/appearance resource is started and ready
function EDIT.Appearance.IsActive()
    if EDIT.ClothingSystem == "native" then
        return true
    elseif EDIT.ClothingSystem == "illenium-appearance" then
        return GetResourceState('illenium-appearance') == 'started'
    elseif EDIT.ClothingSystem == "ped" then
        return GetResourceState('ped') == 'started'
    elseif EDIT.ClothingSystem == "custom" then
        -- TODO: Implement your custom active check
        return true
    end
    return false
end

-- Sets the appearance configuration on a given ped (NPC or clone)
-- @param ped: The entity ID of the ped
-- @param appearance: The JSON-like appearance table (or nil)
function EDIT.Appearance.SetPedAppearance(ped, appearance)
    if not ped or not DoesEntityExist(ped) or not appearance then return false end
    
    if EDIT.ClothingSystem == "illenium-appearance" then
        exports['illenium-appearance']:setPedAppearance(ped, appearance)
        return true
    elseif EDIT.ClothingSystem == "ped" then
        -- Custom 'ped' resource wrapper for entity overrides
        exports["ped"]:ApplyToPed(appearance, false, ped)
        return true
    elseif EDIT.ClothingSystem == "custom" then
        -- TODO: Implement custom logic
        return false
    end
    return false
end

-- Gets the model name of a ped (e.g. for player ped backup)
-- @param ped: The entity ID of the ped
-- @return string/number: The model name or hash
function EDIT.Appearance.GetPedModel(ped)
    if not ped or not DoesEntityExist(ped) then return nil end
    
    if EDIT.ClothingSystem == "illenium-appearance" then
        return exports['illenium-appearance']:getPedModel(ped)
    else
        -- Fallback to standard GTA native for get model
        return GetEntityModel(ped)
    end
end

-- Gets the detailed appearance table of a ped
-- @param ped: The entity ID of the ped
-- @return table: The appearance structure
function EDIT.Appearance.GetPedAppearance(ped)
    if not ped or not DoesEntityExist(ped) then return nil end
    
    if EDIT.ClothingSystem == "illenium-appearance" then
        return exports['illenium-appearance']:getPedAppearance(ped)
    elseif EDIT.ClothingSystem == "ped" then
        -- For 'ped' resource, retrieve it from the player state if it's the player ped
        if ped == PlayerPedId() then
            if LocalPlayer.state.Character then
                return LocalPlayer.state.Character:GetData("Ped")
            end
        end
        return nil
    elseif EDIT.ClothingSystem == "custom" then
        -- TODO: Implement custom logic
        return nil
    end
    return nil
end

-- Restores/sets the player's appearance
-- @param appearance: The appearance table
function EDIT.Appearance.SetPlayerAppearance(appearance)
    if not appearance then return false end
    
    if EDIT.ClothingSystem == "illenium-appearance" then
        exports['illenium-appearance']:setPlayerAppearance(appearance)
        return true
    elseif EDIT.ClothingSystem == "ped" then
        exports["ped"]:ApplyToPed(appearance)
        return true
    elseif EDIT.ClothingSystem == "custom" then
        -- TODO: Implement custom logic
        return false
    end
    return false
end

-- Sets the player's model/skin
-- @param model: The hash or name of the model
function EDIT.Appearance.SetPlayerModel(model)
    if not model then return false end
    
    if EDIT.ClothingSystem == "illenium-appearance" then
        exports['illenium-appearance']:setPlayerModel(model)
        return true
    elseif EDIT.ClothingSystem == "ped" or EDIT.ClothingSystem == "custom" then
        -- Custom model setter using FiveM native loading flow
        RequestModel(model)
        local timeout = GetGameTimer() + 5000
        while not HasModelLoaded(model) and GetGameTimer() < timeout do
            Wait(10)
        end
        if HasModelLoaded(model) then
            SetPlayerModel(PlayerId(), model)
            SetPedDefaultComponentVariation(PlayerPedId())
            SetModelAsNoLongerNeeded(model)
            return true
        end
    end
    return false
end

-- Triggers saving the player's appearance to the server database
-- @param appearance: The appearance table to save
function EDIT.Appearance.SaveAppearance(appearance)
    if not appearance then return false end
    
    if EDIT.ClothingSystem == "illenium-appearance" then
        TriggerServerEvent('illenium-appearance:server:saveAppearance', appearance)
        return true
    elseif EDIT.ClothingSystem == "ped" then
        -- E.g. exports["base"]:ServerCallback("Ped:SavePed", { ped = appearance }, function(ok) end)
        -- (Optional: Add custom save flow if needed, otherwise director script databases handle ped backups)
        return false
    elseif EDIT.ClothingSystem == "custom" then
        -- TODO: Implement custom logic
        return false
    end
    return false
end

-- Opens the customization creator UI for the player
-- @param cb: Callback function(newAppearance) called when saved
-- @param conf: Configuration table defining visible components/features
function EDIT.Appearance.StartPlayerCustomization(cb, conf)
    if not cb then return false end
    
    if EDIT.ClothingSystem == "illenium-appearance" then
        exports['illenium-appearance']:startPlayerCustomization(cb, conf)
        return true
    elseif EDIT.ClothingSystem == "ped" then
        -- TODO: Add export to open custom skin menu if needed (e.g. exports["ped"]:OpenMenu(cb, conf))
        return false
    elseif EDIT.ClothingSystem == "custom" then
        -- TODO: Implement custom logic
        return false
    end
    return false
end

-- ============================================================
-- EXTERNAL ANIMATION MENU BRIDGE
-- ============================================================
-- This is the only section that needs to be edited when using a different
-- animation menu. Spectrem opens that menu as an animation picker, reads the
-- user's choice, then returns to its normal "Select Ped for Animation" modal.
--
-- Configured integration: rpemotes. Use the resource folder name, not its full
-- filesystem path. Compatible forks expose getCurrentEmote/EmoteCancel and use
-- the rp:RecieveMenu event (for example WC_EMOTES_V8).
EDIT.AnimationBridge = {
    Enabled = true,
    Label = "RPEmotes",
    Resource = "WC_EMOTES_V8",
    SelectionTimeout = 120000,
    PollInterval = 100,
}

-- Return true only when the configured animation menu can be used.
function EDIT.AnimationBridge.IsAvailable()
    if EDIT.AnimationBridge.Enabled ~= true then
        return false, "External animation menu is disabled"
    end

    local resource = tostring(EDIT.AnimationBridge.Resource or "")
    if resource == "" or GetResourceState(resource) ~= "started" then
        return false, ("Animation resource '%s' is not started"):format(resource)
    end

    return true
end

-- Open the external menu. Replace this function if another resource uses a
-- command, export, or a different event.
-- Examples:
--   ExecuteCommand("emotemenu")
--   exports["my-emotes"]:OpenMenu()
--   TriggerEvent("my-emotes:client:openMenu")
function EDIT.AnimationBridge.OpenMenu(context)
    local available, message = EDIT.AnimationBridge.IsAvailable()
    if not available then return false, message end

    TriggerEvent("rp:RecieveMenu")
    return true
end

-- Called immediately before opening the external menu. Clearing the previous
-- emote prevents Spectrem from mistaking an old animation for the new choice.
function EDIT.AnimationBridge.PrepareSelection(context)
    local resource = EDIT.AnimationBridge.Resource
    pcall(function()
        exports[resource]:EmoteCancel()
    end)
end

-- Called after Spectrem captures the choice. RPEmotes leaves its NativeUI menu
-- open, so its toggle event closes it and EmoteCancel removes the temporary
-- animation from the user's character.
function EDIT.AnimationBridge.FinishSelection(context, animation)
    TriggerEvent("rp:RecieveMenu")
    local resource = EDIT.AnimationBridge.Resource
    pcall(function()
        exports[resource]:EmoteCancel()
    end)
end

-- Return the active animation in the normalized format shown below. Spectrem
-- checks that dict/anim is really playing before storing it, so stale values
-- returned by an animation resource are ignored.
--
-- Supported return fields:
-- {
--   dict = "animation_dictionary",
--   anim = "animation_clip", -- "clip" is also accepted
--   flags = 1,
--   duration = -1,
--   blendIn = 8.0,
--   blendOut = -8.0,
--   options = {},           -- AnimationOptions is also accepted
-- }
--
-- Scenarios can instead return:
-- { scenario = "WORLD_HUMAN_...", scenarioType = "Scenario" }
function EDIT.AnimationBridge.GetCurrentEmote(ped)
    local available = EDIT.AnimationBridge.IsAvailable()
    if not available then return nil end

    local resource = EDIT.AnimationBridge.Resource
    local ok, emote = pcall(function()
        return exports[resource]:getCurrentEmote()
    end)
    if not ok or type(emote) ~= "table" then return nil end

    local options = emote.AnimationOptions or emote.options
    return {
        dict = emote.dict or emote[1],
        anim = emote.anim or emote.clip or emote[2],
        name = emote.name or emote.label or emote[3],
        scenario = emote.scenario,
        scenarioType = emote.scenarioType,
        options = options,
        flags = emote.flags or (type(options) == "table" and options.Flag),
        duration = emote.duration or (type(options) == "table" and options.EmoteDuration),
        blendIn = emote.blendIn or (type(options) == "table" and options.BlendInSpeed),
        blendOut = emote.blendOut or (type(options) == "table" and options.BlendOutSpeed),
    }
end

-- ============================================================
-- CUSTOM VEHICLE WEAPON BRIDGE
-- ============================================================
-- Native GTA vehicle weapons are detected and replayed automatically. Enable
-- this bridge only when an addon uses its own script for turrets, cannons or
-- missiles and therefore does not expose GET_CURRENT_PED_VEHICLE_WEAPON.
--
-- Capture may return:
-- {
--   handled = true,          -- do not also run native detection this frame
--   fired = true,
--   weapon = "WEAPON_...", -- hash is also accepted
--   count = 1,
--   seat = -1,
--   ammo = 10,
--   muzzle = { x=..., y=..., z=... }, -- world coordinates by default
--   target = { x=..., y=..., z=... },
--   muzzleIsLocal = false,
--   targetIsLocal = false,
-- }
-- Return { handled=true, fired=false } while the custom resource is active but
-- did not shoot on this frame. `context.state` is persistent for the vehicle.
--
-- Replay receives the saved world-space muzzle/target and returns true when the
-- custom resource reproduced the visual/projectile itself. Returning false lets
-- Spectrem continue with the native/ballistic fallback.
EDIT.VehicleWeaponBridge = {
    Enabled = false,
}

function EDIT.VehicleWeaponBridge.Capture(ped, vehicle, context)
    -- Example:
    -- local shot = exports["my-armed-vehicles"]:GetLastShot(vehicle)
    -- if not shot then return { handled=true, fired=false } end
    -- if context.state.lastShotId == shot.id then
    --     return { handled=true, fired=false }
    -- end
    -- context.state.lastShotId = shot.id
    -- return {
    --     handled=true, fired=true, weapon=shot.weapon, count=1,
    --     seat=shot.seat, muzzle=shot.muzzle, target=shot.target,
    -- }
    return nil
end

function EDIT.VehicleWeaponBridge.Replay(vehicle, shooter, event)
    -- Example:
    -- exports["my-armed-vehicles"]:ReplayShot(vehicle, event)
    -- return true
    return false
end

-- CBR CITY: abertura somente por comando, sem atalhos padrão.
EDIT.CustomKeys = { Director = '', Cutscenes = '' }
