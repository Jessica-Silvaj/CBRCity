-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	Opened = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenCrafting(Mode)
	Opened = Mode

	TriggerEvent("inventory:Open",{
		Mode = "Buy",
		Type = "Shops",
		Right = "Produção",
		Resource = "crafting"
	})
end
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
-- CRAFTING:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:Open",function(Number)
	if type(Number) == "table" then
		Number = Number.shop or Number[1] or Number
	end

	if exports.hud:Wanted() then
		return false
	end

	local Data = Location[Number]
	if Data then
		if vSERVER.Permission(Data.Mode) then
			OpenCrafting(Data.Mode)
		end
	else
		if vSERVER.Permission(Number) then
			OpenCrafting(Number)
		end
	end
end)
local activeZones = {}

RegisterNetEvent("crafting:updateCraftings")
AddEventHandler("crafting:updateCraftings", function(craftings)
	for _, id in ipairs(activeZones) do
		exports.target:RemCircleZone("Crafting:"..id)
	end
	activeZones = {}
	Location = {}

	if craftings then
		for _, v in pairs(craftings) do
			local stringId = tostring(v.id)
			Location[stringId] = {
				Name = v.Name,
				Coords = vec3(v.X, v.Y, v.Z),
				Mode = v.Mode,
				Circle = v.Circle
			}

			if v.Circle and v.Circle > 0.0 then
				exports.target:AddCircleZone("Crafting:"..stringId, vec3(v.X, v.Y, v.Z), v.Circle, {
					name = "Crafting:"..stringId,
					heading = 0.0,
					useZ = true
				}, {
					shop = stringId,
					Distance = 2.0,
					options = {
						{
							event = "crafting:Open",
							label = "Abrir",
							tunnel = "client"
						}
					}
				})
			else
				exports.target:AddBoxZone("Crafting:"..stringId, vec3(v.X, v.Y, v.Z), 0.75, 0.75, {
					name = "Crafting:"..stringId,
					heading = 0.0,
					minZ = v.Z - 1.0,
					maxZ = v.Z + 1.0
				}, {
					shop = stringId,
					Distance = 2.0,
					options = {
						{
							event = "crafting:Open",
							label = "Abrir",
							tunnel = "client"
						}
					}
				})
			end
			table.insert(activeZones, stringId)
		end
	end
end)

RegisterNetEvent("crafting:updateConfigs")
AddEventHandler("crafting:updateConfigs", function(configs)
	List = configs
	ItemList = {}

	if List then
		for Index,v in pairs(List) do
			local Result = {}
			for Key,Recipe in pairs(v.List) do
				Result[#Result + 1] = {
					key = Key,
					price = Recipe.Amount,
					required = Recipe.Required
				}
			end
			ItemList[Index] = Result
		end
	end
end)
