-- Reserva: se o vRP ainda estiver com o Global.lua antigo (sem DrawGroundMarker), desenha o anel aqui mesmo
if not DrawGroundMarker then
	function DrawGroundMarker(x,y,z,Size)
		local Color = MarkerColor or { 46, 139, 87, 170 }
		Size = Size or 1.2
		DrawMarker(25,x,y,z - 0.97,0.0,0.0,0.0,0.0,0.0,0.0,Size,Size,1.0,Color[1],Color[2],Color[3],Color[4],false,false,2,false,nil,nil,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("pdm")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Lasted = ""
local Camera = nil
local Selected = 1
local Preview = nil
local Vehicles = exports.vrp:VehicleList()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
local function InitializePDMs(pdms)
	Config = {}
	for _, pdmData in ipairs(pdms) do
		local Index = pdmData.Name
		
		local classes = {}
		if pdmData.Classes then
			local decodedClasses = json.decode(pdmData.Classes)
			if decodedClasses then
				for _, class in ipairs(decodedClasses) do
					classes[class] = true
				end
			end
		end

		local getVec4 = function(jsonStr, fallbackX, fallbackY, fallbackZ)
			if jsonStr then
				local parsed = json.decode(jsonStr)
				if parsed and #parsed >= 4 then
					return vec4(parsed[1], parsed[2], parsed[3], parsed[4])
				end
			end
			return vec4(fallbackX, fallbackY, fallbackZ, 0.0)
		end

		local spawnVec = getVec4(pdmData.Spawn, pdmData.X, pdmData.Y, pdmData.Z)
		local camVec = getVec4(pdmData.Cam, pdmData.X, pdmData.Y, pdmData.Z + 5.0)
		local driveInVec = getVec4(pdmData.DriveIn, pdmData.X, pdmData.Y, pdmData.Z)
		local driveOutVec = getVec4(pdmData.DriveOut, pdmData.X, pdmData.Y, pdmData.Z)

		Config[Index] = {
			List = {},
			Coords = vec3(pdmData.X, pdmData.Y, pdmData.Z),
			Cam = camVec,
			Spawn = spawnVec,
			DriveIn = driveInVec,
			DriveOut = driveOutVec,
			Classes = classes,
			Logo = pdmData.Logo
		}

		exports.target:AddCircleZone("PDM:"..Index,Config[Index].Coords,1.25,{
			name = "PDM:"..Index,
			heading = 0.0,
			useZ = true
		},{
			shop = Index,
			Distance = 1.25,
			options = {
				{ event = "pdm:Open", label = "Abrir", tunnel = "client", shop = Index }
			}
		})

		if next(classes) then
			for Model,Vehicle in pairs(Vehicles) do
				if (Vehicle.Class and classes[Vehicle.Class]) or classes[Model] then
					Config[Index].List[Model] = Vehicle
				end
			end
		else
			Config[Index].List = Vehicles
		end
	end
end

CreateThread(function()
	local pdms = vSERVER.RequestPDMs()
	if pdms then
		InitializePDMs(pdms)
	end
end)

RegisterNetEvent("pdm:reloadDynamicPdms")
AddEventHandler("pdm:reloadDynamicPdms", function()
	local pdms = vSERVER.RequestPDMs()
	if pdms then
		for Index, _ in pairs(Config) do
			exports.target:RemCircleZone("PDM:"..Index)
		end
		InitializePDMs(pdms)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS E TECLA E
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	RequestStreamedTextureDict("textures", true)
	while not HasStreamedTextureDictLoaded("textures") do
		Wait(1)
	end

	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			for Index, v in pairs(Config) do
				local Distance = #(Coords - v.Coords)
				if Distance <= 15.0 then
					TimeDistance = 1
					DrawGroundMarker(v.Coords.x,v.Coords.y,v.Coords.z,1.2)

					if Distance <= 1.25 and IsControlJustPressed(1, 38) and not exports.hud:Wanted() then
						TriggerEvent("pdm:Open", Index)
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Close()
	if DoesEntityExist(Preview) then
		DeleteEntity(Preview)
		Preview = nil
	end

	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	Lasted = ""
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	TriggerEvent("hud:Active",true)
	SendNUIMessage({ Action = "Close" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAMERAACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function CameraActive()
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamRot(Camera,0.0,0.0,Config[Selected].Cam.w)
	SetCamCoord(Camera,Config[Selected].Cam.xyz)
	RenderScriptCams(true,false,0,false,false)
	SetCamActive(Camera,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PDM:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("pdm:Open",function(Number)
	if DoesEntityExist(Preview) then
		DeleteEntity(Preview)
		Preview = nil
	end

	if not LocalPlayer.state.Buttons and not LocalPlayer.state.Commands and not exports.hud:Wanted() then
		if type(Number) == "table" and Number.shop then
			Selected = Number.shop
		elseif type(Number) == "table" and Number[1] then
			Selected = Number[1]
		else
			Selected = Number
		end

		if not Selected or not Config[Selected] then return end

		CameraActive()
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		TriggerEvent("hud:Active",false)
		SendNUIMessage({ Action = "Open", Payload = { Vehicles = Config[Selected].List, Discounts = vSERVER.Discount(), Tax = 0.25, TaxTime = "MENSAL", Logo = Config[Selected].Logo } })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	Close()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Model = Data.Vehicle
	if LoadModel(Model) and Lasted ~= Model then
		if DoesEntityExist(Preview) then
			DeleteEntity(Preview)
			Preview = nil
		end

		Preview = CreateVehicle(Model,Config[Selected].Spawn,false,false)
		SetVehicleCustomSecondaryColour(Preview,255,255,255)
		SetVehicleCustomPrimaryColour(Preview,255,255,255)
		SetVehicleNumberPlateText(Preview,"PDMSPORT")
		SetEntityCollision(Preview,false,false)
		FreezeEntityPosition(Preview,true)
		SetEntityInvincible(Preview,true)
		SetVehicleDirtLevel(Preview,0.0)
		Lasted = Model
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Buy",function(Data,Callback)
	local Sucess = vSERVER.Buy(Data.Vehicle,Data.Rental)

	if Sucess then
		SendNUIMessage({ Action = "Close" })
		Close()
	end

	Callback(Sucess)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	if DoesEntityExist(Preview) then
		local Offset = Data.Direction == "Left" and -5 or 5
		SetEntityHeading(Preview,GetEntityHeading(Preview) + Offset)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Drive", function(Data, Callback)
	if not vSERVER.Check() or not LoadModel(Data.Vehicle) then
		return Callback("Ok")
	end

	SendNUIMessage({ Action = "Close" })
	Close()

	if DoesEntityExist(Preview) then
		DeleteEntity(Preview)
		Preview = nil
	end

	Preview = CreateVehicle(Data.Vehicle,Config[Selected].DriveIn,false,false)

	SetVehicleModKit(Preview,0)
	SetVehicleDirtLevel(Preview,0.0)
	ToggleVehicleMod(Preview,18,true)
	SetEntityInvincible(Preview,true)
	SetPedIntoVehicle(PlayerPedId(),Preview,-1)
	SetVehicleNumberPlateText(Preview,"PDMSPORT")
	SetVehicleCustomPrimaryColour(Preview,255,255,255)
	SetVehicleCustomSecondaryColour(Preview,255,255,255)

	for _,Type in ipairs({ 11,12,13,15 }) do
		SetVehicleMod(Preview,Type,GetNumVehicleMods(Preview,Type) - 1,false)
	end

	LocalPlayer.state:set("Commands",true,true)

	CreateThread(function()
		while true do
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				vSERVER.Remove()
				LocalPlayer.state:set("Commands",false,true)

				SetEntityHeading(Ped,Config[Selected].DriveOut.w)
				SetEntityCoordsNoOffset(Ped,Config[Selected].DriveOut.xyz)

				if DoesEntityExist(Preview) then
					DeleteEntity(Preview)
					Preview = nil

					break
				end
			end

			Wait(1)
		end
	end)

	Callback("Ok")
end)
