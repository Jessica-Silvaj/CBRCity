Framework = {}

local function safeCall(fn, ...)
    local ok, a, b, c = pcall(fn, ...)
    if not ok then
        return nil
    end
    return a, b, c
end

function Framework.getUserId(source)
    if not source or source <= 0 then return nil end
    return safeCall(vRP.getUserId, source) or safeCall(vRP.Passport, source)
end

function Framework.getSource(user_id)
    if not user_id then return nil end
    return safeCall(vRP.getUserSource, user_id) or safeCall(vRP.Source, user_id)
end

function Framework.getIdentityName(user_id)
    if not user_id then return 'Desconhecido' end
    local identity = safeCall(vRP.getUserIdentity, user_id) or safeCall(vRP.Identity, user_id)
    if type(identity) == 'table' then
        local name = identity.name or identity.nome or identity.Name
        local first = identity.firstname or identity.sobrenome or identity.Lastname or ''
        if name and first and first ~= '' then
            return tostring(name) .. ' ' .. tostring(first)
        end
        if name then return tostring(name) end
    end
    return ('ID %s'):format(user_id)
end

function Framework.getMoney(user_id)
    if not user_id then return 0 end
    local money = safeCall(vRP.getMoney, user_id)
    if money ~= nil then return tonumber(money) or 0 end
    money = safeCall(vRP.getBankMoney, user_id)
    if money ~= nil then return tonumber(money) or 0 end
    money = safeCall(vRP.GetBank, user_id)
    if money ~= nil then return tonumber(money) or 0 end
    return 0
end

function Framework.tryPayment(user_id, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    if not user_id then return false end

    if vRP.tryPayment then
        return safeCall(vRP.tryPayment, user_id, amount) == true
    end
    if vRP.tryFullPayment then
        return safeCall(vRP.tryFullPayment, user_id, amount) == true
    end
    if vRP.PaymentBank then
        return safeCall(vRP.PaymentBank, user_id, amount) == true
    end
    if vRP.PaymentFull then
        return safeCall(vRP.PaymentFull, user_id, amount) == true
    end

    local money = Framework.getMoney(user_id)
    if money < amount then return false end
    if vRP.setMoney then
        safeCall(vRP.setMoney, user_id, money - amount)
        return true
    end
    return false
end

function Framework.giveItem(user_id, item, amount)
    if not Config.UseItems.enabled or not user_id or not item then return end
    amount = math.floor(tonumber(amount) or 1)
    if amount <= 0 then return end
    if vRP.giveInventoryItem then
        safeCall(vRP.giveInventoryItem, user_id, item, amount, true)
    elseif vRP.GiveItem then
        safeCall(vRP.GiveItem, user_id, item, amount, true)
    end
end

function Framework.tryTakeItem(user_id, item, amount)
    if not Config.UseItems.enabled or not user_id or not item then return true end
    amount = math.floor(tonumber(amount) or 1)
    if amount <= 0 then return true end
    if vRP.tryGetInventoryItem then
        return safeCall(vRP.tryGetInventoryItem, user_id, item, amount, true) == true
    end
    if vRP.TakeItem then
        return safeCall(vRP.TakeItem, user_id, item, amount, true) == true
    end
    return true
end

function Framework.getItemAmount(user_id, item)
    if not user_id or not item then return 0 end
    local n = safeCall(vRP.getInventoryItemAmount, user_id, item)
    if type(n) == 'table' then return math.floor(tonumber(n.amount) or 0) end
    if n ~= nil then return math.floor(tonumber(n) or 0) end
    n = safeCall(vRP.ItemAmount, user_id, item)
    if n ~= nil then return math.floor(tonumber(n) or 0) end
    return 0
end

function Framework.getUData(user_id, key)
    if not user_id or not key then return nil end
    local raw = safeCall(vRP.getUData, user_id, key)
    if raw == nil then
        raw = safeCall(vRP.UserData, user_id, key)
    end
    if type(raw) == 'string' and raw ~= '' then
        local ok, data = pcall(json.decode, raw)
        if ok then return data end
    elseif type(raw) == 'table' then
        return raw
    end
    return nil
end

function Framework.setUData(user_id, key, data)
    if not user_id or not key then return end
    local encoded = type(data) == 'string' and data or json.encode(data or {})
    if vRP.setUData then
        safeCall(vRP.setUData, user_id, key, encoded)
    elseif vRP.SetData then
        safeCall(vRP.SetData, user_id, key, encoded)
    end
end

function Framework.log(event, payload)
    local res = Config.LogsResource
    if not res or res == '' or GetResourceState(res) ~= 'started' then return end
    pcall(function()
        exports[res]:log(event, payload)
    end)
end