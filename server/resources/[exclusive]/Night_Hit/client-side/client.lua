local activeSound = Config.DefaultSettings.soundId
local activeVisual = Config.DefaultSettings.visualState
local activeHitFeed = Config.DefaultSettings.hitFeedState
local bodyHitSound = Config.DefaultSettings.bodySound
local currentVolume = Config.DefaultSettings.volume
local currentColor = Config.DefaultSettings.color
local settingsLoaded = false

local recentlyKilled = {}
local lastHitAt = {}
local lastPassportRequest = {}
local currentStreak = 0
local lastKillTime = 0

local function clamp(value, minimum, maximum, fallback)
    value = tonumber(value)
    if not value then return fallback end
    return math.max(minimum, math.min(maximum, value))
end

local function validColor(value)
    value = tostring(value or ""):upper()
    if value:match("^#%x%x%x%x%x%x$") then return value end
    return Config.DefaultSettings.color
end

local function applySettings(settings)
    if type(settings) ~= "table" then return end

    settingsLoaded = true

    activeSound = math.floor(clamp(settings.soundId, 0, 11, Config.DefaultSettings.soundId))
    activeVisual = math.floor(clamp(settings.visualState, 0, 5, Config.DefaultSettings.visualState))
    activeHitFeed = settings.hitFeedState == true
    bodyHitSound = math.floor(clamp(settings.bodySound, 0, 10, Config.DefaultSettings.bodySound))
    currentVolume = clamp(settings.volume, 0.0, 1.0, Config.DefaultSettings.volume)
    currentColor = validColor(settings.color)

    SendNUIMessage({
        action = "syncSettings",
        settings = {
            soundId = activeSound,
            visualState = activeVisual,
            hitFeedState = activeHitFeed,
            bodySound = bodyHitSound,
            volume = currentVolume,
            color = currentColor
        }
    })
end

local function settingsPayload()
    return {
        soundId = activeSound,
        visualState = activeVisual,
        hitFeedState = activeHitFeed,
        bodySound = bodyHitSound,
        volume = currentVolume,
        color = currentColor
    }
end

local function registerKill()
    local now = GetGameTimer()

    if now - lastKillTime <= Config.TimeAceValorant then
        currentStreak = currentStreak + 1
    else
        currentStreak = 1
    end

    lastKillTime = now
    currentStreak = math.min(currentStreak, 5)

    local soundToSend = activeSound == 11 and (50 + currentStreak) or activeSound
    if activeSound > 0 or activeVisual > 0 then
        SendNUIMessage({
            action = "playKillEffect",
            soundType = soundToSend,
            playVisual = activeVisual
        })
    end
end

RegisterNetEvent("sprint_killconfirm:applySettings", applySettings)

RegisterNetEvent("sprint_killconfirm:openUI", function(settings)
    applySettings(settings)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openUi", settings = settingsPayload() })
end)

RegisterNetEvent("sprint_killconfirm:testHit", registerKill)

RegisterNUICallback("saveSettings", function(data, cb)
    applySettings(data)
    TriggerServerEvent("sprint_killconfirm:saveSettings", settingsPayload())
    cb({ ok = true })
end)

RegisterNUICallback("closeUiCallback", function(_, cb)
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNUICallback("nuiReady", function(_, cb)
    SendNUIMessage({ action = "syncSettings", settings = settingsPayload() })

    if not settingsLoaded then
        TriggerServerEvent("sprint_killconfirm:requestSettings", false)
    end

    cb({ ok = true })
end)

RegisterNetEvent("sprint_killconfirm:receivePassport", function(passport)
    passport = tonumber(passport)
    if passport and passport > 0 then
        SendNUIMessage({ action = "showHitFeed", targetId = passport })
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)
    if name ~= "CEventNetworkEntityDamage" then return end

    local victim = args[1]
    local attacker = args[2]
    local myPed = PlayerPedId()

    if not victim or not attacker then return end
    if not DoesEntityExist(victim) or not IsEntityAPed(victim) or not IsPedAPlayer(victim) then return end

    -- Nesta base o jogador entra em estado de morte com 100 de vida. O campo
    -- "fatal" do CEventNetworkEntityDamage muda de posição entre artefatos do
    -- FiveM, portanto a vida da entidade é a fonte confiável aqui.
    local isFatal = IsEntityDead(victim) or IsPedDeadOrDying(victim, true) or GetEntityHealth(victim) <= 100

    if isFatal and victim == myPed then
        currentStreak = 0
        return
    end

    if attacker ~= myPed or victim == myPed then return end

    local playerId = NetworkGetPlayerIndexFromPed(victim)
    if playerId == -1 or playerId == PlayerId() then return end

    local targetSource = GetPlayerServerId(playerId)
    if not targetSource or targetSource <= 0 then return end

    local now = GetGameTimer()

    if activeHitFeed then
        local requestedAt = lastPassportRequest[targetSource]
        if not requestedAt or now - requestedAt > 750 then
            TriggerServerEvent("sprint_killconfirm:getPassport", targetSource)
            lastPassportRequest[targetSource] = now
        end
    end

    if not isFatal then
        local previousHit = lastHitAt[targetSource]
        if previousHit and now - previousHit < Config.HitCooldown then return end
        lastHitAt[targetSource] = now

        if bodyHitSound > 0 then
            SendNUIMessage({ action = "playHitSound", soundType = bodyHitSound })
        end
        return
    end

    if recentlyKilled[targetSource] then return end
    recentlyKilled[targetSource] = true
    registerKill()

    CreateThread(function()
        local expiresAt = GetGameTimer() + Config.KillDeduplicationTime

        while GetGameTimer() < expiresAt do
            Wait(500)

            local currentPlayer = GetPlayerFromServerId(targetSource)
            if currentPlayer == -1 then break end

            local currentPed = GetPlayerPed(currentPlayer)
            if currentPed ~= victim or not DoesEntityExist(victim) or GetEntityHealth(victim) > 100 then break end
        end

        recentlyKilled[targetSource] = nil
        lastHitAt[targetSource] = nil
        lastPassportRequest[targetSource] = nil
    end)
end)

exports("DispararKillConfirm", registerKill)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(500) end

    for _, delay in ipairs({ 250, 1000, 3000, 5000 }) do
        Wait(delay)
        if settingsLoaded then break end
        TriggerServerEvent("sprint_killconfirm:requestSettings", false)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then SetNuiFocus(false, false) end
end)
