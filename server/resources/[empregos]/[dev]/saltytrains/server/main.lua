local WebhookURL = "" -- Remplace par ton URL de webhook Discord

local activeJobs = {}
local lastJobTime = os.time()
local ghostTrainActive = false

MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS saltytrains_xp (
            identifier VARCHAR(255) NOT NULL PRIMARY KEY,
            xp INT NOT NULL DEFAULT 0
        )
    ]])
end)

RegisterNetEvent("nc_trains:initiateNetTrain")
AddEventHandler("nc_trains:initiateNetTrain", function(mode)
    local source = source
    activeJobs[source] = { mode = mode, startTime = os.time(), stationsCompleted = 0 }
    lastJobTime = os.time()
end)

RegisterNetEvent("nc_trains:createNetTrain")
AddEventHandler("nc_trains:createNetTrain", function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
    end
end)

RegisterNetEvent("nc_trains:completedStation")
AddEventHandler("nc_trains:completedStation", function(mode)
    local source = source
    local rewards = Config.Rewards[mode]
    if not rewards then return end

    if activeJobs[source] then
        activeJobs[source].stationsCompleted = (activeJobs[source].stationsCompleted or 0) + 1
    end

    local baseReward = math.random(rewards.min, rewards.max)

    if Config.XPSystem then
        local identifier = GetPlayerIdentifier(source)
        GetPlayerXP(identifier, function(currentXP)
            local level, _ = GetLevelFromXP(currentXP)
            local multiplier = 1 + (level * Config.LevelMoneyMultiplier / 100)
            AddPlayerMoney(source, math.floor(baseReward * multiplier))

            local xpRewards = Config.XPRewards[mode]
            local xpGained = math.random(xpRewards.min, xpRewards.max)
            local newXP = currentXP + xpGained
            SavePlayerXP(identifier, newXP)

            local newLevel, xpForNext = GetLevelFromXP(newXP)
            TriggerClientEvent("saltytrains:displayExperience", source, {
                xp = xpGained,
                totalXP = newXP,
                level = newLevel,
                xpForNextLevel = xpForNext,
            })
        end)
    else
        AddPlayerMoney(source, baseReward)
    end

    -- Experiência do emprego (aparece no menu ESC), 1 por estação como no ônibus
    AddWorkExperience(source, 1)
end)

RegisterNetEvent("nc_trains:completedMetroLine")
AddEventHandler("nc_trains:completedMetroLine", function(mode, wasSuccessful)
    local source = source
    local rewards = Config.Rewards[mode]
    if not rewards then return end

    local stationsCompleted = activeJobs[source] and activeJobs[source].stationsCompleted or 0
    activeJobs[source] = nil

    if not wasSuccessful or stationsCompleted == 0 then return end

    local bonus = rewards.bonus * stationsCompleted

    if Config.XPSystem then
        local identifier = GetPlayerIdentifier(source)
        GetPlayerXP(identifier, function(currentXP)
            local level, _ = GetLevelFromXP(currentXP)
            local multiplier = 1 + (level * Config.LevelMoneyMultiplier / 100)
            AddPlayerMoney(source, math.floor(bonus * multiplier))

            local xpRewards = Config.XPRewards[mode]
            local newXP = currentXP + xpRewards.bonus
            SavePlayerXP(identifier, newXP)

            local newLevel, xpForNext = GetLevelFromXP(newXP)
            TriggerClientEvent("saltytrains:displayExperience", source, {
                xp = xpRewards.bonus,
                totalXP = newXP,
                level = newLevel,
                xpForNextLevel = xpForNext,
            })
        end)
    else
        AddPlayerMoney(source, bonus)
    end

    if WebhookURL ~= "" then
        local playerName = GetPlayerName(source)
        SendWebhook(
            WebhookURL,
            "Viagem concluída",
            string.format("**%s** completou a linha **%s** (%d estações).", playerName, mode, stationsCompleted),
            5763719
        )
    end
end)

RegisterNetEvent("nc_trains:createGhostTrain")
AddEventHandler("nc_trains:createGhostTrain", function(netId)
    ghostTrainActive = true
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
    end
end)

RegisterNetEvent("nc_trains:removeGhostTrainHosting")
AddEventHandler("nc_trains:removeGhostTrainHosting", function()
    ghostTrainActive = false
end)

AddEventHandler("playerDropped", function()
    local source = source
    activeJobs[source] = nil
end)

RegisterFrameworkCallback("saltytrains:getJobData", function(source, cb, mode)
    if not Config.XPSystem then
        cb({ level = 1, xp = 0, xpForNextLevel = 0 })
        return
    end
    local identifier = GetPlayerIdentifier(source)
    GetPlayerXP(identifier, function(xp)
        local level, xpForNextLevel = GetLevelFromXP(xp)
        cb({ level = level, xp = xp, xpForNextLevel = xpForNextLevel })
    end)
end)

RegisterFrameworkCallback("xorgynoth:jobsLimit", function(source, cb)
    if activeJobs[source] then
        NotifyPlayer(source, "Você já tem uma viagem em andamento.", "error")
        cb(false)
        return
    end

    cb(true)
end)

if Config.GhostTrains then
    Citizen.CreateThread(function()
        while true do
            Wait(10000)
            if not ghostTrainActive and (os.time() - lastJobTime) >= Config.GhostTrainTimeout then
                local players = GetPlayers()
                if #players > 0 then
                    local modes = {}
                    for mode, _ in pairs(Config.Trains) do
                        modes[#modes + 1] = mode
                    end
                    local selectedMode = modes[math.random(1, #modes)]
                    local host = tonumber(players[math.random(1, #players)])
                    TriggerClientEvent("saltytrains:spawnGhostTrain", host, selectedMode)
                end
            end
        end
    end)
end
