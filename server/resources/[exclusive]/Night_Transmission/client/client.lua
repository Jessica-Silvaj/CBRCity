local mode = "auto"
local manualGear = 1
local overRevTimer = 0.0
local isHUDActive = false

local currentVehicle = nil

RegisterNetEvent("transmissao:client:receiveMode", function(serverMode)
    mode = serverMode
    if mode == "manual" then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        manualGear = GetVehicleCurrentGear(veh)
        if manualGear == 0 then manualGear = 1 end
    end
end)

RegisterNetEvent("transmissao:client:updateVehicleMode", function(plate, newMode)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh and GetVehicleNumberPlateText(veh) == plate then
        mode = newMode
        if mode == "manual" then
            manualGear = GetVehicleCurrentGear(veh)
            if manualGear == 0 then manualGear = 1 end
        end
    end
end)

local displayRpmGlobal = 0.0
local displayGearGlobal = 0

-- Exports
exports("getTransmissionState", function()
    return {
        mode = mode,
        gear = displayGearGlobal,
        rpm = displayRpmGlobal
    }
end)
exports("getGear", function() return manualGear end)
exports("getRPM", function() 
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh and veh ~= 0 then return GetVehicleCurrentRpm(veh) end
    return 0.0 
end)
exports("getEngineState", function() 
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh and veh ~= 0 then return GetVehicleEngineHealth(veh) end
    return 1000.0
end)

local requestShiftUp = false
local requestShiftDown = false
local requestToggle = false
local clutchPressed = false

RegisterCommand('+transmissao_shiftup', function() requestShiftUp = true end, false)
RegisterKeyMapping('+transmissao_shiftup', 'Transmissao: Subir Marcha', 'keyboard', 'LSHIFT')

RegisterCommand('+transmissao_shiftdown', function() requestShiftDown = true end, false)
RegisterKeyMapping('+transmissao_shiftdown', 'Transmissao: Reduzir Marcha', 'keyboard', 'LCONTROL')

RegisterCommand('+transmissao_clutch', function() clutchPressed = true end, false)
RegisterCommand('-transmissao_clutch', function() clutchPressed = false end, false)
RegisterKeyMapping('+transmissao_clutch', 'Transmissao: Embreagem', 'keyboard', 'X')

CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if GetPedInVehicleSeat(vehicle, -1) == ped and not IsVehicleIgnored(vehicle) then
                sleep = 0
                
                local currentSpeed = GetEntitySpeed(vehicle)
                local gameGear = GetVehicleCurrentGear(vehicle)
                local engineHealth = GetVehicleEngineHealth(vehicle)
                local isRunning = GetIsVehicleEngineRunning(vehicle)
                
                if currentVehicle ~= vehicle then
                    currentVehicle = vehicle
                    mode = "auto"
                    TriggerServerEvent("transmissao:server:requestMode", GetVehicleNumberPlateText(vehicle))
                end
                
                local displayRpm = 0.0
                local displayGear = 0
                
                if mode == "manual" then
                    displayGear = manualGear
                    
                    -- Shift Up
                    if requestShiftUp then
                        requestShiftUp = false
                        if manualGear < 6 then
                            if Config.RequireClutch and not clutchPressed then
                                engineHealth = engineHealth - Config.ClutchMissDamage
                                SetVehicleEngineHealth(vehicle, engineHealth)
                                PlayGrindSound(vehicle)
                            else
                                manualGear = manualGear + 1
                                PlayShiftSound(vehicle)
                            end
                        end
                    end
                    
                    -- Shift Down
                    if requestShiftDown then
                        requestShiftDown = false
                        if manualGear > -1 then
                            if Config.RequireClutch and not clutchPressed then
                                engineHealth = engineHealth - Config.ClutchMissDamage
                                SetVehicleEngineHealth(vehicle, engineHealth)
                                PlayGrindSound(vehicle)
                            else
                                manualGear = manualGear - 1
                                PlayShiftSound(vehicle)
                                
                                -- Over-rev check on downshift
                                if currentSpeed > (manualGear * 12.0) and manualGear > 0 then
                                    if Config.DamageEnabled then
                                        engineHealth = engineHealth - Config.OverRevDamage
                                        SetVehicleEngineHealth(vehicle, engineHealth)
                                        PlayGrindSound(vehicle)
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Reverse and Forward constraints
                    if manualGear == -1 then
                        SetVehicleHighGear(vehicle, 1) -- Jogo usa 0 nativamente pra ré, o limite não afeta.
                        if currentSpeed < 0.5 and IsControlPressed(0, 71) and not IsControlPressed(0, 72) then
                            DisableControlAction(0, 71, true) -- Disable W (Accelerate Forward) when stopped
                            SetVehicleForwardSpeed(vehicle, 0.0)
                        end
                    elseif manualGear == 0 then
                        -- Neutral
                        SetVehicleHighGear(vehicle, 1)
                        SetVehicleEngineTorqueMultiplier(vehicle, 0.0)
                        
                        -- Simulate RPM when pressing gas in Neutral
                        local accelInput = GetControlNormal(0, 71)
                        if accelInput > 0.0 then
                            local simulatedRpm = 0.2 + (accelInput * 0.75)
                            if simulatedRpm > 0.98 then simulatedRpm = 0.98 end
                            SetVehicleCurrentRpm(vehicle, simulatedRpm)
                            displayRpm = simulatedRpm
                        end
                    else
                        SetVehicleHighGear(vehicle, manualGear)
                        if currentSpeed < 0.5 and IsControlPressed(0, 72) and not IsControlPressed(0, 71) then
                            DisableControlAction(0, 72, true) -- Disable S (Brake/Reverse)
                            SetVehicleForwardSpeed(vehicle, 0.0)
                        end
                    end
                    
                    -- Engine Logic
                    if isRunning then
                        displayRpm = GetVehicleCurrentRpm(vehicle)
                        
                        -- Lugging simulation (Veículo "manco" se a marcha for muito alta para a velocidade)
                        if manualGear > 0 and manualGear > gameGear then
                            local diff = manualGear - gameGear
                            -- Reduz a potência gradualmente. Ignoramos diff == 1 para não prejudicar subidas ou trocas normais.
                            if diff > 1 then
                                local torqueMult = 1.0 / diff
                                SetVehicleEngineTorqueMultiplier(vehicle, torqueMult)
                            end
                        end
                        
                        -- Stall logic
                        if Config.StallEnabled and manualGear >= 1 and currentSpeed < 1.0 and not clutchPressed then
                            SetVehicleEngineOn(vehicle, false, true, true)
                        end
                        
                        -- Rev Limiter, Engine Braking & Over rev logic
                        -- Se a velocidade for maior do que a marcha suporta (redução brusca), aplica freio motor forte
                        if manualGear > 0 and currentSpeed > (manualGear * 12.0) and not clutchPressed then
                            SetVehicleForwardSpeed(vehicle, currentSpeed * 0.99) -- Desacelera o veículo progressivamente
                            SetVehicleEngineTorqueMultiplier(vehicle, -1.0)
                        elseif displayRpm > 0.98 then
                            -- Cut power completely at redline to prevent gaining more speed
                            SetVehicleEngineTorqueMultiplier(vehicle, -0.1) -- Slight engine braking
                        elseif displayRpm > 0.95 then
                            SetVehicleEngineTorqueMultiplier(vehicle, 0.1) -- Drop power
                        end

                        if gameGear == manualGear and displayRpm > 0.95 then
                            overRevTimer = overRevTimer + GetFrameTime()
                            if overRevTimer > Config.OverRevTimeLimit then
                                if Config.DamageEnabled then
                                    SetVehicleEngineHealth(vehicle, engineHealth - (Config.OverRevTickDamage * GetFrameTime()))
                                end
                                if math.random() > 0.95 then
                                    PlayBackfireSound(vehicle)
                                end
                            end
                        else
                            overRevTimer = 0.0
                        end
                    end
                    
                else
                    -- Auto Mode
                    displayGear = gameGear
                    if gameGear == 0 then
                        displayGear = -1 -- Show R instead of 0
                    end
                    if currentSpeed < 0.5 and IsControlPressed(0, 72) and not IsControlPressed(0, 71) then
                        displayGear = -1
                    end
                    if isRunning then
                        displayRpm = GetVehicleCurrentRpm(vehicle)
                    end
                end
                
                -- Engine destroyed logic
                if engineHealth <= -4000.0 then
                    SetVehicleEngineOn(vehicle, false, true, true)
                end
                
                displayRpmGlobal = displayRpm
                displayGearGlobal = displayGear
                
                -- HUD Display
                if Config.EnableHUD then
                    isHUDActive = true
                    UpdateHUD({
                        rpm = displayRpm,
                        gear = displayGear,
                        speed = currentSpeed * 3.6,
                        mode = mode,
                        engineHealth = engineHealth
                    })
                elseif isHUDActive then
                    HideHUD()
                    isHUDActive = false
                end
                
            else
                if isHUDActive then
                    HideHUD()
                    isHUDActive = false
                end
                currentVehicle = nil
            end
        else
            if isHUDActive then
                HideHUD()
                isHUDActive = false
            end
            currentVehicle = nil
        end
        
        Wait(sleep)
    end
end)
