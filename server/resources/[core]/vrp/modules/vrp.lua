-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
DEVICE = Tunnel.getInterface("device")
REQUEST = Tunnel.getInterface("request")
TASKBAR = Tunnel.getInterface("taskbar")
SURVIVAL = Tunnel.getInterface("survival")
KEYBOARD = Tunnel.getInterface("keyboard")
LETTERGAME = Tunnel.getInterface("lettergame")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetMapName(ServerName)
	SetGameType(ServerName)

	while true do
		Wait(10000)
		for source, data in pairs(Characters) do
			if data and data.id and not data.Phone then
				vRP.Phone(data.id)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ClearInventory(Passport,Ignore)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	exports.inventory:CleanWeapons(Passport)
	TriggerEvent("DebugWeapons",Passport)
	TriggerEvent("DebugObjects",Passport)

	for _,v in pairs(Inventory) do
		local ItemName = SplitOne(v.item)
		if not (KeepItemsOnDeathSystem and KeepItemsOnDeath[ItemName]) then
			if not exports.vrp:BlockDelete(v.item) then
				vRP.RemoveItem(Passport,v.item,v.amount)
			end
		end
	end

	if not Ignore then
		local Weight = 50
		for Permission,Multiplier in pairs({ Ouro = 25, Prata = 15, Bronze = 5 }) do
			if vRP.HasService(Passport,Permission) then
				Weight = Weight - Multiplier
			end
		end

		if Weight > 0 then
			vRP.UpgradeWeight(Passport,Weight,"-")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Phone(Passport)
	local PhoneNumber = "Inativo"
	local source = vRP.Source(Passport)

	if Characters[source] and Characters[source].Phone then
		PhoneNumber = exports["lb-phone"]:FormatNumber(Characters[source].Phone)
	else
		local Consult = vRP.SingleQuery("smartphone/Phone",{ Passport = Passport })
		if Consult and Consult.phone_number then
			PhoneNumber = exports["lb-phone"]:FormatNumber(Consult.phone_number)

			if Characters[source] then
				Characters[source].Phone = Consult.phone_number
			end

			vRP.Execute("characters/UpdatePhone",{ Passport = Passport, Phone = Consult.phone_number })
		end
	end

	return PhoneNumber
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CleanPhone(Passport)
	local Consult = vRP.SingleQuery("smartphone/Phone",{ Passport = Passport })

	return Consult and Consult.phone_number or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Request(source,Title,Message)
	return REQUEST.Function(source,Title,Message)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Revive(source,Health,Arena)
	return SURVIVAL.Revive(source,Health,Arena)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.TASK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Task(source,Amount,Speed)
	return TASKBAR.Task(source,Amount,Speed)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.DEVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Device(source,Seconds)
    return DEVICE.Device(source,Seconds)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.LETTERGAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.LetterGame(source,Duration,Speed)
    return LETTERGAME.LetterGame(source,Duration,Speed)
end
