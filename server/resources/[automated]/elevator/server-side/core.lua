-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Creative = {}
Tunnel.bindInterface("elevator",Creative)

function Creative.checkPermission(permission)
    local source = source
    local Passport = vRP.Passport(source)
    if permission and permission ~= "" then
        local group, level = string.match(permission, "^(.-),(%d+)$")
        if group and level then
            return vRP.HasGroup(Passport, group, tonumber(level))
        elseif vRP.HasGroup(Passport, permission) then
            return true
        else
            return vRP.HasPermission(Passport, permission)
        end
    end
    return true
end

function getElevators()
    local elevators = exports.oxmysql:executeSync('SELECT * FROM elevators ORDER BY elevator_id ASC')
    local config = {}
    
    for _, e in pairs(elevators) do
        local id = e.elevator_id
        if not config[id] then
            config[id] = {}
        end
        local c = json.decode(e.coords)
        table.insert(config[id], {
            Name = e.name,
            Coords = vec3(c.x, c.y, c.z),
            Heading = c.h or 0.0,
            Permission = e.permission
        })
    end
    return config
end

local CachedElevators = {}

RegisterNetEvent("Night_Management:requestElevators")
AddEventHandler("Night_Management:requestElevators", function()
    local source = source
    if source ~= "" and source ~= nil then return end
    CachedElevators = getElevators()
    TriggerClientEvent("elevator:updateConfig", -1, CachedElevators)
end)

AddEventHandler("Connect", function(Passport, source)
    TriggerClientEvent("elevator:updateConfig", source, CachedElevators)
end)

RegisterNetEvent("elevator:serverUpdate")
AddEventHandler("elevator:serverUpdate", function()
    CachedElevators = getElevators()
    TriggerClientEvent("elevator:updateConfig", -1, CachedElevators)
end)
