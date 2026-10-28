Config = {}

Config.DataKey = 'pipa:inv'
Config.LogsResource = 'bp_logs'

Config.MinLine    = 1.0
Config.StartLine  = 12.0
Config.LineStep   = 2.5
Config.LineSpeed  = 8.0
Config.ReelSpeed  = 2.5
Config.LooseReelSpeed = 3.0
Config.PullReelBoost = 1.8
Config.HeightFactor = 0.5

-- SCROLL: para cima a pipa sobe pro céu, para baixo desce.
Config.ScrollElevStep = 7.0   -- graus de subida por clique do scroll
Config.ScrollLineStep = 3.0   -- metros de linha soltos junto (dá sensação de ir longe)
Config.ElevEase       = 4.5   -- velocidade com que a pipa alcança a altura desejada
Config.ElevSinkRate   = 1.6   -- quanto o alvo cai sozinho por segundo (gravidade suave)
Config.ElevBobAmp     = 1.8   -- balanço vertical do vento

Config.AutoStore = {
    enabled   = true,
    startLine = 5.0,
    storeLine = 1.0,
    holdTime  = 350,
    pullSpeed = 3.2,
    elevTarget = 12.0,
    elevEase  = 2.2,
}

Config.SideLimit    = 1.2  
Config.SideLimitMin = 20.0 

Config.SideSpeed   = 5.0   
Config.SpeedBoost  = 1.1
Config.PullImpulse = 2.4  
Config.PullDamping = 1.6
Config.IdleDamping = 5.0
Config.Smoothing   = 1.4
Config.ForcePerPull = 0.18
Config.ForceDecay  = 0.30
Config.HeightBoost = 12.0
Config.MinHeight   = 2.0
Config.DirectionTime = 900
Config.PullWindow    = 400

Config.InitialElev  = 42.0  
Config.MaxElev      = 82.0
Config.MinElev      = -72.0  

Config.KiteSpinSpeed = 0.0
Config.PropLodDist   = 1000

Config.MaxDescent    = 0.85

Config.CollisionEnabled      = true
Config.CollisionTime         = 350   
Config.CollisionGroundMargin = 1.0 
Config.CollisionRadius       = 1.2  
Config.LoseKiteOnSnag        = true 

Config.Drop = {
    FallSpeed          = 4.0, 
    SwayAmp            = 2.0,    
    CatchDist          = 3.0,  
    CatchGrace         = 1500,  
    HandCatchDist      = 3.5,
    HandCatchHeight    = 10.0,
    ServerCatchDist    = 15.0,  
    PickupDist         = 2.0,    
    PickupValidateDist = 15.0,   
    MarkerDist         = 40.0,   
    MaxSpawnDist       = 250.0,  
    DespawnTime        = 240000, 
}

Config.CutDist         = 1.2
Config.CutSegments     = 4
Config.CutCooldown     = 2000
Config.ServerCutDist   = 6.0
Config.MaxDuelDist     = 300.0
Config.KillfeedDist    = 300.0
Config.DuelForceBonus  = 1.2
Config.DuelHeightBonus = 0.8
Config.DuelHeightScale = 25.0
Config.DuelWeakDefense = 0.15
Config.LoseKiteOnCut   = true

Config.DrawDist     = 460.0
Config.SyncInterval = 50     -- ms entre pacotes (menor = menos delay pros outros)
Config.LineSegments = 8
Config.LineCurve    = 1.6
Config.LineWidth    = 0.01

-- Suavização da pipa dos OUTROS players (interpolação entre pacotes).
-- Maior = acompanha mais rápido, menor = mais suave.
Config.RemotePosLerp = 14.0
Config.RemoteRotLerp = 10.0

Config.Marker = {
    enabled = true,
    scale   = 0.45,
    dist    = 1.2,
}

Config.Anim = {
    dict = 'amb@world_human_stand_fishing@idle_a',
    anim = 'idle_c',
    flag = 49,
}

Config.Reel = {
    model      = `myc_carretel`,
    bone       = 60309,
    pos        = { x = 0.070, y = -0.030, z = 0.120 },
    rot        = { x = 120.0, y = 85.0, z = 10.0 },
    scale      = 0.950,
    remote     = true,
    remoteDist = 120.0,
    lodDist    = 200,
}


