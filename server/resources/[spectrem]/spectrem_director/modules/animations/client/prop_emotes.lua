-- ============================================================================
-- PropEmotes helpers
-- Centralized prop normalization/attachment for hover preview, placement, and
-- custom scene playback. This follows the RPEmotes attachment order:
-- PropPlacement = { x, y, z, rx, ry, rz }.
-- ============================================================================

local DEFAULT_PROP_BONE = 28422
local PROP_MODEL_TIMEOUT_MS = 2500

local function propConfig()
    if type(Config) == "table" and type(Config.PropEmotes) == "table" then
        return Config.PropEmotes
    end
    return {}
end

local function trace(stage, data)
    if type(SD_TracePropFlow) == "function" then
        SD_TracePropFlow(stage, data)
    end
end

local function traceEntity(stage, entity)
    if type(SD_TraceEntity) == "function" then
        SD_TraceEntity(stage, entity)
    end
end

local function formatVec3(vec)
    if not vec then return "nil" end
    return ("%.4f,%.4f,%.4f"):format(vec.x or 0.0, vec.y or 0.0, vec.z or 0.0)
end

local function toNumber(value, fallback)
    local n = tonumber(value)
    if n ~= nil then return n end
    return fallback or 0.0
end

local function firstNumber(fallback, ...)
    for i = 1, select("#", ...) do
        -- Parentesis obligatorios: select() devuelve TODOS los valores restantes y
        -- tonumber tomaria el segundo como base (revienta con offsets decimales).
        local n = tonumber((select(i, ...)))
        if n ~= nil then return n end
    end
    return fallback or 0.0
end

local function readPlacement(placement, prop)
    prop = type(prop) == "table" and prop or {}

    if type(placement) == "table" then
        return {
            x = firstNumber(0.0, placement[1], placement.x, placement.X, placement.ox, placement.off1),
            y = firstNumber(0.0, placement[2], placement.y, placement.Y, placement.oy, placement.off2),
            z = firstNumber(0.0, placement[3], placement.z, placement.Z, placement.oz, placement.off3),
        }, {
            x = firstNumber(0.0, placement[4], placement.rx, placement.rX, placement.xRot, placement.rotX, placement.rot1),
            y = firstNumber(0.0, placement[5], placement.ry, placement.rY, placement.yRot, placement.rotY, placement.rot2),
            z = firstNumber(0.0, placement[6], placement.rz, placement.rZ, placement.zRot, placement.rotZ, placement.rot3),
        }
    end

    local offset = type(prop.offset) == "table" and prop.offset
        or type(prop.Offset) == "table" and prop.Offset
        or type(prop.off) == "table" and prop.off
        or {}
    local rot = type(prop.rot) == "table" and prop.rot
        or type(prop.rotation) == "table" and prop.rotation
        or type(prop.Rot) == "table" and prop.Rot
        or {}

    return {
        x = firstNumber(0.0, prop.ox, prop.off1, offset.x, offset.X, offset[1]),
        y = firstNumber(0.0, prop.oy, prop.off2, offset.y, offset.Y, offset[2]),
        z = firstNumber(0.0, prop.oz, prop.off3, offset.z, offset.Z, offset[3]),
    }, {
        x = firstNumber(0.0, prop.rx, prop.rot1, prop.xRot, prop.rotX, rot.x, rot.X, rot[1]),
        y = firstNumber(0.0, prop.ry, prop.rot2, prop.yRot, prop.rotY, rot.y, rot.Y, rot[2]),
        z = firstNumber(0.0, prop.rz, prop.rot3, prop.zRot, prop.rotZ, rot.z, rot.Z, rot[3]),
    }
end

local function getModelOffset(model)
    local offsets = propConfig().PropRotationOffsets
    if type(offsets) ~= "table" then return nil end
    if offsets[model] then return offsets[model] end
    local lower = tostring(model or ""):lower()
    return offsets[lower]
end

