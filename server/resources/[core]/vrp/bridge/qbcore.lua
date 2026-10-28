-----------------------------------------------------------------------------------------------------------------------------------------
-- QBCORE COMPATIBILIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
QBCore = {}
QBCore.Functions = {}

local function CreateQBPlayer(source, user_id)
    local self = {}
    
    self.PlayerData = {
        citizenid = tostring(user_id),
        source = source,
        charinfo = {
            firstname = "User",
            lastname = tostring(user_id),
        },
        money = {
            cash = vRP.ItemAmount(user_id, "dollar"),
            bank = vRP.GetBank(user_id)
        },
        job = {
            name = "unemployed",
            label = "Desempregado",
            onduty = true,
            type = "none",
            grade = { name = "unemployed", level = 0 }
        }
    }

    if vRP.Identity then
        local identity = vRP.Identity(user_id)
        if identity then
            self.PlayerData.charinfo.firstname = identity.Name or "User"
            self.PlayerData.charinfo.lastname = identity.LastName or tostring(user_id)
        end
    end

    self.Functions = {}

    self.Functions.AddMoney = function(moneyType, amount, reason)
        if moneyType == 'cash' then
            vRP.GiveItem(user_id, "dollar", amount, false)
        elseif moneyType == 'bank' then
            vRP.GiveBank(user_id, amount, false)
        end
        return true
    end

    self.Functions.RemoveMoney = function(moneyType, amount, reason)
        if moneyType == 'cash' then
            return vRP.TakeItem(user_id, "dollar", amount, false)
        elseif moneyType == 'bank' then
            if vRP.GetBank(user_id) >= amount then
                vRP.RemoveBank(user_id, amount)
                return true
            end
        end
        return false
    end

    self.Functions.GetMoney = function(moneyType)
        if moneyType == 'cash' then
            return vRP.ItemAmount(user_id, "dollar")
        elseif moneyType == 'bank' then
            return vRP.GetBank(user_id)
        end
        return 0
    end
    
    self.Functions.SetJob = function(job, grade)
        -- Placeholder
        return true
    end

    self.Functions.GetItemByName = function(item)
        local amount = vRP.ItemAmount(user_id, item)
        if amount > 0 then
            return { name = item, amount = amount, info = {} }
        end
        return nil
    end

    self.Functions.AddItem = function(item, amount, slot, info)
        vRP.GiveItem(user_id, item, amount, false)
        return true
    end

    self.Functions.RemoveItem = function(item, amount, slot)
        return vRP.TakeItem(user_id, item, amount, false)
    end

    return self
end

QBCore.Functions.GetPlayer = function(source)
    local user_id = vRP.Passport(source)
    if user_id then
        return CreateQBPlayer(source, user_id)
    end
    return nil
end

QBCore.Functions.GetPlayers = function()
    local players = vRP.Players()
    local sources = {}
    for user_id, src in pairs(players) do
        table.insert(sources, src)
    end
    return sources
end

QBCore.Functions.GetPlayerByCitizenId = function(citizenid)
    local user_id = parseInt(citizenid)
    local source = vRP.Source(user_id)
    if source then
        return CreateQBPlayer(source, user_id)
    end
    return nil
end

QBCore.Functions.CreateCallback = function(name, cb)
    -- Placeholder for QBCore callbacks
end

RegisterNetEvent('QBCore:GetObject', function(cb)
    cb(QBCore)
end)