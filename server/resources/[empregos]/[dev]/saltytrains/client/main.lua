local npcEntities = {}
local activeNpcState = {}
local lastInteractionTime = 0
local jobSession = nil
local xpDisplayQueue = {}
local xpDisplayCounter = 0
local ghostTrainActive = false

function PreloadTrainModels()
    local models = {
        "freight", "metrotrain", "freightcont1",
        "freightcar", "freightcar2", "freightcont2",
        "tankercar", "freightgrain"
    }
    for _, modelName in ipairs(models) do
        local hash = GetHashKey(modelName)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(500)
        end
    end
end

PreloadTrainModels()

function ManageNPC(mode, distanceToNpc)
    if distanceToNpc < 100.0 then
        if npcEntities[mode] then return end

        local npcConfig = Config.Positions[mode].NPC
        local modelHash = GetHashKey(npcConfig.model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(500)
        end

        local ped = CreatePed(4, modelHash, npcConfig.coords.x, npcConfig.coords.y, npcConfig.coords.z - 1.0, npcConfig.heading, false, false)
        npcEntities[mode] = ped

        SetEntityInvincible(ped, true)
        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedFleeAttributes(ped, 0, 0)

        if Config.TargetSystem then
            addTarget(ped, "saltytrains_target_" .. mode, mode)
        end
    else
        if not npcEntities[mode] then return end

        SetEntityAsMissionEntity(npcEntities[mode], false, false)
        DeleteEntity(npcEntities[mode])
        npcEntities[mode] = nil

        if Config.TargetSystem then
            exports.ox_target:removeLocalEntity(npcEntities[mode], "saltytrains_target_" .. mode, mode)
        end
    end
end

Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(500)
    end
    SetTrainsForceDoorsOpen(false)
    SwitchTrainTrack(0, true)
    SwitchTrainTrack(3, true)
    SetRandomTrains(false)
end)

Citizen.CreateThread(function()
    if not Config.ShowBlips then return end

    for mode, posData in pairs(Config.Positions) do
        local blip = AddBlipForCoord(posData.NPC.coords)
        local blipConfig = Config.Blips[mode] or {}

        SetBlipSprite(blip, blipConfig.sprite or 795)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, blipConfig.scale or 0.8)
        SetBlipColour(blip, blipConfig.color or 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipConfig.name or "Trainjob")
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        local waitTime = 10000
        local playerCoords = GetEntityCoords(PlayerPedId())

        for mode, posData in pairs(Config.Positions) do
            local dist = #(playerCoords - posData.NPC.coords)
            if Config.ShowNPC then
                ManageNPC(mode, dist)
            end

            if dist < 50.0 then waitTime = 1000 end
            if dist < 10.0 then waitTime = 0 end

            if not Config.TargetSystem then
                if dist < 2.0 then
                    if not activeNpcState[mode] then
                        activeNpcState[mode] = true
                        showHelpNotification(Config.Language.npc_help_notification)
                    end
                    if IsControlJustPressed(0, 38) then
                        if (lastInteractionTime + 3000) < GetGameTimer() then
                            if Config.XPSystem then
                                TriggerEvent("saltytrains:showJobStartUI", mode)
                            else
                                StartTrainJob(mode)
                            end
                            lastInteractionTime = GetGameTimer()
                        end
                    end
                else
                    if activeNpcState[mode] then
                        activeNpcState[mode] = false
                        hideHelpNotification()
                    end
                end
            end
        end

        Wait(waitTime)
    end
end)

