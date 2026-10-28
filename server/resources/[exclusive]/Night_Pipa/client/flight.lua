Pipa = Pipa or {}

local state = {
    active = false,
    kiteId = nil,
    lineId = nil,
    kiteBonus = 0.0,
    linePower = 1.0,
    maxLine = 80.0,
    lineColor = {245, 245, 245, 160},
    cuts = false,
    meters = Config.StartLine,
    elev = Config.InitialElev,
    elevTarget = Config.InitialElev,
    side = 0.0,
    sideVel = 0.0,
    elevVel = 0.0,
    force = 0.0,
    dir = 0,
    dirUntil = 0,
    lastPull = 0,
    storing = false,
    storeHold = 0,
    collisionHold = 0,
    kiteEntity = nil,
    reelEntity = nil,
    lastSync = 0,
}

-- snapshot usado pelo modo de ajuste (/pipa_pos) pra travar a física
local frozen = { elev = 0.0, meters = 0.0, side = 0.0, elevTarget = 0.0 }

local function loadModel(model)
    if type(model) == 'string' then model = joaat(model) end
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)
    local t = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < t do
        Wait(10)
    end
    return HasModelLoaded(model)
end

local function loadAnim(dict)
    RequestAnimDict(dict)
    local t = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < t do
        Wait(10)
    end
    return HasAnimDictLoaded(dict)
end

local function deleteEntity(ent)
    if ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
    end
end

local function handPos(ped)
    local bone = GetPedBoneIndex(ped, Config.Reel.bone or 60309)
    return GetWorldPositionOfEntityBone(ped, bone)
end

local function kiteWorldPos(ped)
    local hand = handPos(ped)
    local heading = GetEntityHeading(ped)
    local rad = math.rad(heading)
    local elevRad = math.rad(state.elev)
    local sideRad = math.rad(state.side)

    local forward = state.meters * math.cos(elevRad)
    local up = state.meters * math.sin(elevRad)
    local side = state.meters * math.sin(sideRad) * 0.35

    local x = hand.x + (-math.sin(rad) * forward) + (math.cos(rad) * side)
    local y = hand.y + (math.cos(rad) * forward) + (math.sin(rad) * side)
    local z = hand.z + up + (Config.MinHeight or 2.0)
    return vector3(x, y, z), hand
end

local function attachReel(ped)
    deleteEntity(state.reelEntity)
    if not loadModel(Config.Reel.model) then return end
    local coords = GetEntityCoords(ped)
    local obj = CreateObject(Config.Reel.model, coords.x, coords.y, coords.z, true, true, false)
    local bone = GetPedBoneIndex(ped, Config.Reel.bone)
    local p, r = Config.Reel.pos, Config.Reel.rot
    AttachEntityToEntity(
        obj, ped, bone,
        p.x, p.y, p.z,
        r.x, r.y, r.z,
        true, true, false, true, 1, true
    )
    if Config.Reel.lodDist then
        SetEntityLodDist(obj, Config.Reel.lodDist)
    end
    state.reelEntity = obj
end

local function spawnKite(ped)
    deleteEntity(state.kiteEntity)
    local kite = Config.KitesById[state.kiteId]
    if not kite then return end
    if not loadModel(kite.prop) then return end
    local pos = kiteWorldPos(ped)
    local obj = CreateObject(kite.prop, pos.x, pos.y, pos.z, true, true, false)
    SetEntityCollision(obj, false, false)
    FreezeEntityPosition(obj, true)
    SetEntityLodDist(obj, Config.PropLodDist or 1000)
    state.kiteEntity = obj
end

