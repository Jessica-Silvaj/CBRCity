local cutCooldown = {}

local function duelScore(flight)
    if not flight then return 0.0 end
    local power = tonumber(flight.linePower) or 1.0
    local bonus = tonumber(flight.kiteBonus) or 0.0
    local force = tonumber(flight.force) or 0.0
    local elev = tonumber(flight.elev) or 0.0
    local heightPart = math.max(0.0, elev) / (Config.DuelHeightScale or 25.0)
    return power * (1.0 + bonus)
        + force * (Config.DuelForceBonus or 1.2)
        + heightPart * (Config.DuelHeightBonus or 0.8)
end

function API.requestCut(targetSrc, payload)
    local source = source
    targetSrc = tonumber(targetSrc)
    if not targetSrc then return { ok = false } end

    local now = GetGameTimer()
    if cutCooldown[source] and now < cutCooldown[source] then
        return { ok = false, msg = 'Cooldown' }
    end

    local a = Flights[source]
    local b = Flights[targetSrc]
    if not a or not a.active or not b or not b.active then
        return { ok = false }
    end

    if not a.cuts then
        return { ok = false, msg = 'Sua linha não corta' }
    end

    local pedA = GetPlayerPed(source)
    local pedB = GetPlayerPed(targetSrc)
    if pedA == 0 or pedB == 0 then return { ok = false } end

    local distPlayers = #(GetEntityCoords(pedA) - GetEntityCoords(pedB))
    if distPlayers > (Config.MaxDuelDist or 300.0) then
        return { ok = false }
    end

    local segDist = payload and tonumber(payload.segDist)
    if segDist and segDist > (Config.ServerCutDist or 6.0) then
        return { ok = false }
    end

    local scoreA = duelScore(a)
    local scoreB = duelScore(b) * (1.0 + (Config.DuelWeakDefense or 0.15))

    cutCooldown[source] = now + (Config.CutCooldown or 2000)

    local winner, loser
    if scoreA >= scoreB then
        winner, loser = source, targetSrc
    else
        winner, loser = targetSrc, source
    end

    local winnerFlight = Flights[winner]
    local loserFlight = Flights[loser]
    local winnerName = Framework.getIdentityName(winnerFlight and winnerFlight.user_id)
    local loserName = Framework.getIdentityName(loserFlight and loserFlight.user_id)

    local dropCoords = (payload and payload.loserKite) or (loserFlight and loserFlight.kite)
    local lostKite = nil

    if Config.LoseKiteOnCut and loserFlight then
        lostKite = Inventory.LoseEquippedKite(loserFlight.user_id, 'cut')
    end

    Flights[loser] = nil
    TriggerClientEvent('night_pipa:flightStop', -1, loser, 'cut')

    if lostKite and type(dropCoords) == 'table' then
        local dropId = (GetGameTimer() % 1000000) + loser * 10
        local drop = {
            id = dropId,
            kiteId = lostKite,
            coords = dropCoords,
            owner = loser,
            created = GetGameTimer(),
        }
        Drops[dropId] = drop
        TriggerClientEvent('night_pipa:dropSpawn', -1, drop)
        SetTimeout(Config.Drop.DespawnTime or 240000, function()
            if Drops[dropId] then
                Drops[dropId] = nil
                TriggerClientEvent('night_pipa:dropRemove', -1, dropId)
            end
        end)
    end

    local feed = { quem = winnerName, perdeu = loserName }
    local winnerPed = GetPlayerPed(winner)
    local winnerCoords = winnerPed ~= 0 and GetEntityCoords(winnerPed) or nil
    if winnerCoords then
        for _, playerId in ipairs(GetPlayers()) do
            local pid = tonumber(playerId)
            local ped = GetPlayerPed(pid)
            if ped ~= 0 then
                local d = #(GetEntityCoords(ped) - winnerCoords)
                if d <= (Config.KillfeedDist or 300.0) then
                    TriggerClientEvent('night_pipa:killfeed', pid, feed)
                end
            end
        end
    end

    Framework.log('pipa_cut', {
        winner = winnerFlight and winnerFlight.user_id,
        loser = loserFlight and loserFlight.user_id,
        scoreA = scoreA,
        scoreB = scoreB,
    })

    return { ok = true, winner = winner, loser = loser }
end
