Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
Resource = GetCurrentResourceName()

if IsDuplicityVersion() then
    vRP = Proxy.getInterface("vRP")
    vRPclient = Tunnel.getInterface("vRP")

    API = {}
    Tunnel.bindInterface(Resource, API)

    RESPONSE = Tunnel.getInterface(Resource)
else
    vRP = Proxy.getInterface("vRP")

    API = {}
    Tunnel.bindInterface(Resource, API)

    RESPONSE = Tunnel.getInterface(Resource)
end
