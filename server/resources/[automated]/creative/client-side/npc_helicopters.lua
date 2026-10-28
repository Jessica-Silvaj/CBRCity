-----------------------------------------------------------------------------------------------------------------------------------------
-- HELICÓPTEROS DO TRÁFEGO AMBIENTE
-----------------------------------------------------------------------------------------------------------------------------------------
local Helicopters = {
	"annihilator","annihilator2","buzzard","buzzard2",
	"cargobob","cargobob2","cargobob3","cargobob4",
	"conada","conada2","frogger","frogger2","havok","hunter",
	"maverick","polmav","savage","seasparrow","seasparrow2","seasparrow3",
	"skylift","supervolito","supervolito2","swift","swift2",
	"valkyrie","valkyrie2","volatus"
}

local function HasPlayer(Vehicle)
	for Seat = -1,GetVehicleMaxNumberOfPassengers(Vehicle) - 1 do
		local Ped = GetPedInVehicleSeat(Vehicle,Seat)
		if Ped ~= 0 and IsPedAPlayer(Ped) then
			return true
		end
	end

	return false
end

CreateThread(function()
	-- Bloqueia apenas o surgimento natural; garagens continuam criando os modelos normalmente.
	for _,Model in ipairs(Helicopters) do
		SetVehicleModelIsSuppressed(GetHashKey(Model),true)
	end

	while true do
		for _,Vehicle in ipairs(GetGamePool("CVehicle")) do
			if DoesEntityExist(Vehicle) and IsThisModelAHeli(GetEntityModel(Vehicle)) and not IsEntityAMissionEntity(Vehicle) then
				local Population = GetEntityPopulationType(Vehicle)
				local Pilot = GetPedInVehicleSeat(Vehicle,-1)
				if Population >= 1 and Population <= 5 and Pilot ~= 0 and not IsPedAPlayer(Pilot) and not HasPlayer(Vehicle) then
					if not NetworkGetEntityIsNetworked(Vehicle) or NetworkHasControlOfEntity(Vehicle) then
						SetEntityAsMissionEntity(Vehicle,true,true)
						DeleteVehicle(Vehicle)
					else
						NetworkRequestControlOfEntity(Vehicle)
					end
				end
			end
		end

		Wait(5000)
	end
end)
