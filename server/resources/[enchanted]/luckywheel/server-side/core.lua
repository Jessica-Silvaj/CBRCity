-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Progress = os.time()
local Daily = {}
local Bonus = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDAILY
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetDaily(Passport)
	if not Daily[Passport] then
		local Consult = vRP.UserData(Passport,"LuckyWheelDaily")
		if type(Consult) == "number" then
			Daily[Passport] = Consult
		elseif type(Consult) == "table" and Consult.Time then
			Daily[Passport] = Consult.Time
		else
			Daily[Passport] = 0
		end
	end

	return Daily[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDAILY
-----------------------------------------------------------------------------------------------------------------------------------------
local function SetDaily(Passport,Timestamp)
	Daily[Passport] = Timestamp
	vRP.Query("playerdata/SetData",{
		Passport = Passport,
		Name = "LuckyWheelDaily",
		Information = json.encode({ Time = Timestamp })
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
local function CheckPayment(source,Passport)
	local CurrentTimer = os.time()

	if Bonus[Passport] and Bonus[Passport] > 0 then
		Bonus[Passport] = Bonus[Passport] - 1
		TriggerClientEvent("Notify",source,"Sucesso","Você utilizou um giro bônus!","verde",5000)
		return true
	end

	local LastSpin = GetDaily(Passport)
	if CurrentTimer >= LastSpin then
		SetDaily(Passport,CurrentTimer + 86400)
		TriggerClientEvent("Notify",source,"Sucesso","Você utilizou seu giro diário gratuito!","verde",5000)
		return true
	end

	if vRP.TakeItem(Passport,"luckywheelpass",1,true) then
		TriggerClientEvent("Notify",source,"Sucesso","Você utilizou <b>1x Passe da Roleta</b>.","verde",5000)
		return true
	end

	if vRP.TakeItem(Passport,"chips",5000,true) then
		TriggerClientEvent("Notify",source,"Sucesso","Você utilizou <b>5.000x Fichas</b>.","verde",5000)
		return true
	end

	local Remaining = LastSpin - CurrentTimer
	TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x Passe da Roleta</b> ou <b>5.000x Fichas</b>.<br>Próximo giro gratuito em: <b>"..CompleteTimers(Remaining).."</b>.","amarelo",7000)
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddBonus",function(Passport,Amount)
	local Amount = Amount or 1
	Bonus[Passport] = (Bonus[Passport] or 0) + Amount
end)

exports("PodiumModel",function()
	return (Podium and Podium.Model) or "vigero2"
end)

exports("PodiumConfig",function()
	return Podium
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUCKYWHEEL:TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("luckywheel:Target")
AddEventHandler("luckywheel:Target",function()
	local source = source
	local CurrentTimer = os.time()
	local Passport = vRP.Passport(source)

	if not Passport or Active[Passport] then
		return false
	end

	if CurrentTimer < Progress then
		TriggerClientEvent("Notify",source,"Atenção","Aguarde <b>"..(Progress - CurrentTimer).."</b> segundos.","amarelo",5000)
		return false
	end

	if not CheckPayment(source,Passport) then
		return false
	end

	Active[Passport] = true
	Progress = CurrentTimer + 15
	local Result = GetWheelRandom(Rewards)

	if exports.discord then
		pcall(function()
			exports.discord:Embed("Luckywheel","**[PASSAPORTE]:** "..Passport.."\n**[RESULTADO]:** "..Result.."\n**[ITEM]:** "..Dotted(Rewards[Result].Amount).."x "..exports.vrp:ItemName(Rewards[Result].Item))
		end)
	end

	for _,OtherSource in pairs(vRPC.Players(source)) do
		async(function()
			TriggerClientEvent("luckywheel:Start",OtherSource,Result)
		end)
	end

	SetTimeout(10000,function()
		if Rewards[Result] then
			vRP.GenerateItem(Passport,Rewards[Result].Item,Rewards[Result].Amount,true)

			if Rewards[Result].Item == "casinovehicle" then
				TriggerClientEvent("Notify",-1,"Cassino","Parabéns ao cidadão de Passaporte <b>"..Passport.."</b> por ganhar o <b>Veículo do Cassino</b> na Roda da Fortuna!","amarelo",10000)
			end
		end

		Active[Passport] = nil
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWHEELRANDOM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetWheelRandom(Table)
	local PoolSize = 0
	for Number = 1,#Table do
		PoolSize = PoolSize + Table[Number].Chance
	end

	local Selected = math.random(1,PoolSize)
	for Index,v in pairs(Table) do
		Selected = Selected - v.Chance

		if (Selected <= 0) then
			return Index
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end

	if Daily[Passport] then
		Daily[Passport] = nil
	end
end)