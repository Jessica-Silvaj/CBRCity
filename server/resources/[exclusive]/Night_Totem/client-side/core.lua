-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local SpawnedMachines = {}
local InteractionIds  = {}
local BlipIds         = {}
local OpenedTotemId   = nil
local NUIOpen         = false
local NAME_PREFIX     = "night_totem_"
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------

--- Carrega um modelo de forma assincrona. Retorna nil se invalido ou apos timeout.
---@param model string|number
---@return number|nil
local function LoadModel(model)
    local modelHash = type(model) == "string" and GetHashKey(model) or model
    local timeout = GetGameTimer() + 5000

    if not IsModelInCdimage(modelHash) then
        return nil
    end

    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do
        Wait(10)
    end

    if not HasModelLoaded(modelHash) then
        return nil
    end

    return modelHash
end

--- Ajusta o prop ao chao de forma consistente entre clientes (colisao + chao antes de congelar).
---@param entity number
---@param coords vector4|table  x, y, z, w
---@param freeze boolean
---@return void
local function FinalizeTotemProp(entity, coords, freeze)
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return
    end

    local x, y, z = coords.x + 0.0, coords.y + 0.0, coords.z + 0.0
    local heading = coords.w + 0.0

    RequestCollisionAtCoord(x, y, z)

    local timeout = GetGameTimer() + 5000
    while not HasCollisionLoadedAroundEntity(entity) and GetGameTimer() < timeout do
        Wait(0)
        RequestCollisionAtCoord(x, y, z)
    end

    SetEntityAsMissionEntity(entity, true, true)
    SetEntityDynamic(entity, false)
    SetEntityHeading(entity, heading)

    -- Congelar DEPOIS de assentar no chao; se congelar antes, PlaceObjectOnGroundProperly nao move o objeto em parte dos clientes (prop "voando").
    PlaceObjectOnGroundProperly(entity)
    Wait(0)
    PlaceObjectOnGroundProperly(entity)
    SetEntityHeading(entity, heading)

    local ec = GetEntityCoords(entity)
    local ex, ey, ez = ec.x, ec.y, ec.z
    local _, gz = GetGroundZFor_3dCoord(ex, ey, ez + 25.0)
    if gz and (ez - gz) > 0.35 then
        PlaceObjectOnGroundProperly(entity)
        Wait(0)
        SetEntityHeading(entity, heading)
    end

    if freeze ~= false then
        FreezeEntityPosition(entity, true)
    end
end

--- Desenha texto 3D no mundo
---@param x    number
---@param y    number
---@param z    number
---@param text string
---@return void
local function DrawText3D(x, y, z, text)
    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)

    if not onScreen then
        return
    end

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringKeyboardDisplay(text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 200)
    SetTextCentre(true)
    EndTextCommandDisplayText(screenX, screenY)

    local width = (string.len(text) + 6) / 370
    DrawRect(screenX, screenY + 0.0125, width, 0.03, 15, 15, 15, 120)
end

--- Carrega um dicionario de animacao de forma assincrona
---@param dict string
---@return boolean
local function LoadAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do
        Wait(10)
    end
    return HasAnimDictLoaded(dict)
end

--- Toca a animacao de uso do totem no ped local
---@return void
local function PlayTotemAnim()
    CreateThread(function()
        local dict = "amb@prop_human_atm@male@idle_a"
        local anim = "idle_a"
        if LoadAnimDict(dict) then
            TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 15, 1, false, false, false)
            RemoveAnimDict(dict)
        end
    end)
end

--- Para a animacao do totem imediatamente
---@return void
local function StopTotemAnim()
    ClearPedTasksImmediately(PlayerPedId())
end

--- Envia uma mensagem NUI
---@param action string
---@param data   any
---@return void
local function SendInterfaceMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

--- Solicita ao servidor a abertura do painel do totem
---@param totemId string
---@return void
local function OpenTotem(totemId)
    if NUIOpen then return end

    local ped   = PlayerPedId()
    local state = LocalPlayer.state

    if not state.Active               then return end
    if IsPauseMenuActive()            then return end
    if state.Handcuff                 then return end
    if state.Buttons                  then return end
    if state.Commands                 then return end
    if GetEntityHealth(ped) <= 100    then return end

    TriggerServerEvent("night_totem:requestOpen", totemId)
end

--- Fecha o painel NUI
---@param notifyServer boolean
---@return void
local function ClosePanel(notifyServer)
    if notifyServer then
        TriggerServerEvent("night_totem:closeTotem")
    end

    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendInterfaceMessage("setVisible", false)
    StopTotemAnim()
    OpenedTotemId = nil
    NUIOpen = false
end

--- Abre o painel NUI com os dados recebidos do servidor
---@param totemId       string
---@param configPayload table
---@return void
local function OpenPanel(totemId, configPayload)
    OpenedTotemId = totemId
    NUIOpen = true

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)

    PlayTotemAnim()
    SendInterfaceMessage("setVisible", true)
    SendInterfaceMessage("openTotem", configPayload)
