---------------------------------------------------------------------------
-- VRP
---------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_barbershop")
func = {}
Tunnel.bindInterface("nation_barbershop", func)

function func.checkPermission(permission, src)
    local source = src or source
    local user_id = vRP.Passport(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.HasPermission(user_id, perm) then
                return true
            end
        end
        return false
    end
    return vRP.HasPermission(user_id, permission)
end

function func.saveChar(char)
    local source = source
    local user_id = vRP.Passport(source)
    if char.gender == "" then 
        char.gender = GetEntityModel(GetPlayerPed(source))
    end
    local val = json.encode(char,{indent=false})
    vRP.Query("playerdata/SetData", { Passport = user_id, Name = "nation_char", Information = val })
    vRP.Query("playerdata/SetData", { Passport = user_id, Name = "Barbershop", Information = val })
    TriggerClientEvent('barbershop:saveData', source)
    return true
end

function func.tryPay(value)
    local source = source
    local Passport = vRP.Passport(source)
    if value >= 0 then
        if vRP.PaymentFull(Passport, value) or vRP.PaymentBank(Passport, value) or value == 0 then
            return true
        end
    end
    return false
end

local chairsUsers = {}
function func.checkChair(barberId, chairIndex, perm)
    local source = source
    local model = GetEntityModel(GetPlayerPed(source))
    local canEnter = model == GetHashKey("mp_m_freemode_01") or model == GetHashKey("mp_f_freemode_01")
    if (perm and not func.hasPermission(perm, source)) or not canEnter then return end
    for src, v in pairs(chairsUsers) do
        if v.barberId == barberId and v.chairIndex == chairIndex then
            return false
        end
    end
    chairsUsers[source] = { barberId = barberId, chairIndex = chairIndex  }
    return true
end

function func.leaveChar(_source)
    local source = _source or source
    if chairsUsers[source] then
        chairsUsers[source] = nil
    end
end

AddEventHandler('playerDropped', function()
    func.leaveChar(source)
end)

function func.getOverlay()
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        local char = vRP.UserData(user_id, "nation_char")
        if char and char.overlay then
            return char.overlay
        end
    end
    return 0
end

function getUserClothes(user_id)
    local clothes = vRP.UserData(user_id, "Clothings")
    if clothes and type(clothes) == "table" and next(clothes) ~= nil then
        return clothes
    end
    local datatable = vRP.Datatable(user_id) or {}
    return datatable.customization or {}
end

function setPlayerTattoos(source, user_id)
    local data = vRP.UserData(user_id, "Tatuagens")
    if not data or not next(data) then
        data = vRP.UserData(user_id, "Tattooshop")
    end
    if data and type(data) == "table" and next(data) ~= nil then 
        TriggerClientEvent("tattoos:setTattoos", source, data)
        TriggerClientEvent("tattoos:Apply", source, data)
    end
    TriggerClientEvent("forcereloadtattos", source)
    TriggerClientEvent("reloadtattos", source)
end

function func.setPlayerTattoos()
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        setPlayerTattoos(source, user_id)
    end
end

function getGender(user_id)
    local datatable = vRP.Datatable(user_id) or {}
    if type(datatable) == "table" then
        local model = datatable.Skin or datatable.customization
        if model then
            if type(model) == "table" then
                model = model.modelhash or model.model
            end
            if model == GetHashKey("mp_m_freemode_01") or model == "mp_m_freemode_01" then
                return "male"
            elseif model == GetHashKey("mp_f_freemode_01") or model == "mp_f_freemode_01" then
                return "female"
            else
                return model
            end
        end
    end
end

function playerSpawn(user_id, source, first_spawn)
    Wait(1000)
    local char = vRP.UserData(user_id, "nation_char")
    if not char or not next(char) or (char[1] ~= nil and not char.hair) then
        char = vRP.UserData(user_id, "Barbershop")
    end
    if char and next(char) ~= nil then
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, user_id)
    end
end
AddEventHandler("CharacterChosen", function(Passport, source)
    playerSpawn(Passport, source, true)
end)

exports("Add", function(Table) end)

---------------------------------------------------------------------------
-- SISTEMA DE LOCALIZACOES DO BANCO DE DADOS
---------------------------------------------------------------------------
local BarbershopLocations = {}

RegisterNetEvent("barbershop:ServerReload")
AddEventHandler("barbershop:ServerReload", function()
    BarbershopLocations = {}
    local Consult = exports.oxmysql:executeSync("SELECT * FROM barbershop")
    if Consult then
        for _, v in pairs(Consult) do
            table.insert(BarbershopLocations, {
                x = v.X, y = v.Y, z = v.Z,
                Permission = (v.Permission and v.Permission ~= "") and v.Permission or nil
            })
        end
    end
    TriggerClientEvent("barbershop:Init", -1, BarbershopLocations)
end)

CreateThread(function()
    Wait(1000)
    TriggerEvent("barbershop:ServerReload")
end)

AddEventHandler("Connect", function(Passport, source)
    TriggerClientEvent("barbershop:Init", source, BarbershopLocations)
end)