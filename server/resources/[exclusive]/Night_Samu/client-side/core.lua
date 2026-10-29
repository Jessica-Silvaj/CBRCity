-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = false
local Vehicle,Driver,Medic,Blip = nil,nil,nil,nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(Message,Color)
	TriggerEvent("Notify","SAMU",Message,Color or "amarelo",5000)
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

-- O jogador continua desmaiado e o atendimento não foi cancelado?
local function StillDown()
	return Active and LocalPlayer.state.Death
end

-- Ponto de rua a ~SpawnDistance metros do jogador
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

	if not Best then
		local Found,Node,Heading = GetClosestVehicleNodeWithHeading(Coords.x + Config.SpawnDistance,Coords.y,Coords.z,1,3.0,0)
		if Found then
			Best,BestHeading = Node,Heading
		end
	end

	return Best,BestHeading
end

local function Cleanup()
	if Blip and DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end

	for _,Entity in ipairs({ Medic,Driver,Vehicle }) do
		if Entity and DoesEntityExist(Entity) then
			SetEntityAsMissionEntity(Entity,true,true)
			DeleteEntity(Entity)
		end
	end

	Vehicle,Driver,Medic,Blip = nil,nil,nil,nil
end

local function Finish(Revived)
	Active = false
	TriggerServerEvent("Night_Samu:Finish",Revived)
end

