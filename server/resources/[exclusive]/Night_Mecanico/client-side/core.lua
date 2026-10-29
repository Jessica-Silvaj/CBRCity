-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = false
local Truck,Mechanic,Blip = nil,nil,nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(Message,Color)
	TriggerEvent("Notify","Mecânico",Message,Color or "amarelo",5000)
end

local function LoadModel(Model)
	local Hash = GetHashKey(Model)
	RequestModel(Hash)

	local Timeout = GetGameTimer() + 10000
	while not HasModelLoaded(Hash) and GetGameTimer() < Timeout do
		Wait(10)
	end

	return HasModelLoaded(Hash) and Hash
end

local function LoadDict(Dict)
	RequestAnimDict(Dict)

	local Timeout = GetGameTimer() + 5000
	while not HasAnimDictLoaded(Dict) and GetGameTimer() < Timeout do
		Wait(10)
	end
end

-- Veículo que o jogador está dentro ou o mais próximo dele
local function TargetVehicle()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped,false) then
		return GetVehiclePedIsIn(Ped,false)
	end

	local Coords = GetEntityCoords(Ped)
	local Closest,Distance = nil,Config.VehicleDistance

	for _,Vehicle in ipairs(GetGamePool("CVehicle")) do
		local Current = #(GetEntityCoords(Vehicle) - Coords)
		if Current <= Distance and NetworkGetEntityIsNetworked(Vehicle) then
			Closest,Distance = Vehicle,Current
		end
	end

	return Closest
end

