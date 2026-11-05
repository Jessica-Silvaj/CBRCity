---------------------------------------------------------------------------
-- VRP
---------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("nation_creator")
fclient = {}
Tunnel.bindInterface("nation_creator", fclient)
---------------------------------------------------------------------------
-- CONFIG
---------------------------------------------------------------------------
creatorCoords = vec3(CreatorCoords.x, CreatorCoords.y, CreatorCoords.z)
creatorHeading = CreatorCoords.w

spawnCoords = vec3(SpawnCoords.x, SpawnCoords.y, SpawnCoords.z)
spawnHeading = SpawnCoords.w
---------------------------------------------------------------------------
-- ANIMAÇÃO DE PARADO
---------------------------------------------------------------------------
function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function freezeAnim(dict, anim, flag, keep)
    if not keep then
        ClearPedTasks(PlayerPedId())
    end
    LoadAnim(dict)
    TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, flag or 1, 0, false, false, false)
    RemoveAnimDict(dict)
end
---------------------------------------------------------------------------
-- ROUPAAS PADRÕES PARA A CRIAÇÃO
---------------------------------------------------------------------------
resetCloths = function()
    local clothes = {}
    if CreatorResetClothes then for k, v in pairs(CreatorResetClothes) do
        clothes[GetHashKey(k)] = v
    end end
    local model = GetEntityModel(PlayerPedId())
    setClothes(clothes[model] or {})
end
---------------------------------------------------------------------------
-- ROUPAAS SETADAS APÓS CRIAR
---------------------------------------------------------------------------
setCloths = function()
    local clothes = {}
    if CreatorSetClothes then for k, v in pairs(CreatorSetClothes) do
        clothes[GetHashKey(k)] = v
    end end
    local model = GetEntityModel(PlayerPedId())
    setClothes(clothes[model] or {})
end
---------------------------------------------------------------------------
-- CÂMERAS
---------------------------------------------------------------------------
local cameras = {
    body = { coords = vec3(0.0, 2.5, 0.8), point = vec3(0.0,0.0,0.0), f = function() freezeAnim("move_f@multiplayer", "idle") end }, 
    head = { coords = vec3(0.0, 0.5, 0.7), point = vec3(0.0,0.0,0.67), f = function() freezeAnim("mp_sleep", "bind_pose_180", 1, true) end },
    eye = { coords = vec3(0.0, 0.27, 0.7), point = vec3(0.0,0.0,0.7), f = function() freezeAnim("mp_sleep", "bind_pose_180", 1, true) end },
    mouth = { coords = vec3(0.0, 0.27, 0.63), point = vec3(0.0,0.0,0.63), f = function() freezeAnim("mp_sleep", "bind_pose_180", 1, true) end },
    chest = { coords = vec3(0.0, 1.2, 0.4), point = vec3(0.0,0.0,0.2), f = function() freezeAnim("mp_sleep", "bind_pose_180", 1, true) end }, 
}

componentCams = {
    ["chestHair"] = "chest",
    ["hair"] = "head",
    ["facialHair"] = "head",
    ["blush"] = "head",
    ["lipstick"] = "mouth",
    ["makeup"] = "head",
}

local activeCam

function interpCamera(cameraName)
    if not cameras[cameraName] then return end
    if cameraName == activeCam then return end
    activeCam = cameraName

    local ped = PlayerPedId()
    SetEntityHeading(ped, creatorHeading)
    local cam = cameras[cameraName]
    local coord = GetOffsetFromEntityInWorldCoords(ped, cam.coords)
    local pointCoords = GetOffsetFromEntityInWorldCoords(ped, cam.point)

    -- Fade out e teleporta camera direto na posicao final (sem interpolacao para nao atravessar paredes)
    DoScreenFadeOut(200)
    Wait(250)

    -- Destroi camera antiga e cria nova ja na posicao final
    if fixedCam then DestroyCam(fixedCam) end
    fixedCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord, 0, 0, 0, 50.0)
    PointCamAtCoord(fixedCam, pointCoords)
    SetCamActive(fixedCam, true)
    RenderScriptCams(true, false, 0, true, true)

    if cam.f then cam.f() end

    -- Fade in com camera ja na posicao correta
    DoScreenFadeIn(300)
end

function createCamera()
    local ped = PlayerPedId()
    local groundCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    AttachCamToEntity(groundCam, ped, 0.0, -2.0, 0.0)
    SetCamActive(groundCam, true)
    RenderScriptCams(true, false, 1, true, true)
    activeCam = "body"
    local cam = cameras[activeCam]
    local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords)
    fixedCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord, 0,0,0, 50.0)
    local pointCoords = GetOffsetFromEntityInWorldCoords(ped,cam.point)
    PointCamAtCoord(fixedCam, pointCoords)
    SetCamActive(fixedCam, true)
    SetCamActiveWithInterp(fixedCam, groundCam, 1000, true, true)
    if cam.f then cam.f() end
    CreateThread(function()
        Wait(1000)
        DestroyCam(groundCam)
    end)
end

getPopupText = function(data) -- TEXTO QUE VAI APARECER NO POPUP NA HORA DE FINALIZAR A CRIAÇÃO
    name, lastName, age = data.name, data.lastName, math.floor(tonumber(data.age or 0) or 0)
    if not name or name:len() < 2 or name:len() > 16 or name:find(" ") or name:match("%d+") then
        return false , "nome inválido"
    end

    if not lastName or lastName:len() < 2 or lastName:len() > 16 or lastName:find(" ") or lastName:match("%d+") then
        return false , "sobrenome inválido"
    end

    if not age or age < 20 or age > 70 then
        return false , "idade inválida"
    end
    return true, "deseja criar o personagem "..data.name.." "..data.lastName.." ("..age.." anos) ?"
end

