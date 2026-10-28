local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local cachedSettings = {}
local isDatabaseReady = false

-- ====================================================================
-- Helpers & Sanitização
-- ====================================================================

local function getUserId(source)
    if not source or source <= 0 then return nil end
    if vRP.getUserId then
        local uid = vRP.getUserId(source)
        if uid then return tonumber(uid) end
    end
    if vRP.Passport then
        local pass = vRP.Passport(source)
        if pass then return tonumber(pass) end
    end
    return nil
end

local function clamp(value, minimum, maximum, fallback)
    value = tonumber(value)
    if not value then return fallback end
    return math.max(minimum, math.min(maximum, value))
end

local function validColor(value)
    value = tostring(value or ""):upper()
    if value:match("^#%x%x%x%x%x%x$") then
        return value
    end
    return Config.DefaultSettings.color
end

local function sanitizeSettings(settings)
    if type(settings) ~= "table" then
        return {
            soundId = Config.DefaultSettings.soundId,
            visualState = Config.DefaultSettings.visualState,
            hitFeedState = Config.DefaultSettings.hitFeedState,
            bodySound = Config.DefaultSettings.bodySound,
            volume = Config.DefaultSettings.volume,
            color = Config.DefaultSettings.color
        }
    end

    return {
        soundId = math.floor(clamp(settings.soundId, 0, 11, Config.DefaultSettings.soundId)),
        visualState = math.floor(clamp(settings.visualState, 0, 5, Config.DefaultSettings.visualState)),
        hitFeedState = settings.hitFeedState == true or settings.hitFeedState == 1,
        bodySound = math.floor(clamp(settings.bodySound, 0, 10, Config.DefaultSettings.bodySound)),
        volume = clamp(settings.volume, 0.0, 1.0, Config.DefaultSettings.volume),
        color = validColor(settings.color)
    }
end

-- ====================================================================
-- Inicialização do Banco de Dados
-- ====================================================================

local function initializeDatabase()
    local query = [[
        CREATE TABLE IF NOT EXISTS `killconfirm_settings` (
            `user_id` INT NOT NULL,
            `sound_id` INT NOT NULL DEFAULT 0,
            `visual_state` INT NOT NULL DEFAULT 0,
            `hitfeed_state` TINYINT(1) NOT NULL DEFAULT 0,
            `body_sound` INT NOT NULL DEFAULT 0,
            `volume` FLOAT NOT NULL DEFAULT 0.5,
            `color` VARCHAR(10) NOT NULL DEFAULT '#2E8B57',
            PRIMARY KEY (`user_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]

    local function trySetup()
        if not MySQL or not MySQL.query then
            SetTimeout(Config.DatabaseRetryTime or 5000, trySetup)
            return
        end

        MySQL.query(query, {}, function(result)
            isDatabaseReady = true
            --print("^2[HIT CONFIRM] Tabela do banco de dados verificada/criada com sucesso.^7")
        end)
    end

    trySetup()
end

CreateThread(function()
    initializeDatabase()
end)

-- ====================================================================
-- Carregamento e Salvamento de Configurações
-- ====================================================================

local function loadUserSettings(user_id, cb)
    if cachedSettings[user_id] then
        if cb then cb(cachedSettings[user_id]) end
        return
    end

    if not isDatabaseReady then
        local fallback = sanitizeSettings(Config.DefaultSettings)
        if cb then cb(fallback) end
        return
    end

    local query = "SELECT sound_id, visual_state, hitfeed_state, body_sound, volume, color FROM killconfirm_settings WHERE user_id = ?"
    MySQL.query(query, { user_id }, function(result)
        if result and result[1] then
            local row = result[1]
            local userSettings = sanitizeSettings({
                soundId = row.sound_id,
                visualState = row.visual_state,
                hitFeedState = row.hitfeed_state == 1 or row.hitfeed_state == true,
                bodySound = row.body_sound,
                volume = row.volume,
                color = row.color
            })
            cachedSettings[user_id] = userSettings
            if cb then cb(userSettings) end
        else
            local defaultSettings = sanitizeSettings(Config.DefaultSettings)
            cachedSettings[user_id] = defaultSettings
            if cb then cb(defaultSettings) end
        end
    end)
end

local function saveUserSettings(user_id, settings)
    local sanitized = sanitizeSettings(settings)
    cachedSettings[user_id] = sanitized

    if not isDatabaseReady then return end

    local query = [[
        INSERT INTO killconfirm_settings (user_id, sound_id, visual_state, hitfeed_state, body_sound, volume, color)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            sound_id = VALUES(sound_id),
            visual_state = VALUES(visual_state),
            hitfeed_state = VALUES(hitfeed_state),
            body_sound = VALUES(body_sound),
            volume = VALUES(volume),
            color = VALUES(color);
    ]]

    MySQL.query(query, {
        user_id,
        sanitized.soundId,
        sanitized.visualState,
        sanitized.hitFeedState and 1 or 0,
        sanitized.bodySound,
        sanitized.volume,
        sanitized.color
    })
end

-- ====================================================================
-- Eventos de Rede (Client -> Server)
-- ====================================================================

RegisterNetEvent("sprint_killconfirm:requestSettings", function(openUi)
    local src = source
    local user_id = getUserId(src)
    if not user_id then return end

    loadUserSettings(user_id, function(settings)
        if openUi then
            TriggerClientEvent("sprint_killconfirm:openUI", src, settings)
        else
            TriggerClientEvent("sprint_killconfirm:applySettings", src, settings)
        end
    end)
end)

RegisterNetEvent("sprint_killconfirm:saveSettings", function(data)
    local src = source
    local user_id = getUserId(src)
    if not user_id then return end

    saveUserSettings(user_id, data)
end)

RegisterNetEvent("sprint_killconfirm:getPassport", function(targetSource)
    local src = source
    if not targetSource or targetSource <= 0 then return end

    local targetUserId = getUserId(targetSource)
    if targetUserId then
        TriggerClientEvent("sprint_killconfirm:receivePassport", src, targetUserId)
    end
end)

-- ====================================================================
-- Comando para abrir o Menu de Configurações
-- ====================================================================

RegisterCommand(Config.Command or "hit", function(source, args, rawCommand)
    if source <= 0 then return end

    local user_id = getUserId(source)
    if not user_id then return end

    loadUserSettings(user_id, function(settings)
        TriggerClientEvent("sprint_killconfirm:openUI", source, settings)
    end)
end, false)

-- ====================================================================
-- Limpeza de Cache ao Desconectar
-- ====================================================================

AddEventHandler("playerDropped", function()
    local src = source
    local user_id = getUserId(src)
    if user_id and cachedSettings[user_id] then
        cachedSettings[user_id] = nil
    end
end)