local function updateKiteTransform(ped)
    if not state.kiteEntity or not DoesEntityExist(state.kiteEntity) then return end
    local pos = kiteWorldPos(ped)
    local heading = GetEntityHeading(ped)
    local rot = Config.ComputeKiteRotation(state.kiteId, state.dir, heading, state.elev, GetGameTimer())

    local ox, oy, oz = Config.GetKiteCenterOffset(state.kiteId)
    local place = pos
    if Config.KiteAlignCenter and (ox ~= 0.0 or oy ~= 0.0 or oz ~= 0.0) then
        local dx, dy, dz = Config.RotateLocalOffset(ox, oy, oz, rot.pitch, rot.roll, rot.yaw)
        place = vector3(pos.x - dx, pos.y - dy, pos.z - dz)
    end

    SetEntityCoordsNoOffset(state.kiteEntity, place.x, place.y, place.z, false, false, false)
    SetEntityRotation(state.kiteEntity, rot.pitch, rot.roll, rot.yaw, 2, true)
end

local function kiteLineAttachPos()
    if state.kiteEntity and DoesEntityExist(state.kiteEntity) then
        local ox, oy, oz = Config.GetKiteCenterOffset(state.kiteId)
        return GetOffsetFromEntityInWorldCoords(state.kiteEntity, ox, oy, oz)
    end
    return kiteWorldPos(PlayerPedId())
end

local function drawLine(from, to, color)
    local segments = Config.LineSegments or 8
    local curve = Config.LineCurve or 1.6
    local width = Config.LineWidth or 0.01
    local r, g, b, a = color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 180
    local midZ = (from.z + to.z) * 0.5 - (curve * 0.35)

    local prev = from
    for i = 1, segments do
        local t = i / segments
        local x = from.x + (to.x - from.x) * t
        local y = from.y + (to.y - from.y) * t
        local z = from.z + (to.z - from.z) * t
        local sag = math.sin(t * math.pi) * (curve * 0.45)
        z = z - sag
        if i == math.floor(segments / 2) then
            z = (z + midZ) * 0.5
        end
        DrawLine(prev.x, prev.y, prev.z, x, y, z, r, g, b, a)
        -- thicker look with parallel micro-offset
        DrawLine(prev.x, prev.y, prev.z + width, x, y, z + width, r, g, b, a)
        prev = vector3(x, y, z)
    end
end

local function pushHud()
    SendNUIMessage({
        action = 'voo',
        force = state.force,
        metros = state.meters,
        meters = state.meters,
        direcao = state.dir,
        dir = state.dir,
        guardando = state.storing,
        storing = state.storing,
        max = state.maxLine,
    })
end

local function pushRecolher(on)
    if on then
        SendNUIMessage({
            action = 'recolher',
            metros = state.meters,
            meters = state.meters,
            total = state.maxLine,
            max = state.maxLine,
        })
    else
        SendNUIMessage({ action = 'recolherOff' })
    end
end

local function syncFlight(force)
    local now = GetGameTimer()
    if not force and now - state.lastSync < (Config.SyncInterval or 150) then return end
    state.lastSync = now
    local ped = PlayerPedId()
    local kitePos = kiteWorldPos(ped)
    local hand = handPos(ped)
    RESPONSE.updateFlight({
        force = state.force,
        meters = state.meters,
        elev = state.elev,
        dir = state.dir,
        side = state.side,
        storing = state.storing,
        hand = { x = hand.x, y = hand.y, z = hand.z },
        kite = { x = kitePos.x, y = kitePos.y, z = kitePos.z },
    })
end

local function cleanupFlight(reason)
    local wasActive = state.active
    state.active = false
    Pipa.flying = false
    deleteEntity(state.kiteEntity)
    deleteEntity(state.reelEntity)
    state.kiteEntity = nil
    state.reelEntity = nil
    ClearPedTasks(PlayerPedId())
    SendNUIMessage({ action = 'vooOff' })
    SendNUIMessage({ action = 'recolherOff' })
    if wasActive then
        RESPONSE.stopFlight(reason or 'stop')
    end
end

