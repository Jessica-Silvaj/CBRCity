local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

Framework = Framework or {}
NailServer = NailServer or {}

Tunnel.bindInterface("Night_NailShop",NailServer)

local notifyTypes = {
    success = "verde",
    info = "azul",
    error = "vermelho",
    warning = "amarelo"
}

Notify = Notify or {}

Notify.SendNotify = function(src,message,notifyType,time)
    if not src or not message then return end
    TriggerClientEvent("Notify",src,"Nail Studio",message,notifyTypes[notifyType] or notifyType or "azul",time or 5000)
end

Framework.GetFrameworkName = function()
    return "vrp"
end

Framework.GetPlayer = function(src)
    local Passport = vRP.Passport(src)
    return Passport and { source = src, Passport = Passport } or nil
end

Framework.GetPlayerIdentifier = function(src)
    local Passport = vRP.Passport(src)
    return Passport and tostring(Passport) or nil
end

Framework.GetPlayers = function()
    local players = {}
    for Passport,src in pairs(vRP.Players() or {}) do
        if src then
            players[#players + 1] = src
        end
    end
    return players
end

Framework.HasPermission = function(src,permission)
    if not permission then return true end
    local Passport = vRP.Passport(src)
    return Passport and vRP.HasPermission(Passport,permission) and true or false
end

Framework.GetPlayerName = function(src)
    local Passport = vRP.Passport(src)
    if not Passport then return nil,nil end
    local Identity = vRP.Identity(Passport)
    if not Identity then return nil,nil end
    return Identity.Name,Identity.Lastname
end

Framework.GetItemCount = function(src,item)
    local Passport = vRP.Passport(src)
    return Passport and vRP.ItemAmount(Passport,item) or 0
end

Framework.HasItem = function(src,item)
    return Framework.GetItemCount(src,item) > 0
end

Framework.AddItem = function(src,item,amount,slot)
    local Passport = vRP.Passport(src)
    if not Passport then return false end
    vRP.GiveItem(Passport,item,amount or 1,true,slot)
    return true
end

Framework.RemoveItem = function(src,item,amount,slot)
    local Passport = vRP.Passport(src)
    if not Passport then return false end
    return vRP.TakeItem(Passport,item,amount or 1,true,slot) and true or false
end

function NailServer.HasStudioPermission(studioIdx)
    local src = source
    local Config = LoadNailConfig()
    local studioData = Config.NailStudios[studioIdx]
    if not studioData or not studioData.job then return true end
    return Framework.HasPermission(src,studioData.job)
end

function NailServer.IsTableBusy(studioIdx,tableIdx)
    if IsTableBusy then
        return IsTableBusy(source,studioIdx,tableIdx)
    end
    return false
end

RegisterNetEvent("vRP:Active",function(Passport)
    local src = source
    Wait(1500)
    TriggerEvent(Scriptname .. ":server:OnPlayerLoaded",src)
end)

AddEventHandler("Connect",function(Passport,src)
    Wait(1500)
    TriggerEvent(Scriptname .. ":server:OnPlayerLoaded",src)
end)

AddEventHandler("Disconnect",function(Passport,src)
    TriggerEvent(Scriptname .. ":server:OnPlayerUnload",src or vRP.Source(Passport))
end)

AddEventHandler("playerDropped",function()
    TriggerEvent(Scriptname .. ":server:OnPlayerUnload",source)
end)

return Framework
