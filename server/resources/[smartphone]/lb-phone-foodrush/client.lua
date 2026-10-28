
-- client.lua - FoodRush Delivery App
local identifier = "lb-phone-foodrush"

-- ============================================================================
-- CONFIGURAÇÕES E VARIÁVEIS
-- ============================================================================

-- Aguardar lb-phone estar carregado
while GetResourceState("lb-phone") ~= "started" do
    Wait(500)
end

local appConfig = {
    identifier = identifier,
    name = "Food Rush",
    description = "App de delivery completo",
    developer = "CBR CITY",
    defaultApp = false,
    size = 89650,
    ui = GetCurrentResourceName() .. "/ui/index.html",
    icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/logo_foodrush.png",
    fixBlur = true
}

-- Variáveis de estado
local AppState = {
    currentUserType = nil,
    isDelivering = false,
    currentDelivery = nil,
    activeOrder = nil,
    deliveryBlip = nil,
    deliveryRoute = nil,
    monitoringThread = nil
}

-- Constantes
local INTERACTION_DISTANCE = {
    RESTAURANT = 8.0,
    CLIENT = 10.0,
    ABANDON_ORDER = 40.0
}

local MARKER_CONFIG = {
    type = 2,
    size = {0.3, 0.3, 0.3},
    color = {50, 205, 50, 180},
    bobUpAndDown = false,
    faceCamera = true,
    rotate = false
}

-- ============================================================================
-- FUNÇÕES DE INICIALIZAÇÃO
-- ============================================================================

local function addApp()
    local added, errorMessage = exports["lb-phone"]:AddCustomApp(appConfig)
    
    if not added then
        if Config.Debug then
        end
    else
        if Config.Debug then
        end
    end
end

-- Eventos de inicialização
addApp()

AddEventHandler("onResourceStart", function(resource)
    if resource == "lb-phone" then
        addApp()
    end
end)

-- ============================================================================
-- FUNÇÕES UTILITÁRIAS
-- ============================================================================

local function sendNotification(title, content)
    exports["lb-phone"]:SendNotification({
        app = identifier,
        title = title,
        content = content,
    })
end

local function debugPrint(message)
    if Config.Debug then
    end
end

local function updateAppState(key, value)
    AppState[key] = value
end

local function clearDeliveryData()
    updateAppState("isDelivering", false)
    updateAppState("currentDelivery", nil)
    ClearDeliveryRoute()
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 100)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 450
    DrawRect(_x, _y + 0.0125, 0.01 + factor, 0.03, 0, 0, 0, 100)
end

-- ============================================================================
-- SISTEMA DE MONITORAMENTO DE DISTÂNCIA
-- ============================================================================

local function startDistanceMonitoring(orderId, originalCoords)
    if AppState.monitoringThread then
        return -- Já está monitorando
    end
    
    AppState.monitoringThread = CreateThread(function()
        
        while AppState.activeOrder and AppState.activeOrder.id == orderId do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - vector3(originalCoords.x, originalCoords.y, originalCoords.z))
            
            if distance > INTERACTION_DISTANCE.ABANDON_ORDER then
                
                vSERVER.anulateOrder(orderId)
                sendNotification("Pedido Anulado", "Você saiu do local do pedido e foi multado. Pedido anulado.")
                
                updateAppState("activeOrder", nil)
                break
            end


            
            Wait(5000) -- Verifica a cada 5 segundos
        end
        
        AppState.monitoringThread = nil
    end)
end

local function stopDistanceMonitoring()
    if AppState.monitoringThread then
        AppState.monitoringThread = nil
    end
end

-- ============================================================================
-- SISTEMA DE ENTREGA E ROTAS
-- ============================================================================

function ClearDeliveryRoute()
    if AppState.deliveryBlip and DoesBlipExist(AppState.deliveryBlip) then
        RemoveBlip(AppState.deliveryBlip)
        AppState.deliveryBlip = nil
    end
end

local function createInteractionMarker(coords, label, onInteract)
    CreateThread(function()
        while AppState.deliveryBlip and DoesBlipExist(AppState.deliveryBlip) do
            local time = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - vector3(coords.x, coords.y, coords.z))
            
            if distance < INTERACTION_DISTANCE.RESTAURANT then
                time = 0
                
                -- Desenhar marker
                DrawMarker(
                    MARKER_CONFIG.type,
                    coords.x, coords.y, coords.z - 0.6,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    MARKER_CONFIG.size[1], MARKER_CONFIG.size[2], MARKER_CONFIG.size[3],
                    MARKER_CONFIG.color[1], MARKER_CONFIG.color[2], MARKER_CONFIG.color[3], MARKER_CONFIG.color[4],
                    MARKER_CONFIG.bobUpAndDown, MARKER_CONFIG.faceCamera, 2, nil, nil, MARKER_CONFIG.rotate
                )
                
                DrawText3D(coords.x, coords.y, coords.z, "Pressione ~g~[E]~w~ para " .. label)
                
                if IsControlJustReleased(0, 38) then -- E key
                    onInteract()
                    break
                end
            end
            
            Wait(time)
        end
    end)
