Config = {}

-- Qual framework usar? ("QBCore" ou "vRP")
Config.Framework = "vRP" -- Deixando vRP como padrão para testes, mas o player pode mudar.

-- Configurações de Teclas
Config.EnableHUD = false
Config.Keys = {
    ShiftUp = 21,    -- [LEFT SHIFT] Subir Marcha
    ShiftDown = 36,  -- [LEFT CTRL] Reduzir Marcha
    Clutch = 61      -- [X] Embreagem (Opcional)
}

-- Opções de Jogabilidade
Config.RequireClutch = true -- Se true, o jogador deve segurar a embreagem para trocar de marcha no modo manual sem causar dano.
Config.StallEnabled = false   -- Se true, o carro "morre" se parar em marchas altas sem embreagem.
Config.DamageEnabled = true  -- Se true, redução agressiva de marcha e RPM no talo gera dano.

Config.OverRevDamage = 50.0  -- Dano instantâneo aplicado ao motor em reduções erradas.
Config.OverRevTimeLimit = 3.0 -- Segundos no corte de giro antes de começar a superaquecer/estragar.
Config.OverRevTickDamage = 5.0 -- Dano por segundo quando está estourando giro além do limite.
Config.ClutchMissDamage = 15.0 -- Dano se tentar trocar marcha sem embreagem (se RequireClutch = true)

-- Relacionado a sons
Config.PlayBackfireSounds = true
Config.PlayGrindSounds = true

-- Relações de marchas por padrão (Categorias de Veículos)
Config.DefaultGearRatios = {
    -- Estrutura: { Reverse, First, Second, Third, Fourth, Fifth, Sixth, FinalDrive }
    ["default"] = { Reverse = -3.0, First = 3.5, Second = 2.0, Third = 1.4, Fourth = 1.0, Fifth = 0.8, Sixth = 0.65, FinalDrive = 3.5 },
    ["sports"] = { Reverse = -2.8, First = 3.0, Second = 1.8, Third = 1.3, Fourth = 1.0, Fifth = 0.75, Sixth = 0.6, FinalDrive = 3.8 },
    ["trucks"] = { Reverse = -4.0, First = 4.5, Second = 2.8, Third = 1.8, Fourth = 1.2, Fifth = 0.9, Sixth = 0.75, FinalDrive = 4.1 },
    ["motorcycles"] = { Reverse = -2.0, First = 2.8, Second = 1.9, Third = 1.5, Fourth = 1.2, Fifth = 1.0, Sixth = 0.85, FinalDrive = 3.0 }
}

-- Substituições específicas por modelo (spawn name)
Config.CustomGearRatios = {
    ["sultan"] = { Reverse = -3.20, First = 3.80, Second = 2.20, Third = 1.55, Fourth = 1.18, Fifth = 0.95, Sixth = 0.78, FinalDrive = 3.42 }
}

-- Veículos que serão ignorados
Config.IgnoredVehicles = {
    "bmx",
    "scorcher",
    "cruiser",
    "fixter",
    "tribike",
    "tribike2",
    "tribike3",
}
