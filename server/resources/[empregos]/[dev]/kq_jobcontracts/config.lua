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

Config.uiStyling = {
    ['color-background'] = '20, 22, 21',
    ['color-background-light'] = '30, 33, 31',

    ['color-primary-dark'] = '120, 170, 0',
    ['color-primary'] = '178, 243, 0',
    ['color-primary-light'] = '211, 252, 98',

    ['color-secondary'] = '193, 207, 176',
    ['color-secondary-light'] = '226, 245, 203',
    ['color-secondary-dark'] = '111, 117, 103',

    ['color-white'] = '251, 251, 251',
    ['color-black'] = '10, 10, 10',
}

