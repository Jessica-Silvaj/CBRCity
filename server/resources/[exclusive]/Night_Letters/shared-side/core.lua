local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

local Resource = GetCurrentResourceName()
Night = {}

if IsDuplicityVersion() then
    Tunnel.bindInterface(Resource,Night)
    Client = Tunnel.getInterface(Resource)

    sendEvent = TriggerEvent
    sendClient = TriggerClientEvent
else
    Tunnel.bindInterface(Resource,Night)
    Server = Tunnel.getInterface(Resource)

    sendEvent = TriggerEvent
    sendServer = TriggerServerEvent
end

CreateEvent = RegisterNetEvent

function Println(...)
    print('^0[^3LETTERS^0] ^4',table.unpack({...}),"^0")
end

function table.copy(Table)
    local Result = {}

    for Key,Value in pairs(Table) do
        if type(Value) == "table" then
            Result[Key] = table.copy(Value)
        else
            Result[Key] = Value
        end
    end

    return Result
end

function table.sequential(Table)
    local Array = {}

    if Table and type(Table) == "table" then
        for Key,Value in pairs(Table) do
            Array[#Array + 1] = Value
        end
    end

    return Array
end

function table.keysToArray(Table)
    local Array = {}

    if Table and type(Table) == "table" then
        for Key,Value in pairs(Table) do
            Array[#Array + 1] = Key
        end
    end

    return Array
end