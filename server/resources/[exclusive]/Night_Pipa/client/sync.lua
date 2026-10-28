Pipa = Pipa or {}

local remotes = {}
local drops = {}
local remoteReels = {}
local remoteKites = {}
local dropEntities = {}

-- estado interpolado (o que é realmente desenhado) por player
local interp = {}

local function lerp(a, b, t)
    return a + (b - a) * t
end

-- interpola ângulo pelo caminho curto (evita giro de 350 graus)
local function lerpAngle(a, b, t)
    local diff = (b - a) % 360.0
    if diff > 180.0 then diff = diff - 360.0 end
    return a + diff * t
end

local function interpState(src)
    if not interp[src] then
        interp[src] = {
            pos = nil,
            hand = nil,
            rot = nil,
        }
    end
    return interp[src]
end

local function loadModel(model)
    if type(model) == 'string' then model = joaat(model) end
    RequestModel(model)
    local t = GetGameTimer() + 4000
    while not HasModelLoaded(model) and GetGameTimer() < t do Wait(10) end
    return HasModelLoaded(model)
end

-- Versão sem Wait: pede o modelo e devolve na hora.
-- Evita travar o frame do render remoto enquanto o prop carrega.
local function requestModelAsync(model)
    if type(model) == 'string' then model = joaat(model) end
    if HasModelLoaded(model) then return true end
    RequestModel(model)
    return false
end

local function deleteEnt(ent)
    if ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
    end
end

local function drawLine(from, to, color)
    local segments = Config.LineSegments or 8
    local curve = Config.LineCurve or 1.6
    local width = Config.LineWidth or 0.01
    local r, g, b, a = color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 180
    local prev = from
    for i = 1, segments do
        local t = i / segments
        local x = from.x + (to.x - from.x) * t
        local y = from.y + (to.y - from.y) * t
        local z = from.z + (to.z - from.z) * t - math.sin(t * math.pi) * (curve * 0.45)
        DrawLine(prev.x, prev.y, prev.z, x, y, z, r, g, b, a)
        DrawLine(prev.x, prev.y, prev.z + width, x, y, z + width, r, g, b, a)
        prev = vector3(x, y, z)
    end
end

