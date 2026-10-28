local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("vrp","lib/Tunnel")
local vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)

RegisterNetEvent("foguinho")
AddEventHandler("foguinho", function(entity)
    if type(entity) ~= "number" then return end
    TriggerClientEvent("etstore:client_foguinho", -1, entity)
end)

RegisterNetEvent('sound_server:TocarPorDistancia')
AddEventHandler('sound_server:TocarPorDistancia', function(disMax, audioFile, audioVol)
    TriggerClientEvent('sound_client:TocarPorDistancia', -1, GetEntityCoords(GetPlayerPed(source)), disMax, audioFile, audioVol)
end)

function src.checkPermission(permission)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        return vRP.HasPermission(Passport, Config.permissao)
    end
end