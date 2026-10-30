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
math.randomseed(GetGameTimer())
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
	AttachEntityToEntity(Object,Ped,GetPedBoneIndex(Ped,Prop.Bone),Offset.x,Offset.y,Offset.z,Rotation.x,Rotation.y,Rotation.z,true,true,false,true,Prop.Order or 1,true)
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
	SendNUIMessage({ Action = "PuffStart", Volume = Config.PuffVolume })
	Wait(1000)
	while (GetGameTimer() - Started) < Config.MaxHold * 1000 and (IsDisabledControlPressed(0,157) or IsDisabledControlPressed(0,158) or IsDisabledControlPressed(0,160) or IsDisabledControlPressed(0,164)) do
		Wait(0)
	end
	SendNUIMessage({ Action = "PuffStop" })

	-- quanto mais tempo segurou, maior a nuvem e o gasto (puxada curta = Config.Intensity)
	local Held = (GetGameTimer() - Started) / 1000
	local Intensity = math.min(1.0,math.max(Config.Intensity,Held / Config.MaxHold))
	TriggerServerEvent("Night_Vape:Puff",Intensity)

	-- a puxada passou do limite do pulmão: crise de tosse
	-- sabor "Desperto" faz o pulmão encher pela metade
	local Gain = Config.Lung.PerPuff * (0.5 + Intensity) * ((EffectActive() and Active.Effect == "awake") and 0.5 or 1)
	local Overload = Config.Lung.Enabled and Lung + Gain > 100
	if Config.Lung.Enabled then
		Lung = math.min(100.0,Lung + Gain)
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
RegisterNetEvent("Night_Vape:Refill",function(Vape)
	local Ped = PlayerPedId()
	local Refill = Config.Refill

	Busy = true
	Current = Config.Vapes[Vape] and Vape or Current
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

-- Tanque quase vazio: 3 bipes
RegisterNetEvent("Night_Vape:Beep",function()
	for _ = 1,3 do
		PlaySoundFrontend(-1,"Beep_Red","DLC_HEIST_HACKING_SNAKE_SOUNDS",true)
		Wait(220)
	end
end)

-- Vapor colorido: sai da boca e depois solta no ar. Na rua segue o vento (com uma leve ondulação);
-- em lugar fechado fica parado, sobe devagar e some no próprio tempo
RegisterNetEvent("Night_Vape:Smoke",function(ServerId,Color,Cloud)
	local Player = GetPlayerFromServerId(ServerId)
	if Player == -1 then
		return
	end

	local Ped = GetPlayerPed(Player)
	if not DoesEntityExist(Ped) then
		return
	end

	Cloud = math.max(0.15,tonumber(Cloud) or 1.0)
	LoadAsset(SmokeAsset)

	-- saída da boca (o efeito é em loop; NonLooped não aparece)
	UseParticleFxAssetNextCall(SmokeAsset)
	local Mouth = StartParticleFxLoopedOnEntityBone(SmokeName,Ped,0.0,0.15,0.0,0.0,0.0,0.0,GetPedBoneIndex(Ped,31086),0.06 + (Cloud * 0.07),false,false,false)
	SetParticleFxLoopedColour(Mouth,Color[1] / 255.0,Color[2] / 255.0,Color[3] / 255.0,false)
	SetParticleFxLoopedAlpha(Mouth,0.8)
	Wait(600)
	StopParticleFxLooped(Mouth,false)

	-- nuvem solta no ar, deslocada pelo vento
	local Indoor = GetInteriorFromEntity(Ped) ~= 0
	local Position = GetPedBoneCoords(Ped,31086,0.0,0.0,0.0) + (GetEntityForwardVector(Ped) * 0.25)
	local Wind = Indoor and vec3(0.0,0.0,0.0) or (GetWindDirection() * math.min(3.0,GetWindSpeed()) * 0.35)
	local Rise = Indoor and 0.05 or 0.12
	local Drift = math.random() * 6.28

	UseParticleFxAssetNextCall(SmokeAsset)
	local Handle = StartParticleFxLoopedAtCoord(SmokeName,Position.x,Position.y,Position.z,0.0,0.0,0.0,0.08 + (Cloud * 0.1),false,false,false,false)
	SetParticleFxLoopedColour(Handle,Color[1] / 255.0,Color[2] / 255.0,Color[3] / 255.0,false)

	local Duration = math.floor((Indoor and 2600 or 1600) + (Cloud * 1800))
	local Started = GetGameTimer()
	local Last = Started
	while GetGameTimer() - Started < Duration do
		local Now = GetGameTimer()
		local Delta = (Now - Last) / 1000
		local Elapsed = (Now - Started) / 1000
		Last = Now

		-- ondulação limitada para não ficar uma coluna reta
		local Wander = Indoor and vec3(0.0,0.0,0.0) or vec3(math.sin(Elapsed * 1.7 + Drift) * 0.12,math.cos(Elapsed * 1.3 + Drift) * 0.12,0.0)
		Position = Position + ((Wind + Wander + vec3(0.0,0.0,Rise)) * Delta)
		SetParticleFxLoopedOffsets(Handle,Position.x,Position.y,Position.z,0.0,0.0,0.0)
		SetParticleFxLoopedAlpha(Handle,0.75 * (1.0 - (Now - Started) / Duration))

		Wait(0)
	end

	StopParticleFxLooped(Handle,false)
end)

-- Estação de recarga: abre ao usar um líquido ou o vape vazio; depois de cada despejo só atualiza
RegisterNetEvent("Night_Vape:RefillPanel",function(Data)
	if Data.Update and not PanelOpen then
		return
	end

	PanelOpen = true
	Data.Action = Data.Update and "UpdateRefill" or "OpenRefill"
	SetNuiFocus(true,true)
	SendNUIMessage(Data)
end)

RegisterNUICallback("Pour",function(Data,Callback)
	TriggerServerEvent("Night_Vape:Pour",Data.Vape,Data.Item)
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
		elseif Effect == "swim" then
			SetSwimMultiplierForPlayer(PlayerId(),1.20)
		end

		-- termina quando o tempo acaba ou outro sabor substitui o efeito
		local NextHeal = GetGameTimer() + 2000
		while Active and Active.Effect == Effect and GetGameTimer() < Active.Until do
			if Effect == "stamina" then
				RestorePlayerStamina(PlayerId(),1.0)
			elseif Effect == "heal" and GetGameTimer() >= NextHeal then
				-- +2 de vida a cada 2 segundos (não levanta quem está caído)
				NextHeal = GetGameTimer() + 2000
				local Health = GetEntityHealth(PlayerPedId())
				if Health > 101 and Health < GetEntityMaxHealth(PlayerPedId()) then
					SetEntityHealth(PlayerPedId(),math.min(GetEntityMaxHealth(PlayerPedId()),Health + 2))
				end
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
		elseif Effect == "swim" then
			SetSwimMultiplierForPlayer(PlayerId(),1.0)
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
			-- sabor "Gelado" recupera o pulmão 3x mais rápido
			local Recover = Config.Lung.Recover * ((EffectActive() and Active.Effect == "breath") and 3 or 1)
			Lung = math.max(0.0,Lung - Recover * (Now - Last) / 1000)
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

		-- card do vape (sabor/tanque/efeito) desligado: o pulmão já aparece na HUD
		if Config.Card and (Busy or EffectActive()) then
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
		SendNUIMessage({ Action = "PuffStop" })

		if PanelOpen then
			SetNuiFocus(false,false)
		end
	end
end)
