-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Stockades = {}
local Cooldown = os.time()
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASNEED
-----------------------------------------------------------------------------------------------------------------------------------------
-- Itens exigidos do painel (todos): arma (WEAPON_*) precisa estar na mão; outros itens no inventário
local function HasNeed(source,Passport,Need)
	if not Need or not Need.Item then
		return true
	end

	local Found = {}
	for _,Item in ipairs(NeedItems(Need)) do
		if Item:sub(1,7) == "WEAPON_" then
			if not vCLIENT.CheckWeapon(source,Item) then
				NeedMissing(source,Need)
				return false
			end
		else
			local Consult = vRP.ConsultItem(Passport,Item,Need.Amount or 1)
			if not Consult then
				NeedMissing(source,Need)
				return false
			end
			Found[#Found + 1] = Consult
		end
	end

	return Found
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
-- Valores vêm do "Roubo a Carro Forte" do painel gestor (robbery.lua > Stockade)
RegisterNetEvent("inventory:Stockade")
AddEventHandler("inventory:Stockade",function(Vehicle)
	local source = source
	local Plate = Vehicle[1]
	local Passport = vRP.Passport(source)
	local Settings = RobberySettings("Stockade")
	if not Passport or not Settings or Active[Passport] or vRP.PassportPlate(Plate) then
		return false
	end

	if Settings.Enabled == false then
		TriggerClientEvent("Notify",source,"Atenção","O roubo a carro-forte está desativado.","amarelo",5000)
		return false
	end

	if vRP.AmountService("PoliciaCBR") < (Settings.Police or 0) then
		TriggerClientEvent("Notify",source,"Atenção","Contingente indisponível.","amarelo",5000)
		return false
	end

	if not Stockades[Plate] then
		if os.time() < Cooldown then
			TriggerClientEvent("Notify",source,"Atenção","Roubos a carro-forte em espera. Aguarde "..CompleteTimers(Cooldown - os.time())..".","amarelo",5000)
			return false
		end

		if not HasNeed(source,Passport,Settings.Need) then
			return false
		end

		Stockades[Plate] = 10
		Cooldown = os.time() + (Settings.Delay or 3600)

		vRP.CallPolice({
			Source = source,
			Passport = Passport,
			Permission = "PoliciaCBR",
			Name = Settings.Name or "Roubo a Carro Forte",
			Wanted = Settings.Wanted or 60,
			Code = 31,
			Color = 44
		})
	end

	if Stockades[Plate] <= 0 then
		TriggerClientEvent("Notify",source,"Atenção","Compartimento vazio.","amarelo",5000)
		return false
	end

	local Need = HasNeed(source,Passport,Settings.Need)
	if not Need then
		return false
	end

	if type(Need) == "table" and Settings.Need.Consume and not NeedTake(Passport,Settings.Need,Need) then
		return false
	end

	local Timer = Settings.Timer or 20
	local Payment = Settings.Payment and Settings.Payment.List and Settings.Payment.List[1] or { Item = "dirtydollar", Min = 7225, Max = 7225 }

	Active[Passport] = os.time() + Timer
	Stockades[Plate] = Stockades[Plate] - 1
	Player(source)["state"]["Buttons"] = true
	TriggerClientEvent("Progress",source,"Roubando",Timer * 1000)
	vRPC.playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)

	CreateThread(function()
		while Active[Passport] and os.time() < Active[Passport] do
			Wait(100)
		end

		if Active[Passport] then
			vRPC.Destroy(source)
			Active[Passport] = nil
			Player(source)["state"]["Buttons"] = false
			vRP.GenerateItem(Passport,Payment.Item,math.random(math.min(Payment.Min,Payment.Max),math.max(Payment.Min,Payment.Max)),true)
		end
	end)
end)
