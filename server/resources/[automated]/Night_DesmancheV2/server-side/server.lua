local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

cfg = { locs = {}, prohibiteVehicles = {} }

vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

local ActiveChops = {}
local GlobalShelves = {} -- Only used for server references if needed

local function hasDesmanchePermission(pass, permStr)
    if not permStr or permStr == "" then return true end
    
    local orPerms = {}
    for perm in string.gmatch(permStr, "([^;]+)") do
        table.insert(orPerms, perm)
    end
    
    for _, pStr in ipairs(orPerms) do
        local parts = {}
        for part in string.gmatch(pStr, "([^,]+)") do
            table.insert(parts, part)
        end
        local groupName = parts[1]
        local groupLevel = 1
        if parts[2] then groupLevel = tonumber(parts[2]) or 1 end
        
        if vRP.HasPermission(pass, groupName) or vRP.HasGroup(pass, groupName, groupLevel) then
            return true
        end
    end
    
    return false
end

local BONE_ORDER = {
    'door_dside_f',
    'door_pside_f',
    'door_dside_r',
    'door_pside_r',
    'bonnet',
    'boot',
    'wheel_lf',
    'wheel_rf',
    'wheel_lr',
    'wheel_rr',
    'wheel_lm1',
    'wheel_rm1',
    'wheel_f',
    'wheel_r',
    'engine'
}