end

function CreateDeliveryRoute(coords, orderId, label)
    ClearDeliveryRoute()
    
    
    -- Criar blip
    AppState.deliveryBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(AppState.deliveryBlip, 280)
    SetBlipColour(AppState.deliveryBlip, 5)
    SetBlipRoute(AppState.deliveryBlip, true)
    SetBlipRouteColour(AppState.deliveryBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(AppState.deliveryBlip)
    
    -- Configurar interação baseada no tipo
    if label == "Restaurante" then
        createInteractionMarker(coords, label, function()
            sendNotification("Coleta concluída!", "Você coletou no " .. label:lower())
            ClearDeliveryRoute()
            confirmPickup(orderId)
        end)
    elseif label == "Cliente" then
        CreateThread(function()
            while AppState.deliveryBlip and DoesBlipExist(AppState.deliveryBlip) do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - vector3(coords.x, coords.y, coords.z))
                
                if distance < INTERACTION_DISTANCE.CLIENT then
                    ClearDeliveryRoute()
                    sendNotification("Chegou ao destino!", "Você chegou ao local de entrega. Digite o código para concluir.")
                    break
                end
                
                Wait(1000)
            end
        end)
    end
end

-- ============================================================================
-- CALLBACKS DO NUI - ORGANIZADOS POR CATEGORIA
-- ============================================================================

-- === AUTENTICAÇÃO E DADOS GERAIS ===

RegisterNUICallback("getAppData", function(data, cb)
    
    local result = vSERVER.getAppData({})
    cb(result or { success = false, message = "Usuário não encontrado" })
end)

RegisterNUICallback("login", function(data, cb)
    local userType = data.userType
    
    local result = vSERVER.loginUser(userType)
    
    if result.success then
        updateAppState("currentUserType", userType)
        sendNotification("FoodRush", "Login realizado como " .. (userType == "customer" and "Cliente" or "Entregador"))
    else
        sendNotification("FoodRush", result.message)
    end
    
    cb(result)
end)

-- === ENTREGADOR - FUNÇÕES ===

RegisterNUICallback("getActiveDelivery", function(data, cb)
    
    local result = vSERVER.getActiveDelivery()
    
    if result.success and result.delivery then
        updateAppState("isDelivering", true)
        updateAppState("currentDelivery", result.delivery)
    end
    
    cb(result)
end)

RegisterNUICallback("setDelivererAvailability", function(data, cb)
    local isAvailable = data.isAvailable
    
    local result = vSERVER.setDelivererAvailability(isAvailable)
    cb(result)
end)

RegisterNUICallback("getAvailableDeliveries", function(data, cb)
    
    local result = vSERVER.getAvailableDeliveries()
    cb(result)
end)

RegisterNUICallback("acceptDelivery", function(data, cb)
    local orderId = data.orderId
    
    local result = vSERVER.acceptDelivery(orderId)
    
    if result.success then
        updateAppState("isDelivering", true)
        updateAppState("currentDelivery", result.delivery)
        
        sendNotification("Entrega Aceita!", "Vá buscar o pedido no restaurante")
        CreateDeliveryRoute(result.delivery.restaurantCoords, orderId, "Restaurante")
    end
    
    cb(result)
end)

RegisterNUICallback("cancelActiveDelivery", function(data, cb)
    local orderId = data.orderId
    
    local result = vSERVER.cancelActiveDelivery(orderId)
    
    if result.success then
        clearDeliveryData()
        sendNotification("Entrega Cancelada", "A entrega foi cancelada com sucesso")
    end
    
    cb(result)
end)

RegisterNUICallback("deliverOrder", function(data, cb)
    local orderId = data.orderId
    local code = data.code
    
    local result = vSERVER.deliverOrder(orderId, code)
    
    if result.success then
        clearDeliveryData()
        sendNotification("Entrega Concluída!", "Você ganhou " .. Config.FormatPrice(result.earnings))
    else
        sendNotification("Erro na Entrega", result.message or "Verifique o código!")
    end
    
    cb(result)
end)

-- === CLIENTE - FUNÇÕES ===

RegisterNUICallback("getRestaurants", function(data, cb)
    
    local restaurants = {}
    for _, restaurant in ipairs(Config.Restaurants) do
        table.insert(restaurants, {
            id = restaurant.id,
            name = restaurant.name,
            description = restaurant.description,
            logo = restaurant.logo,
            category = restaurant.category,
            rating = restaurant.rating,
            deliveryTime = restaurant.deliveryTime,
            isOpen = restaurant.isOpen,
            deliveryFee = restaurant.deliveryFee,
            minOrder = restaurant.minOrder
        })
    end
    
    cb({success = true, restaurants = restaurants})
end)

RegisterNUICallback("getRestaurantMenu", function(data, cb)
    local restaurantId = data.restaurantId
    
    local restaurant = Config.GetRestaurantById(restaurantId)
    if restaurant then
        cb({
            success = true,
            restaurant = restaurant,
            menu = restaurant.menu
        })
    else
        cb({success = false, message = "Restaurante não encontrado"})
    end
end)

