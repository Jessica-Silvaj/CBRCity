local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
SERVER_TUNNEL = Tunnel.getInterface(GetCurrentResourceName())

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOKUPS (consumidos pelo tvRP.createObjects via export)
-----------------------------------------------------------------------------------------------------------------------------------------
local DefaultPhones = {}
for _, prop in ipairs(Config.DefaultPhones) do
    DefaultPhones[prop] = true
end

local CaseProps = {}
for _, case in ipairs(Config.Cases) do
    CaseProps[case.prop] = true
end

exports("PhoneProps", function()
    return {
        defaults = DefaultPhones,
        cases = CaseProps,
        attach = {
            default = Config.Attach,
            props = Config.PropAttach
        }
    }
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEW
-----------------------------------------------------------------------------------------------------------------------------------------
local UiOpen = false
local PreviewProp = nil
local HandObject = nil
local ShowcaseObject = nil
local ShowcaseHeading = 0.0
local LastDrag = 0

local PREVIEW_DICT = "cellphone@"
local PREVIEW_ANIM = "cellphone_text_read_base"

local function deleteObject(object)
    if object and DoesEntityExist(object) then
        SetEntityAsMissionEntity(object, true, true)
        DeleteEntity(object)
    end
end

local function getAttach(prop)
    local base = Config.Attach
    local custom = Config.PropAttach[prop]

    return {
        bone = custom and custom.bone or base.bone,
        pos = custom and custom.pos or base.pos,
        rot = custom and custom.rot or base.rot
    }
end

-- Carrega o model e confirma que a seleção não mudou durante o load
local function acquireModel(prop)
    local hash = GetHashKey(prop)
    if not LoadModel(hash) or not UiOpen or PreviewProp ~= prop then
        SetModelAsNoLongerNeeded(hash)
        return nil
    end
    return hash
end

local function attachHandObject(prop)
    deleteObject(HandObject)
    HandObject = nil

    local hash = acquireModel(prop)
    if not hash then
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local attach = getAttach(prop)

    HandObject = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)
    SetEntityCollision(HandObject, false, false)
    AttachEntityToEntity(HandObject, ped, GetPedBoneIndex(ped, attach.bone), attach.pos[1], attach.pos[2],
        attach.pos[3], attach.rot[1], attach.rot[2], attach.rot[3], false, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(hash)
end

local function attachShowcaseObject(prop)
    deleteObject(ShowcaseObject)
    ShowcaseObject = nil

    local hash = acquireModel(prop)
    if not hash then
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    ShowcaseObject = CreateObject(hash, coords.x, coords.y, coords.z + 1.0, false, false, false)
    SetEntityCollision(ShowcaseObject, false, false)
    SetEntityInvincible(ShowcaseObject, true)
    SetModelAsNoLongerNeeded(hash)
end

local function updateShowcase()
    if not ShowcaseObject or not DoesEntityExist(ShowcaseObject) then
        return
    end

    local camCoord = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)

    local pitch = math.rad(camRot.x)
    local yaw = math.rad(camRot.z)
    local cosPitch = math.abs(math.cos(pitch))

    local fwd = vector3(-math.sin(yaw) * cosPitch, math.cos(yaw) * cosPitch, math.sin(pitch))
    local right = vector3(fwd.y, -fwd.x, 0.0)
    local rlen = math.sqrt(right.x * right.x + right.y * right.y)
    if rlen > 0.0 then
        right = vector3(right.x / rlen, right.y / rlen, 0.0)
    end

    local pos = camCoord + fwd * 0.55 + right * 0.15
    SetEntityCoordsNoOffset(ShowcaseObject, pos.x, pos.y, pos.z - 0.02, false, false, false)

    if GetGameTimer() - LastDrag > 1000 then
        ShowcaseHeading = (ShowcaseHeading + 0.4) % 360.0
    end

    SetEntityRotation(ShowcaseObject, 8.0, 0.0, ShowcaseHeading, 2, true)
end