local function getChopBones()
    local bones = {}

    for _, bone in ipairs(BONE_ORDER) do
        bones[#bones + 1] = bone
    end

    return bones
end

local function getPlayersNearCoords(coords, radius, ignoreSource)
    local list = {}

    for _, playerId in ipairs(GetPlayers()) do
        local src = tonumber(playerId)
        if src and src ~= ignoreSource then
            local ped = GetPlayerPed(src)
            if ped and ped ~= 0 then
                local playerCoords = GetEntityCoords(ped)
                if #(playerCoords - coords) <= radius then
                    list[#list + 1] = src
                end
            end
        end
    end

    return list
end

local function broadcastChop(chopIndex, eventName, ...)
    local chop = ActiveChops[chopIndex]
    if not chop then
        return
    end

    local sent = {}

    for _, participant in ipairs(chop.participants) do
        if not sent[participant] then
            sent[participant] = true
            TriggerClientEvent(eventName, participant, chopIndex, ...)
        end
    end
end

local function finishChop(chopIndex)
    local chop = ActiveChops[chopIndex]
    if not chop or chop.finished then
        return
    end

    chop.finished = true

    do
        local loc = cfg.locs[chopIndex]
        local price = 0
        
        pcall(function()
            local list = exports.vrp:VehicleList()
            if list then
                for name, data in pairs(list) do
                    if GetHashKey(name) == chop.modelHash then
                        price = exports.vrp:VehiclePrice(name) or 0
                        break
                    end
                end
            end
        end)

        if price == 0 then 
            TriggerClientEvent("Notify", chop.leader, "Atenção", "Este veículo não possui valor registrado, portanto você não recebeu nada.", "amarelo", 5000)
        else
            price = math.floor(price * loc.paymentMultiplier / 100)
            if price > 0 then
                vRP.GenerateItem(chop.leader, loc.darkMoneyItem, price, true)
                TriggerClientEvent("Notify", chop.leader, "Atenção", "Você recebeu R$".. Dotted(price).. " por desmanchar o veículo!", "verde", 5000)
            end
        end
    end

    do
        local passport = vRP.PassportPlate(chop.plate:gsub("%s+", ""))
        if type(passport) == "table" then passport = passport.Passport end
        if passport then vRP.Query("vehicles/arrestVehicles", { Passport = passport, vehicle = chop.modelHash }) end
    end

    do
        local vehicle = NetworkGetEntityFromNetworkId(chop.vehNet)
        if DoesEntityExist(vehicle) then 
            TriggerEvent("garages:Delete", chop.vehNet, chop.plate)
        end
    end

    broadcastChop(chopIndex, 'Night_DesmancheV2:endChop')
    ActiveChops[chopIndex] = nil
end

local function allBonesRemoved(chop)
    for _, bone in ipairs(chop.bones) do
        if not chop.removedBones[bone] then
            return false
        end
    end

    return true
end

local function startRemovingPhase(chopIndex)
    local chop = ActiveChops[chopIndex]
    if not chop then
        return
    end

    chop.phase = 'removing'
    chop.waitEndsAt = nil

    local finishTime = tonumber(cfg.timeToFinish) or 10

    for _, participantId in ipairs(chop.participants) do
        TriggerClientEvent("Notify", participantId, "Atenção", "O desmanche começou! Vocês têm " .. finishTime .. " minutos para finalizá-lo, caso contrário o veículo será deletado.", "amarelo", 10000)
    end

    broadcastChop(chopIndex, 'Night_DesmancheV2:startRemoving', {
        vehNet = chop.vehNet,
        shelf = chop.shelf,
        bones = chop.bones,
        removedBones = chop.removedBones,
        removingBones = chop.removingBones,
        carrying = chop.carrying
    })
end

RegisterNetEvent('Night_DesmancheV2:requestStart', function(chopIndex, vehNet, plate, modelHash, validBones)
    local source = source
    chopIndex = tonumber(chopIndex)
    vehNet = tonumber(vehNet)
    modelHash = tonumber(modelHash)
    validBones = validBones or getChopBones()

    if not chopIndex or not cfg.locs[chopIndex] or not vehNet or not modelHash then
        return
    end

    if ActiveChops[chopIndex] then
        TriggerClientEvent("Notify", source, "Atenção", "Esse lugar está tendo um desmanche! Aguarde!", "vermelho", 5000)
        return
    end

    for index, active in pairs(ActiveChops) do
        if active.vehNet == vehNet then
            TriggerClientEvent("Notify", source, "Atenção", "Esse veículo está detido e não pode ser desmanchado!", "vermelho", 5000)
            return
        end
    end

    if not (function()
        local pass = vRP.Passport(source)
        local perm = cfg.locs[chopIndex].permission
        return hasDesmanchePermission(pass, perm)
    end)() then
        TriggerClientEvent("Notify", source, "Atenção", "Você não tem permissão de usar esse desmanche.", "vermelho", 5000)
        return
    end

    if not not cfg.prohibiteVehicles[modelHash] then
        TriggerClientEvent("Notify", source, "Atenção", "Você está tentando desmanchar um veículo proibido.", "vermelho", 5000)
        return
    end

    if not (function()
        local pass = vRP.Passport(source)
        local owner = vRP.PassportPlate(plate:gsub("%s+", ""))
        if type(owner) == "table" then owner = owner.Passport end

        if not owner and not cfg.canChopNPCVehicles then
            TriggerClientEvent("Notify", source, "Atenção", "Você não pode desmanchar esse veículo (Sem registro/NPC).", "amarelo", 5000)
            return false
        end

        if owner == pass and not cfg.autoChop then
            TriggerClientEvent("Notify", source, "Atenção", "Você não pode desmanchar o seu próprio veículo.", "vermelho", 5000)
            return false
        end
        return true
    end)() then
        return
    end

    if not true then
        return
    end

    local loc = cfg.locs[chopIndex]
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if not vehicle or vehicle == 0 then
        TriggerClientEvent("Notify", source, "Atenção", "Este veículo não pode ser desmanchado.", "vermelho", 5000)
        return
    end

    local vehCoords = GetEntityCoords(vehicle)
    if #(vehCoords - loc.blip) > 25.0 then
        TriggerClientEvent("Notify", source, "Atenção", "Chegue mais perto do veículo que será desmanchado.", "vermelho", 5000)
        return
    end

    if loc.requireItem and loc.requireItemAmount then
        if not (function()
            local pass = vRP.Passport(source)
            local consult = vRP.ConsultItem(pass, loc.requireItem, loc.requireItemAmount)
            if consult then
                if vRP.TakeItem(pass, consult.Item, loc.requireItemAmount, true, consult.Slot) then
                    return true
                end
            end
            return false
        end)() then
            TriggerClientEvent("Notify", source, "Atenção", "Você precisa de "..loc.requireItemAmount.."x "..loc.requireItem..".", "vermelho", 5000)
            return
        end
    end

    local participants = { source }
    local waitTime = tonumber(cfg.timeWaitBeforeStart)

    ActiveChops[chopIndex] = {
        startTime = os.time(),
        leader = source,
        participants = participants,
        vehNet = vehNet,
        plate = plate,
        modelHash = modelHash,
        shelf = loc.shelf,
        phase = 'waiting',
        bones = validBones,
        removedBones = {},
        removingBones = {},
        carrying = {},
        waitEndsAt = os.time() + waitTime,
        finished = false,
        radiusPlayers = {}
    }

    local radiusPlayers = getPlayersNearCoords(vehCoords, tonumber(cfg.distanceToSeeText) or 20.0, source)
    table.insert(radiusPlayers, source)
    ActiveChops[chopIndex].radiusPlayers = radiusPlayers
    for _, ply in ipairs(radiusPlayers) do
        TriggerClientEvent('Night_DesmancheV2:beginWait', ply, chopIndex, waitTime, vehNet, source)
    end
end)

RegisterNetEvent('Night_DesmancheV2:cancelChop', function(chopIndex)
    local source = source
    local chop = ActiveChops[chopIndex]
    if chop and chop.leader == source and chop.phase == 'waiting' then
        ActiveChops[chopIndex] = nil
        TriggerClientEvent("Notify", source, "Atenção", "Você saiu do veículo. O desmanche foi cancelado.", "vermelho", 5000)
    end
end)

RegisterNetEvent('Night_DesmancheV2:syncPassengers', function(chopIndex, passengers)
    local source = source
    local chop = ActiveChops[chopIndex]
    
    if not chop or chop.leader ~= source or chop.phase ~= 'waiting' then
        return
    end

    local finalParticipants = { source }
    for _, passengerId in ipairs(passengers) do
        if passengerId ~= source then
            if (function()
                local pass = vRP.Passport(passengerId)
                local perm = cfg.locs[chopIndex].permission
                return hasDesmanchePermission(pass, perm)
            end)() then
                table.insert(finalParticipants, passengerId)
            else
                TriggerClientEvent("Notify", passengerId, "Atenção", "Você não tem permissão de usar esse desmanche.", "vermelho", 5000)
            end
        end
    end
    
    chop.participants = finalParticipants

    for _, ply in ipairs(chop.radiusPlayers) do
        local isParticipant = false
        for _, p in ipairs(finalParticipants) do
            if ply == p then isParticipant = true break end
        end
        if not isParticipant then
            TriggerClientEvent('Night_DesmancheV2:endChop', ply, chopIndex)
        end
    end

    startRemovingPhase(chopIndex)
end)

RegisterNetEvent('Night_DesmancheV2:tryRemoveBone', function(chopIndex, bone)
    local source = source
    chopIndex = tonumber(chopIndex)
    local chop = ActiveChops[chopIndex]

    if not chop or chop.phase ~= 'removing' or chop.finished then
        return
    end

    chop.removingBones[bone] = nil
    broadcastChop(chopIndex, 'Night_DesmancheV2:syncRemoving', chop.removingBones)

    if chop.carrying[source] then
        TriggerClientEvent("Notify", source, "Atenção", "Aguarde um pouco", "amarelo", 5000)
        return
    end

    if chop.removedBones[bone] then
        TriggerClientEvent("Notify", source, "Atenção", "Essa parte já foi removida do veículo", "amarelo", 5000)
        return
    end

    local valid = false
    for _, allowed in ipairs(chop.bones) do
        if allowed == bone then
            valid = true
            break
        end
    end

    if not valid then
        return
    end

    chop.carrying[source] = bone
    broadcastChop(chopIndex, 'Night_DesmancheV2:syncCarrying', chop.carrying)
    broadcastChop(chopIndex, 'Night_DesmancheV2:boneRemoved', bone, source)
end)

RegisterNetEvent('Night_DesmancheV2:startRemovingAnim', function(chopIndex, bone)
    local source = source
    chopIndex = tonumber(chopIndex)
    local chop = ActiveChops[chopIndex]
    
    if not chop or chop.phase ~= 'removing' or chop.finished then return end

    if chop.removingBones[bone] or chop.removedBones[bone] then
        TriggerClientEvent("Notify", source, "Atenção", "Essa peça já está sendo removida por outra pessoa.", "amarelo", 5000)
        return
    end

    chop.removingBones[bone] = source
    broadcastChop(chopIndex, 'Night_DesmancheV2:syncRemoving', chop.removingBones)
    TriggerClientEvent('Night_DesmancheV2:animAllowed', source, chopIndex, bone)
end)

RegisterNetEvent('Night_DesmancheV2:tryDeliverBone', function(chopIndex)
    local source = source
    chopIndex = tonumber(chopIndex)
    local chop = ActiveChops[chopIndex]

    if not chop or chop.phase ~= 'removing' or chop.finished then
        return
    end

    local bone = chop.carrying[source]
    if not bone then
        return
    end

    chop.carrying[source] = nil
    chop.removedBones[bone] = true

    broadcastChop(chopIndex, 'Night_DesmancheV2:syncCarrying', chop.carrying)
    broadcastChop(chopIndex, 'Night_DesmancheV2:syncRemoved', chop.removedBones)

    if allBonesRemoved(chop) then
        chop.phase = "waiting_finish"
        broadcastChop(chopIndex, "Night_DesmancheV2:readyToFinish")
    end
end)

RegisterNetEvent("Night_DesmancheV2:requestFinishChop", function(chopIndex)
    local source = source
    chopIndex = tonumber(chopIndex)
    local chop = ActiveChops[chopIndex]

    if not chop or chop.phase ~= "waiting_finish" or chop.finished then
        return
    end

    if source ~= chop.leader then
        TriggerClientEvent("Notify", source, "Atenção", "Apenas quem iniciou o desmanche pode finalizar.", "vermelho", 5000)
        return
    end

    finishChop(chopIndex)
end)

RegisterNetEvent('Night_DesmancheV2:cancelChop', function(chopIndex)
    chopIndex = tonumber(chopIndex)
    local chop = ActiveChops[chopIndex]

    if not chop then
        return
    end

    broadcastChop(chopIndex, 'Night_DesmancheV2:endChop')
    ActiveChops[chopIndex] = nil
end)

AddEventHandler('playerDropped', function()
    local source = source

    for chopIndex, chop in pairs(ActiveChops) do
        if chop.leader == source then
            broadcastChop(chopIndex, 'Night_DesmancheV2:endChop')
            ActiveChops[chopIndex] = nil
        else
            for index, participant in ipairs(chop.participants) do
                if participant == source then
                    table.remove(chop.participants, index)
                    chop.carrying[source] = nil
                    break
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        local currentTime = os.time()
        for index, chop in pairs(ActiveChops) do
            local finishTimeSeconds = (tonumber(cfg.timeToFinish) or 10) * 60
            if chop.startTime and (currentTime - chop.startTime) > finishTimeSeconds then
                TriggerClientEvent("Notify", chop.leader, "Atenção", "O tempo limite de " .. (cfg.timeToFinish or 10) .. " minutos para desmanchar o veículo expirou.", "vermelho", 10000)
                local vehicle = NetworkGetEntityFromNetworkId(chop.vehNet)
                if DoesEntityExist(vehicle) then 
                    TriggerEvent("garages:Delete", chop.vehNet, chop.plate)
                end
                TriggerClientEvent("Night_DesmancheV2:endChop", -1, index)
                ActiveChops[index] = nil
            end
        end
    end
end)


RegisterNetEvent("Night_DesmancheV2:updateLocations")
AddEventHandler("Night_DesmancheV2:updateLocations", function()
    local desmanches = exports["Night_Management"]:getDesmanches()
    cfg.locs = {}
    if desmanches then
        for _, v in ipairs(desmanches) do
            local config = json.decode(v.Configuration)
            if config then
                config.id = v.id
                if config.blip then
                    config.blip = vec3(config.blip.x, config.blip.y, config.blip.z)
                end
                if config.shelf and config.shelf.cds then
                    config.shelf.cds = vec3(config.shelf.cds.x, config.shelf.cds.y, config.shelf.cds.z)
                end
                table.insert(cfg.locs, config)
            end
        end
    end
    TriggerClientEvent("Night_DesmancheV2:updateLocationsClient", -1, cfg.locs)
end)

RegisterNetEvent("Night_DesmancheV2:updateGlobals")
AddEventHandler("Night_DesmancheV2:updateGlobals", function()
    local globals = exports["Night_Management"]:getSettings("desmanche")
    if globals then
        cfg.timeWaitBeforeStart = globals.timeWaitBeforeStart
        cfg.timeToFinish = globals.timeToFinish
        cfg.animationTime = globals.animationTime
        cfg.distanceToSeeText = globals.distanceToSeeText
        cfg.shelfObjectName = globals.shelfObjectName
        cfg.canChopNPCVehicles = globals.canChopNPCVehicles
        cfg.autoChop = globals.autoChop
        
        cfg.prohibiteVehicles = {}
        if globals.prohibiteVehicles then
            for _, hashName in ipairs(globals.prohibiteVehicles) do
                cfg.prohibiteVehicles[joaat(hashName)] = true
            end
        end
    end
    TriggerClientEvent("Night_DesmancheV2:updateGlobalsClient", -1, cfg)
end)

RegisterNetEvent("Night_Management:requestDesmanches")
AddEventHandler("Night_Management:requestDesmanches", function()
    TriggerEvent("Night_DesmancheV2:updateGlobals")
    TriggerEvent("Night_DesmancheV2:updateLocations")
end)

AddEventHandler("desmanche:updateCache", function()
    TriggerEvent("Night_DesmancheV2:updateGlobals")
    TriggerEvent("Night_DesmancheV2:updateLocations")
end)

AddEventHandler("Connect", function(user_id, source)
    TriggerClientEvent("Night_DesmancheV2:updateGlobalsClient", source, cfg)
    TriggerClientEvent("Night_DesmancheV2:updateLocationsClient", source, cfg.locs or {})
end)

RegisterNetEvent("Night_DesmancheV2:requestData")
AddEventHandler("Night_DesmancheV2:requestData", function()
    local source = source
    TriggerClientEvent("Night_DesmancheV2:updateGlobalsClient", source, cfg)
    TriggerClientEvent("Night_DesmancheV2:updateLocationsClient", source, cfg.locs or {})
end)