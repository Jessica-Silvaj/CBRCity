-----------------------------------------------------------------------------------------------------------------------------------------
-- ESX COMPATIBILIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
ESX = {}

local function CreateExtendedPlayer(source, user_id)
    local self = {}
    self.source = source
    self.identifier = user_id
    self.name = ""
    
    if vRP.Identity then
        local identity = vRP.Identity(user_id)
        if identity then
            self.name = (identity.Name or "") .. " " .. (identity.LastName or "")
        end
    end

    self.getIdentifier = function()
        return self.identifier
    end

    self.getName = function()
        return self.name
    end

    self.getMoney = function()
        return vRP.ItemAmount(self.identifier, "dollar")
    end

    self.addMoney = function(money)
        vRP.GiveItem(self.identifier, "dollar", money, false)
    end

    self.removeMoney = function(money)
        vRP.TakeItem(self.identifier, "dollar", money, false)
    end

    self.getJob = function()
        -- Fallback to unemployed. A real implementation would parse vRP.UserGroups
        return {
            name = "unemployed",
            label = "Desempregado",
            grade = 0,
            grade_name = "unemployed",
            grade_label = "Desempregado"
        }
    end

    self.getAccount = function(account)
        if account == "bank" then
            return { name = "bank", money = vRP.GetBank(self.identifier) }
        elseif account == "money" or account == "cash" then
            return { name = account, money = self.getMoney() }
        end
        return { name = account, money = 0 }
    end

    self.addAccountMoney = function(account, money)
        if account == "bank" then
            vRP.GiveBank(self.identifier, money, false)
        elseif account == "money" or account == "cash" then
            self.addMoney(money)
        end
    end

    self.removeAccountMoney = function(account, money)
        if account == "bank" then
            vRP.RemoveBank(self.identifier, money)
        elseif account == "money" or account == "cash" then
            self.removeMoney(money)
        end
    end

    self.getInventoryItem = function(itemName)
        return {
            name = itemName,
            count = vRP.ItemAmount(self.identifier, itemName),
            label = itemName,
            weight = 0,
            usable = false,
            rare = false,
            canRemove = true
        }
    end

    self.addInventoryItem = function(itemName, count)
        vRP.GiveItem(self.identifier, itemName, count, false)
    end

    self.removeInventoryItem = function(itemName, count)
        vRP.TakeItem(self.identifier, itemName, count, false)
    end

    self.hasItem = function(itemName)
        local item = self.getInventoryItem(itemName)
        return item and item.count > 0 and item or false
    end

    self.showNotification = function(msg)
        TriggerClientEvent("Notify", self.source, "amarelo", msg)
    end
    
    return self
end

ESX.GetPlayerFromId = function(source)
    local user_id = vRP.Passport(source)
    if user_id then
        return CreateExtendedPlayer(source, user_id)
    end
    return nil
end

ESX.GetPlayers = function()
    local players = vRP.Players()
    local sources = {}
    for user_id, src in pairs(players) do
        table.insert(sources, src)
    end
    return sources
end

ESX.GetPlayerFromIdentifier = function(identifier)
    local user_id = parseInt(identifier)
    local source = vRP.Source(user_id)
    if source then
        return CreateExtendedPlayer(source, user_id)
    end
    return nil
end

ESX.RegisterServerCallback = function(name, cb)
    -- This is a placeholder since callbacks work differently per framework.
    -- If you need ESX callbacks, you'll need an event handler that triggers the cb.
    -- Many ESX scripts rely heavily on this.
end

RegisterNetEvent('esx:getSharedObject', function(cb)
    cb(ESX)
end)