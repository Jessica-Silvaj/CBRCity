Config = {}

-- Tipos de climas disponíveis e sua conversão para o jogo
Config.WeatherTypes = {
    ENSOLARADO = "EXTRASUNNY",
    LIMPO = "CLEAR",
    NEUTRO = "NEUTRAL",
    POLUIDO = "SMOG",
    NEBLINA = "FOGGY",
    ENCOBERTO = "OVERCAST",
    NUBLADO = "CLOUDS",
    LIMPANDO = "CLEARING",
    CHUVOSO = "RAIN",
    TEMPESTADE = "THUNDER",
    NEVANDO = "SNOW",
    NEVASCA = "BLIZZARD",
    NEVE_LEVE = "SNOWLIGHT",
    NEVE = "XMAS",
    HALLOWEEN = "HALLOWEEN"
}

-- Configurações do sistema automático
Config.AutoWeatherEnabled = true          -- Ativar mudança automática de clima
Config.WeatherChangeInterval = 30         -- Intervalo em minutos para mudar o clima
Config.AutoWeatherList = {                -- Lista de climas para o sorteio automático
    "EXTRASUNNY", 
    -- "CLEAR", 
    -- "NEUTRAL", 
    -- "SMOG",
    -- "FOGGY", 
    -- "OVERCAST",
    -- "CLOUDS", 
    -- "CLEARING",
    -- "RAIN",
    -- "THUNDER",
    -- "SNOW",
    -- "BLIZZARD",
    -- "SNOWLIGHT",
    -- "XMAS",
    -- "HALLOWEEN"
}
