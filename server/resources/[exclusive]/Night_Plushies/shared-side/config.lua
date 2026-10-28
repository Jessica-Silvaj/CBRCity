Config = {}

-- Validade de cada aquisição, em dias corridos. Transferir não renova.
Config.ValidityDays = 30

-- Valor da rodada (Gemas/Gemstone)
Config.RoulettePrice = 25

-- Probabilidades da Roleta (Total deve ser 100)
Config.RarityRates = {
    ["common"] = 70,    -- 70% de chance
    ["rare"] = 20,      -- 20% de chance
    ["epic"] = 8,       -- 8% de chance
    ["legendary"] = 2   -- 2% de chance
}

-- Ativar sistema de bônus (salário/ilegal) através das pelúcias
Config.Bonification = true