local function applyConfiguredOffset(prop)
    local correction = getModelOffset(prop.model)
    if type(correction) ~= "table" then return end

    local off = prop.offset
    local rot = prop.rot

    if correction.offset or correction.ox or correction.off1 then
        local cOff = type(correction.offset) == "table" and correction.offset or correction
        off.x = off.x + firstNumber(0.0, cOff.ox, cOff.off1, cOff.x, cOff[1])
        off.y = off.y + firstNumber(0.0, cOff.oy, cOff.off2, cOff.y, cOff[2])
        off.z = off.z + firstNumber(0.0, cOff.oz, cOff.off3, cOff.z, cOff[3])
    end

    local cRot = type(correction.rot) == "table" and correction.rot
        or type(correction.rotation) == "table" and correction.rotation
        or correction
    rot.x = rot.x + firstNumber(0.0, cRot.rx, cRot.rot1, cRot.xRot, cRot.rotX, cRot.x, cRot[4], cRot[1])
    rot.y = rot.y + firstNumber(0.0, cRot.ry, cRot.rot2, cRot.yRot, cRot.rotY, cRot.y, cRot[5], cRot[2])
    rot.z = rot.z + firstNumber(0.0, cRot.rz, cRot.rot3, cRot.zRot, cRot.rotZ, cRot.z, cRot[6], cRot[3])
end

function SD_NormalizeAnimProp(prop)
    if not prop then return nil end

    local model
    if type(prop) == "string" then
        model = prop
        prop = {}
    elseif type(prop) == "table" then
        model = prop.model or prop.Prop or prop.prop or prop.prop1
    else
        return nil
    end

    if not model or model == "" then return nil end

    local bone = DEFAULT_PROP_BONE
    if type(prop) == "table" then
        local rawBone = prop.bone
            or prop.PropBone
            or prop.boneIndex
            or prop.Bone
        bone = tonumber(rawBone)
        if bone == nil then bone = DEFAULT_PROP_BONE end
    end

    local placement = type(prop) == "table" and (prop.placement or prop.PropPlacement) or nil
    local offset, rot = readPlacement(placement, prop)
    local normalized = {
        model = model,
        bone = bone,
        offset = offset,
        rot = rot,
        ox = offset.x,
        oy = offset.y,
        oz = offset.z,
        rx = rot.x,
        ry = rot.y,
        rz = rot.z,
        actorIndex = type(prop) == "table" and tonumber(prop.actorIndex or prop.actor or prop.targetActor) or nil,
        noCollision = type(prop) == "table" and (prop.noCollision == true or prop.PropNoCollision == true) or false,
        textureVariation = type(prop) == "table" and prop.textureVariation or nil,
        attachDelay = type(prop) == "table" and math.max(0, toNumber(prop.attachDelay or prop.attach_delay, 0)) or 0,
        animDuration = type(prop) == "table" and tonumber(prop.animDuration or prop.duration or prop.EmoteDuration) or nil,
        _spectremNormalized = true,
    }

    applyConfiguredOffset(normalized)
    normalized.ox = normalized.offset.x
    normalized.oy = normalized.offset.y
    normalized.oz = normalized.offset.z
    normalized.rx = normalized.rot.x
    normalized.ry = normalized.rot.y
    normalized.rz = normalized.rot.z
    return normalized
end