-- Roda TODO frame: interpola posição/rotação e aplica na entidade.
-- Retorna hand e kite já suavizados pra desenhar a linha sem tremer.
local function ensureRemoteVisuals(src, flight, dt)
    local player = GetPlayerFromServerId(src)
    if player == -1 then return nil end
    local ped = GetPlayerPed(player)
    if ped == 0 then return nil end

    if Config.Reel.remote then
        local myCoords = GetEntityCoords(PlayerPedId())
        local dist = #(myCoords - GetEntityCoords(ped))
        if dist <= (Config.Reel.remoteDist or 120.0) then
            if not remoteReels[src] or not DoesEntityExist(remoteReels[src]) then
                if requestModelAsync(Config.Reel.model) then
                    local c = GetEntityCoords(ped)
                    local obj = CreateObject(Config.Reel.model, c.x, c.y, c.z, false, false, false)
                    local bone = GetPedBoneIndex(ped, Config.Reel.bone)
                    local p, r = Config.Reel.pos, Config.Reel.rot
                    AttachEntityToEntity(obj, ped, bone, p.x, p.y, p.z, r.x, r.y, r.z, true, true, false, true, 1, true)
                    remoteReels[src] = obj
                end
            end
        else
            deleteEnt(remoteReels[src])
            remoteReels[src] = nil
        end
    end

    local kiteCfg = Config.KitesById[flight.kiteId]
    if not kiteCfg or not flight.kite then return nil end

    local st = interpState(src)
    local target = vector3(flight.kite.x, flight.kite.y, flight.kite.z)

    -- mão vem do bone real do ped remoto: sempre em tempo real, zero delay
    local handBone = GetPedBoneIndex(ped, Config.Reel.bone or 60309)
    local handNow = GetWorldPositionOfEntityBone(ped, handBone)
    if not handNow or handNow.x == 0.0 then
        handNow = vector3(flight.hand.x, flight.hand.y, flight.hand.z)
    end
    st.hand = handNow

    local rotTarget = Config.ComputeKiteRotation(
        flight.kiteId,
        flight.dir or 2,
        GetEntityHeading(ped),
        flight.elev or 0.0,
        GetGameTimer()
    )

    if not st.pos then
        st.pos = target
        st.rot = { pitch = rotTarget.pitch, roll = rotTarget.roll, yaw = rotTarget.yaw }
    else
        local tp = math.min(1.0, (Config.RemotePosLerp or 14.0) * dt)
        local tr = math.min(1.0, (Config.RemoteRotLerp or 10.0) * dt)

        -- teleporte (troca de área) sem arrastar pelo mapa
        if #(st.pos - target) > 60.0 then
            st.pos = target
        else
            st.pos = vector3(
                lerp(st.pos.x, target.x, tp),
                lerp(st.pos.y, target.y, tp),
                lerp(st.pos.z, target.z, tp)
            )
        end

        st.rot.pitch = lerpAngle(st.rot.pitch, rotTarget.pitch, tr)
        st.rot.roll = lerpAngle(st.rot.roll, rotTarget.roll, tr)
        st.rot.yaw = lerpAngle(st.rot.yaw, rotTarget.yaw, tr)
    end

    if not remoteKites[src] or not DoesEntityExist(remoteKites[src]) then
        if requestModelAsync(kiteCfg.prop) then
            local obj = CreateObject(kiteCfg.prop, st.pos.x, st.pos.y, st.pos.z, false, false, false)
            SetEntityCollision(obj, false, false)
            FreezeEntityPosition(obj, true)
            SetEntityLodDist(obj, Config.PropLodDist or 1000)
            remoteKites[src] = obj
        end
        return st
    end

    local place = st.pos
    local ox, oy, oz = Config.GetKiteCenterOffset(flight.kiteId)
    if Config.KiteAlignCenter and (ox ~= 0.0 or oy ~= 0.0 or oz ~= 0.0) then
        local dx, dy, dz = Config.RotateLocalOffset(ox, oy, oz, st.rot.pitch, st.rot.roll, st.rot.yaw)
        place = vector3(st.pos.x - dx, st.pos.y - dy, st.pos.z - dz)
    end

    SetEntityCoordsNoOffset(remoteKites[src], place.x, place.y, place.z, false, false, false)
    SetEntityRotation(remoteKites[src], st.rot.pitch, st.rot.roll, st.rot.yaw, 2, true)

    return st
end

local function clearRemote(src)
    remotes[src] = nil
    interp[src] = nil
    deleteEnt(remoteReels[src])
    remoteReels[src] = nil
    deleteEnt(remoteKites[src])
    remoteKites[src] = nil
end

RegisterNetEvent('night_pipa:flightSync', function(src, flight)
    src = tonumber(src)
    if not src or src == GetPlayerServerId(PlayerId()) then return end
    if not flight or not flight.active then
        clearRemote(src)
        return
    end
    remotes[src] = flight
end)

RegisterNetEvent('night_pipa:flightStop', function(src, reason)
    src = tonumber(src)
    if not src then return end
    if src == GetPlayerServerId(PlayerId()) then
        -- local cleanup already handled by flight module; avoid double tunnel stop
        if Pipa.ForceLocalStop then
            Pipa.ForceLocalStop(reason or 'remote')
        end
        return
    end
    clearRemote(src)
end)

