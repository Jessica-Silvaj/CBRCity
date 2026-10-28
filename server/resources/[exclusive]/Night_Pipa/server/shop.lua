local function nearAnyShop(coords)
    for _, shop in ipairs(Config.Shops) do
        if #(coords - shop.pos) <= (Config.ServerBuyDist or 10.0) then
            return true
        end
    end
    return false
end

function API.buyKite(kiteId)
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return { ok = false, msg = 'Sem personagem' } end

    local kite = Config.KitesById[kiteId]
    if not kite then return { ok = false, msg = 'Pipa inválida' } end

    local ped = GetPlayerPed(source)
    if ped == 0 then return { ok = false, msg = 'Jogador inválido' } end
    local coords = GetEntityCoords(ped)
    if not nearAnyShop(coords) then
        return { ok = false, msg = 'Longe da loja' }
    end

    local price = tonumber(kite.price) or 0
    if price > 0 and not Framework.tryPayment(user_id, price) then
        return { ok = false, msg = 'Dinheiro insuficiente' }
    end

    local data = Inventory.Load(user_id)
    Inventory.AddKite(data, kiteId, 1)
    if not data.equipped.kite then
        data.equipped.kite = kiteId
    end
    Inventory.Save(user_id, data)

    if Config.UseItems.enabled then
        Framework.giveItem(user_id, kite.item, 1)
    end

    Framework.log('pipa_buy_kite', {
        user_id = user_id,
        kite = kiteId,
        price = price,
    })

    return { ok = true, inventory = Inventory.BuildPayload(user_id, data) }
end

function API.buyLine(lineId)
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return { ok = false, msg = 'Sem personagem' } end

    local line = Config.LinesById[lineId]
    if not line then return { ok = false, msg = 'Linha inválida' } end
    if lineId == (Config.UseItems.freeLine or 'comum') then
        return { ok = false, msg = 'Linha gratuita' }
    end

    local ped = GetPlayerPed(source)
    if ped == 0 then return { ok = false, msg = 'Jogador inválido' } end
    local coords = GetEntityCoords(ped)
    if not nearAnyShop(coords) then
        return { ok = false, msg = 'Longe da loja' }
    end

    local price = tonumber(line.price) or 0
    if price > 0 and not Framework.tryPayment(user_id, price) then
        return { ok = false, msg = 'Dinheiro insuficiente' }
    end

    local data = Inventory.Load(user_id)
    Inventory.AddLine(data, lineId, 1)
    Inventory.Save(user_id, data)

    if Config.UseItems.enabled then
        Framework.giveItem(user_id, line.item, 1)
    end

    Framework.log('pipa_buy_line', {
        user_id = user_id,
        line = lineId,
        price = price,
    })

    return { ok = true, inventory = Inventory.BuildPayload(user_id, data) }
end
