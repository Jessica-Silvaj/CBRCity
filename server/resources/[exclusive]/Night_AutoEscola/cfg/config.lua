-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
comandos = {
    verMinhaCnh          = { cmd = "cnh",     perms = { "Admin"} },
    policiaConsultarCnh  = { cmd = "vcnh",    perms = { "Policia", "Admin" } },
    policiaRemoverCnh    = { cmd = "rcnh",    perms = { "Policia", "Admin" } },
    policiaAddCnh        = { cmd = "acnh",    perms = { "Admin" } },
    policiaRemoverPontos = { cmd = "rpontos", perms = { "Policia", "Admin" } },
    policiaAddPontos     = { cmd = "apontos", perms = { "Policia", "Admin" } },
    gravarRota           = { cmd = "zgc",     perms = { "Admin" } },
    colocarCones         = { cmd = "zcc",     perms = { "Admin" } },
    resetCooldown        = { cmd = "rcooldown",  perms = { "Admin" } },
    resetAllCooldowns    = { cmd = "rcooldowns", perms = { "Admin" } },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS E ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
blip_provas = {
    -- Auto Escola
    cds       = { 208.74,-1382.74,30.58 },
    cdsFinal  = { 200.83, -1388.54, 30.58, 229.61 }, -- Muda aqui a coordenada de retorno ao finalizar o exame!
    item      = "laudoteorico",
    itemFinal = "cartaconducao",

    -- NPC + interação da Auto Escola (atendente)
    autoEscolaModel    = "a_m_y_business_01",
    autoEscolaHeading  = 136.07,
    autoEscolaScenario = "WORLD_HUMAN_STAND_IMPATIENT",  -- cenário/exposição do atendente

    -- Médico da Auto Escola
    medicoCds         = {214.66,-1400.18,30.58},
    medicoHeading     = 323.15,   -- direção do NPC médico (ajusta se ficar virado ao contrário)
    medicoModel       = "s_m_m_doctor_01",
    medicoScenario    = "WORLD_HUMAN_CLIPBOARD",          -- cenário/exposição do médico
    medicoCusto       = 500,
    medicoValidadeDias = 365,

    configBlipInMap = {
        text  = "Auto Escola",
        icon  = 545,
        color = 5,
    },
    configBlipMedico = {
        text  = "Médico Auto Escola",
        icon  = 61,
        color = 1,
    },
    configDrawnMaker = {
        type  = 36,
        color = { 244, 5, 82 },
        z     = 0.3,
    },
    configDrawnMakerMedico = {
        type  = 36,
        color = { 0, 200, 100 },
        z     = 0.3,
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGRAS DE EXAME (Portugal)
-----------------------------------------------------------------------------------------------------------------------------------------
examRules = {
    -- MODO DEV: usa as 3 perguntas de teste (perguntasDev) e ignora pagamento/atestado/cooldown
    -- no exame teórico. Deixar SEMPRE false em produção.
    dev = false,
    teorico = {
        totalPerguntas = 15,   -- (não usado; ver cfg/perguntas.lua)
        maxErros       = 3,    -- máximo de erros permitidos (27 certas de 30)
        cooldownSeg    = 600, -- segundos de espera após reprovar (1800 = 30 min)
    },
    pratico = {
        cooldownSeg     = 1800, -- segundos de espera após reprovar (1800 = 30 min)
        tempoManobraMax = 300,  -- segundos máximos para concluir manobras (5 min)
        maxBatidas      = 3,    -- nº de batidas/colisões até reprovar
        toleranciaVelocidade = 5,  -- km/h acima do limite tolerados antes de reprovar
        limiteDefault   = 60,   -- limite de velocidade quando o checkpoint não define um
        tempoForaVeiculo = 10,  -- segundos fora do veículo até reprovar
        -- Posição do HUD do exame (velocidade/limite/batidas). Valores: "bottom-left",
        -- "bottom-center", "bottom-right", "top-left", "top-center", "top-right",
        -- "middle-left", "middle-right".
        hudPosition     = "middle-left",
        -- Direção perigosa: segurar esta tecla reprova (36 = LEFT CTRL, a que empina a moto)
        controlEmpinar  = 36,
        tempoEmpinar    = 600,  -- ms segurando a tecla até reprovar
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE PONTOS
-----------------------------------------------------------------------------------------------------------------------------------------
-- pontosConfig é definido após lang.lua (que define L e pais)
pontosConfig = {
    inicial = 0,
    maximo  = L and L.pontos or 20,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS
-----------------------------------------------------------------------------------------------------------------------------------------
rotas = {
    [1] = {
        { 228.06, -1389.03, 30.51, velocidadeMax = 60 },
        { 220.40, -1406.93, 28.90 },
        { 184.07, -1396.04, 28.00, velocidadeMax = 80 },
        { 210.09, -1327.85, 28.86 },
        { 212.71, -1147.49, 28.86 },
        { 83.05,  -1136.40, 28.68 },
        { 69.66,  -1334.23, 28.76 },
        { -70.94, -1364.08, 28.92 },
        { -209.28,-1412.25, 30.77 },
        { -357.95,-1420.19, 28.82 },
        { -241.58,-1243.92, 36.81, velocidadeMax = 110 },
        { -6.31,  -1237.12, 36.76 },
        { 410.16, -1225.85, 40.00 },
        { 624.32, -1240.98, 40.53 },
        { 774.26, -1245.23, 26.32 },
        { 789.94, -1384.34, 26.39 },
        { 555.70, -1429.83, 28.91, velocidadeMax = 80 },
        { 404.47, -1373.16, 29.70 },
        { 248.49, -1298.55, 28.81 },
        { 170.21, -1373.44, 28.85 },
        { 219.47, -1439.26, 28.86 },
        { 284.41, -1394.39, 29.97 },
        { 270.92, -1358.59, 31.45 },
        { 221.85, -1355.60, 30.11 },
    },

    [2] = {
        { 227.77, -1387.38, 29.94, velocidadeMax = 60 },
        { 222.40, -1404.87, 29.16 },
        { 180.36, -1402.71, 28.82, velocidadeMax = 80 },
        { 112.45, -1364.52, 29.35 },
        { -79.40, -1353.58, 29.28 },
        { -96.03, -1316.18, 29.31 },
        { -93.15, -1238.56, 28.98 },
        { -93.62, -1160.45, 25.74 },
        { -59.76, -1147.60, 25.85 },
        { 44.47,  -1144.88, 29.29 },
        { 51.26,  -1218.65, 28.76 },
        { 66.30,  -1319.49, 29.30 },
        { 130.51, -1387.33, 29.30 },
        { 223.55, -1441.24, 29.34 },
        { 251.54, -1435.59, 29.16 },
        { 283.69, -1380.44, 31.58 },
        { 271.45, -1368.61, 31.94 },
        { 252.94, -1343.59, 31.91 },
        { 219.69, -1370.01, 30.56 },
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS DE ROTA / MANOBRAS
-----------------------------------------------------------------------------------------------------------------------------------------
configDrawnMakerRotas = {
    [1] = { type = 1,  color = { 255, 255, 255 }, z = 1.5 },
    [2] = { type = 4,  color = { 255, 7,   58  }, z = 0.5 },
    [3] = { type = 21, color = { 255, 7,   58  }, z = 0.5 },
}

configDrawnMakerManobras = {
    type  = 1,
    color = { 0, 180, 255 },
    z     = 1.5,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CATEGORIAS
-----------------------------------------------------------------------------------------------------------------------------------------
config = {
    ["A"] = {
        label       = "Motos",
        vehicle     = "cg160",
        rota        = rotas[2],
        spawnLoc    = { 215.19, -1381.05, 30.07, 265.74 },
        maxErros    = 3,
        tempoMinimo = 60,
        prerequisito = nil,
        instrutor   = { existe = true, model = "a_m_y_genstreet_01" },
        valor       = 5000,
        validadeAnos = 10,
        img         = "assets/moto.png",
    },
    ["B"] = {
        label       = "Carros",
        vehicle     = "golg9",
        rota        = rotas[2],
        spawnLoc    = { 215.19, -1381.05, 30.07, 265.74 },
        maxErros    = 3,
        tempoMinimo = 60,
        prerequisito = nil,
        instrutor   = { existe = true, model = "ig_mp_agent14" },
        valor       = 5000,
        validadeAnos = 10,
        img         = "assets/carro.png",
    },
    ["C"] = {
        label       = "Caminhões",
        vehicle     = "hauler",
        rota        = rotas[1],
        spawnLoc    = { 218.88, -1381.34, 30.78, 269.82 },
        maxErros    = 3,
        tempoMinimo = 90,
        prerequisito = nil,
        -- prerequisito = "B",
        instrutor   = { existe = true, model = "ig_mp_agent14" },
        valor       = 8000,
        validadeAnos = 5,
        img         = "assets/caminhoes.png",
    },
    ["D"] = {
        label       = "Ônibus",
        vehicle     = "coachrv",
        rota        = rotas[1],
        spawnLoc    = { 212.56, -1372.78, 31.43, 228.27 },
        maxErros    = 3,
        tempoMinimo = 90,
        prerequisito = nil,
        -- prerequisito = "B",
        instrutor   = { existe = true, model = "ig_mp_agent14" },
        valor       = 8000,
        validadeAnos = 5,
        img         = "assets/onibus.png",
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ZONAS DE ESTACIONAMENTO (manobras)
-----------------------------------------------------------------------------------------------------------------------------------------
parkInfos = {
    ["A"]  = {
        cdsVehicle = { 250.78,-1412.09,30.58,51.03 },
        cdsBlips   = { { 250.78,-1412.09,30.58 } },
        cones = {
            { 250.59,-1412.84,30.58 }, { 250.11,-1412.43,30.58 },
            { 249.7,-1412.03,30.58 }, { 251.49,-1411.92,30.58 },
            {250.95,-1411.49,30.58 }, {250.48,-1411.08,30.58 },
        },
    },

    ["B"] = {
        cdsVehicle = { 241.42,-1395.09,29.81,257.96 },
        cdsBlips = {
            { 241.42,-1395.09,29.81 }
        },
        cones = {
            { 245.41, -1396.84, 29.51 }, { 245.59, -1395.86, 29.50 },
            { 245.76, -1394.87, 29.48 }, { 245.93, -1393.89, 29.45 },
            { 244.81, -1393.64, 29.45 }, { 243.62, -1393.40, 29.45 },
            { 242.48, -1393.14, 29.45 }, { 241.31, -1392.88, 29.44 },
            { 240.14, -1392.69, 29.45 }, { 238.53, -1392.31, 29.45 },
            { 238.30, -1393.20, 29.48 }, { 238.12, -1394.37, 29.52 },
            { 237.96, -1395.32, 29.52 },
        },
    },

    ["C"] = {
        cdsVehicle = { 243.84,-1395.98,29.81,260.79 },
        cdsBlips   = { { 243.84,-1395.98,29.81 } },
        cones = {
            { 249.11, -1394.19, 29.57 }, { 248.13, -1393.98, 29.57 },
            { 247.15, -1393.75, 29.57 }, { 246.18, -1393.54, 29.57 },
            { 245.20, -1393.32, 29.57 }, { 244.22, -1393.11, 29.57 },
            { 243.24, -1392.89, 29.57 }, { 242.27, -1392.65, 29.57 },
            { 241.30, -1392.44, 29.57 }, { 240.31, -1392.24, 29.57 },
            { 239.33, -1392.04, 29.56 }, { 238.48, -1392.63, 29.46 },
            { 238.28, -1393.67, 29.49 }, { 238.08, -1394.54, 29.52 },
            { 237.88, -1395.46, 29.52 }, { 248.71, -1397.94, 29.52 },
            { 248.87, -1397.24, 29.52 }, { 249.07, -1396.47, 29.52 },
            { 249.27, -1395.70, 29.49 }, { 249.50, -1394.86, 29.46 },
        },
    },

    ["D"] = {
        cdsVehicle = { 246.14,-1396.61,30.5,260.79 },
        cdsBlips   = { { 246.14,-1396.61,30.5 } },
        cones = {
            { 250.21,-1394.43,30.57}, { 251.45,-1394.61,30.57}, 
            { 252.43,-1394.82,30.57}, {253.35,-1395.08,30.57},
            { 249.11, -1394.19, 29.57 }, { 248.13, -1393.98, 29.57 },
            { 247.15, -1393.75, 29.57 }, { 246.18, -1393.54, 29.57 },
            { 245.20, -1393.32, 29.57 }, { 244.22, -1393.11, 29.57 },
            { 243.24, -1392.89, 29.57 }, { 242.27, -1392.65, 29.57 },
            { 241.30, -1392.44, 29.57 }, { 240.31, -1392.24, 29.57 },
            { 239.33, -1392.04, 29.56 }, { 238.48, -1392.63, 29.46 },
            { 238.28, -1393.67, 29.49 }, { 238.08, -1394.54, 29.52 },
            { 237.88, -1395.46, 29.52 }, { 253.51,-1395.83,30.48 },
            { 253.39,   -1396.43,30.5 }, { 253.31,-1397.05,30.5 },
            { 253.14,-1397.82,30.51 },
        },
    },
}
