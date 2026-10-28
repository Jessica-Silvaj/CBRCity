local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

cfg = { locs = {}, prohibiteVehicles = {} }

local NightDesmancheServer = Tunnel.getInterface("Night_DesmancheV2")

local LocalChop = nil
local shelfObject = nil
local carriedProp = nil
local animBusy = false
local GlobalShelves = {}
local locallyBrokenBones = {}

local DOOR_INDEX = {
    door_dside_f = 0,
    door_pside_f = 1,
    door_dside_r = 2,
    door_pside_r = 3,
    bonnet = 4,
    boot = 5
}

local WHEEL_INDEX = {
    wheel_lf = 0,
    wheel_rf = 1,
    wheel_lm1 = 2,
    wheel_rm1 = 3,
    wheel_lr = 4,
    wheel_rr = 5,
    wheel_f = 0,
    wheel_r = 4
}

local function drawText3D(x, y, z, text)
    local onScreen, sx, sy = World3dToScreen2d(x, y, z)
    if not onScreen then
        return
    end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(sx, sy)
end


local function getVehicleFromNet(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local timeout = GetGameTimer() + 5000

    while (not entity or entity == 0 or not DoesEntityExist(entity)) and GetGameTimer() < timeout do
        entity = NetworkGetEntityFromNetworkId(netId)
        Wait(0)
    end

    return entity
end

local function getBoneCoords(vehicle, boneName)
    local index = GetEntityBoneIndexByName(vehicle, boneName)
    if index == -1 then
        return GetEntityCoords(vehicle)
    end

    return GetWorldPositionOfEntityBone(vehicle, index)
end

local function breakVehicleBone(vehicle, bone)
    local door = DOOR_INDEX[bone]
    if door then
        SetVehicleDoorBroken(vehicle, door, true)
        return
    end

    local wheel = WHEEL_INDEX[bone]
    if wheel then
        SetVehicleTyreBurst(vehicle, wheel, true, 1000.0)
    end
end

local function clearCarriedProp()
    if carriedProp and DoesEntityExist(carriedProp) then
        DetachEntity(carriedProp, true, true)
        DeleteEntity(carriedProp)
    end

    carriedProp = nil
    ClearPedTasks(PlayerPedId())
end

local wheelOffsets = {
    vec3(-1.05, -0.25, 1.85), vec3(-0.35, -0.25, 1.85), vec3(0.35, -0.25, 1.85), vec3(1.05, -0.25, 1.85),
    vec3(-1.05, 0.25, 1.85), vec3(-0.35, 0.25, 1.85), vec3(0.35, 0.25, 1.85), vec3(1.05, 0.25, 1.85)
}

local flatOffsets = {
    vec3(-0.4, 0.0, 0.1), vec3(-0.1, 0.0, 0.1), vec3(0.2, 0.0, 0.1),
    vec3(0.5, 0.0, 0.1), vec3(0.8, 0.0, 0.1), vec3(1.1, 0.0, 0.1)
}

local function getCurrentBoneGroup()
    if not LocalChop then return 5 end
    local hasWheels = false
    local hasDoors = false
    local hasHoodTrunk = false
    local hasEngine = false

    for _, b in ipairs(LocalChop.bones or {}) do
        if not LocalChop.removedBones[b] then
            if string.find(b, 'wheel') then
                hasWheels = true
            elseif string.find(b, 'door') then
                hasDoors = true
            elseif b == 'bonnet' or b == 'boot' then
                hasHoodTrunk = true
            elseif b == 'engine' then
                hasEngine = true
            end
        end
    end

    if hasWheels then return 1 end
    if hasDoors then return 2 end
    if hasHoodTrunk then return 3 end
    if hasEngine then return 4 end
    return 5
end

local function getPropForBone(bone)
    if bone and string.find(bone, 'wheel') then
        return joaat('prop_wheel_tyre')
    elseif bone == 'engine' then
        return joaat('prop_car_engine_01')
    else
        return joaat('prop_car_door_01')
    end
end

local function updateShelfProps()
    if not LocalChop or not shelfObject then return end
    
    if not LocalChop.shelfProps then
        LocalChop.shelfProps = {}
        LocalChop.doorPropCount = 0
        LocalChop.wheelPropCount = 0
    end
    
    for bone, removed in pairs(LocalChop.removedBones) do
        if removed and not LocalChop.shelfProps[bone] then
            local isWheel = string.find(bone, 'wheel')
            local isEngine = bone == 'engine'
            local offset
            
            if isWheel then
                LocalChop.wheelPropCount = LocalChop.wheelPropCount + 1
                offset = wheelOffsets[LocalChop.wheelPropCount]
            elseif isEngine then
                if not LocalChop.hasEngineProp then
                    LocalChop.hasEngineProp = true
                    offset = vec3(-1.05, 0.0, 0.03)
                end
            else
                LocalChop.flatPropCount = (LocalChop.flatPropCount or 0) + 1
                offset = flatOffsets[LocalChop.flatPropCount]
            end

            if offset then
                local model = getPropForBone(bone)
                RequestModel(model)
                local timeout = GetGameTimer() + 5000
                while not HasModelLoaded(model) do Wait(0) end
                
                if HasModelLoaded(model) then
                    local coords = GetOffsetFromEntityInWorldCoords(shelfObject, offset.x, offset.y, offset.z)
                    local prop = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
                    SetEntityAsMissionEntity(prop, true, true)
                    
                    if isWheel then
                        SetEntityRotation(prop, 0.0, 90.0, GetEntityHeading(shelfObject), 2, true)
                    elseif isEngine then
                        SetEntityHeading(prop, GetEntityHeading(shelfObject))
                    else
                        SetEntityHeading(prop, GetEntityHeading(shelfObject) + 90.0)
                    end
                    
                    FreezeEntityPosition(prop, true)
                    LocalChop.shelfProps[bone] = prop
                end
            else
                LocalChop.shelfProps[bone] = true
            end
        end
    end
end

local function attachCarryProp(bone)
    clearCarriedProp()

    local ped = PlayerPedId()
    local model = getPropForBone(bone)
    RequestModel(model)

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do
        Wait(0)
    end

    if not HasModelLoaded(model) then
        return
    end

    local coords = GetEntityCoords(ped)
    carriedProp = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    SetEntityAsMissionEntity(carriedProp, true, true)
    
    if bone and string.find(bone, 'wheel') then
        AttachEntityToEntity(carriedProp, ped, GetPedBoneIndex(ped, 28422), 0.0, -0.1, 0.218, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif bone == 'engine' then
        AttachEntityToEntity(carriedProp, ped, GetPedBoneIndex(ped, 28422), 0.0, -0.68, -0.18, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    else
        AttachEntityToEntity(carriedProp, ped, GetPedBoneIndex(ped, 28422), 0.0, -0.08, -0.13, -1.0, 0.0, 0.0, true, true, false, true, 1, true)
    end

    RequestAnimDict('anim@heists@box_carry@')
    while not HasAnimDictLoaded('anim@heists@box_carry@') do
        Wait(0)
    end

    TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 49, 0, false, false, false)
end

local function playRemoveAnim(bone, callback)
    if animBusy then
        return
    end

    animBusy = true
    local ped = PlayerPedId()
    local duration = (cfg.animationTime or 5) * 1000

    if bone and (string.find(bone, 'wheel') or bone == 'engine') then
        local dict = 'amb@medic@standing@tendtodead@idle_a'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
        TaskPlayAnim(ped, dict, 'idle_a', 8.0, -8.0, duration, 1, 0, false, false, false)
        Wait(duration)
        ClearPedTasks(ped)
    elseif bone and string.find(bone, 'door') then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(duration)
        ClearPedTasks(ped)
    else
        local dict = 'mini@repair'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
        TaskPlayAnim(ped, dict, 'fixing_a_player', 8.0, -8.0, duration, 1, 0, false, false, false)
        Wait(duration)
        ClearPedTasks(ped)
    end

    animBusy = false

    if callback then
        callback()
    end
end

local function ensureShelfObject(shelf)
    if LocalChop and GlobalShelves[LocalChop.index] then
        shelfObject = GlobalShelves[LocalChop.index]
    end
end

local function placeVehicleOnShelf(vehicle, shelf)
    if not vehicle or not DoesEntityExist(vehicle) then
        return
    end

    SetVehicleOnGroundProperly(vehicle)
    FreezeEntityPosition(vehicle, true)
    SetEntityInvincible(vehicle, true)
end

local function cleanupLocalChop()
    clearCarriedProp()

    if LocalChop then
        if LocalChop.vehNet then
            local vehicle = NetworkGetEntityFromNetworkId(LocalChop.vehNet)
            if vehicle and vehicle ~= 0 then
                FreezeEntityPosition(vehicle, false)
            end
        end

        if LocalChop.shelfProps then
            for _, prop in pairs(LocalChop.shelfProps) do
                if type(prop) ~= 'boolean' and DoesEntityExist(prop) then
                    DeleteEntity(prop)
                end
            end
        end
    end

    if shelfObject and DoesEntityExist(shelfObject) then
        DeleteEntity(shelfObject)
        shelfObject = nil
    end

    locallyBrokenBones = {}
    LocalChop = nil
    animBusy = false
end

RegisterNetEvent('Night_DesmancheV2:deleteVehicle', function(vehNet)
    local vehicle = getVehicleFromNet(vehNet)
    if vehicle and DoesEntityExist(vehicle) then
        executePluginHandler('deleteVehicle', vehicle, vehNet)
    end
end)

RegisterNetEvent('Night_DesmancheV2:beginWait', function(chopIndex, waitTime, vehNet, leaderSource)
    local mySource = GetPlayerServerId(PlayerId())
    LocalChop = {
        index = chopIndex,
        phase = 'waiting',
        vehNet = vehNet,
        waitEndsAt = GetGameTimer() + (waitTime * 1000),
        removedBones = {},
        removingBones = {},
        carrying = {},
        isLeader = (mySource == leaderSource)
    }
    
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if vehicle and vehicle ~= 0 then
        FreezeEntityPosition(vehicle, true)
    end
end)

RegisterNetEvent('Night_DesmancheV2:startRemoving', function(chopIndex, data)
    if not LocalChop or LocalChop.index ~= chopIndex then
        LocalChop = {
            index = chopIndex,
            phase = 'removing',
            vehNet = data.vehNet,
            shelf = data.shelf,
            bones = data.bones,
            removedBones = data.removedBones or {},
            removingBones = data.removingBones or {},
            carrying = data.carrying or {}
        }
    else
        LocalChop.phase = 'removing'
        LocalChop.shelf = data.shelf
        LocalChop.bones = data.bones
        LocalChop.removedBones = data.removedBones or {}
        LocalChop.removingBones = data.removingBones or {}
        LocalChop.carrying = data.carrying or {}
    end

    local vehicle = getVehicleFromNet(LocalChop.vehNet)
    ensureShelfObject(LocalChop.shelf)
    placeVehicleOnShelf(vehicle, LocalChop.shelf)

    local ped = PlayerPedId()
    if IsPedInVehicle(ped, vehicle, false) then
        TaskLeaveVehicle(ped, vehicle, 0)
    end
end)

RegisterNetEvent('Night_DesmancheV2:syncCarrying', function(chopIndex, carrying)
    if LocalChop and LocalChop.index == chopIndex then
        LocalChop.carrying = carrying or {}
    end
end)

RegisterNetEvent('Night_DesmancheV2:syncRemoved', function(chopIndex, removedBones)
    if LocalChop and LocalChop.index == chopIndex then
        LocalChop.removedBones = removedBones
        updateShelfProps()
    end
end)

RegisterNetEvent('Night_DesmancheV2:syncRemoving', function(chopIndex, removingBones)
    if LocalChop and LocalChop.index == chopIndex then
        LocalChop.removingBones = removingBones
    end
end)

RegisterNetEvent("Night_DesmancheV2:readyToFinish", function(chopIndex)
    if LocalChop and LocalChop.index == chopIndex then
        LocalChop.phase = "waiting_finish"
        if LocalChop.isLeader then
            TriggerEvent("Notify", "Atenção", "Para finalizar o desmanche entre no veículo e aperte E", "verde", 10000)
        else
            TriggerEvent("Notify", "Atenção", "Todas as peças foram removidas! Aguarde o líder finalizar.", "verde", 10000)
        end
    end
end)

RegisterNetEvent('Night_DesmancheV2:boneRemoved', function(chopIndex, bone, removerId)
    if not LocalChop or LocalChop.index ~= chopIndex then
        return
    end

    local vehicle = getVehicleFromNet(LocalChop.vehNet)
    if vehicle and DoesEntityExist(vehicle) then
        locallyBrokenBones[bone] = true
        breakVehicleBone(vehicle, bone)
    end

    if GetPlayerServerId(PlayerId()) == removerId then
        attachCarryProp(bone)
    end
end)

RegisterNetEvent('Night_DesmancheV2:animAllowed', function(chopIndex, bone)
    if not LocalChop or LocalChop.index ~= chopIndex then return end
    
    local vehicle = getVehicleFromNet(LocalChop.vehNet)
    if vehicle and DoesEntityExist(vehicle) then
        if not NetworkHasControlOfEntity(vehicle) then
            NetworkRequestControlOfEntity(vehicle)
            local t = GetGameTimer() + 1500
            while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() < t do
                Wait(100)
            end
        end
    end

    playRemoveAnim(bone, function()
        TriggerServerEvent('Night_DesmancheV2:tryRemoveBone', LocalChop.index, bone)
    end)
end)

RegisterNetEvent('Night_DesmancheV2:endChop', function(chopIndex)
    if not LocalChop or LocalChop.index ~= chopIndex then
        return
    end

    local vehicle = getVehicleFromNet(LocalChop.vehNet)
    local ped = PlayerPedId()
    if vehicle and DoesEntityExist(vehicle) and IsPedInVehicle(ped, vehicle, false) then
        TaskLeaveVehicle(ped, vehicle, 0)
    end

    cleanupLocalChop()
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if not LocalChop then
            for index, loc in ipairs(cfg.locs or {}) do
                if loc.blip then
                    local dist = #(coords - loc.blip)

                    if dist <= (cfg.distanceToSeeText or 20.0) then
                        sleep = 0
                        DrawMarker(23, loc.blip.x, loc.blip.y, loc.blip.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.5, 46, 139, 87, 150, false, false, 2, false, nil, nil, false)

                        local vehicle = GetVehiclePedIsIn(ped, false)

                    if dist <= 3.0 and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then

                        if (IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)) and not animBusy then
                            local vehCoords = GetEntityCoords(vehicle)
                            if #(vehCoords - loc.blip) > 12.0 then
                                TriggerEvent("Notify", "Atenção", "Chegue mais perto do veículo que será desmanchado.", "amarelo",5000)
                            else
                                local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1')
                                local validBones = {}
                                for _, bName in ipairs({'door_dside_f', 'door_pside_f', 'door_dside_r', 'door_pside_r', 'bonnet', 'boot', 'wheel_lf', 'wheel_rf', 'wheel_lr', 'wheel_rr', 'wheel_lm1', 'wheel_rm1', 'wheel_f', 'wheel_r', 'engine'}) do
                                    if GetEntityBoneIndexByName(vehicle, bName) ~= -1 then
                                        table.insert(validBones, bName)
                                    end
                                end
                                
                                TriggerServerEvent(
                                    'Night_DesmancheV2:requestStart',
                                    index,
                                    VehToNet(vehicle),
                                    plate,
                                    GetEntityModel(vehicle),
                                    validBones
                                )
                                end
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if LocalChop and LocalChop.phase == 'waiting' then
            local ped = PlayerPedId()
            local vehicle = getVehicleFromNet(LocalChop.vehNet)
            
            if not vehicle or not DoesEntityExist(vehicle) then
                if LocalChop.isLeader then
                    TriggerServerEvent('Night_DesmancheV2:cancelChop', LocalChop.index)
                end
                cleanupLocalChop()
            else
                local remaining = math.max(0, math.ceil((LocalChop.waitEndsAt - GetGameTimer()) / 1000))
                local vehCoords = GetEntityCoords(vehicle)
                if not LocalChop.isLeader and not IsPedInVehicle(ped, vehicle, false) then
                    drawText3D(vehCoords.x, vehCoords.y, vehCoords.z + 1.0, ('~b~Você tem %s para entrar no veículo e participar do desmanche'):format(remaining .. 's'))
                else
                    drawText3D(vehCoords.x, vehCoords.y, vehCoords.z + 1.0, ('~b~Aguarde %s segundos para iniciar'):format(remaining))
                end

                if LocalChop.isLeader then
                    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
                        TriggerServerEvent('Night_DesmancheV2:cancelChop', LocalChop.index)
                        cleanupLocalChop()
                    end
                end

            if LocalChop and remaining == 0 and LocalChop.isLeader then
                    local passengers = {}
                    for i = 0, 6 do
                        local pedInSeat = GetPedInVehicleSeat(vehicle, i)
                        if pedInSeat ~= 0 and IsPedAPlayer(pedInSeat) then
                            local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(pedInSeat))
                            if serverId > 0 then
                                table.insert(passengers, serverId)
                            end
                        end
                    end
                    TriggerServerEvent('Night_DesmancheV2:syncPassengers', LocalChop.index, passengers)
                    LocalChop.phase = 'syncing'
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 500
        if LocalChop and (LocalChop.phase == 'removing' or LocalChop.phase == 'waiting_finish') then
            sleep = 0
            local vehicle = getVehicleFromNet(LocalChop.vehNet)
            
            if not vehicle or not DoesEntityExist(vehicle) then
                if LocalChop.isLeader then
                    TriggerServerEvent('Night_DesmancheV2:cancelChop', LocalChop.index)
                end
                cleanupLocalChop()
            else
                local ped = PlayerPedId()
                local pedCoords = GetEntityCoords(ped)
                local myServerId = GetPlayerServerId(PlayerId())
                local carryingBone = LocalChop.carrying[myServerId]

                if LocalChop.phase == 'waiting_finish' then
                if vehicle and DoesEntityExist(vehicle) then
                    local shelfCoords = LocalChop.shelf.cds
                    if GetPedInVehicleSeat(vehicle, -1) == ped then
                        if (IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)) and not animBusy then
                            TriggerServerEvent("Night_DesmancheV2:requestFinishChop", LocalChop.index)
                        end
                    end
                end
            else
                if carryingBone then
                    local shelfCoords = LocalChop.shelf.cds
                    DrawMarker(21, shelfCoords.x, shelfCoords.y, shelfCoords.z + 1.0, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, 46, 139, 87, 150, 0, 0, 0, 1)
                    local distShelf = #(pedCoords - shelfCoords)

                    if distShelf <= 2.0 then
                        drawText3D(shelfCoords.x, shelfCoords.y, shelfCoords.z + 0.5, '~b~PRESSIONE ~b~E ~b~PARA ENTREGAR A PEÇA')

                        if (IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)) and not animBusy then
                            playRemoveAnim(nil, function()
                                clearCarriedProp()
                                TriggerServerEvent('Night_DesmancheV2:tryDeliverBone', LocalChop.index)
                            end)
                        end
                    end
                elseif vehicle and DoesEntityExist(vehicle) then
                    local currentGroup = getCurrentBoneGroup()
                    for _, bone in ipairs(LocalChop.bones or {}) do
                        if not LocalChop.removedBones[bone] and not (LocalChop.removingBones and LocalChop.removingBones[bone]) then
                            local isWheel = string.find(bone, 'wheel')
                            local isDoor = string.find(bone, 'door')
                            local isHoodTrunk = bone == 'bonnet' or bone == 'boot'
                            local isEngine = bone == 'engine'

                            local canInteract = false
                            if currentGroup == 1 and isWheel then canInteract = true end
                            if currentGroup == 2 and isDoor then canInteract = true end
                            if currentGroup == 3 and isHoodTrunk then canInteract = true end
                            if currentGroup == 4 and isEngine then canInteract = true end

                            if canInteract then
                                local boneCoords = getBoneCoords(vehicle, bone)
                                DrawMarker(21, boneCoords.x, boneCoords.y, boneCoords.z + 1.0, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, 46, 139, 87, 150, 0, 0, 0, 1)

                                local dist = #(pedCoords - boneCoords)
                                if dist <= 1.8 then
                                    drawText3D(boneCoords.x, boneCoords.y, boneCoords.z + 0.3, '~b~PRESSIONE ~b~E ~b~PARA REMOVER A PEÇA')

                                    if (IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)) and not animBusy then
                                        TriggerServerEvent('Night_DesmancheV2:startRemovingAnim', LocalChop.index, bone)
                                    end
                                end
                            end
                        end
                    end
                    
                    for bone, removed in pairs(LocalChop.removedBones) do
                        if removed and not locallyBrokenBones[bone] then
                            locallyBrokenBones[bone] = true
                            breakVehicleBone(vehicle, bone)
                        end
                    end
                end
            end
        end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("Night_DesmancheV2:updateLocationsClient")
