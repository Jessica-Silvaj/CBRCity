-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS DA CIDADE (painel gestor)
-----------------------------------------------------------------------------------------------------------------------------------------
local Props = {}
local Spawned = {}
local Placing = false
local Editing = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN / DESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadModel(Hash)
	if not IsModelInCdimage(Hash) then
		return false
	end

	RequestModel(Hash)
	local Timeout = GetGameTimer() + 5000
	while not HasModelLoaded(Hash) and GetGameTimer() < Timeout do
		Wait(10)
	end

	return HasModelLoaded(Hash)
end

local function Despawn(Id)
	if Spawned[Id] then
		if DoesEntityExist(Spawned[Id]) then
			DeleteEntity(Spawned[Id])
		end
		Spawned[Id] = nil
	end
end

local function Spawn(Prop)
	local Hash = GetHashKey(Prop.Model)
	if not LoadModel(Hash) then
		return
	end

	local Object = CreateObjectNoOffset(Hash,Prop.X,Prop.Y,Prop.Z,false,false,false)
	SetEntityHeading(Object,Prop.H)
	FreezeEntityPosition(Object,true)
	SetEntityCollision(Object,Prop.Collision,Prop.Collision)
	SetEntityInvincible(Object,true)
	SetModelAsNoLongerNeeded(Hash)

	Spawned[Prop.id] = Object
end

RegisterNetEvent("Night_Management:propsSync")
AddEventHandler("Night_Management:propsSync",function(List)
	for Id in pairs(Spawned) do
		Despawn(Id)
	end

	Props = {}
	for _,Prop in ipairs(List or {}) do
		Props[Prop.id] = Prop
	end
end)

