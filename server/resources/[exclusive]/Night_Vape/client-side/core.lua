-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Current = nil
local Object = nil
-- Busy: puxando ou recarregando
local Busy = false
local PanelOpen = false
-- Efeito do sabor em andamento: { Effect, Label, Description, Until, Duration }
local Active = nil
local Tank = { Ml = 0.0, Capacity = Config.Capacity, Flavor = nil, Color = nil }
-- Pulmão de 0 a 100 (ver Config.Lung)
local Lung = 0.0

local CoughDict,CoughAnim = "timetable@gardener@smoking_joint","idle_cough"

local PuffDict,PuffAnim = "amb@world_human_smoking@male@male_b@idle_a","idle_a"
-- fumaça colorida dos aviões de acrobacia: aceita SetParticleFxLoopedColour (a de granada ignora a cor)
local SmokeAsset,SmokeName = "scr_ar_planes","scr_ar_trail_smoke"
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadDict(Dict)
	RequestAnimDict(Dict)

	local Timeout = GetGameTimer() + 5000
	while not HasAnimDictLoaded(Dict) and GetGameTimer() < Timeout do
		Wait(10)
	end
end

local function LoadAsset(Asset)
	RequestNamedPtfxAsset(Asset)

	local Timeout = GetGameTimer() + 5000
	while not HasNamedPtfxAssetLoaded(Asset) and GetGameTimer() < Timeout do
		Wait(10)
	end
end

local function LoadModel(Hash)
	RequestModel(Hash)

	local Timeout = GetGameTimer() + 5000
	while not HasModelLoaded(Hash) and GetGameTimer() < Timeout do
		Wait(10)
	end

	return HasModelLoaded(Hash)
end

local function RemoveProp()
	if Object and DoesEntityExist(Object) then
		DetachEntity(Object,true,true)
		DeleteEntity(Object)
	end

	Object = nil
end

local function AttachProp()
	RemoveProp()

	local Prop = Config.Vapes[Current] or Config.Vapes["vape"]
	local Hash = GetHashKey(Prop.Model)
	if not LoadModel(Hash) then
		return
	end

	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	Object = CreateObject(Hash,Coords.x,Coords.y,Coords.z,true,true,false)
	SetModelAsNoLongerNeeded(Hash)

	local Offset,Rotation = Prop.Offset,Prop.Rotation
	AttachEntityToEntity(Object,Ped,GetPedBoneIndex(Ped,Prop.Bone),Offset.x,Offset.y,Offset.z,Rotation.x,Rotation.y,Rotation.z,true,true,false,true,1,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD: aparece durante a puxada/recarga e enquanto o efeito do sabor estiver ativo
-----------------------------------------------------------------------------------------------------------------------------------------
local function EffectActive()
	return Active and GetGameTimer() < Active.Until
end

local function Hud()
	local Prop = Config.Vapes[Current] or Config.Vapes["vape"]
	SendNUIMessage({
		Action = "Update",
		Name = Prop.Name,
		Flavor = Tank.Flavor,
		Color = Tank.Color,
		Ml = Tank.Ml,
		Capacity = Tank.Capacity,
		Lung = Lung,
		LungWarning = Config.Lung.Warning,
		Effect = EffectActive() and {
			Label = Active.Label,
			Description = Active.Description,
			Left = (Active.Until - GetGameTimer()) / Active.Duration,
			Seconds = math.ceil((Active.Until - GetGameTimer()) / 1000)
		} or nil
	})
end

-- Crise de tosse: animação, câmera tremendo e um pouco de vida
local function Cough()
	local Ped = PlayerPedId()

	LoadDict(CoughDict)
	TaskPlayAnim(Ped,CoughDict,CoughAnim,8.0,-8.0,4000,49,0,false,false,false)
	ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.08)

	local Health = GetEntityHealth(Ped)
	if Health > Config.Lung.MinHealth then
		SetEntityHealth(Ped,math.max(Config.Lung.MinHealth,Health - Config.Lung.Damage))
	end

	TriggerEvent("Notify","Vape","Você puxou demais e começou a tossir.","vermelho",5000)
	Wait(4000)
	StopAnimTask(Ped,CoughDict,CoughAnim,2.0)
end

local function ClosePanel()
	PanelOpen = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "CloseRefill" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Vape:Tank",function(Ml,Capacity,Flavor,Color)
	Tank.Ml,Tank.Capacity,Tank.Flavor,Tank.Color = Ml,Capacity,Flavor,Color
end)