local function playPreviewAnim()
    local ped = PlayerPedId()
    if IsEntityPlayingAnim(ped, PREVIEW_DICT, PREVIEW_ANIM, 3) then
        return
    end

    if LoadAnim(PREVIEW_DICT) and UiOpen then
        TaskPlayAnim(ped, PREVIEW_DICT, PREVIEW_ANIM, 8.0, -8.0, -1, 49, 0, false, false, false)
    end
end

local function setPreview(prop)
    if not CaseProps[prop] then
        return
    end

    PreviewProp = prop
    attachHandObject(prop)
    attachShowcaseObject(prop)
    playPreviewAnim()
end

local function stopPreview()
    PreviewProp = nil
    deleteObject(HandObject)
    deleteObject(ShowcaseObject)
    HandObject = nil
    ShowcaseObject = nil
    StopAnimTask(PlayerPedId(), PREVIEW_DICT, PREVIEW_ANIM, 1.0)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UI
-----------------------------------------------------------------------------------------------------------------------------------------
local function closeUi()
    if not UiOpen then
        return
    end

    UiOpen = false
    stopPreview()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeInterface" })
end

local function openUi()
    if UiOpen then
        return
    end

    local ped = PlayerPedId()
    if IsPauseMenuActive() or GetEntityHealth(ped) <= 101 or LocalPlayer.state.Handcuff or LocalPlayer.state.Commands then
        return
    end

    TriggerEvent("dynamic:closeSystem")

    local data = SERVER_TUNNEL.GetShopData()
    if not data or UiOpen then
        return
    end

    data.imageUrl = GetConvar("CFG_ServerCDN", "https://miami.wins.company/") .. Config.Images.path
    data.imageExt = Config.Images.ext
    data.customCase = Config.CustomCase.enabled and Config.CustomCase or nil
    data.showGuide = GetResourceKvpString("capinhas_guide_seen") == nil

    UiOpen = true
    SetNuiFocus(true, true)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({ action = "openInterface", data = data })

    ShowcaseHeading = 0.0
    setPreview(data.equipped or (data.cases[1] and data.cases[1].prop))

    CreateThread(function()
        while UiOpen do
            updateShowcase()
            playPreviewAnim()
            Wait(0)
        end
    end)
end

RegisterNUICallback("preview", function(data, cb)
    if UiOpen and type(data.prop) == "string" then
        setPreview(data.prop)
    end
    cb({ ok = true })
end)

RegisterNUICallback("rotate", function(data, cb)
    local delta = tonumber(data.delta)
    if delta then
        LastDrag = GetGameTimer()
        ShowcaseHeading = (ShowcaseHeading + delta) % 360.0
    end
    cb({ ok = true })
end)

RegisterNUICallback("buy", function(data, cb)
    cb(SERVER_TUNNEL.BuyCase(data.prop, data.currency) or { success = false })
end)

RegisterNUICallback("equip", function(data, cb)
    cb(SERVER_TUNNEL.EquipCase(data.prop) or { success = false })
end)

RegisterNUICallback("unequip", function(_, cb)
    cb(SERVER_TUNNEL.UnequipCase() or { success = false })
end)

RegisterNUICallback("guideSeen", function(_, cb)
    SetResourceKvp("capinhas_guide_seen", "1")
    cb({ ok = true })
end)

RegisterNUICallback("closeInterface", function(_, cb)
    closeUi()
    cb({ ok = true })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ACESSOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Capinhas:openUI")
AddEventHandler("Night_Capinhas:openUI", function()
    openUi()
end)

exports("OpenUI", function()
    openUi()
end)

CreateThread(function()
    local shop = Config.Shop

    if shop.blip.enabled then
        local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
        SetBlipSprite(blip, shop.blip.sprite)
        SetBlipColour(blip, shop.blip.color)
        SetBlipScale(blip, shop.blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(shop.blip.name)
        EndTextCommandSetBlipName(blip)
    end

    -- exports["interactions"]:addCoords(shop.coords, {
    --     {
    --         label = shop.label,
    --         icon = shop.icon,
    --         distance = shop.distance,
    --         onSelect = function()
    --             openUi()
    --         end
    --     }
    -- })
end)

AddEventHandler("onResourceStop", function(name)
    if name == GetCurrentResourceName() then
        closeUi()
    end
end)
