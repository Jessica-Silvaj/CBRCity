-- ============================
-- Police Chase runtime
-- Local, cinematic pursuit actors with deterministic ownership and cleanup.
-- ============================

local ChaseSettings = (Config and Config.PoliceChase) or {}

PoliceChaseVehicles = ChaseSettings.Vehicles or {
    { label = "Police Cruiser", value = "police" },
    { label = "Police Cruiser 2", value = "police2" },
    { label = "Police Cruiser 3", value = "police3" },
    { label = "Police Buffalo", value = "police4" },
    { label = "Police Transporter", value = "policet" },
    { label = "FBI Sedan", value = "fbi" },
    { label = "FBI SUV", value = "fbi2" },
    { label = "Sheriff Cruiser", value = "sheriff" },
    { label = "Sheriff SUV", value = "sheriff2" },
}

PoliceChaseHelicopters = ChaseSettings.Helicopters or {
    { label = "Police Maverick", value = "polmav" },
    { label = "Buzzard", value = "buzzard" },
    { label = "Annihilator", value = "annihilator" },
    { label = "Frogger", value = "frogger" },
    { label = "Valkyrie", value = "valkyrie" },
    { label = "Savage", value = "savage" },
}

local FALLBACK_DRIVING_PRESETS = {
    [1] = {
        label = "Normal",
        drivingStyle = 786468,
        maxSpeed = 35.0,
        driverAbility = 0.85,
        driverAggressiveness = 0.35,
        idealPursuitDistance = 16.0,
        brakeDistance = 8.0,
        allowRamming = false,
    },
    [2] = {
        label = "Aggressive",
        drivingStyle = 262716,
        maxSpeed = 45.0,
        driverAbility = 1.0,
        driverAggressiveness = 0.75,
        idealPursuitDistance = 12.0,
        brakeDistance = 7.0,
        allowRamming = false,
    },
    [3] = {
        label = "Ramming",
        drivingStyle = 786469,
        maxSpeed = 55.0,
        driverAbility = 1.0,
        driverAggressiveness = 1.0,
        idealPursuitDistance = 4.0,
        brakeDistance = 2.0,
        allowRamming = true,
    },
}

local DEFAULT_PROTECTION = {
    vehicles = true,
    drivers = true,
    helicopter = true,
    pilot = true,
}

local DEFAULT_ON_FOOT = {
    enabled = true,
    distance = 20.0,
    exitVehicle = true,
    weapon = "WEAPON_PISTOL",
    ammo = 60,
    accuracy = 35,
    graceMs = 3000,
    forceAfterMs = 6500,
    vehicleStopSpeed = 3.0,
}

local DeferredVehicleDeletes = {}

local function IsFiniteNumber(value)
    return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

local function NumberOr(value, fallback)
    local parsed = tonumber(value)
    if IsFiniteNumber(parsed) then return parsed end
    return fallback
end

local function Clamp(value, minimum, maximum)
    value = NumberOr(value, minimum)
    if value < minimum then return minimum end
    if value > maximum then return maximum end
    return value
end

local function Round(value)
    return math.floor(NumberOr(value, 0) + 0.5)
end

local function CopyTable(value)
    if type(value) ~= "table" then return value end
    local output = {}
    for key, item in pairs(value) do
        output[key] = CopyTable(item)
    end
    return output
end

local function FirstValue(source, ...)
    if type(source) ~= "table" then return nil end
    for index = 1, select("#", ...) do
        local key = select(index, ...)
        if source[key] ~= nil then return source[key] end
    end
    return nil
end

local function BooleanValue(source, fallback, ...)
    local value = FirstValue(source, ...)
    if value == nil then return fallback end
    return value == true
end

local function ModelName(value, fallback)
    if type(value) == "number" then return value end
    if type(value) == "string" and value ~= "" then return value end
    return fallback
end

local function ModelHash(value)
    if type(value) == "number" then return value end
    if type(value) == "string" then
        local numeric = tonumber(value)
        if numeric then return numeric end
    end
    return GetHashKey(tostring(value or ""))
end

local function EntityExists(entity)
    return entity ~= nil and entity ~= 0 and DoesEntityExist(entity)
end

local function EntityAlive(entity)
    return EntityExists(entity) and not IsEntityDead(entity)
end

local function DistanceBetween(first, second)
    if not first or not second then return math.huge end
    local dx = NumberOr(first.x, 0.0) - NumberOr(second.x, 0.0)
    local dy = NumberOr(first.y, 0.0) - NumberOr(second.y, 0.0)
    local dz = NumberOr(first.z, 0.0) - NumberOr(second.z, 0.0)
    return math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
end

local function RuntimeDebugEnabled()
    local liveSettings = (Config and Config.PoliceChase) or ChaseSettings
    return liveSettings.Debug == true or (Config and Config.DebugPoliceChase == true)
end

local function DebugLog(message, ...)
    if not RuntimeDebugEnabled() then return end
    local ok, formatted = pcall(string.format, tostring(message), ...)
    print(("[Spectrem][Chase] %s"):format(ok and formatted or tostring(message)))
end

local function ConfigNumber(name, fallback)
    local liveSettings = (Config and Config.PoliceChase) or ChaseSettings
    return NumberOr(liveSettings[name], fallback)
end

local function RuntimeChaseDisabled()
    local liveSettings = (Config and Config.PoliceChase) or ChaseSettings
    return liveSettings.Enabled == false or (type(EDIT) == "table" and EDIT.DisablePoliceChase == true)
end

local function GetPreset(index)
    local presetIndex = math.floor(Clamp(index, 1, 3))
    local configured = ((Config and Config.PoliceChase) or ChaseSettings).DrivingPresets or {}
    local source = configured[presetIndex] or configured[tostring(presetIndex)] or FALLBACK_DRIVING_PRESETS[presetIndex]
    local fallback = FALLBACK_DRIVING_PRESETS[presetIndex]

    return {
        id = presetIndex,
        label = tostring(FirstValue(source, "label", "Label") or fallback.label),
        drivingStyle = Round(FirstValue(source, "drivingStyle", "DrivingStyle") or fallback.drivingStyle),
        maxSpeed = Clamp(FirstValue(source, "maxSpeed", "MaxSpeed") or fallback.maxSpeed, 5.0, 120.0),
        driverAbility = Clamp(FirstValue(source, "driverAbility", "DriverAbility") or fallback.driverAbility, 0.0, 1.0),
        driverAggressiveness = Clamp(FirstValue(source, "driverAggressiveness", "DriverAggressiveness", "aggression") or fallback.driverAggressiveness, 0.0, 1.0),
        idealPursuitDistance = Clamp(FirstValue(source, "idealPursuitDistance", "IdealPursuitDistance", "idealDistance", "IdealDistance") or fallback.idealPursuitDistance, 0.0, 100.0),
        brakeDistance = Clamp(FirstValue(source, "brakeDistance", "BrakeDistance") or fallback.brakeDistance, 0.0, 100.0),
        allowRamming = BooleanValue(source, fallback.allowRamming, "allowRamming", "AllowRamming"),
    }
end

local function NormalizeProtection(input, base)
    local protection = CopyTable(base or DEFAULT_PROTECTION)
    local source = input

    if type(source) == "boolean" then
        protection.vehicles = source
        protection.drivers = source
        protection.helicopter = source
        protection.pilot = source
        return protection
    end

    if type(source) ~= "table" then return protection end
    protection.vehicles = BooleanValue(source, protection.vehicles, "vehicles", "Vehicles")
    protection.drivers = BooleanValue(source, protection.drivers, "drivers", "Drivers")
    protection.helicopter = BooleanValue(source, protection.helicopter, "helicopter", "Helicopter")
    protection.pilot = BooleanValue(source, protection.pilot, "pilot", "Pilot")
    return protection
end

local function NormalizeOnFoot(input, base)
    local response = CopyTable(base or DEFAULT_ON_FOOT)
    if type(input) == "boolean" then
        response.enabled = input
        return response
    end
    if type(input) ~= "table" then return response end

    response.enabled = BooleanValue(input, response.enabled, "enabled", "Enabled")
    response.distance = Clamp(FirstValue(input, "distance", "Distance") or response.distance, 3.0, 150.0)
    response.exitVehicle = BooleanValue(input, response.exitVehicle, "exitVehicle", "ExitVehicle")

    local weapon = FirstValue(input, "weapon", "Weapon", "weapons", "Weapons")
    if type(weapon) == "table" then
        weapon = weapon[1]
        if type(weapon) == "table" then weapon = weapon.value or weapon.weapon or weapon.name end
    end
    response.weapon = ModelName(weapon, response.weapon)
    response.ammo = Round(Clamp(FirstValue(input, "ammo", "Ammo") or response.ammo, 0, 9999))
    response.accuracy = Round(Clamp(FirstValue(input, "accuracy", "Accuracy") or response.accuracy, 0, 100))
    response.graceMs = Round(Clamp(FirstValue(input, "graceMs", "GraceMs") or response.graceMs, 0, 30000))
    response.forceAfterMs = Round(Clamp(FirstValue(input, "forceAfterMs", "ForceAfterMs") or response.forceAfterMs, 1000, 60000))
    response.vehicleStopSpeed = Clamp(FirstValue(input, "vehicleStopSpeed", "VehicleStopSpeed") or response.vehicleStopSpeed, 0.0, 20.0)
    return response
end

local function AdvancedFleetSettings()
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    return type(settings.AdvancedFleet) == "table" and settings.AdvancedFleet or {}
end

local function NormalizeFleetSource(value, fallback)
    value = tostring(value or fallback or "default"):lower()
    if value == "saved" or value == "preset" or value == "library" then return "saved" end
    if value == "model" or value == "custom" or value == "addon" then return "model" end
    return "default"
end

local function NormalizeUnitOccupant(input, fallback, defaultSeat)
    input = type(input) == "table" and input or {}
    fallback = type(fallback) == "table" and fallback or {}
    local savedPedId = FirstValue(input, "savedPedId", "pedId", "savedId")
    if savedPedId == nil then savedPedId = FirstValue(fallback, "savedPedId", "pedId", "savedId") end
    local source = NormalizeFleetSource(
        FirstValue(input, "source", "pedSource"),
        FirstValue(fallback, "source", "pedSource")
    )
    if savedPedId ~= nil and tostring(savedPedId) ~= "" then source = "saved" end
    local seat = Round(Clamp(
        FirstValue(input, "seat", "seatIndex")
            or FirstValue(fallback, "seat", "seatIndex")
            or defaultSeat
            or -1,
        -1,
        31
    ))
    return {
        seat = seat,
        role = seat == -1 and "driver" or "passenger",
        source = source,
        savedPedId = savedPedId ~= nil and tostring(savedPedId) or nil,
        model = ModelName(
            FirstValue(input, "model", "pedModel") or FirstValue(fallback, "model", "pedModel"),
            nil
        ),
    }
end

