-----------------------------------------------------------------------------------------------------------------------------------------
-- TREINO: +1 KG A CADA 1 KM, ATÉ +20 KG POR PERSONAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local FitnessVRP = module("vrp","lib/Proxy").getInterface("vRP")
local Samples = {}
local Step = 1000
local Limit = 20 * Step
local Bicycles = {}
for _,Model in ipairs({ "bmx","cruiser","fixter","scorcher","tribike","tribike2","tribike3","inductor","inductor2" }) do
	Bicycles[GetHashKey(Model)] = true
end

RegisterNetEvent("player:Fitness",function(Mode)
	local Source = source
	if Mode ~= "run" and Mode ~= "bike" then
		Samples[Source] = nil
		return
	end

	local Now = GetGameTimer()
	local Last = Samples[Source]
	if Last and Now - Last.Time < 500 then
		return
	end

	local Passport = FitnessVRP.Passport(Source)
	local Ped = GetPlayerPed(Source)
	local State = Player(Source).state
	if not Passport or Ped == 0 or not DoesEntityExist(Ped) or GetEntityHealth(Ped) <= 100 or not State.Active or State.Arena then
		Samples[Source] = nil
		return
	end

	local Vehicle = GetVehiclePedIsIn(Ped,false)
	if (Mode == "run" and Vehicle ~= 0) or (Mode == "bike" and (Vehicle == 0 or not Bicycles[GetEntityModel(Vehicle)] or GetPedInVehicleSeat(Vehicle,-1) ~= Ped)) then
		Samples[Source] = nil
		return
	end

	local Coords = GetEntityCoords(Ped)
	local Bucket = GetPlayerRoutingBucket(Source)
	Samples[Source] = { Time = Now, Coords = Coords, Mode = Mode, Ped = Ped, Passport = Passport, Bucket = Bucket }
	if not Last or Last.Mode ~= Mode or Last.Ped ~= Ped or Last.Passport ~= Passport or Last.Bucket ~= Bucket then
		return
	end

	local Elapsed = (Now - Last.Time) / 1000
	if Elapsed <= 0 or Elapsed > 4 then
		return
	end
	local Distance = #(Coords - Last.Coords)
	local Speed = Distance / Elapsed
	if Speed < (Mode == "run" and 2.0 or 1.0) or Speed > (Mode == "run" and 12.0 or 35.0) then
		return
	end

	local Data = FitnessVRP.Datatable(Passport)
	if not Data then return end
	local Before = math.max(0,math.min(Limit,tonumber(Data.FitnessMeters) or 0))
	local Total = math.min(Limit,Before + Distance)
	local Bonus = math.floor(Total / Step)
	-- Quem já treinou mantém os metros; avisa apenas o bônus ainda não notificado.
	local Notified = tonumber(Data.FitnessNotifiedBonus)
	if not Notified then
		Notified = math.min(20,math.floor(math.max(0,tonumber(Data.FitnessMeters) or 0) / 10000))
	end
	if Total > Before then
		FitnessVRP.UpdateDatatable(Passport,"FitnessMeters",Total)
	end

	if Bonus > Notified then
		local Gained = Bonus - Notified
		FitnessVRP.UpdateDatatable(Passport,"FitnessNotifiedBonus",Bonus)
		TriggerClientEvent("Notify",Source,"Academia","Você ganhou <b>+"..Gained.." kg</b> de capacidade na mochila com seu treino. Bônus de corrida e bicicleta: <b>+"..Bonus.."/20 kg</b>.","verde",5000)
		TriggerClientEvent("inventory:Update",Source,"Backpack")
	end
end)

AddEventHandler("playerDropped",function()
	Samples[source] = nil
end)

