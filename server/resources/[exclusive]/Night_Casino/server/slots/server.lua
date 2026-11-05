local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--math.randomseed(os.clock()*100000000000)
--math.randomseed(os.clock()*100000000000)
--math.randomseed(os.clock()*100000000000)

local activeSlot = {}

RegisterNetEvent('casino:slots:isSeatUsed')
AddEventHandler('casino:slots:isSeatUsed',function(index)
    local source = source
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
	if activeSlot[index] ~= nil then
		if activeSlot[index].used then
		else
			activeSlot[index].used = true
		end
	else
		activeSlot[index] = {}
		activeSlot[index].used = true
		updatePlayerChips(source)
	end
  end
end)

RegisterNetEvent('casino:slots:notUsing')
AddEventHandler('casino:slots:notUsing',function(index)
    local source = source
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
	if activeSlot[index] ~= nil then
		activeSlot[index].used = false
	end
  end
end)



RegisterNetEvent('casino:taskStartSlots')
AddEventHandler('casino:taskStartSlots',function(index)
	local source = source
	local Machine = ConfigSlots.Slots[index]
	local Active = activeSlot[index]
	if not Machine or not Active then return end

	-- Maquina ocupada por outro jogador ainda conectado
	if Active.win and Active.owner ~= source and GetPlayerName(Active.owner) then return end

	-- O valor vem da configuracao do servidor, nunca do cliente
	local Bet = Machine.bet
	local user_id = vRP.getUserId(source)
	if user_id == nil then return end

	Active.win = nil
	Active.owner = source
	Active.bet = Bet

	if not vRP.tryGetInventoryItem(user_id,"chips",Bet,false) then
		Active.owner = nil
		TriggerClientEvent("Notify",source,"Atenção","Você não tem fichas suficientes!","amarelo",5500)
		return
	end

	local w = {a = math.random(1,16),b = math.random(1,16),c = math.random(1,16)}

	local rnd1 = math.random(1,100)
	local rnd2 = math.random(1,100)
	local rnd3 = math.random(1,100)

	if ConfigSlots.Offset then
		if rnd1 > 30 then w.a = w.a + 0.5 end
		if rnd2 > 30 then w.b = w.b + 1.0 end
		if rnd3 > 30 then w.c = w.c + 0.5 end
	end

	Active.win = w
	TriggerClientEvent('casino:slots:startSpin', source, index, w)
end)



RegisterNetEvent('casino:slotsCheckWin')
AddEventHandler('casino:slotsCheckWin',function(index, data)
	local source = source
	local Active = activeSlot[index]
	if not Active or not Active.win or Active.owner ~= source or type(data) ~= "table" then return end

	local Win = Active.win
	if Win.a == data.a and Win.b == data.b and Win.c == data.c then
		-- Limpa antes de pagar: o mesmo giro nao pode ser pago duas vezes
		Active.win = nil
		CheckForWin(source, Win, { bet = Active.bet })
	end
end)



function CheckForWin(source, w, data)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
	local a = ConfigSlots.Wins[w.a]
	local b = ConfigSlots.Wins[w.b]
	local c = ConfigSlots.Wins[w.c]
	local total = 0
	if a == b and b == c and a == c then
		if ConfigSlots.Mult[a] then
			total = data.bet*ConfigSlots.Mult[a]
		end		
	elseif a == '6' and b == '6' then
		total = data.bet*5
	elseif a == '6' and c == '6' then
		total = data.bet*5
	elseif b == '6' and c == '6' then
		total = data.bet*5
		
	elseif a == '6' then
		total = data.bet*2
	elseif b == '6' then
		total = data.bet*2
	elseif c == '6' then
		total = data.bet*2
	end
	if total > 0 then
		            TriggerClientEvent("Notify",source,"Sucesso","Você ganhou <b>"..total.."</b> fichas.","verde",5500)
					TriggerClientEvent('InteractSound_CL:PlayOnOne', source, 'TD_BIG_WIN_01', 0.1)
		            vRP.giveInventoryItem(user_id,"chips",total,false)
					updatePlayerChips(source)
		else
		            TriggerClientEvent("Notify",source,"Aviso","Infelizmente você perdeu.","amarelo",5500)
					TriggerClientEvent('InteractSound_CL:PlayOnOne', source, 'TD_NO_WIN_01', 0.1)
					updatePlayerChips(source)
	end
  end
end

function getPlayerChips(source)
    local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
        return vRP.getInventoryItemAmount(user_id,"chips")
    else
        return 0
    end
end

function updatePlayerChips(source)
    TriggerClientEvent('slots:updatePlayerChips', source, getPlayerChips(source))
end