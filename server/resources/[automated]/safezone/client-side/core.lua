-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local LastVehicle = nil
local SafeZones = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC ZONES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Safezone:UpdateZones")
AddEventHandler("Safezone:UpdateZones", function(data)
    SafeZones = {}
    for k, v in pairs(data) do
        if v.points and #v.points >= 3 then
            local pts = {}
            for _, p in ipairs(v.points) do
                table.insert(pts, vec2(p.x, p.y))
            end
            
            table.insert(SafeZones, PolyZone:Create(pts, {
                name = "Safezone_"..v.id,
                minZ = v.minZ,
                maxZ = v.maxZ
            }))
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Inside = false
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Index,Poly in ipairs(SafeZones) do
			if Poly:isPointInside(Coords) then
				Inside = Index
				break
			end
		end

		local SafeState = LocalPlayer.state.Safezone
		if Inside and not SafeState then
			LocalPlayer.state:set("Safezone",Inside,true)
			NetworkSetFriendlyFireOption(false)
			SetEntityInvincible(Ped,true)
			SetLocalPlayerAsGhost(true)

			if IsPedArmed(Ped,7) then
				TriggerEvent("inventory:CleanWeapons")
			end
		elseif not Inside and SafeState then
			SetLocalPlayerAsGhost(false)
			SetEntityInvincible(Ped,false)
			NetworkSetFriendlyFireOption(true)
			LocalPlayer.state:set("Safezone",false,true)
		end

		Wait(1000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADZONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if LocalPlayer.state.Safezone then
			TimeDistance = 0

			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,68,true)
			DisableControlAction(0,69,true)
			DisableControlAction(0,70,true)
			DisableControlAction(0,91,true)
			DisableControlAction(0,92,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,257,true)
			DisablePlayerFiring(Ped,true)

			local Vehicle = GetVehiclePedIsIn(Ped)
			if Vehicle > 0 then
				if LastVehicle ~= Vehicle then
					if LastVehicle and DoesEntityExist(LastVehicle) then
						SetNetworkVehicleAsGhost(LastVehicle,false)
					end

					LastVehicle = Vehicle
					SetNetworkVehicleAsGhost(Vehicle,true)
				end
			elseif LastVehicle then
				if DoesEntityExist(LastVehicle) then
					SetNetworkVehicleAsGhost(LastVehicle,false)
				end

				LastVehicle = nil
			end
		elseif LastVehicle then
			if DoesEntityExist(LastVehicle) then
				SetNetworkVehicleAsGhost(LastVehicle,false)
			end

			LastVehicle = nil
		end

		Wait(TimeDistance)
	end
end)