local function loseAndDrop(reason)
    local ped = PlayerPedId()
    local kitePos = kiteWorldPos(ped)
    RESPONSE.spawnDrop({
        kiteId = state.kiteId,
        reason = reason or 'snag',
        coords = { x = kitePos.x, y = kitePos.y, z = kitePos.z },
    })
    Pipa.ForceLocalStop(reason or 'drop')
end

function Pipa.StartFlight()
    if state.active then return false, 'Já está voando' end
    local can = RESPONSE.canStartFlight()
    if not can or not can.ok then
        return false, (can and can.msg) or 'Não pode voar'
    end

    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        return false, 'Saia do veículo'
    end

    state.active = true
    Pipa.flying = true
    state.kiteId = can.kiteId
    state.lineId = can.lineId
    state.kiteBonus = can.kiteBonus or 0.0
    state.linePower = can.linePower or 1.0
    state.maxLine = can.maxLine or 80.0
    state.lineColor = can.lineColor or {245, 245, 245, 160}
    state.cuts = can.cuts == true
    state.meters = Config.StartLine
    state.elev = Config.InitialElev
    state.elevTarget = Config.InitialElev
    state.side = 0.0
    state.sideVel = 0.0
    state.elevVel = 0.0
    state.force = 0.0
    state.dir = 2
    state.dirUntil = 0
    state.lastPull = 0
    state.storing = false
    state.storeHold = 0
    state.collisionHold = 0

    loadAnim(Config.Anim.dict)
    TaskPlayAnim(ped, Config.Anim.dict, Config.Anim.anim, 2.0, 2.0, -1, Config.Anim.flag, 0.0, false, false, false)
    attachReel(ped)
    spawnKite(ped)

    local hand = handPos(ped)
    local kitePos = kiteWorldPos(ped)
    RESPONSE.startFlight({
        hand = { x = hand.x, y = hand.y, z = hand.z },
        kite = { x = kitePos.x, y = kitePos.y, z = kitePos.z },
    })

    pushHud()
    Pipa.Notify('↑ solta linha · ↓ recolhe · ← → vira · clique esquerdo puxa')
    return true
end

function Pipa.StopFlight(reason)
    cleanupFlight(reason or 'stop')
end

function Pipa.ForceLocalStop(reason)
    local wasActive = state.active
    state.active = false
    Pipa.flying = false
    deleteEntity(state.kiteEntity)
    deleteEntity(state.reelEntity)
    state.kiteEntity = nil
    state.reelEntity = nil
    ClearPedTasks(PlayerPedId())
    SendNUIMessage({ action = 'vooOff' })
    SendNUIMessage({ action = 'recolherOff' })
    if wasActive and reason ~= 'drop' and reason ~= 'cut' and reason ~= 'snag' then
        -- server already cleared flight for drop/cut
    end
end

function Pipa.GetLocalFlight()
    if not state.active then return nil end
    return state
end

function Pipa.DebugGetFlight()
    if not state.active then return nil end
    return {
        elev = state.elev,
        meters = state.meters,
        side = state.side,
        dir = state.dir,
        kiteId = state.kiteId,
    }
end

function Pipa.DebugSetFlight(elev, meters, side)
    if not state.active then return false end
    if elev then
        state.elev = math.max(Config.MinElev, math.min(Config.MaxElev, elev))
        state.elevTarget = state.elev
    end
    if meters then state.meters = math.max(Config.MinLine, math.min(state.maxLine, meters)) end
    if side then state.side = side end
    frozen.elev = state.elev
    frozen.elevTarget = state.elevTarget
    frozen.meters = state.meters
    frozen.side = state.side
    return true
end

function Pipa.DebugFreeze(on)
    state.debugFrozen = on == true
end

function Pipa.DebugIsFrozen()
    return state.debugFrozen == true
end

function Pipa.GetKitePos()
    if not state.active then return nil end
    return kiteWorldPos(PlayerPedId())
end

function Pipa.GetHandPos()
    return handPos(PlayerPedId())
end

