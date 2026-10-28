-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = false
local Animation = false
local StoreBlock = false
local TakeBlock = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Open")
AddEventHandler("chest:Open",function(Name,Mode,Item,Blocked,Force)
	if type(Name) == "table" then
		Mode = Name.service or Name.Mode
		Name = Name.shop or Name.Name or Name.chest
	end

	if not Name or not Mode then
		return false
	end

	if Mode == "Goals" then
		Name = "Painel:Goals:"..SplitOne(Name,":")
		TakeBlock = true
	end

	local Ped = PlayerPedId()
	if not vSERVER.Permissions(Name,Mode,Item) or GetEntityHealth(Ped) <= 100 then
		return false
	end

	if Blocked then
		StoreBlock = true
	else
		local BlockedTypes = { "Helicrash","Halloween","Christmas" }
		for Number = 1,#BlockedTypes do
			if SplitBoolean(Name,BlockedTypes[Number],":") then
				StoreBlock = true
				break
			end
		end
	end

	Opened = Name

	if Mode ~= "Item" then
		Animation = true
		vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)
	end

	TriggerEvent("inventory:Open", {
		Type = "Chest",
		Resource = "chest",
		Force = Force,
		Right = "Baú"
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Item",function(Name)
	local FullName = splitString(Name)
	if vSERVER.Permissions(FullName[1]..":"..FullName[3],"Item") and GetEntityHealth(PlayerPedId()) > 100 then
		Opened = true
		TriggerEvent("inventory:Open",{ Type = "Chest", Resource = "chest", Right = "Baú" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:RECYCLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Recycle",function()
	if vSERVER.Permissions("Recycle","Tray") and GetEntityHealth(PlayerPedId()) > 100 then
		Opened = true
		TriggerEvent("inventory:Open",{ Type = "Chest", Resource = "chest", Right = "Baú" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function(Force)
	if (not Force and Opened) or (Force and Opened and Opened == Force) then
		if Animation then
			Animation = false
			vRP.Destroy()
		end

		Opened = false
		TakeBlock = false
		StoreBlock = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:Closed",function(Name)
	if Opened and Opened == Name then
		if Animation then
			Animation = false
			vRP.Destroy()
		end

		Opened = false
		TakeBlock = false
		StoreBlock = false
		TriggerEvent("inventory:Close")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	Callback(vSERVER.Take(Data.Item,Data.Slot,Data.Amount,Data.Target,TakeBlock))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	Callback(vSERVER.Store(Data.Item,Data.Slot,Data.Amount,Data.Target,StoreBlock))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	Callback(vSERVER.Update(Data.Slot,Data.Target,Data.Amount))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,Secondary,PrimaryWeight,SecondaryWeight,PrimarySlots,SecondarySlots = vSERVER.Mount()
	if Primary then
		Callback({
			Primary = {
				Data = Primary,
				MaxWeight = PrimaryWeight,
				Slots = PrimarySlots or Theme.inventory.slots.default
			},
			Secondary = {
				Data = Secondary,
				MaxWeight = SecondaryWeight,
				Slots = SecondarySlots or Theme.inventory.slots.default
			}
		})
	end
end)