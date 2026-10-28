-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("admin",Creative)
vSERVER = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Debug = false
local Actived = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.teleportWay()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		Ped = GetVehiclePedIsUsing(Ped)
	end

	local Waypoint = GetFirstBlipInfoId(8)
	if not DoesBlipExist(Waypoint) then
		return false
	end

	local Coords = GetBlipCoords(Waypoint)
	for Height = 1,1000 do
		SetEntityCoordsNoOffset(Ped,Coords.x,Coords.y,Height + 0.0,true,false,false)

		RequestCollisionAtCoord(Coords.x,Coords.y,Coords.z)
		while not HasCollisionLoadedAroundEntity(Ped) do
			Wait(1)
		end

		local Found,GroundZ = GetGroundZFor_3dCoord(Coords.x,Coords.y,Height + 0.0)
		if Found then
			SetEntityCoordsNoOffset(Ped,Coords.x,Coords.y,GroundZ + 1.0,true,false,false)
			break
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:Tuning",function()
	local Ped = PlayerPedId()
	if not IsPedInAnyVehicle(Ped) then
		return false
	end

	local Vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleModKit(Vehicle,0)
	ToggleVehicleMod(Vehicle,18,true)

	for _,Mod in ipairs({ 11,12,13,15 }) do
		SetVehicleMod(Vehicle,Mod,GetNumVehicleMods(Vehicle,Mod) - 1,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			vSERVER.buttonTxt()
-- 		end
-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Markers = {}
local DefaultLeft = 2.0
local ConfigRace = false
local DefaultRight = -2.0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGRACE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("configrace",function(_,Message)
	if not LocalPlayer.state.Admin then
		return false
	end

	for _,v in pairs(Markers) do
		if DoesBlipExist(v.Blip) then
			RemoveBlip(v.Blip)
		end
	end

	local RaceName = Message[1] or "nulled"
	DefaultLeft, DefaultRight = 2.0, -2.0
	ConfigRace = not ConfigRace
	Markers = {}

	while ConfigRace do
		Wait(1)

		local Ped = PlayerPedId()
		local Vehicle = GetVehiclePedIsUsing(Ped)
		if not Vehicle or not DoesEntityExist(Vehicle) then
			ConfigRace = false
			break
		end

		local Center = GetOffsetFromEntityInWorldCoords(Vehicle,0.0,5.0,0.0)
		local Left = GetOffsetFromEntityInWorldCoords(Vehicle,DefaultLeft,5.0,0.0)
		local Right = GetOffsetFromEntityInWorldCoords(Vehicle,DefaultRight,5.0,0.0)

		if IsDisabledControlPressed(1,10) then
			DefaultLeft += 0.1
			DefaultRight -= 0.1
		elseif IsDisabledControlPressed(1,11) then
			DefaultLeft -= 0.1
			DefaultRight += 0.1
		end

		DefaultLeft = math.max(DefaultLeft,2.0)
		DefaultRight = math.min(DefaultRight,-2.0)

		if IsControlJustPressed(1,38) then
			local Number = #Markers + 1
			vSERVER.RaceConfig(Left,Center,Right,DefaultLeft * 0.8,RaceName)

			local Blip = AddBlipForCoord(Center.x,Center.y,Center.z)
			SetBlipSprite(Blip,1)
			SetBlipColour(Blip,2)
			SetBlipScale(Blip,0.85)
			ShowNumberOnBlip(Blip,Number)
			SetBlipAsShortRange(Blip,true)

			Markers[Number] = { Left = Left, Right = Right, Blip = Blip }
		end

		DrawMarker(1,Left.x,Left.y,Left.z - 100,0,0,0,0,0,0,1.75,1.75,200.0,255,255,255,175,false,false,0,false)
		DrawMarker(1,Right.x,Right.y,Right.z - 100,0,0,0,0,0,0,1.75,1.75,200.0,255,255,255,175,false,false,0,false)
		DrawMarker(1,Center.x,Center.y,Center.z - 100,0,0,0,0,0,0,0.75,0.75,200.0,255,255,255,25,false,false,0,false)

		for _,v in pairs(Markers) do
			DrawMarker(1,v.Left.x,v.Left.y,v.Left.z - 100,0,0,0,0,0,0,1.75,1.75,200.0,0,255,0,100,false,false,0,false)
			DrawMarker(1,v.Right.x,v.Right.y,v.Right.z - 100,0,0,0,0,0,0,1.75,1.75,200.0,0,255,0,100,false,false,0,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:INITSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:initSpectate",function(OtherSource)
	if NetworkIsInSpectatorMode() then
		return false
	end

	local TargetPlayer = GetPlayerFromServerId(OtherSource)
	if TargetPlayer == -1 then
		return false
	end

	local TargetPed = GetPlayerPed(TargetPlayer)
	LocalPlayer.state:set("Spectate",true,false)
	NetworkSetInSpectatorMode(true,TargetPed)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:resetSpectate",function()
	if not NetworkIsInSpectatorMode() then
		return false
	end

	NetworkSetInSpectatorMode(false)
	LocalPlayer.state:set("Spectate",false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Quake",nil,function(Name,Key,Value)
	ShakeGameplayCam("SKY_DIVING_SHAKE",1.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Limparea(Coords)
	local Radius = 100.0
	local x,y,z = Coords.x,Coords.y,Coords.z

	ClearAreaOfPeds(x,y,z,Radius,0)
	ClearAreaOfCops(x,y,z,Radius,0)
	ClearAreaOfObjects(x,y,z,Radius,0)
	ClearAreaOfProjectiles(x,y,z,Radius,0)
	ClearArea(x,y,z,Radius,true,false,false,false)
	ClearAreaOfVehicles(x,y,z,Radius,false,false,false,false,false)
	ClearAreaLeaveVehicleHealth(x,y,z,Radius,false,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEDEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:ToggleDebug")
AddEventHandler("admin:ToggleDebug",function()
	Debug = not Debug

	if Debug then
		Creative.EnableDebug()
	end

	if Actived then
		Actived = false
	else
		Actived = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetVehicle()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstVehicle()
	local success
	local rped = nil
	local distanceFrom

	repeat
		local pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		if Creative.canPedBeUsed(ped) and distance < 3.0 and (distanceFrom == nil or distance < distanceFrom) then
			distanceFrom = distance
			rped = ped

			if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
				Creative.DebugDrawText3D(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
			else
				Creative.DebugDrawText3D(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
			end
		end

		success, ped = FindNextVehicle(handle)
	until not success

	EndFindVehicle(handle)

	return rped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetObject()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstObject()
	local success
	local rped = nil
	local distanceFrom

	repeat
		local pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		if distance < 15.0 then
			distanceFrom = distance
			rped = ped

			if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
				Creative.DebugDrawText3D(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
			else
				Creative.DebugDrawText3D(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
			end
		end

		success, ped = FindNextObject(handle)
	until not success

	EndFindObject(handle)

	return rped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNPC
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetNPC()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstPed()
	local success
	local rped = nil
	local distanceFrom

	repeat
		local pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		if Creative.canPedBeUsed(ped) and distance < 3.0 and (distanceFrom == nil or distance < distanceFrom) then
			distanceFrom = distance
			rped = ped

			if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
				Creative.DebugDrawText3D(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
			else
				Creative.DebugDrawText3D(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
			end
		end

		success, ped = FindNextPed(handle)
	until not success

	EndFindPed(handle)

	return rped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANPEDBEUSED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.canPedBeUsed(ped)
	if ped == nil then
		return false
	end

	if ped == GetPlayerPed(-1) then
		return false
	end

	if not DoesEntityExist(ped) then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENABLEDEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.EnableDebug()
	CreateThread(function()
		while true do
			Wait(1)

			if Debug then
				local Pos = GetEntityCoords(GetPlayerPed(-1))
				local ForPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0.0)
				local BackPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -1.0, 0.0)
				local LPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, 0.0)
				local RPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -1.0, 0.0, 0.0) 
				local ForPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0.0)
				local BackPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -2.0, 0.0)
				local LPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 2.0, 0.0, 0.0)
				local RPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -2.0, 0.0, 0.0)    
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
				currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

				Creative.DebugDrawText2D(0.20,0.70,0.4,0.4,0.30, "~w~Heading: ~g~" .. GetEntityHeading(GetPlayerPed(-1)),55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.72,0.4,0.4,0.30, "~w~Coords: ~g~" .. Pos,55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.74,0.4,0.4,0.30, "~w~Attached Ent: ~g~" .. GetEntityAttachedTo(GetPlayerPed(-1)),55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.76,0.4,0.4,0.30, "~w~Health: ~g~" .. GetEntityHealth(GetPlayerPed(-1)),55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.78,0.4,0.4,0.30, "~w~H a G: ~g~" .. GetEntityHeightAboveGround(GetPlayerPed(-1)),55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.80,0.4,0.4,0.30, "~w~Model: ~g~" .. GetEntityModel(GetPlayerPed(-1)),55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.82,0.4,0.4,0.30, "~w~Speed: ~g~" .. GetEntitySpeed(GetPlayerPed(-1)),55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.84,0.4,0.4,0.30, "~w~Frame Time: ~g~" .. GetFrameTime(),55,155,55,255)
				Creative.DebugDrawText2D(0.20,0.86,0.4,0.4,0.30, "~w~Street: ~g~" .. currentStreetName,55,155,55,255)

				local nearped = Creative.GetNPC()
				local veh = Creative.GetVehicle()
				local nearobj = Creative.GetObject()
			else
				Wait(5000)
			end
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGDRAWTEXT2D
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DebugDrawText2D(x,y,width,height,scale,text,r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.30,0.30)
	SetTextColour(r,g,b,a)
	SetTextDropShadow(0,0,0,0,255)
	SetTextEdge(1,0,0,0,255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x-width/2,y-height/2+0.005)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGDRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DebugDrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,0,0,0,150)
	end
end