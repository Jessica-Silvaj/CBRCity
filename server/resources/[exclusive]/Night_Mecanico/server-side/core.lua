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
	TriggerClientEvent("Notify",source,"Mecânico",Message,Color or "amarelo",5000)
end

local function Minutes(Seconds)
	local Value = math.ceil(Seconds / 60)
	return Value.." minuto"..(Value > 1 and "s" or "")
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
	if State.Death or State.Crawl then
		Notify(source,"Você não pode chamar o mecânico agora.")
		return
	end

	if Calls[source] then
		Notify(source,"O mecânico já está a caminho.")
		return
	end

	if Cooldowns[Passport] and os.time() < Cooldowns[Passport] then
		Notify(source,"Você só pode chamar o mecânico novamente em "..Minutes(Cooldowns[Passport] - os.time())..".")
		return
	end

	if vRP.AmountService(Config.MechanicGroup) > 0 then
		Notify(source,"Há mecânicos em serviço. Procure a Bennys ou a Redline.")
		return
	end

	Calls[source] = { Passport = Passport, Entities = {}, Pending = true }
	TriggerClientEvent("Night_Mecanico:Check",source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK: o client confirma qual veículo será atendido
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Mecanico:Checked",function(NetId,Message)
	local source = source
	local Call = Calls[source]
	if not Call or not Call.Pending then
		return
	end

	if not NetId then
		Calls[source] = nil
		Notify(source,Message or "Nenhum veículo próximo para o mecânico atender.")
		return
	end

	if Config.Price > 0 and not vRP.PaymentBank(Call.Passport,Config.Price,true) then
		Calls[source] = nil
		Notify(source,"Você não tem dinheiro suficiente no banco.")
		return
	end

	Call.Pending = false
	Cooldowns[Call.Passport] = os.time() + Config.Cooldown

	Notify(source,"Chamado registrado. O mecânico chega em "..Minutes(Config.Delay)..". Fique perto do veículo.","verde")
	TriggerClientEvent("Night_Mecanico:Start",source,NetId)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTER ENTITIES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Mecanico:Entities",function(NetIds)
	local source = source
	if Calls[source] and type(NetIds) == "table" then
		Calls[source].Entities = NetIds
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIR: aplica no dono da entidade, que pode não ser quem chamou
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Mecanico:Repair",function(NetId)
	local source = source
	local Call = Calls[source]
	if not Call or Call.Pending or Call.Repaired then
		return
	end

	local Vehicle = NetworkGetEntityFromNetworkId(NetId)
	if Vehicle == 0 or not DoesEntityExist(Vehicle) then
		return
	end

	Call.Repaired = true
	TriggerClientEvent("Night_Mecanico:ApplyRepair",-1,NetId,Config.EnginePercent * 10.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Mecanico:Finish",function(Repaired)
	local source = source
	local Call = Calls[source]
	if not Call then
		return
	end

	-- chamado que falhou antes do reparo não consome os 30 minutos
	if not Repaired and not Call.Repaired then
		Cooldowns[Call.Passport] = nil
	end

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