-- Usar o vape: tira da bolsa, leva à boca, solta a fumaça e guarda
RegisterNetEvent("Night_Vape:Use",function(Item)
	if Busy or PanelOpen then
		return
	end

	local Ped = PlayerPedId()
	if IsPedSwimming(Ped) or IsPedRagdoll(Ped) then
		return
	end

	Busy = true
	Current = Item
	AttachProp()

	LoadDict(PuffDict)
	TaskPlayAnim(Ped,PuffDict,PuffAnim,8.0,-8.0,-1,49,0,false,false,false)

	-- segurando a tecla da hotbar (1-4) continua puxando, até Config.MaxHold segundos
	local Started = GetGameTimer()
	Wait(1000)
	while (GetGameTimer() - Started) < Config.MaxHold * 1000 and (IsDisabledControlPressed(0,157) or IsDisabledControlPressed(0,158) or IsDisabledControlPressed(0,160) or IsDisabledControlPressed(0,164)) do
		Wait(0)
	end

	-- quanto mais tempo segurou, maior a nuvem e o gasto (puxada curta = Config.Intensity)
	local Held = (GetGameTimer() - Started) / 1000
	local Intensity = math.min(1.0,math.max(Config.Intensity,Held / Config.MaxHold))
	TriggerServerEvent("Night_Vape:Puff",Intensity)

	-- puxou com o pulmão já cheio: crise de tosse
	local Overload = Config.Lung.Enabled and Lung >= 100
	if Config.Lung.Enabled then
		Lung = math.min(100.0,Lung + Config.Lung.PerPuff * (0.5 + Intensity))
	end

	Wait(1000)
	StopAnimTask(Ped,PuffDict,PuffAnim,2.0)
	RemoveProp()

	if Overload then
		Cough()
	elseif Config.Lung.Enabled and Lung >= Config.Lung.Warning then
		TriggerEvent("Notify","Vape","Sua garganta está irritada. Dê um tempo antes de puxar de novo.","amarelo",5000)
	end

	SetTimeout(math.max(0,Config.PuffCooldown * 1000 - (GetGameTimer() - Started)),function()
		Busy = false
	end)
end)

-- Animação de encaixar o frasco, com o frasco na mão esquerda e o vape na direita
RegisterNetEvent("Night_Vape:Refill",function()
	local Ped = PlayerPedId()
	local Refill = Config.Refill

	Busy = true
	AttachProp()

	local Bottle = nil
	local Hash = GetHashKey(Refill.Model)
	if LoadModel(Hash) then
		local Coords = GetEntityCoords(Ped)
		Bottle = CreateObject(Hash,Coords.x,Coords.y,Coords.z,true,true,false)
		SetModelAsNoLongerNeeded(Hash)
		AttachEntityToEntity(Bottle,Ped,GetPedBoneIndex(Ped,Refill.Bone),Refill.Offset.x,Refill.Offset.y,Refill.Offset.z,Refill.Rotation.x,Refill.Rotation.y,Refill.Rotation.z,true,true,false,true,1,true)
	end

	LoadDict("mp_arresting")
	TaskPlayAnim(Ped,"mp_arresting","a_uncuff",8.0,-8.0,Refill.Duration,49,0,false,false,false)

	Wait(Refill.Duration)

	if Bottle and DoesEntityExist(Bottle) then
		DetachEntity(Bottle,true,true)
		DeleteEntity(Bottle)
	end

	RemoveProp()
	Busy = false
end)

-- Vapor colorido saindo da boca de quem puxou
RegisterNetEvent("Night_Vape:Smoke",function(ServerId,Color,Intensity)
	local Player = GetPlayerFromServerId(ServerId)
	if Player == -1 then
		return
	end

	local Ped = GetPlayerPed(Player)
	if not DoesEntityExist(Ped) then
		return
	end

	Intensity = tonumber(Intensity) or 1.0
	LoadAsset(SmokeAsset)

	-- o efeito é em loop (NonLooped não aparece)
	UseParticleFxAssetNextCall(SmokeAsset)
	local Handle = StartParticleFxLoopedOnEntityBone(SmokeName,Ped,0.0,0.15,0.0,0.0,0.0,0.0,GetPedBoneIndex(Ped,31086),0.08 + (Intensity * 0.08),false,false,false)
	SetParticleFxLoopedColour(Handle,Color[1] / 255.0,Color[2] / 255.0,Color[3] / 255.0,false)
	SetParticleFxLoopedAlpha(Handle,0.8)

	Wait(math.floor(1000 + (Intensity * 2000)))
	StopParticleFxLooped(Handle,false)
end)

