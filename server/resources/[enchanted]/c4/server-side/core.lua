-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("c4", Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTADO
-----------------------------------------------------------------------------------------------------------------------------------------
local Cooldowns = {}
local AtmLock = {}
local Active = {}
local LastCall = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISRATELIMITED
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsRateLimited(Passport)
	local Now = GetGameTimer()
	if LastCall[Passport] and (Now - LastCall[Passport]) < Config.Security.RateLimitMs then
		return true
	end

	LastCall[Passport] = Now
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ISPERMITTEDTIME
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsPermittedTime(Atm)
	if not Atm.PermittedTime then
		return true
	end

	local StartHour, EndHour = Atm.PermittedTime[1], Atm.PermittedTime[2]
	local CurrentHour = tonumber(GlobalState.Hours) or 12

	if StartHour <= EndHour then
		return CurrentHour >= StartHour and CurrentHour < EndHour
	end

	return CurrentHour >= StartHour or CurrentHour < EndHour
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCHPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
local function DispatchPolice(source, Passport, Atm, Method)
	local Settings = Config.Police.CallPolice
	local MethodSettings = Settings[Method] or {}

	exports["vrp"]:CallPolice({
		Source = source,
		Passport = Passport,
		Permission = Config.Police.Permission,
		Name = Settings.Name,
		Percentage = Settings.Percentage,
		Wanted = MethodSettings.Wanted,
		Code = Settings.Code,
		Color = Settings.Color,
		Coords = Atm.Cds
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLLVALUATION
-----------------------------------------------------------------------------------------------------------------------------------------
local function RollValuation(Passport)
	local Valuation = math.random(Config.Robbery.Valuation.Min, Config.Robbery.Valuation.Max)

	if exports.party:DoesExist(Passport, 2) then
		Valuation = Valuation * Config.Robbery.Valuation.Multipliers.Party
	end

	if exports.inventory:Buffs("Dexterity", Passport) then
		Valuation = Valuation * Config.Robbery.Valuation.Multipliers.Dexterity
	end

	for Permission, Multiplier in pairs(Config.Robbery.Valuation.Multipliers.Services) do
		if vRP.HasService(Passport, Permission) then
			Valuation = Valuation * (1 + Multiplier)
		end
	end

	return math.floor(Valuation)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANUPROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local function CleanupRobbery(targetId)
	Active[targetId] = nil
	if AtmLock[targetId] then
		AtmLock[targetId] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSYSTEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckSystems(targetId)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or IsRateLimited(Passport) then
		return false
	end

	if Active[targetId] then
		return false
	end

	local Atm = Config.AtmList[targetId]
	if not Atm or Atm.Safe then
		return false
	end

	if AtmLock[targetId] then
		TriggerClientEvent("Notify", source, "Atenção", "Outra pessoa já está roubando este caixa.", "amarelo", 5000)
		return false
	end

	if (Cooldowns[targetId] or 0) > os.time() then
		local remaining = Cooldowns[targetId] - os.time()
		TriggerClientEvent("Notify", source, "Atenção", "Este caixa foi roubado recentemente. Aguarde " .. remaining .. " segundos.", "amarelo", 5000)
		return false
	end

	if not IsPermittedTime(Atm) then
		TriggerClientEvent("Notify", source, "Atenção", "Este caixa só pode ser roubado em determinado horário.", "amarelo", 5000)
		return false
	end

	local Coords = vRP.GetEntityCoords(source)
	if not Coords or #(Coords - Atm.Cds) > Config.Security.StartDistance then
		return false
	end

	if vRP.AmountService(Config.Police.Permission) < Config.Police.MinAmount then
		TriggerClientEvent("Notify", source, "Atenção", "Contingente policial insuficiente para este roubo.", "amarelo", 5000)
		return false
	end

	local RequiredItem = Config.ItemC4
	local HasItem = vRP.ConsultItem(Passport, RequiredItem, 1)
	if not HasItem then
		TriggerClientEvent("Notify", source, "Atenção", "Você precisa de 1x "..exports.vrp:ItemName(RequiredItem)..".", "amarelo", 5000)
		return false
	end

	if not vRP.TakeItem(Passport, HasItem.Item, 1, true) then
		return false
	end

	local FuseTime = math.random(Config.Robbery.MinC4Time, Config.Robbery.C4Time)

	Cooldowns[targetId] = os.time() + Config.Robbery.Cooldown
	AtmLock[targetId] = Passport
	Active[targetId] = {
		StartedBy = Passport,
		Method = "c4",
		Phase = "attempt",
		PickupsRemaining = math.max(Config.Robbery.Pickups.Total, 1),
		StartedAt = GetGameTimer(),
		MinElapsedMs = Config.AnimWaitMs + FuseTime * 1000
	}

	return FuseTime
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPAREEXPLOSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PrepareExplosion(targetId)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Robbery = Active[targetId]
	if not Robbery or Robbery.Method ~= "c4" or Robbery.Phase ~= "attempt" then
		return false
	end

	if Robbery.StartedBy ~= Passport then
		return false
	end

	if (GetGameTimer() - Robbery.StartedAt) < (Robbery.MinElapsedMs - 500) then
		return false
	end

	local Atm = Config.AtmList[targetId]
	DispatchPolice(source, Passport, Atm, "C4")
	Robbery.Phase = "exploded"

	for _, OtherSource in pairs(vRPC.Players(source)) do
		if OtherSource ~= source then
			TriggerClientEvent("eletronics:Explosion", OtherSource, Atm.Cds)
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEATMEXPLODED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdateAtmExploded(targetId)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Robbery = Active[targetId]
	if not Robbery or Robbery.Phase ~= "exploded" then
		CleanupRobbery(targetId)
		return false
	end

	if Robbery.StartedBy ~= Passport then
		return false
	end

	Robbery.Phase = "pickup"
	Robbery.Value = RollValuation(Passport)
	Robbery.PickupExpires = os.time() + Config.Security.PickupTimeout

	local Atm = Config.AtmList[targetId]
	for _, OtherSource in pairs(vRPC.Players(source)) do
		local Coords = vRP.GetEntityCoords(OtherSource)
		if Coords and #(Coords - Atm.Cds) <= 100.0 then
			TriggerClientEvent("eletronics:setDrop", OtherSource, targetId)
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYPICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TryPickup(targetId)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Robbery = Active[targetId]
	if not Robbery or Robbery.Phase ~= "pickup" then
		return false
	end

	if os.time() > Robbery.PickupExpires then
		TriggerClientEvent("eletronics:removeDrop", -1, targetId)
		CleanupRobbery(targetId)
		return false
	end

	local Atm = Config.AtmList[targetId]
	local Coords = vRP.GetEntityCoords(source)
	local Dist = Coords and #(Coords - Atm.Cds)
	if not Coords or Dist > Config.Security.PickupDistance then
		return false
	end

	local Share = math.floor(Robbery.Value / math.max(Config.Robbery.Pickups.Total, 1))
	vRP.GiveItem(Passport, Config.MoneyItem, Share, true)

	Robbery.PickupsRemaining = Robbery.PickupsRemaining - 1
	if Robbery.PickupsRemaining <= 0 then
		TriggerClientEvent("eletronics:removeDrop", -1, targetId)
		CleanupRobbery(targetId)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ABORTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AbortRobbery(targetId)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Robbery = Active[targetId]
	if not Robbery then
		return false
	end

	if Robbery.StartedBy == Passport then
		CleanupRobbery(targetId)
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPEZA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport, source)
	for targetId, Robbery in pairs(Active) do
		if Robbery.StartedBy == Passport and Robbery.Phase ~= "pickup" then
			CleanupRobbery(targetId)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(60000)

		local Now = os.time()
		for targetId, Robbery in pairs(Active) do
			if Robbery.Phase == "pickup" and Now > Robbery.PickupExpires then
				TriggerClientEvent("eletronics:removeDrop", -1, targetId)
				CleanupRobbery(targetId)
			end
		end
	end
end)