CreateThread(function()
    while true do
        if not state.active then
            Wait(200)
        else
            local ped = PlayerPedId()
            local dt = GetFrameTime()
            local now = GetGameTimer()

            for _, ctrl in ipairs(Config.BlockedControls) do
                DisableControlAction(0, ctrl, true)
            end

            if not IsEntityPlayingAnim(ped, Config.Anim.dict, Config.Anim.anim, 3) then
                TaskPlayAnim(ped, Config.Anim.dict, Config.Anim.anim, 2.0, 2.0, -1, Config.Anim.flag, 0.0, false, false, false)
            end

            local releasing = IsControlPressed(0, Config.Keys.release) or IsDisabledControlPressed(0, Config.Keys.release)
            local reeling = IsControlPressed(0, Config.Keys.reel) or IsDisabledControlPressed(0, Config.Keys.reel)
            local left = IsControlPressed(0, Config.Keys.left) or IsDisabledControlPressed(0, Config.Keys.left)
            local right = IsControlPressed(0, Config.Keys.right) or IsDisabledControlPressed(0, Config.Keys.right)
            local pull = IsDisabledControlPressed(0, Config.Mouse.clickLeft) or IsControlPressed(0, Config.Mouse.clickLeft)

            -- SCROLL PRA CIMA: pipa sobe pro céu (ganha altura + solta linha)
            if IsDisabledControlJustPressed(0, Config.Mouse.scrollUp) or IsControlJustPressed(0, Config.Mouse.scrollUp) then
                state.elevTarget = math.min(Config.MaxElev, state.elevTarget + (Config.ScrollElevStep or 7.0))
                state.meters = math.min(state.maxLine, state.meters + (Config.ScrollLineStep or 3.0))
            end
            -- SCROLL PRA BAIXO: pipa desce
            if IsDisabledControlJustPressed(0, Config.Mouse.scrollDown) or IsControlJustPressed(0, Config.Mouse.scrollDown) then
                state.elevTarget = math.max(Config.MinElev, state.elevTarget - (Config.ScrollElevStep or 7.0))
                state.meters = math.max(Config.MinLine, state.meters - (Config.ScrollLineStep or 3.0))
            end

            if releasing and not state.storing then
                state.meters = math.min(state.maxLine, state.meters + Config.LineSpeed * dt)
            end

            local reelSpeed = Config.ReelSpeed
            if pull then
                reelSpeed = reelSpeed * (Config.PullReelBoost or 1.8)
                state.force = math.min(1.0, state.force + Config.ForcePerPull * dt * 4.0)
                state.lastPull = now
                state.elevTarget = state.elevTarget + Config.PullImpulse * dt
            else
                state.force = math.max(0.0, state.force - Config.ForceDecay * dt)
            end

            if reeling then
                state.meters = math.max(Config.MinLine, state.meters - reelSpeed * dt)
                pushRecolher(true)
            else
                pushRecolher(false)
            end

            local sideInput = 0.0
            if left then sideInput = sideInput - 1.0 end
            if right then sideInput = sideInput + 1.0 end

            local sideLimit = Config.SideLimit
            if state.meters < Config.SideLimitMin then
                sideLimit = sideLimit * (state.meters / Config.SideLimitMin)
            end

            -- vento / balanço idle pra pipa não ficar "morta"
            if sideInput == 0.0 and not pull and not state.storing then
                state.sideVel = state.sideVel + math.sin(now / 860.0) * 6.5 * dt
            end

            state.sideVel = state.sideVel + sideInput * Config.SideSpeed * dt * 10.0
            if pull then
                state.sideVel = state.sideVel * (1.0 + (Config.SpeedBoost - 1.0) * dt)
            end
            state.sideVel = state.sideVel - state.sideVel * Config.IdleDamping * dt
            state.side = state.side + state.sideVel * dt
            state.side = math.max(-sideLimit * 45.0, math.min(sideLimit * 45.0, state.side))

            -- ELEVAÇÃO: alvo controlado por scroll/puxada, pipa persegue esse alvo.
            if pull then
                -- clique esquerdo empurra a pipa pra cima
                state.elevTarget = state.elevTarget + Config.HeightBoost * state.force * dt
            elseif releasing then
                -- soltar linha ganha altura devagar
                state.elevTarget = state.elevTarget + (Config.ScrollElevStep or 7.0) * 0.35 * dt
            elseif not state.storing then
                -- gravidade suave só quando o jogador não está comandando
                state.elevTarget = state.elevTarget - (Config.ElevSinkRate or 1.6) * dt
            end
            state.elevTarget = math.max(Config.MinElev, math.min(Config.MaxElev, state.elevTarget))

            local bob = math.sin(now / 700.0) * (Config.ElevBobAmp or 1.8)
            local desired = state.elevTarget + bob
            state.elev = state.elev + (desired - state.elev) * math.min(1.0, (Config.ElevEase or 4.5) * dt)
            state.elev = math.max(Config.MinElev, math.min(Config.MaxElev, state.elev))

            if state.debugFrozen then
                state.elev = frozen.elev
                state.elevTarget = frozen.elevTarget
                state.meters = frozen.meters
                state.side = frozen.side
            else
                frozen.elev = state.elev
                frozen.elevTarget = state.elevTarget
                frozen.meters = state.meters
                frozen.side = state.side
            end

            if sideInput < 0 then
                state.dir = 3
                state.dirUntil = now + Config.DirectionTime
            elseif sideInput > 0 then
                state.dir = 1
                state.dirUntil = now + Config.DirectionTime
            elseif pull then
                state.dir = 0
                state.dirUntil = now + Config.DirectionTime
            elseif now > state.dirUntil then
                state.dir = 2
            end

            local ended = false

            -- auto store: só puxa até guardar depois de segurar um pouco (evita travar em 1m)
            if Config.AutoStore.enabled and reeling and state.meters <= Config.AutoStore.startLine then
                state.storing = true
                state.storeHold = state.storeHold + dt * 1000.0
                state.elevTarget = state.elevTarget + (Config.AutoStore.elevTarget - state.elevTarget) * Config.AutoStore.elevEase * dt
                if state.storeHold >= (Config.AutoStore.holdTime * 0.4) then
                    state.meters = math.max(Config.AutoStore.storeLine, state.meters - Config.AutoStore.pullSpeed * dt)
                end
                if state.meters <= Config.AutoStore.storeLine and state.storeHold >= Config.AutoStore.holdTime then
                    cleanupFlight('store')
                    Pipa.Notify('Pipa guardada')
                    ended = true
                end
            else
                state.storing = false
                state.storeHold = 0
            end

            -- ground collision
            if not ended and Config.CollisionEnabled and not state.storing then
                local checkPos = kiteWorldPos(ped)
                local found, groundZ = GetGroundZFor_3dCoord(checkPos.x, checkPos.y, checkPos.z + 50.0, false)
                if found and checkPos.z <= (groundZ + Config.CollisionGroundMargin) then
                    state.collisionHold = state.collisionHold + dt * 1000.0
                    if state.collisionHold >= Config.CollisionTime then
                        if Config.LoseKiteOnSnag then
                            loseAndDrop('snag')
                            Pipa.Notify('A pipa enroscou e foi perdida')
                        else
                            cleanupFlight('snag')
                            Pipa.Notify('A pipa enroscou')
                        end
                        ended = true
                    end
                else
                    state.collisionHold = 0
                end
            end

            if not ended and state.active then
                updateKiteTransform(ped)
                local hand = handPos(ped)
                local attach = kiteLineAttachPos()
                drawLine(hand, attach, state.lineColor)
                pushHud()
                syncFlight(false)

                if IsControlJustPressed(0, 322) or IsControlJustPressed(0, 177) then
                    cleanupFlight('cancel')
                end
            end

            Wait(0)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    cleanupFlight('resource_stop')
end)
