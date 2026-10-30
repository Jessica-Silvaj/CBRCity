-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("paramedic",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Damaged = {}
local Bleedings = 0
local Punches = 0
local PunchDamage = 3
local HealthNow,HealthBefore = 200,200
local Injuried = GetGameTimer()
local BloodTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,Message)
	if Event ~= "CEventNetworkEntityDamage" or PlayerPedId() ~= Message[1] or LocalPlayer.state.Arena then
		return false
	end

	local Ped = Message[1]
	local Damage = Message[7]
	local Health = GetEntityHealth(Ped) > 100
	local Explosive = (Damage == 126349499 or Damage == 1064738331 or Damage == 85055149 or Damage == -135142818)

	if Explosive and Health then
		SetPedToRagdoll(Ped,2500,2500,0,0,0,0)

		return false
	end

	-- Soco (desarmado) só causa sangramento a partir do 5º soco (contagem zera no tratamento do paramédico)
	if GetWeapontypeGroup(Damage) == `GROUP_UNARMED` then
		-- cada soco tira no máximo PunchDamage de vida (a barra vai de 100 a 200)
		local Before = math.max(HealthNow,HealthBefore)
		local Now = GetEntityHealth(Ped)
		if Now > 100 and Before - Now > PunchDamage then
			SetEntityHealth(Ped,Before - PunchDamage)
		end
		HealthNow,HealthBefore = GetEntityHealth(Ped),GetEntityHealth(Ped)

		Punches = Punches + 1

		if Punches < 5 then
			return false
		end
	end

	if GetGameTimer() >= Injuried and not IsPedInAnyVehicle(Ped) and Health then
		Injuried = GetGameTimer() + 1000

		local Hit,Mark = GetPedLastDamageBone(Ped)
		if Hit and not Damaged[Mark] and Mark ~= 0 then
			Bleedings = math.min(Bleedings + 1,5)
			TriggerEvent("hud:Bleeding",Bleedings)
			ClearPedBloodDamage(Ped)
			Damaged[Mark] = true
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPUNCH: o vrp reduz o soco só uma vez ao carregar; aqui vale a cada frame e guarda a vida de antes do golpe
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		SetWeaponDamageModifier(`WEAPON_UNARMED`,0.25)

		HealthBefore = HealthNow
		HealthNow = GetEntityHealth(PlayerPedId())

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOODTICK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1000)

		local Ped = PlayerPedId()
		if not LocalPlayer.state.Arena and Bleedings > 0 and GetGameTimer() >= BloodTimers and GetEntityHealth(Ped) > 100 then
			TriggerEvent("Notify","Sangramento","Ferimentos encontrados.","sangue",5000)
			BloodTimers = GetGameTimer() + 30000
			SetEntityHealth(Ped,math.max(100,GetEntityHealth(Ped) - 5)) -- 5% da barra (100 a 200).
			ClearPedBloodDamage(Ped)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:RESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:Reset")
AddEventHandler("paramedic:Reset",function()
	Damaged = {}
	Bleedings = 0
	Punches = 0
	TriggerEvent("hud:Bleeding",Bleedings)
	Injuried = GetGameTimer()
	BloodTimers = GetGameTimer()
	ClearPedBloodDamage(PlayerPedId())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLEEDING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bleeding()
	return Bleedings
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bandage()
	Punches = 0

	for Number in pairs(Damaged) do
		local Humane = Bone(Number)

		TriggerEvent("sounds:Private","bandage",0.5)
		TriggerEvent("Notify","Atenção","Passou ataduras no(a) <b>"..Humane.."</b>.","amarelo",10000)

		Bleedings = math.max(Bleedings - 1,0)
		TriggerEvent("hud:Bleeding",Bleedings)
		Damaged[Number] = nil

		ClearPedBloodDamage(PlayerPedId())

		return Humane
	end

	return ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETPUNCHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ResetPunches()
	Punches = 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OXYCONTIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Oxycontin()
	Damaged = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:INJURIES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("paramedic:Injuries",function()
	if next(Damaged) == nil then
		TriggerEvent("Notify","Aviso","Nenhum ferimento encontrado.","amarelo",5000)

		return false
	end

	local Index = 1
	local Injuries = {}
	for Number in pairs(Damaged) do
		table.insert(Injuries,string.format("<b>%d</b>: %s<br>",Index,Bone(Number)))
		Index = Index + 1
	end

	TriggerEvent("Notify","Ferimentos",table.concat(Injuries),"amarelo",10000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Diagnostic()
	return Damaged,Bleedings
end