RegisterNUICallback("placeOrder", function(data, cb)
    
    local result = vSERVER.placeOrder(data)
    
    if result.success then
        updateAppState("activeOrder", result.order)
        
        -- Iniciar monitoramento de distância
        local playerCoords = GetEntityCoords(PlayerPedId())
        startDistanceMonitoring(result.order.id, playerCoords)
        
        sendNotification("Pedido Confirmado!", "Seu pedido #" .. result.order.id .. " foi confirmado!")
    end

    cb(result)
end)

RegisterNUICallback("getMyOrders", function(data, cb)
    
    local result = vSERVER.getMyOrders({})
    cb(result)
end)

RegisterNUICallback("cancelOrder", function(data, cb)
    local orderId = data.orderId
    
    local result = vSERVER.cancelOrder(orderId)
    
    if result.success then
        sendNotification("Pedido Cancelado", "Seu pedido foi cancelado com sucesso")
        
        -- Parar monitoramento se for o pedido ativo
        if AppState.activeOrder and AppState.activeOrder.id == orderId then
            stopDistanceMonitoring()
            updateAppState("activeOrder", nil)
        end
    end
    
    cb(result)
end)

RegisterNUICallback("getOrderStatus", function(data, cb)
    local orderId = data.orderId
    
    local result = vSERVER.getOrderStatus(orderId)
    cb(result)
end)

-- ============================================================================
-- FUNÇÕES ESPECÍFICAS DA ENTREGA
-- ============================================================================

function confirmPickup(orderId)
    
    local result = vSERVER.confirmPickup(orderId)
    
    if result.success then
        CreateDeliveryRoute(result.delivery.customerCoords, orderId, "Cliente")
    end
end

-- ============================================================================
-- FUNÇÕES DO SERVIDOR (CALLBACKS)
-- ============================================================================

function src.anulateOrderClient(orderId)
    exports["lb-phone"]:SendCustomAppMessage(identifier, {
        action = "anulateActiveDelivery",
        data = {
            orderId = orderId
        }
    })
    
    clearDeliveryData()
    stopDistanceMonitoring()
    updateAppState("activeOrder", nil)
end

function src.endDistanceThread()
    stopDistanceMonitoring()
end

-- ============================================================================
-- EVENTOS DE REDE
-- ============================================================================

RegisterNetEvent("foodrush:orderUpdated")
AddEventHandler("foodrush:orderUpdated", function(order)
    if AppState.activeOrder and AppState.activeOrder.id == order.id then
        updateAppState("activeOrder", order)
        
        local statusMessages = {
            confirmed = "Seu pedido foi confirmado pelo restaurante!",
            preparing = "Seu pedido está sendo preparado!",
            ready = "Seu pedido está pronto para ser coletado por um entregador!",
            pickup = "Seu pedido foi aceito por um entregador!",
            delivering = "Seu pedido está a caminho",
            delivered = "Seu pedido foi entregue!",
            cancelled = "Seu pedido foi cancelado!"
        }

       
        
        if statusMessages[order.status] then
            exports["lb-phone"]:SendCustomAppMessage(identifier, {
                action = "consumerOrderUpdated",
                data = {}
            })
            sendNotification("Pedido #" .. order.id, statusMessages[order.status])
            -- Parar monitoramento quando entregue
            if order.status == "delivered" then
                stopDistanceMonitoring()
            end
        end
    end
end)

RegisterNetEvent("foodrush:newDeliveryAvailable")
AddEventHandler("foodrush:newDeliveryAvailable", function(delivery)
    if AppState.currentUserType == "deliverer" and not AppState.isDelivering then
        exports["lb-phone"]:SendCustomAppMessage(identifier, {
            action = "newDeliveryAvailable",
            data = {
                label = "Nova Entrega",
                coords = {x = 123.4, y = -456.7, z = 21.0}
            }
        })
        
        sendNotification("Nova Entrega Disponível!", "Ganhe " .. Config.FormatPrice(delivery.earnings) .. " - Abra o app para aceitar")
    end
end)

local blips = {}

RegisterNetEvent('sj:blip', function(type, x, y, z)
  local isUber = type == 'uber'

  local blip = blips[type]
  if not blip then
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, isUber and 198 or 348)
    SetBlipColour(blip, 0)
    SetBlipRoute(blip, true)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(isUber and 'Motorista' or 'Entregador')
    EndTextCommandSetBlipName(blip)
    blips[type] = blip
  else
    SetBlipCoords(blip, x, y, z)
    SetBlipRoute(blip, true)
  end
end)  

RegisterNetEvent('sj:rmblip', function(type)
  if type and blips[type] then
    RemoveBlip(blips[type])
  end
end)  

RegisterNetEvent("foodrush:updateAvailableDeliveries")
AddEventHandler("foodrush:updateAvailableDeliveries", function()
    if AppState.currentUserType == "deliverer" and not AppState.isDelivering then
        exports["lb-phone"]:SendCustomAppMessage(identifier, {
            action = "updateAvailableDeliveries"
        })
    end
end)