local function Abort(Message)
	if Message then
		Notify(Message)
	end

	Cleanup()
	Finish(false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVE: socorrista volta, ambulância vai embora e some
-----------------------------------------------------------------------------------------------------------------------------------------
local function Leave()
	if Blip and DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end

	if Medic and DoesEntityExist(Medic) and Vehicle and DoesEntityExist(Vehicle) then
		TaskEnterVehicle(Medic,Vehicle,10000,0,2.0,1,0)

		local Timeout = GetGameTimer() + 10000
		while not IsPedInVehicle(Medic,Vehicle,false) and GetGameTimer() < Timeout do
			Wait(250)
		end
	end

	if Driver and DoesEntityExist(Driver) and Vehicle and DoesEntityExist(Vehicle) then
		SetVehicleSiren(Vehicle,false)
		TaskVehicleDriveWander(Driver,Vehicle,Config.DriveSpeed,786603)
	end

	local Entities = { Vehicle,Driver,Medic }
	SetTimeout(Config.DespawnTime * 1000,function()
		for _,Entity in ipairs(Entities) do
			if Entity and DoesEntityExist(Entity) then
				SetEntityAsMissionEntity(Entity,true,true)
				DeleteEntity(Entity)
			end
		end
	end)

	Vehicle,Driver,Medic = nil,nil,nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Samu:Start",function()
	if Active then
		return
	end

	Active = true

	CreateThread(function()
		-- Espera o tempo de chegada
		local Arrival = GetGameTimer() + (Config.Delay * 1000)
		while GetGameTimer() < Arrival do
			if not StillDown() then
				return Abort("Atendimento do SAMU cancelado: você já foi socorrido.")
			end

			Wait(500)
		end

		local VehicleHash = LoadModel(Config.Vehicle)
		local DriverHash = LoadModel(Config.Driver)
		local MedicHash = LoadModel(Config.Medic)
		if not VehicleHash or not DriverHash or not MedicHash then
			return Abort("Não foi possível enviar a ambulância. Tente novamente.")
		end

		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local SpawnCoords,SpawnHeading = FindSpawn(Coords)
		if not SpawnCoords then
			return Abort("Nenhuma rua próxima para a ambulância chegar até você.")
		end

		Vehicle = CreateVehicle(VehicleHash,SpawnCoords.x,SpawnCoords.y,SpawnCoords.z,SpawnHeading,true,false)
		Driver = CreatePedInsideVehicle(Vehicle,26,DriverHash,-1,true,false)
		Medic = CreatePedInsideVehicle(Vehicle,26,MedicHash,0,true,false)

		SetModelAsNoLongerNeeded(VehicleHash)
		SetModelAsNoLongerNeeded(DriverHash)
		SetModelAsNoLongerNeeded(MedicHash)

		if not DoesEntityExist(Vehicle) or not DoesEntityExist(Driver) or not DoesEntityExist(Medic) then
			return Abort("Não foi possível enviar a ambulância. Tente novamente.")
		end

		for _,Entity in ipairs({ Vehicle,Driver,Medic }) do
			SetEntityAsMissionEntity(Entity,true,true)
		end

		for _,Npc in ipairs({ Driver,Medic }) do
			SetBlockingOfNonTemporaryEvents(Npc,true)
			SetPedKeepTask(Npc,true)
			SetPedCanBeDraggedOut(Npc,false)
			SetEntityInvincible(Npc,true)
			SetPedFleeAttributes(Npc,0,false)
		end

		SetVehicleOnGroundProperly(Vehicle)
		SetVehicleEngineOn(Vehicle,true,true,false)
		SetVehicleSiren(Vehicle,true)
		SetVehicleDoorsLocked(Vehicle,2)
		SetEntityInvincible(Vehicle,true)

		TriggerServerEvent("Night_Samu:Entities",{ VehToNet(Vehicle),PedToNet(Driver),PedToNet(Medic) })

		Blip = AddBlipForEntity(Vehicle)
		SetBlipSprite(Blip,Config.Blip.Sprite)
		SetBlipColour(Blip,Config.Blip.Color)
		SetBlipScale(Blip,Config.Blip.Scale)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blip.Name)
		EndTextCommandSetBlipName(Blip)

		Notify("A ambulância está a caminho.","verde")

		-- Dirige até o jogador
		TaskVehicleDriveToCoordLongrange(Driver,Vehicle,Coords.x,Coords.y,Coords.z,Config.DriveSpeed,786603,12.0)

		local DriveTimeout = GetGameTimer() + (Config.DriveTimeout * 1000)
		while #(GetEntityCoords(Vehicle) - GetEntityCoords(PlayerPedId())) > 15.0 do
			if not StillDown() then
				Leave()
				return Finish(false)
			end

			if not DoesEntityExist(Vehicle) or not DoesEntityExist(Driver) or not DoesEntityExist(Medic) then
				return Abort("A ambulância teve um problema no caminho. Use /"..Config.Command.." novamente.")
			end

			-- Travou ou demorou demais: posiciona a ambulância na rua mais próxima do jogador
			if GetGameTimer() > DriveTimeout then
				local Target = GetEntityCoords(PlayerPedId())
				local Found,Node,Heading = GetClosestVehicleNodeWithHeading(Target.x,Target.y,Target.z,1,3.0,0)
				if not Found or #(Node - Target) > 40.0 then
					Node,Heading = Target + vec3(4.0,4.0,0.0),0.0
				end

				SetEntityCoords(Vehicle,Node.x,Node.y,Node.z,false,false,false,false)
				SetEntityHeading(Vehicle,Heading)
				SetVehicleOnGroundProperly(Vehicle)
				break
			end

			Wait(500)
		end

		-- Estaciona e o socorrista desce
		TaskVehicleTempAction(Driver,Vehicle,27,3000)
		Wait(1500)

		if not StillDown() then
			Leave()
			return Finish(false)
		end

		SetVehicleDoorsLocked(Vehicle,1)
		TaskLeaveVehicle(Medic,Vehicle,0)
		Wait(2000)

		-- Socorrista vai até o jogador
		local Target = GetEntityCoords(PlayerPedId())
		TaskGoToCoordAnyMeans(Medic,Target.x,Target.y,Target.z,2.0,0,false,786603,0.0)

		local WalkTimeout = GetGameTimer() + 30000
		while #(GetEntityCoords(Medic) - GetEntityCoords(PlayerPedId())) > 1.8 do
			if not StillDown() then
				Leave()
				return Finish(false)
			end

			if GetGameTimer() > WalkTimeout then
				local Behind = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,-1.2,0.0)
				SetEntityCoords(Medic,Behind.x,Behind.y,Behind.z,false,false,false,false)
				break
			end

			Wait(250)
		end

		ClearPedTasks(Medic)
		TaskTurnPedToFaceEntity(Medic,PlayerPedId(),1500)
		Wait(1500)

		-- Massagem cardíaca
		LoadDict("mini@cpr@char_a@cpr_str")
		TaskPlayAnim(Medic,"mini@cpr@char_a@cpr_str","cpr_pumpchest",8.0,-8.0,-1,1,0,false,false,false)
		Notify("O socorrista está te reanimando...","verde")

		local ReviveAt = GetGameTimer() + (Config.ReviveTime * 1000)
		while GetGameTimer() < ReviveAt do
			if not StillDown() then
				ClearPedTasks(Medic)
				Leave()
				return Finish(false)
			end

			Wait(250)
		end

		ClearPedTasks(Medic)
		RemoveAnimDict("mini@cpr@char_a@cpr_str")

		-- Reanima com a porcentagem de vida configurada (100 = morto, 200 = cheia)
		exports.survival:Revive(100 + math.floor(Config.HealthPercent))
		Notify("Você foi reanimado pelo SAMU. Procure um hospital para se recuperar.","verde")

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
