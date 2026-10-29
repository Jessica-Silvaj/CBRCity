-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local vRP = module("vrp","lib/Proxy").getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Calls = {}
local Cooldowns = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(source,Message,Color)
	TriggerClientEvent("Notify",source,"SAMU",Message,Color or "amarelo",5000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANUP
-----------------------------------------------------------------------------------------------------------------------------------------
local function Cleanup(source)
	local Call = Calls[source]
	if not Call then
		return
	end

	for _,NetId in ipairs(Call.Entities or {}) do
		local Entity = NetworkGetEntityFromNetworkId(NetId)
		if Entity ~= 0 and DoesEntityExist(Entity) then
			DeleteEntity(Entity)
		end
	end

	Calls[source] = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Command,function(source)
	if source <= 0 then
		return
	end

	local Passport = vRP.Passport(source)
	if not Passport then
		return
	end

	local State = Player(source).state
	if not State.Death then
		Notify(source,"Você só pode chamar o SAMU depois de ficar 5 minutos desmaiado.")
		return
	end

	if State.Arena then
		Notify(source,"O SAMU não atende na arena.")
		return
	end

	if Calls[source] then
		Notify(source,"O SAMU já está a caminho.")
		return
	end

	if Cooldowns[Passport] and os.time() < Cooldowns[Passport] then
		Notify(source,"Aguarde "..(Cooldowns[Passport] - os.time()).." segundos para chamar o SAMU novamente.")
		return
	end

	if Config.BlockIfParamedics > 0 and vRP.AmountService(Config.ParamedicGroup) >= Config.BlockIfParamedics then
		Notify(source,"Há paramédicos em serviço. Peça socorro pelo celular.")
		return
	end

	if Config.Price > 0 then
		vRP.PaymentBank(Passport,Config.Price,true)
	end

	Calls[source] = { Passport = Passport, Entities = {} }
	Cooldowns[Passport] = os.time() + Config.Cooldown

	Notify(source,"Chamado registrado. A ambulância chega em "..Config.Delay.." segundos.","verde")
	TriggerClientEvent("Night_Samu:Start",source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTER ENTITIES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Samu:Entities",function(NetIds)
	local source = source
	if Calls[source] and type(NetIds) == "table" then
		Calls[source].Entities = NetIds
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Samu:Finish",function(Revived)
	local source = source
	local Call = Calls[source]
	if not Call then
		return
	end

	if not Revived then
		Cooldowns[Call.Passport] = nil
	end

	-- o client já apaga a ambulância; isto garante a limpeza se ele cair antes
	SetTimeout((Config.DespawnTime + 10) * 1000,function()
		if Calls[source] == Call then
			Cleanup(source)
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	Cleanup(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(Resource)
	if Resource == GetCurrentResourceName() then
		for source in pairs(Calls) do
			Cleanup(source)
		end
	end
end)