function CreateJobSession(mode)
    local session = {}
    local stations = Config.Stations[mode]

    session.mode = mode
    session.startTime = GetCloudTimeAsInt()
    session.startPos = Config.Positions[mode].coords
    session.railPos = Config.Positions[mode].railPos
    session.emergencyBrake = false
    session.isInsideTrain = false
    session.isDoorOpen = false
    session.isDoorInMotion = false
    session.speed = 0
    session.currentStation = 1
    session.isStopping = false
    session.cam = nil

    local trainVariations = Config.Trains[mode].variations
    session.trainVariation = trainVariations[math.random(1, #trainVariations)]
    session.train = CreateMissionTrain(
        session.trainVariation,
        session.railPos.x, session.railPos.y, session.railPos.z,
        Config.Positions[mode].direction, true, true
    )

    SetTrainSpeed(session.train, 0)
    SetTrainCruiseSpeed(session.train, 0)
    SetEntityAsMissionEntity(session.train, true, false)
    SetTrainState(session.train, 0)
    SetVehicleFuelLevel(session.train, 100.0)
    DecorSetFloat(session.train, "_FUEL_LEVEL", GetVehicleFuelLevel(session.train))

    local netId = NetworkGetNetworkIdFromEntity(session.train)
    TriggerServerEvent("nc_trains:createNetTrain", netId)

    session.maxSpeed = math.floor(Config.Trains[mode].maxSpeed / 3.6)

    function session.enterTrain()
        TaskWarpPedIntoVehicle(PlayerPedId(), session.train, -1)
        session.isInsideTrain = true
        notify(Config.Language.job_started, "primary")
    end

    function session.toggleCamera()
        if session.cam then
            DestroyAllCams(true)
            RenderScriptCams(false, false, 0, true, true)
            SetFollowPedCamViewMode(1)
            session.cam = nil
        else
            session.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamActive(session.cam, true)
            RenderScriptCams(true, false, 0, true, true)
        end
    end

    function session.setMaxSpeed(newMaxSpeed)
        if newMaxSpeed then
            session.maxSpeed = math.floor(newMaxSpeed / 3.6)
            if session.speed > session.maxSpeed then
                session.speed = session.maxSpeed
                SetTrainCruiseSpeed(session.train, session.speed)
            end
        else
            session.maxSpeed = math.floor(Config.Trains[mode].maxSpeed / 3.6)
        end
        SendNUIMessage({ action = "train:updateMaxSpeed", data = session.maxSpeed })
    end

    function session.increaseSpeed()
        if session.isDoorOpen or session.emergencyBrake or session.isStopping then return end
        local ratio = session.speed / session.maxSpeed
        session.speed = session.speed + (0.2 * (1 - ratio))
        if session.speed > session.maxSpeed then session.speed = session.maxSpeed end
        SetTrainCruiseSpeed(session.train, session.speed)
    end

    function session.decreaseSpeed()
        if session.isDoorOpen or session.emergencyBrake or session.isStopping then return end
        local ratio = session.speed / session.maxSpeed
        session.speed = session.speed - (0.04 + ratio * 0.1)
        if session.speed < 0 then session.speed = 0 end
        SetTrainCruiseSpeed(session.train, session.speed)
    end

    function session.toggleEmergencyBrake()
        if session.isDoorOpen or session.isStopping then return end
        session.emergencyBrake = not session.emergencyBrake
        if session.emergencyBrake then
            SetTrainCruiseSpeed(session.train, 0)
            PlaySound(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        else
            SetTrainCruiseSpeed(session.train, session.speed)
            PlaySound(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        end
    end

    function session.toggleDoors()
        if session.isStopping or session.isDoorInMotion then return end
        if GetEntitySpeed(session.train) > 0.1 then return end

        if session.isDoorOpen then
            SetTrainState(session.train, 4)
            SetTimeout(5000, function()
                PlaySound(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
                session.isDoorOpen = false
                session.isDoorInMotion = false
            end)
        else
            session.isDoorInMotion = true
            session.isDoorOpen = true
            SetTrainState(session.train, 2)
            SetTimeout(2000, function()
                session.isDoorInMotion = false
                TriggerEvent("nc_trains:doorsOpened")
            end)
        end
    end

    return session
end

function EndTrainJob(wasSuccessful)
    if not jobSession then return end

    TriggerServerEvent("nc_trains:completedMetroLine", jobSession.mode, wasSuccessful)

    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, true, true)
    SetFollowPedCamViewMode(1)

    SetEntityAsMissionEntity(jobSession.train, false, false)
    DeleteMissionTrain(jobSession.train)

    if Config.Teleport then
        SetEntityCoords(PlayerPedId(), Config.Positions[jobSession.mode].endPos)
    end

    jobSession = nil
    SendNUIMessage({ action = "train:toggle", data = false })
    notify(Config.Language.job_ended, "primary")
end

AddEventHandler("saltytrains:startJob", function(mode)
    StartTrainJob(mode)
end)

AddEventHandler("saltytrains:showJobStartUI", function(mode)
    local p = promise.new()
    local jobData = nil

    TriggerServerCallback("saltytrains:getJobData", function(result)
        jobData = result
        p:resolve()
    end, mode)

    Citizen.Await(p)

    if not jobData then
        notify("There was an error fetching your data", "error")
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "train:showJobStart",
        data = {
            mode = mode,
            level = jobData.level,
            xp = jobData.xp,
            xp_for_next_level = jobData.xpForNextLevel,
        }
    })
end)

RegisterNUICallback("train:startJob", function(data, cb)
    SendNUIMessage({ action = "train:hideJobStart" })
    SetNuiFocus(false, false)
    StartTrainJob(data.mode)
    cb({})
end)

RegisterNUICallback("train:escapedJobStart", function(data, cb)
    SendNUIMessage({ action = "train:hideJobStart" })
    SetNuiFocus(false, false)
    cb({})
end)

function StartTrainJob(mode)
    if jobSession then
        EndTrainJob()
        return
    end

    -- Emprego assinado pela Central de Empregos (Night_Jobcenter)
    if Config.RequiredJob and LocalPlayer.state.Job ~= Config.RequiredJob then
        notify("Você não está com a carteira assinada para este emprego.", "error")
        return
    end

    TriggerServerEvent("nc_trains:initiateNetTrain", mode)
    DoScreenFadeOut(800)
    Wait(1000)

    jobSession = CreateJobSession(mode)

    if not jobSession then
        DoScreenFadeIn(800)
        return
    end

    jobSession.enterTrain()
    Wait(800)
    DoScreenFadeIn(800)

    local stations = Config.Stations[mode]
    SendNUIMessage({ action = "train:updateCurrentStation", data = stations[jobSession.currentStation].name })
    jobSession.setMaxSpeed(stations[jobSession.currentStation].newMaxSpeed)
    SendNUIMessage({ action = "train:toggle", data = true })

    local loopTick = 0
    local stationArrivalTimes = {}
    local missedNotified = false

    Citizen.CreateThread(function()
        while jobSession and jobSession.currentStation <= #stations do
            Wait(0)
            if not jobSession then return end

            loopTick = loopTick + 1

            local currentStationData = stations[jobSession.currentStation]
            local stationPos = currentStationData.pos
            local trainCoords = GetEntityCoords(jobSession.train)
            local frontOffset = GetOffsetFromEntityInWorldCoords(jobSession.train, 0.0, -30.0, 0.0)
            local distToStation = #(trainCoords - stationPos)
            local frontDistToStation = #(frontOffset - stationPos)

            if distToStation <= 10.0 then
                if currentStationData.isEnd then
                    EndTrainJob(true)
                    return
                end

                if currentStationData.isSkipping then
                    jobSession.currentStation = jobSession.currentStation + 1
                    local nextStation = stations[jobSession.currentStation]
                    if nextStation then
                        jobSession.setMaxSpeed(currentStationData.newMaxSpeed)
                        SendNUIMessage({ action = "train:updateCurrentStation", data = nextStation.name })
                    end
                end

                if not stationArrivalTimes[jobSession.currentStation] then
                    stationArrivalTimes[jobSession.currentStation] = GetCloudTimeAsInt()
                end
            end

            local arrivalTime = stationArrivalTimes[jobSession.currentStation]
            if arrivalTime and (arrivalTime + 10) < GetCloudTimeAsInt() then
                if not missedNotified and not currentStationData.isSkipping then
                    missedNotified = true
                    SetTimeout(2000, function()
                        if not jobSession then return end
                        local newDist = #(GetEntityCoords(jobSession.train) - stationPos)
                        if newDist >= 50.0 then
                            if not currentStationData.isSkipping then
                                jobSession.currentStation = jobSession.currentStation + 1
                                local nextStation = stations[jobSession.currentStation]
                                if not nextStation then
                                    jobSession.currentStation = jobSession.currentStation - 1
                                    return
                                end
                                jobSession.setMaxSpeed(currentStationData.newMaxSpeed)
                                SendNUIMessage({ action = "train:updateCurrentStation", data = nextStation.name or "N/A" })
                                notify(Config.Language.missed_station, "primary")
                                missedNotified = false
                            end
                        else
                            missedNotified = false
                        end
                    end)
                end
            end

            if not currentStationData.isSkipping then
                local sx, sy, sz = stationPos.x, stationPos.y, stationPos.z
                local w, h = 3.0, 55.0

                local corners = {
                    vector3(sx - w/2, sy - h/2, sz - 0.9),
                    vector3(sx + w/2, sy - h/2, sz - 0.9),
                    vector3(sx + w/2, sy + h/2, sz - 0.9),
                    vector3(sx - w/2, sy + h/2, sz - 0.9),
                }

                local heading = currentStationData.heading or 0.0
                for i = 1, 4 do
                    corners[i] = rotatePoint(stationPos, corners[i], heading)
                end

                local color = frontDistToStation <= 25.0 and { 0, 255, 0, 40 } or { 255, 0, 0, 40 }

                local topCorners = {}
                for i = 1, 4 do
                    topCorners[i] = vector3(corners[i].x, corners[i].y, corners[i].z + 0.4)
                end

                function DrawQuadPoly(a, b, c, col)
                    DrawPoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, col[1], col[2], col[3], col[4])
                    DrawPoly(c.x, c.y, c.z, b.x, b.y, b.z, a.x, a.y, a.z, col[1], col[2], col[3], col[4])
                end

                DrawQuadPoly(corners[1], corners[3], corners[2], color)
                DrawQuadPoly(corners[1], corners[4], corners[3], color)
                DrawQuadPoly(topCorners[1], topCorners[2], topCorners[3], color)
                DrawQuadPoly(topCorners[1], topCorners[3], topCorners[4], color)
                DrawQuadPoly(corners[1], corners[2], topCorners[2], color)
                DrawQuadPoly(corners[1], topCorners[2], topCorners[1], color)
                DrawQuadPoly(corners[4], topCorners[3], corners[3], color)
                DrawQuadPoly(corners[4], topCorners[4], topCorners[3], color)
                DrawQuadPoly(corners[4], topCorners[1], corners[1], color)
                DrawQuadPoly(corners[4], topCorners[4], topCorners[1], color)
                DrawQuadPoly(corners[2], topCorners[3], corners[3], color)
                DrawQuadPoly(corners[2], topCorners[2], topCorners[3], color)
            end

            if loopTick % 100 == 0 then
                SendNUIMessage({ action = "train:updateDistanceToStation", data = distToStation })
            end
            if loopTick >= 2000 then loopTick = 0 end
        end
    end)

    local stoppedTicks = 0
    local warnedPlayer = false
    local waitSounds = {}

    Citizen.CreateThread(function()
        while jobSession and jobSession.currentStation <= #stations do
            if not jobSession then return end

            if jobSession.isInsideTrain then
                if GetEntitySpeed(jobSession.train) < 5.0 then
                    if (jobSession.startTime + 30) > GetCloudTimeAsInt() then
                        if not waitSounds.w_s then
                            waitSounds.w_s = true
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                        DrawMissionText(Config.Language.mission_text_2, 1000)
                    end
                end
            end

            if GetEntitySpeed(jobSession.train) < 1.0 then
                if not jobSession.isStopping then
                    local stationDist = #(GetEntityCoords(jobSession.train) - stations[jobSession.currentStation].pos)
                    if stationDist < 30.0 then
                        DrawMissionText(Config.Language.mission_text_1, 1000)
                    end
                end
            end

            if GetEntitySpeed(jobSession.train) < 0.1 then
                stoppedTicks = stoppedTicks + 1
                if stoppedTicks >= 120 then
                    EndTrainJob()
                    return
                end
            else
                stoppedTicks = 0
            end

            Wait(1000)
        end
    end)

    local fKeyPressCount = 0
    local lastFKeyTime = 0

    Citizen.CreateThread(function()
        while jobSession and jobSession.currentStation <= #stations do
            local waitTime = 1000
            if not jobSession then return end

            if jobSession.isInsideTrain then
                waitTime = 0
                DisableControlAction(0, 23, true)
                DisableControlAction(0, 49, true)
                DisableControlAction(0, 75, true)
                DisableControlAction(0, 144, true)
                DisableControlAction(0, 145, true)
                DisableControlAction(0, 185, true)
                DisableControlAction(0, 251, true)
                DisableControlAction(0, 86, true)

                if IsControlPressed(0, 32) then jobSession.increaseSpeed() end
                if IsControlPressed(0, 31) then jobSession.decreaseSpeed() end
                if IsControlJustPressed(0, 38) then jobSession.toggleDoors() end

                if IsDisabledControlJustPressed(0, 75) then
                    fKeyPressCount = fKeyPressCount + 1
                    if (GetGameTimer() - lastFKeyTime) > 1000 then fKeyPressCount = 0 end
                    if fKeyPressCount >= 2 then
                        EndTrainJob()
                        fKeyPressCount = 0
                    end
                    lastFKeyTime = GetGameTimer()
                end
            end

            Wait(waitTime)
        end
    end)
end

function rotatePoint(center, point, angle)
    local rad = math.rad(angle)
    local cosA = math.cos(rad)
    local sinA = math.sin(rad)
    local dx = point.x - center.x
    local dy = point.y - center.y
    return vector3(
        center.x + dx * cosA - dy * sinA,
        center.y + dx * sinA + dy * cosA,
        point.z
    )
end

AddEventHandler("nc_trains:doorsOpened", function()
    if not jobSession then return end

    local trainCoords = GetEntityCoords(jobSession.train)
    local stations = Config.Stations[jobSession.mode]
    local currentStation = stations[jobSession.currentStation]

    if currentStation.isEnd or currentStation.isSkipping then return end

    local distToStation = #(trainCoords - currentStation.pos)
    if distToStation <= 30.0 then
        if GetEntitySpeed(jobSession.train) < 0.1 then
            jobSession.isStopping = true
            startProgress(Config.WaitTime[jobSession.mode] + 4, Config.Language.waiting_at_station)
            Wait(Config.WaitTime[jobSession.mode] * 1000)

            if not jobSession then return end
            jobSession.isStopping = false
            jobSession.currentStation = jobSession.currentStation + 1
            jobSession.toggleDoors()

            local nextStation = Config.Stations[jobSession.mode][jobSession.currentStation]
            jobSession.setMaxSpeed(currentStation.newMaxSpeed)
            SendNUIMessage({ action = "train:updateCurrentStation", data = nextStation and nextStation.name or "N/A" })
            TriggerServerEvent("nc_trains:completedStation", jobSession.mode)
        end
    else
        notify(Config.Language.not_at_station, "error")
        jobSession.toggleDoors()
    end
end)

AddEventHandler("onClientResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if jobSession then EndTrainJob() end
end)

Citizen.CreateThread(function()
    local nuiReady = false

    RegisterNUICallback("nuiReady", function(data, cb)
        nuiReady = true
        SendNUIMessage({ action = "train:getConfig", data = Config.UI })
        cb({})
    end)

    Wait(30000)
    if not nuiReady then
        SendNUIMessage({ action = "train:getConfig", data = Config.UI })
    end
end)

RegisterNUICallback("finishedDisplayingXp", function(data, cb)
    Wait(1000)
    table.remove(xpDisplayQueue, 1)
    cb({})
end)

RegisterNetEvent("saltytrains:displayExperience")
AddEventHandler("saltytrains:displayExperience", function(xpData)
    local myIndex = xpDisplayCounter
    table.insert(xpDisplayQueue, myIndex)
    xpDisplayCounter = xpDisplayCounter + 1

    while #xpDisplayQueue > 0 and xpDisplayQueue[1] ~= myIndex do
        Wait(800)
    end

    SendNUIMessage({ action = "displayXp", data = xpData })
end)

function SpawnGhostTrain(mode)
    print(string.format("Spawning ghost train for mode ^3%s^0", mode))

    local ghost = {}
    ghost.mode = mode

    local railPos = Config.Positions[mode].railPos
    local variations = Config.Trains[mode].variations
    local trainVariation = variations[math.random(1, #variations)]

    ghost.train = CreateMissionTrain(
        trainVariation,
        railPos.x, railPos.y, railPos.z,
        Config.Positions[mode].direction, true, true
    )
    ghost.maxSpeed = math.floor(Config.Trains[mode].maxSpeed / 3.6) + 0.0
    ghost.speed = 0
    ghost.currentStation = 1
    ghost.isStopping = false
    ghost.isDoorOpen = false
    ghost.isDoorInMotion = false

    SetEntityAsMissionEntity(ghost.train, true, true)
    local netId = NetworkGetNetworkIdFromEntity(ghost.train)
    TriggerServerEvent("nc_trains:createGhostTrain", netId)

    function ghost.setMaxSpeed(newMaxSpeed)
        if newMaxSpeed then
            ghost.maxSpeed = math.floor(newMaxSpeed / 3.6) + 0.0
            if ghost.speed > ghost.maxSpeed then
                ghost.speed = ghost.maxSpeed
                SetTrainCruiseSpeed(ghost.train, ghost.speed)
            end
        else
            ghost.maxSpeed = math.floor(Config.Trains[mode].maxSpeed / 3.6) + 0.0
        end
    end

    function ghost.toggleDoors()
        if ghost.isDoorInMotion then return end
        if GetEntitySpeed(ghost.train) > 0.1 then return end

        if ghost.isDoorOpen then
            SetTrainState(ghost.train, 4)
            SetTimeout(5000, function()
                ghost.isDoorOpen = false
                ghost.isDoorInMotion = false
            end)
        else
            ghost.isDoorInMotion = true
            ghost.isDoorOpen = true
            SetTrainState(ghost.train, 2)
            SetTimeout(2000, function()
                ghost.isDoorInMotion = false
            end)
        end
    end

    function ghost.increaseSpeed()
        if ghost.isDoorOpen or ghost.isStopping then return end
        local ratio = ghost.speed / ghost.maxSpeed
        ghost.speed = ghost.speed + (0.2 * (1 - ratio))
        if ghost.speed > ghost.maxSpeed then ghost.speed = ghost.maxSpeed end
        SetTrainCruiseSpeed(ghost.train, ghost.speed)
    end

    function ghost.decreaseSpeed()
        if ghost.isDoorOpen or ghost.isStopping then return end
        local ratio = ghost.speed / ghost.maxSpeed
        ghost.speed = ghost.speed - (0.04 + ratio * 0.1)
        if ghost.speed < 0 then ghost.speed = 0 end
        SetTrainCruiseSpeed(ghost.train, ghost.speed)
    end

    local stations = Config.Stations[mode]
    ghost.setMaxSpeed(stations[ghost.currentStation].newMaxSpeed)
    SetTrainCruiseSpeed(ghost.train, ghost.maxSpeed)

    Citizen.CreateThread(function()
        while ghost and ghost.currentStation <= #stations do
            Wait(100)

            local stationData = stations[ghost.currentStation]
            local trainCoords = GetEntityCoords(ghost.train)
            local dist = #(trainCoords - stationData.pos)

            if dist <= 10.0 then
                if stationData.isEnd then break end

                if stationData.isSkipping then
                    ghost.currentStation = ghost.currentStation + 1
                    local nextStation = stations[ghost.currentStation]
                    if nextStation then
                        ghost.setMaxSpeed(stationData.newMaxSpeed)
                    end
                elseif dist <= 4.0 then
                    if not ghost.isStopping then
                        ghost.isStopping = true
                        SetTrainCruiseSpeed(ghost.train, 0.0)

                        while GetEntitySpeed(ghost.train) > 0.1 do
                            Wait(100)
                        end

                        ghost.toggleDoors()
                        Wait(Config.WaitTime[ghost.mode] * 1000)
                        ghost.isStopping = false
                        ghost.toggleDoors()

                        local currentStationAfterWait = stations[ghost.currentStation]
                        if currentStationAfterWait then
                            ghost.setMaxSpeed(currentStationAfterWait.newMaxSpeed)
                        end
                        ghost.currentStation = ghost.currentStation + 1
                        SetTrainCruiseSpeed(ghost.train, ghost.maxSpeed)
                    end
                end
            end
        end

        SetEntityAsMissionEntity(ghost.train, false, false)
        DeleteMissionTrain(ghost.train)
        ghostTrainActive = false
        TriggerServerEvent("nc_trains:removeGhostTrainHosting")
    end)
end

RegisterNetEvent("saltytrains:spawnGhostTrain")
AddEventHandler("saltytrains:spawnGhostTrain", function(mode)
    if ghostTrainActive then return end
    ghostTrainActive = true
    SpawnGhostTrain(mode)
end)
