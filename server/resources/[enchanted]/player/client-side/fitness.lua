-----------------------------------------------------------------------------------------------------------------------------------------
-- TREINO: CORRIDA E BICICLETA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Previous = false
	while true do
		Wait(1000)
		local Ped = PlayerPedId()
		local Mode = false
		if LocalPlayer.state.Active and not LocalPlayer.state.Arena and GetEntityHealth(Ped) > 100 then
			local Vehicle = GetVehiclePedIsIn(Ped,false)
			if Vehicle ~= 0 and GetVehicleClass(Vehicle) == 13 and GetPedInVehicleSeat(Vehicle,-1) == Ped then
				Mode = "bike"
			elseif IsPedOnFoot(Ped) and (IsPedRunning(Ped) or IsPedSprinting(Ped)) and not IsPedSwimming(Ped)
				and not IsPedFalling(Ped) and not IsPedRagdoll(Ped) then
				Mode = "run"
			end
		end

		if Mode or Previous then
			-- O servidor mede a distância; o client informa somente a atividade.
			TriggerServerEvent("player:Fitness",Mode)
		end
		Previous = Mode
	end
end)
