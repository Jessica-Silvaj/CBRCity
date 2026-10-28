Pipa = Pipa or {}

local lastCut = 0

local function distPointToSegment(p, a, b)
    local ab = b - a
    local ap = p - a
    local abLen2 = ab.x * ab.x + ab.y * ab.y + ab.z * ab.z
    if abLen2 <= 0.0001 then
        return #(p - a)
    end
    local t = (ap.x * ab.x + ap.y * ab.y + ap.z * ab.z) / abLen2
    t = math.max(0.0, math.min(1.0, t))
    local closest = a + ab * t
    return #(p - closest), t
end

local function segmentDistance(a1, a2, b1, b2)
    -- approximate by sampling points
    local best = 9999.0
    local samples = Config.CutSegments or 4
    for i = 0, samples do
        local t = i / samples
        local p = vector3(
            a1.x + (a2.x - a1.x) * t,
            a1.y + (a2.y - a1.y) * t,
            a1.z + (a2.z - a1.z) * t
        )
        local d = distPointToSegment(p, b1, b2)
        if d < best then best = d end
    end
    return best
end

CreateThread(function()
    while true do
        local sleep = 250
        local localFlight = Pipa.GetLocalFlight and Pipa.GetLocalFlight() or nil
        if localFlight and localFlight.active and localFlight.cuts then
            sleep = 0
            local now = GetGameTimer()
            if now - lastCut >= (Config.CutCooldown or 2000) then
                local hand = Pipa.GetHandPos()
                local kite = Pipa.GetKitePos()
                if hand and kite then
                    local remotes = Pipa.GetRemotes and Pipa.GetRemotes() or {}
                    for src, flight in pairs(remotes) do
                        if flight.hand and flight.kite then
                            local rh = vector3(flight.hand.x, flight.hand.y, flight.hand.z)
                            local rk = vector3(flight.kite.x, flight.kite.y, flight.kite.z)
                            local d = segmentDistance(hand, kite, rh, rk)
                            if d <= (Config.CutDist or 1.2) then
                                lastCut = now
                                local res = RESPONSE.requestCut(src, {
                                    segDist = d,
                                    loserKite = { x = rk.x, y = rk.y, z = rk.z },
                                })
                                if res and res.ok then
                                    if res.loser == GetPlayerServerId(PlayerId()) then
                                        Pipa.Notify('Sua linha foi cortada!')
                                    else
                                        Pipa.Notify('Você cortou a linha!')
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
