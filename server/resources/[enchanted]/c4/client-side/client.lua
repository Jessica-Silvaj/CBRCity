-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("c4", Creative)
vSERVER = Tunnel.getInterface("c4")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer.state.IsPickingUp = nil
local IsPlayerStealing = false
local IsPickingUp = false
local ActiveRobberies = {}
local ActiveProps = {}
local LOOT_HASH = GetHashKey(Config.Robbery.Pickups.Model or "bkr_prop_money_unsorted_01")
local LOOT_FALLBACK_HASH = GetHashKey(Config.Robbery.Pickups.FallbackModel or "bkr_prop_money_unsorted_01")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Auxilio
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(true)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z, 0)
	DrawText(0.0, 0.0)
	local factor = string.len(text) / 370
	DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 120)
	ClearDrawOrigin()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
local function cancelPlayer(status)
	LocalPlayer["state"]:set("Buttons", status, true)
	LocalPlayer["state"]:set("Commands", status, true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNBOMB
-----------------------------------------------------------------------------------------------------------------------------------------
local function spawnBomb(coords, atmProp, offsetData)
	LoadModel(Config.BombHash)
	local bombProp = CreateObject(Config.BombHash, coords)
	local timeout = GetGameTimer() + 5000
	repeat
		Wait(10)
	until DoesEntityExist(bombProp) or GetGameTimer() > timeout
	SetModelAsNoLongerNeeded(Config.BombHash)
	if atmProp ~= 0 then
		if DoesEntityExist(bombProp) then
			AttachEntityToEntity(bombProp, atmProp, 0, offsetData.off.x, offsetData.off.y, offsetData.off.z, offsetData.rot.x, offsetData.rot.y, offsetData.rot.z, false, false, false, true, 0, true)
		end
	else
		FreezeEntityPosition(bombProp, true)
		SetEntityCollision(bombProp, false)
	end
	if DoesEntityExist(bombProp) then
		ActiveProps[bombProp] = true
	end
	return bombProp
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETRANDOMCIRCULARCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetRandomCircularCoords(position, radius)
	local angle = GetRandomFloatInRange(0.1, 6.2)
	return vec3(position.x + radius * math.cos(angle), position.y + radius * math.sin(angle), position.z)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNLOOT
-----------------------------------------------------------------------------------------------------------------------------------------
local function spawnLoot(lootHash, centerCoords, maxRange)
	local spawnCoords = GetRandomCircularCoords(centerCoords, GetRandomFloatInRange(0.0, maxRange))
	local moneyProp = CreateObjectNoOffset(lootHash, spawnCoords)
	local timeout = GetGameTimer() + 5000
	repeat
		Wait(10)
	until DoesEntityExist(moneyProp) or GetGameTimer() > timeout

	if DoesEntityExist(moneyProp) then
		SetEntityHeading(moneyProp, math.random(360) + 0.0)
		PlaceObjectOnGroundProperly(moneyProp)
		FreezeEntityPosition(moneyProp, true)
		ActiveProps[moneyProp] = true

		return { prop = moneyProp, coords = GetEntityCoords(moneyProp) }
	end

	return { prop = nil, coords = spawnCoords }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RUNROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local function runRobbery(targetId)
	local ped = PlayerPedId()
	local stealData = Config.AtmList[targetId]
	if not stealData or stealData.Safe then
		return
	end

	local c4Time = vSERVER.CheckSystems(targetId)
	if not c4Time then
		return
	end
	if type(c4Time) ~= "number" then c4Time = 60 end

	cancelPlayer(true, true)

	local atmProp = GetClosestObjectOfType(stealData.Cds, 2.0, stealData.Prop)
	local offsetCoords = atmProp ~= 0 and GetOffsetFromEntityInWorldCoords(atmProp, Config.PropOffset[stealData.Prop].money.pos) or stealData.Cds
	if atmProp ~= 0 then
		SetEntityHeading(ped, GetEntityHeading(atmProp))
	end
	SetEntityCoords(ped, offsetCoords.x, offsetCoords.y, offsetCoords.z)

	FreezeEntityPosition(ped, true)
	vRP.playAnim(false, { "anim@heists@ornate_bank@thermal_charge", "thermal_charge" }, true)
	vRP._createObjects("anim@heists@ornate_bank@thermal_charge", "thermal_charge", "prop_c4_final_green", 0, 28422, 0.0, 0.0, 0.0, 260.0, 0.0, 0.0)

	local timeout = GetGameTimer() + 5000
	repeat
		Wait(10)
	until GetGameTimer() > timeout

	FreezeEntityPosition(ped, false)
	vRP.stopAnim(false)
	vRP.Destroy()
	cancelPlayer(false)

	local bombProp = spawnBomb(stealData.Cds, atmProp, Config.PropOffset[stealData.Prop])
	SendNUIMessage({ time = c4Time })
	timeout = GetGameTimer() + (c4Time * 1000)
	repeat
		Wait(10)
	until GetGameTimer() > timeout
	DeleteObject(bombProp)
	vSERVER.PrepareExplosion(targetId)
	AddExplosion(stealData.Cds.x, stealData.Cds.y, stealData.Cds.z, 2, 1.0, true, false, 2.0)

	local pickupOpened = vSERVER.UpdateAtmExploded(targetId)
	if not pickupOpened then
		IsPlayerStealing = false
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDROP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("eletronics:setDrop", function(atm)
	local ped = PlayerPedId()
	local plyVeh = GetVehiclePedIsUsing(ped)
	local stealData = Config.AtmList[atm]
	if not stealData then
		return
	end

	IsPickingUp = true
	LocalPlayer.state.IsPickingUp = true
	ActiveRobberies[atm] = true

	local atmProp = GetClosestObjectOfType(stealData.Cds, 2.0, stealData.Prop)

	local lootHash = LOOT_HASH
	if not LoadModel(lootHash) then
		lootHash = LOOT_FALLBACK_HASH
		LoadModel(lootHash)
	end

	local lootTotal = math.max(Config.Robbery.Pickups.Total, 1)
	local remaining = lootTotal
	local propList = {}
	local offsetCoords = atmProp ~= 0 and GetOffsetFromEntityInWorldCoords(atmProp, Config.PropOffset[stealData.Prop].money.pos) or stealData.Cds
	SetEntityDrawOutlineColor(255, 255, 255, 150)
	for i = 1, lootTotal do
		propList[i] = spawnLoot(lootHash, offsetCoords, Config.PropOffset[stealData.Prop].money.range)

		if not propList[i].prop and lootHash ~= LOOT_FALLBACK_HASH then
			lootHash = LOOT_FALLBACK_HASH
			LoadModel(lootHash)
			propList[i] = spawnLoot(lootHash, offsetCoords, Config.PropOffset[stealData.Prop].money.range)
		end

		if propList[i].prop then
			SetEntityDrawOutline(propList[i].prop, true)
		end
	end
	SetModelAsNoLongerNeeded(lootHash)
	TriggerEvent("Notify", "Atenção", "O caixa explodiu! Pegue o malote e saia antes que a polícia chegue.", "amarelo", 8000)

	local dist, delay
	local hoverfyActive = false

	while ActiveRobberies[atm] do
		delay = 500
		ped = PlayerPedId()
		plyVeh = GetVehiclePedIsUsing(ped)
		local pedCoords = GetEntityCoords(ped)
		dist = #(pedCoords - offsetCoords)

		if dist <= 30 then
			delay = 0

			local closestIdx = nil
			local closestDist = 999.0
			for idx, v in pairs(propList) do
				local liveCoords = v.coords
				if v.prop and DoesEntityExist(v.prop) then
					liveCoords = GetEntityCoords(v.prop)
				end
				local pDist = #(pedCoords - liveCoords)
				DrawMarker(1, liveCoords.xy, liveCoords.z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.02, 0.02, 0.9, 240, 83, 0, 150, false, false, 2)
				if pDist < closestDist then
					closestDist = pDist
					closestIdx = idx
				end
			end

			if closestIdx and closestDist <= 1.5 and plyVeh == 0 then
				if not hoverfyActive then
					hoverfyActive = true
					TriggerEvent("hoverfy:Show", { Key = "E", Title = "Pegar malote", Legend = "Pressione E para pegar o malote" })
				end

				if IsControlJustPressed(0, 38) then
					local pickupResult = vSERVER.TryPickup(atm)

					if not pickupResult then
						TriggerEvent("Notify", "Erro", "Não foi possível pegar o malote.", "vermelho", 8000)
						break
					end

					cancelPlayer(true)
					FreezeEntityPosition(ped, true)
					vRP.playAnim(true, { "amb@world_human_bum_wash@male@high@base", "base" }, false)

					if propList[closestIdx] and propList[closestIdx].prop and DoesEntityExist(propList[closestIdx].prop) then
						DeleteEntity(propList[closestIdx].prop)
					end
					propList[closestIdx] = nil
					remaining = remaining - 1

					local timeout = GetGameTimer() + 1500
					repeat
						Wait(10)
					until GetGameTimer() > timeout

					vRP.stopAnim(true)
					FreezeEntityPosition(ped, false)
					cancelPlayer(false)

					if remaining <= 0 then
						TriggerEvent("Notify", "Sucesso", "Malote recolhido. Fuja da área o mais rápido possível", "verde", 8000)
						break
					end
				end
			else
				if hoverfyActive then
					hoverfyActive = false
					TriggerEvent("hoverfy:Hide")
				end
			end
		elseif dist > 100 then
			ActiveRobberies[atm] = nil
			TriggerEvent("Notify", "Atenção", "Você se afastou demais da área do malote.", "amarelo", 8000)
			break
		end
		Wait(delay)
	end

	for _, v in pairs(propList) do
		if v and v.prop and DoesEntityExist(v.prop) then
			DeleteEntity(v.prop)
		end
	end

	if hoverfyActive then TriggerEvent("hoverfy:Hide") end
	IsPickingUp = false
	IsPlayerStealing = false
	LocalPlayer.state.IsPickingUp = nil
end)

RegisterNetEvent("eletronics:removeDrop", function(atmId)
	if ActiveRobberies[atmId] then
		ActiveRobberies[atmId] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("eletronics:showTimer", function(time)
	SendNUIMessage({ time = time or 60 })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPLOSION (broadcast para quem esta perto, o ladrao ja detona localmente em runRobbery)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("eletronics:Explosion", function(coords)
	AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 2.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("eletronics:openSystem", function()
	if IsPickingUp then
		return
	end

	local targetId = getRobberyLocation(2)

	if not targetId or IsPlayerStealing then
		return TriggerEvent("Notify", "Atenção", "Este caixinha está vazio.", "amarelo", 5000)
	end

	IsPlayerStealing = true
	IsPlayerStealing = runRobbery(targetId)
end)

function getRobberyLocation(radius)
	local coords = GetEntityCoords(PlayerPedId())

	for index, data in pairs(Config.AtmList) do
		if #(data.Cds - coords) <= radius then
			return index
		end
	end

	return nil
end

exports("IsPickingUp", function()
	return IsPickingUp
end)

exports("IsPlayerStealing", function()
	return IsPlayerStealing
end)

exports("GetRobberyLocation", function()
	return getRobberyLocation(2)
end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		for prop, _ in pairs(ActiveProps) do
			if DoesEntityExist(prop) then
				DeleteEntity(prop)
			end
		end
	end
end)-----------------------------------------------------------------------------------------------------------------------------------------
-- ATMS DO PAINEL GESTOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Management:atmsSync", function(List)
	Config.LoadAtms(List)
end)

-- Se o c4 reiniciar sozinho, pede a lista de novo
CreateThread(function()
	TriggerServerEvent("Night_Management:atmsLoad")
end)
