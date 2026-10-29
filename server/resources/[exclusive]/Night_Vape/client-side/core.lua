-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Equipped = false
local Object = nil
local Puffing = false
local Tank = { Ml = 0.0, Capacity = Config.Capacity, Flavor = nil }

local PuffDict,PuffAnim = "mp_player_inteat@burger","mp_player_int_eat_burger"
local SmokeAsset,SmokeName = "core","exp_grd_bzgas_smoke"
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

local function RemoveProp()
	if Object and DoesEntityExist(Object) then
		DetachEntity(Object,true,true)
		DeleteEntity(Object)
	end

	Object = nil
end

local function AttachProp()
	RemoveProp()

	local Hash = GetHashKey(Config.Prop.Model)
	RequestModel(Hash)

	local Timeout = GetGameTimer() + 5000
	while not HasModelLoaded(Hash) and GetGameTimer() < Timeout do
		Wait(10)
	end

	if not HasModelLoaded(Hash) then
		return
	end

	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	Object = CreateObject(Hash,Coords.x,Coords.y,Coords.z,true,true,false)
	SetModelAsNoLongerNeeded(Hash)

	local Offset,Rotation = Config.Prop.Offset,Config.Prop.Rotation
	AttachEntityToEntity(Object,Ped,GetPedBoneIndex(Ped,Config.Prop.Bone),Offset.x,Offset.y,Offset.z,Rotation.x,Rotation.y,Rotation.z,true,true,false,true,1,true)
end

local function Unequip(Notify)
	if not Equipped then
		return
	end

	Equipped = false
	Puffing = false
	ClearPedSecondaryTask(PlayerPedId())
	RemoveProp()

	if Notify then
		TriggerServerEvent("Night_Vape:Store")
	end
end

local function HelpText()
	local Status = Tank.Flavor and (Tank.Flavor.." "..string.format("%.1f/%.0f ml",Tank.Ml,Tank.Capacity)) or "Tanque vazio"
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName("~INPUT_CONTEXT~ Puxar   ~INPUT_DETONATE~ Guardar~n~"..Status)
	EndTextCommandDisplayHelp(0,false,false,-1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Vape:Tank",function(Ml,Capacity,Flavor)
	Tank.Ml,Tank.Capacity,Tank.Flavor = Ml,Capacity,Flavor
end)

RegisterNetEvent("Night_Vape:Equip",function(Status)
	if Status then
		Equipped = true
		AttachProp()
	else
		Unequip(false)
	end
end)

-- Animação curta de encaixar o frasco
RegisterNetEvent("Night_Vape:Refill",function()
	LoadDict("mp_arresting")
	TaskPlayAnim(PlayerPedId(),"mp_arresting","a_uncuff",8.0,-8.0,2500,49,0,false,false,false)
end)

-- Vapor colorido saindo da boca de quem puxou
RegisterNetEvent("Night_Vape:Smoke",function(ServerId,Color)
	local Player = GetPlayerFromServerId(ServerId)
	if Player == -1 then
		return
	end

	local Ped = GetPlayerPed(Player)
	if not DoesEntityExist(Ped) then
		return
	end

	LoadAsset(SmokeAsset)

	-- espera o fim da puxada para soltar o vapor
	SetTimeout(1800,function()
		if not DoesEntityExist(Ped) then
			return
		end

		for Index = 1,3 do
			UseParticleFxAssetNextCall(SmokeAsset)
			SetParticleFxNonLoopedColour(Color[1] / 255.0,Color[2] / 255.0,Color[3] / 255.0)
			SetParticleFxNonLoopedAlpha(0.6)
			StartParticleFxNonLoopedOnPedBone(SmokeName,Ped,0.0,0.15,0.0,0.0,0.0,0.0,GetPedBoneIndex(Ped,31086),0.18 + (Index * 0.06),false,false,false)
			Wait(350)
		end
	end)
end)

RegisterNetEvent("Night_Vape:Effect",function(Effect,Duration)
	local Ped = PlayerPedId()
	Duration = (tonumber(Duration) or 12) * 1000
	if Effect == "stamina" then
		RestorePlayerStamina(PlayerId(),1.0)
	elseif Effect == "focus" then
		StartScreenEffect("FocusIn",Duration,false)
	elseif Effect == "speed" then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.05)
		SetTimeout(Duration,function()
			SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 500

		if Equipped then
			TimeDistance = 1
			local Ped = PlayerPedId()

			-- Guarda sozinho em situações onde não faz sentido segurar o vape
			if LocalPlayer.state.Death or LocalPlayer.state.Crawl or LocalPlayer.state.Handcuff or IsPedSwimming(Ped) or IsPedRagdoll(Ped) then
				Unequip(true)
			else
				HelpText()
				DisablePlayerFiring(Ped,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,140,true)

				if Object and not DoesEntityExist(Object) then
					AttachProp()
				end

				if IsControlJustPressed(0,Config.Keys.Store) then
					Unequip(true)
				elseif not Puffing and IsControlPressed(0,Config.Keys.Puff) then
					Puffing = true

					CreateThread(function()
						LoadDict(PuffDict)
						TaskPlayAnim(Ped,PuffDict,PuffAnim,8.0,-8.0,1600,49,0,false,false,false)
						TriggerServerEvent("Night_Vape:Puff")

						Wait(Config.PuffCooldown * 1000)
						Puffing = false
					end)
				end
			end
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
	end
end)
