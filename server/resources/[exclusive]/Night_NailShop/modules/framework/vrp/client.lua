local Tunnel = module("vrp","lib/Tunnel")

NailServer = Tunnel.getInterface("Night_NailShop")

Framework = Framework or {}
Notify = Notify or {}

local notifyTypes = {
    success = "verde",
    info = "azul",
    error = "vermelho",
    warning = "amarelo"
}

Framework.GetFrameworkName = function()
    return "vrp"
end

Framework.Notify = function(message,notifyType,time)
    TriggerEvent("Notify","Nail Studio",message,notifyTypes[notifyType] or notifyType or "azul",time or 5000)
end

Notify.SendNotify = function(message,notifyType,time)
    Framework.Notify(message,notifyType,time)
end

Framework.HasStudioPermission = function(studioIdx)
    return NailServer.HasStudioPermission(studioIdx)
end

Framework.IsTableBusy = function(studioIdx,tableIdx)
    return NailServer.IsTableBusy(studioIdx,tableIdx)
end

RegisterNetEvent("vRP:Active",function()
    Wait(1500)
    TriggerEvent(Scriptname .. ":client:OnPlayerLoaded")
end)

return Framework
