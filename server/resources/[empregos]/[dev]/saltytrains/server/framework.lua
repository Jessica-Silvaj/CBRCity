ESX, QBCore, vRP = nil

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "QBCore" then
    QBCore = exports["qb-core"]:GetCoreObject()
elseif Config.Framework == "vRP" then
    local Proxy = module("vrp", "lib/Proxy")
    vRP = Proxy.getInterface("vRP")
end

function GetServerPlayer(source)
    if Config.Framework == "ESX" then
        return ESX.GetPlayerFromId(source)
    elseif Config.Framework == "QBCore" then
        return QBCore.Functions.GetPlayer(source)
    elseif Config.Framework == "vRP" then
        return vRP.Passport(source)
    end
end

function GetPlayerIdentifier(source)
    if Config.Framework == "ESX" then
        return GetServerPlayer(source).identifier
    elseif Config.Framework == "QBCore" then
        return GetServerPlayer(source).PlayerData.citizenid
    elseif Config.Framework == "vRP" then
        local Passport = GetServerPlayer(source)
        return Passport and tostring(Passport) or nil
    end
end

function AddPlayerMoney(source, amount)
    local player = GetServerPlayer(source)
    if not player then return end
    if Config.Framework == "ESX" then
        player.addAccountMoney("money", amount)
    elseif Config.Framework == "QBCore" then
        player.Functions.AddMoney("cash", amount)
    elseif Config.Framework == "vRP" then
        vRP.GenerateItem(player, "dollar", amount, true)
    end
end

function RegisterFrameworkCallback(name, cb)
    if Config.Framework == "ESX" then
        ESX.RegisterServerCallback(name, cb)
    elseif Config.Framework == "QBCore" then
        QBCore.Functions.CreateCallback(name, cb)
    elseif Config.Framework == "vRP" then
        RegisterNetEvent("saltytrains:callback:" .. name, function(requestId, ...)
            local src = source
            cb(src, function(...)
                TriggerClientEvent("saltytrains:callbackResult", src, requestId, ...)
            end, ...)
        end)
    end
end

-- Experiência do emprego na base vRP (lista Works do vrp/config/Global.lua)
function AddWorkExperience(source, amount)
    if Config.Framework ~= "vRP" or not Config.RequiredJob then return end

    local Passport = GetServerPlayer(source)
    if Passport then
        vRP.PutExperience(Passport, Config.RequiredJob, amount)
    end
end

function NotifyPlayer(source, message, notifType)
    if Config.Framework == "ESX" then
        TriggerClientEvent("esx:showNotification", source, message)
    elseif Config.Framework == "QBCore" then
        TriggerClientEvent("QBCore:Notify", source, message, notifType or "primary")
    elseif Config.Framework == "vRP" then
        TriggerClientEvent("Notify", source, "Trem", message, notifType == "error" and "vermelho" or "default", 5000)
    end
end