function teleport(ply,x, y, z)
    if type(x) == "vector3" then
        x,y,z = table.unpack(x)
    end
    FreezeEntityPosition(ply, true)
    SetEntityCoords(ply, x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
    local timer = 10
    while not HasCollisionLoadedAroundEntity(ply) and timer > 0 do
        FreezeEntityPosition(ply, true)
        SetEntityCoords(ply, x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
        RequestCollisionAtCoord(x, y, z)
        Wait(500)
        timer = timer - 1
    end
    SetEntityCoords(ply, x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
    FreezeEntityPosition(ply, false)
    Wait(1000)
end

function initCreator()
    loadingPlayer(true)
    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
    TriggerEvent("nation_barbershop:stop")
    func._changeSession(GetPlayerServerId(PlayerId()))
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(500)
    teleport(ped, creatorCoords)
    SetEntityHeading(ped, creatorHeading)
    setGender("male")
    SetEntityHealth(ped, GetPedMaxHealth(ped))
    resetCloths()
    SetFacialIdleAnimOverride(PlayerPedId(), "pose_normal_1", 0)
    Wait(1000)
    DoScreenFadeIn(1000)
end

function finishCreator()
    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
    changeClothes()
    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(1500)
    if CutScene then
        cutScene()
    end
    teleport(ped, spawnCoords)
    SetEntityHeading(ped, spawnHeading)
    FreezeEntityPosition(ped, false)
    SetEntityHealth(ped, GetPedMaxHealth(ped))
    func._updateLogin()
    func._changeSession(0)
    Wait(1000)
    DoScreenFadeIn(1000)
    TriggerEvent("hud:Active", true)

    if GetResourceState("referrals") == "started" then
        local openedResgatar = false
        local function openResgatar()
            if not openedResgatar then
                openedResgatar = true
                Wait(500)
                ExecuteCommand("resgatar")
            end
        end

        local handler
        handler = AddEventHandler("referrals:Close", function()
            if handler then
                RemoveEventHandler(handler)
                handler = nil
            end
            openResgatar()
        end)

        TriggerEvent("referrals:Open", function()
            if handler then
                RemoveEventHandler(handler)
                handler = nil
            end
            openResgatar()
        end)
    else
        Wait(1000)
        ExecuteCommand("resgatar")
    end
end

RegisterNetEvent("nation_creator:finishClothes")
AddEventHandler("nation_creator:finishClothes", function()
    clothesFinished = true
    Wait(5000)
    clothesFinished = false
end)

function changeClothes()
    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
    if GetResourceState("nation_skinshop") == "started" then
        TriggerEvent("nation_skinshop:toggleMenu", "nation_creator")
        while not clothesFinished do
            Wait(500)
        end
    else
        setCloths()
        func._saveClothes(getCloths())
    end
    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
end

function setGender(gender)    
    local model = "mp_m_freemode_01"
    if gender == "female" then
        model = "mp_f_freemode_01"
    elseif gender ~= "male" then
        model = gender
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)   
    end
    local ped = PlayerPedId()
    local currentHealth, currentMaxHealth, currentArmour = GetEntityHealth(ped), GetPedMaxHealth(ped), GetPedArmour(ped)
    local weapons = vRP.getWeapons() or {}
    SetPlayerModel(PlayerId(), model)
    ped = PlayerPedId()
    SetPedMaxHealth(ped, 200)
    SetEntityHealth(ped, currentHealth)
    SetPedArmour(ped, currentArmour)
    resetCloths()
    if gender == "male" then
        SetPedHeadBlendData(ped, 21, 0, 0, 21, 0, 0, 0.8, 0.8, 0.0, false)
    else
        SetPedHeadBlendData(ped, 21, 0, 0, 21, 0, 0, 0.2, 0.2, 0.0, false)
    end
    -- Começa sem marcas no rosto/corpo: manchas, rugas, aspecto, danos solares, sardas e marcas do corpo
    -- (255 = nenhum; 0 já é o primeiro estilo). A opacidade fica em 1.0 para os sliders continuarem visíveis.
    for _, overlayId in ipairs({ 0, 3, 6, 7, 9, 11, 12 }) do
        SetPedHeadOverlay(ped, overlayId, 255, 1.0)
    end
end

function fclient.spawnPlayer(firstspawn)
    loginSpawn(not firstspawn)
    local ped = PlayerPedId()
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    SetEntityAlpha(ped, 255, false)
end

function loadingPlayer(stats)
    -- TriggerEvent("hud:Active", false)
    local ped = PlayerPedId()
    SetEntityInvincible(ped,false)
    SetEntityVisible(ped,stats)
    LocalPlayer["state"]["Invisible"] = not stats
    FreezeEntityPosition(ped,not stats)
end

RegisterNetEvent("nation_creator:finishSpawn")
AddEventHandler("nation_creator:finishSpawn", function()
    loadingPlayer(true)
    DoScreenFadeIn(1000)
end)

function parseFloat(num)
    local n = tonumber(num..".0")
    if not n then n = tonumber(num) or num end
    return n
end

function f(num)
    local n = parseFloat(string.format("%.2f", tostring(num)))
    return n
end

local overlays = {
    [GetHashKey("mp_m_freemode_01")] = {
        { collection = 'mpbeach_overlays', overlay = 'FM_Hair_Fuzz' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_002' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_005' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_005_M' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_002' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_005' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_005_M' },
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_M_000_M'},
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_M_001_M'}
    },

    [GetHashKey("mp_f_freemode_01")] = {
        { collection = 'mpbeach_overlays', overlay = 'FM_Hair_Fuzz' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_010' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_002' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_F' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_003' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_006_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_F' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_010' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_002' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_F' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_003' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_006_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_F' },
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_F_000_F' },
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_F_001_F' }
    }
}

function getOverlays()
    local model = GetEntityModel(PlayerPedId())
    return overlays[model] or {}
end

function getOverlayByIndex(index)
    return getOverlays()[index]
end

Config = Config or {}

if not Config.Selector then
    Config.Selector = { 
        Main = vec3(-777.54, 331.47, 211.4),
        Ipl = "mpbusiness_int_placement_interior_v_mp_apt_h_01_milo__3",
        InteriorId = 146945,

        Spawns = {
            { -- SENTADO TOMANDO VINHO
                Coords = { x = -792.79, y = 332.97, z = { ["m"] = 206.62, ["f"] = 206.52 }, h = 187.09 },
                Anim = {
                    Dict = "anim_casino_a@amb@casino@games@insidetrack@ped_male@regular@02b@base",
                    Name = "base"
                },
                Camera = {
                    Coords = { x = -792.09, y = 331.96, z = 206.62 },
                    Point = { x = -792.29, y = 332.26, z = 206.62 },
                }
            },
            { -- MEDITANDO
                Coords = { x = -802.27, y = 338.63, z = 206.21, h = 85.04 },
                Anim = {
                    Dict = "amb@world_human_yoga@male@base",
                    Name = "base_a"
                },
                Camera = {
                    Coords = { x = -803.51, y = 337.79, z = 206.21 },
                    Point = { x = -802.27, y = 338.63, z = 206.42 },
                }
            },
            { -- SENTADO NA POLTRONA
                Coords = { x = -793.43, y = 341.39, z = 206.21, h = 238.12 },
                Anim = {
                    Dict = "timetable@ron@ig_5_p3",
                    Name = "ig_5_p3_base"
                },
                Camera = {
                    Coords = { x = -793.23, y = 340.8, z = 206.21 },
                    Point = { x = -793.43, y = 341.39, z = 206.21 }
                }
            },
            { -- DEITADO NA CAMA
                Coords = { x = -795.9, y = 338.4, z = 202.15, h = 87.88 },
                Anim = {
                    Dict = "amb@world_human_sunbathe@male@back@idle_a",
                    Name = "idle_a"
                },
                Camera = {
                    Coords = { x = -796.31, y = 338.4, z = 202.45 },
                    Point = { x = -796.55, y = 338.4, z = 201.15 },
                }
            },
            { -- CORTANDO ALGO NA COZINHA
                Coords = { x = -789.3, y = 330.43, z = 206.21, h = 0.0 },
                Anim = {
                    Dict = "amb@prop_human_bbq@male@idle_b",
                    Name = "idle_e"
                },
                Camera = {
                    Coords = { x = -789.8, y = 331.33, z = 206.71 },
                    Point = { x = -789.3, y = 330.43, z = 206.71 }
                }
            }
        },
        Cameras = {
            {
                Duration = 12000,
                List = {
                    {
                        Coords = { x = -797.09, y = 335.62, z = 201.41 },
                        Point = { x = -796.04, y = 342.89, z = 201.41 }
                    },
                    {
                        Coords = { x = -786.35, y = 336.11, z = 201.41 },
                        Point = { x = -787.09, y = 341.61, z = 201.41 }
                    }
                }
            },
            {
                Duration = 20000,
                List = {
                    {
                        Coords = { x = -779.52, y = 341.71, z = 207.62 },
                        Point = { x = -787.66, y = 338.35, z = 206.21 }
                    },
                    {
                        Coords = { x = -800.83, y = 334.5, z = 206.21 },
                        Point = { x = -797.68, y = 328.24, z = 206.21 }
                    }
                }
            },
            {
                Duration = 13000,
                List = {
                    {
                        Coords = { x = -798.0, y = 326.99, z = 207.51 },
                        Point = { x = -781.95, y = 336.55, z = 207.62 }
                    },
                    {
                        Coords = { x = -790.06, y = 334.79, z = 206.21 },
                        Point = { x = -795.0, y = 343.17, z = 206.21 }
                    }
                }
            },
            {
                Duration = 12000,
                List = {
                    {
                        Coords = { x = -778.91, y = 336.73, z = 203.82 },
                        Point = { x = -795.25, y = 337.09, z = 201.41 }
                    },
                    {
                        Coords = { x = -795.25, y = 337.09, z = 201.41 },
                        Point = { x = -792.76, y = 342.49, z = 201.41 }
                    }
                }
            },
            {
                Duration = 10000,
                List = {
                    {
                        Coords = { x = -803.85, y = 342.2, z = 207.21 },
                        Point = { x = -796.07, y = 342.08, z = 207.21 }
                    },
                    {
                        Coords = { x = -796.07, y = 342.08, z = 207.21 },
                        Point = { x = -798.8, y = 334.84, z = 206.21 }
                    }
                }
            }
        }
    }
end

HouseSelector = {
    mainCamera = nil,
    characters = {},
    spawnedPeds = {},
    runningCamera = false,
    selectedSpawn = nil,
    returningFromSelect = false,
    cameraThreadActive = false
}

local function shuffleHouseList(list)
    local n = #list
    local copy = {}
    for i = 1, n do copy[i] = list[i] end
    for i = n, 2, -1 do
        local j = math.random(1, i)
        copy[i], copy[j] = copy[j], copy[i]
    end
    return copy
end

local function applyAnimHousePed(ped, dict, name)
    if not dict or not name then return end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 3000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do
        Wait(10)
    end
    if HasAnimDictLoaded(dict) then
        ClearPedTasksImmediately(ped)
        TaskPlayAnim(ped, dict, name, 4.0, 4.0, -1, 1, 0, false, false, false)
        RemoveAnimDict(dict)
    end
end

local function applyDefaultClothesHousePed(ped, isFemale)
    if isFemale then
        SetPedComponentVariation(ped, 3, 15, 0, 0)  -- braços/torso
        SetPedComponentVariation(ped, 4, 15, 0, 0)  -- calças
        SetPedComponentVariation(ped, 6, 5, 0, 0)   -- sapatos
        SetPedComponentVariation(ped, 8, 14, 0, 0)  -- camiseta interna
        SetPedComponentVariation(ped, 11, 15, 0, 0) -- camisa/jaqueta
    else
        SetPedComponentVariation(ped, 3, 15, 0, 0)  -- braços/torso
        SetPedComponentVariation(ped, 4, 21, 0, 0)  -- calças
        SetPedComponentVariation(ped, 6, 34, 0, 0)  -- sapatos
        SetPedComponentVariation(ped, 8, 15, 0, 0)  -- camiseta interna
        SetPedComponentVariation(ped, 11, 15, 0, 0) -- camisa/jaqueta
    end
end

local function applyClothesHousePed(ped, clothes, isFemale)
    applyDefaultClothesHousePed(ped, isFemale)
    if not clothes or type(clothes) ~= "table" then return end

    if clothes.pants then
        local componentsMap = { mask = 1, arms = 3, pants = 4, backpack = 5, shoes = 6, accessory = 7, tshirt = 8, vest = 9, decals = 10, torso = 11 }
        local propsMap = { hat = 0, glass = 1, ear = 2, watch = 6, bracelet = 7 }
        for comp, i in pairs(componentsMap) do
            if clothes[comp] and type(clothes[comp]) == "table" then
                SetPedComponentVariation(ped, i, clothes[comp].item or 0, clothes[comp].texture or 0, 0)
            end
        end
        for prop, i in pairs(propsMap) do
            if clothes[prop] and type(clothes[prop]) == "table" and (clothes[prop].item or 0) >= 0 then
                SetPedPropIndex(ped, i, clothes[prop].item, clothes[prop].texture or 0, 0)
            else
                ClearPedProp(ped, i)
            end
        end
        return
    end

    local compKeys = {
        [1] = "masks", [3] = "torsos", [4] = "legs", [5] = "bags", [6] = "shoes",
        [7] = "accessories", [8] = "undershirts", [9] = "bodyArmors", [10] = "decals",
        [11] = "tops", ["p0"] = "hats", ["p1"] = "glasses", ["p2"] = "ears",
        ["p6"] = "watches", ["p7"] = "bracelets"
    }

    local function getPart(component)
        for key, comp in pairs(compKeys) do
            if comp == component or tostring(key) == tostring(component) then
                if type(key) == "string" and string.sub(key, 1, 1) == "p" then
                    return true, tonumber(string.sub(key, 2))
                else
                    return false, tonumber(key)
                end
            end
        end
        if type(component) == "string" and string.sub(component, 1, 1) == "p" then
            return true, tonumber(string.sub(component, 2))
        end
        return false, tonumber(component)
    end

    for k, v in pairs(clothes) do
        if type(v) == "table" then
            local item = v[1] or v.item or 0
            local tex = v[2] or v.texture or 0
            local isprop, index = getPart(k)
            if isprop and index then
                if item < 0 then
                    ClearPedProp(ped, index)
                else
                    SetPedPropIndex(ped, index, item, tex, 0)
                end
            elseif index then
                SetPedComponentVariation(ped, index, item, tex, 0)
            end
        end
    end
end

local function applyCharHousePed(ped, char)
    if not char or type(char) ~= "table" then return end

    local shapeFirst = char.shapeFirst or 21
    local shapeSecond = char.shapeSecond or 0
    local shapeThird = char.shapeThird or 0
    local skinFirst = char.skinFirst or 21
    local skinSecond = char.skinSecond or 0
    local skinThird = char.skinThird or 0
    local shapeMix = parseFloat(char.shapeMix or 0.5)
    local skinMix = parseFloat(char.skinMix or 0.5)
    local thirdMix = parseFloat(char.thirdMix or 0.0)

    SetPedHeadBlendData(ped, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix, false)

    local overlaysList = {
        [0] = "blemishes", [1] = "facialHair", [2] = "eyebrows", [3] = "ageing",
        [4] = "makeup", [5] = "blush", [6] = "complexion", [7] = "sunDamage",
        [8] = "lipstick", [9] = "freckles", [10] = "chestHair", [11] = "bodyBlemishes",
        [12] = "addBodyBlemishes"
    }

    for overlayId, name in pairs(overlaysList) do
        if char[name] ~= nil then
            local val = tonumber(char[name]) or -1
            local opacity = parseFloat(char[name.."-opacity"] or 1.0)
            local col = tonumber(char[name.."-color"]) or 0

            local colourType = 0
            if name:find("eyebrows") or name:find("facialHair") or name:find("chestHair") then
                colourType = 1
            elseif name:find("blush") or name:find("lipstick") or name:find("makeup") then
                colourType = 2
            end

            SetPedHeadOverlay(ped, overlayId, val, opacity)
            SetPedHeadOverlayColor(ped, overlayId, colourType, col, col)
        end
    end

    local featuresList = {
        [0] = "noseWidth", [1] = "nosePeakHeight", [2] = "nosePeakLength",
        [3] = "noseBoneHigh", [4] = "nosePeakLowering", [5] = "noseBoneTwist",
        [6] = "eyeBrownHigh", [7] = "eyeBrownForward", [8] = "cheeksBoneHigh",
        [9] = "cheeksBoneWidth", [10] = "cheeksWidth", [11] = "eyesOpenning",
        [12] = "lipsThickness", [13] = "jawBoneWidth", [14] = "jawBoneBackLength",
        [15] = "chinBoneLowering", [16] = "chinBoneLength", [17] = "chinBoneWidth",
        [18] = "chinHole", [19] = "neckThickness"
    }

    for featureId, name in pairs(featuresList) do
        if char[name] ~= nil then
            SetPedFaceFeature(ped, featureId, parseFloat(char[name]))
        end
    end

    if char.eyes then
        SetPedEyeColor(ped, tonumber(char.eyes) or 0)
    end

    local hair = tonumber(char.hair or char.hairModel) or 0
    local hairColor = tonumber(char["hair-color"] or char.firstHairColor) or 0
    local hairHighlight = tonumber(char["hair-highlightcolor"] or char.secondHairColor) or 0
    SetPedComponentVariation(ped, 2, hair, 0, 0)
    SetPedHairColor(ped, hairColor, hairHighlight)

    if char.overlay and char.overlay > 0 and getOverlayByIndex then
        local decoration = getOverlayByIndex(char.overlay)
        if decoration then
            local collection = GetHashKey(decoration.collection)
            local overlay = GetHashKey(decoration.overlay)
            AddPedDecorationFromHashesInCorona(ped, collection, overlay)
        end
    end
end

local function applyTattoosHousePed(ped, tattoos)
    if not tattoos or type(tattoos) ~= "table" then return end
    ClearPedDecorations(ped)
    for overlay, collection in pairs(tattoos) do
        if type(collection) == "string" and type(overlay) == "string" then
            AddPedDecorationFromHashes(ped, GetHashKey(collection), GetHashKey(overlay))
        end
    end
end

function HouseSelector:LoadInterior()
    RequestIpl(Config.Selector.Ipl)
    local interiorId = GetInteriorAtCoords(Config.Selector.Main.x, Config.Selector.Main.y, Config.Selector.Main.z)
    if IsValidInterior(interiorId) then
        PinInteriorInMemory(interiorId)
        RefreshInterior(interiorId)
    end
end

function HouseSelector:Init()
    self:LoadInterior()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false)
    SetEntityCollision(ped, false, false)
    SetEntityInvincible(ped, true)
    SetEntityCoords(ped, Config.Selector.Main.x, Config.Selector.Main.y, Config.Selector.Main.z, false, false, false, true)
end

function HouseSelector:Start(charactersList)
    self:Init()
    self.characters = {}
    if charactersList then
        local sortedKeys = {}
        for k, v in pairs(charactersList) do
            local numKey = tonumber(k)
            if numKey and type(v) == "table" then
                table.insert(sortedKeys, { key = numKey, val = v })
            end
        end
        table.sort(sortedKeys, function(a, b) return a.key < b.key end)
        for _, item in ipairs(sortedKeys) do
            table.insert(self.characters, item.val)
        end
        if #self.characters == 0 then
            for _, v in pairs(charactersList) do
                if type(v) == "table" and (v.Passport or v.id or v.name) then
                    table.insert(self.characters, v)
                end
            end
        end
    end

    self.runningCamera = true
    self.selectedSpawn = nil

    self:CreatePeds()
    Wait(200)
    self:StartCamera()
end

function HouseSelector:CreatePeds()
    self:ClearPeds()
    local spawnsData = Config.Selector.Spawns or {}

    for index = 1, math.min(#self.characters, #spawnsData) do
        local character = self.characters[index]
        if character and (character.Passport or character.id) then
            local isFemale = (character.gender == "feminino" or character.gender == "f" or character.gender == "female" or (character.char and character.char.gender == "female"))
            local genderStr = isFemale and "f" or "m"
            local modelHash = isFemale and `mp_f_freemode_01` or `mp_m_freemode_01`

            if not HasModelLoaded(modelHash) then
                LoadModel(modelHash)
            end
            if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                local timeout = GetGameTimer() + 5000
                while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do
                    Wait(0)
                end
            end

            if HasModelLoaded(modelHash) then
                local spawnData = spawnsData[index]
                local coords = spawnData.Coords
                local z = type(coords.z) == "table" and (coords.z[genderStr] or coords.z["m"]) or coords.z

                RequestCollisionAtCoord(coords.x, coords.y, z)

                local ped = CreatePed(26, modelHash, coords.x, coords.y, z, coords.h or 0.0, false, false)
                if not DoesEntityExist(ped) then
                    ped = CreatePed(4, modelHash, coords.x, coords.y, z, coords.h or 0.0, false, false)
                end

                if DoesEntityExist(ped) then
                    DecorSetBool(ped, "CREATIVE_PED", true)
                    SetPedDefaultComponentVariation(ped)
                    SetEntityAsMissionEntity(ped, true, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    SetEntityInvincible(ped, true)
                    SetPedCanRagdoll(ped, false)
                    FreezeEntityPosition(ped, true)
                    SetEntityCollision(ped, false, false)
                    SetEntityVisible(ped, true)
                    SetEntityAlpha(ped, 255, false)
                    ResetEntityAlpha(ped)
                    SetPedKeepTask(ped, true)

                    character.ped = ped
                    character.currentSpawn = index
                    table.insert(self.spawnedPeds, ped)

                    pcall(applyClothesHousePed, ped, character.clothes, isFemale)

                    if character.char then
                        pcall(applyCharHousePed, ped, character.char)
                    end

                    if character.tattoos then
                        pcall(applyTattoosHousePed, ped, character.tattoos)
                    end

                    if spawnData.Anim and spawnData.Anim.Dict and spawnData.Anim.Name then
                        pcall(applyAnimHousePed, ped, spawnData.Anim.Dict, spawnData.Anim.Name)
                    end
                end
            end
        end
    end
end

function HouseSelector:PositionPedsForCamera(cameraIdx)
    if self.selectedSpawn ~= nil then return end
    local spawnsData = Config.Selector.Spawns or {}
    local totalSpawns = #spawnsData
    if totalSpawns <= 0 then return end

    local cameraPrimarySpawn = {
        [1] = 4, -- Câmera 1 (Quarto) -> Cama (Spawn 4)
        [2] = 1, -- Câmera 2 (Bancada/Bar) -> Vinho na bancada (Spawn 1)
        [3] = 3, -- Câmera 3 (Sala de Estar) -> Poltrona (Spawn 3)
        [4] = 4, -- Câmera 4 (Escada/Quarto) -> Cama (Spawn 4)
        [5] = 2, -- Câmera 5 (Cozinha/Yoga) -> Yoga na sala de vidro (Spawn 2)
    }

    local primary = cameraPrimarySpawn[cameraIdx] or 1

    local order = { primary }
    for s = 1, totalSpawns do
        if s ~= primary then
            table.insert(order, s)
        end
    end

    for index, character in ipairs(self.characters) do
        if character and character.ped and DoesEntityExist(character.ped) then
            local isFemale = (character.gender == "feminino" or character.gender == "f" or character.gender == "female" or (character.char and character.char.gender == "female"))
            local genderStr = isFemale and "f" or "m"

            local spawnIndex = order[index] or (((primary + index - 2) % totalSpawns) + 1)
            local spawnData = spawnsData[spawnIndex]
            if spawnData then
                local coords = spawnData.Coords
                local z = type(coords.z) == "table" and (coords.z[genderStr] or coords.z["m"]) or coords.z

                character.currentSpawn = spawnIndex

                ClearPedTasksImmediately(character.ped)
                SetEntityCoords(character.ped, coords.x, coords.y, z, false, false, false, true)
                SetEntityCoordsNoOffset(character.ped, coords.x, coords.y, z, true, true, true)
                SetEntityHeading(character.ped, coords.h or 0.0)
                FreezeEntityPosition(character.ped, true)
                SetEntityCollision(character.ped, false, false)
                SetEntityVisible(character.ped, true)
                SetEntityAlpha(character.ped, 255, false)
                ResetEntityAlpha(character.ped)

                if spawnData.Anim and spawnData.Anim.Dict and spawnData.Anim.Name then
                    pcall(applyAnimHousePed, character.ped, spawnData.Anim.Dict, spawnData.Anim.Name)
                end
            end
        end
    end
end

function HouseSelector:StartCamera()
    if self.cameraThreadActive then return end
    self.cameraThreadActive = true

    if self.mainCamera and DoesCamExist(self.mainCamera) then
        DestroyCam(self.mainCamera)
        self.mainCamera = nil
    end

    self.mainCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(self.mainCamera, true)
    RenderScriptCams(true, false, 0, true, true)

    local playerPed = PlayerPedId()
    local camerasData = Config.Selector.Cameras or {}

    -- Posiciona os personagens no enquadramento da primeira câmera imediatamente
    self:PositionPedsForCamera(1)

    if camerasData[1] and camerasData[1].List and camerasData[1].List[1] then
        local first = camerasData[1].List[1]
        SetCamCoord(self.mainCamera, first.Coords.x, first.Coords.y, first.Coords.z)
        PointCamAtCoord(self.mainCamera, first.Point.x, first.Point.y, first.Point.z)
        SetEntityCoords(playerPed, first.Coords.x, first.Coords.y, first.Coords.z)
    end

    CreateThread(function()
        local currentData, currentIndex = 1, 1

        while self.runningCamera do
            if self.selectedSpawn ~= nil then
                local spawnData = Config.Selector.Spawns[self.selectedSpawn]
                if spawnData and spawnData.Camera then
                    local targetCam = spawnData.Camera
                    local activeSpawn = self.selectedSpawn

                    -- Teleporte instantaneo: fade out -> posiciona camera -> fade in (sem atravessar paredes)
                    DoScreenFadeOut(200)
                    Wait(250)
                    SetCamCoord(self.mainCamera, targetCam.Coords.x, targetCam.Coords.y, targetCam.Coords.z)
                    PointCamAtCoord(self.mainCamera, targetCam.Point.x, targetCam.Point.y, targetCam.Point.z)
                    DoScreenFadeIn(300)

                    while self.runningCamera and self.selectedSpawn == activeSpawn do
                        SetCamCoord(self.mainCamera, targetCam.Coords.x, targetCam.Coords.y, targetCam.Coords.z)
                        PointCamAtCoord(self.mainCamera, targetCam.Point.x, targetCam.Point.y, targetCam.Point.z)
                        Wait(50)
                    end
                else
                    Wait(100)
                end
            else
                local sequence = camerasData[currentData] and camerasData[currentData].List

                if self.returningFromSelect then
                    self.returningFromSelect = false
                    self:PositionPedsForCamera(currentData)

                    if sequence and sequence[currentIndex] then
                        local toCoord = sequence[currentIndex].Coords
                        local toPoint = sequence[currentIndex].Point
                        DoScreenFadeOut(200)
                        Wait(250)
                        SetCamCoord(self.mainCamera, toCoord.x, toCoord.y, toCoord.z)
                        PointCamAtCoord(self.mainCamera, toPoint.x, toPoint.y, toPoint.z)
                        SetEntityCoords(playerPed, toCoord.x, toCoord.y, toCoord.z)
                        DoScreenFadeIn(300)
                    end
                end

                if sequence and sequence[currentIndex] then
                    local from = sequence[currentIndex]
                    local to = sequence[currentIndex + 1]

                    if not to then
                        currentData = camerasData[currentData + 1] and (currentData + 1) or 1
                        currentIndex = 1
                    else
                        local isLastSegment = not sequence[currentIndex + 2]
                        local startTime = GetGameTimer()
                        local duration = (camerasData[currentData] and camerasData[currentData].Duration) or 10000
                        local fadeDuration = 1000
                        local fadeLeadTime = 400
                        local fadeTriggerTime = math.max(0, duration - (fadeDuration + fadeLeadTime))
                        local fadeOutTriggered = false

                        while (GetGameTimer() - startTime) < duration and self.runningCamera and self.selectedSpawn == nil do
                            local now = GetGameTimer()
                            local elapsed = now - startTime
                            local alpha = elapsed / duration

                            local function interp(a, b)
                                return a + (b - a) * alpha
                            end

                            local px = interp(from.Coords.x, to.Coords.x)
                            local py = interp(from.Coords.y, to.Coords.y)
                            local pz = interp(from.Coords.z, to.Coords.z)

                            local tx = interp(from.Point.x, to.Point.x)
                            local ty = interp(from.Point.y, to.Point.y)
                            local tz = interp(from.Point.z, to.Point.z)

                            SetCamCoord(self.mainCamera, px, py, pz)
                            PointCamAtCoord(self.mainCamera, tx, ty, tz)
                            SetEntityCoords(playerPed, px, py, pz)

                            -- Inicia o fade out enquanto a câmera CONTINUA se movendo suavemente
                            if isLastSegment and not fadeOutTriggered and elapsed >= fadeTriggerTime then
                                fadeOutTriggered = true
                                DoScreenFadeOut(fadeDuration)
                            end

                            Wait(0)
                        end

                        if self.runningCamera and self.selectedSpawn == nil then
                            if isLastSegment then
                                -- Aguarda a tela ficar 100% preta
                                while not IsScreenFadedOut() do
                                    Wait(10)
                                end

                                -- Avança para o próximo cenário em tela preta
                                currentData = camerasData[currentData + 1] and (currentData + 1) or 1
                                currentIndex = 1

                                -- Reposiciona os peds para o novo cenário
                                self:PositionPedsForCamera(currentData)

                                -- Posiciona câmera e player no início do novo cenário antes de clarear
                                local nextSequence = camerasData[currentData] and camerasData[currentData].List
                                if nextSequence and nextSequence[1] then
                                    SetCamCoord(self.mainCamera, nextSequence[1].Coords.x, nextSequence[1].Coords.y, nextSequence[1].Coords.z)
                                    PointCamAtCoord(self.mainCamera, nextSequence[1].Point.x, nextSequence[1].Point.y, nextSequence[1].Point.z)
                                    SetEntityCoords(playerPed, nextSequence[1].Coords.x, nextSequence[1].Coords.y, nextSequence[1].Coords.z)
                                end

                                Wait(100)

                                -- Abre a tela suavemente já com o novo cenário pronto
                                DoScreenFadeIn(fadeDuration)
                            else
                                currentIndex = currentIndex + 1
                            end
                        end
                    end
                else
                    currentData = 1
                    currentIndex = 1
                end

                Wait(0)
            end
        end

        self.cameraThreadActive = false
    end)
end

function HouseSelector:SelectCharacter(info, index)
    if not self.runningCamera then return end

    local numIdx = tonumber(index)
    if not info or not numIdx or numIdx < 1 then
        if self.selectedSpawn ~= nil then
            self.selectedSpawn = nil
            self.returningFromSelect = true
        end
        return
    end

    local targetChar = (self.characters and self.characters[numIdx]) or info
    if targetChar and targetChar.ped and DoesEntityExist(targetChar.ped) then
        local spawnIdx = targetChar.currentSpawn or numIdx
        local spawnData = Config.Selector.Spawns[spawnIdx]
        if spawnData then
            self.selectedSpawn = spawnIdx

            local ped = targetChar.ped
            if ped and DoesEntityExist(ped) then
                local isFemale = (targetChar.gender == "feminino" or targetChar.gender == "f" or targetChar.gender == "female" or (targetChar.char and targetChar.char.gender == "female"))
                local genderStr = isFemale and "f" or "m"
                local coords = spawnData.Coords
                local z = type(coords.z) == "table" and (coords.z[genderStr] or coords.z["m"]) or coords.z

                targetChar.currentSpawn = spawnIdx
                ClearPedTasksImmediately(ped)
                SetEntityCoords(ped, coords.x, coords.y, z, false, false, false, true)
                SetEntityCoordsNoOffset(ped, coords.x, coords.y, z, true, true, true)
                SetEntityHeading(ped, coords.h or 0.0)
                FreezeEntityPosition(ped, true)
                SetEntityCollision(ped, false, false)
                SetEntityVisible(ped, true)
                SetEntityAlpha(ped, 255, false)
                ResetEntityAlpha(ped)

                if spawnData.Anim and spawnData.Anim.Dict and spawnData.Anim.Name then
                    pcall(applyAnimHousePed, ped, spawnData.Anim.Dict, spawnData.Anim.Name)
                end
            end
            return
        end
    end

    if self.selectedSpawn ~= nil then
        self.selectedSpawn = nil
        self.returningFromSelect = true
    end
end

function HouseSelector:ClearPeds()
    for _, ped in ipairs(self.spawnedPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    self.spawnedPeds = {}
    for _, char in pairs(self.characters) do
        if char.ped and DoesEntityExist(char.ped) then
            DeleteEntity(char.ped)
        end
        char.ped = nil
    end
end

function HouseSelector:Stop()
    self.runningCamera = false
    self.selectedSpawn = nil
    self.returningFromSelect = false

    self:ClearPeds()

    if self.mainCamera and DoesCamExist(self.mainCamera) then
        DestroyCam(self.mainCamera)
        self.mainCamera = nil
    end

    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, true, true)

    local ped = PlayerPedId()
    SetEntityVisible(ped, true)
    SetEntityCollision(ped, true, true)
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
end

AddEventHandler("onResourceStop", function(resName)
    if resName == GetCurrentResourceName() then
        HouseSelector:Stop()
    end
end)

RegisterNetEvent("spawn:setupChars")
AddEventHandler("spawn:setupChars", function()
    Wait(1000)
    while not loaded do
        Wait(1000)
    end
    toggleMultiChar()
end)

function initMultiChar()
    loadingPlayer(false)
    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
    func._changeSession(GetPlayerServerId(PlayerId()))
    TriggerEvent("nation_barbershop:stop")
    local ped = PlayerPedId()
    DoScreenFadeOut(0)
    HouseSelector:Init()
end

function leaveMultiChar()
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(1000)
    HouseSelector:Stop()
    func._changeSession(0)
    Wait(500)
end

function selectCharacter(info, index)
    if HouseSelector and HouseSelector.runningCamera then
        HouseSelector:SelectCharacter(info, index)
    end
end

function playChar(info)
    if not info then return end
    func._playChar(info)
    toggleMultiChar()
end

function createChar()
    if func.tryCreateChar() then
        toggleMultiChar()
        startCreator()
    end
end

function getDeleteCharMessage(info)
    if info and info.char then
        return true, "deseja realmente deletar o personagem "..info.name.." "..info.id.." ?"
    end
    return false, "error"
end

function tryDeleteChar(info)
    local success, message = func.tryDeleteChar(info)
    return success, message
end

function setClothing(data)
	local ped = PlayerPedId()
    if not data then
        return resetCloths()
    end
    if not data.pants then
        return setClothes(data)
    end

    if data["backpack"] == nil then
		data["backpack"] = {}
		data["backpack"]["item"] = 0
		data["backpack"]["texture"] = 0
	end

    local components = { mask = 1, arms = 3, pants = 4, backpack = 5, shoes = 6, accessory = 7, tshirt = 8, vest = 9, decals = 10, torso = 11 }
    local props = { hat = 0, glass = 1, ear = 2, watch = 6, bracelet = 7 }
    for comp, i in pairs(components) do
        if data[comp] then
            SetPedComponentVariation(ped,i,data[comp].item,data[comp].texture,2)
        end
    end
    for prop, i in pairs(props) do
        if data[prop] and data[prop].item > 0 then
            SetPedPropIndex(ped,i,data[prop].item,data[prop].texture,2)
        else
            ClearPedProp(ped,i)
        end
    end
end

fclient.setClothing = setClothing
---------------------------------------------------------------------------
-- CUT SCENE
---------------------------------------------------------------------------
local sub_b0b5 = {
    [0] = "MP_Plane_Passenger_1",
    [1] = "MP_Plane_Passenger_2",
    [2] = "MP_Plane_Passenger_3",
    [3] = "MP_Plane_Passenger_4",
    [4] = "MP_Plane_Passenger_5",
    [5] = "MP_Plane_Passenger_6",
    [6] = "MP_Plane_Passenger_7"
}

function sub_b747(ped, a_1)
    if a_1 == 0 then
        SetPedComponentVariation(ped, 0, 21, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 9, 0, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 9, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 4, 8, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 15, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 10, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 1 then
        SetPedComponentVariation(ped, 0, 13, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 5, 4, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 10, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 10, 0, 0)
        SetPedComponentVariation(ped, 7, 11, 2, 0)
        SetPedComponentVariation(ped, 8, 13, 6, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 10, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 2 then
        SetPedComponentVariation(ped, 0, 15, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 1, 4, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 1, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 7, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 9, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 6, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 3 then
        SetPedComponentVariation(ped, 0, 14, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 5, 3, 0)
        SetPedComponentVariation(ped, 3, 3, 0, 0)
        SetPedComponentVariation(ped, 4, 1, 6, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 11, 5, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 3, 12, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 4 then
        SetPedComponentVariation(ped, 0, 18, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 15, 3, 0)
        SetPedComponentVariation(ped, 3, 15, 0, 0)
        SetPedComponentVariation(ped, 4, 2, 5, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 4, 6, 0)
        SetPedComponentVariation(ped, 7, 4, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 4, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 5 then
        SetPedComponentVariation(ped, 0, 27, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 7, 3, 0)
        SetPedComponentVariation(ped, 3, 11, 0, 0)
        SetPedComponentVariation(ped, 4, 4, 8, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 13, 14, 0)
        SetPedComponentVariation(ped, 7, 5, 3, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 2, 7, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 6 then
        SetPedComponentVariation(ped, 0, 16, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 15, 1, 0)
        SetPedComponentVariation(ped, 3, 3, 0, 0)
        SetPedComponentVariation(ped, 4, 5, 6, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 2, 8, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 3, 7, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    end
end

function cutScene() -- ORDER CREATION
    LocalPlayer.state:set("inCutscene", true, false)
    inCutscene = true

    TriggerMusicEvent("AC_STOP")
    CancelMusicEvent("FM_INTRO_START")
    SetAudioFlag("DisableFlightMusic", true)

    local plyrId = PlayerPedId() -- PLAYER ID
    -----------------------------------------------
	if IsMale(plyrId) then
		RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 31, 8)
	else	
		RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 103, 8)
	end
    while not HasCutsceneLoaded() do Wait(10) end --- waiting for the cutscene to load
	if IsMale(plyrId) then
		RegisterEntityForCutscene(0, 'MP_Male_Character', 3, GetEntityModel(PlayerPedId()), 0)
		RegisterEntityForCutscene(PlayerPedId(), 'MP_Male_Character', 0, 0, 0)
		SetCutsceneEntityStreamingFlags('MP_Male_Character', 0, 1) 
		local female = RegisterEntityForCutscene(0,"MP_Female_Character",3,0,64) 
		NetworkSetEntityInvisibleToNetwork(female, true)
	else
		RegisterEntityForCutscene(0, 'MP_Female_Character', 3, GetEntityModel(PlayerPedId()), 0)
		RegisterEntityForCutscene(PlayerPedId(), 'MP_Female_Character', 0, 0, 0)
		SetCutsceneEntityStreamingFlags('MP_Female_Character', 0, 1) 
		local male = RegisterEntityForCutscene(0,"MP_Male_Character",3,0,64) 
		NetworkSetEntityInvisibleToNetwork(male, true)
	end
	LoadModel(`mp_f_freemode_01`)
	LoadModel(`mp_m_freemode_01`)
	local ped = {}
	for v_3=0, 6, 1 do
		if v_3 == 1 or v_3 == 2 or v_3 == 4 or v_3 == 6 then
			ped[v_3] = CreatePed(26, `mp_f_freemode_01`, -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
		else
			ped[v_3] = CreatePed(26, `mp_m_freemode_01`, -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
		end
        if not IsEntityDead(ped[v_3]) then
            DecorSetBool(ped[v_3], "CREATIVE_PED", true)
            SetEntityAsMissionEntity(ped[v_3], true, true)
            SetBlockingOfNonTemporaryEvents(ped[v_3], true)
            SetPedKeepTask(ped[v_3], true)
            SetEntityInvincible(ped[v_3], true)
			sub_b747(ped[v_3], v_3)
            FinalizeHeadBlend(ped[v_3])
            RegisterEntityForCutscene(ped[v_3], sub_b0b5[v_3], 0, 0, 64)
        end
    end
	
	NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0) ----- avoid texture bugs

    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
    -- CreateThread(setWeather) ---- SUN TIME
    StartCutscene(4) --- START the custscene
    CreateThread(function()
        while IsCutsceneActive() do
            TriggerEvent("hud:Active", false)
            DisplayRadar(false)
            SetPlayerControl(PlayerId(), true, false)
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            Wait(0)
        end
    end)
    DoScreenFadeIn(3000)

    Wait(75500) --- custscene time
	for v_3=0, 6, 1 do
        if DoesEntityExist(ped[v_3]) then
		    DeleteEntity(ped[v_3])
        end
	end
	TriggerMusicEvent("AC_STOP")
    FreezeEntityPosition(plyrId)
    DoScreenFadeOut(500)
    Wait(500)
    StopCutsceneImmediately()
    inCutscene = false
    LocalPlayer.state:set("inCutscene", false, false)
    SetAudioFlag("DisableFlightMusic", false)
end 


function setWeather()
    -- while inCutscene do
    --     SetWeatherTypeNow("EXTRASUNNY")
    --     NetworkOverrideClockTime(12,0,0)
    --     Wait(0)
    -- end
end

function IsMale(ped)
	if IsPedModel(ped, 'mp_m_freemode_01') then
		return true
	else
		return false
	end
end
---------------------------------------------------------------------------
-- LOGIN
---------------------------------------------------------------------------

spawns = {
    { name = "Garagem Praça", coords = {55.04,-878.8,30.37,176.39} },
    { name = "Garagem Sandy Shores", coords = {318.1,2623.98,44.47,268.35} },
    { name = "Garagem Paleto", coords = {-772.95,5595.9,33.49,168.85} },
    { name = "Metrô", coords = {-798.69,-99.21,37.62,277.17} },
    { name = "Aeroporto", coords = {-1035.74,-2733.37,13.76,324.76} },
}

function fclient.setPlayerLastCoords(coords)
    if lastCoords then return end
    lastCoords = coords
    table.insert(spawns, { name = "Última Localização", coords = lastCoords })
end

local cam = nil
function loginSpawn(status)
    TriggerEvent("hud:Active", false)
    DisplayRadar(false)
    TriggerEvent('hookSelector',status)
    TriggerEvent('register:Open')
end

function changeLoginCam(x,y,z)
	local ped = PlayerPedId()
    local myCoords = GetEntityCoords(ped)
    if #(myCoords - vec3(x,y,z)) < 3 then return end
    changingSpawnCam = true
    SetEntityCoordsNoOffset(ped, x,y,z)
    local coord = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,200.0)
    local tempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord, 0,0,0, 50.0)
    local tempCamPoint = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord, 0,0,0, 50.0)
    local camPoint = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", myCoords.x, myCoords.y, myCoords.z+200, 0,0,0, 50.0)
    PointCamAtCoord(tempCam, coord)
    PointCamAtCoord(camPoint, coord)
    PointCamAtCoord(tempCamPoint, x,y,z)
    SetCamActive(camPoint, true)
    SetCamActiveWithInterp(camPoint, cam, 500, true, true)
    Wait(500)
    DestroyCam(cam)
    cam = camPoint
    SetCamActive(tempCam, true)
    SetCamActiveWithInterp(tempCam, cam, 1000, true, true)
    Wait(1000)
    DestroyCam(cam)
    cam = tempCam
    SetCamActive(tempCamPoint, true)
    SetCamActiveWithInterp(tempCamPoint, cam, 500, true, true)
    Wait(500)
    DestroyCam(cam)
    cam = tempCamPoint
    changingSpawnCam = false
    TriggerEvent('register:Open')
end

function GetHeadBlendData(ped)
    local p = {Citizen.InvokeNative(0x2746BD9D88C5C5D0, ped, Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0))}
    local headBlendData = {
        shapeFirst = p[1],
        shapeSecond = p[2],
        shapeThird = p[3],
        skinFirst = p[4],
        skinSecond = p[5],
        skinThird = p[6],
        shapeMix = p[7],
        skinMix = p[8],
        thirdMix = p[9]
    }
    return headBlendData
end

RegisterNetEvent("login:Spawn")
AddEventHandler("login:Spawn",loginSpawn)


RegisterNetEvent("nation_creator:forceSaveChar")
AddEventHandler("nation_creator:forceSaveChar", function(user_id)
    local char = getPlayerChar(PlayerPedId())
    func._saveChar(false, false, false, char, user_id)
    TriggerEvent("nation_barbershop:init", char)
end)


CreateThread(function()
    loadingPlayer(false) -- comentar caso nao queira que o player fique invisível quando spawna
    while true do
        if inMultiChar or inMenu or inLoginMenu or spawnned then
            break
        end
        local ped = PlayerPedId()
        SetEntityInvincible(ped,true)
        SetEntityVisible(ped,false)
        FreezeEntityPosition(ped,true)
        Wait(10)
    end
end)


AddEventHandler("onClientResourceStart",function(Resource)
	if (GetCurrentResourceName() ~= Resource) then
		return
	end
	DoScreenFadeOut(0)
	DisplayRadar(false)
	TriggerEvent("hud:Active", false)
    TriggerEvent("spawn:setupChars")
end)

RegisterNetEvent("spawn:StartSelector", function()
    TriggerEvent("spawn:setupChars")
end)

RegisterNetEvent("character:Client:Creator:Open", function()
    fclient.startCreator()
end)

exports("Creation", function()
    fclient.startCreator()
end)

local components = {
    [1] = "masks",
    [3] = "torsos",
    [4] = "legs",
    [5] = "bags",
    [6] = "shoes",
    [7] = "accessories",
    [8] = "undershirts",
    [9] = "bodyArmors",
    [10] = "decals",
    [11] = "tops",
    ["p"..(0)] = "hats",
    ["p"..(1)] = "glasses",
    ["p"..(2)] = "ears",
    ["p"..(6)] = "watches",
    ["p"..(7)] = "bracelets",
}

local getMyClothes = function()
    local ped = PlayerPedId()
	local custom = {}
	for i = 0,20 do
        local k = components[i]
        if k then
		    custom[k] = { GetPedDrawableVariation(ped,i),GetPedTextureVariation(ped,i),GetPedPaletteVariation(ped,i) }
        end
	end

	for i = 0,10 do
        local k = components["p"..i]
        if k then
		    custom[k] = { GetPedPropIndex(ped,i),math.max(GetPedPropTextureIndex(ped,i),0) }
        end
	end
	return custom
end

local skinData = {
	["pants"] = "legs",
	["arms"] = "torsos",
	["tshirt"] = "undershirts",
	["torso"] = "tops",
	["vest"] = "bodyArmors",
	["backpack"] = "bags",
	["shoes"] = "shoes",
	["mask"] = "masks",
	["hat"] = "hats",
	["glass"] = "glasses",
	["ear"] = "ears",
	["watch"] = "watches",
	["bracelet"] = "bracelets",
	["accessory"] = "accessories",
	["decals"] = "decals"
}

function getCloths()
    local myCloths = getMyClothes()
    local cloths = {}
    for cloth, comp in pairs(skinData) do
        local item = myCloths[comp][1]
        local texture = myCloths[comp][2]
        cloths[cloth] = { item = item, texture = texture }
    end
    return cloths
end


-- NATION_CONFIG_SYNC_HOOK
RegisterNUICallback("getNationConfig", function(data, cb)
    cb({
        ScriptNationBarbershop = ScriptNationBarbershop,
        ScriptNationSkinshop   = ScriptNationSkinshop,
        ScriptNationTattoos    = ScriptNationTattoos,
        ScriptNationCreator    = ScriptNationCreator
    })
end)

CreateThread(function()
    Wait(1500)
    SendNUIMessage({
        action = "setNationConfig",
        NationConfig = {
            ScriptNationBarbershop = ScriptNationBarbershop,
            ScriptNationSkinshop   = ScriptNationSkinshop,
            ScriptNationTattoos    = ScriptNationTattoos,
            ScriptNationCreator    = ScriptNationCreator
        }
    })
end)