-- Outros recursos (ex.: blackjack) leem os props colocados pelo painel
exports("PropList",function()
	local List = {}
	for _,Prop in pairs(Props) do
		List[#List + 1] = Prop
	end
	return List
end)

CreateThread(function()
	TriggerServerEvent("Night_Management:propsLoad")

	while true do
		local Coords = GetEntityCoords(PlayerPedId())

		for Id,Prop in pairs(Props) do
			local Near = #(Coords - vector3(Prop.X,Prop.Y,Prop.Z)) <= Prop.Distance
			if Near and not Spawned[Id] and Id ~= Editing then
				Spawn(Prop)
			elseif not Near and Spawned[Id] then
				Despawn(Id)
			end
		end

		Wait(1000)
	end
end)

AddEventHandler("onResourceStop",function(Resource)
	if Resource == GetCurrentResourceName() then
		for Id in pairs(Spawned) do
			Despawn(Id)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POSICIONAMENTO NO JOGO
-----------------------------------------------------------------------------------------------------------------------------------------
local function RotationToDirection(Rotation)
	local X,Z = math.rad(Rotation.x),math.rad(Rotation.z)
	return vector3(-math.sin(Z) * math.abs(math.cos(X)),math.cos(Z) * math.abs(math.cos(X)),math.sin(X))
end

local function CameraRaycast(Ignore)
	local Origin = GetGameplayCamCoord()
	local Target = Origin + RotationToDirection(GetGameplayCamRot(2)) * 30.0
	local Ray = StartExpensiveSynchronousShapeTestLosProbe(Origin.x,Origin.y,Origin.z,Target.x,Target.y,Target.z,1 | 16,Ignore,4)
	local _,Hit,Coords = GetShapeTestResult(Ray)

	return Hit == 1 and Coords or nil
end

local function HelpText()
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName("Mire com a câmera~n~~INPUT_WEAPON_WHEEL_NEXT~ Girar~n~")
	AddTextComponentSubstringPlayerName("~INPUT_SCRIPTED_FLY_ZUP~ / ~INPUT_SCRIPTED_FLY_ZDOWN~ Subir / descer~n~")
	AddTextComponentSubstringPlayerName("~INPUT_CONTEXT~ Confirmar~n~~INPUT_FRONTEND_RRIGHT~ / ~INPUT_AIM~ Cancelar")
	EndTextCommandDisplayHelp(0,false,false,-1)
end

local function StartPlacement(Data)
	if Placing then
		return
	end

	local Model = tostring(Data.model or "")
	local Hash = GetHashKey(Model)
	if not LoadModel(Hash) then
		TriggerEvent("Notify","Erro","Modelo <b>"..Model.."</b> não encontrado.","vermelho",5000)
		return
	end

	Placing = true

	local Ped = PlayerPedId()
	local Start = Data.id and Props[tonumber(Data.id)]
	local Heading = Start and Start.H or GetEntityHeading(Ped)
	local Height = 0.0

	if Start then
		Editing = Start.id
		Despawn(Start.id)
	end

	local Ghost = CreateObjectNoOffset(Hash,GetEntityCoords(Ped),false,false,false)
	SetEntityAlpha(Ghost,180,false)
	SetEntityCollision(Ghost,false,false)
	FreezeEntityPosition(Ghost,true)
	SetModelAsNoLongerNeeded(Hash)

	local Position = Start and vector3(Start.X,Start.Y,Start.Z) or GetEntityCoords(Ped)
	local Confirmed = false

	while Placing do
		HelpText()

		DisableControlAction(0,24,true)
		DisableControlAction(0,25,true)
		DisableControlAction(0,140,true)
		DisableControlAction(0,141,true)
		DisableControlAction(0,142,true)
		DisableControlAction(0,14,true)
		DisableControlAction(0,15,true)
		DisableControlAction(0,16,true)
		DisableControlAction(0,17,true)
		DisableControlAction(0,37,true)

		local Hit = CameraRaycast(Ghost)
		if Hit then
			Position = Hit
		end

		if IsDisabledControlPressed(0,15) or IsDisabledControlJustPressed(0,15) then
			Heading = (Heading + 5.0) % 360.0
		elseif IsDisabledControlPressed(0,14) or IsDisabledControlJustPressed(0,14) then
			Heading = (Heading - 5.0) % 360.0
		end

		if IsControlPressed(0,10) then
			Height = Height + 0.01
		elseif IsControlPressed(0,11) then
			Height = Height - 0.01
		end

		SetEntityCoordsNoOffset(Ghost,Position.x,Position.y,Position.z + Height,false,false,false)
		SetEntityHeading(Ghost,Heading)

		if IsControlJustPressed(0,38) then
			Confirmed = true
			Placing = false
		elseif IsControlJustPressed(0,194) or IsDisabledControlJustPressed(0,25) then
			Placing = false
		end

		Wait(0)
	end

	local Final = GetEntityCoords(Ghost)
	DeleteEntity(Ghost)
	ClearAllHelpMessages()
	Editing = nil

	if Confirmed then
		TriggerServerEvent("Night_Management:saveProp",{
			id = Data.id,
			name = Data.name,
			model = Model,
			x = Final.x, y = Final.y, z = Final.z, h = Heading,
			distance = Data.distance,
			collision = Data.collision
		})
	else
		TriggerEvent("Notify","Aviso","Posicionamento cancelado.","amarelo",5000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestProps",function(Data,Callback)
	TriggerServerEvent("Night_Management:requestProps")
	Callback("ok")
end)

RegisterNetEvent("Night_Management:updateProps")
AddEventHandler("Night_Management:updateProps",function(List)
	SendNUIMessage({ action = "updateProps", props = List })
end)

-- O painel já foi fechado pelo callback "close" antes deste
RegisterNUICallback("placeProp",function(Data,Callback)
	CreateThread(function() StartPlacement(Data) end)
	Callback("ok")
end)

RegisterNUICallback("deleteProp",function(Data,Callback)
	TriggerServerEvent("Night_Management:deleteProp",Data.id)
	Callback("ok")
end)
