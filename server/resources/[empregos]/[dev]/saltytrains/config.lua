Config = {}

-- DONT FORGET TO CHANGE THE WEBHOOK URL IN THE SERVER FILES -> server/main.lua line 1

Config.Framework = "vRP" -- The framework you are using -> ESX, QBCore, custom (if you are using a custom framework, you need to implement the functions in the framework.lua and utils.lua files)

-- Emprego que precisa estar assinado na Central de Empregos (Night_Jobcenter). false = qualquer jogador
Config.RequiredJob = "TrainDriver"

-- Blip no mapa e NPC no ponto de início (a interação com E continua no mesmo lugar)
Config.ShowBlips = false
Config.ShowNPC = false

Config.TargetSystem = false -- Set to true if you want to use a target system like qb-target or ox_target, otherwise set to false. Default ist configured for ox_target. if you have something else you can change it in utils.lua

Config.Trains = {
    ["metro"] = {
        variations = { 28 }, -- When a train gets spawned it selects a random variation from this list https://docs.fivem.net/natives/?_0x63C6CCA8E68AE8C8
        maxSpeed = 80, -- the maximum speed of the train in km/h
    },
    ["train"] = {
        variations = { 2, 5, 6, 9, 10, 11, 12, 19, 20, 24 },
        maxSpeed = 160,
    },
}

-- This setting controls whether the player gets teleported to the start position when the job is finished or when he force ends the job
-- If set to false, the train will just despawn and the player has to walk back to the NPC
Config.Teleport = true

-- Ghost train configuration
-- If you set Config.GhostTrains to true, trains will spawn eventough there are players or vehicles on the tracks
-- This is useful for servers with low player counts, so the tracks look more alive
Config.GhostTrains = false
Config.GhostTrainTimeout = 300 -- Time in seconds that has to pass without a player starting a train job route until a ghost train can spawn

-- The XP system configuration
-- Added xp system to reward players for completing stations and lines
-- The more xp a player has, the higher their level will be (level calculated in GetLevelFromXP function below in the config)
-- If you don't want to use the xp system, just set Config.XPSystem to false

Config.XPSystem = false -- Set to true if you want to use an XP system, otherwise set to false

Config.XPRewards = {
    ["metro"] = {
        min = 10, -- Minimum XP for completing a station
        max = 20, -- Maximum XP for completing a station
        bonus = 50, -- Bonus XP for completing the whole line
    },
    ["train"] = {
        min = 25,
        max = 40,
        bonus = 60,
    },
}

-- The money multiplier per level
Config.LevelMoneyMultiplier = 0.5 -- This means that for each level the player gets, he will receive 0.5% more money on top of the normal reward

-- Level calculation function for the XP system
-- Returns level 1–100 for a given XP amount
-- Change this function only if you know what you are doing
function GetLevelFromXP(xp)
    local maxXP = 150000
    local exponent = 1.5

    if xp >= maxXP then
        return 100, 0
    end

    local xpPercent = xp / maxXP

    local level = math.floor((xpPercent ^ (1/exponent)) * 100)
    if level < 1 then level = 1 end

    local nextLevelPercent = (level + 1) / 100

    local xpForNextLevel = math.floor((nextLevelPercent ^ exponent) * maxXP)

    return level, xpForNextLevel
end

Config.Positions = {
    -- The Los Santos Metro
    ["metro"] = {
        NPC = {
            model = "ig_josh", -- The model of the NPC that gives the job
            coords = vector3(-532.858154296875, -1265.3775634765625, 26.891176223754883), -- The position of the NPC
            heading = 330.9914855957031, -- The heading of the NPC
        },
        railPos = vector3(-530.0886, -1270.5343, 25.9033), -- The position where the train will be spawned
        endPos = vector3(-533.3856, -1265.9607, 26.9016), -- The position where the player will be tped to when the job is finished (or when he force ends the job)
        direction = true, -- The direction of the train on the track (true = forward, false = backward)
    },
    ["train"] = {
        NPC = {
            model = "ig_josh", -- The model of the NPC that gives the job
            coords = vector3(2617.86474609375, 1670.142578125, 27.60074234008789), -- The position of the NPC
            heading = 0.8220174312591553, -- The heading of the NPC
        },
        railPos = vector3(2610.9312, 1691.5001, 26.9047),
        endPos = vector3(2620.1904, 1672.3811, 27.5996),
        direction = false,
    },
}

-- The time in seconds the player has to wait at the station before the train can leave
Config.WaitTime = {
    ["metro"] = 5, -- SECONDS
    ["train"] = 15,
}

-- The min and max values are used to calculate a random amount of money the player receives when he completes a station instantly
-- The bonus is multiplied by the number of stations the player has completed and will only receive it when he completes the whole line
-- This was done to prevent abuse, so players can't just spam the job and only drive to one station and get the bonus and then restart the job
-- As the server files are open source, you can change this to your liking but it is recommended to keep the bonus as it is
Config.Rewards = {
    ["metro"] = { min = 30, max = 44, bonus = 32 },
    ["train"] = { min = 110, max = 160, bonus = 100 },
}

Config.Blips = {
    ["metro"] = {
        sprite = 795, -- The sprite of the blip
        color = 12, -- The color of the blip
        scale = 0.5, -- The scale of the blip
        name = "Emprego | Metrô", -- The name of the blip
    },
    ["train"] = {
        sprite = 795,
        color = 12,
        scale = 0.5,
        name = "Emprego | Trem",
    },
}