-- Pose ÚNICA para TODAS as pipas (mesma da Pipa Flamengo / murcha).
-- dir: 0=puxando, 1=direita, 2=idle, 3=esquerda
Config.DirectionRot = {
    [0] = { pitch = 260.0, roll = 170.0, yaw = 180.0 },
    [1] = { pitch = 0.0,   roll = 275.0, yaw = 275.0 },
    [2] = { pitch = 75.0,  roll = 355.0, yaw = 190.0 },
    [3] = { pitch = 185.0, roll = 280.0, yaw = 280.0 },
}

-- Flip global do modelo.
Config.KiteBaseOffset = { pitch = 180.0, roll = 0.0, yaw = 0.0 }

-- Centro visual da pipa (local do prop) = onde a linha gruda.
-- Ajuste fino com /pipa_tune (ALT+numpad) se a linha sair da ponta.
Config.KiteCenterOffset = { x = 0.0, y = 0.0, z = 0.0 }
Config.KiteAlignCenter = true
Config.KiteElevFactor = 0.0

-- Vazio de propósito: todas as pipas usam Config.DirectionRot (pose do Flamengo).
-- Para dar uma pose exclusiva a uma pipa, adicione aqui, ex.:
-- Config.KiteRot['cafifa'] = { [0] = {...}, [1] = {...}, [2] = {...}, [3] = {...} }
Config.KiteRot = {}

function Config.RotFor(kiteId, dir)
    local t = kiteId and Config.KiteRot[kiteId]
    if t and t[dir] then return t[dir] end
    return Config.DirectionRot[dir] or Config.DirectionRot[0]
end

-- Rotação final = pose peixinho + flip base + leve balanço
function Config.ComputeKiteRotation(kiteId, dir, pedHeading, elev, now)
    local pose = Config.RotFor(kiteId, dir)
    local base = Config.KiteBaseOffset or { pitch = 0.0, roll = 180.0, yaw = 0.0 }
    elev = tonumber(elev) or 0.0
    now = tonumber(now) or GetGameTimer()
    local elevFactor = Config.KiteElevFactor or 0.0

    local sway = 0.0
    if dir == 2 then
        sway = math.sin(now / 520.0) * 4.0
    end

    return {
        pitch = (base.pitch or 0.0) + (pose.pitch or 0.0) + (elev * elevFactor),
        roll = (base.roll or 0.0) + (pose.roll or 0.0) + sway,
        yaw = pedHeading + (base.yaw or 0.0) + (pose.yaw or 0.0),
    }
end

-- Converte offset local do prop em deslocamento mundo (ordem ZXY = 2)
function Config.RotateLocalOffset(ox, oy, oz, pitch, roll, yaw)
    ox, oy, oz = ox or 0.0, oy or 0.0, oz or 0.0
    local p = math.rad(pitch or 0.0)
    local r = math.rad(roll or 0.0)
    local y = math.rad(yaw or 0.0)

    local c, s = math.cos(y), math.sin(y)
    local x1 = ox * c - oy * s
    local y1 = ox * s + oy * c
    local z1 = oz

    c, s = math.cos(p), math.sin(p)
    local x2 = x1
    local y2 = y1 * c - z1 * s
    local z2 = y1 * s + z1 * c

    c, s = math.cos(r), math.sin(r)
    local x3 = x2 * c + z2 * s
    local y3 = y2
    local z3 = -x2 * s + z2 * c

    return x3, y3, z3
end

function Config.GetKiteCenterOffset(kiteId)
    local o = Config.KiteCenterOffset or { x = 0.0, y = 0.0, z = 0.0 }
    if kiteId and Config.KiteCenterById and Config.KiteCenterById[kiteId] then
        o = Config.KiteCenterById[kiteId]
    end
    return o.x or 0.0, o.y or 0.0, o.z or 0.0
end

