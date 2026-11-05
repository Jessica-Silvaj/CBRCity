--------------------------------------------------------------------------------------------------------------
-- ALPHAS, TELEPORTS E NOMES DE RUAS (painel gestor)
--------------------------------------------------------------------------------------------------------------
for _,Name in ipairs({ "requestAlphas","saveAlpha","deleteAlpha","requestTeleports","saveTeleport","deleteTeleport","requestStreets","saveStreet","deleteStreet" }) do
	RegisterNUICallback(Name,function(Data,Callback)
		TriggerServerEvent("Night_Management:"..Name,Data)
		Callback("ok")
	end)
end

RegisterNetEvent("Night_Management:updateAlphas")
AddEventHandler("Night_Management:updateAlphas",function(List)
	SendNUIMessage({ action = "updateAlphas", alphas = List })
end)

RegisterNetEvent("Night_Management:updateTeleports")
AddEventHandler("Night_Management:updateTeleports",function(List)
	SendNUIMessage({ action = "updateTeleports", teleports = List })
end)

RegisterNetEvent("Night_Management:updateStreets")
AddEventHandler("Night_Management:updateStreets",function(List)
	SendNUIMessage({ action = "updateStreets", streets = List })
end)

for _,Name in ipairs({ "alphaSaved","teleportSaved","streetSaved" }) do
	RegisterNetEvent("Night_Management:"..Name)
	AddEventHandler("Night_Management:"..Name,function()
		SendNUIMessage({ action = Name })
	end)
end

for Callback,Action in pairs({ getCoordsAlpha = "pushCoordsAlpha", getCoordsTeleport1 = "pushCoordsTeleport1", getCoordsTeleport2 = "pushCoordsTeleport2" }) do
	RegisterNUICallback(Callback,function(Data,Reply)
		local Coords = GetEntityCoords(PlayerPedId())
		SendNUIMessage({ action = Action, x = Coords.x, y = Coords.y, z = Coords.z })
		Reply("ok")
	end)
end

RegisterNUICallback("getCurrentStreet",function(Data,Callback)
	local Coords = GetEntityCoords(PlayerPedId())
	local Hash = GetStreetNameAtCoord(Coords.x,Coords.y,Coords.z)
	SendNUIMessage({ action = "pushCurrentStreet", hash = string.format("0x%X",Hash), name = GetStreetNameFromHashKey(Hash) or "" })
	Callback("ok")
end)
