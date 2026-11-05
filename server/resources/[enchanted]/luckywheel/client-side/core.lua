-----------------------------------------------------------------------------------------------------------------------------------------
-- DECORS
-----------------------------------------------------------------------------------------------------------------------------------------
DecorRegister("CREATIVE_VEHICLE", 2)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Object = nil
local Model = "vw_prop_vw_luckywheel_02a"
local PodiumVehicle = nil
local PodiumObject = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYVEHICLECOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
local function ApplyVehicleColors(Vehicle)
	if not DoesEntityExist(Vehicle) then
		return
	end

	-- Cor Primaria RGB
	if type(Podium.PrimaryColor) == "table" then
		SetVehicleCustomPrimaryColour(Vehicle, Podium.PrimaryColor[1] or 0, Podium.PrimaryColor[2] or 0, Podium.PrimaryColor[3] or 0)
	elseif type(Podium.PrimaryColor) == "number" then
		local Sec = type(Podium.SecondaryColor) == "number" and Podium.SecondaryColor or 0
		SetVehicleColours(Vehicle, Podium.PrimaryColor, Sec)
	end

	-- Cor Secundaria RGB
	if type(Podium.SecondaryColor) == "table" then
		SetVehicleCustomSecondaryColour(Vehicle, Podium.SecondaryColor[1] or 0, Podium.SecondaryColor[2] or 0, Podium.SecondaryColor[3] or 0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD WHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	LoadModel(Model)

	while true do
		local Sleep = 1000
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local Distance = #(Coords - Wheel.xyz)

		if Distance <= 50 then
			Sleep = 250
			if not Object then
				Object = CreateObjectNoOffset(Model,Wheel.xyz,false,false,false)
				SetEntityHeading(Object,Wheel.w)
			end
		elseif Object then
			if DoesEntityExist(Object) then
				DeleteEntity(Object)
			end
			Object = nil
		end

		Wait(Sleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD PODIUM VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Sleep = 1000

		if Podium and Podium.Model and Podium.Coords then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)
			local Distance = #(Coords - Podium.Coords.xyz)

			if Distance <= 80.0 then
				if not PodiumVehicle or not DoesEntityExist(PodiumVehicle) then
					if LoadModel(Podium.Model) then
						ClearAreaOfVehicles(Podium.Coords.x, Podium.Coords.y, Podium.Coords.z, 4.0, false, false, false, false, false)
						PodiumVehicle = CreateVehicle(GetHashKey(Podium.Model), Podium.Coords.x, Podium.Coords.y, Podium.Coords.z, Podium.Coords.w, false, false)
						SetVehicleNumberPlateText(PodiumVehicle, "CASINO")
						DecorSetBool(PodiumVehicle, "CREATIVE_VEHICLE", true)
						Entity(PodiumVehicle).state:set("CasinoVehicle", true, false)
						SetEntityInvincible(PodiumVehicle, true)
						SetVehicleDirtLevel(PodiumVehicle, 0.0)
						SetVehicleDoorsLocked(PodiumVehicle, 2)
						SetVehicleCanBeUsedByFleeingPeds(PodiumVehicle, false)
						SetVehicleHasBeenOwnedByPlayer(PodiumVehicle, true)
						ApplyVehicleColors(PodiumVehicle)
						SetVehicleOnGroundProperly(PodiumVehicle)
						FreezeEntityPosition(PodiumVehicle, true)
						SetEntityAsMissionEntity(PodiumVehicle, true, true)
						SetModelAsNoLongerNeeded(GetHashKey(Podium.Model))
					end
				end

				if Podium.Rotate and DoesEntityExist(PodiumVehicle) then
					Sleep = 0

					if not PodiumObject or PodiumObject == 0 or not DoesEntityExist(PodiumObject) then
						PodiumObject = GetClosestObjectOfType(Podium.Coords.x, Podium.Coords.y, Podium.Coords.z, 10.0, -1561087446, false, false, false)
					end

					local CurHeadingCar = GetEntityHeading(PodiumVehicle)
					local NextHeading = (CurHeadingCar + 0.075) % 360.0

					SetEntityHeading(PodiumVehicle, NextHeading)

					if PodiumObject and PodiumObject ~= 0 and DoesEntityExist(PodiumObject) then
						SetEntityHeading(PodiumObject, NextHeading)
					end
				else
					Sleep = 500
				end
			else
				if PodiumVehicle then
					if DoesEntityExist(PodiumVehicle) then
						DeleteEntity(PodiumVehicle)
					end
					PodiumVehicle = nil
					PodiumObject = nil
				end
			end
		end

		Wait(Sleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("luckywheel:Start")
AddEventHandler("luckywheel:Start",function(Result)
	if not Result or not Object or not DoesEntityExist(Object) then
		return false
	end

	SetEntityRotation(Object,0.0,0.0,0.0,2,true)

	CreateThread(function()
		local RollingSpeed
		local RollingRatio = 1.0
		local TargetAngle = (Result - 1) * 18
		local TotalRotation = TargetAngle + (360 * 8)
		local HalfRotation = TotalRotation / 2

		while RollingRatio > 0 do
			if TotalRotation > HalfRotation then
				RollingRatio = RollingRatio + 1
			else
				RollingRatio = RollingRatio - 1
			end

			RollingRatio = math.max(RollingRatio,0)
			RollingSpeed = RollingRatio / 200
			TotalRotation = TotalRotation - RollingSpeed

			local CurrentRotation = GetEntityRotation(Object,2)

			SetEntityRotation(Object,0.0,(CurrentRotation.y - RollingSpeed),Wheel.w,2,true)

			Wait(0)
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(Resource)
	if GetCurrentResourceName() == Resource then
		if Object and DoesEntityExist(Object) then
			DeleteEntity(Object)
		end

		if PodiumVehicle and DoesEntityExist(PodiumVehicle) then
			DeleteEntity(PodiumVehicle)
		end
	end
end)