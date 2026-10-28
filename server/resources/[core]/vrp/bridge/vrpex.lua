-----------------------------------------------------------------------------------------------------------------------------------------
-- VRPEX COMPATIBILIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.getUserId = function(source)
    return vRP.Passport(source)
end

vRP.getUserSource = function(user_id)
    return vRP.Source(user_id)
end

vRP.getInventoryItemAmount = function(user_id, item)
    return vRP.ItemAmount(user_id, item)
end

vRP.giveInventoryItem = function(user_id, item, amount, notify)
    return vRP.GiveItem(user_id, item, amount, notify)
end

vRP.tryGetInventoryItem = function(user_id, item, amount, notify)
    return vRP.TakeItem(user_id, item, amount, notify)
end

vRP.getInventoryWeight = function(user_id)
    return vRP.InventoryWeight(user_id)
end

vRP.getInventoryMaxWeight = function(user_id)
    return vRP.GetWeight(user_id)
end

vRP.giveMoney = function(user_id, amount)
    return vRP.GiveItem(user_id, "dollar", amount, false)
end

vRP.tryPayment = function(user_id, amount)
    return vRP.PaymentFull(user_id, amount, false)
end

vRP.giveBankMoney = function(user_id, amount)
    return vRP.GiveBank(user_id, amount, false)
end

vRP.getBankMoney = function(user_id)
    return vRP.GetBank(user_id)
end

vRP.getMoney = function(user_id)
    return vRP.ItemAmount(user_id, "dollar")
end

vRP.setBankMoney = function(user_id, amount)
    local currentBank = vRP.GetBank(user_id)
    if currentBank > amount then
        vRP.RemoveBank(user_id, currentBank - amount)
    elseif amount > currentBank then
        vRP.GiveBank(user_id, amount - currentBank, false)
    end
end

vRP.getInventory = function(user_id)
    return vRP.Inventory(user_id)
end

vRP.clearInventory = function(user_id)
    local inventory = vRP.Inventory(user_id)
    for slot, itemData in pairs(inventory) do
        vRP.TakeItem(user_id, itemData.item, itemData.amount, false, slot)
    end
end

vRP.setUData = function(user_id, key, value)
    if vRP.UpdateDatatable then
        vRP.UpdateDatatable(user_id, key, value)
    end
end

vRP.getUData = function(user_id, key)
    return vRP.UserData(user_id, key) or ""
end

vRP.setSData = function(key, value)
    vRP.SetSrvData(key, value, true)
end

vRP.getSData = function(key)
    return vRP.GetSrvData(key, true) or ""
end

vRP.getUserDataTable = function(user_id)
    return vRP.Datatable(user_id)
end

vRP.hasPermission = function(user_id, perm)
    if vRP.HasPermission then
        return vRP.HasPermission(user_id, perm)
    end
    return false
end

vRP.hasGroup = function(user_id, group)
    if vRP.HasGroup then
        return vRP.HasGroup(user_id, group)
    end
    return false
end

vRP.getUsers = function()
    return vRP.Players()
end

vRP.prompt = function(source, title, text)
    -- Requires a prompt implementation on client side or generic vRP.Prompt
    -- Mocking for compatibility to prevent errors
    return "" 
end

vRP.request = function(source, text, time)
    if vRP.Request then
        return vRP.Request(source, text, text)
    end
    return true
end

vRP.getUserIdentity = function(user_id)
    if vRP.Identity then
        return vRP.Identity(user_id)
    end
    return {}
end