-- The UI configuration for the speed limit and distance display
Config.UI = {
    speed_limit = {
        unit = "kmh", -- "mph" -> miles per hour, "kmh" -> kilometers per hour
        position = { bottom = "18vh", right = "4vw" }, -- The position of the speed limit display on the screen
    },
    distance = {
        unit = "km", -- "m" -> meters, "km" -> kilometers, "mi" -> miles
        text = "Próxima parada:",
        position = { top = "32vh", left = "1vw" }, -- The position of the distance display on the screen
    },
    xp = {
        color = "#39baffff", -- The color of the XP display on the screen
    }
}

Config.Language = {
    npc_help_notification = "Pressione E para iniciar o trabalho",
    waiting_at_station = "Aguardando...",
    not_at_station = "Você ainda não chegou na estação!",
    job_started = "Vamos! Pressione F duas vezes para concluir o trabalho!",
    missed_station = "Você passou da estação! Pare na próxima, dentro da área marcada, e abra as portas com E",
    job_ended = "Trabalho finalizado!",
    mission_text_1 = "Pressione ~b~E~s~ para abrir as portas",
    mission_text_2 = "Pressione ~b~W~s~ para acelerar e ~b~S~s~ para frear",
}

-- The positions of the stations for the metro and train
Config.Stations = {
    ["metro"] = {
        {
            name = "Strawberry", -- The name of the station
            pos = vector3(258.7029, -1210.0177, 38.0746), -- The position of the station where the player has to stop
            heading = 270.0, -- The heading of the station (In which direction the train is facing)
        },
        {
            name = "Burton",
            pos = vector3(-287.1656, -332.1422, 9.1726),
            heading = 0.0,
        },
        {
            name = "Portola Drive",
            pos = vector3(-817.9713, -130.5173, 19.0597),
            heading = 120.0,
        },
        {
            name = "Del Perro",
            pos = vector3(-1359.2241, -467.0545, 14.1547),
            heading = 210.0,
        },
        {
            name = "Little Seoul",
            pos = vector3(-502.5719, -680.8267, 10.9186),
            heading = 270.0,
        },
        {
            name = "Pillbox South",
            pos = vector3(-218.0561, -1032.5148, 29.3254),
            heading = 160.0,
            newMaxSpeed = 50, -- New maximum speed after this station in km/h
        },
        {
            name = "Davis",
            pos = vector3(112.9824, -1729.3881, 29.0559),
            heading = 230.0,
            -- Note: IF there is not a newMaxSpeed defined, the train will again use the default speed defined in Config.Trains["metro"].maxSpeed
        },
        {
            name = "Davis",
            pos = vector3(119.3929, -1723.7031, 29.1272),
            heading = 230.0,
            newMaxSpeed = 50, -- New maximum speed after this station in km/h
        },
        {
            name = "Pillbox South",
            pos = vector3(-208.0023, -1032.1862, 29.3227),
            heading = 340.2458,
        },
        {
            name = "Little Seoul",
            pos = vector3(-500.5500, -665.4594, 10.9198),
            heading = 90.2,
        },
        {
            name = "Del Perro",
            pos = vector3(-1345.5730, -459.9233, 14.1551),
            heading = 29.85,
        },
        {
            name = "Portola Drive",
            pos = vector3(-810.7444, -143.7276, 19.0599),
            heading = 300.0,
        },
        {
            name = "Burton",
            pos = vector3(-302.2440, -332.0439, 9.1726),
            heading = 0.0,
        },
        {
            name = "Strawberry",
            pos = vector3(263.1355, -1198.4581, 38.0757),
            heading = 90.0,
        },
        {
            name = "Puerto Del Sol (Estação final)",
            pos = vector3(-545.2571, -1281.0559, 25.9053),
            heading = 155.64,
            isEnd = true, -- This station is the end of the metro line
        },
    },
    ["train"] = {
        {
            name = "Minas de Ferro",
            pos = vector3(2612.4163, 2930.6208, 39.8856),
            heading = 324.0,
        },
        {
            name = "Paleto Bay",
            pos = vector3(-139.8481, 6142.5410, 31.5772),
            heading = 135.0,
        },
        {
            name = "Minas de Ferro",
            pos = vector3(2607.4248, 2934.0396, 40.0196),
            heading = 144.0,
        },
        {
            name = "Mirror Park",
            pos = vector3(664.5507, -898.7147, 22.2379),
            heading = 0.0,
        },
        {
            name = "Passagem de nível (sem parada)",
            pos = vector3(556.1844, -1496.6737, 21.4630),
            heading = 181.6500,
            isSkipping = true, -- This station is skipped, the train does not stop here (These stations are used to change the speed of the train without stopping)
            newMaxSpeed = 50, -- New maximum speed after this station in km/h
        },
        {
            name = "Harbourbridge (sem parada)",
            pos = vector3(146.5812, -2055.6763, 18.3216),
            heading = 174.8581,
            isSkipping = true,
            newMaxSpeed = 80,
        },
        {
            name = "Harbourbridge (sem parada)",
            pos = vector3(692.0786, -2566.0730, 12.0574),
            heading = 327.6513,
            isSkipping = true,
            newMaxSpeed = 180,
        },
        {
            name = "Estação final (sem parada)",
            pos = vector3(2610.7798, 1467.4595, 31.9006),
            heading = 357.8342,
            isSkipping = true,
            newMaxSpeed = 45,
        },
        {
            name = "Estação final",
            pos = vector3(2611.1006, 1698.0022, 26.7970),
            heading = 0.0,
            isEnd = true,
        },
    }
}