-- Painel de recarga (abre ao usar o vape com o tanque vazio)
RegisterNetEvent("Night_Vape:RefillPanel",function(Data)
	PanelOpen = true
	Data.Action = "OpenRefill"
	SetNuiFocus(true,true)
	SendNUIMessage(Data)
end)

RegisterNUICallback("Refill",function(Data,Callback)
	ClosePanel()
	TriggerServerEvent("Night_Vape:RefillFrom",Data.Item)
	Callback("Ok")
end)

RegisterNUICallback("Close",function(_,Callback)
	ClosePanel()
	Callback("Ok")
end)

-- Efeito do sabor: aparece no painel com o tempo restante; puxar de novo renova
RegisterNetEvent("Night_Vape:Effect",function(Effect)
	local Data = Config.Effects[Effect]
	if not Data then
		return
	end

	-- só abre um loop novo se o efeito não está rodando (senão só renova o tempo)
	local Fresh = not Active or Active.Effect ~= Effect or GetGameTimer() >= Active.Until

	if Data.Duration <= 0 then
		-- efeito instantâneo: só mostra o rótulo por alguns segundos
		Active = { Effect = Effect, Label = Data.Label, Description = Data.Description, Until = GetGameTimer() + 4000, Duration = 4000 }
		return
	end

	local Duration = Data.Duration * 1000
	Active = { Effect = Effect, Label = Data.Label, Description = Data.Description, Until = GetGameTimer() + Duration, Duration = Duration }

	if not Fresh then
		return
	end

	-- loop do efeito enquanto estiver ativo
	CreateThread(function()
		local Ped = PlayerPedId()

		-- visuais definidos no config
		if Data.Timecycle then
			SetTimecycleModifier(Data.Timecycle)
			SetTimecycleModifierStrength(Data.Strength or 0.5)
		end

		if Data.Postfx then
			AnimpostfxPlay(Data.Postfx,0,true)
		end

		if Data.Shake then
			ShakeGameplayCam(Data.Shake,Data.ShakeAmp or 0.5)
		end

		if Data.Walk then
			RequestAnimSet(Data.Walk)
			local Timeout = GetGameTimer() + 3000
			while not HasAnimSetLoaded(Data.Walk) and GetGameTimer() < Timeout do
				Wait(10)
			end
			SetPedMovementClipset(Ped,Data.Walk,0.5)
		end

		if Effect == "speed" then
			SetRunSprintMultiplierForPlayer(PlayerId(),1.10)
		end

		-- termina quando o tempo acaba ou outro sabor substitui o efeito
		while Active and Active.Effect == Effect and GetGameTimer() < Active.Until do
			if Effect == "stamina" then
				RestorePlayerStamina(PlayerId(),1.0)
			end

			Wait(250)
		end

		if Data.Timecycle then
			ClearTimecycleModifier()
		end

		if Data.Postfx then
			AnimpostfxStop(Data.Postfx)
		end

		if Data.Shake then
			StopGameplayCamShaking(false)
		end

		if Data.Walk then
			-- volta para o andar escolhido no vrp (state.Walk) ou o padrão
			local Walk = LocalPlayer.state.Walk
			if Walk and HasAnimSetLoaded(Walk) then
				SetPedMovementClipset(PlayerPedId(),Walk,0.5)
			else
				ResetPedMovementClipset(PlayerPedId(),0.5)
			end
		end

		if Effect == "speed" then
			SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD: recupera o pulmão e mostra o painel enquanto puxa/recarrega, com efeito ativo ou pulmão carregado
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Visible = false
	local Last = GetGameTimer()
	local LungSent = -1

	while true do
		local TimeDistance = 500

		local Now = GetGameTimer()
		if Lung > 0 then
			Lung = math.max(0.0,Lung - Config.Lung.Recover * (Now - Last) / 1000)
		end
		Last = Now

		-- círculo do pulmão na HUD (ao lado de vida/colete/fome/sede)
		local Rounded = math.ceil(Lung)
		if Rounded ~= LungSent then
			LungSent = Rounded
			TriggerEvent("hud:Lung",Rounded)
		end

		if Lung > 0 then
			TimeDistance = 200
		end

		if Busy or EffectActive() then
			TimeDistance = 100
			Hud()

			if not Visible then
				Visible = true
				SendNUIMessage({ Action = "Show" })
			end
		elseif Visible then
			Visible = false
			SendNUIMessage({ Action = "Hide" })
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(Resource)
	if Resource == GetCurrentResourceName() then
		RemoveProp()

		if PanelOpen then
			SetNuiFocus(false,false)
		end
	end
end)
