Inventory = {}
Flights = Flights or {}
Drops = Drops or {}

local function defaultInv()
    return {
        kites = {},
        lines = {},
        equipped = {
            kite = nil,
            line = Config.UseItems.freeLine or 'comum',
        },
    }
end

local userInventories = {}

function Inventory.Load(user_id)
    if userInventories[user_id] then
        return userInventories[user_id]
    end
    local data = Framework.getUData(user_id, Config.DataKey)
    if type(data) ~= 'table' then
        data = defaultInv()
    end
    data.kites = data.kites or {}
    data.lines = data.lines or {}
    data.equipped = data.equipped or {}
    if not data.equipped.line then
        data.equipped.line = Config.UseItems.freeLine or 'comum'
    end
    userInventories[user_id] = data
    return data
end

function Inventory.Save(user_id, data)
    userInventories[user_id] = data
    Framework.setUData(user_id, Config.DataKey, data)
end

function Inventory.HasKite(data, kiteId)
    return (tonumber(data.kites[kiteId]) or 0) > 0
end

function Inventory.HasAnyKite(data)
    for _, qty in pairs(data.kites or {}) do
        if (tonumber(qty) or 0) > 0 then
            return true
        end
    end
    return false
end

function Inventory.HasLine(data, lineId)
    if lineId == (Config.UseItems.freeLine or 'comum') then
        return true
    end
    return (tonumber(data.lines[lineId]) or 0) > 0
end

-- Sincroniza pipa:inv com os itens do inventário vRP (pipa_* / linha_*)
function Inventory.SyncFromItems(user_id, data)
    if not Config.UseItems.enabled then return data, false end

    local changed = false
    for _, kite in ipairs(Config.Kites) do
        local amount = Framework.getItemAmount(user_id, kite.item)
        local current = tonumber(data.kites[kite.id]) or 0
        if amount ~= current then
            if amount > 0 then
                data.kites[kite.id] = amount
            else
                data.kites[kite.id] = nil
                if data.equipped.kite == kite.id then
                    data.equipped.kite = nil
                end
            end
            changed = true
        end
    end

    for _, line in ipairs(Config.Lines) do
        if line.id ~= (Config.UseItems.freeLine or 'comum') then
            local amount = Framework.getItemAmount(user_id, line.item)
            local current = tonumber(data.lines[line.id]) or 0
            if amount ~= current then
                if amount > 0 then
                    data.lines[line.id] = amount
                else
                    data.lines[line.id] = nil
                    if data.equipped.line == line.id then
                        data.equipped.line = Config.UseItems.freeLine or 'comum'
                    end
                end
                changed = true
            end
        end
    end

    if changed then
        Inventory.Save(user_id, data)
    end
    return data, changed
end

function Inventory.AddKite(data, kiteId, amount)
    amount = math.floor(tonumber(amount) or 1)
    data.kites[kiteId] = (tonumber(data.kites[kiteId]) or 0) + amount
end

function Inventory.AddLine(data, lineId, amount)
    amount = math.floor(tonumber(amount) or 1)
    data.lines[lineId] = (tonumber(data.lines[lineId]) or 0) + amount
end

function Inventory.RemoveKite(data, kiteId, amount)
    amount = math.floor(tonumber(amount) or 1)
    local qty = (tonumber(data.kites[kiteId]) or 0) - amount
    if qty <= 0 then
        data.kites[kiteId] = nil
        if data.equipped.kite == kiteId then
            data.equipped.kite = nil
        end
        return true
    end
    data.kites[kiteId] = qty
    return true
end

function Inventory.BuildPayload(user_id, data)
    local money = Framework.getMoney(user_id)
    local kites = {}
    for _, kite in ipairs(Config.Kites) do
        kites[#kites + 1] = {
            id = kite.id,
            name = kite.name,
            price = kite.price,
            bonus = kite.bonus,
            qty = tonumber(data.kites[kite.id]) or 0,
            owned = Inventory.HasKite(data, kite.id),
            equipped = data.equipped.kite == kite.id,
        }
    end

    local lines = {}
    for _, line in ipairs(Config.Lines) do
        local free = line.id == (Config.UseItems.freeLine or 'comum')
        local qty = free and 1 or (tonumber(data.lines[line.id]) or 0)
        lines[#lines + 1] = {
            id = line.id,
            name = line.name,
            price = line.price,
            power = line.power,
            cuts = line.cuts,
            maxLine = line.maxLine,
            qty = qty,
            owned = Inventory.HasLine(data, line.id),
            equipped = data.equipped.line == line.id,
        }
    end

    return {
        money = money,
        kites = kites,
        lines = lines,
        equipped = {
            kite = data.equipped.kite,
            line = data.equipped.line,
        },
    }
