-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("doors")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Doors = {}
local Display = {}
local Cooldown = GetGameTimer()
local closestDoor = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS:CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("doors:Connect")
AddEventHandler("doors:Connect",function(Table)
	if Doors then
		for Number, _ in pairs(Doors) do
			if not Table[Number] then
				local doorHash = GetHashKey("door_" .. tostring(Number))
				if IsDoorRegisteredWithSystem(doorHash) then
					RemoveDoorFromSystem(doorHash)
				end
			end
		end
	end

	Doors = Table

	for Number, v in pairs(Doors) do
		local doorHash = GetHashKey("door_" .. tostring(Number))

		if not IsDoorRegisteredWithSystem(doorHash) then
			AddDoorToSystem(doorHash, v.Hash, v.Coords.x, v.Coords.y, v.Coords.z, false, false, false)
		end

		DoorSystemSetOpenRatio(doorHash, 0.0, true, true)
		DoorSystemSetAutomaticRate(doorHash, 0.0, false, false)
		DoorSystemSetAutomaticDistance(doorHash, 0.0, false, false)
		DoorSystemSetDoorState(doorHash, v.Lock and 1 or 0, true, true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS:SYNC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("doors:Sync")
AddEventHandler("doors:Sync",function(Number,Status,Other)
	if Number and Doors[Number] then
		Doors[Number].Lock = Status

		if Other and Doors[Other] then
			TriggerEvent("doors:Sync",Other,Status)
		end

		local doorHash = GetHashKey("door_" .. tostring(Number))

		if Status then
			DoorSystemSetDoorState(doorHash, 0, false, false)
			DoorSystemSetOpenRatio(doorHash, 0.0, false, false)
		else
			DoorSystemSetDoorState(doorHash, 0, false, false)
		end

		if Display[Number] then
			SendNUIMessage({ Action = "Show", Payload = { "E","Pressione",Status and "para destrancar" or "para trancar" } })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local newClosest = nil
		local minDistance = 9999.0

		for Number,v in pairs(Doors) do
			if not v.Disabled then
				local dist = #(Coords - (v.Center or v.Coords))
				if dist <= v.Distance and dist < minDistance then
					minDistance = dist
					newClosest = Number
				end
			end
		end

		if newClosest then
			TimeDistance = 1
			if closestDoor ~= newClosest then
				if closestDoor and Display[closestDoor] then
					SendNUIMessage({ Action = "Hide" })
					Display[closestDoor] = nil
				end
				closestDoor = newClosest
			end

			local v = Doors[closestDoor]
			if not Display[closestDoor] then
				SendNUIMessage({ Action = "Show", Payload = { "E","Pressione",v.Lock and "para destrancar" or "para trancar" } })
				Display[closestDoor] = true
			end

			if IsControlJustPressed(1,38) and Cooldown <= GetGameTimer() then
				Cooldown = GetGameTimer() + 1000
				vSERVER.Permission(closestDoor)
			end
		else
			if closestDoor then
				if Display[closestDoor] then
					SendNUIMessage({ Action = "Hide" })
					Display[closestDoor] = nil
				end
				closestDoor = nil
			end
		end

		Wait(TimeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REINFORCEMENT THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(150)

		local playerPed = PlayerPedId()
		if playerPed ~= 0 and playerPed ~= -1 and DoesEntityExist(playerPed) and next(Doors) then
			local playerCoords = GetEntityCoords(playerPed)
			local checkDistance = 15.0

			for Number, v in pairs(Doors) do
				if not v.Disabled then
					local distance = #(playerCoords - v.Coords)

					if distance < checkDistance then
                        local doorHash = GetHashKey("door_" .. tostring(Number))
						if v.Lock then
							local ratio = DoorSystemGetOpenRatio(doorHash)
							if ratio > -0.05 and ratio < 0.05 then
								if DoorSystemGetDoorState(doorHash) ~= 1 then
									DoorSystemSetDoorState(doorHash, 1, false, false)
								end
							else
								if DoorSystemGetDoorState(doorHash) ~= 0 then
									DoorSystemSetDoorState(doorHash, 0, false, false)
								end
								DoorSystemSetOpenRatio(doorHash, 0.0, false, false)
							end
						else
							if DoorSystemGetDoorState(doorHash) ~= 0 then
								DoorSystemSetDoorState(doorHash, 0, false, false)
							end
						end
					end
				end
			end
		else
			Wait(1000)
		end
	end
end)