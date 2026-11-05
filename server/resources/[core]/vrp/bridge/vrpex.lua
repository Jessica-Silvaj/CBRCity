-----------------------------------------------------------------------------------------------------------------------------------------
-- VRPEX COMPATIBILIDADE (UNIVERSAL)
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.getUserId = function(source)
    if not source then return false end
    return vRP.Passport(source)
end

vRP.getUserSource = function(user_id)
    if not user_id then return false end
    return vRP.Source(parseInt(user_id))
end

vRP.getInventoryItemAmount = function(user_id, item)
    if not user_id or not item then return 0 end
    return vRP.ItemAmount(parseInt(user_id), tostring(item)) or 0
end

vRP.giveInventoryItem = function(user_id, item, amount, notify)
    if not user_id or not item or not amount then return end
    return vRP.GiveItem(parseInt(user_id), tostring(item), parseInt(amount), notify or false)
end

vRP.tryGetInventoryItem = function(user_id, item, amount, notify)
    if not user_id or not item or not amount then return false end
    return vRP.TakeItem(parseInt(user_id), tostring(item), parseInt(amount), notify or false)
end

vRP.getInventoryWeight = function(user_id)
    if not user_id then return 0 end
    return vRP.InventoryWeight(parseInt(user_id)) or 0
end

vRP.getInventoryMaxWeight = function(user_id)
    if not user_id then return 0 end
    return vRP.GetWeight(parseInt(user_id)) or 0
end

vRP.giveMoney = function(user_id, amount)
    if not user_id or not amount then return end
    return vRP.GiveItem(parseInt(user_id), "dollar", parseInt(amount), false)
end

vRP.tryPayment = function(user_id, amount)
    if not user_id or not amount then return false end
    return vRP.TakeItem(parseInt(user_id), "dollar", parseInt(amount), false)
end

vRP.tryFullPayment = function(user_id, amount)
    if not user_id or not amount then return false end
    return vRP.PaymentFull(parseInt(user_id), parseInt(amount), false)
end

vRP.giveBankMoney = function(user_id, amount)
    if not user_id or not amount then return end
    return vRP.GiveBank(parseInt(user_id), parseInt(amount), false)
end

vRP.getBankMoney = function(user_id)
    if not user_id then return 0 end
    return vRP.GetBank(parseInt(user_id)) or 0
end

vRP.getMoney = function(user_id)
    if not user_id then return 0 end
    return vRP.ItemAmount(parseInt(user_id), "dollar") or 0
end

vRP.setBankMoney = function(user_id, amount)
    if not user_id then return end
    local currentBank = vRP.GetBank(parseInt(user_id)) or 0
    local amount = parseInt(amount)
    if currentBank > amount then
        vRP.RemoveBank(parseInt(user_id), currentBank - amount)
    elseif amount > currentBank then
        vRP.GiveBank(parseInt(user_id), amount - currentBank, false)
    end
end

vRP.getInventory = function(user_id)
    if not user_id then return {} end
    return vRP.Inventory(parseInt(user_id)) or {}
end

vRP.clearInventory = function(user_id)
    if not user_id then return end
    local inventory = vRP.Inventory(parseInt(user_id)) or {}
    for slot, itemData in pairs(inventory) do
        vRP.TakeItem(parseInt(user_id), itemData.item, itemData.amount, false, slot)
    end
end

vRP.setUData = function(user_id, key, value)
    if not user_id or not key then return end
    local information = type(value) == "table" and json.encode(value) or tostring(value)
    vRP.Query("playerdata/SetData",{ Passport = parseInt(user_id), Name = key, Information = information })
end

vRP.getUData = function(user_id, key)
    if not user_id or not key then return "" end
    local data = vRP.UserData(parseInt(user_id), key)
    if type(data) == "table" then
        return json.encode(data)
    end
    return data or ""
end

vRP.setSData = function(key, value)
    if not key then return end
    vRP.SetSrvData(key, value, true)
end

vRP.getSData = function(key)
    if not key then return "" end
    return vRP.GetSrvData(key, true) or ""
end

vRP.getUserDataTable = function(user_id)
    if not user_id then return {} end
    return vRP.Datatable(parseInt(user_id)) or {}
end

vRP.hasPermission = function(user_id, perm)
    if not user_id or not perm then return false end
    if vRP.HasPermission then
        return vRP.HasPermission(parseInt(user_id), perm)
    end
    return false
end

vRP.hasGroup = function(user_id, group)
    if not user_id or not group then return false end
    if vRP.HasGroup then
        return vRP.HasGroup(parseInt(user_id), group)
    end
    return false
end

vRP.getUsers = function()
    return vRP.Players() or {}
end

vRP.prompt = function(source, title, text)
    return ""
end

vRP.request = function(source, text, time)
    if vRP.Request then
        return vRP.Request(source, text, text)
    end
    return true
end

vRP.getUserIdentity = function(user_id)
    if not user_id then return {} end
    if vRP.Identity then
        return vRP.Identity(parseInt(user_id)) or {}
    end
    return {}
end