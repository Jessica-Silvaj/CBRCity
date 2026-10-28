local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(),src)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
Config = module(GetCurrentResourceName(), "config/config")


local carregando = false
local carregandoId = nil
local animFlags = 0
local animDict = nil
local animName = nil
local forceAnim = false

local lastClicka = 0
local cooldowna = 5000 -- Cooldown in milliseconds (1 second)


RegisterNetEvent("NightAnimMenu:abrir")
AddEventHandler("NightAnimMenu:abrir",function(index,fix)
    if not aberto then
		TriggerEvent("dynamic:closeSystem")
		local c1,c2,c3,c4,c5,c6,c7 = vSERVER.Contadores()
		aberto = true
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showMenu",
		c1 = c1,
		c2 = c2,
		c3 = c3,
		c4 = c4,
		c5 = c5,
		c6 = c6,
		c7 = c7
		}) 
		StartScreenEffect("MenuMGSelectionIn", 0, true)
    end
end)

RegisterCommand(Config.ComandoAnim,function()
    if not aberto then
		local c1,c2,c3,c4,c5,c6,c7 = vSERVER.Contadores()
		aberto = true
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showMenu",
		c1 = c1,
		c2 = c2,
		c3 = c3,
		c4 = c4,
		c5 = c5,
		c6 = c6,
		c7 = c7
		}) 
		StartScreenEffect("MenuMGSelectionIn", 0, true)
    end
end)

RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
	StopScreenEffect("MenuMGSelectionIn")
	aberto = false
end)

RegisterKeyMapping("Night_AnimDuplaCancel","Cancelar animacao.","keyboard","F6")

RegisterCommand("Night_AnimDuplaCancel",function(source,args,rawCommand)
	if carregando then
		vSERVER.CancelarAnim()
		ClearPedTasksImmediately(PlayerPedId())
		src.stopAnim(animUpper)
		ClearPedTasks(GetPlayerPed(-1))
		animActived = false
		forceAnim = false
	end
end)

CreateThread(function()
    while true do 
		
		for k,v in pairs(Config.Comandos) do
			RegisterCommand(k, function(source, args, rawCommand)
				animacao(k)
			end)
		end

        Wait(1000)
    end
end)

animacao = function(index)
	if not carregando then
		vSERVER.PegarJogador(index,Config.Comandos[index].nome_anim)
	end
end

RegisterNetEvent(""..GetCurrentResourceName()..":SetId")
AddEventHandler(""..GetCurrentResourceName()..":SetId",function(otherPlayer)
	carregando = true
end)

RegisterNetEvent(""..GetCurrentResourceName()..":CancelarAnim")
AddEventHandler(""..GetCurrentResourceName()..":CancelarAnim",function()
	DetachEntity(PlayerPedId(),false,false)
	ClearPedTasksImmediately(PlayerPedId())
	src.stopAnim(animUpper)
	ClearPedTasks(GetPlayerPed(-1))
	animActived = false
	forceAnim = false
	carregando = false
end)

RegisterNetEvent(""..GetCurrentResourceName()..":Pegar")
AddEventHandler(""..GetCurrentResourceName()..":Pegar",function(otherPlayer,index)
	carregando = true
	DetachEntity(PlayerPedId(), true, false)
	local attachs = Config.Comandos[index].attachsInfos
	local plyServerId = GetPlayerFromServerId(otherPlayer)
	local pedInFront = GetPlayerPed(plyServerId)
	AttachEntityToEntity(PlayerPedId(),pedInFront,GetPedBoneIndex(pedInFront, attachs[1]),attachs[2],attachs[3],attachs[4],attachs[5],attachs[6],attachs[7],false,false,false,true,2,true)
end)

src.carregandoVerify = function()
	return carregando
end

src.ModelPlayer = function(tabela) 
	local ped = PlayerPedId()
	local model = GetEntityModel(ped)
	
	for skin, _ in pairs(tabela) do
		if model == GetHashKey(skin) then
			return skin
		end
	end
	
	return false
end 


