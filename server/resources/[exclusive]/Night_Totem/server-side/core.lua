-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = {}
local Cooldowns = {}
local LastRestaurantNotify = {}
local LastAutoRestock = 0
local Resource = GetCurrentResourceName()
local DataPrefix = "night_totem:"

-----------------------------------------------------------------------------------------------------------------------------------------
-- DATABASE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `totem` (
          `totem_id` varchar(100) NOT NULL,
          `data` longtext NOT NULL,
          PRIMARY KEY (`totem_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

local function GetTotemData(totemId)
    local result = MySQL.query.await("SELECT data FROM totem WHERE totem_id = ?", {totemId})
    if result and result[1] then
        return json.decode(result[1].data) or {}
    end
    return {}
end

local function SetTotemData(totemId, state)
    local dataString = json.encode(state)
    MySQL.query.await("INSERT INTO totem (totem_id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {totemId, dataString, dataString})
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("night_totem:requestOpen",function(totemId)
    local source = source
    local now = os.time()

    Cooldowns[source] = Cooldowns[source] or {}
    if Cooldowns[source].requestOpen and Cooldowns[source].requestOpen > now then
        return
    end
    Cooldowns[source].requestOpen = now + 1

    if type(totemId) ~= "string" or not Totem.Restaurants[totemId] then
        return
    end

    local Passport = vRP.Passport(source)
    if not Passport then
        return
    end

    local totem = Totem.Restaurants[totemId]
    if not totem.Machine or not totem.Machine.Coords then
        return
    end

    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then
        return
    end

    local coords = totem.Machine.Coords
    local playerCoords = GetEntityCoords(ped)
    local openDistance = Totem.Interaction and Totem.Interaction.ServerOpenDistance or 10.0
    if #(playerCoords - vec3(coords.x + 0.0,coords.y + 0.0,coords.z + 0.0)) > openDistance then
        return
    end

    local adminPermission = totem.GroupName
    if totem.AdminHierarchy and tonumber(totem.AdminHierarchy) and tonumber(totem.AdminHierarchy) > 0 then
        adminPermission = tostring(totem.GroupName).."-"..tostring(math.floor(tonumber(totem.AdminHierarchy)))
    end

    local isAdmin = totem.GroupName and vRP.HasPermission(Passport,adminPermission) and true or false

    if Totem.Blocking and Totem.Blocking.Enabled == true and not isAdmin and totem.GroupName then
        local servicePermission = totem.GroupName
        if totem.ServiceHierarchy and tonumber(totem.ServiceHierarchy) and tonumber(totem.ServiceHierarchy) > 0 then
            servicePermission = tostring(totem.GroupName).."-"..tostring(math.floor(tonumber(totem.ServiceHierarchy)))
        end

        local radius = Totem.Blocking.Radius or 25.0
        for _,player in ipairs(GetPlayers()) do
            local target = tonumber(player)
            if target and target ~= source then
                local targetPassport = vRP.Passport(target)
                if targetPassport and vRP.HasService(targetPassport,servicePermission) then
                    local targetPed = GetPlayerPed(target)
                    if targetPed and targetPed ~= 0 then
                        local targetCoords = GetEntityCoords(targetPed)
                        if #(targetCoords - vec3(coords.x + 0.0,coords.y + 0.0,coords.z + 0.0)) <= radius then
                            TriggerClientEvent("Notify",source,"Erro",Totem.Blocking.BlockedMessage or "O totem esta fechado.","vermelho",5000)
                            return
                        end
                    end
                end
            end
        end
    end

    local state = GetTotemData(DataPrefix..totemId)
    if type(state) ~= "table" then
        state = {}
    end

    state.items = type(state.items) == "table" and state.items or {}
    state.revenue = math.max(0,math.floor(tonumber(state.revenue) or 0))
    state.totalSales = math.max(0,math.floor(tonumber(state.totalSales) or 0))

    for item,config in pairs(totem.Items or {}) do
        if type(state.items[item]) ~= "table" then
            state.items[item] = {}
        end

        state.items[item].stock = math.max(0,math.floor(tonumber(state.items[item].stock) or 0))
        state.items[item].price = math.max(0,math.floor(tonumber(state.items[item].price) or 0))

        if state.items[item].price <= 0 then
            state.items[item].price = math.max(0,math.floor(tonumber(config.DefaultPrice) or 0))
        end
    end

    local totalStock = 0
    for item in pairs(totem.Items or {}) do
        totalStock = totalStock + math.max(0,math.floor(tonumber(state.items[item] and state.items[item].stock) or 0))
    end

    if Totem.SmartStock and Totem.SmartStock.Enabled == true and totalStock <= 0 then
        local groupOnline = false
        local servicePermission = totem.GroupName
        if totem.ServiceHierarchy and tonumber(totem.ServiceHierarchy) and tonumber(totem.ServiceHierarchy) > 0 then
            servicePermission = tostring(totem.GroupName).."-"..tostring(math.floor(tonumber(totem.ServiceHierarchy)))
        end

        if servicePermission then
            for _,player in ipairs(GetPlayers()) do
                local target = tonumber(player)
                local targetPassport = target and vRP.Passport(target)
                if targetPassport and vRP.HasService(targetPassport,servicePermission) then
                    groupOnline = true
                    break
                end
            end
        end

        local otherTotem = nil
        local otherDistance = nil
        for id,restaurant in pairs(Totem.Restaurants) do
            if id ~= totemId then
                local otherState = GetTotemData(DataPrefix..id)
                if type(otherState) ~= "table" then
                    otherState = {}
                end

                otherState.items = type(otherState.items) == "table" and otherState.items or {}

                local otherStock = 0
                for item in pairs(restaurant.Items or {}) do
                    otherStock = otherStock + math.max(0,math.floor(tonumber(otherState.items[item] and otherState.items[item].stock) or 0))
                end

                if otherStock > 0 and restaurant.Machine and restaurant.Machine.Coords then
                    local otherCoords = restaurant.Machine.Coords
                    local distance = #(playerCoords - vec3(otherCoords.x + 0.0,otherCoords.y + 0.0,otherCoords.z + 0.0))

                    if not otherDistance or distance < otherDistance then
                        otherDistance = distance
                        otherTotem = {
                            id = id,
                            x = otherCoords.x + 0.0,
                            y = otherCoords.y + 0.0,
                            stock = otherStock
                        }
                    end
                end
            end
        end

        if not otherTotem and Totem.SmartStock.AutoRestock and Totem.SmartStock.AutoRestock.Enabled == true then
            local allowAutoRestock = true

            if Totem.SmartStock.AutoRestock.OnlyWhenNoGroupOnline == true and groupOnline then
                allowAutoRestock = false
            end

            if LastAutoRestock > now then
                allowAutoRestock = false
            end

            if allowAutoRestock then
                local amount = math.max(0,math.floor(tonumber(Totem.SmartStock.AutoRestock.AmountPerItem) or 0))
                local maxStock = math.max(0,math.floor(tonumber(Totem.Stock and Totem.Stock.MaxStock) or 0))
                local affected = 0
                local total = 0

                if amount > 0 and maxStock > 0 then
                    for id,restaurant in pairs(Totem.Restaurants) do
                        local restockState = GetTotemData(DataPrefix..id)
                        if type(restockState) ~= "table" then
                            restockState = {}
                        end

                        restockState.items = type(restockState.items) == "table" and restockState.items or {}
                        restockState.revenue = math.max(0,math.floor(tonumber(restockState.revenue) or 0))
                        restockState.totalSales = math.max(0,math.floor(tonumber(restockState.totalSales) or 0))

                        local changed = false
                        for item,config in pairs(restaurant.Items or {}) do
                            if type(restockState.items[item]) ~= "table" then
                                restockState.items[item] = {}
                            end

                            restockState.items[item].stock = math.max(0,math.floor(tonumber(restockState.items[item].stock) or 0))
                            restockState.items[item].price = math.max(0,math.floor(tonumber(restockState.items[item].price) or 0))

                            if restockState.items[item].price <= 0 then
                                restockState.items[item].price = math.max(0,math.floor(tonumber(config.DefaultPrice) or 0))
                            end

                            local add = math.min(amount,math.max(0,maxStock - restockState.items[item].stock))
                            if add > 0 then
                                restockState.items[item].stock = restockState.items[item].stock + add
                                total = total + add
                                changed = true
                            end
                        end

                        if changed then
                            SetTotemData(DataPrefix..id, restockState)
                            affected = affected + 1
                        end
                    end

                    if affected > 0 then
                        LastAutoRestock = now + (Totem.SmartStock.AutoRestock.CooldownSeconds or 900)
                        state = GetTotemData(DataPrefix..totemId)
                        if type(state) ~= "table" then
                            state = {}
                        end

                        state.items = type(state.items) == "table" and state.items or {}
                        state.revenue = math.max(0,math.floor(tonumber(state.revenue) or 0))
                        state.totalSales = math.max(0,math.floor(tonumber(state.totalSales) or 0))

                        for item,config in pairs(totem.Items or {}) do
                            if type(state.items[item]) ~= "table" then
                                state.items[item] = {}
                            end

                            state.items[item].stock = math.max(0,math.floor(tonumber(state.items[item].stock) or 0))
                            state.items[item].price = math.max(0,math.floor(tonumber(state.items[item].price) or 0))

                            if state.items[item].price <= 0 then
                                state.items[item].price = math.max(0,math.floor(tonumber(config.DefaultPrice) or 0))
                            end
                        end

                        local message = string.format((Totem.SmartStock.Messages and Totem.SmartStock.Messages.AutoRestocked) or "Reposicao automatica aplicada (%s itens em %s totem(ns)).",total,affected)
                        TriggerClientEvent("Notify",source,"Sucesso",message,"verde",7000)
                    end
                end
            end
        elseif otherTotem then
            if Totem.SmartStock.NotifyWhenOtherTotemHasStock == true then
                local message = string.format((Totem.SmartStock.Messages and Totem.SmartStock.Messages.OtherTotemStock) or "Sem estoque aqui. Use o totem %s (estoque total: %s).",otherTotem.id,otherTotem.stock)
                TriggerClientEvent("Notify",source,"Atenção",message,"amarelo",7000)
            end

            if Totem.SmartStock.MarkNearestTotemWithStock == true then
                TriggerClientEvent("night_totem:setWaypoint",source,{
                    x = otherTotem.x,
                    y = otherTotem.y,
                    totemId = otherTotem.id,
                    showNotify = false
                })

                if Totem.SmartStock.Messages and Totem.SmartStock.Messages.WaypointSetShort then
                    TriggerClientEvent("Notify",source,"Atenção",Totem.SmartStock.Messages.WaypointSetShort,"amarelo",5000)
                end
            end
        elseif Totem.SmartStock.NotifyWhenNoGroupOnline == true and not groupOnline then
            local message = string.format((Totem.SmartStock.Messages and Totem.SmartStock.Messages.NoGroupOnline) or "Nao ha funcionarios de %s online para reabastecer agora.",totem.GroupName or "restaurante")
            TriggerClientEvent("Notify",source,"Atenção",message,"amarelo",7000)
        elseif Totem.SmartStock.NotifyWhenOutOfStock == true then
            TriggerClientEvent("Notify",source,"Erro",(Totem.SmartStock.Messages and Totem.SmartStock.Messages.OutOfStock) or "Este totem esta sem estoque no momento.","vermelho",7000)
        end

        if Totem.SmartStock.NotifyRestaurantMembersWhenOutOfStock == true and totem.GroupName then
            local cooldown = Totem.SmartStock.RestaurantNotifyCooldownSeconds or 120
            if not LastRestaurantNotify[totemId] or LastRestaurantNotify[totemId] <= now then
                LastRestaurantNotify[totemId] = now + cooldown

                local name = vRP.FullName(Passport) or ("Passaporte "..tostring(Passport))
                local message = string.format((Totem.SmartStock.Messages and Totem.SmartStock.Messages.NotifyRestaurantMembers) or "[Totem %s] %s abriu o totem sem estoque.",totemId,name)

                for _,player in ipairs(GetPlayers()) do
                    local target = tonumber(player)
                    local targetPassport = target and vRP.Passport(target)
                    if targetPassport and vRP.HasPermission(targetPassport,totem.GroupName) then
                        TriggerClientEvent("Notify",target,"Atenção",message,"amarelo",7000)
                    end
                end
            end
        end
    end

    local items = {}
    for item,config in pairs(totem.Items or {}) do
        local itemIndex = (exports.vrp and pcall(function() return exports.vrp:ItemIndex(item) end) and exports.vrp:ItemIndex(item)) or (vRP.ItemIndex and exports.vrp:ItemIndex(item)) or (vRP.itemIndexList and vRP.itemIndexList(item)) or tostring(item)
        items[#items + 1] = {
            id = item,
            name = config.Name or (exports.vrp and pcall(function() return exports.vrp:ItemName(item) end) and exports.vrp:ItemName(item)) or (vRP.ItemName and exports.vrp:ItemName(item)) or (vRP.itemNameList and vRP.itemNameList(item)) or tostring(item),
            price = math.max(0,math.floor(tonumber(state.items[item] and state.items[item].price) or tonumber(config.DefaultPrice) or 0)),
            stock = math.max(0,math.floor(tonumber(state.items[item] and state.items[item].stock) or 0)),
            image = config.Image or tostring((Totem.Images and Totem.Images.BaseUrl) or "")..string.lower(tostring(itemIndex))..tostring((Totem.Images and Totem.Images.Extension) or ".png"),
            defaultPrice = math.max(0,math.floor(tonumber(config.DefaultPrice) or 0))
        }
    end

    table.sort(items,function(a,b)
        return tostring(a.name) < tostring(b.name)
    end)

    local bulkPermission = Totem.BulkRestock and Totem.BulkRestock.Permission

    Opened[source] = totemId
    TriggerClientEvent("night_totem:openPanel",source,totemId,{
        totemId = totemId,
        banner = totem.Banner or "",
        themeColor = totem.ThemeColor or Totem.DefaultThemeColor or "#0143BB",
        isAdmin = isAdmin,
        canBulkRestock = isAdmin and bulkPermission and bulkPermission ~= "" and vRP.HasPermission(Passport,bulkPermission) and true or false,
        items = items,
        revenue = state.revenue,
        totalSales = state.totalSales,
        currencyPrefix = (Totem.Currency and Totem.Currency.Prefix) or "R$ ",
        currencySuffix = (Totem.Currency and Totem.Currency.Suffix) or "",
        currencySeparator = (Totem.Currency and Totem.Currency.Separator) or ".",
        priceMin = math.max(0,math.floor(tonumber(Totem.PriceRange and Totem.PriceRange.Min) or 0)),
        priceMax = math.max(0,math.floor(tonumber(Totem.PriceRange and Totem.PriceRange.Max) or 0)),
        maxStock = math.max(0,math.floor(tonumber(Totem.Stock and Totem.Stock.MaxStock) or 0))
    })
end)

RegisterNetEvent("night_totem:closeTotem",function()
    Opened[source] = nil
end)

RegisterNetEvent("night_totem:propNotFound",function(totemId,propName)
    local source = source
    local now = os.time()

    Cooldowns[source] = Cooldowns[source] or {}
    if Cooldowns[source].propNotFound and Cooldowns[source].propNotFound > now then
        return
    end
    Cooldowns[source].propNotFound = now + 30

    print(("^1[%s]^7 Prop nao encontrado no cliente %s: totem=%s prop=%s"):format(Resource,source,tostring(totemId),tostring(propName)))
end)

RegisterNetEvent("night_totem:handleAction",function(action,data)
    local source = source
    local now = os.time()

    Cooldowns[source] = Cooldowns[source] or {}
    if Cooldowns[source].handleAction and Cooldowns[source].handleAction > now then
        return
    end
    Cooldowns[source].handleAction = now + 1

    local Passport = vRP.Passport(source)
    if not Passport then
        return
    end

    local totemId = Opened[source]
    if not totemId or not Totem.Restaurants[totemId] then
        return
    end

    local totem = Totem.Restaurants[totemId]
    if not totem.Machine or not totem.Machine.Coords then
        return
    end

    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then
        Opened[source] = nil
        return
    end

    local coords = totem.Machine.Coords
    local playerCoords = GetEntityCoords(ped)
    local openDistance = Totem.Interaction and Totem.Interaction.ServerOpenDistance or 10.0
    if #(playerCoords - vec3(coords.x + 0.0,coords.y + 0.0,coords.z + 0.0)) > openDistance then
        Opened[source] = nil
        return
    end

    local adminPermission = totem.GroupName
    if totem.AdminHierarchy and tonumber(totem.AdminHierarchy) and tonumber(totem.AdminHierarchy) > 0 then
        adminPermission = tostring(totem.GroupName).."-"..tostring(math.floor(tonumber(totem.AdminHierarchy)))
    end

    local isAdmin = totem.GroupName and vRP.HasPermission(Passport,adminPermission) and true or false
    local state = GetTotemData(DataPrefix..totemId)
    if type(state) ~= "table" then
        state = {}
    end

    state.items = type(state.items) == "table" and state.items or {}
    state.revenue = math.max(0,math.floor(tonumber(state.revenue) or 0))
    state.totalSales = math.max(0,math.floor(tonumber(state.totalSales) or 0))

    for item,config in pairs(totem.Items or {}) do
        if type(state.items[item]) ~= "table" then
            state.items[item] = {}
        end

        state.items[item].stock = math.max(0,math.floor(tonumber(state.items[item].stock) or 0))
        state.items[item].price = math.max(0,math.floor(tonumber(state.items[item].price) or 0))

        if state.items[item].price <= 0 then
            state.items[item].price = math.max(0,math.floor(tonumber(config.DefaultPrice) or 0))
        end
    end

    if action == "confirm" then
        if type(data) ~= "table" or type(data.order) ~= "table" then
            return
        end

        if Totem.Blocking and Totem.Blocking.Enabled == true and not isAdmin and totem.GroupName then
            local servicePermission = totem.GroupName
            if totem.ServiceHierarchy and tonumber(totem.ServiceHierarchy) and tonumber(totem.ServiceHierarchy) > 0 then
                servicePermission = tostring(totem.GroupName).."-"..tostring(math.floor(tonumber(totem.ServiceHierarchy)))
            end

            local radius = Totem.Blocking.Radius or 25.0
            for _,player in ipairs(GetPlayers()) do
                local target = tonumber(player)
                if target and target ~= source then
                    local targetPassport = vRP.Passport(target)
                    if targetPassport and vRP.HasService(targetPassport,servicePermission) then
                        local targetPed = GetPlayerPed(target)
                        if targetPed and targetPed ~= 0 then
                            local targetCoords = GetEntityCoords(targetPed)
                            if #(targetCoords - vec3(coords.x + 0.0,coords.y + 0.0,coords.z + 0.0)) <= radius then
                                TriggerClientEvent("Notify",source,"Erro",Totem.Blocking.BlockedMessage or "O totem esta fechado.","vermelho",5000)
                                return
                            end
                        end
                    end
                end
            end
        end

        local order = {}
        local total = 0

        for _,entry in ipairs(data.order) do
            if type(entry) ~= "table" then
                return
            end

            local item = tostring(entry.id or "")
            local quantity = math.floor(tonumber(entry.quantity) or 0)

            if quantity <= 0 or not totem.Items[item] then
                return
            end

            local price = math.max(0,math.floor(tonumber(state.items[item] and state.items[item].price) or tonumber(totem.Items[item].DefaultPrice) or 0))
            local stock = math.max(0,math.floor(tonumber(state.items[item] and state.items[item].stock) or 0))

            if price <= 0 or stock < quantity then
                TriggerClientEvent("Notify",source,"Erro","Estoque insuficiente.","vermelho",5000)
                return
            end

            total = total + (price * quantity)
            order[#order + 1] = {
                item = item,
                quantity = quantity,
                price = price
            }
        end

        if #order <= 0 or total <= 0 then
            return
        end

        for _,entry in ipairs(order) do
            if not vRP.CheckWeight(Passport,entry.item,entry.quantity) or vRP.MaxItens(Passport,entry.item,entry.quantity) then
                TriggerClientEvent("Notify",source,"Erro","Mochila cheia ou limite do item atingido.","vermelho",5000)
                return
            end
        end

        if not vRP.PaymentFull(Passport,total,true) then
            TriggerClientEvent("Notify",source,"Erro","Pagamento recusado.","vermelho",5000)
            return
        end

        -- vRP.GenerateItem nao retorna valor, entao a entrega e validada antes do pagamento
        for _,entry in ipairs(order) do
            vRP.GenerateItem(Passport,entry.item,entry.quantity,true)
            state.items[entry.item].stock = state.items[entry.item].stock - entry.quantity
        end

        state.totalSales = state.totalSales + 1

        if Totem.Revenue and Totem.Revenue.Destination == "painel" and totem.GroupName and GetResourceState("night_painel") == "started" then
            local success = pcall(function()
                exports["night_painel"]:DirectAddMoney(totem.GroupName,total)
            end)

            if not success then
                state.revenue = state.revenue + total
            end
        else
            state.revenue = state.revenue + total
        end

        SetTotemData(DataPrefix..totemId, state)
        TriggerClientEvent("Notify",source,"Sucesso","Compra realizada com sucesso.","verde",5000)
    elseif action == "withdraw" then
        if not isAdmin then
            return
        end

        local amount = math.max(0,math.floor(tonumber(state.revenue) or 0))
        if amount <= 0 then
            TriggerClientEvent("Notify",source,"Atenção","Nao ha dinheiro para retirar.","amarelo",5000)
            return
        end

        state.revenue = 0
        SetTotemData(DataPrefix..totemId, state)

        if Totem.Withdraw and Totem.Withdraw.Item then
            vRP.GenerateItem(Passport,Totem.Withdraw.Item,amount,true)
        else
            vRP.GiveBank(Passport,amount,true)
        end

        TriggerClientEvent("Notify",source,"Sucesso","Retirada realizada com sucesso.","verde",5000)
    elseif action == "setPrice" then
        if not isAdmin or type(data) ~= "table" then
            return
        end

        local item = tostring(data.itemId or "")
        if not totem.Items[item] then
            return
        end

        local price = math.floor(tonumber(data.price) or 0)
        local min = math.max(0,math.floor(tonumber(Totem.PriceRange and Totem.PriceRange.Min) or 0))
        local max = math.max(0,math.floor(tonumber(Totem.PriceRange and Totem.PriceRange.Max) or 0))

        if max > 0 then
            price = math.min(price,max)
        end

        if price < min then
            price = min
        end

        if price <= 0 then
            return
        end

        state.items[item].price = price
        SetTotemData(DataPrefix..totemId, state)
        TriggerClientEvent("Notify",source,"Sucesso","Preco atualizado com sucesso.","verde",5000)
    elseif action == "restock" then
        if not isAdmin or type(data) ~= "table" then
            return
        end

        local item = tostring(data.itemId or "")
        local amount = math.floor(tonumber(data.amount) or 0)

        if amount <= 0 or not totem.Items[item] then
            return
        end

        local maxStock = math.max(0,math.floor(tonumber(Totem.Stock and Totem.Stock.MaxStock) or 0))
        local current = math.max(0,math.floor(tonumber(state.items[item] and state.items[item].stock) or 0))
        local add = math.min(amount,math.max(0,maxStock - current))

        if add <= 0 then
            TriggerClientEvent("Notify",source,"Atenção","Estoque ja esta no limite.","amarelo",5000)
            return
        end

        if Totem.Stock and Totem.Stock.RequireItems == true then
            local inventoryAmount = vRP.InventoryItemAmount(Passport,item)
            if type(inventoryAmount) == "table" then
                inventoryAmount = math.max(0,math.floor(tonumber(inventoryAmount[1]) or 0))
            else
                inventoryAmount = math.max(0,math.floor(tonumber(inventoryAmount) or 0))
            end

            if inventoryAmount < add then
                TriggerClientEvent("Notify",source,"Erro","Voce nao possui itens suficientes.",5000)
                return
            end

            if not vRP.TakeItem(Passport,item,add,true) then
                TriggerClientEvent("Notify",source,"Erro","Nao foi possivel remover os itens.",5000)
                return
            end
        end

        state.items[item].stock = current + add
        SetTotemData(DataPrefix..totemId, state)
        TriggerClientEvent("Notify",source,"Sucesso","Estoque atualizado com sucesso.","verde",5000)
    elseif action == "restockAll" then
        if not isAdmin or type(data) ~= "table" then
            return
        end

        local bulkPermission = Totem.BulkRestock and Totem.BulkRestock.Permission
        if not bulkPermission or bulkPermission == "" or not vRP.HasPermission(Passport,bulkPermission) then
            return
        end

        local amount = math.floor(tonumber(data.amount) or 0)
        local maxStock = math.max(0,math.floor(tonumber(Totem.Stock and Totem.Stock.MaxStock) or 0))

        if amount <= 0 or maxStock <= 0 then
            return
        end

        amount = math.min(amount,maxStock)

        local changed = false
        for item in pairs(totem.Items or {}) do
            local current = math.max(0,math.floor(tonumber(state.items[item] and state.items[item].stock) or 0))
            local add = math.min(amount,math.max(0,maxStock - current))

            if add > 0 then
                state.items[item].stock = current + add
                changed = true
            end
        end

        if not changed then
            TriggerClientEvent("Notify",source,"Atenção","Todos os itens ja estao no limite.","amarelo",5000)
            return
        end

        SetTotemData(DataPrefix..totemId, state)
        TriggerClientEvent("Notify",source,"Sucesso","Todos os estoques foram atualizados.","verde",5000)
    else
        return
    end

    local updatedState = GetTotemData(DataPrefix..totemId)
    if type(updatedState) ~= "table" then
        updatedState = {}
    end

    updatedState.items = type(updatedState.items) == "table" and updatedState.items or {}
    updatedState.revenue = math.max(0,math.floor(tonumber(updatedState.revenue) or 0))
    updatedState.totalSales = math.max(0,math.floor(tonumber(updatedState.totalSales) or 0))

    local items = {}
    for item,config in pairs(totem.Items or {}) do
        if type(updatedState.items[item]) ~= "table" then
            updatedState.items[item] = {}
        end

        updatedState.items[item].stock = math.max(0,math.floor(tonumber(updatedState.items[item].stock) or 0))
        updatedState.items[item].price = math.max(0,math.floor(tonumber(updatedState.items[item].price) or tonumber(config.DefaultPrice) or 0))

        local itemIndex = (exports.vrp and pcall(function() return exports.vrp:ItemIndex(item) end) and exports.vrp:ItemIndex(item)) or (vRP.ItemIndex and exports.vrp:ItemIndex(item)) or (vRP.itemIndexList and vRP.itemIndexList(item)) or tostring(item)
        items[#items + 1] = {
            id = item,
            name = config.Name or (exports.vrp and pcall(function() return exports.vrp:ItemName(item) end) and exports.vrp:ItemName(item)) or (vRP.ItemName and exports.vrp:ItemName(item)) or (vRP.itemNameList and vRP.itemNameList(item)) or tostring(item),
            price = updatedState.items[item].price,
            stock = updatedState.items[item].stock,
            image = config.Image or tostring((Totem.Images and Totem.Images.BaseUrl) or "")..string.lower(tostring(itemIndex))..tostring((Totem.Images and Totem.Images.Extension) or ".png"),
            defaultPrice = math.max(0,math.floor(tonumber(config.DefaultPrice) or 0))
        }
    end

    table.sort(items,function(a,b)
        return tostring(a.name) < tostring(b.name)
    end)

    TriggerClientEvent("night_totem:nuiMessage",source,"updateTotemState",{
        items = items,
        revenue = updatedState.revenue,
        totalSales = updatedState.totalSales
    })
end)

AddEventHandler("playerDropped",function()
    Opened[source] = nil
    Cooldowns[source] = nil
end)
