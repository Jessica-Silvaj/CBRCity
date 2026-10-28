-- ============================================================================
-- PropEmotes placement helpers
-- Keeps PropEmotes placement separate from the generic scene placement math.
-- The placement marker is kept slightly above ground for camera/marker UX, but
-- peds that run PropEmotes must spawn at the real ground origin.
-- ============================================================================

local function propPlacementConfig()
    if type(Config) == "table" and type(Config.PropEmotes) == "table" then
        return Config.PropEmotes
    end
    return {}
end

local function hasPlacementProps(props)
    return type(SD_HasAnimProps) == "function" and SD_HasAnimProps(props)
end

local function tracePlacement(stage, data)
    if type(SD_TracePropFlow) == "function" then
        SD_TracePropFlow(stage, data)
    end
end

function SD_IsPropEmotePlacement(props)
    return hasPlacementProps(props)
end

function SD_GetPropPlacementGroundOffset(props)
    if not hasPlacementProps(props) then return 0.0 end
    return tonumber(propPlacementConfig().PlacementGroundOffset) or 1.0
end

function SD_GetPropEmotePlacementPedZ(z, props)
    z = tonumber(z) or 0.0
    if not hasPlacementProps(props) then return z end

    -- The marker rides at ground + PlacementGroundOffset (1.0), which is also
    -- the standing capsule height of a ped: entity origin ~1m above ground.
    -- The ped Z must MATCH the marker. Subtracting the offset here buried the
    -- ped 1m whenever update_origin teleported it (CreatePed auto-grounds the
    -- capsule on spawn, masking the mismatch until the first drag).
    local offset = tonumber(propPlacementConfig().PlacementPedZOffset) or 0.0
    return z - offset
end

function SD_GetPropEmotePlacementPedPosition(pos, props)
    if not pos then return pos end
    if not hasPlacementProps(props) then return pos end

    return vector3(
        pos.x,
        pos.y,
        SD_GetPropEmotePlacementPedZ(pos.z, props)
    )
end

function SD_TracePropEmotePlacementZ(stage, visualPos, props)
    if not visualPos or not hasPlacementProps(props) then return end

    tracePlacement(stage, {
        visualZ = ("%.4f"):format(visualPos.z or 0.0),
        pedZ = ("%.4f"):format(SD_GetPropEmotePlacementPedZ(visualPos.z, props)),
        groundOffset = ("%.4f"):format(SD_GetPropPlacementGroundOffset(props)),
    })
end
