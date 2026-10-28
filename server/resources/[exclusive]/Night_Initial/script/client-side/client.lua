
--------------------------------
-- [ CONEXAO ] --
--------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface(GetCurrentResourceName(),src)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
Config = module(GetCurrentResourceName(), "config/config")

-- O comando /resgatar e o menu de escolha foram removidos:
-- o veiculo inicial (Config.VeiculoInicial) e entregue automaticamente pelo servidor.

RegisterNetEvent("Night_Initial:Verify")
AddEventHandler("Night_Initial:Verify",function()
	vSERVER.verificar_resgate()
end)
