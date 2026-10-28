if Config.Framework ~= "standalone" then
    return
end

while not NetworkIsSessionStarted() do
    Wait(500)
end

-- Só carrega o celular depois que o personagem é escolhido (o servidor marca Active)
CreateThread(function()
    while not LocalPlayer.state.Active do
        Wait(500)
    end

    FrameworkLoaded = true
end)

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vSERVER = Tunnel.getInterface("lb-phone")