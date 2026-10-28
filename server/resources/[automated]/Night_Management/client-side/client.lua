local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
NightAdmin = {}
Tunnel.bindInterface("Night_Management",NightAdmin)
vSERVER = Tunnel.getInterface("Night_Management")
local panelOpen = false
RegisterNetEvent("Night_Management:openPanel")
AddEventHandler("Night_Management:openPanel", function(allowedCategories, detailedPermissions)
    if not panelOpen then
        TriggerEvent("dynamic:Close")
        panelOpen = true
        SetNuiFocus(true, true)
        SetCursorLocation(0.5, 0.5)
        TriggerEvent("hud:Active", false)
        SendNUIMessage({ action = "show", theme = Theme, allowedCategories = allowedCategories, detailedPermissions = detailedPermissions })
    end
end)

RegisterNUICallback("close", function(data, cb)
    panelOpen = false
    SetNuiFocus(false, false)
    SetCursorLocation(0.5, 0.5)
    TriggerEvent("hud:Active", true)
    SendNUIMessage({ action = "hide" })
    cb("ok")
end)

---------------------------------------------------------------------------------------------------------
-- GLOBAL GETCOORDS & TELEPORT
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("getCoords", function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local result = {}
    local type = tonumber(data.type) or 4

    if type >= 1 then result.x = coords.x end
    if type >= 2 then result.y = coords.y end
    if type >= 3 then result.z = coords.z end
    if type >= 4 then result.h = heading end
    
    cb(result)
end)

RegisterNUICallback("teleport", function(data, cb)
    local ped = PlayerPedId()
    local x = tonumber(data.x) or 0.0
    local y = tonumber(data.y) or 0.0
    local z = tonumber(data.z) or 0.0
    
    SetEntityCoords(ped, x, y, z + 0.5, false, false, false, false)
    TriggerEvent("Notify", "Sucesso", "Teleportado com sucesso.", "verde", 5000)
    cb("ok")
end)

RegisterNUICallback("requestChests", function(data, cb)
    TriggerServerEvent("Night_Management:requestChests")
    cb("ok")
end)

RegisterNUICallback("saveChest", function(data, cb)
    TriggerServerEvent("Night_Management:saveChest", data)
    cb("ok")
end)

RegisterNUICallback("deleteChest", function(data, cb)
    TriggerServerEvent("Night_Management:deleteChest", data.id)
    cb("ok")
end)


RegisterNetEvent("Night_Management:receiveChests")
AddEventHandler("Night_Management:receiveChests", function(chests)
    SendNUIMessage({
        action = "loadChests",
        chests = chests
    })
end)

RegisterNetEvent("Night_Management:chestSaved")
AddEventHandler("Night_Management:chestSaved", function()
    SendNUIMessage({
        action = "chestSaved"
    })
end)


local chestZones = {}

RegisterNetEvent("Night_Management:updateChests")
AddEventHandler("Night_Management:updateChests", function(chests)
    for _, name in ipairs(chestZones) do
        exports.target:RemCircleZone("Chest:"..name)
    end
    chestZones = {}

    for _, v in pairs(chests) do
        local config = json.decode(v.Configuration) or {}
        local options = {}

        for i, access in ipairs(config) do
            local targetEvent = "chest:Open"
            local targetTunnel = "client"
            
            local lowerLabel = string.lower(access.label)
            if string.find(lowerLabel, "colete") then
                targetEvent = "chest:Armour"
                targetTunnel = "server"
            end

            table.insert(options, {
                event = targetEvent,
                label = access.label,
                tunnel = targetTunnel,
                service = tostring(i)
            })
        end

        exports.target:AddCircleZone("Chest:"..v.Name, vec3(v.X, v.Y, v.Z), 1.25, {
            name = "Chest:"..v.Name,
            heading = 0.0,
            useZ = true
        }, {
            Distance = 1.25,
            shop = v.Name,
            options = options
        })
        table.insert(chestZones, v.Name)
    end
end)




---------------------------------------------------------------------------------------------------------
-- CLOAKROOM.LUA
---------------------------------------------------------------------------------------------------------
local activeCloakrooms = {}

