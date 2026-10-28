-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("bank")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
-- Bank points and branch blips are managed by Night_Management.
local AtmZones = {}
local AgencyBlips = {}

RegisterNetEvent("Night_Management:atmsSync")
AddEventHandler("Night_Management:atmsSync",function(List)
	for Zone in pairs(AtmZones) do
		exports.target:RemCircleZone(Zone)
	end

	AtmZones = {}
    for _,Blip in ipairs(AgencyBlips) do RemoveBlip(Blip) end
    AgencyBlips = {}

	for _,Atm in ipairs(List or {}) do
		local Options = {}
        if Atm.Kind == "agency" and Atm.Open then
            local Blip = AddBlipForCoord(Atm.X,Atm.Y,Atm.Z)
            SetBlipSprite(Blip,108)
            SetBlipColour(Blip,2)
            SetBlipScale(Blip,0.65)
            SetBlipAsShortRange(Blip,true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Atm.Name or "Banco")
            EndTextCommandSetBlipName(Blip)
            AgencyBlips[#AgencyBlips + 1] = Blip
        end

		if Atm.Open then
			Options[#Options + 1] = { event = "Bank", label = "Abrir", tunnel = "client" }
		end

		if Atm.Kind ~= "agency" and Atm.Rob then
			Options[#Options + 1] = { event = "eletronics:openSystem", label = "Roubar", tunnel = "client" }
		end

		if #Options > 0 then
			local Zone = "BankATM:"..Atm.id
			exports.target:AddCircleZone(Zone,vec3(Atm.X,Atm.Y,Atm.Z),1.0,{
				name = Zone,
				heading = 0.0,
				useZ = true
			},{
				Distance = 1.0,
				options = Options
			})

			AtmZones[Zone] = true
		end
	end
end)

-- Se o bank reiniciar sozinho, pede a lista de novo
CreateThread(function()
	TriggerServerEvent("Night_Management:atmsLoad")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Bank",function()
	if not exports.hud:Wanted() then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		TriggerEvent("hud:Active",false)
		SendNUIMessage({ Action = "Open", Payload = { Name = LocalPlayer.state.Name, Passport = LocalPlayer.state.Passport } })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	TriggerEvent("hud:Active",true)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK:NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("bank:Notify")
AddEventHandler("bank:Notify",function(Title,Message,Type)
	SendNUIMessage({ Action = "Notify", Payload = { Title = Title, Message = Message, Type = Type } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Transactions",function(Data,Callback)
	Callback(vSERVER.Transactions())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADTRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("LoadTransactions",function(Data,Callback)
	Callback(vSERVER.Transactions(Data.Before))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Home",function(Data,Callback)
	Callback(vSERVER.Home())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deposit",function(Data,Callback)
	Callback(vSERVER.Deposit(Data.Value))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Withdraw",function(Data,Callback)
	Callback(vSERVER.Withdraw(Data.Value))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Transfer",function(Data,Callback)
	Callback(vSERVER.Transfer(Data.Passport,Data.Value))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Invoices",function(Data,Callback)
	Callback(vSERVER.Invoices())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CreateInvoice",function(Data,Callback)
	Callback(vSERVER.CreateInvoice(Data.Passport,Data.Value,Data.Reason))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PayInvoice",function(Data,Callback)
	Callback(vSERVER.PayInvoice(Data.Id))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CancelInvoice",function(Data,Callback)
	Callback(vSERVER.CancelInvoice(Data.Id))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Fines",function(Data,Callback)
	Callback(vSERVER.Fines())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetFine",function(Data,Callback)
	Callback(vSERVER.GetFine(Data.Id))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYFINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PayFine",function(Data,Callback)
	Callback(vSERVER.PayFine(Data.Id))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYALLFINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PayAllFines",function(Data,Callback)
	Callback(vSERVER.PayAllFines())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Taxes",function(Data,Callback)
	Callback(vSERVER.Taxes())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYTAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PayTax",function(Data,Callback)
	Callback(vSERVER.PayTax(Data.Id))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYALLTAXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PayAllTaxes",function(Data,Callback)
	Callback(vSERVER.PayAllTaxes())
end)
