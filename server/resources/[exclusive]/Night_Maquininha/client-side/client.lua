-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("Night_Maquininha",Creative)
vSERVER = Tunnel.getInterface("Night_Maquininha")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local uObject = nil 
local animActived = false 
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local timeDistance = 999
		if animActived then
			timeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(ped,true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
function deleteMachine()
	local ped = PlayerPedId()
	animActived = false 

	ClearPedTasks(ped)
	ClearPedSecondaryTask(ped)
	if DoesEntityExist(uObject) then
		vSERVER.tryDeleteObject(ObjToNet(uObject))
		uObject = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
function createMachine()
    if DoesEntityExist(uObject) then
		vSERVER.tryDeleteObject(ObjToNet(uObject))
		uObject = nil
	end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if newAnim ~= "" then
		RequestAnimDict("cellphone@")
		while not HasAnimDictLoaded("cellphone@") do
			Wait(1)
		end
		TaskPlayAnim(ped,"cellphone@","cellphone_text_in",3.0,3.0,-1,50,0,0,0,0)
		animActived = true
	end

	local myObject,objNet = vSERVER.createObject("arts_maquina_cartao",coords["x"],coords["y"],coords["z"])
	if myObject then
		local spawnObjects = 0
		uObject = NetworkGetEntityFromNetworkId(objNet)
		while not DoesEntityExist(uObject) and spawnObjects <= 1000 do
			uObject = NetworkGetEntityFromNetworkId(objNet)
			spawnObjects = spawnObjects + 1
			Wait(1)
		end

		spawnObjects = 0
		local objectControl = NetworkRequestControlOfEntity(uObject)
		while not objectControl and spawnObjects <= 1000 do
			objectControl = NetworkRequestControlOfEntity(uObject)
			spawnObjects = spawnObjects + 1
			Wait(1)
		end

		AttachEntityToEntity(uObject,ped,GetPedBoneIndex(ped,28422),0.0,0.0,0.0,70.0,0.0,0.0,true,true,false,false,1,true)
		SetEntityAsNoLongerNeeded(uObject)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENFRAME
-----------------------------------------------------------------------------------------------------------------------------------------
function openFrame()
	SendNUIMessage({ action = "showFrame",payload = true })
	SetNuiFocus(true,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSEFRAME
-----------------------------------------------------------------------------------------------------------------------------------------
function closeFrame()
	SendNUIMessage({ action = "showFrame", payload = false })
	SetNuiFocus(false, false)
	animActived = false 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDATA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getData",function(data,cb)
    local userName,id = vSERVER.getUserData()
    cb({
        name = userName,
        id = id 
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getUser",function(data,cb)
    local userName,id = vSERVER.getUserDataFromId(data.id)
    cb({
        name = userName,
        id = id
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTPAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("insertPay",function(data,cb)
    local sendBill = vSERVER.sendBill(data.user.findUser,data.value)
    cb({
        success = sendBill
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIDEFRAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("hideFrame",function(data,cb)
	SetNuiFocus(false)
	deleteMachine()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAQUININHA:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("maquininha:open")
AddEventHandler("maquininha:open",function(data)
	if data[1] == "open" then 
		createMachine()
		openFrame()
	elseif data[1] == "close" then 
		closeFrame()
		deleteMachine()
	end
end)