RegisterNUICallback("requestCloakrooms", function(data, cb)
    TriggerServerEvent("Night_Management:requestCloakrooms")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveCloakrooms")
AddEventHandler("Night_Management:receiveCloakrooms", function(cloakrooms)
    SendNUIMessage({
        action = "updateCloakrooms",
        cloakrooms = cloakrooms
    })
end)

RegisterNUICallback("saveCloakroom", function(data, cb)
    TriggerServerEvent("Night_Management:saveCloakroom", data)
    cb("ok")
end)

RegisterNUICallback("deleteCloakroom", function(data, cb)
    TriggerServerEvent("Night_Management:deleteCloakroom", data.id)
    cb("ok")
end)



RegisterNUICallback("getCurrentClothes", function(data, cb)
    local ped = PlayerPedId()
    local clothes = {
        ["hat"] = { item = GetPedPropIndex(ped, 0), texture = GetPedPropTextureIndex(ped, 0) },
        ["glass"] = { item = GetPedPropIndex(ped, 1), texture = GetPedPropTextureIndex(ped, 1) },
        ["ear"] = { item = GetPedPropIndex(ped, 2), texture = GetPedPropTextureIndex(ped, 2) },
        ["watch"] = { item = GetPedPropIndex(ped, 6), texture = GetPedPropTextureIndex(ped, 6) },
        ["bracelet"] = { item = GetPedPropIndex(ped, 7), texture = GetPedPropTextureIndex(ped, 7) },
        ["pants"] = { item = GetPedDrawableVariation(ped, 4), texture = GetPedTextureVariation(ped, 4) },
        ["arms"] = { item = GetPedDrawableVariation(ped, 3), texture = GetPedTextureVariation(ped, 3) },
        ["tshirt"] = { item = GetPedDrawableVariation(ped, 8), texture = GetPedTextureVariation(ped, 8) },
        ["torso"] = { item = GetPedDrawableVariation(ped, 11), texture = GetPedTextureVariation(ped, 11) },
        ["vest"] = { item = GetPedDrawableVariation(ped, 9), texture = GetPedTextureVariation(ped, 9) },
        ["shoes"] = { item = GetPedDrawableVariation(ped, 6), texture = GetPedTextureVariation(ped, 6) },
        ["mask"] = { item = GetPedDrawableVariation(ped, 1), texture = GetPedTextureVariation(ped, 1) },
        ["backpack"] = { item = GetPedDrawableVariation(ped, 5), texture = GetPedTextureVariation(ped, 5) },
        ["accessory"] = { item = GetPedDrawableVariation(ped, 7), texture = GetPedTextureVariation(ped, 7) },
        ["decals"] = { item = GetPedDrawableVariation(ped, 10), texture = GetPedTextureVariation(ped, 10) }
    }
    local modelHash = GetEntityModel(ped)
    local modelName = "mp_m_freemode_01"
    if modelHash == GetHashKey("mp_f_freemode_01") then
        modelName = "mp_f_freemode_01"
    end

    SendNUIMessage({
        action = "pushCurrentClothes",
        clothes = clothes,
        model = modelName
    })
    cb("ok")
end)

RegisterNetEvent("Night_Management:cloakroomSaved")
AddEventHandler("Night_Management:cloakroomSaved", function()
    SendNUIMessage({ action = "cloakroomSaved" })
end)

RegisterNetEvent("Night_Management:updateCloakroomsData")
AddEventHandler("Night_Management:updateCloakroomsData", function(cloakrooms)
    activeCloakrooms = cloakrooms
end)



exports("getCloakrooms", function()
    return activeCloakrooms
end)


---------------------------------------------------------------------------------------------------------
-- CRAFTING.LUA
---------------------------------------------------------------------------------------------------------

RegisterNUICallback("requestCraftings", function(data, cb)
    TriggerServerEvent("Night_Management:requestCraftings")
    cb("ok")
end)

RegisterNUICallback("saveCrafting", function(data, cb)
    TriggerServerEvent("Night_Management:saveCrafting", data)
    cb("ok")
end)

RegisterNUICallback("deleteCrafting", function(data, cb)
    TriggerServerEvent("Night_Management:deleteCrafting", data.id)
    cb("ok")
end)



RegisterNetEvent("Night_Management:updateClientCraftings")
AddEventHandler("Night_Management:updateClientCraftings", function(craftings)
    SendNUIMessage({
        action = "updateCraftings",
        craftings = craftings
    })
end)

RegisterNetEvent("Night_Management:notifyCraftingSaved")
AddEventHandler("Night_Management:notifyCraftingSaved", function()
    SendNUIMessage({ action = "craftingSaved" })
end)


RegisterNUICallback("requestCraftingConfigs", function(data, cb)
    TriggerServerEvent("Night_Management:requestCraftingConfigs")
    cb("ok")
end)

RegisterNUICallback("saveCraftingConfig", function(data, cb)
    TriggerServerEvent("Night_Management:saveCraftingConfig", data)
    cb("ok")
end)

RegisterNUICallback("deleteCraftingConfig", function(data, cb)
    TriggerServerEvent("Night_Management:deleteCraftingConfig", data.mode)
    cb("ok")
end)

RegisterNetEvent("Night_Management:updateClientCraftingConfigs")
AddEventHandler("Night_Management:updateClientCraftingConfigs", function(configs)
    SendNUIMessage({
        action = "updateCraftingConfigs",
        configs = configs
    })
end)

RegisterNetEvent("Night_Management:notifyCraftingConfigSaved")
AddEventHandler("Night_Management:notifyCraftingConfigSaved", function()
    SendNUIMessage({ action = "craftingConfigSaved" })
end)


---------------------------------------------------------------------------------------------------------
-- PERMISSIONS CALLBACKS
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAdminRoles", function(data, cb)
    TriggerServerEvent("Night_Management:requestAdminRoles")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveAdminRoles")
AddEventHandler("Night_Management:receiveAdminRoles", function(roles)
    SendNUIMessage({
        action = "updateAdminRoles",
        roles = roles
    })
end)

RegisterNUICallback("requestRolePermissions", function(data, cb)
    TriggerServerEvent("Night_Management:requestRolePermissions", data.role)
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveRolePermissions")
AddEventHandler("Night_Management:receiveRolePermissions", function(role, permissions)
    SendNUIMessage({
        action = "updateRolePermissions",
        role = role,
        permissions = permissions
    })
end)

RegisterNUICallback("saveRolePermissions", function(data, cb)
    TriggerServerEvent("Night_Management:saveRolePermissions", data)
    cb("ok")
end)

---------------------------------------------------------------------------------------------------------
-- BLIPS & UTILS
---------------------------------------------------------------------------------------------------------
-- ==========================================
-- BLIPS NUI CALLBACKS
-- ==========================================

RegisterNUICallback("requestBlips", function(data, cb)
    TriggerServerEvent("Night_Management:requestBlips")
    cb("ok")
end)

RegisterNetEvent("Night_Management:updateBlips")
AddEventHandler("Night_Management:updateBlips", function(blips)
    SendNUIMessage({
        action = "updateBlips",
        blips = blips
    })
end)


RegisterNUICallback("saveBlip", function(data, cb)
    TriggerServerEvent("Night_Management:saveBlip", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:blipSaved")
AddEventHandler("Night_Management:blipSaved", function()
    SendNUIMessage({ action = "blipSaved" })
end)

RegisterNUICallback("deleteBlip", function(data, cb)
    TriggerServerEvent("Night_Management:deleteBlip", data)
    cb("ok")
end)


-- ==========================================
-- NPCS NUI CALLBACKS
-- ==========================================

RegisterNUICallback("requestNpcs", function(data, cb)
    TriggerServerEvent("Night_Management:requestNpcs")
    cb("ok")
end)

RegisterNetEvent("Night_Management:updateNpcs")
AddEventHandler("Night_Management:updateNpcs", function(npcs)
    SendNUIMessage({
        action = "updateNpcs",
        npcs = npcs
    })
end)


RegisterNUICallback("saveNpc", function(data, cb)
    TriggerServerEvent("Night_Management:saveNpc", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:npcSaved")
AddEventHandler("Night_Management:npcSaved", function()
    SendNUIMessage({ action = "npcSaved" })
end)

RegisterNUICallback("deleteNpc", function(data, cb)
    TriggerServerEvent("Night_Management:deleteNpc", data)
    cb("ok")
end)


RegisterNUICallback("requestAppearances", function(data, cb)
    TriggerServerEvent("Night_Management:requestAppearances", data.type)
    cb("ok")
end)

RegisterNetEvent("Night_Management:updateAppearances")
AddEventHandler("Night_Management:updateAppearances", function(appearances)
    SendNUIMessage({
        action = "updateAppearances",
        appearances = appearances
    })
end)


RegisterNUICallback("saveAppearance", function(data, cb)
    TriggerServerEvent("Night_Management:saveAppearance", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:appearanceSaved")
AddEventHandler("Night_Management:appearanceSaved", function()
    SendNUIMessage({ action = "appearanceSaved" })
end)

RegisterNUICallback("deleteAppearance", function(data, cb)
    TriggerServerEvent("Night_Management:deleteAppearance", data)
    cb("ok")
end)



---------------------------------------------------------------------------------------------------------
-- DENSITY LOGIC
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestDensity", function(data, cb)
    TriggerServerEvent("Night_Management:requestDensity")
    cb("ok")
end)

RegisterNetEvent("Night_Management:loadDensity")
AddEventHandler("Night_Management:loadDensity", function(density)
    SendNUIMessage({
        action = "loadDensity",
        density = density
    })
end)

RegisterNUICallback("saveDensity", function(data, cb)
    TriggerServerEvent("Night_Management:saveDensity", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:densitySaved")
AddEventHandler("Night_Management:densitySaved", function()
    SendNUIMessage({ action = "densitySaved" })
end)

---------------------------------------------------------------------------------------------------------
-- CLEARAREA LOGIC
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("getCoordsClearArea", function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    SendNUIMessage({
        action = "pushCoordsClearArea",
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
    cb("ok")
end)

RegisterNUICallback("requestClearAreas", function(data, cb)
    TriggerServerEvent("Night_Management:requestClearAreas")
    cb("ok")
end)

RegisterNetEvent("Night_Management:updateClearAreas")
AddEventHandler("Night_Management:updateClearAreas", function(clearareas)
    SendNUIMessage({
        action = "updateClearAreas",
        clearareas = clearareas
    })
end)

RegisterNUICallback("saveClearArea", function(data, cb)
    TriggerServerEvent("Night_Management:saveClearArea", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:clearareaSaved")
AddEventHandler("Night_Management:clearareaSaved", function()
    SendNUIMessage({ action = "clearareaSaved" })
end)

RegisterNUICallback("deleteClearArea", function(data, cb)
    TriggerServerEvent("Night_Management:deleteClearArea", data)
    cb("ok")
end)

---------------------------------------------------------------------------------------------------------
-- DOORS.LUA
---------------------------------------------------------------------------------------------------------
local setupMode = false
local selectedDoor1 = nil
local selectedDoor2 = nil
local currentSetupName = "Porta"
local currentSetupDistance = 2.0
local currentSetupPermission = nil
local currentSetupIsDouble = false

function GetForwardVector(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vec3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = GetForwardVector(cameraRotation)
    local destination = vec3(cameraCoord.x + direction.x * distance, cameraCoord.y + direction.y * distance, cameraCoord.z + direction.z * distance)
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

RegisterNUICallback("startDoorSetup", function(data, cb)
    currentSetupName = data.name or "Porta"
    currentSetupIsDouble = data.isDouble or false
    currentSetupDistance = tonumber(data.distance) or 2.0
    currentSetupPermission = data.permission
    if currentSetupPermission == "" then currentSetupPermission = nil end

    TriggerEvent("doors:addtranca")
    cb("ok")
end)

RegisterNUICallback("requestDoors", function(data, cb)
    TriggerServerEvent("Night_Management:requestDoors")
    cb("ok")
end)

RegisterNUICallback("deleteDoor", function(data, cb)
    TriggerServerEvent("Night_Management:deleteDoor", data.id)
    cb("ok")
end)

RegisterNUICallback("editDoorConfig", function(data, cb)
    TriggerServerEvent("Night_Management:editDoorConfig", data.id, data.name, data.distance, data.permission)
    cb("ok")
end)


RegisterNetEvent("Night_Management:receiveDoors")
AddEventHandler("Night_Management:receiveDoors", function(doors)
    SendNUIMessage({
        action = "loadDoors",
        doors = doors
    })
end)

RegisterNetEvent("doors:addtranca")
AddEventHandler("doors:addtranca", function()
    setupMode = not setupMode
    if setupMode then
        SetNuiFocus(false, false)
        SendNUIMessage({ Action = "Close" })
        SendNUIMessage({ action = "hideMenu" })
        
        if currentSetupIsDouble then
            TriggerEvent("inventory:Buttons", {
                { Letter = "E", Text = "Selecionar Porta" },
                { Letter = "F", Text = "Cancelar" }
            })
        else
            TriggerEvent("inventory:Buttons", {
                { Letter = "E", Text = "Selecionar Porta" },
                { Letter = "F", Text = "Cancelar" }
            })
        end
        
        selectedDoor1 = nil
        selectedDoor2 = nil

        CreateThread(function()
            while setupMode do
                local timeDistance = 1
                local hit, coords, entity = RayCastGamePlayCamera(10.0)

                if hit and entity ~= 0 and GetEntityType(entity) == 3 then
                    -- Get the exact center of the door model
                    local min, max = GetModelDimensions(GetEntityModel(entity))
                    local offset = (min + max) * 0.5
                    local center = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)

                    -- Draw aiming marker at the center
                    DrawMarker(28, center.x, center.y, center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 255, 255, 255, 150, false, false, 2, false, nil, nil, false)
                    
                    if IsControlJustPressed(1, 38) then -- E
                        local hash = GetEntityModel(entity)
                        local entityCoords = GetEntityCoords(entity)
                        
                        if not selectedDoor1 then
                            selectedDoor1 = { hash = hash, coords = entityCoords, center = center }
                            if not currentSetupIsDouble then
                                TriggerServerEvent("doors:requestSetup", selectedDoor1, nil, currentSetupName, currentSetupDistance, currentSetupPermission)
                                setupMode = false
                                selectedDoor1 = nil
                                selectedDoor2 = nil
                                TriggerEvent("inventory:CloseButtons")
                                TriggerEvent("Notify", "Sucesso", "Porta salva com sucesso!", "verde", 5000)
                            else
                                TriggerEvent("Notify", "Sucesso", "Primeira porta selecionada! Selecione a segunda porta.", "verde", 5000)
                            end
                        elseif not selectedDoor2 and currentSetupIsDouble then
                            selectedDoor2 = { hash = hash, coords = entityCoords, center = center }
                            TriggerServerEvent("doors:requestSetup", selectedDoor1, selectedDoor2, currentSetupName, currentSetupDistance, currentSetupPermission)
                            setupMode = false
                            selectedDoor1 = nil
                            selectedDoor2 = nil
                            TriggerEvent("inventory:CloseButtons")
                            TriggerEvent("Notify", "Sucesso", "Porta dupla salva com sucesso!", "verde", 5000)
                        end
                    end
                end

                -- Draw saved markers at their centers
                if selectedDoor1 then
                    DrawMarker(28, selectedDoor1.center.x, selectedDoor1.center.y, selectedDoor1.center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 0, 255, 0, 200, false, false, 2, false, nil, nil, false)
                end
                if selectedDoor2 then
                    DrawMarker(28, selectedDoor2.center.x, selectedDoor2.center.y, selectedDoor2.center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 0, 255, 0, 200, false, false, 2, false, nil, nil, false)
                end

                if IsControlJustPressed(1, 49) then -- F
                    setupMode = false
                    TriggerEvent("inventory:CloseButtons")
                    TriggerEvent("Notify", "Aviso", "Configuração cancelada.", "amarelo", 5000)
                end

                Wait(timeDistance)
            end
        end)
    else
        TriggerEvent("Notify", "Aviso", "Modo configuração DESATIVADO.", "amarelo", 5000)
    end
end)


---------------------------------------------------------------------------------------------------------
-- ELEVATORS.LUA
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestElevators", function(data, cb)
    TriggerServerEvent("Night_Management:requestElevators")
    cb("ok")
end)

RegisterNUICallback("saveElevator", function(data, cb)
    TriggerServerEvent("Night_Management:saveElevator", data)
    cb("ok")
end)


RegisterNUICallback("deleteElevator", function(data, cb)
    TriggerServerEvent("Night_Management:deleteElevator", data.id)
    cb("ok")
end)

RegisterNetEvent("Night_Management:updateElevators")
AddEventHandler("Night_Management:updateElevators", function(elevators)
    SendNUIMessage({
        action = "loadElevators",
        elevators = elevators
    })
end)

RegisterNetEvent("Night_Management:elevatorSaved")
AddEventHandler("Night_Management:elevatorSaved", function()
    SendNUIMessage({
        action = "elevatorSaved"
    })
end)


---------------------------------------------------------------------------------------------------------
-- GARAGES.LUA
---------------------------------------------------------------------------------------------------------


RegisterNUICallback("saveGarage", function(data, cb)
    TriggerServerEvent("Night_Management:saveGarage", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:garageSaved")
AddEventHandler("Night_Management:garageSaved", function()
    SendNUIMessage({
        action = "garageSaved"
    })
end)

RegisterNUICallback("requestGarages", function(data, cb)
    TriggerServerEvent("Night_Management:requestGarages")
    cb("ok")
end)

RegisterNUICallback("deleteGarage", function(data, cb)
    TriggerServerEvent("Night_Management:deleteGarage", data)
    cb("ok")
end)

RegisterNUICallback("requestVehicleClasses", function(data, cb)
    TriggerServerEvent("Night_Management:requestVehicleClasses")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveGarages")
AddEventHandler("Night_Management:receiveGarages", function(garages)
    SendNUIMessage({
        action = "loadGarages",
        garages = garages
    })
end)

RegisterNetEvent("Night_Management:receiveVehicleClasses")
AddEventHandler("Night_Management:receiveVehicleClasses", function(classes)
    SendNUIMessage({
        action = "loadVehicleClasses",
        classes = classes
    })
end)

RegisterNUICallback("startSpawnEditor", function(data, cb)
    local garageId = data.id
    local garageName = data.name
    
    SendNUIMessage({ action = "hide" })
    SetNuiFocus(false, false)

    TriggerEvent("inventory:Buttons", {
        { Letter = "E", Text = "Adicionar Vaga" },
        { Letter = "F", Text = "Cancelar" },
        { Letter = "H", Text = "Finalizar e Salvar" }
    })

    CreateThread(function()
        local collectedSpawns = {}
        local editing = true

        while editing do
            Wait(1)
            
            -- Pressionou E para adicionar
            if IsControlJustPressed(1, 38) then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                
                table.insert(collectedSpawns, { coords.x, coords.y, coords.z, heading })
                TriggerEvent("Notify", "sucesso", "Vaga adicionada! Total: " .. #collectedSpawns, "verde", 3000)
            end

            -- Pressionou H para finalizar
            if IsControlJustPressed(1, 74) then
                editing = false
                TriggerEvent("inventory:CloseButtons")
                
                if #collectedSpawns > 0 then
                    -- Sends collected spawns back to NUI!
                    SendNUIMessage({
                        action = "show"
                    })
                    SetNuiFocus(true, true)
                    
                    SendNUIMessage({
                        action = "pushSpawns",
                        spawns = collectedSpawns
                    })
                    TriggerEvent("Notify", "sucesso", "Vagas importadas para o painel!", "verde", 3000)
                else
                    SendNUIMessage({ action = "show" })
                    SetNuiFocus(true, true)
                    TriggerEvent("Notify", "aviso", "Nenhuma vaga foi salva.", "amarelo", 3000)
                end
            end

            -- Pressionou F para cancelar
            if IsControlJustPressed(1, 49) then
                editing = false
                TriggerEvent("inventory:CloseButtons")
                SendNUIMessage({ action = "show" })
                SetNuiFocus(true, true)
                TriggerEvent("Notify", "aviso", "Edição de vagas cancelada.", "amarelo", 3000)
            end
        end
    end)
    cb("ok")
end)


---------------------------------------------------------------------------------------------------------
-- LSCUSTOMS.LUA
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestLSCustoms", function(data, cb)
    TriggerServerEvent("Night_Management:requestLSCustoms")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveLSCustoms")
AddEventHandler("Night_Management:receiveLSCustoms", function(lscustoms)
    SendNUIMessage({
        action = "loadLSCustoms",
        lscustoms = lscustoms
    })
end)

RegisterNUICallback("saveLSCustoms", function(data, cb)
    TriggerServerEvent("Night_Management:saveLSCustoms", data)
    cb("ok")
end)

RegisterNUICallback("deleteLSCustoms", function(data, cb)
    TriggerServerEvent("Night_Management:deleteLSCustoms", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:lscustomsSaved")
AddEventHandler("Night_Management:lscustomsSaved", function()
    TriggerServerEvent("Night_Management:requestLSCustoms")
end)




---------------------------------------------------------------------------------------------------------
-- PDM.LUA
---------------------------------------------------------------------------------------------------------


RegisterNUICallback("savePdm", function(data, cb)
    TriggerServerEvent("Night_Management:savePdm", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:pdmSaved")
AddEventHandler("Night_Management:pdmSaved", function()
    SendNUIMessage({
        action = "pdmSaved"
    })
end)

RegisterNUICallback("requestPdms", function(data, cb)
    TriggerServerEvent("Night_Management:requestPdms")
    cb("ok")
end)

RegisterNUICallback("deletePdm", function(data, cb)
    TriggerServerEvent("Night_Management:deletePdm", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:receivePdms")
AddEventHandler("Night_Management:receivePdms", function(pdms)
    SendNUIMessage({
        action = "loadPdms",
        pdms = pdms
    })
end)



---------------------------------------------------------------------------------------------------------
-- RADIOS.LUA
---------------------------------------------------------------------------------------------------------

RegisterNUICallback("requestRadios", function(data, cb)
    TriggerServerEvent("Night_Management:requestRadios")
    cb("ok")
end)

RegisterNUICallback("saveRadio", function(data, cb)
    TriggerServerEvent("Night_Management:saveRadio", data)
    cb("ok")
end)

RegisterNUICallback("deleteRadio", function(data, cb)
    TriggerServerEvent("Night_Management:deleteRadio", data.frequencia)
    cb("ok")
end)

RegisterNetEvent("Night_Management:updateRadios")
AddEventHandler("Night_Management:updateRadios", function(radios)
    SendNUIMessage({
        action = "loadRadios",
        radios = radios
    })
end)

RegisterNetEvent("Night_Management:radioSaved")
AddEventHandler("Night_Management:radioSaved", function()
    SendNUIMessage({
        action = "radioSaved"
    })
end)


---------------------------------------------------------------------------------------------------------
-- SAFEZONES.LUA
---------------------------------------------------------------------------------------------------------




local SafeZones = {}
local PreviewPoly = nil

CreateThread(function()
    Wait(2000)
    TriggerServerEvent("Night_Management:requestSyncSafezones")
end)

RegisterNetEvent("Night_Management:syncSafezones")
AddEventHandler("Night_Management:syncSafezones", function(data)
    SafeZonesData = data
    SafeZones = {}
    
    for k, v in pairs(SafeZonesData) do
        if v.points and #v.points >= 3 then
            local pts = {}
            for _, p in ipairs(v.points) do
                table.insert(pts, vec2(p.x, p.y))
            end
            
            table.insert(SafeZones, PolyZone:Create(pts, {
                name = "Safezone_"..v.id,
                minZ = v.minZ,
                maxZ = v.maxZ
            }))
        end
    end
    
    TriggerEvent("Safezone:UpdateZones", SafeZonesData)
end)

RegisterNUICallback("togglePreviewSafezone", function(data, cb)
    if data.state then
        if PreviewPoly then
            PreviewPoly:destroy()
        end
        local pts = {}
        for _, p in ipairs(data.points) do
            table.insert(pts, vec2(p.x, p.y))
        end
        PreviewPoly = PolyZone:Create(pts, {
            name = "Preview",
            minZ = data.minZ,
            maxZ = data.maxZ,
            debugPoly = true
        })
    else
        if PreviewPoly then
            PreviewPoly:destroy()
            PreviewPoly = nil
        end
    end
    cb("ok")
end)

RegisterNUICallback("saveSafezone", function(data, cb)
    TriggerServerEvent("Night_Management:saveSafezone", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:safezoneSaved")
AddEventHandler("Night_Management:safezoneSaved", function()
    SendNUIMessage({ action = "safezoneSaved" })
end)

RegisterNUICallback("requestSafezones", function(data, cb)
    TriggerServerEvent("Night_Management:requestSafezones")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveSafezones")
AddEventHandler("Night_Management:receiveSafezones", function(safezones)
    SendNUIMessage({ action = "updateSafezones", safezones = safezones })
end)


RegisterNUICallback("deleteSafezone", function(data, cb)
    TriggerServerEvent("Night_Management:deleteSafezone", data.id)
    cb("ok")
end)


---------------------------------------------------------------------------------------------------------
-- SHOPS.LUA
---------------------------------------------------------------------------------------------------------

RegisterNUICallback("requestShops", function(data, cb)
    TriggerServerEvent("Night_Management:requestShops")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveShops")
AddEventHandler("Night_Management:receiveShops", function(shops)
    SendNUIMessage({
        action = "updateShops",
        shops = shops
    })
end)

RegisterNUICallback("saveShop", function(data, cb)
    TriggerServerEvent("Night_Management:saveShop", data)
    cb("ok")
end)

RegisterNUICallback("deleteShop", function(data, cb)
    TriggerServerEvent("Night_Management:deleteShop", data.id)
    cb("ok")
end)



RegisterNUICallback("requestShopConfigs", function(data, cb)
    TriggerServerEvent("Night_Management:requestShopConfigs")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveShopConfigs")
AddEventHandler("Night_Management:receiveShopConfigs", function(configs)
    local formatedList = {}
    for _, v in pairs(configs) do
        formatedList[v.Mode] = {
            Mode = v.Action,
            Type = v.Type,
            Item = v.Item,
            Permission = v.Permission,
            List = json.decode(v.List)
        }
    end

    SendNUIMessage({
        action = "updateShopConfigs",
        configs = formatedList
    })
end)

RegisterNUICallback("saveShopConfig", function(data, cb)
    TriggerServerEvent("Night_Management:saveShopConfig", data)
    cb("ok")
end)

RegisterNUICallback("deleteShopConfig", function(data, cb)
    TriggerServerEvent("Night_Management:deleteShopConfig", data.mode)
    cb("ok")
end)

---------------------------------------------------------------------------------------------------------
-- DESMANCHES.LUA
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestDesmanches", function(data, cb)
    TriggerServerEvent("Night_Management:requestDesmanches")
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveDesmanches")
AddEventHandler("Night_Management:receiveDesmanches", function(desmanches)
    SendNUIMessage({
        action = "updateDesmanches",
        desmanches = desmanches
    })
end)

RegisterNUICallback("saveDesmanche", function(data, cb)
    TriggerServerEvent("Night_Management:saveDesmanche", data)
    cb("ok")
end)

RegisterNUICallback("deleteDesmanche", function(data, cb)
    TriggerServerEvent("Night_Management:deleteDesmanche", data.id)
    cb("ok")
end)

RegisterNetEvent("Night_Management:desmancheSaved")
AddEventHandler("Night_Management:desmancheSaved", function()
    SendNUIMessage({
        action = "desmancheSaved"
    })
end)



RegisterNUICallback("requestSettings", function(data, cb)
    TriggerServerEvent("Night_Management:requestSettings", data.module)
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveSettings")
AddEventHandler("Night_Management:receiveSettings", function(module, config)
    SendNUIMessage({
        action = "updateSettings",
        module = module,
        config = config
    })
end)

RegisterNUICallback("saveSettings", function(data, cb)
    TriggerServerEvent("Night_Management:saveSettings", data.module, data.config)
    cb("ok")
end)



RegisterNUICallback('getRoutes', function(data, cb)
    local routes = vSERVER.getRoutes()
    cb(routes)
end)

RegisterNUICallback('saveRoute', function(data, cb)
    local result = vSERVER.saveRoute(data)
    cb(result)
end)

RegisterNUICallback('deleteRoute', function(data, cb)
    local result = vSERVER.deleteRoute(data.id)
    cb(result)
end)




RegisterNUICallback("notify", function(data, cb)
    TriggerEvent("Notify", "aviso", data.message, "verde", 5000)
    cb({})
end)

---------------------------------------------------------------------------------------------------------
-- MONEYWASH.LUA
---------------------------------------------------------------------------------------------------------

RegisterNUICallback('requestMoneywash', function(data, cb)
    TriggerServerEvent('Night_Management:requestMoneywash')
    cb('ok')
end)

RegisterNUICallback('saveMoneywash', function(data, cb)
    TriggerServerEvent('Night_Management:saveMoneywash', data)
    cb('ok')
end)

RegisterNUICallback('deleteMoneywash', function(data, cb)
    TriggerServerEvent('Night_Management:deleteMoneywash', data.id)
    cb('ok')
end)


RegisterNetEvent('Night_Management:updateMoneywash')
AddEventHandler('Night_Management:updateMoneywash', function(machines)
    SendNUIMessage({
        action = 'loadMoneywash',
        machines = machines
    })
end)

RegisterNetEvent('Night_Management:moneywashSaved')
AddEventHandler('Night_Management:moneywashSaved', function()
    SendNUIMessage({
        action = 'moneywashSaved'
    })
end)

---------------------------------------------------------------------------------------------------------
-- COORDS CALLBACKS (For NUI)
---------------------------------------------------------------------------------------------------------
local coordsCallbacks = {
    ["getCoordsChest"] = "updateCoords",
    ["getCoordsGarage"] = "updateCoordsGarage",
    ["getCoordsSpawn"] = "updateCoordsSpawn",
    ["getCoordsPdm"] = "updateCoordsPdm",
    ["getCoordsPdmSpawn"] = "updateCoordsPdmSpawn",
    ["getCoordsLSCustoms"] = "updateCoordsLSCustoms",
    ["getCoordsDesmanche"] = "updateCoordsDesmanche",
    ["getCoordsForRouteInit"] = "updateCoordsRouteInit",
    ["getCoordsForRouteCoord"] = "updateCoordsRouteCoord",
    ["getCoordsMoneywash"] = "updateCoordsMoneywash",
    ["getCoordsShop"] = "pushCoordsShop",
    ["getCoordsCrafting"] = "pushCoordsCrafting",
    ["getCoordsBlip"] = "pushCoordsBlip",
    ["getCoordsNpc"] = "pushCoordsNpc",
    ["getCoordsAppearance"] = "pushCoordsAppearance",
    ["getCoordsCloakroom"] = "pushCoordsCloakroom",
    ["getCoordsElevator"] = "pushCoordsElevatorFloor",
    ["getCoordsSafezone"] = "pushCoordsSafezone",
    ["getCoordsService"] = "pushCoordsService"
}

for callbackName, actionName in pairs(coordsCallbacks) do
    RegisterNUICallback(callbackName, function(data, cb)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        
        SendNUIMessage({
            action = actionName,
            coords = { X = coords.x, Y = coords.y, Z = coords.z, H = heading },
            x = coords.x, y = coords.y, z = coords.z, h = heading
        })
        cb("ok")
    end)
end

RegisterNUICallback("requestWebhooks", function(data, cb)
    TriggerServerEvent("Night_Management:requestWebhooks")
    cb("ok")
end)

RegisterNUICallback("saveWebhooks", function(data, cb)
    TriggerServerEvent("Night_Management:saveWebhooks", data)
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveWebhooks")
AddEventHandler("Night_Management:receiveWebhooks", function(webhooks)
    SendNUIMessage({
        action = "updateWebhooks",
        webhooks = webhooks
    })
end)

---------------------------------------------------------------------------------------------------------
-- SERVICES (BATE PONTOS)
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestServices", function(data, cb)
    TriggerServerEvent("Night_Management:requestServices")
    cb("ok")
end)

RegisterNUICallback("saveService", function(data, cb)
    TriggerServerEvent("Night_Management:saveService", data)
    cb("ok")
end)

RegisterNUICallback("deleteService", function(data, cb)
    TriggerServerEvent("Night_Management:deleteService", data.id)
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveServices")
AddEventHandler("Night_Management:receiveServices", function(services)
    SendNUIMessage({
        action = "loadServices",
        services = services
    })
end)

RegisterNetEvent("Night_Management:serviceSaved")
AddEventHandler("Night_Management:serviceSaved", function()
    SendNUIMessage({
        action = "serviceSaved"
    })
end)

---------------------------------------------------------------------------------------------------------
-- GROUPS (GRUPOS / CARGOS)
---------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestGroups", function(data, cb)
    TriggerServerEvent("Night_Management:requestGroups")
    cb("ok")
end)

RegisterNUICallback("saveGroup", function(data, cb)
    TriggerServerEvent("Night_Management:saveGroup", data)
    cb("ok")
end)

RegisterNUICallback("deleteGroup", function(data, cb)
    TriggerServerEvent("Night_Management:deleteGroup", data.name)
    cb("ok")
end)

RegisterNetEvent("Night_Management:receiveGroups")
AddEventHandler("Night_Management:receiveGroups", function(groups)
    SendNUIMessage({
        action = "loadGroups",
        groups = groups
    })
end)

RegisterNetEvent("Night_Management:groupSaved")
AddEventHandler("Night_Management:groupSaved", function()
    SendNUIMessage({
        action = "groupSaved"
    })
end)