-- Ponto de rua a ~SpawnDistance metros
local function FindSpawn(Coords)
	local Best,BestHeading,BestDiff = nil,0.0,math.huge

	for Index = 1,60 do
		local Found,Node,Heading = GetNthClosestVehicleNodeWithHeading(Coords.x,Coords.y,Coords.z,Index,1,3.0,0)
		if Found then
			local Diff = math.abs(#(Node - Coords) - Config.SpawnDistance)
			if Diff < BestDiff then
				Best,BestHeading,BestDiff = Node,Heading,Diff
			end

			if Diff <= 10.0 then
				break
			end
		end
	end

	return Best,BestHeading
end

local function Cleanup()
	if Blip and DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end

	for _,Entity in ipairs({ Mechanic,Truck }) do
		if Entity and DoesEntityExist(Entity) then
			SetEntityAsMissionEntity(Entity,true,true)
			DeleteEntity(Entity)
		end
	end

	Truck,Mechanic,Blip = nil,nil,nil
end

local function Finish(Repaired)
	Active = false
	TriggerServerEvent("Night_Mecanico:Finish",Repaired)
end

local function Abort(Message)
	if Message then
		Notify(Message)
	end

	Cleanup()
	Finish(false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVE: mecânico volta ao guincho, vai embora e some
-----------------------------------------------------------------------------------------------------------------------------------------
local function Leave()
	if Blip and DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end

	if Mechanic and DoesEntityExist(Mechanic) and Truck and DoesEntityExist(Truck) then
		ClearPedTasks(Mechanic)
		TaskEnterVehicle(Mechanic,Truck,15000,-1,2.0,1,0)

		local Timeout = GetGameTimer() + 15000
		while not IsPedInVehicle(Mechanic,Truck,false) and GetGameTimer() < Timeout do
			Wait(250)
		end

		if not IsPedInVehicle(Mechanic,Truck,false) then
			SetPedIntoVehicle(Mechanic,Truck,-1)
		end

		TaskVehicleDriveWander(Mechanic,Truck,Config.DriveSpeed,786603)
	end

	local Entities = { Truck,Mechanic }
	SetTimeout(Config.DespawnTime * 1000,function()
		for _,Entity in ipairs(Entities) do
			if Entity and DoesEntityExist(Entity) then
				SetEntityAsMissionEntity(Entity,true,true)
				DeleteEntity(Entity)
			end
		end
	end)

	Truck,Mechanic = nil,nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Mecanico:Check",function()
	local Vehicle = TargetVehicle()
	if not Vehicle then
		return TriggerServerEvent("Night_Mecanico:Checked",nil,"Fique dentro ou ao lado do veículo para chamar o mecânico.")
	end

	if GetVehicleEngineHealth(Vehicle) >= Config.EnginePercent * 10.0 then
		return TriggerServerEvent("Night_Mecanico:Checked",nil,"O motor deste veículo não precisa de reparo.")
	end

	TriggerServerEvent("Night_Mecanico:Checked",VehToNet(Vehicle))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYREPAIR: só o dono da entidade consegue alterar a vida do motor
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Mecanico:ApplyRepair",function(NetId,Engine)
	if not NetworkDoesNetworkIdExist(NetId) then
		return
	end

	local Vehicle = NetToVeh(NetId)
	if not DoesEntityExist(Vehicle) or not NetworkHasControlOfEntity(Vehicle) then
		return
	end

	if GetVehicleEngineHealth(Vehicle) < Engine then
		SetVehicleEngineHealth(Vehicle,Engine)
	end

	SetVehicleUndriveable(Vehicle,false)
	SetVehicleDoorShut(Vehicle,4,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Mecanico:Start",function(NetId)
	if Active then
		return
	end

	Active = true

	CreateThread(function()
		-- Espera o tempo de chegada
		local Arrival = GetGameTimer() + (Config.Delay * 1000)
		local Warned = false
		while GetGameTimer() < Arrival do
			if not Warned and Arrival - GetGameTimer() <= 60000 then
				Warned = true
				Notify("O mecânico chega em 1 minuto. Fique perto do veículo.")
			end

			Wait(1000)
		end

		if not NetworkDoesNetworkIdExist(NetId) then
			return Abort("O veículo não foi encontrado. O chamado foi cancelado.")
		end

		local Vehicle = NetToVeh(NetId)
		if not DoesEntityExist(Vehicle) then
			return Abort("Você está longe do veículo. O chamado foi cancelado.")
		end

		if GetVehicleEngineHealth(Vehicle) >= Config.EnginePercent * 10.0 then
			Notify("O motor já foi reparado. O chamado foi cancelado.")
			return Finish(false)
		end

		local TruckHash = LoadModel(Config.Vehicle)
		local MechanicHash = LoadModel(Config.Mechanic)
		if not TruckHash or not MechanicHash then
			return Abort("Não foi possível enviar o mecânico. Tente novamente.")
		end

		local SpawnCoords,SpawnHeading = FindSpawn(GetEntityCoords(Vehicle))
		if not SpawnCoords then
			return Abort("Nenhuma rua próxima para o guincho chegar até o veículo.")
		end

		Truck = CreateVehicle(TruckHash,SpawnCoords.x,SpawnCoords.y,SpawnCoords.z,SpawnHeading,true,false)
		Mechanic = CreatePedInsideVehicle(Truck,26,MechanicHash,-1,true,false)

		SetModelAsNoLongerNeeded(TruckHash)
		SetModelAsNoLongerNeeded(MechanicHash)

		if not DoesEntityExist(Truck) or not DoesEntityExist(Mechanic) then
			return Abort("Não foi possível enviar o mecânico. Tente novamente.")
		end

		SetEntityAsMissionEntity(Truck,true,true)
		SetEntityAsMissionEntity(Mechanic,true,true)

		SetBlockingOfNonTemporaryEvents(Mechanic,true)
		SetPedKeepTask(Mechanic,true)
		SetPedCanBeDraggedOut(Mechanic,false)
		SetEntityInvincible(Mechanic,true)
		SetPedFleeAttributes(Mechanic,0,false)

		SetVehicleOnGroundProperly(Truck)
		SetVehicleEngineOn(Truck,true,true,false)
		SetVehicleDoorsLocked(Truck,2)
		SetEntityInvincible(Truck,true)

		TriggerServerEvent("Night_Mecanico:Entities",{ VehToNet(Truck),PedToNet(Mechanic) })

		Blip = AddBlipForEntity(Truck)
		SetBlipSprite(Blip,Config.Blip.Sprite)
		SetBlipColour(Blip,Config.Blip.Color)
		SetBlipScale(Blip,Config.Blip.Scale)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blip.Name)
		EndTextCommandSetBlipName(Blip)

		Notify("O mecânico chegou na região e está indo até o veículo.","verde")

		-- Dirige até o veículo
		local Target = GetEntityCoords(Vehicle)
		TaskVehicleDriveToCoordLongrange(Mechanic,Truck,Target.x,Target.y,Target.z,Config.DriveSpeed,786603,12.0)

		local DriveTimeout = GetGameTimer() + (Config.DriveTimeout * 1000)
		while #(GetEntityCoords(Truck) - GetEntityCoords(Vehicle)) > 15.0 do
			if not DoesEntityExist(Vehicle) then
				Leave()
				Notify("O veículo saiu de perto. O chamado foi cancelado.")
				return Finish(false)
			end

			if not DoesEntityExist(Truck) or not DoesEntityExist(Mechanic) then
				return Abort("O guincho teve um problema no caminho. Use /"..Config.Command.." novamente.")
			end

			-- Travou ou demorou demais: posiciona o guincho na rua mais próxima do veículo
			if GetGameTimer() > DriveTimeout then
				local Coords = GetEntityCoords(Vehicle)
				local Found,Node,Heading = GetClosestVehicleNodeWithHeading(Coords.x,Coords.y,Coords.z,1,3.0,0)
				if not Found or #(Node - Coords) > 40.0 then
					Node,Heading = GetOffsetFromEntityInWorldCoords(Vehicle,0.0,-8.0,0.0),GetEntityHeading(Vehicle)
				end

				SetEntityCoords(Truck,Node.x,Node.y,Node.z,false,false,false,false)
				SetEntityHeading(Truck,Heading)
				SetVehicleOnGroundProperly(Truck)
				break
			end

			Wait(500)
		end

		-- Estaciona e desce
		TaskVehicleTempAction(Mechanic,Truck,27,3000)
		Wait(1500)
		TaskLeaveVehicle(Mechanic,Truck,0)
		Wait(2000)

		if not DoesEntityExist(Vehicle) then
			Leave()
			Notify("O veículo saiu de perto. O chamado foi cancelado.")
			return Finish(false)
		end

		-- Vai até a frente do veículo (capô)
		local Front = GetOffsetFromEntityInWorldCoords(Vehicle,0.0,2.6,0.0)
		TaskGoToCoordAnyMeans(Mechanic,Front.x,Front.y,Front.z,1.5,0,false,786603,0.0)

		local WalkTimeout = GetGameTimer() + 30000
		while #(GetEntityCoords(Mechanic) - GetOffsetFromEntityInWorldCoords(Vehicle,0.0,2.6,0.0)) > 1.2 do
			if not DoesEntityExist(Vehicle) then
				Leave()
				Notify("O veículo saiu de perto. O chamado foi cancelado.")
				return Finish(false)
			end

			if GetGameTimer() > WalkTimeout then
				local Spot = GetOffsetFromEntityInWorldCoords(Vehicle,0.0,2.6,0.0)
				SetEntityCoords(Mechanic,Spot.x,Spot.y,Spot.z,false,false,false,false)
				break
			end

			Wait(250)
		end

		ClearPedTasks(Mechanic)
		TaskTurnPedToFaceEntity(Mechanic,Vehicle,1500)
		Wait(1500)

		-- O controle de dano do creative desfaz reparos com o jogador dentro do veículo
		local Ped = PlayerPedId()
		if IsPedInVehicle(Ped,Vehicle,false) then
			Notify("Saia do veículo para o mecânico trabalhar.")
			TaskLeaveVehicle(Ped,Vehicle,0)

			local LeaveTimeout = GetGameTimer() + 5000
			while IsPedInVehicle(Ped,Vehicle,false) and GetGameTimer() < LeaveTimeout do
				Wait(250)
			end
		end

		-- Abre o capô e trabalha no motor
		SetVehicleDoorOpen(Vehicle,4,false,false)
		LoadDict("mini@repair")
		TaskPlayAnim(Mechanic,"mini@repair","fixing_a_ped",8.0,-8.0,-1,1,0,false,false,false)
		Notify("O mecânico está reparando o motor...","verde")

		local RepairAt = GetGameTimer() + (Config.RepairTime * 1000)
		while GetGameTimer() < RepairAt do
			if not DoesEntityExist(Vehicle) then
				Leave()
				Notify("O veículo saiu de perto. O chamado foi cancelado.")
				return Finish(false)
			end

			Wait(250)
		end

		ClearPedTasks(Mechanic)
		RemoveAnimDict("mini@repair")

		TriggerServerEvent("Night_Mecanico:Repair",NetId)
		Notify("Motor reparado em "..Config.EnginePercent.."%. Leve o veículo a uma oficina para o reparo completo.","verde")

		Wait(1000)
		Leave()
		Finish(true)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(Resource)
	if Resource == GetCurrentResourceName() then
		Cleanup()
	end
end)