Config.Kites = {
    { id = 'simples', name = 'Peixinho',     prop = `vdg_pipa_01`, price = 200,  bonus = 0.0 },
    { id = 'careca',  name = 'Peixinho Mengão',      prop = `vdg_pipa_02`, price = 500,  bonus = 0.08 },
    { id = 'treme',   name = 'Peixinho Palmeiras', prop = `vdg_pipa_03`, price = 1200, bonus = 0.15 },
    { id = 'raiada',  name = 'Peixinho Botafogo',      prop = `vdg_pipa_04`, price = 2500, bonus = 0.25 },
    { id = 'cafifa',  name = 'Peixinho Cruzeiro',      prop = `vdg_pipa_05`, price = 5000, bonus = 0.35 },
    { id = 'murcha1', name = 'Pipa Favela',   prop = `vdg_murcha_01`, price = 300,   bonus = 0.03 },
    { id = 'murcha2', name = 'Pipa Santos',   prop = `vdg_murcha_02`, price = 800,   bonus = 0.10 },
    { id = 'murcha3', name = 'Pipa Flamengo',   prop = `vdg_murcha_03`, price = 1600,  bonus = 0.17 },
    { id = 'murcha4', name = 'Pipa Palmeiras',   prop = `vdg_murcha_04`, price = 3000,  bonus = 0.24 },
    { id = 'murcha5', name = 'Pipa São Paulo',   prop = `vdg_murcha_05`, price = 5500,  bonus = 0.30 },
    { id = 'murcha6', name = 'Pipa P2C',   prop = `vdg_murcha_06`, price = 9000,  bonus = 0.38 },
    { id = 'murcha7', name = 'Pipa Corinthians',   prop = `vdg_murcha_07`, price = 15000, bonus = 0.45 },
}

Config.Lines = {
    { id = 'comum',   name = 'Linha Comum',   power = 1.0, cuts = false, color = {245, 245, 245, 160}, maxLine = 80.0,  price = 0 },
    { id = 'fio10',   name = 'Fio 10',        power = 1.4, cuts = true,  color = {170, 215, 255, 180}, maxLine = 95.0,  price = 500 },
    { id = 'fio24',   name = 'Fio 24',        power = 1.8, cuts = true,  color = {90, 170, 255, 190},  maxLine = 105.0, price = 1200 },
    { id = 'seda',    name = 'Linha de Seda', power = 2.3, cuts = true,  color = {255, 210, 90, 200},  maxLine = 115.0, price = 2500 },
    { id = 'cerol',   name = 'Cerol',         power = 3.0, cuts = true,  color = {255, 80, 80, 210},   maxLine = 125.0, price = 5000 },
    { id = 'chilena', name = 'Linha Chilena', power = 4.0, cuts = true,  color = {255, 40, 180, 220},  maxLine = 140.0, price = 10000 },
}

Config.Shops = {}

Config.ShopBlip = {
    sprite = 66,
    color  = 47,
    scale  = 0.75,
    name   = 'Loja de Pipas',
}

Config.ShopMarker = {
    color  = {255, 160, 40, 120},
    radius = 0.8,
}

Config.InteractDist   = 1.5
Config.ServerBuyDist  = 10.0
Config.MarkerDist     = 25.0

Config.Mouse = {
    scrollUp   = 15,
    scrollDown = 14,
    clickLeft  = 24,
    clickRight = 25,
}

Config.Keys = {
    release = 172,
    reel    = 173,
    left    = 174,
    right   = 175,
}

Config.BlockedControls = { 12, 13, 14, 15, 16, 17, 24, 25, 37, 44, 140, 141, 142, 257, 263, 264 }

Config.UseItems = {
    enabled    = true,
    kitePrefix = 'pipa_',
    linePrefix = 'linha_',
    freeLine   = 'comum',
}

Config.KitesById = {}
Config.KitesByModel = {}
Config.KitesByItem = {}
for _, kite in ipairs(Config.Kites) do
    kite.item = Config.UseItems.kitePrefix .. kite.id
    Config.KitesById[kite.id] = kite
    Config.KitesByModel[kite.prop % 4294967296] = kite
    Config.KitesByItem[kite.item] = kite
end

Config.LinesById = {}
Config.LinesByItem = {}
for i, line in ipairs(Config.Lines) do
    line.index = i
    line.item = Config.UseItems.linePrefix .. line.id
    Config.LinesById[line.id] = line
    Config.LinesByItem[line.item] = line
end
