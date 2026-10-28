-- FindFreeSpawnPoint: returns the first vehicle spawn location with no nearby vehicles or peds
-- Falls back to the first configured location if all are occupied.
function FindFreeSpawnPoint()
    for _, spawnPoint in ipairs(Config.vehicleSpawnLocations) do
        local pos    = vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z)
        local radius = Config.spawnCheckRadius

        -- Type 1 = peds, Type 2 = vehicles
        local nearbyPeds     = GetEntitiesInRadius(pos, radius, 1, false, nil)
        local nearbyVehicles = GetEntitiesInRadius(pos, radius, 2, false, nil)

        if #nearbyPeds == 0 and #nearbyVehicles == 0 then
            return spawnPoint
        end
    end

    -- All spots occupied — return the first one as a fallback
    return Config.vehicleSpawnLocations[1]
end

-- EstimateContractDuration: estimate total contract time (seconds) for the given contract definition
-- contractDef: contract definition table, playerCount: number of players (default 1)
-- Returns a table with totalMs, totalSeconds, travelTimeSeconds, cleanTimeSeconds,
-- transitionTimeSeconds, and formatted ("M:SS") fields.
function EstimateContractDuration(contractDef, playerCount)
    if not playerCount then playerCount = 1 end

    -- Tuning constants
    local SPEED_MULTIPLIER   = 1.37   -- factor applied to straight-line distance for travel time
    local TRAVEL_SPEED_MPH   = 55     -- assumed average travel speed (mph)
    local CLEAN_RATE_M2_MIN  = 65     -- square metres cleaned per minute at base speed
    local AREA_PER_M2        = 25     -- square metres of wash work per m² of surface area
    local STOP_TIME_SEC      = 5      -- seconds added per stop/transition
    local BASE_TRANSITION    = 60     -- base transition/setup time (seconds)
    local PLAYER_BONUS_2     = 0.75   -- cleaning speed bonus for 2nd player
    local PLAYER_BONUS_EXTRA = 0.6    -- cleaning speed bonus per additional player beyond 2nd
    local MILES_PER_METRE    = 1609.34

    -- Convert travel speed to metres/second
    local travelSpeedMs = (TRAVEL_SPEED_MPH * MILES_PER_METRE) / 3600

    -- Helper: Euclidean distance between two positions
    local function dist3D(a, b)
        local dx = a.x - b.x
        local dy = a.y - b.y
        local dz = a.z - b.z
        return math.sqrt(dx * dx + dy * dy + dz * dz)
    end

    -- Helper: approximate area of a quadrilateral from four corner vectors
    local function quadArea(corners)
        local d1 = vector3(corners[3].x - corners[1].x, corners[3].y - corners[1].y, corners[3].z - corners[1].z)
        local d2 = vector3(corners[4].x - corners[2].x, corners[4].y - corners[2].y, corners[4].z - corners[2].z)
        -- Cross product magnitude / 2 = half the parallelogram area
        local cross = vector3(
            d1.y * d2.z - d1.z * d2.y,
            d1.z * d2.x - d1.x * d2.z,
            d1.x * d2.y - d1.y * d2.x
        )
        return math.sqrt(cross.x * cross.x + cross.y * cross.y + cross.z * cross.z) * 0.5
    end

    local travelTimeSec     = 0
    local cleanTimeSec      = 0
    local transitionTimeSec = BASE_TRANSITION

    -- Collect all location coords
    local locationCoords = {}
    for _, loc in ipairs(contractDef.locations) do
        table.insert(locationCoords, loc.coords)
    end

    -- Estimate travel time between stops (HQ → loc[1] → loc[2] → … → HQ)
    local hqCoords   = Config.headquarters.coords
    local prevCoords = hqCoords
    for _, coords in ipairs(locationCoords) do
        local d = dist3D(prevCoords, coords) * SPEED_MULTIPLIER
        if d < 1400 then d = d * 1.35 end  -- short-distance city driving penalty
        travelTimeSec      = travelTimeSec + (d / travelSpeedMs)
        transitionTimeSec  = transitionTimeSec + STOP_TIME_SEC
        prevCoords         = coords
    end
    -- Return trip to HQ
    travelTimeSec     = travelTimeSec + (dist3D(prevCoords, hqCoords) * SPEED_MULTIPLIER) / travelSpeedMs
    transitionTimeSec = transitionTimeSec + STOP_TIME_SEC

    -- Estimate cleaning time from area sizes
    for _, loc in ipairs(contractDef.locations) do
        for _, spot in ipairs(loc.spots) do
            transitionTimeSec = transitionTimeSec + STOP_TIME_SEC
            for _, area in ipairs(spot.areas) do
                local corners    = area.corners or area
                local multiplier = area.cleaningMultiplier or 1.0
                local areaSqM    = quadArea(corners)
                -- Time = area / (m² cleaned per minute) × (area units per m²) ÷ multiplier
                local areaTime = (areaSqM / AREA_PER_M2) * CLEAN_RATE_M2_MIN / multiplier
                cleanTimeSec = cleanTimeSec + areaTime
            end
        end
    end

    -- Apply player-count bonus to cleaning speed
    local speedFactor = 1.0
    if playerCount >= 2 then speedFactor = speedFactor + PLAYER_BONUS_2 end
    if playerCount >= 3 then speedFactor = speedFactor + PLAYER_BONUS_EXTRA * (playerCount - 2) end
    cleanTimeSec = cleanTimeSec / speedFactor

    local totalSec = travelTimeSec + cleanTimeSec + transitionTimeSec

    return {
        totalMs              = math.floor(totalSec * 1000),
        totalSeconds         = totalSec,
        travelTimeSeconds    = travelTimeSec,
        cleanTimeSeconds     = cleanTimeSec,
        transitionTimeSeconds = transitionTimeSec,
        formatted            = string.format("%d:%02d", math.floor(totalSec / 60), math.floor(totalSec % 60)),
    }
end

-- CalculateContractRating: returns a star rating (3-5) based on actual vs estimated time
-- estimatedSec: estimated duration, actualSec: real elapsed time
function CalculateContractRating(estimatedSec, actualSec)
    if estimatedSec <= 0 or actualSec <= 0 then return 3 end

    local ratio = actualSec / estimatedSec
    if ratio <= 1.0  then return 5
    elseif ratio <= 1.25 then return 4
    else return 3
    end
end