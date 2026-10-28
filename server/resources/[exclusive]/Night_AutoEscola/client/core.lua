-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel  = module("vrp","lib/Tunnel")
local Proxy   = module("vrp","lib/Proxy")
local vRPSrv  = Tunnel.getInterface("Night_AutoEscola")
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE
-----------------------------------------------------------------------------------------------------------------------------------------
local NUIOpen        = false
local EmExame        = false
local CategoriaAtual = nil
local VeiculoExame   = nil
local InstructorNPC  = nil
local RotaBlips      = {}
local RecordMode     = false
local RecordCoords   = {}
local ConesObj       = {}
local ThemeColor     = "#0143bb"
local FaseManobras   = false   -- true durante a fase de manobras
local ConesManobras  = {}      -- cones spawned para as manobras
local MainBlip       = nil     -- blip da auto escola
local MedicoBlip     = nil     -- blip do médico
local MedicoPed      = nil     -- NPC do médico
local AutoEscolaPed  = nil     -- NPC do atendente da auto escola
local ExameFinalizando = false -- evita reprovar duas vezes em simultâneo
local MugshotHandle    = nil   -- headshot do jogador para a carta

CreateThread(function()
    local Ok, Colors = pcall(function() return vRPSrv.GetColors() end)
    if Ok and Colors and Colors.primaryColor then
        local R, G, B = Colors.primaryColor:match("(%d+),(%d+),(%d+)")
        if R then
            ThemeColor = string.format("#%02x%02x%02x", tonumber(R), tonumber(G), tonumber(B))
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI
-----------------------------------------------------------------------------------------------------------------------------------------
local function SendNui(Action, Data)
    SendNUIMessage({ action = Action, data = Data })
end

local function OpenNUI(Page, Data)
    NUIOpen = true
    SetNuiFocus(true, true)
    SendNui("setThemeColor", ThemeColor)
    local PageData = Data or {}
    PageData.page  = Page
    SendNui("setPage", PageData)
    SendNui("setVisible", true)
end

-- Gera um headshot (mugshot) do personagem do jogador e devolve a URL nui-img.
local function GerarMugshot()
    if MugshotHandle then
        UnregisterPedheadshot(MugshotHandle)
        MugshotHandle = nil
    end
    local Ped    = PlayerPedId()
    local Handle = RegisterPedheadshotTransparent(Ped)
    local Tries  = 0
    while (not IsPedheadshotReady(Handle) or not IsPedheadshotValid(Handle)) and Tries < 150 do
        Wait(15)
        Tries = Tries + 1
    end
    if IsPedheadshotValid(Handle) then
        MugshotHandle = Handle
        local Txd = GetPedheadshotTxdString(Handle)
        return ("https://nui-img/%s/%s"):format(Txd, Txd)
    end
    UnregisterPedheadshot(Handle)
    return nil
end

local function CloseNUI()
    NUIOpen = false
    SetNuiFocus(false, false)
    SendNui("setVisible", false)
    if MugshotHandle then
        UnregisterPedheadshot(MugshotHandle)
        MugshotHandle = nil
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFICAÇÃO CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
local function NotifyLocal(kind, msg)
    TriggerEvent("Notify", "Auto Escola", msg, kind, 6000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FADES / TELEPORTE / HUD
-----------------------------------------------------------------------------------------------------------------------------------------
local function FadeOut(ms)
    DoScreenFadeOut(ms or 500)
    local T = 0
    while not IsScreenFadedOut() and T < 60 do Wait(15); T = T + 1 end
end

local function FadeIn(ms)
    DoScreenFadeIn(ms or 600)
end

-- Teleporta o jogador de volta à entrada da auto escola
local function VoltarAutoEscola()
    local C   = blip_provas.cdsFinal or blip_provas.cds
    local Ped = PlayerPedId()
    SetEntityCoords(Ped, C[1], C[2], C[3], false, false, false, false)
    SetEntityHeading(Ped, C[4] or 90.0)
end

-- Atualiza/esconde o HUD do exame (overlay NUI)
local function HudExame(Data)
    SendNui("examHud", Data)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN VEÍCULO
-----------------------------------------------------------------------------------------------------------------------------------------
local function SpawnVeiculo(Cat)
    local Hash = GetHashKey(Cat.vehicle)

    -- Modelo inexistente/inválido? Aborta em vez de travar para sempre.
    if not IsModelInCdimage(Hash) or not IsModelAVehicle(Hash) then
        NotifyLocal("vermelho", "Veículo de exame '" .. tostring(Cat.vehicle) .. "' não existe no servidor. Avisa um admin.")
        return nil
    end

    RequestModel(Hash)
    local Tries = 0
    while not HasModelLoaded(Hash) and Tries < 300 do Wait(10); Tries = Tries + 1 end
    if not HasModelLoaded(Hash) then
        NotifyLocal("vermelho", "Não foi possível carregar o veículo de exame. Tenta novamente.")
        return nil
    end

    local S   = Cat.spawnLoc
    local Veh = CreateVehicle(Hash, S[1], S[2], S[3], S[4], true, false)

    NetworkRegisterEntityAsNetworked(Veh)
    local Attempts = 0
    while not NetworkGetEntityIsNetworked(Veh) do
        NetworkRegisterEntityAsNetworked(Veh)
        Wait(1)
        Attempts = Attempts + 1
        if Attempts > 300 then break end
    end

    local NetId = VehToNet(Veh)
    SetNetworkIdExistsOnAllMachines(NetId, true)
    SetNetworkIdCanMigrate(NetId, true)
    SetVehicleNumberPlateText(Veh, "AUTOESCO")
    SetEntityAsMissionEntity(Veh, true, true)
    SetVehicleHasBeenOwnedByPlayer(Veh, true)
    SetVehicleNeedsToBeHotwired(Veh, false)
    SetVehRadioStation(Veh, "OFF")

    -- core-vehicles: marca o veículo como "unlocked" senão a thread autoLockAIVehicles
    -- desliga o motor continuamente (veículo não anda). É o state que o framework reconhece.
    Entity(Veh).state:set("unlocked", 1, true)
    SetVehicleEngineOn(Veh, true, true, false)
    SetVehicleFuelLevel(Veh, 100.0)
    SetVehicleUndriveable(Veh, false)
    SetVehicleDoorsLocked(Veh, 0)

    SetModelAsNoLongerNeeded(Hash)
    return Veh
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN INSTRUTOR
-----------------------------------------------------------------------------------------------------------------------------------------
local function SpawnInstrutor(Cat, Veh)
    if not Cat.instrutor or not Cat.instrutor.existe then return nil end
    if not Veh or Veh == 0 or not DoesEntityExist(Veh) then return nil end
    local Hash = GetHashKey(Cat.instrutor.model)
    if not IsModelInCdimage(Hash) then return nil end
    RequestModel(Hash)
    local Tries = 0
    while not HasModelLoaded(Hash) and Tries < 300 do Wait(10); Tries = Tries + 1 end
    if not HasModelLoaded(Hash) then return nil end

    -- Assento 0 = passageiro da frente (NÃO -1, que é o do motorista)
    local Ped = CreatePedInsideVehicle(Veh, 1, Hash, 0, true, false)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)
    SetPedFleeAttributes(Ped, 0, false)
    SetModelAsNoLongerNeeded(Hash)
    return Ped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS DE ROTA
-----------------------------------------------------------------------------------------------------------------------------------------
local function CriarBlipsRota(Rota)
    for _, B in ipairs(RotaBlips) do
        if DoesBlipExist(B) then RemoveBlip(B) end
    end
    RotaBlips = {}

    for I, P in ipairs(Rota) do
        local B = AddBlipForCoord(P[1], P[2], P[3])
        SetBlipSprite(B, 38)
        SetBlipScale(B, 0.8)
        SetBlipColour(B, 5)
        SetBlipAsShortRange(B, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(I == #Rota and "Chegada" or "Checkpoint " .. I)
        EndTextCommandSetBlipName(B)
        RotaBlips[I] = B
    end
end

local function LimparBlipsRota()
    for _, B in ipairs(RotaBlips) do
        if DoesBlipExist(B) then RemoveBlip(B) end
    end
    RotaBlips = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONES DE MANOBRAS
-----------------------------------------------------------------------------------------------------------------------------------------
local function SpawnConesManobras(Cat)
    LimparConesManobras()
    local Park = parkInfos[Cat]
    if not Park or not Park.cones then return end

    local Hash = GetHashKey("prop_mp_cone_03")
    RequestModel(Hash)
    local Tries = 0
    while not HasModelLoaded(Hash) and Tries < 200 do Wait(10); Tries = Tries + 1 end
    if not HasModelLoaded(Hash) then return end

    for _, C in ipairs(Park.cones) do
        local Obj = CreateObject(Hash, C[1], C[2], C[3], true, true, false)
        PlaceObjectOnGroundProperly(Obj)
        FreezeEntityPosition(Obj, true)
        ConesManobras[#ConesManobras + 1] = Obj
    end
    SetModelAsNoLongerNeeded(Hash)
end

function LimparConesManobras()
    for _, Obj in ipairs(ConesManobras) do
        if DoesEntityExist(Obj) then DeleteObject(Obj) end
    end
    ConesManobras = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANUP EXAME
-----------------------------------------------------------------------------------------------------------------------------------------
local function LimparExame()
    EmExame      = false
    FaseManobras = false
    HudExame({ show = false })
    LimparBlipsRota()
    LimparConesManobras()
    ClearGpsPlayerWaypoint()
    pcall(function() vRPSrv.SetDimension(false) end)

    if InstructorNPC and DoesEntityExist(InstructorNPC) then
        DeleteEntity(InstructorNPC)
    end
    if VeiculoExame and DoesEntityExist(VeiculoExame) then
        SetEntityAsMissionEntity(VeiculoExame, false, true)
        DeleteVehicle(VeiculoExame)
    end

    InstructorNPC = nil
    VeiculoExame  = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINALIZAR PRÁTICO (após circulação)
-----------------------------------------------------------------------------------------------------------------------------------------
local function FinalizarPratico(ErrosNum, Motivo)
    if ExameFinalizando then return end
    ExameFinalizando = true
    local Cat = CategoriaAtual

    -- Fade - limpa o exame e devolve o jogador à auto escola
    FadeOut(500)
    LimparExame()
    VoltarAutoEscola()
    Wait(400)

    local Resultado = vRPSrv.ConferirPratico(Cat, ErrosNum or 0)

    if Resultado and Resultado.ok then
        OpenNUI("resultado", {
            passou    = true,
            msg       = string.format("Parabéns! Categoria %s aprovada. Válida até %s.", Cat, Resultado.validade),
            categoria = nil,  -- sem botão de iniciar prático
        })
    else
        OpenNUI("resultado", {
            passou = false,
            msg    = Motivo or (Resultado and Resultado.msg) or "Reprovado!",
        })
    end

    FadeIn(700)
    CategoriaAtual = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FASE DE CIRCULAÇÃO (segunda fase do prático)
-----------------------------------------------------------------------------------------------------------------------------------------
local function IniciarCirculacao(Category)
    local Cat   = config[Category]
    local Rota  = Cat.rota
    local PrCfg = examRules.pratico
    local MaxBatidas    = PrCfg.maxBatidas or 3
    local TolVel        = PrCfg.toleranciaVelocidade or 5
    local LimiteDefault = PrCfg.limiteDefault or 60
    local TempoForaSeg  = PrCfg.tempoForaVeiculo or 10
    local TempoForaMax  = TempoForaSeg * 1000
    local HudPos        = PrCfg.hudPosition or "bottom-center"

    local CpIdx       = 1
    local OffVehicle  = 0
    local Batidas     = 0
    local LimiteAtual = Rota[1].velocidadeMax or LimiteDefault
    local LastBody    = GetVehicleBodyHealth(VeiculoExame)
    local CrashCd     = 0
    local OverCount   = 0

    CriarBlipsRota(Rota)
    SetNewWaypoint(Rota[1][1], Rota[1][2])
    NotifyLocal("amarelo", string.format("Exame de condução! %d checkpoints · respeita os limites · máx %d batidas.", #Rota, MaxBatidas))

    -- Thread de direção perigosa (segurar CTRL = empinar a moto - reprova). Só em motos.
    local ControlEmpinar = PrCfg.controlEmpinar or 36
    local TempoEmpinar   = PrCfg.tempoEmpinar or 600
    local EhMoto = DoesEntityExist(VeiculoExame) and IsThisModelABike(GetEntityModel(VeiculoExame))
    if EhMoto then
        CreateThread(function()
            local Inicio = nil
            while EmExame do
                Wait(0)
                if IsControlPressed(0, ControlEmpinar) or IsDisabledControlPressed(0, ControlEmpinar) then
                    if not Inicio then Inicio = GetGameTimer() end
                    if GetGameTimer() - Inicio >= TempoEmpinar then
                        NotifyLocal("vermelho", "Direção perigosa!")
                        FinalizarPratico(999, "Reprovado! Direção perigosa (empinar a moto).")
                        return
                    end
                else
                    Inicio = nil
                end
            end
        end)
    end

    -- Thread de lógica (500ms)
    CreateThread(function()
        while EmExame do
            Wait(500)

            if not DoesEntityExist(VeiculoExame) then
                NotifyLocal("vermelho", L.veiculoDestruido)
                FinalizarPratico(999, "Reprovado! O veículo foi destruído.")
                return
            end

            -- Fora do veículo por demasiado tempo - reprova
            if GetVehiclePedIsIn(PlayerPedId(), false) ~= VeiculoExame then
                OffVehicle = OffVehicle + 500
                if OffVehicle >= TempoForaMax then
                    NotifyLocal("vermelho", L.saiuVeiculo)
                    FinalizarPratico(999, string.format("Reprovado! Saíste do veículo por mais de %d segundos.", TempoForaSeg))
                    return
                end
            else
                OffVehicle = 0
            end

            local Ponto = Rota[CpIdx]
            if not Ponto then break end

            -- Limite de velocidade vigente (mantém o último definido)
            if Ponto.velocidadeMax then LimiteAtual = Ponto.velocidadeMax end
            local Speed = math.floor(GetEntitySpeed(VeiculoExame) * 3.6)

            -- Batidas / colisões (queda de body health)
            if CrashCd > 0 then CrashCd = CrashCd - 1 end
            local Body = GetVehicleBodyHealth(VeiculoExame)
            if (LastBody - Body) > 35 and CrashCd <= 0 then
                Batidas = Batidas + 1
                CrashCd = 3   -- ~1.5s de debounce por colisão
                NotifyLocal("vermelho", string.format("Batida! (%d/%d)", Batidas, MaxBatidas))
                if Batidas >= MaxBatidas then
                    FinalizarPratico(999, string.format("Reprovado! Bateste %d vezes.", Batidas))
                    return
                end
            end
            if Body < LastBody then LastBody = Body end

            -- Excesso de velocidade - reprova (sustentado ~1s p/ evitar falso positivo)
            if Speed > (LimiteAtual + TolVel) then
                OverCount = OverCount + 1
                if OverCount >= 2 then
                    FinalizarPratico(999, string.format("Reprovado! Excesso de velocidade: %d km/h (limite %d).", Speed, LimiteAtual))
                    return
                end
            else
                OverCount = 0
            end

            -- Chegou ao checkpoint
            local Pos  = GetEntityCoords(PlayerPedId())
            local Dist = #(Pos - vector3(Ponto[1], Ponto[2], Ponto[3]))
            if Dist < 8.0 then
                if RotaBlips[CpIdx] and DoesBlipExist(RotaBlips[CpIdx]) then
                    RemoveBlip(RotaBlips[CpIdx])
                    RotaBlips[CpIdx] = nil
                end
                CpIdx = CpIdx + 1
                if CpIdx > #Rota then
                    FinalizarPratico(0)
                    return
                end
                NotifyLocal("verde", L.checkpoint(CpIdx - 1, #Rota))
                SetNewWaypoint(Rota[CpIdx][1], Rota[CpIdx][2])
            end
        end
    end)

    -- Thread de render (marker + HUD)
    CreateThread(function()
        while EmExame do
            Wait(0)
            local Ponto = Rota[CpIdx]
            if Ponto then
                DrawMarker(
                    configDrawnMakerRotas[1].type,
                    Ponto[1], Ponto[2], Ponto[3] - 0.5,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    4.0, 4.0, configDrawnMakerRotas[1].z,
                    configDrawnMakerRotas[1].color[1],
                    configDrawnMakerRotas[1].color[2],
                    configDrawnMakerRotas[1].color[3],
                    180, false, false, 2, false, nil, nil, false
                )
            end

        end
    end)

    -- Thread do HUD NUI (throttle ~120ms)
    CreateThread(function()
        while EmExame do
            local Speed = DoesEntityExist(VeiculoExame) and math.floor(GetEntitySpeed(VeiculoExame) * 3.6) or 0
            HudExame({
                show       = true,
                speed      = Speed,
                limite     = LimiteAtual,
                batidas    = Batidas,
                maxBatidas = MaxBatidas,
                cp         = math.min(CpIdx, #Rota),
                total      = #Rota,
                position   = HudPos,
            })
            Wait(120)
        end
        HudExame({ show = false })
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FASE DE MANOBRAS (primeira fase do prático)
-----------------------------------------------------------------------------------------------------------------------------------------
local function IniciarFaseManobras(Category)
    FaseManobras = true
    local Park = parkInfos[Category]

    SpawnConesManobras(Category)

    local Target = vector3(
        parkInfos[Category] and parkInfos[Category].cdsVehicle[1] or 0,
        parkInfos[Category] and parkInfos[Category].cdsVehicle[2] or 0,
        parkInfos[Category] and parkInfos[Category].cdsVehicle[3] or 0
    )

    local BlipMan = AddBlipForCoord(Target.x, Target.y, Target.z)
    SetBlipSprite(BlipMan, 1)
    SetBlipColour(BlipMan, 3)
    SetBlipScale(BlipMan, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Zona de Manobras")
    EndTextCommandSetBlipName(BlipMan)
    SetNewWaypoint(Target.x, Target.y)

    local TempoMax = examRules.pratico.tempoManobraMax
    local Inicio   = GetGameTimer()
    local LastBody = GetVehicleBodyHealth(VeiculoExame)

    NotifyLocal("amarelo", L.manobrasTempo(math.floor(TempoMax / 60)))

    -- Thread de lógica das manobras
    CreateThread(function()
        while EmExame and FaseManobras do
            Wait(500)

            if not DoesEntityExist(VeiculoExame) then
                if DoesBlipExist(BlipMan) then RemoveBlip(BlipMan) end
                NotifyLocal("vermelho", "Veículo destruído. Exame cancelado!")
                FadeOut(500)
                LimparExame()
                VoltarAutoEscola()
                Wait(400)
                OpenNUI("resultado", { passou = false, msg = "Veículo destruído durante as manobras." })
                FadeIn(700)
                return
            end

            local Body = GetVehicleBodyHealth(VeiculoExame)
            if Body < LastBody then
                if DoesBlipExist(BlipMan) then RemoveBlip(BlipMan) end
                NotifyLocal("vermelho", "Você bateu na prova de baliza. Exame cancelado!")
                FadeOut(500)
                LimparExame()
                VoltarAutoEscola()
                Wait(400)
                OpenNUI("resultado", { passou = false, msg = "Você bateu o veículo na prova de baliza." })
                FadeIn(700)
                return
            end
            LastBody = Body

            -- Timeout de manobras
            local ElapsedMs = GetGameTimer() - Inicio
            if ElapsedMs >= TempoMax * 1000 then
                if DoesBlipExist(BlipMan) then RemoveBlip(BlipMan) end
                NotifyLocal("vermelho", "Tempo esgotado nas manobras. Exame cancelado!")
                FadeOut(500)
                LimparExame()
                VoltarAutoEscola()
                Wait(400)
                OpenNUI("resultado", { passou = false, msg = "Tempo esgotado na fase de manobras." })
                FadeIn(700)
                return
            end

            -- Verificar se estacionou dentro da zona
            local Pos  = GetEntityCoords(VeiculoExame)
            local Dist = #(Pos - Target)
            local Speed = GetEntitySpeed(VeiculoExame)
            
            local TargetHeading = parkInfos[Category] and parkInfos[Category].cdsVehicle[4] or 0.0
            local VehHeading = GetEntityHeading(VeiculoExame)
            local Diff = math.abs(VehHeading - TargetHeading)
            if Diff > 180.0 then Diff = 360.0 - Diff end

            -- Aceita se distância < 4.0, parado e diferença de direção menor que 20 graus
            if Dist < 4.0 and Speed < 0.5 and Diff < 20.0 then
                -- Validar com servidor
                local Ok, Res = pcall(function() return vRPSrv.ConferirManobras(Category) end)
                if Ok and Res and Res.ok then
                    if DoesBlipExist(BlipMan) then RemoveBlip(BlipMan) end
                    LimparConesManobras()
                    FaseManobras = false
                    NotifyLocal("verde", L.manobrasConcluidas)
                    Wait(2000)
                    IniciarCirculacao(Category)
                    return
                end
            end
        end
    end)

    -- Thread de render das manobras
    CreateThread(function()
        while EmExame and FaseManobras do
            Wait(0)
            DrawMarker(
                configDrawnMakerManobras.type,
                Target.x, Target.y, Target.z - 0.5,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                4.0, 4.0, configDrawnMakerManobras.z,
                configDrawnMakerManobras.color[1],
                configDrawnMakerManobras.color[2],
                configDrawnMakerManobras.color[3],
                180, false, false, 2, false, nil, nil, false
            )
        end
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR PRÁTICO
-----------------------------------------------------------------------------------------------------------------------------------------
local function IniciarPratico(Category)
    if EmExame then return end

    local Cat = config[Category]
    if not Cat then return end

    CategoriaAtual   = Category
    EmExame          = true
    ExameFinalizando = false

    pcall(function() vRPSrv.SetDimension(true) end)

    -- Fade para esconder o spawn do veículo / teleporte
    FadeOut(500)

    VeiculoExame  = SpawnVeiculo(Cat)
    -- Falha ao spawnar (modelo inexistente/inválido) - aborta sem travar o jogador
    if not VeiculoExame or VeiculoExame == 0 or not DoesEntityExist(VeiculoExame) then
        EmExame        = false
        CategoriaAtual = nil
        VeiculoExame   = nil
        FadeIn(500)
        return
    end

    Wait(300)
    InstructorNPC = SpawnInstrutor(Cat, VeiculoExame)

    TaskWarpPedIntoVehicle(PlayerPedId(), VeiculoExame, -1)
    Wait(500)
    FadeIn(700)

    IniciarFaseManobras(Category)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER: spawn de NPC com cenário/exposição
-----------------------------------------------------------------------------------------------------------------------------------------
local function SpawnNPC(Coords, Model, Heading, Scenario)
    local Hash = GetHashKey(Model)
    if not IsModelInCdimage(Hash) then return nil end
    RequestModel(Hash)
    local Tries = 0
    while not HasModelLoaded(Hash) and Tries < 300 do Wait(10); Tries = Tries + 1 end
    if not HasModelLoaded(Hash) then return nil end
    local Ped = CreatePed(4, Hash, Coords[1], Coords[2], Coords[3] - 1.0, Heading or 0.0, false, true)
    DecorSetBool(Ped, "CREATIVE_PED", true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)
    SetPedFleeAttributes(Ped, 0, false)
    FreezeEntityPosition(Ped, true)
    SetEntityAsMissionEntity(Ped, true, true)
    if Scenario then TaskStartScenarioInPlace(Ped, Scenario, 0, true) end
    SetModelAsNoLongerNeeded(Hash)
    return Ped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AÇÕES DAS INTERAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local function AbrirMenuAutoEscola()
    if NUIOpen or EmExame then return end
    local Ok, Status = pcall(function() return vRPSrv.GetStatus() end)
    if not Ok or not Status then
        Status = {
            cnh = {}, hasLaudo = false,
            pontos = 12, suspensa = false,
            atestadoValido = false, atestadoExpira = nil,
            categoriasInfo = {},
            pais = "PT", moeda = "R$", localeNum = "pt-PT", pontosMax = 12, nomePais = "PORTUGAL",
        }
    end
    OpenNUI("menu", {
        categoriasInfo  = Status.categoriasInfo or {},
        hasLaudo        = Status.hasLaudo or false,
        cnh             = type(Status.cnh) == "table" and Status.cnh or {},
        pontos          = Status.pontos or 12,
        suspensa        = Status.suspensa or false,
        atestadoValido  = Status.atestadoValido or false,
        atestadoExpira  = Status.atestadoExpira,
        pais            = Status.pais or "PT",
        moeda           = Status.moeda or "R$",
        localeNum       = Status.localeNum or "pt-PT",
        pontosMax       = Status.pontosMax or 12,
        nomePais        = Status.nomePais,
    })
end

local function AbrirExameMedico()
    if NUIOpen or EmExame then return end
    local Ok, Res = pcall(function() return vRPSrv.IniciarExameMedico() end)
    if not Ok then
        NotifyLocal("vermelho", "Erro ao contactar o médico. Tenta novamente.")
    elseif not Res or not Res.ok then
        NotifyLocal("amarelo", (Res and Res.msg) or "Não foi possível iniciar o exame médico.")
    else
        OpenNUI("medico", {
            perguntas      = Res.perguntas,
            totalPerguntas = Res.totalPerguntas,
            maxErros       = Res.maxErros,
        })
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_AutoEscola:AbrirMenu")
AddEventHandler("Night_AutoEscola:AbrirMenu", function()
    AbrirMenuAutoEscola()
end)

RegisterNetEvent("Night_AutoEscola:AbrirMedico")
AddEventHandler("Night_AutoEscola:AbrirMedico", function()
    AbrirExameMedico()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS + NPCs + INTERAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    if MainBlip and DoesBlipExist(MainBlip) then return end

    -- Blips desativados a pedido do usuário

    -- NPCs (cada um com a sua exposição/cenário)
    AutoEscolaPed = SpawnNPC(blip_provas.cds, blip_provas.autoEscolaModel, blip_provas.autoEscolaHeading, blip_provas.autoEscolaScenario)
    MedicoPed     = SpawnNPC(blip_provas.medicoCds, blip_provas.medicoModel, blip_provas.medicoHeading, blip_provas.medicoScenario)

    -- Interações (target)
    exports.target:AddCircleZone("AutoEscolaMenu",vec3(blip_provas.cds[1], blip_provas.cds[2], blip_provas.cds[3]), 2.75, {
        name = "AutoEscolaMenu",
        heading = 0.0,
        useZ = true
    }, {
        Distance = 2.5,
        options = {
            {
                event = "Night_AutoEscola:AbrirMenu",
                label = "Auto Escola",
                tunnel = "client"
            }
        }
    })

    exports.target:AddCircleZone("AutoEscolaMedico",vec3(blip_provas.medicoCds[1], blip_provas.medicoCds[2], blip_provas.medicoCds[3]), 2.75, {
        name = "AutoEscolaMedico",
        heading = 0.0,
        useZ = true
    }, {
        Distance = 2.5,
        options = {
            {
                event = "Night_AutoEscola:AbrirMedico",
                label = ("Exame Médico (%s)"):format(blip_provas.medicoCusto),
                tunnel = "client"
            }
        }
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("hideFrame", function(_, Callback)
    CloseNUI()
    Callback({ ok = true })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("pagarExame", function(Data, Callback)
    local Ok, Err = pcall(function()
        local Category = tostring(Data.categoria or ""):upper()
        -- Shuffle agora é feito no servidor; aqui apenas reencaminhamos
        local Result = vRPSrv.PagarExame(Category)

        if not (Result and Result.ok) then
            Callback(Result or { ok = false, msg = "Saldo insuficiente ou categoria inválida." })
            return
        end

        Callback({
            ok             = true,
            perguntas      = Result.perguntas,
            categoria      = Category,
            totalPerguntas = Result.totalPerguntas,
            maxErros       = Result.maxErros,
        })
    end)

    if not Ok then
        print("[AutoEscola] Erro em pagarExame: " .. tostring(Err))
        Callback({ ok = false, msg = "Erro interno. Tenta novamente." })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("concluirTeorico", function(Data, Callback)
    local Ok, Err = pcall(function()
        local Acertos  = tonumber(Data.acertos)  or 0
        local Category = tostring(Data.categoria or ""):upper()
        local Result   = vRPSrv.ConferirTeorico(Acertos, Category)
        Callback(Result or { ok = false, msg = "Erro ao processar resultado." })
    end)

    if not Ok then
        print("[AutoEscola] Erro em concluirTeorico: " .. tostring(Err))
        Callback({ ok = false, msg = "Erro interno." })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("concluirMedico", function(Data, Callback)
    local Ok, Err = pcall(function()
        local Acertos = tonumber(Data.acertos) or 0
        local Result  = vRPSrv.ConcluirExameMedico(Acertos)
        Callback(Result or { ok = false, msg = "Erro ao processar exame médico." })
    end)

    if not Ok then
        print("[AutoEscola] Erro em concluirMedico: " .. tostring(Err))
        Callback({ ok = false, msg = "Erro interno." })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("iniciarPratico", function(Data, Callback)
    local Category = tostring(Data.categoria or ""):upper()

    local SessaoOk, SessaoResult = pcall(function()
        local Res = vRPSrv.IniciarExame(Category)
        if not (Res and Res.ok) then
            Callback(Res or { ok = false, msg = "Não foi possível iniciar o exame." })
            return false
        end
        return true
    end)

    if not SessaoOk then
        print("[AutoEscola] Erro em IniciarExame: " .. tostring(SessaoResult))
        Callback({ ok = false, msg = "Erro interno ao iniciar exame." })
        return
    end

    if SessaoResult == false then return end

    Callback({ ok = true })
    CloseNUI()
    Wait(300)
    local Ok, Err = pcall(IniciarPratico, Category)
    if not Ok then
        print("[AutoEscola] Erro em IniciarPratico: " .. tostring(Err))
        NUIOpen = false
        EmExame = false
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("renovarCarta", function(Data, Callback)
    local Ok, Err = pcall(function()
        local Category = tostring(Data.categoria or ""):upper()
        local Result   = vRPSrv.RenovarCarta(Category)
        Callback(Result or { ok = false, msg = "Erro ao renovar." })
    end)

    if not Ok then
        print("[AutoEscola] Erro em renovarCarta: " .. tostring(Err))
        Callback({ ok = false, msg = "Erro interno." })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("verCNH", function(_, Callback)
    local Ok, Status = pcall(function() return vRPSrv.GetStatus() end)
    if not Ok or not Status then Status = { cnh = {}, hasLaudo = false } end
    Callback({
        cnh      = type(Status.cnh) == "table" and Status.cnh or {},
        hasLaudo = Status.hasLaudo or false,
    })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS DE REDE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_AutoEscola:MostrarCNH")
AddEventHandler("Night_AutoEscola:MostrarCNH", function(CNH, Titulo, Pais)
    OpenNUI("cnh", { cnh = CNH, titulo = Titulo or "Carta de Condução", pais = Pais })
end)

RegisterNetEvent("Night_AutoEscola:AbrirPainel")
AddEventHandler("Night_AutoEscola:AbrirPainel", function(Data)
    if NUIOpen then return end
    OpenNUI("policia", Data or {})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("polListarJogadores", function(_, Callback)
    local Ok, Res = pcall(function() return vRPSrv.GetJogadoresOnline() end)
    Callback(Ok and Res or { ok = false, jogadores = {} })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("polConsultar", function(Data, Callback)
    local Ok, Res = pcall(function()
        return vRPSrv.ConsultarCNH(tonumber(Data.targetId))
    end)
    Callback(Ok and Res or { ok = false, msg = "Erro ao consultar." })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("polRemoverPontos", function(Data, Callback)
    local Ok, Res = pcall(function()
        return vRPSrv.PolRemoverPontos(tonumber(Data.targetId), tonumber(Data.qty))
    end)
    Callback(Ok and Res or { ok = false, msg = "Erro ao remover pontos." })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("polRemoverCategoria", function(Data, Callback)
    local Ok, Res = pcall(function()
        return vRPSrv.PolRemoverCategoria(tonumber(Data.targetId), tostring(Data.categoria or ""))
    end)
    Callback(Ok and Res or { ok = false, msg = "Erro ao remover categoria." })
end)

RegisterNetEvent("Night_AutoEscola:AbrirCarta")
AddEventHandler("Night_AutoEscola:AbrirCarta", function(Data)
    if EmExame then return end
    -- Fecha o inventário primeiro para não haver conflito de foco entre os dois NUIs
    TriggerEvent("inventory:Close")
    CreateThread(function()
        Wait(150)
        Data = Data or {}
        -- Foto = headshot do personagem (ao vivo); fallback para o avatar do servidor
        Data.foto = GerarMugshot() or Data.foto
        OpenNUI("carta", Data)
    end)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop", function(Resource)
    if Resource ~= GetCurrentResourceName() then return end
    SetNuiFocus(false, false)
    LimparExame()
    -- Remove blips, NPCs e interações para não acumularem entre restarts
    if MainBlip      and DoesBlipExist(MainBlip)      then RemoveBlip(MainBlip) end
    if MedicoBlip    and DoesBlipExist(MedicoBlip)    then RemoveBlip(MedicoBlip) end
    if MedicoPed     and DoesEntityExist(MedicoPed)   then DeleteEntity(MedicoPed) end
    if AutoEscolaPed and DoesEntityExist(AutoEscolaPed) then DeleteEntity(AutoEscolaPed) end
    if ConesObj then
        for _, Obj in ipairs(ConesObj) do
            if DoesEntityExist(Obj) then DeleteObject(Obj) end
        end
    end
    exports.target:RemCircleZone("AutoEscolaMenu")
    exports.target:RemCircleZone("AutoEscolaMedico")
    HudExame({ show = false })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN: GRAVAR ROTA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(comandos.gravarRota.cmd, function()
    local Ok, HasPerm = pcall(function() return vRPSrv.CheckAdminPerm() end)
    if not Ok or not HasPerm then NotifyLocal("vermelho", "Sem permissão.") return end

    if RecordMode then
        RecordMode = false
        local Output = "-- Rota gravada (" .. #RecordCoords .. " pontos):\n"
        for _, C in ipairs(RecordCoords) do
            Output = Output .. string.format("    { %.2f, %.2f, %.2f },\n", C[1], C[2], C[3])
        end
        print(Output)
        RecordCoords = {}
        NotifyLocal("verde", "Gravação encerrada. Vê o console F8.")
    else
        RecordMode   = true
        RecordCoords = {}
        NotifyLocal("amarelo",
            "Gravação de rota iniciada. /" .. comandos.gravarRota.cmd .. " para parar.")
        CreateThread(function()
            while RecordMode do
                Wait(2000)
                local Pos = GetEntityCoords(PlayerPedId())
                RecordCoords[#RecordCoords + 1] = { Pos.x, Pos.y, Pos.z }
            end
        end)
    end
end, false)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN: COLOCAR CONES
-----------------------------------------------------------------------------------------------------------------------------------------
local ActiveConesCat = nil

RegisterCommand(comandos.colocarCones.cmd, function(source, args)
    local Ok, HasPerm = pcall(function() return vRPSrv.CheckAdminPerm() end)
    if not Ok or not HasPerm then NotifyLocal("vermelho", "Sem permissão.") return end

    local CatArgs = args[1]
    
    if not CatArgs then
        -- Desativa todos os cones
        for _, Obj in ipairs(ConesObj) do
            if DoesEntityExist(Obj) then DeleteObject(Obj) end
        end
        ConesObj = {}
        ActiveConesCat = nil
        NotifyLocal("amarelo", "Todos os cones removidos. Use: /" .. comandos.colocarCones.cmd .. " [A/B/C/D]")
        return
    end

    CatArgs = string.upper(CatArgs)

    if not parkInfos[CatArgs] then
        NotifyLocal("vermelho", "Categoria inválida! Use A, B, C ou D.")
        return
    end

    if ActiveConesCat == CatArgs then
        for _, Obj in ipairs(ConesObj) do
            if DoesEntityExist(Obj) then DeleteObject(Obj) end
        end
        ConesObj = {}
        ActiveConesCat = nil
        NotifyLocal("amarelo", "Cones da zona " .. CatArgs .. " removidos.")
        return
    end

    for _, Obj in ipairs(ConesObj) do
        if DoesEntityExist(Obj) then DeleteObject(Obj) end
    end
    ConesObj = {}

    local Park = parkInfos[CatArgs]
    local Hash = GetHashKey("prop_mp_cone_03")
    RequestModel(Hash)
    local TriesC = 0
    while not HasModelLoaded(Hash) and TriesC < 200 do Wait(10); TriesC = TriesC + 1 end
    if not HasModelLoaded(Hash) then return end

    for _, C in ipairs(Park.cones or {}) do
        local Obj = CreateObject(Hash, C[1], C[2], C[3], true, true, false)
        PlaceObjectOnGroundProperly(Obj)
        FreezeEntityPosition(Obj, true)
        ConesObj[#ConesObj + 1] = Obj
    end

    SetModelAsNoLongerNeeded(Hash)
    NotifyLocal("verde", "Cones da zona " .. CatArgs .. " posicionados.")
end, false)
