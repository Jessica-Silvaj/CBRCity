-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
NightServer = Tunnel.getInterface("Night_Plushies")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Gemstone = 0
local currentPlushie = nil
local currentAnim = nil
local currentAnimData = nil
local currentBlocks = {}
local serverWinner = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLUSHIE MODEL HASHES
-----------------------------------------------------------------------------------------------------------------------------------------
local PlushieModelHashes = {}

local function InitPlushieHashes()
	PlushieModelHashes = {}
	for _, item in pairs(CollectionsCatalog or {}) do
		if item.prop then
			if item.prop.model then
				PlushieModelHashes[GetHashKey(item.prop.model)] = true
			end
			if item.prop.positions then
				for _, pos in ipairs(item.prop.positions) do
					if pos.model then
						PlushieModelHashes[GetHashKey(pos.model)] = true
					elseif item.prop.model then
						PlushieModelHashes[GetHashKey(item.prop.model)] = true
					end
				end
			end
		end
	end
end

CreateThread(function()
	InitPlushieHashes()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
---- ATTACH TOKENS & SLOTS CLEANUP
-----------------------------------------------------------------------------------------------------------------------------------------
local currentPlushies = {}
local slotTokens = {}

function CleanSlot(slot)
	slotTokens[slot] = (slotTokens[slot] or 0) + 1
	local data = currentPlushies[slot]
	if data then
		if DoesEntityExist(data.entity) then
			if NetworkGetEntityIsNetworked(data.entity) then
				TriggerServerEvent("DeleteObject", NetworkGetNetworkIdFromEntity(data.entity))
			end
			DeleteEntity(data.entity)
		end
		currentPlushies[slot] = nil
	end
end

function CleanAllPlushies()
	for slot, _ in pairs(currentPlushies) do
		CleanSlot(slot)
	end
	currentPlushies = {}

	-- Limpa qualquer objeto de pelúcia anexado ao Ped que tenha ficado órfão
	local Ped = PlayerPedId()
	for _, obj in ipairs(GetGamePool("CObject")) do
		if DoesEntityExist(obj) and GetEntityAttachedTo(obj) == Ped then
			local model = GetEntityModel(obj)
			if PlushieModelHashes[model] then
				if NetworkGetEntityIsNetworked(obj) then
					TriggerServerEvent("DeleteObject", NetworkGetNetworkIdFromEntity(obj))
				end
				DeleteEntity(obj)
			end
		end
	end

	if currentAnimData then
		StopAnimTask(Ped, currentAnimData.dict, currentAnimData.name, 3.0)
	end
	currentAnimData = nil
	currentBlocks = {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE ACTIVE ANIM & BLOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdateActiveAnimAndBlocks()
	local Ped = PlayerPedId()
	local foundAnim = nil
	local blocks = { run = false, hit = false }

	for _, data in pairs(currentPlushies) do
		if data.anim and not foundAnim then
			foundAnim = data.anim
		end
		if data.blocks then
			if data.blocks.run then blocks.run = true end
			if data.blocks.hit then blocks.hit = true end
		end
	end

	currentBlocks = blocks

	if foundAnim then
		currentAnimData = foundAnim
		if not IsEntityPlayingAnim(Ped, foundAnim.dict, foundAnim.name, 3) then
			if not IsPedRagdoll(Ped) and not IsPedClimbing(Ped) and not IsPedJumping(Ped) then
				TaskPlayAnim(Ped, foundAnim.dict, foundAnim.name, 8.0, 8.0, -1, foundAnim.flag, 1, 0, 0, 0)
			end
		end
	else
		if currentAnimData then
			StopAnimTask(Ped, currentAnimData.dict, currentAnimData.name, 3.0)
		end
		currentAnimData = nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
local function OpenPlushiesHandler()
	local data = NightServer.getData()
	if not data then 
		data = { gems = 0, price = 250 }
	end

	Gemstone = data.gems or 0
	SetNuiFocus(true, true)

	local themeData = {}
	if _G.Theme then
		themeData = {
			main = _G.Theme.main,
			common = _G.Theme.common,
			rare = _G.Theme.rare,
			epic = _G.Theme.epic,
			legendary = _G.Theme.legendary
		}
	end

	-- Filtra pelúcias ocultas (reservadas para reintegração)
	local filteredCatalog = {}
	for id, item in pairs(CollectionsCatalog or {}) do
		if not item.hidden then
			filteredCatalog[id] = item
		end
	end

	local currentEquipped = LocalPlayer.state.plushies or {}

	SendNUIMessage({
		action = "open",
		catalog = filteredCatalog,
		gems = Gemstone,
		price = data.price or 250,
		theme = themeData,
		equipped = currentEquipped
	})

	TriggerEvent("dynamic:Close")
	TriggerEvent("hud:Active", false)
end

RegisterNetEvent("Night_Plushies:Open")
AddEventHandler("Night_Plushies:Open", OpenPlushiesHandler)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ADDGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:AddGemstone")
AddEventHandler("hud:AddGemstone",function(Number)
	Gemstone = Gemstone + Number

	SendNUIMessage({ action = "updateGems", gems = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveGemstone")
AddEventHandler("hud:RemoveGemstone",function(Number)
	Gemstone = Gemstone - Number

	if Gemstone < 0 then
		Gemstone = 0
	end

	SendNUIMessage({ action = "updateGems", gems = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EQUIPPLUSHIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("equipPlushie", function(data, cb)
	if not data.id or data.id == "none" then
		CleanAllPlushies()
		LocalPlayer.state:set("plushies", {}, false)
		LocalPlayer.state:set("plushie", { id = "none" }, false)
	end
	NightServer.equipPlushie(data.id, data.position)
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMATION THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
local nextReequip = 0
local nextAnimCheck = 0

CreateThread(function()
	while true do
		local TimeDistance = 1000
		local GameTimer = GetGameTimer()
		local Ped = PlayerPedId()

		-- Anti-bypass: reequipa os slots vazios ou perdidos com intervalo de segurança (4s)
		local statePlushies = LocalPlayer.state.plushies
		if statePlushies and type(statePlushies) == "table" and next(statePlushies) ~= nil then
			if not IsPedInAnyVehicle(Ped) and GetEntityHealth(Ped) > 101 then
				for slot, data in pairs(statePlushies) do
					if data and data.id and data.id ~= "none" then
						local current = currentPlushies[slot]
						if (not current or not DoesEntityExist(current.entity)) and GameTimer > nextReequip then
							nextReequip = GameTimer + 4000
							AttachPlushieSlot(slot, data.id, data.position)
						end
					end
				end
			end
		end

		if currentAnimData then
			if GetEntityHealth(Ped) > 101 then
				TimeDistance = 1

				-- Verifica se precisa restaurar a animação a cada 1.5s
				if GameTimer > nextAnimCheck then
					nextAnimCheck = GameTimer + 1500
					if not IsEntityPlayingAnim(Ped, currentAnimData.dict, currentAnimData.name, 3) then
						if not IsPedRagdoll(Ped) and not IsPedClimbing(Ped) and not IsPedJumping(Ped) then
							TaskPlayAnim(Ped, currentAnimData.dict, currentAnimData.name, 8.0, 8.0, -1, currentAnimData.flag, 1, 0, 0, 0)
						end
					end
				end

				if currentBlocks.hit then
					DisableControlAction(0, 18, true)
					DisableControlAction(0, 24, true)
					DisableControlAction(0, 25, true)
					DisableControlAction(0, 257, true)
					DisableControlAction(0, 263, true)
					DisableControlAction(0, 140, true)
					DisableControlAction(0, 141, true)
					DisableControlAction(0, 142, true)
					DisableControlAction(0, 143, true)
					DisablePlayerFiring(Ped, true)
				end

				if currentBlocks.run then
					DisableControlAction(0, 21, true)
					DisableControlAction(0, 22, true)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACH PLUSHIE SLOT
-----------------------------------------------------------------------------------------------------------------------------------------
function AttachPlushieSlot(slot, plushieId, positionId)
	slotTokens[slot] = (slotTokens[slot] or 0) + 1
	local myToken = slotTokens[slot]

	local item = CollectionsCatalog[plushieId]
	if not item or not item.prop then return end

	local propData = item.prop
	local posData = nil

	if positionId and propData.positions then
		for _, pos in ipairs(propData.positions) do
			if pos.id == positionId then
				posData = pos
				break
			end
		end
	end

	if not posData and propData.positions and #propData.positions > 0 then
		posData = propData.positions[1]
	elseif not posData then
		posData = propData
	end

	if not posData then return end

	local model = posData.model or propData.model
	if not model then return end

	local animDict = (posData.anim and posData.anim.dict) or ""
	local animName = (posData.anim and posData.anim.name) or ""
	local animFlag = (posData.anim and posData.anim.flag) or 49
	local isMonkey = (item.category == "Caquinhos")
	local bone = posData.bone or 24818

	CreateThread(function()
		local Ped = PlayerPedId()
		if myToken ~= slotTokens[slot] then return end

		if animDict ~= "" and animName ~= "" then
			LoadAnim(animDict)
			if myToken ~= slotTokens[slot] then return end
		end

		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)
			local Hash = type(model) == "string" and GetHashKey(model) or model

			if not HasModelLoaded(Hash) then
				RequestModel(Hash)
				local Timeout = GetGameTimer() + 5000
				while not HasModelLoaded(Hash) and GetGameTimer() < Timeout do
					if myToken ~= slotTokens[slot] then return end
					Wait(10)
				end
			end

			if myToken ~= slotTokens[slot] then return end

			local Entity = nil
			local Networked = vRPS.CreateObject(model, Coords.x, Coords.y, Coords.z)
			if myToken ~= slotTokens[slot] then
				if Networked and type(Networked) == "number" and Networked > 0 then
					TriggerServerEvent("DeleteObject", Networked)
				end
				return
			end

			if Networked and type(Networked) == "number" and Networked > 0 then
				Entity = LoadNetwork(Networked)
			end

			if myToken ~= slotTokens[slot] then
				if Entity and DoesEntityExist(Entity) then
					if NetworkGetEntityIsNetworked(Entity) then
						TriggerServerEvent("DeleteObject", NetworkGetNetworkIdFromEntity(Entity))
					end
					DeleteEntity(Entity)
				end
				return
			end

			if not Entity or not DoesEntityExist(Entity) then
				Entity = CreateObject(Hash, Coords.x, Coords.y, Coords.z - 2.0, true, true, false)
			end

			if myToken ~= slotTokens[slot] then
				if Entity and DoesEntityExist(Entity) then
					DeleteEntity(Entity)
				end
				return
			end

			if not Entity or not DoesEntityExist(Entity) then return end

			-- Com sv_filterRequestControl 4 só dá para anexar se tiver o controle da entidade criada pelo servidor
			if NetworkGetEntityIsNetworked(Entity) and not NetworkHasControlOfEntity(Entity) then
				local ControlTimeout = GetGameTimer() + 1500
				while not NetworkHasControlOfEntity(Entity) and GetGameTimer() < ControlTimeout do
					NetworkRequestControlOfEntity(Entity)
					Wait(10)
				end
			end

			-- Limpa o slot anterior se houver
			CleanSlot(slot)

			SetEntityLodDist(Entity, 0xFFFF)
			SetEntityCollision(Entity, false, false)
			SetEntityCompletelyDisableCollision(Entity, true, true)
			SetEntityNoCollisionEntity(Entity, Ped, true)

			local px, py, pz = 0.0, 0.0, 0.0
			local rx, ry, rz = 0.0, 0.0, 0.0

			if posData.pos then
				px = (posData.pos.x or posData.pos[1] or 0.0) + 0.0
				py = (posData.pos.y or posData.pos[2] or 0.0) + 0.0
				pz = (posData.pos.z or posData.pos[3] or 0.0) + 0.0
			end

			if posData.rot then
				rx = (posData.rot.x or posData.rot[1] or 0.0) + 0.0
				ry = (posData.rot.y or posData.rot[2] or 0.0) + 0.0
				rz = (posData.rot.z or posData.rot[3] or 0.0) + 0.0
			end

			local boneTarget = bone or 24818
			local boneIndex = 0
			if type(boneTarget) == "number" then
				boneIndex = GetPedBoneIndex(Ped, boneTarget)
			elseif type(boneTarget) == "string" then
				boneIndex = GetEntityBoneIndexByName(Ped, boneTarget)
			end

			if not boneIndex or boneIndex == -1 then
				boneIndex = 0
			end

			AttachEntityToEntity(Entity, Ped, boneIndex, px, py, pz, rx, ry, rz, true, true, false, true, 1, true)

			if isMonkey and animDict ~= "" and animName ~= "" then
				PlayEntityAnim(Entity, animName, animDict, 1000.0, true, true, true, 0.0, false)
			end

			currentPlushies[slot] = {
				entity = Entity,
				id = plushieId,
				position = positionId,
				token = myToken,
				anim = (animDict ~= "" and animName ~= "") and { dict = animDict, name = animName, flag = animFlag } or nil,
				blocks = item.blocks or {}
			}

			UpdateActiveAnimAndBlocks()
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADNETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadNetwork(Network)
	local Timeout = GetGameTimer() + 5000
	while not NetworkDoesEntityExistWithNetworkId(Network) do
		if GetGameTimer() > Timeout then
			return false
		end
		Wait(10)
	end

	local Entitys = NetToEnt(Network)
	if not DoesEntityExist(Entitys) then
		return false
	end

	Timeout = GetGameTimer() + 5000
	NetworkRequestControlOfEntity(Entitys)
	while not NetworkHasControlOfEntity(Entitys) do
		if GetGameTimer() > Timeout then
			return false
		end
		Wait(10)
	end

	SetEntityAsMissionEntity(Entitys, true, true)
	return Entitys
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadAnim(Dict)
	if not HasAnimDictLoaded(Dict) then
		RequestAnimDict(Dict)

		local Timeout = GetGameTimer() + 10000
		while not HasAnimDictLoaded(Dict) do
			if GetGameTimer() > Timeout then
				return false
			end

			Wait(0)
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC PLUSHIES HANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
local function SyncPlushiesHandler(newEquipped)
	newEquipped = newEquipped or {}

	-- 1. Remove qualquer slot que não esteja mais na lista ou cujos dados mudaram
	for slot, current in pairs(currentPlushies) do
		local target = newEquipped[slot]
		if not target or target.id ~= current.id or target.position ~= current.position then
			CleanSlot(slot)
		end
	end

	-- 2. Carrega novos slots
	for slot, data in pairs(newEquipped) do
		if data and data.id and data.id ~= "none" then
			if not currentPlushies[slot] then
				AttachPlushieSlot(slot, data.id, data.position)
			end
		end
	end

	UpdateActiveAnimAndBlocks()

	-- Atualiza NUI caso esteja aberta
	SendNUIMessage({
		action = "syncPlushies",
		equipped = newEquipped
	})
end

RegisterNetEvent("Night_Plushies:syncPlushies")
AddEventHandler("Night_Plushies:syncPlushies", SyncPlushiesHandler)

local function LegacyAttachHandler(plushieId, positionId)
	if not plushieId or plushieId == "none" or plushieId == "" then
		CleanAllPlushies()
		LocalPlayer.state:set("plushies", {}, false)
		return
	end

	local slot = GetPlushieSlot(plushieId, positionId)
	AttachPlushieSlot(slot, plushieId, positionId)
end

RegisterNetEvent("Night_Plushies:attachProp")
AddEventHandler("Night_Plushies:attachProp", LegacyAttachHandler)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELPLUSHIE
-----------------------------------------------------------------------------------------------------------------------------------------
local function CancelPlushieHandler()
	CleanAllPlushies()
	LocalPlayer.state:set("plushies", {}, false)
	LocalPlayer.state:set("plushie", { id = "none" }, false)
	NightServer.equipPlushie("none")
end

RegisterNetEvent("Night_Plushies:cancelPlushie")
AddEventHandler("Night_Plushies:cancelPlushie", CancelPlushieHandler)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(data, cb)
	TriggerEvent("hud:Active", true)
	SetNuiFocus(false, false)
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
local function ClosePlushiesHandler()
	SendNUIMessage({ action = "close" })
	SetNuiFocus(false, false)
	TriggerEvent("hud:Active", true)
end

RegisterNetEvent("Night_Plushies:close")
AddEventHandler("Night_Plushies:close", ClosePlushiesHandler)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERPLUSHIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("transferPlushie", function(data, cb)
	NightServer.transferPlushie(data.id)
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYSPIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("trySpin", function(data, cb)
	local result = NightServer.spinRoulette()

	if result and type(result) == "table" and result.success then
		serverWinner = result.winner
		cb(result) -- Retorna o objeto completo { success = true, winner = ... }
	else
		serverWinner = nil
		cb({ success = false })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINNOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("winNotify", function(data, cb)
	if serverWinner then
		TriggerServerEvent("Night_Plushies:winPlushie", serverWinner.id)
		TriggerEvent("Notify", "Sucesso", "Parabéns! Você ganhou uma <b>" .. serverWinner.name .. "</b>", "verde", 5000)

		serverWinner = nil
	end

	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMYPLUSHIES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getMyPlushies", function(data, cb)
	local plushies = NightServer.getPlushies()
	cb(plushies or {})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTOTALPLUSHIES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getTotalPlushies", function(data, cb)
	local count = NightServer.getTotalPlushies(data.id)
	cb(count or 0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end

	CleanAllPlushies()

	SendNUIMessage({ action = "close" })
	SetNuiFocus(false, false)
end)