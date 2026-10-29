-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
-- Pontos vêm do servidor (GlobalState.RobberyPoints, editável no painel gestor); sem ele usa a lista do shared
local Zones = {}

local function BuildZones(Points,Removed)
	for Name in pairs(Zones) do
		exports.target:RemCircleZone(Name)
	end
	Zones = {}

	Removed = Removed or GlobalState.RobberyRemoved or {}
	Points = Points or GlobalState.RobberyPoints
	if not Points then
		Points = {}
		for Number,v in pairs(Robbery) do
			Points[tostring(Number)] = { Mode = v.Mode,X = v.Coords.x,Y = v.Coords.y,Z = v.Coords.z }
		end
	end

	for Id,v in pairs(Points) do
		local Number = tonumber(Id)
		if Number and not Removed[v.Mode] then
			local Name = "Robbery:"..Number
			exports.target:AddCircleZone(Name,vec3(v.X,v.Y,v.Z),1.0,{
				name = Name,
				heading = 0.0,
				useZ = true
			},{
				shop = Number,
				Distance = 1.0,
				options = {
					{
						event = "inventory:Robbery",
						tunnel = "server",
						label = "Roubar",
						service = v.Mode
					}
				}
			})
			Zones[Name] = true
		end
	end
end

AddStateBagChangeHandler("RobberyRemoved","global",function(_,_,Value)
	BuildZones(nil,Value)
end)

AddStateBagChangeHandler("RobberyPoints","global",function(_,_,Value)
	BuildZones(Value)
end)

CreateThread(function()
	BuildZones()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:EXPLOSION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Explosion")
AddEventHandler("inventory:Explosion",function(Coords)
	AddExplosion(Coords.x,Coords.y,Coords.z,4,1.0,true,false,true)
end)