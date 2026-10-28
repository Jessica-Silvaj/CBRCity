-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	if Opened then
		Opened = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,PrimaryWeight,PrimarySlots = vSERVER.Mount(Opened)
	if Primary then
		Callback({
			Primary = {
				Data = Primary,
				MaxWeight = PrimaryWeight,
				Slots = PrimarySlots or Theme.inventory.slots.default
			},
			Secondary = {
				Data = ItemList[Opened],
				Slots = math.max(CountTable(ItemList[Opened]),25)
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Take(Data.Item,Data.Amount,Data.Target,Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Store(Data.Item,Data.Amount,Data.Target,Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Open",function(Number)
	if exports.hud:Wanted() then
		return
	end

	if type(Number) == "table" and Number.shop then
		Number = Number.shop
	end
	Number = tostring(Number)

	local Shop = Location[Number]
	if Shop then
	end

	if not Shop then
		if vSERVER.Permission(Number) and List[Number] then
			Opened = Number

			TriggerEvent("inventory:Open",{
				Type = "Shops",
				Mode = List[Opened].Mode,
				Item = List[Opened].Item or "dollar",
				Resource = "shops",
				Right = "Loja"
			})
		end

		return
	end

	local RouteMatch = not Shop.Route or Shop.Route == LocalPlayer.state.Route
	if not RouteMatch or not vSERVER.Permission(Shop.Mode) then
		return
	end

	Opened = Shop.Mode

	if not List[Opened] then return end

	TriggerEvent("inventory:Open",{
		Type = "Shops",
		Mode = List[Opened].Mode,
		Item = List[Opened].Item or "dollar",
		Resource = "shops",
		Right = Shop.Name or "Loja"
	})

	if Shop.Sound then
		TriggerEvent("sounds:Private","shop",0.5)
	end
end)
local activeZones = {}

RegisterNetEvent("shops:updateFromAdmin")
AddEventHandler("shops:updateFromAdmin", function(shops)
	for _, id in ipairs(activeZones) do
		exports.target:RemCircleZone("Shops:"..id)
	end
	activeZones = {}
	Location = {}

	for _, v in pairs(shops) do
		local stringId = tostring(v.id)
		Location[stringId] = {
			Name = v.Name,
			Coords = vec3(v.X, v.Y, v.Z),
			Mode = v.Mode,
			Route = v.Route,
			Circle = v.Circle
		}

		if v.Circle and v.Circle > 0.0 then
			exports.target:AddCircleZone("Shops:"..stringId, vec3(v.X, v.Y, v.Z), v.Circle, {
				name = "Shops:"..stringId,
				heading = 0.0,
				useZ = true
			}, {
				shop = stringId,
				Distance = 2.0,
				options = {
					{
						event = "shops:Open",
						label = "Abrir",
						tunnel = "client"
					}
				}
			})
		else
			exports.target:AddBoxZone("Shops:"..stringId, vec3(v.X, v.Y, v.Z), 0.75, 0.75, {
				name = "Shops:"..stringId,
				heading = 0.0,
				minZ = v.Z - 1.0,
				maxZ = v.Z + 1.0
			}, {
				shop = stringId,
				Distance = 2.0,
				options = {
					{
						event = "shops:Open",
						label = "Abrir",
						tunnel = "client"
					}
				}
			})
		end
		table.insert(activeZones, stringId)
	end
end)

RegisterNetEvent("shops:updateConfigsFromAdmin")
AddEventHandler("shops:updateConfigsFromAdmin", function(configs)
	List = configs
	ItemList = {}

	for Shop, v in pairs(List) do
		ItemList[Shop] = {}
		if v.List then
			for Key, Amount in pairs(v.List) do
				table.insert(ItemList[Shop], { price = Amount, key = Key })
			end
		end
	end
end)