local function NormalizeUnitOccupants(input, fallback)
    local advanced = AdvancedFleetSettings()
    local maximum = Round(Clamp(advanced.MaxOccupantsPerUnit or 8, 1, 32))
    local source = type(input) == "table" and input or nil
    local base = type(fallback) == "table" and fallback or nil
    local occupants = {}
    local occupiedSeats = {}

    local function append(entry, fallbackEntry, defaultSeat)
        if #occupants >= maximum then return end
        local normalized = NormalizeUnitOccupant(entry, fallbackEntry, defaultSeat)
        if not occupiedSeats[normalized.seat] then
            occupiedSeats[normalized.seat] = true
            occupants[#occupants + 1] = normalized
        end
    end

    if source then
        for index, entry in ipairs(source) do append(entry, nil, index - 2) end
    elseif base then
        for index, entry in ipairs(base) do append(entry, nil, index - 2) end
    end

    -- A Chase vehicle always needs a driver. Passenger-only payloads are
    -- accepted, but a default police driver is inserted in seat -1.
    if not occupiedSeats[-1] then
        if #occupants >= maximum then table.remove(occupants, #occupants) end
        table.insert(occupants, 1, NormalizeUnitOccupant(nil, nil, -1))
    end
    table.sort(occupants, function(left, right) return left.seat < right.seat end)
    return occupants
end

local function NormalizeUnitSetup(input, fallback, defaultVehicle)
    input = type(input) == "table" and input or {}
    fallback = type(fallback) == "table" and fallback or {}
    local savedVehicleId = FirstValue(input, "savedVehicleId", "vehicleId", "savedId")
    if savedVehicleId == nil then savedVehicleId = FirstValue(fallback, "savedVehicleId", "vehicleId", "savedId") end
    local source = NormalizeFleetSource(
        FirstValue(input, "vehicleSource", "source"),
        FirstValue(fallback, "vehicleSource", "source")
    )
    if savedVehicleId ~= nil and tostring(savedVehicleId) ~= "" then source = "saved" end
    local occupantsInput = input.occupants
    local occupantsFallback = fallback.occupants
    return {
        vehicleSource = source,
        savedVehicleId = savedVehicleId ~= nil and tostring(savedVehicleId) or nil,
        vehicleModel = ModelName(
            FirstValue(input, "vehicleModel", "model") or FirstValue(fallback, "vehicleModel", "model"),
            defaultVehicle
        ),
        occupants = NormalizeUnitOccupants(occupantsInput, occupantsFallback),
        onFootWeapon = ModelName(
            FirstValue(input, "onFootWeapon", "weapon") or FirstValue(fallback, "onFootWeapon", "weapon"),
            nil
        ),
    }
end

local function NormalizeUnitSetups(input, count, fallback, defaultVehicle)
    input = type(input) == "table" and input or {}
    fallback = type(fallback) == "table" and fallback or {}
    local setups = {}
    for index = 1, count do
        local incoming = input[index] or input[tostring(index)]
        local previous = fallback[index] or fallback[tostring(index)]
        setups[index] = NormalizeUnitSetup(incoming, previous, defaultVehicle)
    end
    return setups
end

local function DefaultRuntimeConfig()
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local output = {
        numUnits = Round(Clamp(settings.DefaultUnits, NumberOr(settings.MinUnits, 1), NumberOr(settings.MaxUnits, 8))),
        vehicleModel = ModelName(settings.DefaultVehicle, "police"),
        aggressiveness = Round(Clamp(settings.DefaultAggressiveness, 1, 3)),
        sirens = settings.DefaultSirens ~= false,
        helicopter = settings.DefaultHelicopter == true,
        helicopterModel = ModelName(settings.DefaultHelicopterModel, "polmav"),
        deploymentDistance = Clamp(settings.DefaultDeploymentDistance or settings.SpawnDistance, NumberOr(settings.MinDeploymentDistance, 18.0), NumberOr(settings.MaxDeploymentDistance, 120.0)),
        protection = NormalizeProtection(settings.Protection, DEFAULT_PROTECTION),
        onFootResponse = NormalizeOnFoot(settings.OnFootResponse, DEFAULT_ON_FOOT),
        advancedEnabled = false,
        networked = false,
    }
    output.unitSetups = NormalizeUnitSetups(settings.DefaultUnitSetups, output.numUnits, nil, output.vehicleModel)
    return output
end

local function NormalizeRuntimeConfig(input, base)
    input = type(input) == "table" and input or {}
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local output = CopyTable(base or DefaultRuntimeConfig())
    local minimum = Round(Clamp(settings.MinUnits, 0, 32))
    local maximum = Round(Clamp(settings.MaxUnits, math.max(1, minimum), 32))

    if input.numUnits ~= nil then output.numUnits = Round(Clamp(input.numUnits, minimum, maximum)) end
    if input.vehicleModel ~= nil then output.vehicleModel = ModelName(input.vehicleModel, output.vehicleModel) end
    if input.aggressiveness ~= nil then output.aggressiveness = Round(Clamp(input.aggressiveness, 1, 3)) end
    if input.sirens ~= nil then output.sirens = input.sirens == true end
    if input.helicopter ~= nil then output.helicopter = input.helicopter == true end
    if input.helicopterModel ~= nil then output.helicopterModel = ModelName(input.helicopterModel, output.helicopterModel) end

    local deployment = FirstValue(input, "deploymentDistance", "spawnDistance", "SpawnDistance")
    if deployment ~= nil then
        output.deploymentDistance = Clamp(deployment, NumberOr(settings.MinDeploymentDistance, 18.0), NumberOr(settings.MaxDeploymentDistance, 120.0))
    end

    local protectionPatch = input.protection
    if protectionPatch == nil then protectionPatch = input.unitProtection end
    if protectionPatch ~= nil then output.protection = NormalizeProtection(protectionPatch, output.protection) end
    if input.onFootResponse ~= nil then output.onFootResponse = NormalizeOnFoot(input.onFootResponse, output.onFootResponse) end

    local unitSetups = input.unitSetups
    local template = type(input.unitSetup) == "table" and input.unitSetup or nil
    if input.advancedEnabled ~= nil then output.advancedEnabled = input.advancedEnabled == true end
    if template and template.enabled ~= nil then output.advancedEnabled = template.enabled == true end
    if template and template.enabled == true then
        if type(template.units) == "table" and #template.units > 0 then
            unitSetups = template.units
        elseif type(unitSetups) ~= "table" or #unitSetups == 0 then
            unitSetups = {}
            for index = 1, output.numUnits do unitSetups[index] = template end
        end
    elseif type(unitSetups) ~= "table" then
        unitSetups = nil
    end
    local fleetAllowed = AdvancedFleetSettings().Enabled ~= false
    if not fleetAllowed or output.advancedEnabled ~= true then
        -- Opt-in is a hard boundary. The UI intentionally keeps the last
        -- advanced draft when the switch is turned off, but none of those
        -- saved-vehicle, custom-ped or weapon choices may leak into the
        -- classic Chase configuration.
        output.advancedEnabled = false
        unitSetups = nil
        output.unitSetups = NormalizeUnitSetups(nil, output.numUnits, nil, output.vehicleModel)
    else
        output.unitSetups = NormalizeUnitSetups(unitSetups, output.numUnits, output.unitSetups, output.vehicleModel)
    end

    -- Pursuit entities are intentionally local. Network migration makes
    -- cinematic timing non-deterministic and is not supported by this mode.
    output.networked = false
    return output
end

PoliceChase = {
    active = false,
    phase = "idle",
    units = {},
    casualtyUnits = {}, -- Bodies and their vehicles remain until Chase cleanup.
    config = DefaultRuntimeConfig(),
    desiredUnits = 0,
    helicopter = nil,
    threadToken = 0,
    operationBusy = false,
    spawnBusy = false,
    nextUnitId = 0,
    modelHashes = {},
    preparedUnits = {},
    replayLock = false,
    replayLockOwner = nil,
    nextHelicopterSpawnAt = 0,
    lastError = nil,
    target = {
        ped = 0,
        vehicle = 0,
        lastVehicle = 0,
        lastVehicleSpeed = 0.0,
        onFootSince = nil,
    },
}

local function CurrentTokenMatches(token)
    return PoliceChase.active == true and PoliceChase.threadToken == token
end

local function SetLastError(message)
    PoliceChase.lastError = message and tostring(message) or nil
    if message then DebugLog("%s", PoliceChase.lastError) end
end

local function IsModelListed(model, catalogue)
    local wanted = tostring(model or ""):lower()
    for _, option in ipairs(catalogue or {}) do
        local value = type(option) == "table" and (option.value or option.model or option.name) or option
        if tostring(value or ""):lower() == wanted then return true end
    end
    return false
end

local function ValidateVehicleModel(model, expectHelicopter)
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local catalogue = expectHelicopter and (settings.Helicopters or PoliceChaseHelicopters) or (settings.Vehicles or PoliceChaseVehicles)
    if not IsModelListed(model, catalogue) and settings.AllowCustomVehicleModels ~= true then
        return false, expectHelicopter and "The helicopter model is not allowed" or "The police vehicle model is not allowed"
    end

    local hash = ModelHash(model)
    if hash == 0 or not IsModelInCdimage(hash) or not IsModelValid(hash) or not IsModelAVehicle(hash) then
        return false, expectHelicopter and "The helicopter model is not streamed or valid" or "The police vehicle model is not streamed or valid"
    end

    if expectHelicopter then
        if not IsThisModelAHeli(hash) then return false, "The selected model is not a helicopter" end
    else
        local class = GetVehicleClassFromName(hash)
        if IsThisModelAHeli(hash) or IsThisModelAPlane(hash) or class == 14 or class == 15 or class == 16 or class == 21 then
            return false, "Ground Chase units require a road vehicle"
        end
    end

    return true, nil, hash
end

local function ValidateGroundVehicleHash(hash, label)
    hash = ModelHash(hash)
    if hash == 0 or not IsModelInCdimage(hash) or not IsModelValid(hash) or not IsModelAVehicle(hash) then
        return false, (label or "Vehicle") .. " model is not streamed or valid"
    end
    local class = GetVehicleClassFromName(hash)
    if IsThisModelAHeli(hash) or IsThisModelAPlane(hash) or class == 14 or class == 15 or class == 16 or class == 21 then
        return false, (label or "Vehicle") .. " must be a ground vehicle"
    end
    return true, nil, hash
end

local function ValidatePedModel(model, label)
    local hash = ModelHash(model)
    if hash == 0 or not IsModelInCdimage(hash) or not IsModelValid(hash) or not IsModelAPed(hash) then
        return false, (label or "Ped") .. " model is not streamed or valid"
    end
    return true, nil, hash
end

local function RequestModelWithTimeout(hash, timeoutMs, token)
    if token and not CurrentTokenMatches(token) then return false, "cancelled" end
    if HasModelLoaded(hash) then return true end
    RequestModel(hash)
    local deadline = GetGameTimer() + Round(Clamp(timeoutMs, 250, 20000))
    while not HasModelLoaded(hash) do
        if token and not CurrentTokenMatches(token) then return false, "cancelled" end
        if GetGameTimer() >= deadline then return false, "timeout" end
        Wait(0)
    end
    return true
end

local function ReleaseModelHashes(hashes)
    for hash in pairs(hashes or {}) do
        SetModelAsNoLongerNeeded(hash)
    end
end

local function ResolveSavedVehicle(vehicleId)
    if type(SD_FindSavedVehicle) == "function" then
        local ok, result = pcall(SD_FindSavedVehicle, vehicleId)
        if ok and type(result) == "table" then return result end
    end
    for _, saved in ipairs(type(_savedVehiclesCache) == "table" and _savedVehiclesCache or {}) do
        if tostring(saved.id or "") == tostring(vehicleId or "") then return saved end
    end
    return nil
end

local function ResolveSavedPed(pedId)
    if type(SD_FindSavedPed) == "function" then
        local ok, result = pcall(SD_FindSavedPed, pedId)
        if ok and type(result) == "table" then return result end
    end
    for _, saved in ipairs(type(_savedPedsCache) == "table" and _savedPedsCache or {}) do
        if tostring(saved.id or "") == tostring(pedId or "") then return saved end
    end
    return nil
end

local function ValidateOnFootWeapon(value, fallback)
    local weapon = ModelName(value, fallback or DEFAULT_ON_FOOT.weapon)
    local advanced = AdvancedFleetSettings()
    local options = type(advanced.Weapons) == "table" and advanced.Weapons or {}
    local allowed = #options == 0
    for _, option in ipairs(options) do
        local optionValue = type(option) == "table" and (option.value or option.weapon or option.name) or option
        if tostring(optionValue or ""):upper() == tostring(weapon or ""):upper() then
            allowed = true
            break
        end
    end
    if tostring(weapon or ""):upper() == tostring(fallback or ""):upper() then allowed = true end
    local hash = ModelHash(weapon)
    if not allowed or hash == 0 or (type(IsWeaponValid) == "function" and not IsWeaponValid(hash)) then
        return nil, "The selected on-foot weapon is not allowed or valid"
    end
    return weapon
end

local function PrepareGroundUnitDefinition(setup, config, unitIndex)
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    setup = type(setup) == "table" and setup or NormalizeUnitSetup(nil, nil, config.vehicleModel)
    local vehicleHash, vehicleDefinition

    if setup.vehicleSource == "saved" then
        vehicleDefinition = ResolveSavedVehicle(setup.savedVehicleId)
        if not vehicleDefinition then
            return nil, ("Saved vehicle for Chase unit %d was not found"):format(unitIndex)
        end
        if type(SpectremVehicleCustomization) ~= "table"
            or type(SpectremVehicleCustomization.ResolveModel) ~= "function" then
            return nil, "The saved-vehicle customization runtime is not available"
        end
        vehicleHash = SpectremVehicleCustomization.ResolveModel(vehicleDefinition)
        local valid, message, validatedHash = ValidateGroundVehicleHash(vehicleHash, ("Chase unit %d"):format(unitIndex))
        if not valid then return nil, message end
        vehicleHash = validatedHash
    else
        local model = setup.vehicleSource == "model" and setup.vehicleModel or config.vehicleModel
        local valid, message, validatedHash = ValidateVehicleModel(model, false)
        if not valid then return nil, message end
        vehicleHash = validatedHash
    end

    local onFootWeapon, weaponMessage = ValidateOnFootWeapon(setup.onFootWeapon, config.onFootResponse.weapon)
    if not onFootWeapon then return nil, weaponMessage end
    local prepared = {
        vehicleHash = vehicleHash,
        vehicleDefinition = vehicleDefinition and CopyTable(vehicleDefinition) or nil,
        setup = CopyTable(setup),
        occupants = {},
        onFootWeapon = onFootWeapon,
    }

    local defaultPedModel = ModelName(settings.CopPedModel, "s_m_y_cop_01")
    for occupantIndex, occupant in ipairs(setup.occupants or {}) do
        local savedPed = nil
        local model = occupant.model
        if occupant.source == "saved" then
            savedPed = ResolveSavedPed(occupant.savedPedId)
            if not savedPed then
                return nil, ("Saved ped for Chase unit %d, seat %d was not found"):format(unitIndex, occupant.seat)
            end
            model = savedPed.model or (type(savedPed.appearance) == "table" and savedPed.appearance.model) or model
        elseif occupant.source ~= "model" then
            model = defaultPedModel
        end
        model = ModelName(model, defaultPedModel)
        local valid, message, pedHash = ValidatePedModel(model, occupant.seat == -1 and "Chase driver" or "Chase passenger")
        if not valid then return nil, message end
        prepared.occupants[occupantIndex] = {
            seat = occupant.seat,
            role = occupant.seat == -1 and "driver" or "passenger",
            source = occupant.source,
            savedPedId = occupant.savedPedId,
            model = model,
            hash = pedHash,
            appearance = savedPed and CopyTable(savedPed.appearance) or nil,
            name = savedPed and savedPed.name or nil,
        }
    end
    return prepared
end

local function PrepareModels(config, token)
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local hashes = {}
    local result = {}
    local preparedUnits = {}

    for unitIndex = 1, config.numUnits do
        local prepared, message = PrepareGroundUnitDefinition(config.unitSetups[unitIndex], config, unitIndex)
        if not prepared then return false, message end
        preparedUnits[unitIndex] = prepared
        hashes[prepared.vehicleHash] = true
        for _, occupant in ipairs(prepared.occupants) do hashes[occupant.hash] = true end
    end
    if preparedUnits[1] then
        result.vehicle = preparedUnits[1].vehicleHash
        result.driver = preparedUnits[1].occupants[1] and preparedUnits[1].occupants[1].hash or nil
    end

    if config.helicopter then
        local heliValid, heliMessage, heliHash = ValidateVehicleModel(config.helicopterModel, true)
        if not heliValid then return false, heliMessage end
        local pilotModel = ModelName(settings.PilotPedModel, "s_m_y_pilot_01")
        local pilotValid, pilotMessage, pilotHash = ValidatePedModel(pilotModel, "Helicopter pilot")
        if not pilotValid then return false, pilotMessage end
        hashes[heliHash] = true
        hashes[pilotHash] = true
        result.helicopter = heliHash
        result.pilot = pilotHash
    end

    for hash in pairs(hashes) do
        local loaded, reason = RequestModelWithTimeout(hash, 8000, token)
        if not loaded then
            -- A superseding session may be requesting the same hash. Do not
            -- mark it unused from this cancelled coroutine.
            if reason ~= "cancelled" then ReleaseModelHashes(hashes) end
            if reason == "cancelled" then return false, "The Chase request was cancelled" end
            return false, "A Chase model could not be loaded"
        end
    end

    if not CurrentTokenMatches(token) then
        return false, "The Chase request was cancelled"
    end

    for hash in pairs(hashes) do PoliceChase.modelHashes[hash] = true end
    PoliceChase.preparedUnits = preparedUnits
    PoliceChase.modelHashesByRole = result
    return true
end

local function VehicleHasForeignOccupants(vehicle, ownedPeds)
    if not EntityExists(vehicle) then return false end
    local owned = {}
    if type(ownedPeds) == "table" then
        for key, value in pairs(ownedPeds) do
            local ped = type(key) == "number" and value or key
            if type(ped) == "number" then owned[ped] = true end
        end
    elseif type(ownedPeds) == "number" and ownedPeds ~= 0 then
        owned[ownedPeds] = true
    end
    local maximumPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
    for seat = -1, maximumPassengers - 1 do
        local occupant = GetPedInVehicleSeat(vehicle, seat)
        if occupant ~= 0 and not owned[occupant] and EntityExists(occupant) then return true end
    end
    return false
end

local function DeleteOwnedPed(ped)
    if not EntityExists(ped) or ped == PlayerPedId() then return end
    ClearPedTasksImmediately(ped)
    SetEntityAsMissionEntity(ped, true, true)
    DeleteEntity(ped)
end

local function QueueVehicleDelete(vehicle)
    if not EntityExists(vehicle) or DeferredVehicleDeletes[vehicle] then return end
    DeferredVehicleDeletes[vehicle] = true
    -- Release immediately so a resource restart cannot strand a mission
    -- vehicle that currently contains a ped we do not own. The deferred
    -- worker may safely reclaim and delete it after those occupants leave.
    SetEntityAsMissionEntity(vehicle, false, false)
    SetEntityAsNoLongerNeeded(vehicle)
    CreateThread(function()
        local deadline = GetGameTimer() + 30000
        while EntityExists(vehicle) and VehicleHasForeignOccupants(vehicle, 0) and GetGameTimer() < deadline do
            Wait(500)
        end

        if EntityExists(vehicle) then
            if VehicleHasForeignOccupants(vehicle, 0) then
                SetEntityAsMissionEntity(vehicle, false, false)
                SetEntityAsNoLongerNeeded(vehicle)
                DebugLog("Released occupied cleanup vehicle %s instead of deleting foreign occupants", vehicle)
            else
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteEntity(vehicle)
            end
        end
        DeferredVehicleDeletes[vehicle] = nil
    end)
end

local function DeleteOwnedVehicle(vehicle, ownedPeds)
    if not EntityExists(vehicle) then return end
    SetVehicleSiren(vehicle, false)
    SetVehicleHasMutedSirens(vehicle, true)
    SetVehicleHandbrake(vehicle, true)
    if VehicleHasForeignOccupants(vehicle, ownedPeds) then
        QueueVehicleDelete(vehicle)
        return
    end
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteEntity(vehicle)
end

local function CleanupGroundUnit(unit, reason, preserveCasualties)
    if type(unit) ~= "table" or unit.cleaned then return end
    unit.cleaned = true
    DebugLog("Cleaning ground unit %s (%s)", unit.id or "?", reason or "unspecified")
    local driver = unit.driver
    local vehicle = unit.vehicle
    local ownedPeds = {}
    for _, occupant in ipairs(type(unit.occupants) == "table" and unit.occupants or {}) do
        if EntityExists(occupant.ped) then ownedPeds[#ownedPeds + 1] = occupant.ped end
    end
    if #ownedPeds == 0 and EntityExists(driver) then ownedPeds[1] = driver end
    local casualties = {}
    for _, ped in ipairs(ownedPeds) do
        if preserveCasualties and ped ~= PlayerPedId() and IsEntityDead(ped) then
            casualties[#casualties + 1] = { ped = ped }
        else
            DeleteOwnedPed(ped)
        end
    end
    if #casualties > 0 then
        -- Retirement from the controller is not deletion from the shot. Keep
        -- mission ownership so Stop/restart can still clean up these entities.
        PoliceChase.casualtyUnits[#PoliceChase.casualtyUnits + 1] = {
            id = unit.id, driver = 0, vehicle = vehicle, occupants = casualties,
        }
    else
        DeleteOwnedVehicle(vehicle, ownedPeds)
    end
    unit.driver = 0
    unit.vehicle = 0
    unit.occupants = {}
end

local function CleanupHelicopter(reason)
    local helicopter = PoliceChase.helicopter
    if type(helicopter) ~= "table" then
        PoliceChase.helicopter = nil
        return
    end
    DebugLog("Cleaning helicopter (%s)", reason or "unspecified")
    DeleteOwnedPed(helicopter.pilot)
    DeleteOwnedVehicle(helicopter.vehicle, helicopter.pilot)
    PoliceChase.helicopter = nil
end

local function CleanupAllEntities(reason)
    for index = #PoliceChase.units, 1, -1 do
        CleanupGroundUnit(PoliceChase.units[index], reason)
        table.remove(PoliceChase.units, index)
    end
    for index = #PoliceChase.casualtyUnits, 1, -1 do
        CleanupGroundUnit(PoliceChase.casualtyUnits[index], reason)
        table.remove(PoliceChase.casualtyUnits, index)
    end
    CleanupHelicopter(reason)
end

local function ApplyVehicleProtection(vehicle, protected)
    if not EntityExists(vehicle) then return end
    SetEntityInvincible(vehicle, protected == true)
    SetEntityCanBeDamaged(vehicle, protected ~= true)
    SetVehicleCanBeVisiblyDamaged(vehicle, protected ~= true)
    SetVehicleTyresCanBurst(vehicle, protected ~= true)
    SetVehicleWheelsCanBreak(vehicle, protected ~= true)
    SetVehicleEngineCanDegrade(vehicle, protected ~= true)
end

local function ApplyPedProtection(ped, protected)
    if not EntityExists(ped) or ped == PlayerPedId() then return end
    SetEntityInvincible(ped, protected == true)
    SetEntityCanBeDamaged(ped, protected ~= true)
    SetPedCanRagdoll(ped, protected ~= true)
end

local function ConfigurePoliceDriver(driver, profile, protection)
    if not EntityExists(driver) or driver == PlayerPedId() then return false end
    SetEntityAsMissionEntity(driver, true, true)
    SetBlockingOfNonTemporaryEvents(driver, true)
    SetPedKeepTask(driver, true)
    SetPedCanBeDraggedOut(driver, false)
    SetPedFleeAttributes(driver, 0, false)
    SetPedCombatAbility(driver, 2)
    SetPedCombatRange(driver, 2)
    SetPedCombatMovement(driver, 3)
    SetPedCombatAttributes(driver, 3, false)
    SetPedCombatAttributes(driver, 5, false)
    SetPedCombatAttributes(driver, 21, false)
    SetPedCombatAttributes(driver, 46, false)
    SetPedCanEvasiveDive(driver, false)
    SetPedSeeingRange(driver, 250.0)
    SetPedHearingRange(driver, 250.0)
    SetDriverAbility(driver, profile.driverAbility)
    SetDriverAggressiveness(driver, profile.driverAggressiveness)
    ApplyPedProtection(driver, protection.drivers)
    return true
end

local function ConfigurePoliceOccupant(ped, protection)
    if not EntityExists(ped) or ped == PlayerPedId() then return false end
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedKeepTask(ped, true)
    SetPedCanBeDraggedOut(ped, false)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAbility(ped, 2)
    SetPedCombatRange(ped, 2)
    SetPedCombatMovement(ped, 3)
    SetPedCombatAttributes(ped, 3, false)
    SetPedCombatAttributes(ped, 5, false)
    SetPedCombatAttributes(ped, 21, false)
    SetPedCombatAttributes(ped, 46, false)
    SetPedCanEvasiveDive(ped, false)
    SetPedSeeingRange(ped, 250.0)
    SetPedHearingRange(ped, 250.0)
    ApplyPedProtection(ped, protection.drivers)
    return true
end

local function ApplySavedPedAppearance(ped, appearance)
    if not EntityExists(ped) or type(appearance) ~= "table" then return end
    if type(EDIT) == "table" and type(EDIT.Appearance) == "table"
        and type(EDIT.Appearance.SetPedAppearance) == "function" then
        pcall(EDIT.Appearance.SetPedAppearance, ped, appearance)
    end
end

local function ConfigurePoliceVehicle(vehicle, protection, sirens)
    if not EntityExists(vehicle) then return false end
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleSiren(vehicle, sirens == true)
    SetVehicleHasMutedSirens(vehicle, sirens ~= true)
    SetVehRadioStation(vehicle, "OFF")
    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), true)
    ApplyVehicleProtection(vehicle, protection.vehicles)
    return true
end

local function ApplyChaseTask(unit, targetPed, force)
    if type(unit) ~= "table" or not EntityAlive(unit.driver) or not EntityAlive(unit.vehicle) then return false end
    if not EntityAlive(targetPed) or targetPed == unit.driver then return false end
    if GetPedInVehicleSeat(unit.vehicle, -1) ~= unit.driver then return false end

    local now = GetGameTimer()
    local profile = GetPreset(PoliceChase.config.aggressiveness)
    local separation = DistanceBetween(GetEntityCoords(unit.vehicle), GetEntityCoords(targetPed))
    local distanceRetaskDue = separation > ConfigNumber("RetaskDistance", 50.0)
        and now >= NumberOr(unit.nextDistanceRetaskAt, 0)
    if force or unit.targetPed ~= targetPed or now >= NumberOr(unit.nextRetaskAt, 0) or distanceRetaskDue then
        ConfigurePoliceDriver(unit.driver, profile, PoliceChase.config.protection)
        for _, occupant in ipairs(unit.occupants or {}) do
            if occupant.ped ~= unit.driver and EntityAlive(occupant.ped)
                and IsPedInVehicle(occupant.ped, unit.vehicle, false) then
                ConfigurePoliceOccupant(occupant.ped, PoliceChase.config.protection)
            end
            occupant.combatTarget = nil
        end
        TaskVehicleChase(unit.driver, targetPed)
        SetDriverAbility(unit.driver, profile.driverAbility)
        SetDriverAggressiveness(unit.driver, profile.driverAggressiveness)
        SetDriveTaskDrivingStyle(unit.driver, profile.drivingStyle)
        SetDriveTaskMaxCruiseSpeed(unit.driver, profile.maxSpeed)
        SetTaskVehicleChaseIdealPursuitDistance(unit.driver, profile.idealPursuitDistance)
        -- GTA's chase flags persist on the task. Clear every contact tactic
        -- we own before applying the selected profile so a live style change
        -- cannot inherit the previous Ramming behavior.
        SetTaskVehicleChaseBehaviorFlag(unit.driver, 1, profile.allowRamming == true)
        SetTaskVehicleChaseBehaviorFlag(unit.driver, 2, profile.allowRamming == true)
        SetTaskVehicleChaseBehaviorFlag(unit.driver, 8, false)
        SetTaskVehicleChaseBehaviorFlag(unit.driver, 16, false)
        SetTaskVehicleChaseBehaviorFlag(unit.driver, 32, profile.allowRamming ~= true)
        SetVehicleMaxSpeed(unit.vehicle, profile.maxSpeed + 5.0)
        unit.targetPed = targetPed
        unit.nextRetaskAt = now + 4000
        unit.nextDistanceRetaskAt = now + 1500
    end

    -- Normal and Aggressive profiles brake progressively instead of receiving
    -- a second task that would overwrite TaskVehicleChase. Ramming keeps its
    -- authored top speed and deliberately ignores this safety envelope.
    local cruiseSpeed = profile.maxSpeed
    local brakeDistance = math.max(profile.brakeDistance, ConfigNumber("MinFollowDistance", 8.0))
    if not profile.allowRamming and separation <= brakeDistance then
        local targetContext = PoliceChase.target.vehicle ~= 0 and PoliceChase.target.vehicle or targetPed
        cruiseSpeed = math.max(4.0, GetEntitySpeed(targetContext))
    end
    SetDriveTaskMaxCruiseSpeed(unit.driver, cruiseSpeed)
    unit.mode = "vehicle"
    return true
end

local function IsPositionVisible(coords, radius)
    local visible = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if visible then return true end
    if IsSphereVisible then return IsSphereVisible(coords.x, coords.y, coords.z, radius or 4.0) end
    return false
end

local function GetTargetAnchor()
    local ped = PlayerPedId()
    if not EntityExists(ped) then return nil, 0, 0 end
    local vehicle = GetVehiclePedIsIn(ped, false)
    local anchor = vehicle ~= 0 and vehicle or ped
    return GetEntityCoords(anchor), GetEntityHeading(anchor), anchor
end

local function GetRoadSpawnPosition(index, deploymentDistance)
    local anchorCoords, heading = GetTargetAnchor()
    if not anchorCoords then return nil end
    local lateralSpacing = ConfigNumber("SpawnLateralSpacing", 5.0)
    local baseDistance = Clamp(deploymentDistance, ConfigNumber("MinDeploymentDistance", 18.0), ConfigNumber("MaxDeploymentDistance", 120.0))
    local sideIndex = math.ceil(index / 2)
    local side = index % 2 == 0 and 1.0 or -1.0

    for attempt = 0, 9 do
        local distance = baseDistance + (attempt * 8.0) + ((sideIndex - 1) * 3.0)
        local angleOffset = (attempt % 3 - 1) * 18.0
        local candidateHeading = heading + angleOffset
        local radians = math.rad(candidateHeading)
        local forwardX = -math.sin(radians)
        local forwardY = math.cos(radians)
        local rightX = math.cos(radians)
        local rightY = math.sin(radians)
        local lateral = side * lateralSpacing * sideIndex
        local candidateX = anchorCoords.x - (forwardX * distance) + (rightX * lateral)
        local candidateY = anchorCoords.y - (forwardY * distance) + (rightY * lateral)
        local candidateZ = anchorCoords.z + 2.0
        local found, roadCoords, roadHeading = GetClosestVehicleNodeWithHeading(candidateX, candidateY, candidateZ, 1, 3.0, 0)

        if found and roadCoords then
            RequestCollisionAtCoord(roadCoords.x, roadCoords.y, roadCoords.z)
            local groundFound, groundZ = GetGroundZFor_3dCoord(roadCoords.x, roadCoords.y, roadCoords.z + 15.0, false)
            if groundFound then roadCoords = vector3(roadCoords.x, roadCoords.y, groundZ + 0.25) end
            local occupied = IsAnyVehicleNearPoint(roadCoords.x, roadCoords.y, roadCoords.z, 4.5)
            if not occupied and not IsPositionVisible(roadCoords, 5.0) then
                return roadCoords, roadHeading
            end
        end
    end
    return nil
end

local function SpawnGroundUnit(index, token)
    if not CurrentTokenMatches(token) then return nil, "The Chase request was cancelled" end
    local preparedUnits = PoliceChase.preparedUnits or {}
    local prepared = preparedUnits[index] or preparedUnits[#preparedUnits] or preparedUnits[1]
    if type(prepared) ~= "table" or not prepared.vehicleHash or type(prepared.occupants) ~= "table" then
        return nil, "Ground Chase models are not ready"
    end
    local coords, heading = GetRoadSpawnPosition(index, PoliceChase.config.deploymentDistance)
    if not coords then return nil, "No safe off-camera road spawn was found" end

    local vehicle, spawnMessage
    if prepared.vehicleDefinition and type(SpectremVehicleCustomization) == "table"
        and type(SpectremVehicleCustomization.Spawn) == "function" then
        vehicle, spawnMessage = SpectremVehicleCustomization.Spawn(prepared.vehicleDefinition, coords, heading, false)
    else
        vehicle = CreateVehicle(prepared.vehicleHash, coords.x, coords.y, coords.z, heading, false, false)
    end
    if not EntityExists(vehicle) then return nil, "The police vehicle could not be created" end
    SetEntityAsMissionEntity(vehicle, true, true)

    if not CurrentTokenMatches(token) then
        DeleteOwnedVehicle(vehicle, 0)
        return nil, "The Chase request was cancelled"
    end

    local profile = GetPreset(PoliceChase.config.aggressiveness)
    ConfigurePoliceVehicle(vehicle, PoliceChase.config.protection, PoliceChase.config.sirens)
    PoliceChase.nextUnitId = PoliceChase.nextUnitId + 1
    local unit = {
        id = PoliceChase.nextUnitId,
        vehicle = vehicle,
        driver = 0,
        occupants = {},
        onFootWeapon = prepared.onFootWeapon or PoliceChase.config.onFootResponse.weapon,
        setup = CopyTable(prepared.setup),
        vehicleDefinition = prepared.vehicleDefinition and CopyTable(prepared.vehicleDefinition) or nil,
        mode = "vehicle",
        targetPed = 0,
        nextRetaskAt = 0,
        nextDistanceRetaskAt = 0,
        createdAt = GetGameTimer(),
        cleaned = false,
    }

    local maximumPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
    for _, occupantDefinition in ipairs(prepared.occupants) do
        local seat = occupantDefinition.seat
        if seat ~= -1 and (seat < 0 or seat >= maximumPassengers) then
            CleanupGroundUnit(unit, "configured seat unavailable")
            return nil, ("Chase unit %d does not have passenger seat %d"):format(index, seat)
        end
        if not CurrentTokenMatches(token) then
            CleanupGroundUnit(unit, "spawn cancelled")
            return nil, "The Chase request was cancelled"
        end
        local ped = CreatePedInsideVehicle(vehicle, 6, occupantDefinition.hash, seat, false, false)
        if not EntityExists(ped) or ped == PlayerPedId() or GetPedInVehicleSeat(vehicle, seat) ~= ped then
            if EntityExists(ped) and ped ~= PlayerPedId() then DeleteOwnedPed(ped) end
            CleanupGroundUnit(unit, "occupant spawn failed")
            return nil, seat == -1 and "The Chase driver could not be created"
                or ("The Chase passenger for seat %d could not be created"):format(seat)
        end
        ApplySavedPedAppearance(ped, occupantDefinition.appearance)
        if seat == -1 then
            unit.driver = ped
            ConfigurePoliceDriver(ped, profile, PoliceChase.config.protection)
        else
            ConfigurePoliceOccupant(ped, PoliceChase.config.protection)
        end
        unit.occupants[#unit.occupants + 1] = {
            ped = ped,
            seat = seat,
            role = seat == -1 and "driver" or "passenger",
            source = occupantDefinition.source,
            savedPedId = occupantDefinition.savedPedId,
            model = occupantDefinition.model,
            name = occupantDefinition.name,
            appearance = occupantDefinition.appearance and CopyTable(occupantDefinition.appearance) or nil,
        }
    end

    if not EntityExists(unit.driver) then
        CleanupGroundUnit(unit, "driver missing")
        return nil, "The Chase unit requires a driver"
    end

    local targetPed = PlayerPedId()
    if not ApplyChaseTask(unit, targetPed, true) then
        CleanupGroundUnit(unit, "initial task failed")
        return nil, "The police unit could not begin pursuit"
    end

    DebugLog("Spawned unit %s vehicle=%s driver=%s occupants=%s", unit.id, vehicle, unit.driver, #unit.occupants)
    return unit
end

local function GetHelicopterSpawnPosition()
    local targetCoords = GetEntityCoords(PlayerPedId())
    local distance = ConfigNumber("HeliSpawnDistance", 80.0)
    local height = ConfigNumber("HeliSpawnHeight", 60.0)
    local cameraHeading = GetGameplayCamRot(2).z
    local firstPosition = nil

    for attempt = 0, 7 do
        local radians = math.rad(cameraHeading + 180.0 + (attempt * 45.0))
        local coords = vector3(
            targetCoords.x - math.sin(radians) * distance,
            targetCoords.y + math.cos(radians) * distance,
            targetCoords.z + height
        )
        firstPosition = firstPosition or coords
        if not IsPositionVisible(coords, 12.0) then return coords end
    end
    return firstPosition
end

local function AssignHelicopterTask(helicopter, targetPed, force)
    if type(helicopter) ~= "table" or not EntityAlive(helicopter.vehicle) or not EntityAlive(helicopter.pilot) then return false end
    if GetPedInVehicleSeat(helicopter.vehicle, -1) ~= helicopter.pilot or not EntityAlive(targetPed) then return false end
    local now = GetGameTimer()
    if force or helicopter.targetPed ~= targetPed or now >= NumberOr(helicopter.nextRetaskAt, 0) then
        TaskHeliChase(helicopter.pilot, targetPed, 0.0, 0.0, 45.0)
        helicopter.targetPed = targetPed
        helicopter.nextRetaskAt = now + 5000
    end
    return true
end

local function SpawnPoliceHelicopter(token, configOverride, hashesOverride)
    local spawnConfig = configOverride or PoliceChase.config
    if not CurrentTokenMatches(token) or not spawnConfig.helicopter then return nil, "The helicopter request was cancelled" end
    local hashes = hashesOverride or PoliceChase.modelHashesByRole or {}
    if not hashes.helicopter or not hashes.pilot then return nil, "Helicopter models are not ready" end
    local coords = GetHelicopterSpawnPosition()
    if not coords then return nil, "No helicopter spawn position was found" end

    local vehicle = CreateVehicle(hashes.helicopter, coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), false, false)
    if not EntityExists(vehicle) then return nil, "The police helicopter could not be created" end
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetHeliBladesFullSpeed(vehicle)
    ApplyVehicleProtection(vehicle, spawnConfig.protection.helicopter)

    local pilot = CreatePedInsideVehicle(vehicle, 6, hashes.pilot, -1, false, false)
    if not EntityExists(pilot) or pilot == PlayerPedId() or GetPedInVehicleSeat(vehicle, -1) ~= pilot then
        if EntityExists(pilot) and pilot ~= PlayerPedId() then DeleteOwnedPed(pilot) end
        DeleteOwnedVehicle(vehicle, 0)
        return nil, "The helicopter pilot could not be created"
    end

    if not CurrentTokenMatches(token) then
        DeleteOwnedPed(pilot)
        DeleteOwnedVehicle(vehicle, 0)
        return nil, "The helicopter request was cancelled"
    end

    SetEntityAsMissionEntity(pilot, true, true)
    SetBlockingOfNonTemporaryEvents(pilot, true)
    SetPedKeepTask(pilot, true)
    SetPedCanBeDraggedOut(pilot, false)
    ApplyPedProtection(pilot, spawnConfig.protection.pilot)
    local helicopter = {
        vehicle = vehicle,
        pilot = pilot,
        targetPed = 0,
        nextRetaskAt = 0,
        nextDistanceRetaskAt = 0,
        createdAt = GetGameTimer(),
    }
    if not AssignHelicopterTask(helicopter, PlayerPedId(), true) then
        DeleteOwnedPed(pilot)
        DeleteOwnedVehicle(vehicle, 0)
        return nil, "The helicopter could not begin pursuit"
    end
    DebugLog("Spawned helicopter vehicle=%s pilot=%s", vehicle, pilot)
    return helicopter
end

local function RefreshTargetContext()
    local target = PoliceChase.target
    local ped = PlayerPedId()
    if not EntityAlive(ped) then return false end
    local now = GetGameTimer()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local changed = target.ped ~= ped or target.vehicle ~= vehicle

    if vehicle ~= 0 then
        target.lastVehicle = vehicle
        target.lastVehicleSpeed = GetEntitySpeed(vehicle)
        target.onFootSince = nil
    else
        if target.vehicle ~= 0 then
            target.lastVehicle = target.vehicle
            if EntityExists(target.vehicle) then target.lastVehicleSpeed = GetEntitySpeed(target.vehicle) end
        end
        target.onFootSince = target.onFootSince or now
    end

    target.ped = ped
    target.vehicle = vehicle
    return changed
end

local function UnitCrew(unit)
    if type(unit) ~= "table" then return {} end
    if type(unit.occupants) == "table" and #unit.occupants > 0 then return unit.occupants end
    if EntityExists(unit.driver) then return { { ped = unit.driver, seat = -1, role = "driver" } } end
    return {}
end

local function UnitCrewIsSeated(unit)
    if not EntityAlive(unit.vehicle) then return false end
    local living = 0
    for _, occupant in ipairs(UnitCrew(unit)) do
        if EntityAlive(occupant.ped) then
            living = living + 1
            if GetPedInVehicleSeat(unit.vehicle, occupant.seat) ~= occupant.ped then return false end
        end
    end
    return living > 0 and GetPedInVehicleSeat(unit.vehicle, -1) == unit.driver
end

local function LivingCrewPed(unit)
    for _, occupant in ipairs(UnitCrew(unit)) do
        if EntityAlive(occupant.ped) and occupant.ped ~= PlayerPedId() then return occupant.ped end
    end
    return nil
end

local function ApplyCrewProtection(unit, protection)
    for _, occupant in ipairs(UnitCrew(unit)) do
        -- Vehicle protection ends when officers dismount, including while
        -- returning to the car. Repairs/live settings must respect this too.
        if EntityAlive(occupant.ped) then
            ApplyPedProtection(occupant.ped, protection.drivers == true
                and unit.mode == "vehicle" and EntityAlive(unit.vehicle)
                and IsPedInVehicle(occupant.ped, unit.vehicle, false))
        end
    end
end

local function UnitCrewHasLeftVehicle(unit)
    local living = 0
    for _, occupant in ipairs(UnitCrew(unit)) do
        if EntityAlive(occupant.ped) then
            living = living + 1
            if EntityAlive(unit.vehicle) and IsPedInVehicle(occupant.ped, unit.vehicle, false) then return false end
        end
    end
    return living > 0
end

local function ArmOfficerForTarget(unit, targetPed)
    if unit.driver == PlayerPedId() or not EntityAlive(targetPed) then return false end
    local settings = PoliceChase.config.onFootResponse
    local weaponHash = ModelHash(unit.onFootWeapon or settings.weapon)
    local armed = 0
    for _, occupant in ipairs(UnitCrew(unit)) do
        local ped = occupant.ped
        if EntityAlive(ped) and ped ~= PlayerPedId()
            and (not EntityAlive(unit.vehicle) or not IsPedInVehicle(ped, unit.vehicle, false)) then
            ApplyPedProtection(ped, false)
            FreezeEntityPosition(ped, false)
            if occupant.combatTarget ~= targetPed or not IsPedInCombat(ped, targetPed) then
                ClearPedTasks(ped)
                GiveWeaponToPed(ped, weaponHash, settings.ammo, false, true)
                SetCurrentPedWeapon(ped, weaponHash, true)
                SetPedAccuracy(ped, settings.accuracy)
                SetPedCombatAbility(ped, 2)
                SetPedCombatRange(ped, 2)
                SetPedCombatMovement(ped, 2) -- Advance and use cover.
                SetPedCombatAttributes(ped, 0, true) -- Use cover.
                SetPedCombatAttributes(ped, 3, true) -- May leave vehicles.
                SetPedCombatAttributes(ped, 5, true) -- Fight instead of fleeing.
                SetPedCombatAttributes(ped, 21, true) -- Pursue a target on foot.
                SetPedCombatAttributes(ped, 46, true)
                SetPedCanEvasiveDive(ped, true)
                SetPedShootRate(ped, 650)
                SetPedSeeingRange(ped, 250.0)
                SetPedHearingRange(ped, 250.0)
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskCombatPed(ped, targetPed, 0, 16)
                occupant.combatTarget = targetPed
            end
            armed = armed + 1
        end
    end
    if armed == 0 then return false end
    unit.targetPed = targetPed
    unit.nextRetaskAt = GetGameTimer() + 2000
    if UnitCrewHasLeftVehicle(unit) then unit.mode = "on_foot" end
    return true
end

local function BeginOnFootTransition(unit)
    if unit.mode ~= "vehicle" or not EntityAlive(unit.vehicle) or not EntityAlive(unit.driver) then return end
    if GetPedInVehicleSeat(unit.vehicle, -1) ~= unit.driver then return end
    TaskVehicleTempAction(unit.driver, unit.vehicle, 27, 900)
    unit.mode = "braking"
    ApplyCrewProtection(unit, PoliceChase.config.protection)
    unit.transitionDeadline = GetGameTimer() + 1400
    DebugLog("Unit %s braking for on-foot response", unit.id or "?")
end

local function ContinueOnFootTransition(unit, targetPed)
    if not LivingCrewPed(unit) then return false end
    if not EntityAlive(unit.vehicle) then return ArmOfficerForTarget(unit, targetPed) end
    local now = GetGameTimer()
    if unit.mode == "braking" then
        if GetEntitySpeed(unit.vehicle) <= 1.25 or now >= NumberOr(unit.transitionDeadline, 0) then
            ApplyCrewProtection(unit, PoliceChase.config.protection)
            SetVehicleForwardSpeed(unit.vehicle, 0.0)
            SetVehicleHandbrake(unit.vehicle, true)
            for _, occupant in ipairs(UnitCrew(unit)) do
                if EntityAlive(occupant.ped) and IsPedInVehicle(occupant.ped, unit.vehicle, false) then
                    SetPedCombatAttributes(occupant.ped, 3, true)
                    occupant.combatTarget = nil
                    TaskLeaveVehicle(occupant.ped, unit.vehicle, 0)
                end
            end
            unit.mode = "exiting"
            unit.transitionDeadline = now + PoliceChase.config.onFootResponse.forceAfterMs
        end
        return true
    end

    if unit.mode == "exiting" then
        -- Start each officer as soon as they exit; a blocked passenger door
        -- must not leave the rest of the crew standing idle.
        ArmOfficerForTarget(unit, targetPed)
        if unit.mode == "on_foot" then return true end
        if now >= NumberOr(unit.transitionDeadline, 0) then
            for _, occupant in ipairs(UnitCrew(unit)) do
                if EntityAlive(occupant.ped) and IsPedInVehicle(occupant.ped, unit.vehicle, false) then
                    SetPedCombatAttributes(occupant.ped, 3, true)
                    TaskLeaveVehicle(occupant.ped, unit.vehicle, 16)
                end
            end
            unit.transitionDeadline = now + 1500
        end
        return true
    end
    return false
end

local function BeginReturnToVehicle(unit)
    if not EntityAlive(unit.driver) or not EntityAlive(unit.vehicle) then return false end
    for _, occupant in ipairs(UnitCrew(unit)) do
        local ped = occupant.ped
        if EntityAlive(ped) then
            occupant.combatTarget = nil
            RemoveAllPedWeapons(ped, true)
            SetPedCombatAttributes(ped, 5, false)
            SetPedCombatAttributes(ped, 21, false)
            SetPedCombatAttributes(ped, 46, false)
            SetPedCanEvasiveDive(ped, false)
        end
    end
    if UnitCrewIsSeated(unit) then
        SetVehicleHandbrake(unit.vehicle, false)
        return ApplyChaseTask(unit, PoliceChase.target.ped, true)
    end

    for _, occupant in ipairs(UnitCrew(unit)) do
        local ped = occupant.ped
        if EntityAlive(ped) and GetPedInVehicleSeat(unit.vehicle, occupant.seat) ~= ped then
            local current = GetPedInVehicleSeat(unit.vehicle, occupant.seat)
            if current ~= 0 and current ~= ped then return false end
            ClearPedTasks(ped)
            TaskEnterVehicle(ped, unit.vehicle, 5000, occupant.seat, 2.0, 1, 0)
        end
    end
    unit.mode = "returning"
    unit.transitionDeadline = GetGameTimer() + PoliceChase.config.onFootResponse.forceAfterMs
    DebugLog("Unit %s returning to its patrol vehicle", unit.id or "?")
    return true
end

local function ContinueReturnToVehicle(unit)
    if not EntityAlive(unit.driver) or not EntityAlive(unit.vehicle) then return false, "invalid" end
    if UnitCrewIsSeated(unit) then
        SetVehicleHandbrake(unit.vehicle, false)
        ApplyChaseTask(unit, PoliceChase.target.ped, true)
        return true, "resumed"
    end

    local driverSeat = GetPedInVehicleSeat(unit.vehicle, -1)
    if driverSeat ~= 0 and driverSeat ~= unit.driver then return false, "occupied" end
    if GetGameTimer() >= NumberOr(unit.transitionDeadline, 0) then
        local vehicleVisible = IsEntityOnScreen(unit.vehicle)
        for _, occupant in ipairs(UnitCrew(unit)) do
            local ped = occupant.ped
            if EntityAlive(ped) and GetPedInVehicleSeat(unit.vehicle, occupant.seat) ~= ped then
                local seatPed = GetPedInVehicleSeat(unit.vehicle, occupant.seat)
                if seatPed == 0 then
                    if not vehicleVisible and not IsEntityOnScreen(ped) then
                        SetPedIntoVehicle(ped, unit.vehicle, occupant.seat)
                    else
                        TaskEnterVehicle(ped, unit.vehicle, 5000, occupant.seat, 3.0, 1, 0)
                    end
                end
            end
        end
        unit.transitionDeadline = GetGameTimer() + 3000
    end
    return true, "waiting"
end

local function ShouldBeginOnFootResponse(unit)
    local settings = PoliceChase.config.onFootResponse
    if PoliceChase.replayLock == true or not settings.enabled or not settings.exitVehicle or PoliceChase.target.vehicle ~= 0 then return false end
    if not EntityAlive(unit.vehicle) or not EntityAlive(unit.driver) then return false end
    local distance = DistanceBetween(GetEntityCoords(unit.vehicle), GetEntityCoords(PoliceChase.target.ped))
    if distance > settings.distance then return false end
    local elapsed = GetGameTimer() - NumberOr(PoliceChase.target.onFootSince, GetGameTimer())
    return PoliceChase.target.lastVehicleSpeed <= settings.vehicleStopSpeed or elapsed >= settings.graceMs
end

local function UpdateGroundUnitBehavior(unit, targetChanged)
    if not LivingCrewPed(unit) then return false, "crew lost" end
    if unit.driver == PlayerPedId() then return false, "invalid driver ownership" end
    local targetPed = PoliceChase.target.ped
    if not EntityAlive(targetPed) then return true end

    -- Killing the driver or destroying the parked car must not delete the
    -- surviving officers. Stranded crews continue fighting on foot.
    if not EntityAlive(unit.driver) or not EntityAlive(unit.vehicle) then
        if unit.mode ~= "on_foot" then
            if unit.mode ~= "exiting" then
                unit.mode = "exiting"
                unit.transitionDeadline = 0
            end
            ContinueOnFootTransition(unit, targetPed)
        else
            ArmOfficerForTarget(unit, targetPed)
        end
        return true
    end

    if PoliceChase.target.vehicle ~= 0 or PoliceChase.replayLock == true then
        if unit.mode == "vehicle" then
            if GetPedInVehicleSeat(unit.vehicle, -1) ~= unit.driver then
                if IsPedInVehicle(unit.driver, unit.vehicle, false) then return false, "driver seat lost" end
                return BeginReturnToVehicle(unit), "returning"
            end
            ApplyChaseTask(unit, targetPed, targetChanged)
            return true
        end

        if unit.mode == "returning" then
            local ok, reason = ContinueReturnToVehicle(unit)
            return ok, reason
        end

        if unit.mode == "braking" and IsPedInVehicle(unit.driver, unit.vehicle, false) then
            SetVehicleHandbrake(unit.vehicle, false)
            ApplyChaseTask(unit, targetPed, true)
            return true
        end

        return BeginReturnToVehicle(unit), "returning"
    end

    if not PoliceChase.config.onFootResponse.enabled or not PoliceChase.config.onFootResponse.exitVehicle then
        if unit.mode == "vehicle" then
            ApplyChaseTask(unit, targetPed, targetChanged)
            return true
        end
        if unit.mode == "returning" then
            local ok, reason = ContinueReturnToVehicle(unit)
            return ok, reason
        end
        if (unit.mode == "braking" or unit.mode == "exiting") and GetPedInVehicleSeat(unit.vehicle, -1) == unit.driver then
            SetVehicleHandbrake(unit.vehicle, false)
            ApplyChaseTask(unit, targetPed, true)
            return true
        end
        return BeginReturnToVehicle(unit), "returning"
    end

    if unit.mode == "vehicle" then
        if ShouldBeginOnFootResponse(unit) then BeginOnFootTransition(unit) end
        return true
    end

    if unit.mode == "braking" or unit.mode == "exiting" then
        ContinueOnFootTransition(unit, targetPed)
        return true
    end

    if unit.mode == "returning" then
        -- The target got out again before our crew finished boarding.
        unit.mode = "braking"
        unit.transitionDeadline = 0
        ContinueOnFootTransition(unit, targetPed)
        return true
    end

    if unit.mode == "on_foot" then
        if targetChanged or unit.targetPed ~= targetPed or GetGameTimer() >= NumberOr(unit.nextRetaskAt, 0) then
            ArmOfficerForTarget(unit, targetPed)
        end
        return true
    end

    unit.mode = "vehicle"
    return true
end

local function RemoveUnitAt(index, reason, preserveCasualties)
    local unit = PoliceChase.units[index]
    if not unit then return end
    CleanupGroundUnit(unit, reason, preserveCasualties)
    table.remove(PoliceChase.units, index)
end

local function SpawnMissingGroundUnits(token, maximumPerPass)
    if not CurrentTokenMatches(token) or PoliceChase.spawnBusy then return 0 end
    PoliceChase.spawnBusy = true
    local spawned = 0
    local limit = maximumPerPass or math.huge
    local stagger = Round(Clamp(ConfigNumber("SpawnStaggerDelay", 300), 0, 5000))

    while CurrentTokenMatches(token) and #PoliceChase.units < PoliceChase.desiredUnits and spawned < limit do
        local unit, message = SpawnGroundUnit(#PoliceChase.units + 1, token)
        if not unit then
            if message and not message:find("cancelled", 1, true) then SetLastError(message) end
            break
        end
        PoliceChase.units[#PoliceChase.units + 1] = unit
        PoliceChase.lastError = nil
        spawned = spawned + 1
        if stagger > 0 and #PoliceChase.units < PoliceChase.desiredUnits then Wait(stagger) end
    end

    if CurrentTokenMatches(token) then PoliceChase.spawnBusy = false end
    return spawned
end

local function EnsureHelicopterModels(token, model)
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local valid, message, helicopterHash = ValidateVehicleModel(model, true)
    if not valid then return false, message end
    local pilotModel = ModelName(settings.PilotPedModel, "s_m_y_pilot_01")
    local pilotValid, pilotMessage, pilotHash = ValidatePedModel(pilotModel, "Helicopter pilot")
    if not pilotValid then return false, pilotMessage end

    for _, hash in ipairs({ helicopterHash, pilotHash }) do
        local loaded, reason = RequestModelWithTimeout(hash, 8000, token)
        if not loaded then
            if reason == "cancelled" then return false, "The helicopter request was cancelled" end
            return false, "A helicopter model could not be loaded"
        end
        PoliceChase.modelHashes[hash] = true
    end
    PoliceChase.modelHashesByRole = PoliceChase.modelHashesByRole or {}
    return true, nil, {
        helicopter = helicopterHash,
        pilot = pilotHash,
    }
end

local function MaintainHelicopter(token, targetChanged)
    if not PoliceChase.config.helicopter then
        if PoliceChase.helicopter then CleanupHelicopter("disabled") end
        PoliceChase.nextHelicopterSpawnAt = 0
        return
    end

    local helicopter = PoliceChase.helicopter
    local needsReplacement = type(helicopter) ~= "table" or not EntityAlive(helicopter.vehicle) or not EntityAlive(helicopter.pilot)
    if not needsReplacement and GetPedInVehicleSeat(helicopter.vehicle, -1) ~= helicopter.pilot then needsReplacement = true end
    if not needsReplacement then
        local targetCoords = GetEntityCoords(PoliceChase.target.ped)
        local distance = DistanceBetween(GetEntityCoords(helicopter.vehicle), targetCoords)
        if distance > ConfigNumber("HeliRespawnDistance", 400.0) and not IsEntityOnScreen(helicopter.vehicle) then needsReplacement = true end
    end

    if needsReplacement then
        CleanupHelicopter("replacement")
        if GetGameTimer() < NumberOr(PoliceChase.nextHelicopterSpawnAt, 0) then return end
        local spawned, message = SpawnPoliceHelicopter(token)
        if spawned then
            PoliceChase.helicopter = spawned
            PoliceChase.nextHelicopterSpawnAt = 0
        else
            PoliceChase.nextHelicopterSpawnAt = GetGameTimer() + 3000
            if message and not message:find("cancelled", 1, true) then DebugLog("Helicopter spawn deferred: %s", message) end
        end
        return
    end

    local now = GetGameTimer()
    local distance = DistanceBetween(GetEntityCoords(helicopter.vehicle), GetEntityCoords(PoliceChase.target.ped))
    local distanceRetaskDue = distance > ConfigNumber("HeliRetaskDistance", 80.0)
        and now >= NumberOr(helicopter.nextDistanceRetaskAt, 0)
    if targetChanged or distanceRetaskDue then
        AssignHelicopterTask(helicopter, PoliceChase.target.ped, true)
        helicopter.nextDistanceRetaskAt = now + 1500
    else
        AssignHelicopterTask(helicopter, PoliceChase.target.ped, false)
    end
end

local function StartControllerThreads(token)
    CreateThread(function()
        while CurrentTokenMatches(token) do
            local targetChanged = RefreshTargetContext()
            if EntityAlive(PoliceChase.target.ped) then
                for index = #PoliceChase.units, 1, -1 do
                    local ok, reason = UpdateGroundUnitBehavior(PoliceChase.units[index], targetChanged)
                    if not ok then RemoveUnitAt(index, reason or "behavior failed", true) end
                end
                MaintainHelicopter(token, targetChanged)
            end
            Wait(150)
        end
    end)

    CreateThread(function()
        local interval = Round(Clamp(ConfigNumber("KeepAliveInterval", 3000), 500, 15000))
        while CurrentTokenMatches(token) do
            local targetPed = PoliceChase.target.ped
            if EntityAlive(targetPed) then
                local targetCoords = GetEntityCoords(targetPed)
                local respawnDistance = ConfigNumber("RespawnDistance", 250.0)
                for index = #PoliceChase.units, 1, -1 do
                    local unit = PoliceChase.units[index]
                    local livingPed = LivingCrewPed(unit)
                    local invalid = not livingPed or unit.driver == PlayerPedId()
                    if not invalid then
                        local pursuitEntity = unit.mode == "vehicle" and unit.vehicle or livingPed
                        if not EntityExists(pursuitEntity) then pursuitEntity = unit.vehicle end
                        local distance = DistanceBetween(GetEntityCoords(pursuitEntity), targetCoords)
                        invalid = distance > respawnDistance and not IsEntityOnScreen(unit.vehicle) and not IsEntityOnScreen(unit.driver)
                        if invalid then
                            for _, occupant in ipairs(UnitCrew(unit)) do
                                if EntityAlive(occupant.ped) and (IsEntityOnScreen(occupant.ped)
                                    or DistanceBetween(GetEntityCoords(occupant.ped), targetCoords) <= respawnDistance) then
                                    invalid = false
                                    break
                                end
                            end
                        end
                    end
                    if invalid then RemoveUnitAt(index, "maintenance replacement", true) end
                end
                SpawnMissingGroundUnits(token, 1)
                MaintainHelicopter(token, false)
            end
            Wait(interval)
        end
    end)
end

function GetPoliceChaseStatus()
    local aliveUnits = 0
    local operationalUnits = 0
    local vehicleUnits = 0
    local onFootUnits = 0
    local returningUnits = 0
    local brakingUnits = 0
    local exitingUnits = 0
    local aliveOccupants = 0
    local configuredOccupants = 0
    for _, unit in ipairs(PoliceChase.units) do
        local livingPed = LivingCrewPed(unit)
        if EntityAlive(unit.vehicle) or livingPed then aliveUnits = aliveUnits + 1 end
        if EntityAlive(unit.vehicle) and EntityAlive(unit.driver) and unit.driver ~= PlayerPedId() then operationalUnits = operationalUnits + 1 end
        if EntityAlive(unit.driver) and EntityAlive(unit.vehicle) and IsPedInVehicle(unit.driver, unit.vehicle, false) then
            vehicleUnits = vehicleUnits + 1
        elseif livingPed then
            onFootUnits = onFootUnits + 1
        end
        if unit.mode == "returning" then returningUnits = returningUnits + 1 end
        if unit.mode == "braking" then brakingUnits = brakingUnits + 1 end
        if unit.mode == "exiting" then exitingUnits = exitingUnits + 1 end
        for _, occupant in ipairs(UnitCrew(unit)) do
            configuredOccupants = configuredOccupants + 1
            if EntityAlive(occupant.ped) then aliveOccupants = aliveOccupants + 1 end
        end
    end

    local helicopter = PoliceChase.helicopter
    local helicopterAlive = type(helicopter) == "table" and EntityAlive(helicopter.vehicle) and EntityAlive(helicopter.pilot)
    local targetPed = PlayerPedId()
    local targetVehicle = EntityExists(targetPed) and GetVehiclePedIsIn(targetPed, false) or 0
    return {
        ok = true,
        active = PoliceChase.active == true,
        phase = PoliceChase.phase,
        sessionId = PoliceChase.threadToken,
        busy = PoliceChase.operationBusy == true or PoliceChase.spawnBusy == true,
        totalUnits = #PoliceChase.units,
        aliveUnits = aliveUnits,
        operationalUnits = operationalUnits,
        desiredUnits = PoliceChase.desiredUnits,
        vehicleUnits = vehicleUnits,
        onFootUnits = onFootUnits,
        returningUnits = returningUnits,
        brakingUnits = brakingUnits,
        exitingUnits = exitingUnits,
        configuredOccupants = configuredOccupants,
        aliveOccupants = aliveOccupants,
        replayLocked = PoliceChase.replayLock == true,
        replayLockOwner = PoliceChase.replayLockOwner,
        helicopter = helicopterAlive,
        helicopterActive = helicopterAlive,
        helicopterAlive = helicopterAlive,
        target = {
            ped = targetPed,
            vehicle = targetVehicle,
            onFoot = targetVehicle == 0,
            alive = EntityAlive(targetPed),
        },
        config = CopyTable(PoliceChase.config),
        lastError = PoliceChase.lastError,
    }
end

function GetPoliceChaseConfig()
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local defaults = DefaultRuntimeConfig()
    local advanced = type(settings.AdvancedFleet) == "table" and settings.AdvancedFleet or {}
    local replay = type(settings.ChaseReplay) == "table" and settings.ChaseReplay or {}
    return {
        enabled = not RuntimeChaseDisabled(),
        minUnits = Round(Clamp(settings.MinUnits, 0, 32)),
        maxUnits = Round(Clamp(settings.MaxUnits, 1, 32)),
        vehicleOptions = CopyTable(settings.Vehicles or PoliceChaseVehicles),
        helicopterOptions = CopyTable(settings.Helicopters or PoliceChaseHelicopters),
        drivingPresets = CopyTable(settings.DrivingPresets or FALLBACK_DRIVING_PRESETS),
        defaults = defaults,
        protection = CopyTable(defaults.protection),
        onFootResponse = CopyTable(defaults.onFootResponse),
        advancedFleet = {
            enabled = advanced.Enabled ~= false,
            maxOccupantsPerUnit = Round(Clamp(advanced.MaxOccupantsPerUnit or 8, 1, 32)),
            weaponOptions = CopyTable(advanced.Weapons or {}),
        },
        weaponOptions = CopyTable(advanced.Weapons or {}),
        chaseReplay = {
            enabled = replay.Enabled ~= false,
            sampleIntervalMs = Round(Clamp(replay.SampleIntervalMs or 50, 10, 250)),
            maxDurationSeconds = Clamp(replay.MaxDurationSeconds or 300, 1, 600),
            maxVehicles = Round(Clamp(replay.MaxVehicles or 24, 1, 64)),
            maxTotalFrames = Round(Clamp(replay.MaxTotalFrames or 180000, 1000, 200000)),
        },
        distances = {
            deployment = defaults.deploymentDistance,
            minDeployment = ConfigNumber("MinDeploymentDistance", 18.0),
            maxDeployment = ConfigNumber("MaxDeploymentDistance", 120.0),
            spawnLateralSpacing = ConfigNumber("SpawnLateralSpacing", 5.0),
            follow = ConfigNumber("MinFollowDistance", 8.0),
            respawn = ConfigNumber("RespawnDistance", 250.0),
            retask = ConfigNumber("RetaskDistance", 50.0),
            helicopterSpawn = ConfigNumber("HeliSpawnDistance", 80.0),
            helicopterHeight = ConfigNumber("HeliSpawnHeight", 60.0),
            helicopterRespawn = ConfigNumber("HeliRespawnDistance", 400.0),
            helicopterRetask = ConfigNumber("HeliRetaskDistance", 80.0),
        },
        capabilities = {
            customVehicleModels = settings.AllowCustomVehicleModels == true,
            localEntities = true,
            liveSettings = true,
            onFootResponse = true,
            retargetsPlayerPed = true,
            advancedFleet = advanced.Enabled ~= false,
            savedVehicles = true,
            savedPeds = true,
            multipleOccupants = true,
            chaseReplay = replay.Enabled ~= false,
        },
    }
end

local function ReplayOccupantsForVehicle(vehicle, authoredCrew)
    local output = {}
    local seen = {}
    for _, occupant in ipairs(type(authoredCrew) == "table" and authoredCrew or {}) do
        local ped = occupant.ped or occupant.handle
        if EntityExists(ped) and not seen[ped] then
            output[#output + 1] = {
                ped = ped,
                handle = ped,
                seat = NumberOr(occupant.seat, -1),
                role = occupant.role or (NumberOr(occupant.seat, -1) == -1 and "driver" or "passenger"),
                savedPedId = occupant.savedPedId,
                model = occupant.model,
                appearance = occupant.appearance and CopyTable(occupant.appearance) or nil,
            }
            seen[ped] = true
        end
    end
    if EntityExists(vehicle) then
        local maximumPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
        for seat = -1, maximumPassengers - 1 do
            local ped = GetPedInVehicleSeat(vehicle, seat)
            if EntityExists(ped) and not seen[ped] then
                output[#output + 1] = {
                    ped = ped,
                    handle = ped,
                    seat = seat,
                    role = seat == -1 and "driver" or "passenger",
                }
                seen[ped] = true
            end
        end
    end
    return output
end

function GetPoliceChaseReplayParticipants()
    local participants = {}
    local seenVehicles = {}
    local function append(vehicle, role, id, crew, extra)
        if not EntityExists(vehicle) or seenVehicles[vehicle] then return end
        seenVehicles[vehicle] = true
        local descriptor = {
            id = tostring(id or (role .. ":" .. vehicle)),
            role = role,
            entity = vehicle,
            vehicle = vehicle,
            handle = vehicle,
            modelHash = GetEntityModel(vehicle),
            occupants = ReplayOccupantsForVehicle(vehicle, crew),
        }
        for key, value in pairs(type(extra) == "table" and extra or {}) do descriptor[key] = value end
        participants[#participants + 1] = descriptor
    end

    local targetPed = PlayerPedId()
    local targetVehicle = EntityExists(targetPed) and GetVehiclePedIsIn(targetPed, false) or 0
    if targetVehicle == 0 and EntityExists(PoliceChase.target.lastVehicle) then targetVehicle = PoliceChase.target.lastVehicle end
    append(targetVehicle, "target", "target", nil, { isTarget = true })

    for index, unit in ipairs(PoliceChase.units) do
        append(unit.vehicle, "ground_unit", unit.id or index, UnitCrew(unit), {
            unitIndex = index,
            vehicleDefinition = unit.vehicleDefinition and CopyTable(unit.vehicleDefinition) or nil,
            onFootWeapon = unit.onFootWeapon,
        })
    end

    if type(PoliceChase.helicopter) == "table" then
        append(PoliceChase.helicopter.vehicle, "helicopter", "helicopter", {
            { ped = PoliceChase.helicopter.pilot, seat = -1, role = "pilot" },
        }, { isHelicopter = true })
    end
    return participants
end

function SetPoliceChaseReplayLock(active, owner)
    local requestedOwner = tostring(owner or "legacy")
    local currentOwner = PoliceChase.replayLockOwner

    if active == true then
        if PoliceChase.replayLock == true and currentOwner ~= nil and currentOwner ~= requestedOwner then
            return false, ("The Chase replay lock is owned by %s"):format(currentOwner)
        end
        PoliceChase.replayLock = true
        PoliceChase.replayLockOwner = requestedOwner
    else
        if PoliceChase.replayLock == true and currentOwner ~= nil and currentOwner ~= requestedOwner then
            return false, ("The Chase replay lock is owned by %s"):format(currentOwner)
        end
        PoliceChase.replayLock = false
        PoliceChase.replayLockOwner = nil
    end

    if PoliceChase.replayLock and PoliceChase.active then
        for _, unit in ipairs(PoliceChase.units) do
            if unit.mode ~= "vehicle" and unit.mode ~= "returning" then BeginReturnToVehicle(unit) end
        end
    end
    return true, PoliceChase.replayLockOwner
end

function StopPoliceChase()
    local wasActive = PoliceChase.active == true or #PoliceChase.units > 0 or PoliceChase.helicopter ~= nil
    PoliceChase.threadToken = PoliceChase.threadToken + 1
    PoliceChase.active = false
    PoliceChase.phase = "stopping"
    PoliceChase.operationBusy = false
    PoliceChase.spawnBusy = false
    PoliceChase.nextHelicopterSpawnAt = 0
    PoliceChase.desiredUnits = 0
    CleanupAllEntities("stop")
    ReleaseModelHashes(PoliceChase.modelHashes)
    PoliceChase.modelHashes = {}
    PoliceChase.modelHashesByRole = nil
    PoliceChase.preparedUnits = {}
    PoliceChase.target = { ped = 0, vehicle = 0, lastVehicle = 0, lastVehicleSpeed = 0.0, onFootSince = nil }
    PoliceChase.phase = "idle"
    PoliceChase.lastError = nil
    local message = wasActive and "Chase stopped" or "Chase is already stopped"
    return true, message, GetPoliceChaseStatus()
end

function StartPoliceChase(config)
    if PoliceChase.replayLock == true and PoliceChase.replayLockOwner ~= "recording" then
        return false, "Stop Chase Replay playback before starting a new Chase", GetPoliceChaseStatus()
    end
    if RuntimeChaseDisabled() then
        return false, "Chase is disabled by the server configuration", GetPoliceChaseStatus()
    end

    local requested = NormalizeRuntimeConfig(config, DefaultRuntimeConfig())
    local requiresClassicVehicle = requested.advancedEnabled ~= true
    if requested.advancedEnabled == true then
        requiresClassicVehicle = false
        for unitIndex = 1, requested.numUnits do
            local setup = requested.unitSetups[unitIndex]
            local source = type(setup) == "table" and setup.vehicleSource or "default"
            if source ~= "saved" and source ~= "model" then
                requiresClassicVehicle = true
                break
            end
        end
    end
    if requiresClassicVehicle then
        local valid, message = ValidateVehicleModel(requested.vehicleModel, false)
        if not valid then return false, message, GetPoliceChaseStatus() end
    end
    if requested.helicopter then
        local heliValid, heliMessage = ValidateVehicleModel(requested.helicopterModel, true)
        if not heliValid then return false, heliMessage, GetPoliceChaseStatus() end
    end

    -- A new session supersedes a running or partially-started request. The
    -- token is changed before any yielding model/spawn operation.
    PoliceChase.threadToken = PoliceChase.threadToken + 1
    local token = PoliceChase.threadToken
    PoliceChase.active = false
    CleanupAllEntities("superseded by start")
    ReleaseModelHashes(PoliceChase.modelHashes)
    PoliceChase.modelHashes = {}
    PoliceChase.modelHashesByRole = nil
    PoliceChase.preparedUnits = {}
    PoliceChase.nextHelicopterSpawnAt = 0

    PoliceChase.config = requested
    PoliceChase.desiredUnits = requested.numUnits
    PoliceChase.active = true
    PoliceChase.phase = "starting"
    PoliceChase.operationBusy = true
    PoliceChase.spawnBusy = false
    PoliceChase.lastError = nil
    PoliceChase.target = { ped = 0, vehicle = 0, lastVehicle = 0, lastVehicleSpeed = 0.0, onFootSince = nil }
    RefreshTargetContext()

    local prepared, prepareMessage = PrepareModels(requested, token)
    if not prepared then
        if CurrentTokenMatches(token) then
            SetLastError(prepareMessage)
            PoliceChase.active = false
            PoliceChase.phase = "idle"
            PoliceChase.operationBusy = false
            CleanupAllEntities("start failed")
            ReleaseModelHashes(PoliceChase.modelHashes)
            PoliceChase.modelHashes = {}
            PoliceChase.modelHashesByRole = nil
            PoliceChase.preparedUnits = {}
        end
        return false, prepareMessage, GetPoliceChaseStatus()
    end

    local spawned = SpawnMissingGroundUnits(token, requested.numUnits)
    if not CurrentTokenMatches(token) then return false, "The Chase request was cancelled", GetPoliceChaseStatus() end
    if spawned <= 0 or #PoliceChase.units <= 0 then
        local failure = PoliceChase.lastError or "No police units could be deployed safely"
        SetLastError(failure)
        PoliceChase.active = false
        PoliceChase.phase = "idle"
        PoliceChase.operationBusy = false
        CleanupAllEntities("zero units spawned")
        ReleaseModelHashes(PoliceChase.modelHashes)
        PoliceChase.modelHashes = {}
        PoliceChase.modelHashesByRole = nil
        PoliceChase.preparedUnits = {}
        return false, failure, GetPoliceChaseStatus()
    end

    if requested.helicopter then
        local helicopter, helicopterMessage = SpawnPoliceHelicopter(token)
        if helicopter then
            PoliceChase.helicopter = helicopter
            PoliceChase.nextHelicopterSpawnAt = 0
        else
            PoliceChase.nextHelicopterSpawnAt = GetGameTimer() + 3000
            if helicopterMessage then DebugLog("Initial helicopter deferred: %s", helicopterMessage) end
        end
    end

    PoliceChase.phase = "running"
    PoliceChase.operationBusy = false
    StartControllerThreads(token)
    local resultMessage = #PoliceChase.units < requested.numUnits
        and ("Chase started with %d of %d requested units"):format(#PoliceChase.units, requested.numUnits)
        or ("Chase started with %d units"):format(#PoliceChase.units)
    return true, resultMessage, GetPoliceChaseStatus()
end

function AddPoliceUnit()
    if not PoliceChase.active then return false, "Start the Chase before adding units", GetPoliceChaseStatus() end
    if PoliceChase.operationBusy or PoliceChase.spawnBusy then return false, "The Chase is busy updating units", GetPoliceChaseStatus() end
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local maximum = Round(Clamp(settings.MaxUnits, 1, 32))
    if PoliceChase.desiredUnits >= maximum then return false, "The maximum number of Chase units is already active", GetPoliceChaseStatus() end

    local token = PoliceChase.threadToken
    PoliceChase.spawnBusy = true
    PoliceChase.desiredUnits = PoliceChase.desiredUnits + 1
    PoliceChase.config.numUnits = PoliceChase.desiredUnits
    local newIndex = PoliceChase.desiredUnits
    local previousSetup = PoliceChase.config.unitSetups[newIndex - 1]
    PoliceChase.config.unitSetups[newIndex] = NormalizeUnitSetup(nil, previousSetup, PoliceChase.config.vehicleModel)
    local preparedFallback = PoliceChase.preparedUnits[newIndex - 1] or PoliceChase.preparedUnits[1]
    PoliceChase.preparedUnits[newIndex] = preparedFallback and CopyTable(preparedFallback) or nil
    local unit, message = SpawnGroundUnit(#PoliceChase.units + 1, token)
    if unit and CurrentTokenMatches(token) then PoliceChase.units[#PoliceChase.units + 1] = unit end
    if CurrentTokenMatches(token) then PoliceChase.spawnBusy = false end

    if not unit then
        if CurrentTokenMatches(token) then
            PoliceChase.desiredUnits = math.max(0, PoliceChase.desiredUnits - 1)
            PoliceChase.config.numUnits = PoliceChase.desiredUnits
            PoliceChase.config.unitSetups[newIndex] = nil
            PoliceChase.preparedUnits[newIndex] = nil
            SetLastError(message)
        end
        return false, message or "The police unit could not be added", GetPoliceChaseStatus()
    end
    PoliceChase.lastError = nil
    return true, "Police unit added", GetPoliceChaseStatus()
end

function RemovePoliceUnit()
    if not PoliceChase.active then return false, "The Chase is not active", GetPoliceChaseStatus() end
    if PoliceChase.operationBusy or PoliceChase.spawnBusy then return false, "The Chase is busy updating units", GetPoliceChaseStatus() end
    local settings = (Config and Config.PoliceChase) or ChaseSettings
    local minimum = Round(Clamp(settings.MinUnits, 0, 32))
    if PoliceChase.desiredUnits <= minimum or #PoliceChase.units <= minimum then
        return false, "The minimum number of Chase units is already active", GetPoliceChaseStatus()
    end
    PoliceChase.desiredUnits = PoliceChase.desiredUnits - 1
    PoliceChase.config.numUnits = PoliceChase.desiredUnits
    RemoveUnitAt(#PoliceChase.units, "removed by user")
    PoliceChase.config.unitSetups[PoliceChase.desiredUnits + 1] = nil
    PoliceChase.preparedUnits[PoliceChase.desiredUnits + 1] = nil
    PoliceChase.lastError = nil
    return true, "Police unit removed", GetPoliceChaseStatus()
end

function FixPoliceVehicles()
    if not PoliceChase.active then return false, "The Chase is not active", GetPoliceChaseStatus() end
    local fixed = 0
    for _, unit in ipairs(PoliceChase.units) do
        if EntityExists(unit.vehicle) then
            SetVehicleFixed(unit.vehicle)
            SetVehicleDeformationFixed(unit.vehicle)
            SetVehicleDirtLevel(unit.vehicle, 0.0)
            SetVehicleEngineOn(unit.vehicle, true, true, false)
            ApplyVehicleProtection(unit.vehicle, PoliceChase.config.protection.vehicles)
            fixed = fixed + 1
        end
        ApplyCrewProtection(unit, PoliceChase.config.protection)
    end
    if PoliceChase.helicopter and EntityExists(PoliceChase.helicopter.vehicle) then
        SetVehicleFixed(PoliceChase.helicopter.vehicle)
        SetVehicleEngineOn(PoliceChase.helicopter.vehicle, true, true, false)
        SetHeliBladesFullSpeed(PoliceChase.helicopter.vehicle)
        ApplyVehicleProtection(PoliceChase.helicopter.vehicle, PoliceChase.config.protection.helicopter)
        ApplyPedProtection(PoliceChase.helicopter.pilot, PoliceChase.config.protection.pilot)
        fixed = fixed + 1
    end
    PoliceChase.lastError = nil
    return true, ("Repaired %d Chase vehicles"):format(fixed), GetPoliceChaseStatus()
end

function UpdatePoliceChaseSettings(patch)
    patch = type(patch) == "table" and patch or {}
    if PoliceChase.operationBusy or PoliceChase.spawnBusy then return false, "The Chase is busy updating units", GetPoliceChaseStatus() end
    local previous = PoliceChase.config
    local updated = NormalizeRuntimeConfig(patch, previous)

    if PoliceChase.active and updated.vehicleModel ~= previous.vehicleModel then
        return false, "Changing the ground vehicle model requires restarting the Chase", GetPoliceChaseStatus()
    end
    if PoliceChase.active and (type(patch.unitSetup) == "table" or type(patch.unitSetups) == "table") then
        return false, "Changing Chase vehicles, seats or cast requires restarting the Chase", GetPoliceChaseStatus()
    end

    if not PoliceChase.active then
        PoliceChase.config = updated
        PoliceChase.desiredUnits = updated.numUnits
        return true, "Chase defaults updated", GetPoliceChaseStatus()
    end

    local token = PoliceChase.threadToken
    PoliceChase.operationBusy = true

    -- Replacing a helicopter is transactional: prepare and spawn the new
    -- local pair first. A bad addon model must never destroy a working unit
    -- or silently mutate the current Chase settings.
    local currentHelicopter = PoliceChase.helicopter
    local currentHelicopterValid = type(currentHelicopter) == "table"
        and EntityAlive(currentHelicopter.vehicle)
        and EntityAlive(currentHelicopter.pilot)
        and GetPedInVehicleSeat(currentHelicopter.vehicle, -1) == currentHelicopter.pilot
    local helicopterNeedsReplacement = updated.helicopter and (
        not previous.helicopter
        or updated.helicopterModel ~= previous.helicopterModel
        or not currentHelicopterValid
    )
    local replacementHelicopter = nil
    local replacementHashes = nil

    if helicopterNeedsReplacement then
        local ready, readyMessage, preparedHashes = EnsureHelicopterModels(token, updated.helicopterModel)
        if not ready then
            if CurrentTokenMatches(token) then
                PoliceChase.operationBusy = false
                SetLastError(readyMessage)
            end
            return false, readyMessage or "The helicopter models could not be prepared", GetPoliceChaseStatus()
        end

        if not CurrentTokenMatches(token) then
            return false, "The Chase update was cancelled", GetPoliceChaseStatus()
        end

        local spawnMessage
        replacementHelicopter, spawnMessage = SpawnPoliceHelicopter(token, updated, preparedHashes)
        if not replacementHelicopter then
            if CurrentTokenMatches(token) then
                PoliceChase.operationBusy = false
                PoliceChase.nextHelicopterSpawnAt = GetGameTimer() + 3000
                SetLastError(spawnMessage)
            end
            return false, spawnMessage or "The replacement helicopter could not be created", GetPoliceChaseStatus()
        end
        replacementHashes = preparedHashes
    end

    if not CurrentTokenMatches(token) then
        if replacementHelicopter then
            DeleteOwnedPed(replacementHelicopter.pilot)
            DeleteOwnedVehicle(replacementHelicopter.vehicle, replacementHelicopter.pilot)
        end
        return false, "The Chase update was cancelled", GetPoliceChaseStatus()
    end

    PoliceChase.config = updated
    PoliceChase.desiredUnits = updated.numUnits

    if replacementHelicopter then
        CleanupHelicopter("live replacement committed")
        PoliceChase.helicopter = replacementHelicopter
        PoliceChase.modelHashesByRole = PoliceChase.modelHashesByRole or {}
        PoliceChase.modelHashesByRole.helicopter = replacementHashes.helicopter
        PoliceChase.modelHashesByRole.pilot = replacementHashes.pilot
        PoliceChase.nextHelicopterSpawnAt = 0
    elseif not updated.helicopter then
        CleanupHelicopter("disabled by live settings")
        PoliceChase.nextHelicopterSpawnAt = 0
    end

    while CurrentTokenMatches(token) and #PoliceChase.units > PoliceChase.desiredUnits do
        RemoveUnitAt(#PoliceChase.units, "live unit reduction")
    end
    if CurrentTokenMatches(token) and #PoliceChase.units < PoliceChase.desiredUnits then
        SpawnMissingGroundUnits(token, PoliceChase.desiredUnits - #PoliceChase.units)
    end

    if not CurrentTokenMatches(token) then return false, "The Chase update was cancelled", GetPoliceChaseStatus() end

    for _, unit in ipairs(PoliceChase.units) do
        ConfigurePoliceVehicle(unit.vehicle, updated.protection, updated.sirens)
        ApplyCrewProtection(unit, updated.protection)
        if previous.onFootResponse.weapon ~= updated.onFootResponse.weapon
            or previous.onFootResponse.ammo ~= updated.onFootResponse.ammo
            or previous.onFootResponse.accuracy ~= updated.onFootResponse.accuracy then
            for _, occupant in ipairs(UnitCrew(unit)) do occupant.combatTarget = nil end
            unit.nextRetaskAt = 0
        end
        if unit.mode == "vehicle" then ApplyChaseTask(unit, PlayerPedId(), true) end
    end

    if updated.helicopter and PoliceChase.helicopter then
        ApplyVehicleProtection(PoliceChase.helicopter.vehicle, updated.protection.helicopter)
        ApplyPedProtection(PoliceChase.helicopter.pilot, updated.protection.pilot)
        AssignHelicopterTask(PoliceChase.helicopter, PlayerPedId(), true)
    end

    if CurrentTokenMatches(token) then
        PoliceChase.operationBusy = false
        local helicopterReady = not updated.helicopter or PoliceChase.helicopter ~= nil
        if #PoliceChase.units >= PoliceChase.desiredUnits and helicopterReady then PoliceChase.lastError = nil end
    end
    return true, "Chase settings updated", GetPoliceChaseStatus()
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    StopPoliceChase()
end)
