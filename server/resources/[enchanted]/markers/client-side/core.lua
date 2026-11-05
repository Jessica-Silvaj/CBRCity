-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("markers")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Markers = {}
local BlipTypes = {}
local Players = {}
local ParentOfs = {}
local Permissions = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARENTPAIRS
-----------------------------------------------------------------------------------------------------------------------------------------
if ParentGroups then
	for Index,List in pairs(ParentGroups) do
		for _,Permission in ipairs(List) do
			ParentOfs[Permission] = Index
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARENTS
-----------------------------------------------------------------------------------------------------------------------------------------
local function CheckParents(Permission)
	local Group = ParentOfs[Permission]
	if not Group or not ParentGroups or not ParentGroups[Group] then
		return false
	end

	for _,Index in ipairs(ParentGroups[Group]) do
		if Permissions[Index] then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAN SEE BLIP
-----------------------------------------------------------------------------------------------------------------------------------------
local function CanSeeBlip(targetPerm)
	if not targetPerm or not Groups or not Groups[targetPerm] then
		return false
	end

	if Permissions[targetPerm] then
		return true
	end

	if CheckParents(targetPerm) then
		return true
	end

	for myPerm in pairs(Permissions) do
		if Groups[myPerm] and Groups[myPerm].Permission and Groups[myPerm].Permission[targetPerm] then
			return true
		end
		if Groups[targetPerm] and Groups[targetPerm].Permission and Groups[targetPerm].Permission[myPerm] then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEMARKER
-----------------------------------------------------------------------------------------------------------------------------------------
local function RemoveMarker(Index)
	local Blip = Markers[Index]
	if Blip and DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end

	Markers[Index] = nil
	BlipTypes[Index] = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANMARKERS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanMarkers()
	for _,Blip in pairs(Markers) do
		if DoesBlipExist(Blip) then
			RemoveBlip(Blip)
		end
	end

	Markers = {}
	BlipTypes = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET PLAYER BLIP SPRITE AND STATUS
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetPlayerBlipSpriteAndStatus(Ped, targetServerId)
	local isDead = false

	if Ped and DoesEntityExist(Ped) then
		if IsEntityDead(Ped) or GetEntityHealth(Ped) <= 100 then
			isDead = true
		end
	end

	if targetServerId then
		local pState = Player(targetServerId).state
		if pState and (pState.Crawl or pState.Death) then
			isDead = true
		end
	end

	if isDead then
		return 84, true
	end

	if Ped and DoesEntityExist(Ped) then
		local paraState = GetPedParachuteState(Ped)
		if paraState >= 1 or IsPedInParachuteFreeFall(Ped) then
			return 94, false
		end

		if IsPedInAnyVehicle(Ped, false) then
			local veh = GetVehiclePedIsIn(Ped, false)
			local class = GetVehicleClass(veh)
			local siren = IsVehicleSirenOn(veh)

			if class == 15 then
				return 43, siren
			elseif class == 16 then
				return 423, siren
			elseif class == 14 then
				return 427, siren
			elseif class == 8 then
				return 226, siren
			elseif class == 13 then
				return 348, false
			else
				return 225, siren
			end
		end

		return 1, false
	end

	if targetServerId then
		local pState = Player(targetServerId).state
		if pState then
			local sprite = pState.BlipSprite or 1
			local siren = pState.BlipSiren or false
			return sprite, siren
		end
	end

	return 1, false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE OR UPDATE BLIP