function src.playAnim(animUpper,animSequency,animLoop,forceFlag)
	local playFlags = 0
	local ped = PlayerPedId()
	if animSequency["task"] then
		src.stopAnim(true)

		TaskStartScenarioInPlace(ped,animSequency["task"],0,true)
	else
		src.stopAnim(animUpper)

		if animUpper then
			playFlags = playFlags + 48
		end

		if animLoop then
			playFlags = playFlags + 1
		end

		Citizen.CreateThread(function()
			RequestAnimDict(animSequency[1])
			while not HasAnimDictLoaded(animSequency[1]) do
				Citizen.Wait(1)
			end

			if HasAnimDictLoaded(animSequency[1]) then
				animDict = animSequency[1]
				animName = animSequency[2]
				animFlags = playFlags

				if playFlags == 49 then
					animActived = true
				end

				if forceFlag then
					playFlags = 0
					forceAnim = true
					animActived = true
				end

				TaskPlayAnim(ped, animSequency[1], animSequency[2], 3.0, 3.0, -1, playFlags, 0, false, false, false)
			end
		end)
	end
end

function LoadAnim(dict)
    if not DoesAnimDictExist(dict) then
        return false
    end

    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end

    return true
end


Citizen.CreateThread(function()
	while true do
		local timeDistance = 200
		local ped = PlayerPedId()
		if carregando and animActived then
			blockButtons()
			if forceAnim then
				TaskPlayAnim(ped,animDict,animName,3.0,3.0,-1,0,0,0,0,0)
				timeDistance = 1
			else
				if not IsEntityPlayingAnim(ped,animDict,animName,3) then
					TaskPlayAnim(ped,animDict,animName,3.0,3.0,-1,animFlags,0,0,0,0)
					timeDistance = 1
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)

function src.stopAnim(animUpper)
	animActived = false
	local ped = PlayerPedId()

	if animUpper then
		ClearPedSecondaryTask(ped)
	else
		ClearPedTasks(ped)
	end
end

blockButtons = function() 
	DisablePlayerFiring(PlayerPedId(),true)
    BlockWeaponWheelThisFrame()
    DisableControlAction(0,29,true)
    DisableControlAction(0,38,true)
    DisableControlAction(0,47,true)
    DisableControlAction(0,56,true)
    DisableControlAction(0,57,true)
    DisableControlAction(0,73,true)
    DisableControlAction(0,137,true)
    DisableControlAction(0,161,true)
    DisableControlAction(0,166,true)
    DisableControlAction(0,167,true)
    DisableControlAction(0,169,true)
    DisableControlAction(0,170,true)
    DisableControlAction(0,182,true)
    DisableControlAction(0,187,true)
    DisableControlAction(0,188,true)
    DisableControlAction(0,189,true)
    DisableControlAction(0,190,true)
    DisableControlAction(0,243,true)
    DisableControlAction(0,245,true)
    DisableControlAction(0,257,true)
    DisableControlAction(0,288,true)
    DisableControlAction(0,289,true)
    DisableControlAction(0,311,true)
    DisableControlAction(0,344,true)	
end

RegisterNUICallback("GetTabelas",function(data,cb)
	local tabela = vSERVER.GetTabelas(data.tipo)
	if tabela then
		cb({ tabela = tabela })
	end
end)


local lastClick = 0
local cooldown = 10000 -- Cooldown in milliseconds (1 second)

RegisterNUICallback("addFavoritos", function(data, cb)
    k = data.k
    vSERVER.addFavoritos(k)
    lastClick = currentTime
	local c1,c2,c3,c4,c5,c6 = vSERVER.Contadores()
    cb({ retorno = 'done', c6 = c6 })
end)


RegisterNUICallback("IniciarAnim", function(data, cb)
	lastClicka = currentTime
    k = data.k
	ExecuteCommand(data.k)
end)


RegisterNUICallback("remFavoritos", function(data, cb)
    local currentTime = GetGameTimer()
    if currentTime - lastClick < cooldown then
		TriggerEvent("Notify","Atenção","Espere 10 segundos.","amarelo",5000)
        return
    end
    k = data.k
	print(k)
   	vSERVER.remFavoritos(k)
    lastClick = currentTime
	local c1,c2,c3,c4,c5,c6 = vSERVER.Contadores()
    cb({ retorno = 'done', c6 = c6 })
end)