function SD_NormalizeAnimProps(props)
    if not props then return {} end

    if type(props) == "string" then
        local prop = SD_NormalizeAnimProp(props)
        return prop and { prop } or {}
    end

    if type(props) ~= "table" then return {} end

    if props._spectremNormalized == true or props.model or props.Prop or props.prop or props.prop1 then
        local prop = SD_NormalizeAnimProp(props)
        return prop and { prop } or {}
    end

    local list = {}
    for _, item in ipairs(props) do
        local prop = SD_NormalizeAnimProp(item)
        if prop then list[#list + 1] = prop end
    end
    return list
end

function SD_HasAnimProps(props)
    return #SD_NormalizeAnimProps(props) > 0
end

function SD_PropsNeedLookup(props)
    local normalized = SD_NormalizeAnimProps(props)
    if #normalized == 0 then return true end

    for _, prop in ipairs(normalized) do
        local off = prop.offset or {}
        local rot = prop.rot or {}
        if math.abs(toNumber(off.x, 0.0)) > 0.0001
            or math.abs(toNumber(off.y, 0.0)) > 0.0001
            or math.abs(toNumber(off.z, 0.0)) > 0.0001
            or math.abs(toNumber(rot.x, 0.0)) > 0.0001
            or math.abs(toNumber(rot.y, 0.0)) > 0.0001
            or math.abs(toNumber(rot.z, 0.0)) > 0.0001 then
            return false
        end
    end

    return true
end

function SD_ResolvePropsForAnimation(dict, anim, props)
    if not SD_PropsNeedLookup(props) then return props end
    if type(SD_LookupPropsForAnimation) ~= "function" then return props end

    local lookedUp = SD_LookupPropsForAnimation(dict, anim)
    if lookedUp and #SD_NormalizeAnimProps(lookedUp) > 0 then
        trace("prop_emotes.lookup_recovered_props", {
            dict = dict,
            anim = anim,
            count = #SD_NormalizeAnimProps(lookedUp),
        })
        return lookedUp
    end

    return props
end

function SD_BuildPropsFromAnimationOptions(opts)
    local props = {}
    if type(opts) ~= "table" then return props end

    local attachDelay = math.max(0, toNumber(opts.EmoteDuration, 0))

    local function push(model, bone, placement, noCollision)
        local normalized = SD_NormalizeAnimProp({
            model = model,
            bone = bone,
            placement = placement,
            noCollision = noCollision,
            attachDelay = attachDelay,
            animDuration = attachDelay,
        })
        if normalized then props[#props + 1] = normalized end
    end

    push(opts.Prop, opts.PropBone, opts.PropPlacement, opts.PropNoCollision)
    push(
        opts.SecondProp or opts.Prop2 or opts.PropTwo,
        opts.SecondPropBone or opts.Prop2Bone or opts.PropTwoBone,
        opts.SecondPropPlacement or opts.Prop2Placement or opts.PropTwoPlacement,
        opts.SecondPropNoCollision or opts.Prop2NoCollision or opts.PropTwoNoCollision
    )

    return props
end

function SD_GetAnimPropsDuration(props)
    local duration = -1
    for _, prop in ipairs(SD_NormalizeAnimProps(props)) do
        local propDuration = tonumber(prop.animDuration or prop.attachDelay)
        if propDuration and propDuration > duration then
            duration = propDuration
        end
    end
    return duration > 0 and duration or -1
end

function SD_PlayPropEmoteAnim(ped, dict, anim, flags, props)
    local duration = SD_GetAnimPropsDuration(props)
    local animFlags = flags or 0
    trace("prop_emotes.play_anim", {
        ped = ped,
        dict = dict,
        anim = anim,
        flags = animFlags,
        duration = duration,
        props = #SD_NormalizeAnimProps(props),
    })

    TaskPlayAnim(ped, dict, anim, 5.0, 5.0, duration, animFlags, 0.0, false, false, false)
end

local function isRootBoneProp(prop)
    return tonumber(prop and prop.bone) == 0
end

local function hasRootBoneProp(props)
    for _, prop in ipairs(SD_NormalizeAnimProps(props)) do
        if isRootBoneProp(prop) then
            return true
        end
    end
    return false
end

local function forcePedPoseUpdate(ped, rootBone)
    if rootBone and type(ForcePedMotionState) == "function" and type(GetHashKey) == "function" then
        ForcePedMotionState(ped, GetHashKey("MotionState_None"), false, 1, true)
    end
    if type(ForceEntityAiAndAnimationUpdate) == "function" then
        ForceEntityAiAndAnimationUpdate(ped)
    end
end

local function attachExistingPropToPed(ped, obj, prop, stage)
    local boneIndex = GetPedBoneIndex(ped, prop.bone or DEFAULT_PROP_BONE)
    local off = prop.offset or {}
    local rot = prop.rot or {}

    trace(stage or "prop_emotes.attach", {
        ped = ped,
        obj = obj,
        model = prop.model,
        bone = prop.bone,
        boneIndex = boneIndex,
        off = ("%.4f,%.4f,%.4f"):format(off.x or 0.0, off.y or 0.0, off.z or 0.0),
        rot = ("%.4f,%.4f,%.4f"):format(rot.x or 0.0, rot.y or 0.0, rot.z or 0.0),
    })

    AttachEntityToEntity(
        obj,
        ped,
        boneIndex,
        off.x or 0.0,
        off.y or 0.0,
        off.z or 0.0,
        rot.x or 0.0,
        rot.y or 0.0,
        rot.z or 0.0,
        true,
        true,
        false,
        true,
        1,
        true
    )
end

function SD_WaitForPropEmotePose(ped, props, context, dict, anim)
    if not ped or not DoesEntityExist(ped) then return end

    local normalized = SD_NormalizeAnimProps(props)
    if #normalized == 0 then return end

    local rootBone = hasRootBoneProp(normalized)
    local waitFrames = rootBone
        and toNumber(propConfig().RootPropPoseWaitFrames, 8)
        or toNumber(propConfig().PropPoseWaitFrames, 1)
    local startTimeoutMs = math.max(0, toNumber(propConfig().PropAnimStartTimeoutMs, 500))
    local waitedForStart = 0
    local playingBefore = false

    if type(dict) == "string" and dict ~= "" and type(anim) == "string" and anim ~= "" then
        playingBefore = IsEntityPlayingAnim(ped, dict, anim, 3)
        local deadline = GetGameTimer() + startTimeoutMs
        while not playingBefore and GetGameTimer() < deadline and DoesEntityExist(ped) do
            forcePedPoseUpdate(ped, rootBone)
            Wait(0)
            waitedForStart = waitedForStart + 1
            playingBefore = IsEntityPlayingAnim(ped, dict, anim, 3)
        end
    end

    waitFrames = math.max(0, math.floor(waitFrames))
    local beforeRot = GetEntityRotation(ped, 2)
    local beforeHeading = GetEntityHeading(ped)

    for _ = 1, waitFrames do
        forcePedPoseUpdate(ped, rootBone)
        Wait(0)
    end
    forcePedPoseUpdate(ped, rootBone)

    trace("prop_emotes.pose_wait", {
        ped = ped,
        context = context or "unknown",
        frames = waitFrames,
        rootBone = rootBone,
        animStarted = playingBefore,
        startWaitFrames = waitedForStart,
        headingBefore = ("%.4f"):format(beforeHeading or 0.0),
        headingAfter = ("%.4f"):format(GetEntityHeading(ped) or 0.0),
        rotBefore = formatVec3(beforeRot),
        rotAfter = formatVec3(GetEntityRotation(ped, 2)),
    })
end

local function loadPropModel(model)
    local hash = type(model) == "number" and model or GetHashKey(model)
    if not IsModelValid(hash) then
        print("[spectrem_director] PropEmotes invalid prop model: " .. tostring(model))
        return nil
    end

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local deadline = GetGameTimer() + PROP_MODEL_TIMEOUT_MS
        while not HasModelLoaded(hash) and GetGameTimer() < deadline do
            Wait(10)
        end
    end

    if not HasModelLoaded(hash) then
        print("[spectrem_director] PropEmotes failed to load prop model: " .. tostring(model))
        return nil
    end

    return hash
end

-- Bone-0 props inherit SKEL_ROOT, which several custom anims animate (e.g.
-- mouse@female_sitting_forward holds it pitched ~-16°), so a chair attached to
-- that bone tilts/sinks while the ped stays upright. The authored placement
-- (offsets in bone space) is resolved by the initial bone attach; afterwards we
-- re-anchor the prop to the ped ENTITY keeping the captured position and yaw
-- but dropping pitch/roll, so the result no longer depends on animation pose,
-- reattach timing, or teleports.
local function anchorRootPropToEntity(ped, obj, stage)
    local pedPos = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local objPos = GetEntityCoords(obj)
    local objRot = GetEntityRotation(obj, 2)

    local rad = math.rad(heading)
    local cosH, sinH = math.cos(rad), math.sin(rad)
    local dx, dy = objPos.x - pedPos.x, objPos.y - pedPos.y
    local ox = dx * cosH + dy * sinH
    local oy = -dx * sinH + dy * cosH
    local rz = (objRot.z or 0.0) - heading

    -- Ground the prop instead of trusting the captured Z: a standing ped's
    -- origin sits ~1m above the ground and the model bounding box tells us
    -- where the prop's base is, so base-on-ground = -1.0 - minZ regardless of
    -- what the animation later does with the root bone.
    local minDim = GetModelDimensions(GetEntityModel(obj))
    local oz = -1.0 - ((minDim and minDim.z) or 0.0)

    DetachEntity(obj, true, true)
    AttachEntityToEntity(
        obj,
        ped,
        -1,
        ox,
        oy,
        oz,
        0.0,
        0.0,
        rz,
        true,
        true,
        false,
        true,
        1,
        true
    )

    -- Detaching re-enables collision; a collidable chair corrupts GetGroundZ
    -- probes during placement (the marker Z climbs onto the chair every tick).
    SetEntityCollision(obj, false, false)
    if type(SetEntityNoCollisionEntity) == "function" then
        SetEntityNoCollisionEntity(obj, ped, true)
    end

    trace(stage or "prop_emotes.root_anchor", {
        ped = ped,
        obj = obj,
        off = ("%.4f,%.4f,%.4f"):format(ox, oy, oz),
        rotZ = ("%.4f"):format(rz),
        capturedRot = formatVec3(objRot),
    })
end

local function attachOneProp(ped, prop)
    local hash = loadPropModel(prop.model)
    if not hash then return nil end

    local x, y, z = table.unpack(GetEntityCoords(ped))
    -- dynamic=true like RPEmotes: props with a static archetype (some addon
    -- models) otherwise spawn frozen and desync from the bone on teleports.
    local obj = CreateObject(hash, x, y, z + 0.2, false, false, true)
    if not obj or obj == 0 or not DoesEntityExist(obj) then
        print("[spectrem_director] PropEmotes failed to create prop: " .. tostring(prop.model))
        SetModelAsNoLongerNeeded(hash)
        return nil
    end

    SetEntityAsMissionEntity(obj, true, true)
    FreezeEntityPosition(obj, false)

    if prop.textureVariation ~= nil and type(SetObjectTextureVariation) == "function" then
        SetObjectTextureVariation(obj, prop.textureVariation)
    end

    -- Root props are always non-collidable: they are visual set dressing glued
    -- to the actor, and their collision corrupts ground probes during placement.
    if prop.noCollision == true or isRootBoneProp(prop) then
        SetEntityCollision(obj, false, false)
        if type(SetEntityNoCollisionEntity) == "function" then
            SetEntityNoCollisionEntity(obj, ped, true)
        end
    end

    attachExistingPropToPed(ped, obj, prop, "prop_emotes.attach")

    if isRootBoneProp(prop) then
        -- At least one frame so the bone attach transform is applied before capture
        local settleFrames = math.max(1, math.floor(toNumber(propConfig().RootPropReattachFrames, 1)))
        for _ = 1, settleFrames do
            forcePedPoseUpdate(ped, true)
            Wait(0)
        end
        if DoesEntityExist(ped) and DoesEntityExist(obj) then
            anchorRootPropToEntity(ped, obj, "prop_emotes.root_anchor")
        end
    end

    local targetAlpha = GetEntityAlpha(ped)
    if targetAlpha and targetAlpha < 255 then
        SetEntityAlpha(obj, targetAlpha, false)
    end

    SetModelAsNoLongerNeeded(hash)
    traceEntity("prop_emotes.attached_entity", obj)
    return obj
end

function SD_AttachPropsToPed(ped, props, bucket, onAttached)
    local attached = {}
    if not ped or not DoesEntityExist(ped) then return attached end
    if propConfig().DisablePropsVisually then return attached end

    local normalized = SD_NormalizeAnimProps(props)
    trace("prop_emotes.attach_props", { ped = ped, count = #normalized })

    local function track(obj)
        if not obj then return end
        attached[#attached + 1] = obj
        if bucket and bucket ~= attached then
            bucket[#bucket + 1] = obj
        end
        if type(onAttached) == "function" then
            onAttached(obj)
        end
    end

    for index, prop in ipairs(normalized) do
        local delay = math.max(0, toNumber(prop.attachDelay, 0))
        if delay > 0 then
            CreateThread(function()
                Wait(delay)
                if DoesEntityExist(ped) then
                    track(attachOneProp(ped, prop))
                end
            end)
        else
            track(attachOneProp(ped, prop))
        end
        trace("prop_emotes.attach_queued", { index = index, delay = delay, model = prop.model })
    end

    return attached
end

function SD_PartitionAnimProps(props)
    local rootProps, handProps = {}, {}
    for _, prop in ipairs(SD_NormalizeAnimProps(props)) do
        if isRootBoneProp(prop) then
            rootProps[#rootProps + 1] = prop
        else
            handProps[#handProps + 1] = prop
        end
    end
    return rootProps, handProps
end

-- ============================================================================
-- Dedicated PropEmotes flow (preview / placement)
--
-- Root (bone 0) props must be attached BEFORE the emote anim starts, while the
-- skeleton is still neutral. The bone attach resolves the authored bone-space
-- placement against a neutral SKEL_ROOT — the same geometry RPEmotes produces
-- on a standing player — and anchorRootPropToEntity pins that result to the
-- ped entity so it stays upright and stable. Attaching after the anim starts
-- samples a blending or root-animated pose: the captured transform then varies
-- per run (the -8°..-16° pitch drift seen with mouse@female_sitting_forward).
--
-- Hand/bone props keep the old order (anim first, then attach) because they
-- are meant to follow animated bones.
-- ============================================================================

local THIGH_L_BONE = 58271 -- SKEL_L_Thigh
local THIGH_R_BONE = 51826 -- SKEL_R_Thigh

-- World-space facing of the ped's BODY (not the entity), derived from the hip
-- bones. Clips with baked root motion rotate the skeleton away from the
-- entity heading; sampling bone positions avoids the euler coupling that makes
-- SKEL_ROOT's reported z-rotation unreliable when the root is also pitched.
function SD_GetPedBodyYaw(ped)
    if not ped or not DoesEntityExist(ped) then return nil end
    local li = GetPedBoneIndex(ped, THIGH_L_BONE)
    local ri = GetPedBoneIndex(ped, THIGH_R_BONE)
    if not li or li == -1 or not ri or ri == -1 then return nil end

    local lp = GetWorldPositionOfEntityBone(ped, li)
    local rp = GetWorldPositionOfEntityBone(ped, ri)
    if not lp or not rp then return nil end

    local lx, ly = lp.x - rp.x, lp.y - rp.y
    if (lx * lx + ly * ly) < 0.0004 then return nil end

    -- forward = lateral (right->left hip) x up
    local fx, fy = ly, -lx
    return math.deg(math.atan(-fx, fy))
end

function SD_AttachRootPropsBeforeEmote(ped, props, bucket, context, onAttached)
    if not ped or not DoesEntityExist(ped) then return {} end
    local rootProps = SD_PartitionAnimProps(props)
    if #rootProps == 0 then return {} end

    -- Neutralize the skeleton: a reused preview ped may still hold the
    -- previous emote's pose, which would contaminate the captured transform.
    ClearPedTasksImmediately(ped)
    for _ = 1, 2 do
        forcePedPoseUpdate(ped, true)
        Wait(0)
    end

    trace("prop_emotes.attach_root_pre_anim", {
        ped = ped,
        context = context or "unknown",
        count = #rootProps,
    })
    local rootEnts = SD_AttachPropsToPed(ped, rootProps, bucket, onAttached)

    -- Neutral references for the steady-state refine: the anchor above ran on
    -- a neutral skeleton, so the body yaw and each prop's relative yaw at this
    -- moment are the baseline the anim's baked root motion is measured against.
    local neutralBodyYaw = SD_GetPedBodyYaw(ped)
    local baseRelYaw = {}
    do
        local h = GetEntityHeading(ped)
        for _, obj in ipairs(rootEnts) do
            if DoesEntityExist(obj) then
                baseRelYaw[obj] = GetEntityRotation(obj, 2).z - h
            end
        end
    end

    -- Steady-state refine: clips with baked root motion (mouse@* pack) move
    -- AND rotate the body away from the entity origin (forward: ~-16° pitch +
    -- 0.2m slide; folded: large root yaw), so the anchored props must follow
    -- the root's X/Y and YAW — keeping Z ground-locked and pitch/roll upright.
    -- Runs several passes because the clip may take over a second to settle.
    CreateThread(function()
        local delay = math.max(100, toNumber(propConfig().RootPropRefineDelayMs, 600))
        local lastApplied = {}

        for _ = 1, 5 do
            Wait(delay)
            if not ped or not DoesEntityExist(ped) then return end

            local pedPos = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local rootPos = GetWorldPositionOfEntityBone(ped, 0)
            if not rootPos then return end

            local rad = math.rad(heading)
            local cosH, sinH = math.cos(rad), math.sin(rad)
            local dx, dy = rootPos.x - pedPos.x, rootPos.y - pedPos.y
            local lx = dx * cosH + dy * sinH
            local ly = -dx * sinH + dy * cosH

            -- Anim never started / ped mid-teleport: offsets beyond 1.5m are bogus
            if (lx * lx + ly * ly) > 2.25 then return end

            local yawDelta = 0.0
            if neutralBodyYaw then
                local bodyYaw = SD_GetPedBodyYaw(ped)
                if bodyYaw then
                    yawDelta = ((bodyYaw - neutralBodyYaw) + 540.0) % 360.0 - 180.0
                end
            end

            local anyAlive = false
            for _, obj in ipairs(rootEnts) do
                if DoesEntityExist(obj) then
                    anyAlive = true
                    local rz = (baseRelYaw[obj] or (GetEntityRotation(obj, 2).z - heading)) + yawDelta
                    local last = lastApplied[obj]
                    local changed = not last
                        or math.abs(last.lx - lx) > 0.01
                        or math.abs(last.ly - ly) > 0.01
                        or math.abs(((last.rz - rz) + 540.0) % 360.0 - 180.0) > 0.5

                    if changed then
                        local minDim = GetModelDimensions(GetEntityModel(obj))
                        local oz = -1.0 - ((minDim and minDim.z) or 0.0)

                        DetachEntity(obj, true, true)
                        AttachEntityToEntity(obj, ped, -1, lx, ly, oz, 0.0, 0.0, rz, true, true, false, true, 1, true)
                        SetEntityCollision(obj, false, false)
                        if type(SetEntityNoCollisionEntity) == "function" then
                            SetEntityNoCollisionEntity(obj, ped, true)
                        end
                        lastApplied[obj] = { lx = lx, ly = ly, rz = rz }

                        trace("prop_emotes.root_anchor_refine", {
                            ped = ped,
                            obj = obj,
                            context = context or "unknown",
                            off = ("%.4f,%.4f,%.4f"):format(lx, ly, oz),
                            rotZ = ("%.4f"):format(rz),
                            yawDelta = ("%.4f"):format(yawDelta),
                        })
                    end
                end
            end
            if not anyAlive then return end
        end
    end)

    return rootEnts
end

function SD_AttachHandPropsAfterEmote(ped, props, bucket, context, dict, anim, onAttached)
    if not ped or not DoesEntityExist(ped) then return {} end
    local _, handProps = SD_PartitionAnimProps(props)
    if #handProps == 0 then return {} end

    SD_WaitForPropEmotePose(ped, handProps, context, dict, anim)
    return SD_AttachPropsToPed(ped, handProps, bucket, onAttached)
end

function SD_ReattachPropsToPed(ped, props, entities, stage, onlyRoot)
    if not ped or not DoesEntityExist(ped) then return end
    if type(entities) ~= "table" then return end

    -- Entities are bucketed root-first (pre-anim attach) so their order no
    -- longer matches the config order; match each prop to its entity by model.
    local used = {}
    local function findEntityForProp(prop)
        local hash = GetHashKey(prop.model)
        for i, obj in ipairs(entities) do
            if not used[i] and obj and DoesEntityExist(obj) and GetEntityModel(obj) == hash then
                used[i] = true
                return obj
            end
        end
        return nil
    end

    local normalized = SD_NormalizeAnimProps(props)
    for _, prop in ipairs(normalized) do
        -- Root props are anchored to the ped entity (anchorRootPropToEntity) and
        -- follow teleports/heading changes natively. Detaching and re-attaching
        -- them here re-samples the animated SKEL_ROOT pose, which tilts chairs
        -- and makes them jitter while dragging.
        --
        -- Hand/bone props are the opposite: teleporting a frozen ped corrupts
        -- their bone attachment basis, so they MUST be re-attached with their
        -- configured bone-space placement after every teleport.
        if not isRootBoneProp(prop) then
            local obj = findEntityForProp(prop)
            if obj then
                forcePedPoseUpdate(ped, false)
                DetachEntity(obj, true, true)
                attachExistingPropToPed(ped, obj, prop, (stage or "prop_emotes") .. ".reattach")
                traceEntity((stage or "prop_emotes") .. ".reattach_entity", obj)
            end
        end
    end
end

function SD_ClearPropEntities(entities)
    if type(entities) ~= "table" then return end
    for _, entity in ipairs(entities) do
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
end

function SD_GetPropPlacementGroundOffset(props)
    if #SD_NormalizeAnimProps(props) > 0 then
        return 1.0
    end
    return 0.0
end

-- RPEmotes attaches root props directly. The old Director heading correction
-- fights the attachment transform and can push chairs/seats out of place.
function SD_CorrectRootPropAttachment()
    return
end

function SD_CorrectRootPropsForPed()
    return
end

function SD_ReattachRootPropIfInverted()
    return false
end