end

--- Remove todas as zonas de interacao registradas
---@return void
local function RemoveInteractions()
    for totemId, interactionId in pairs(InteractionIds) do
        if interactionId then
            if type(interactionId) == "string" and GetResourceState("ox_target") == "started" and exports.ox_target then
                pcall(function()
                    exports.ox_target:removeZone(interactionId)
                end)
            elseif GetResourceState("sleepless_interact") == "started" and exports.sleepless_interact then
                pcall(function()
                    exports.sleepless_interact:removeCoords(interactionId)
                end)
            end
        end

        InteractionIds[totemId] = nil
    end
end

--- Remove todos os blips criados no mapa
---@return void
local function RemoveBlips()
    for totemId, blip in pairs(BlipIds) do
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end

        BlipIds[totemId] = nil
    end
end

--- Cria os blips configurados para os totens
---@return void
local function CreateConfiguredBlips()
    RemoveBlips()

    local settings = Totem.Blips or Totem.Blip or {}

    if settings.Enabled ~= true then
        return
    end

    for totemId, totem in pairs(Totem.Restaurants) do
        local machineData = totem.Machine or {}
        local coords = machineData.Coords

        if coords then
            local blip = AddBlipForCoord(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)

            SetBlipSprite(blip, totem.BlipSprite or settings.Sprite or 52)
            SetBlipDisplay(blip, settings.Display or 4)
            SetBlipScale(blip, totem.BlipScale or settings.Scale or 0.65)
            SetBlipColour(blip, totem.BlipColor or settings.Color or 1)
            SetBlipAsShortRange(blip, settings.ShortRange ~= false)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(totem.BlipName or settings.Name or "Totem")
            EndTextCommandSetBlipName(blip)

            BlipIds[totemId] = blip
        end
    end
end

--- Registra as zonas de interacao usando o sleepless_interact
---@return void
local function RegisterSleeplessInteractions()
    local settings = Totem.Interaction.Sleepless or {}

    if GetResourceState("sleepless_interact") ~= "started" or not exports.sleepless_interact then
        return
    end

    RemoveInteractions()

    for totemId, totem in pairs(Totem.Restaurants) do
        local coords = totem.Machine.Coords
        local zOffset = totem.Machine.Object and 1.0 or 0.0
        local interactionId = exports.sleepless_interact:addCoords(vec3(coords.x, coords.y, coords.z + zOffset), {
            name = NAME_PREFIX .. tostring(totemId),
            label = settings.Label or "Abrir Totem",
            icon = settings.Icon or "utensils",
            distance = settings.Distance or 2.5,
            onSelect = function()
                OpenTotem(totemId)
            end,
            canInteract = function(entity, distance)
                return not NUIOpen and distance <= (settings.InteractDistance or settings.Distance or 2.5)
            end,
        })

        InteractionIds[totemId] = interactionId
    end
end

--- Registra as zonas de interacao usando o ox_target
---@return void
local function RegisterOxTargetInteractions()
    local settings = Totem.Interaction.OxTarget or {}

    if GetResourceState("ox_target") ~= "started" or not exports.ox_target then
        return
    end

    RemoveInteractions()

    for totemId, totem in pairs(Totem.Restaurants) do
        local coords = totem.Machine.Coords
        local zOffset = totem.Machine.Object and 1.0 or 0.0
        local zoneName = NAME_PREFIX .. tostring(totemId)

        exports.ox_target:addSphereZone({
            name = zoneName,
            coords = vec3(coords.x, coords.y, coords.z + zOffset),
            radius = settings.Radius or 1.0,
            options = {
                {
                    name = zoneName,
                    label = settings.Label or "Abrir Totem",
                    icon = settings.Icon or "fa-solid fa-utensils",
                    distance = settings.Distance or 2.5,
                    onSelect = function()
                        OpenTotem(totemId)
                    end,
                    canInteract = function()
                        return not NUIOpen
                    end,
                },
            },
        })

        InteractionIds[totemId] = zoneName
    end
end

--- Registra as interacoes conforme o sistema configurado
---@return void
local function RegisterInteractions()
    if Totem.Interaction.System == "sleepless" then
        RegisterSleeplessInteractions()
        return
    end

    if Totem.Interaction.System == "ox_target" then
        RegisterOxTargetInteractions()
        return
    end

    RemoveInteractions()
end