-----------------------------------------------------------------------------------------------------------------------------------------
local function UpdatePlayerBlip(Index, Coords, Permission, Level, Ped)
	local myServerId = GetPlayerServerId(PlayerId())
	if Index == myServerId then
		RemoveMarker(Index)
		return false
	end

	if not CanSeeBlip(Permission) then
		RemoveMarker(Index)
		return false
	end

	local GroupData = Groups[Permission]
	if not GroupData then
		RemoveMarker(Index)
		return false
	end

	local isEntity = Ped and DoesEntityExist(Ped)
	local currentType = BlipTypes[Index]
	local Blip = Markers[Index]

	if Blip and DoesBlipExist(Blip) then
		if (isEntity and currentType ~= "entity") or (not isEntity and currentType ~= "coord") then
			RemoveBlip(Blip)
			Markers[Index] = nil
			BlipTypes[Index] = nil
			Blip = nil
		end
	end

	if not Blip or not DoesBlipExist(Blip) then
		if isEntity then
			Blip = AddBlipForEntity(Ped)
			BlipTypes[Index] = "entity"
		elseif Coords then
			Blip = AddBlipForCoord(Coords.x or Coords[1], Coords.y or Coords[2], Coords.z or Coords[3])
			BlipTypes[Index] = "coord"
		else
			return false
		end
		Markers[Index] = Blip
	else
		if not isEntity and Coords then
			SetBlipCoords(Blip, Coords.x or Coords[1], Coords.y or Coords[2], Coords.z or Coords[3])
		end
	end

	if not Blip or not DoesBlipExist(Blip) then
		Markers[Index] = nil
		BlipTypes[Index] = nil
		return false
	end

	local sprite, flashes = GetPlayerBlipSpriteAndStatus(Ped, Index)
	SetBlipSprite(Blip, sprite)
	SetBlipFlashes(Blip, flashes)

	SetBlipDisplay(Blip, 4)
	SetBlipAsShortRange(Blip, false)

	if sprite == 1 then
		SetBlipScale(Blip, 0.65)
	elseif sprite == 84 then
		SetBlipScale(Blip, 0.75)
	else
		SetBlipScale(Blip, 0.70)
	end

	ShowHeadingIndicatorOnBlip(Blip, true)

	if isEntity then
		SetBlipRotation(Blip, math.ceil(GetEntityHeading(Ped)))
	end

	local LevelName = GroupData.Hierarchy and GroupData.Hierarchy[Level] or "Membro"
	SetBlipColour(Blip, GroupData.Markers or 1)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("! "..Permission.." : "..LevelName)
	EndTextCommandSetBlipName(Blip)

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAL PLAYER ACTIVITY SYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1000)
		if LocalPlayer.state.Active and LocalPlayer.state.Markers then
			local ped = PlayerPedId()
			local sprite, flashes = GetPlayerBlipSpriteAndStatus(ped, GetPlayerServerId(PlayerId()))
			if LocalPlayer.state.BlipSprite ~= sprite then
				LocalPlayer.state:set("BlipSprite", sprite, true)
			end
			if LocalPlayer.state.BlipSiren ~= flashes then
				LocalPlayer.state:set("BlipSiren", flashes, true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REFRESH PERMISSIONS FROM LOCAL STATE
-----------------------------------------------------------------------------------------------------------------------------------------
local function RefreshMyPermissions()
	if not Groups then return end
	local hasAny = false
	for Perm, v in pairs(Groups) do
		if v.Markers or v.ServiceBlip then
			if LocalPlayer.state[Perm] then
				Permissions[Perm] = true
				hasAny = true
			else
				Permissions[Perm] = nil
			end
		end
	end

	if not hasAny then
		CleanMarkers()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATEBAG CHANGE LISTENER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Wait(500)
	end

	local myServerId = GetPlayerServerId(PlayerId())
	AddStateBagChangeHandler(nil, ("player:%s"):format(myServerId), function(bagName, key, value)
		if key == "Markers" then
			if not value then
				CleanMarkers()
			else
				RefreshMyPermissions()
			end
		elseif Groups and Groups[key] and (Groups[key].Markers or Groups[key].ServiceBlip) then
			if value then
				Permissions[key] = true
			else
				Permissions[key] = nil
				RefreshMyPermissions()
			end
		end
	end)

	RefreshMyPermissions()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS:SYNCCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("markers:SyncCoords")
AddEventHandler("markers:SyncCoords", function(CoordsData)
	if not LocalPlayer.state.Active or not LocalPlayer.state.Markers or not next(Permissions) then
		if next(Markers) then
			CleanMarkers()
		end
		return
	end

	local myServerId = GetPlayerServerId(PlayerId())
	local currentIndices = {}
	for Index, data in pairs(CoordsData) do
		currentIndices[Index] = true
		if Index == myServerId then
			UpdatePlayerBlip(Index, nil, data.Permission, data.Level, PlayerPedId())
		else
			local targetPlayer = GetPlayerFromServerId(Index)
			local targetPed = (targetPlayer ~= -1 and NetworkIsPlayerConnected(targetPlayer)) and GetPlayerPed(targetPlayer) or nil

			if targetPed and DoesEntityExist(targetPed) then
				UpdatePlayerBlip(Index, nil, data.Permission, data.Level, targetPed)
			else
				UpdatePlayerBlip(Index, data.Coords, data.Permission, data.Level, nil)
			end
		end
	end

	for Index in pairs(Markers) do
		if not currentIndices[Index] then
			RemoveMarker(Index)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("markers:Add")
AddEventHandler("markers:Add",function(Source,Data)
	if Source and Data then
		Players[Source] = Data
		local myServerId = GetPlayerServerId(PlayerId())
		if Source == myServerId then
			RefreshMyPermissions()
			UpdatePlayerBlip(Source, nil, Data.Permission, Data.Level, PlayerPedId())
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS:FULL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("markers:Full")
AddEventHandler("markers:Full",function(Data)
	Players = Data or {}
	RefreshMyPermissions()
	local myServerId = GetPlayerServerId(PlayerId())
	if Players[myServerId] then
		UpdatePlayerBlip(myServerId, nil, Players[myServerId].Permission, Players[myServerId].Level, PlayerPedId())
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("markers:Remove")
AddEventHandler("markers:Remove",function(Source)
	local myServerId = GetPlayerServerId(PlayerId())
	if Source == myServerId then
		CleanMarkers()
	else
		Players[Source] = nil
		RemoveMarker(Source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESOURCE STOP CLEANUP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		CleanMarkers()
	end
end)