AddEventHandler("Night_DesmancheV2:updateLocationsClient", function(locations)
    cfg.locs = locations
    for _, loc in ipairs(cfg.locs or {}) do
        if loc.blip then 
            loc.blip = vec3(loc.blip.x, loc.blip.y, loc.blip.z) 
        end
        if loc.shelf and loc.shelf.cds then 
            loc.shelf.cds = vec3(loc.shelf.cds.x, loc.shelf.cds.y, loc.shelf.cds.z) 
        end
    end
    
    for _, obj in pairs(GlobalShelves or {}) do
        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    GlobalShelves = {}

    local hash = joaat(cfg.shelfObjectName or 'v_ind_cf_shelf2')
    for index, loc in ipairs(cfg.locs or {}) do
        if loc.shelf and loc.shelf.cds then
            local obj = (function(hash, coords, isNet)
                RequestModel(hash)
                while not HasModelLoaded(hash) do Wait(10) end
                return CreateObject(hash, coords.x, coords.y, coords.z, isNet, true, true)
            end)(hash, loc.shelf.cds, false)
            
            if obj and DoesEntityExist(obj) then
                SetEntityHeading(obj, loc.shelf.h or 0.0)
                FreezeEntityPosition(obj, true)
                GlobalShelves[index] = obj
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if carriedProp and DoesEntityExist(carriedProp) then
            DeleteEntity(carriedProp)
        end
        
        for _, obj in pairs(GlobalShelves or {}) do
            if DoesEntityExist(obj) then
                DeleteEntity(obj)
            end
        end
        
        if LocalChop and LocalChop.shelfProps then
            for _, prop in pairs(LocalChop.shelfProps) do
                if DoesEntityExist(prop) then
                    DeleteEntity(prop)
                end
            end
        end
    end
end)

RegisterNetEvent('Night_DesmancheV2:clientDeleteVehicle', function(vehNet)
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if vehicle and DoesEntityExist(vehicle) then
        TriggerEvent('garages:Delete', vehicle)
    end
end)

RegisterNetEvent('Night_DesmancheV2:updateGlobalsClient')
AddEventHandler('Night_DesmancheV2:updateGlobalsClient', function(globals)
    if globals then
        cfg.timeWaitBeforeStart = globals.timeWaitBeforeStart
        cfg.animationTime = globals.animationTime
        cfg.distanceToSeeText = globals.distanceToSeeText
        cfg.shelfObjectName = globals.shelfObjectName
        cfg.canChopNPCVehicles = globals.canChopNPCVehicles
        cfg.autoChop = globals.autoChop
        cfg.prohibiteVehicles = globals.prohibiteVehicles or {}
    end
end)

CreateThread(function()
    Wait(2000)
    TriggerServerEvent("Night_DesmancheV2:requestData")
end)