end

function Inventory.LoseEquippedKite(user_id, reason)
    local data = Inventory.Load(user_id)
    local kiteId = data.equipped.kite
    if not kiteId then return nil end

    Inventory.RemoveKite(data, kiteId, 1)
    data.equipped.kite = nil
    Inventory.Save(user_id, data)

    local kite = Config.KitesById[kiteId]
    if kite and Config.UseItems.enabled then
        Framework.tryTakeItem(user_id, kite.item, 1)
    end

    Framework.log('pipa_lose', {
        user_id = user_id,
        kite = kiteId,
        reason = reason or 'unknown',
    })

    return kiteId
end

function API.getInventory()
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return nil end
    local data = Inventory.Load(user_id)
    Inventory.SyncFromItems(user_id, data)
    return Inventory.BuildPayload(user_id, data)
end

-- /pipa: abre a loja de qualquer lugar se tiver ao menos 1 pipa no inventário
function API.openShopCommand()
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then
        return { ok = false, msg = 'Sem personagem' }
    end

    local data = Inventory.Load(user_id)
    Inventory.SyncFromItems(user_id, data)

    if not Inventory.HasAnyKite(data) then
        return { ok = false, msg = 'Você precisa ter uma pipa no inventário' }
    end

    if not data.equipped.kite then
        for kiteId, qty in pairs(data.kites) do
            if (tonumber(qty) or 0) > 0 and Config.KitesById[kiteId] then
                data.equipped.kite = kiteId
                Inventory.Save(user_id, data)
                break
            end
        end
    end

    return {
        ok = true,
        inventory = Inventory.BuildPayload(user_id, data),
        remote = true,
    }
end

function API.equipKite(kiteId)
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return { ok = false, msg = 'Sem personagem' } end
    if not Config.KitesById[kiteId] then
        return { ok = false, msg = 'Pipa inválida' }
    end

    local data = Inventory.Load(user_id)
    if not Inventory.HasKite(data, kiteId) then
        return { ok = false, msg = 'Você não possui essa pipa' }
    end

    data.equipped.kite = kiteId
    Inventory.Save(user_id, data)
    return { ok = true, inventory = Inventory.BuildPayload(user_id, data) }
end

function API.equipLine(lineId)
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return { ok = false, msg = 'Sem personagem' } end
    if not Config.LinesById[lineId] then
        return { ok = false, msg = 'Linha inválida' }
    end

    local data = Inventory.Load(user_id)
    if not Inventory.HasLine(data, lineId) then
        return { ok = false, msg = 'Você não possui essa linha' }
    end

    data.equipped.line = lineId
    Inventory.Save(user_id, data)
    return { ok = true, inventory = Inventory.BuildPayload(user_id, data) }
end

function API.canStartFlight()
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return { ok = false, msg = 'Sem personagem' } end

    local data = Inventory.Load(user_id)
    local kiteId = data.equipped.kite
    local lineId = data.equipped.line or Config.UseItems.freeLine or 'comum'

    if not kiteId or not Config.KitesById[kiteId] then
        return { ok = false, msg = 'Equipe uma pipa primeiro' }
    end
    if not Inventory.HasKite(data, kiteId) then
        return { ok = false, msg = 'Pipa não encontrada' }
    end
    if not Inventory.HasLine(data, lineId) then
        return { ok = false, msg = 'Equipe uma linha' }
    end

    local kite = Config.KitesById[kiteId]
    local line = Config.LinesById[lineId]
    return {
        ok = true,
        kiteId = kiteId,
        lineId = lineId,
        kiteBonus = kite.bonus or 0.0,
        linePower = line.power or 1.0,
        maxLine = line.maxLine or 80.0,
        lineColor = line.color,
        cuts = line.cuts == true,
    }
end

AddEventHandler('playerDropped', function()
    local source = source
    local user_id = Framework.getUserId(source)
    if user_id then
        userInventories[user_id] = nil
    end
end)
