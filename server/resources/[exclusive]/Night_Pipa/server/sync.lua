Flights = Flights or {}
Drops = Drops or {}
local nextDropId = 1

local function playerCoords(src)
    local ped = GetPlayerPed(src)
    if ped == 0 then return nil end
    return GetEntityCoords(ped)
end

-- Manda o pacote só pra quem está perto: menos rede = menos delay pra quem importa.
local function broadcastFlight(src, flight)
    local origin = playerCoords(src)
    if not origin then
        TriggerClientEvent('night_pipa:flightSync', -1, src, flight)
        return
    end

    local range = (Config.DrawDist or 460.0) + 60.0
    for _, raw in ipairs(GetPlayers()) do
        local target = tonumber(raw)
        if target and target ~= src then
            local c = playerCoords(target)
            if not c or #(c - origin) <= range then
                TriggerClientEvent('night_pipa:flightSync', target, src, flight)
            end
        end
    end
end

function API.startFlight(payload)
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return false end

    local can = API.canStartFlight()
    if not can or not can.ok then return false end

    Flights[source] = {
        user_id = user_id,
        kiteId = can.kiteId,
        lineId = can.lineId,
        linePower = can.linePower,
        kiteBonus = can.kiteBonus,
        maxLine = can.maxLine,
        lineColor = can.lineColor,
        cuts = can.cuts,
        force = 0.0,
        meters = Config.StartLine,
        elev = Config.InitialElev,
        dir = 2,
        side = 0.0,
        hand = payload and payload.hand or nil,
        kite = payload and payload.kite or nil,
        active = true,
    }

    broadcastFlight(source, Flights[source])
    return true
end

function API.updateFlight(payload)
    local source = source
    local flight = Flights[source]
    if not flight or not flight.active then return end
    if type(payload) ~= 'table' then return end

    flight.force = tonumber(payload.force) or flight.force
    flight.meters = tonumber(payload.meters) or flight.meters
    flight.elev = tonumber(payload.elev) or flight.elev
    flight.dir = tonumber(payload.dir) or flight.dir
    flight.side = tonumber(payload.side) or flight.side
    flight.hand = payload.hand or flight.hand
    flight.kite = payload.kite or flight.kite
    flight.storing = payload.storing == true

    broadcastFlight(source, flight)
end

function API.stopFlight(reason)
    local source = source
    local flight = Flights[source]
    if not flight then return end
    Flights[source] = nil
    TriggerClientEvent('night_pipa:flightStop', -1, source, reason or 'stop')
end

function API.spawnDrop(payload)
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return nil end

    local flight = Flights[source]
    local kiteId = payload and payload.kiteId or (flight and flight.kiteId)
    if not kiteId or not Config.KitesById[kiteId] then return nil end

    local lost = Inventory.LoseEquippedKite(user_id, payload and payload.reason or 'drop')
    if not lost then return nil end

    Flights[source] = nil
    TriggerClientEvent('night_pipa:flightStop', -1, source, 'drop')

    local coords = payload and payload.coords
    if type(coords) ~= 'table' then
        local c = playerCoords(source)
        if not c then return nil end
        coords = { x = c.x, y = c.y, z = c.z + 2.0 }
    end

    local id = nextDropId
    nextDropId = nextDropId + 1

    local drop = {
        id = id,
        kiteId = kiteId,
        coords = coords,
        owner = source,
        created = GetGameTimer(),
    }
    Drops[id] = drop

    TriggerClientEvent('night_pipa:dropSpawn', -1, drop)

    SetTimeout(Config.Drop.DespawnTime or 240000, function()
        if Drops[id] then
            Drops[id] = nil
            TriggerClientEvent('night_pipa:dropRemove', -1, id)
        end
    end)

    return id
end

function API.pickupDrop(dropId)
    local source = source
    local user_id = Framework.getUserId(source)
    if not user_id then return { ok = false, msg = 'Sem personagem' } end

    local drop = Drops[dropId]
    if not drop then return { ok = false, msg = 'Pipa não encontrada' } end

    local pedCoords = playerCoords(source)
    if not pedCoords then return { ok = false, msg = 'Jogador inválido' } end

    local dc = drop.coords
    local dist = #(pedCoords - vector3(dc.x, dc.y, dc.z))
    if dist > (Config.Drop.PickupValidateDist or 15.0) then
        return { ok = false, msg = 'Muito longe' }
    end

    Drops[dropId] = nil
    TriggerClientEvent('night_pipa:dropRemove', -1, dropId)

    local data = Inventory.Load(user_id)
    Inventory.AddKite(data, drop.kiteId, 1)
    if not data.equipped.kite then
        data.equipped.kite = drop.kiteId
    end
    Inventory.Save(user_id, data)

    local kite = Config.KitesById[drop.kiteId]
    if kite and Config.UseItems.enabled then
        Framework.giveItem(user_id, kite.item, 1)
    end

    return { ok = true, kiteId = drop.kiteId, inventory = Inventory.BuildPayload(user_id, data) }
end

AddEventHandler('playerDropped', function()
    local source = source
    if Flights[source] then
        Flights[source] = nil
        TriggerClientEvent('night_pipa:flightStop', -1, source, 'disconnect')
    end
end)

RegisterNetEvent('night_pipa:requestState', function()
    local source = source
    for src, flight in pairs(Flights) do
        TriggerClientEvent('night_pipa:flightSync', source, src, flight)
    end
    for _, drop in pairs(Drops) do
        TriggerClientEvent('night_pipa:dropSpawn', source, drop)
    end
end)