--- Cria os props dos totens no mundo
---@return void
local function SpawnConfiguredMachines()
    for totemId, entity in pairs(SpawnedMachines) do
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end

        SpawnedMachines[totemId] = nil
    end

    for totemId, totem in pairs(Totem.Restaurants) do
        local machineData = totem.Machine or {}

        if machineData.Object then
            local machineObj = Totem.MachineObject or {}
            local propName = machineData.Model or machineObj.Model or "totem"

            -- Tenta carregar o modelo ate 3 vezes antes de reportar erro
            local modelHash
            local maxAttempts = 3
            for attempt = 1, maxAttempts do
                modelHash = LoadModel(propName)
                if modelHash then break end
                if attempt < maxAttempts then Wait(2000) end
            end

            if not modelHash then
                TriggerServerEvent("night_totem:propNotFound", tostring(totemId), tostring(propName))
            else
                local coords = machineData.Coords
                local entity = CreateObjectNoOffset(modelHash, coords.x + 0.0, coords.y + 0.0, coords.z + 0.0, false, false, false)

                if entity and entity > 0 then
                    FinalizeTotemProp(entity, coords, machineObj.Freeze ~= false)
                    SpawnedMachines[totemId] = entity
                end

                SetModelAsNoLongerNeeded(modelHash)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    Wait(1000)
    SpawnConfiguredMachines()
    CreateConfiguredBlips()
end)

CreateThread(function()
    while not LocalPlayer.state.Active do
        Wait(1000)
    end

    RegisterInteractions()
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)

        local markerSettings = Totem.Interaction.Marker or {}

        if Totem.Interaction.System == "marker" or markerSettings.Enabled == true then

            for totemId, totem in pairs(Totem.Restaurants) do
                local machineData = totem.Machine or {}
                local coords = machineData.Coords
                local distance = #(playerCoords - vec3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0))

                if distance <= (markerSettings.DrawDistance or 12.0) then
                    sleep = 0

                    local markerColor = markerSettings.Color or { 59, 130, 246, 160 }
                    local markerScale = markerSettings.Scale or vec3(0.18, 0.18, 0.18)
                    if not markerSettings.DisableMarker then
                        DrawMarker(markerSettings.Type or 2, coords.x + 0.0, coords.y + 0.0, coords.z + (markerSettings.ZOffset or 0.15), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerScale.x + 0.0, markerScale.y + 0.0, markerScale.z + 0.0, markerColor[1], markerColor[2], markerColor[3], markerColor[4], false, false, 2, false, nil, nil, false)
                    end
                    local canUseMarkerKey = Totem.Interaction.System == "marker" or markerSettings.EnableKey == true

                    if canUseMarkerKey and distance <= (markerSettings.OpenDistance or 1.5) and not NUIOpen then
                        DrawText3D(coords.x + 0.0, coords.y + 0.0, coords.z + (markerSettings.TextZOffset or 0.35), markerSettings.Text or "~g~E~w~  ABRIR TOTEM")

                        if IsControlJustPressed(0, markerSettings.Key or 38) then
                            OpenTotem(totemId)
                        end
                    end
                end
            end
        end

        if NUIOpen and OpenedTotemId then
            local totem = Totem.Restaurants[OpenedTotemId]

            if totem and totem.Machine and totem.Machine.Coords then
                local coords = totem.Machine.Coords
                local distance = #(playerCoords - vec3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0))

                if distance > (Totem.Interaction.AutoCloseDistance or 5.0) then
                    ClosePanel(true)
                end
            end
        end

        Wait(sleep)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("night_totem:openPanel", function(totemId, configPayload)
    OpenPanel(totemId, configPayload)
end)

RegisterNetEvent("night_totem:nuiMessage", function(action, data)
    SendInterfaceMessage(action, data)
end)

RegisterNetEvent("night_totem:setWaypoint", function(data)
    if not data or not data.x or not data.y then
        return
    end

    SetNewWaypoint(data.x + 0.0, data.y + 0.0)

    -- Texto do GPS fica na notify unificada do servidor (SmartStock); evita 2 avisos seguidos.
    if data.showNotify then
        local label = data.totemId and ("Totem " .. tostring(data.totemId)) or "totem com estoque"
        TriggerEvent("Notify", "Atenção", "Rota marcada no mapa para " .. label .. ".", "amarelo", 7000)
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName ~= GetCurrentResourceName() and resourceName ~= "sleepless_interact" and resourceName ~= "ox_target" then
        return
    end

    Wait(1500)
    RegisterInteractions()
    CreateConfiguredBlips()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    ClosePanel(false)
    RemoveInteractions()
    RemoveBlips()

    for totemId, entity in pairs(SpawnedMachines) do
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end

        SpawnedMachines[totemId] = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(data, cb)
    ClosePanel(true)
    cb({ ok = true })
end)

RegisterNUICallback("confirm", function(data, cb)
    TriggerServerEvent("night_totem:handleAction", "confirm", data)
    cb({ ok = true })
end)

RegisterNUICallback("withdraw", function(data, cb)
    TriggerServerEvent("night_totem:handleAction", "withdraw", data)
    cb({ ok = true })
end)

RegisterNUICallback("setPrice", function(data, cb)
    TriggerServerEvent("night_totem:handleAction", "setPrice", data)
    cb({ ok = true })
end)

RegisterNUICallback("restock", function(data, cb)
    TriggerServerEvent("night_totem:handleAction", "restock", data)
    cb({ ok = true })
end)

RegisterNUICallback("restockAll", function(data, cb)
    TriggerServerEvent("night_totem:handleAction", "restockAll", data)
    cb({ ok = true })
end)