RegisterNetEvent('night_pipa:dropSpawn', function(drop)
    if type(drop) ~= 'table' or not drop.id then return end
    drops[drop.id] = drop

    local kite = Config.KitesById[drop.kiteId]
    if not kite then return end
    local c = drop.coords
    if not c then return end

    CreateThread(function()
        if not loadModel(kite.prop) then return end
        local my = GetEntityCoords(PlayerPedId())
        if #(my - vector3(c.x, c.y, c.z)) > (Config.Drop.MaxSpawnDist or 250.0) then return end

        local obj = CreateObject(kite.prop, c.x, c.y, c.z + 8.0, false, false, false)
        SetEntityCollision(obj, false, false)
        FreezeEntityPosition(obj, true)
        dropEntities[drop.id] = obj

        local z = c.z + 8.0
        local start = GetGameTimer()
        while drops[drop.id] and DoesEntityExist(obj) do
            local dt = GetFrameTime()
            local found, groundZ = GetGroundZFor_3dCoord(c.x, c.y, c.z + 50.0, false)
            local target = found and (groundZ + 0.15) or c.z
            if z > target then
                z = z - (Config.Drop.FallSpeed or 4.0) * dt
                local sway = math.sin((GetGameTimer() - start) / 350.0) * (Config.Drop.SwayAmp or 2.0) * 0.05
                SetEntityCoordsNoOffset(obj, c.x + sway, c.y, z, false, false, false)
            else
                SetEntityCoordsNoOffset(obj, c.x, c.y, target, false, false, false)
                drop.coords = { x = c.x, y = c.y, z = target }
                break
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent('night_pipa:dropRemove', function(id)
    id = tonumber(id) or id
    drops[id] = nil
    deleteEnt(dropEntities[id])
    dropEntities[id] = nil
end)

CreateThread(function()
    while true do
        local sleep = 500
        local myCoords = GetEntityCoords(PlayerPedId())
        local dt = GetFrameTime()
        if dt <= 0.0 then dt = 0.016 end

        for src, flight in pairs(remotes) do
            if flight.hand and flight.kite then
                local kite = vector3(flight.kite.x, flight.kite.y, flight.kite.z)
                if #(myCoords - kite) <= (Config.DrawDist or 460.0) then
                    sleep = 0
                    local st = ensureRemoteVisuals(src, flight, dt)
                    if st and st.pos and st.hand then
                        drawLine(st.hand, st.pos, flight.lineColor or {245, 245, 245, 160})
                    end
                else
                    interp[src] = nil
                end
            end
        end

        for id, drop in pairs(drops) do
            local c = drop.coords
            if c then
                local pos = vector3(c.x, c.y, c.z)
                local dist = #(myCoords - pos)
                if dist < (Config.Drop.MarkerDist or 40.0) then
                    sleep = 0
                    if Config.Marker.enabled then
                        DrawMarker(
                            2, pos.x, pos.y, pos.z + 0.35,
                            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                            Config.Marker.scale, Config.Marker.scale, Config.Marker.scale,
                            255, 180, 60, 180,
                            false, false, 2, false, nil, nil, false
                        )
                    end
                    if dist <= (Config.Drop.PickupDist or 2.0) then
                        BeginTextCommandDisplayHelp('STRING')
                        AddTextComponentSubstringPlayerName('Pressione ~INPUT_CONTEXT~ para pegar a pipa')
                        EndTextCommandDisplayHelp(0, false, false, -1)
                        if IsControlJustPressed(0, 38) then
                            local res = RESPONSE.pickupDrop(id)
                            if res and res.ok then
                                Pipa.Notify('Você pegou a pipa')
                                if res.inventory then Pipa.ApplyInventory(res.inventory) end
                            else
                                Pipa.Notify((res and res.msg) or 'Não foi possível pegar')
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

function Pipa.GetRemotes()
    return remotes
end

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for src, ent in pairs(remoteReels) do
        deleteEnt(ent)
        remoteReels[src] = nil
    end
    for src, ent in pairs(remoteKites) do
        deleteEnt(ent)
        remoteKites[src] = nil
    end
    for id, ent in pairs(dropEntities) do
        deleteEnt(ent)
        dropEntities[id] = nil
    end
    remotes = {}
    interp = {}
end)
