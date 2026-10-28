-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS DA CIDADE (painel gestor)
-----------------------------------------------------------------------------------------------------------------------------------------
local Props = {}
local Spawned = {}
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
-- POSICIONAMENTO NO JOGO (mesma mecânica de mobiliar a casa: vRP.ObjectControlling, chamada pelo servidor)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Esconde o prop original enquanto ele está sendo reposicionado
RegisterNetEvent("Night_Management:propsEditing")
AddEventHandler("Night_Management:propsEditing",function(Id)
	Editing = Id
	if Id then
		Despawn(Id)
	end
end)
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
	local Model = tostring(Data.model or "")
	if not IsModelInCdimage(GetHashKey(Model)) then
		TriggerEvent("Notify","Erro","Modelo <b>"..Model.."</b> não encontrado.","vermelho",5000)
	else
		TriggerServerEvent("Night_Management:placeProp",Data)
	end

	Callback("ok")
end)

RegisterNUICallback("deleteProp",function(Data,Callback)
	TriggerServerEvent("Night_Management:deleteProp",Data.id)
	Callback("ok")
end)
