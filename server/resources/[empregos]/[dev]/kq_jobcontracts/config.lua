Config = {}

-- Enabling this will add additional prints and debug visuals
Config.debug = false

Config.locale = 'pt-br'

--

Config.sql = {
    driver = 'oxmysql', -- oxmysql or ghmattimysql or mysql
    -- If you're using an older version of oxmysql set this to false
    newOxMysql = true,
}

-- When someone disconnects while performing a contract, the contract will be kept and they will have a grace period to join back.
-- If they don't join back in time, they will be abandoned from the contract.
-- Time in minutes
Config.abandonGracePeriod = 15

-- Job leveling
Config.xp = {
    baseXp = 150, -- XP needed to go from level 1, to level 2
    multiplier = 1.1, -- Controls how much the XP required per level increases, making each next level cost 'multiplier' times more than the previous one
    maxXpPerLevel = 1000, -- Limits the amount of XP necessary for a level, to not make reaching higher levels too difficult
}

-- Position of the active contract HUD
Config.hud = {
    position = { -- CSS styling
        right = '2vw',
        left = nil,
        top = '50%',
        bottom = nil,
        transform = 'translateY(-50%)',
    },
}

-- Styling of the contract list/overview UI
Config.ui = {
    layout = 'sidebar',  -- "centered" or "sidebar"
}

-- Cores no padrão do servidor (Central de Empregos): fundo #0a0a0a, superfície #121212, verde #2e8b57
Config.uiStyling = {
    ['color-background'] = '10, 10, 10',
    ['color-background-light'] = '18, 18, 18',

    ['color-primary-dark'] = '31, 99, 61',
    ['color-primary'] = '46, 139, 87',
    ['color-primary-light'] = '143, 209, 172',

    ['color-secondary'] = '163, 163, 163',
    ['color-secondary-light'] = '212, 212, 212',
    ['color-secondary-dark'] = '38, 38, 38',

    ['color-white'] = '255, 255, 255',
    ['color-black'] = '10, 10, 10',
}

