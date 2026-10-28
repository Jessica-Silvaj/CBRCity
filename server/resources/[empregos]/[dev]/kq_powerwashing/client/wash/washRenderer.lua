-- Manages runtime dirt textures for wash areas and renders them as textured polys each frame.
-- Also handles texture creation, pixel-level upscaling, noise-based dirt visuals,
-- and the "washer vision" dirt-highlight overlay.

-- Declaración anticipada para evitar nil al llamar métodos antes de que se defina la tabla
WashRenderer = {}

-- Module-level state tables
local activeWashAreas  = {}     -- list of currently active WashArea data tables
local textureHandles   = {}     -- [areaId] = { runtime, txd, txdName, textureName, ... }
local savedOpacityData = {}     -- [areaId] = packed binary opacity string (last server value)
local serverOpacityGrid = {}    -- [areaId] = unpacked opacity grid (server state)
local localOpacityGrid  = {}    -- [areaId] = unpacked opacity grid (local deltas applied)
local extraOpacityCache = {}    -- [areaId] = extra opacity pixel grid for dirt-border effect

-- Drawing-distance thresholds
local drawDistNormal = 30.0
local drawDistBlips  = 70.0

-- Client texture quality settings
local targetPixelSize  = Config.clientTargetPixelSize or 0.022
local maxTextureSize   = Config.clientMaxTextureSize  or 512

-- Default noise blend strength
local defaultBlendStrength = 0.2

-- Default dirt colour (dark brown)
local defaultDirtColor = { 30, 26, 22 }


-- Renderer state used by washCleaner for the dirt-highlight pulse
Renderer = {
    extraLayerOpacity          = 0,
    extraLayerLastUse          = 0,
    washerVisionHintsRemaining = 2,
    washerVisionLastHint       = 0,
}


-- ============================================================
-- Hint system
-- ============================================================

-- Show a keybind hint for washer vision if hints remain and cooldown has passed
local function HintAtWasherVision()
    Debug("HintAtWasherVision")
    if not (Config.dirtHighlight.enabled
        and Renderer.washerVisionHintsRemaining > 0
        and Renderer.washerVisionLastHint + 90000 < GetGameTimer()) then
        Debug("Cancel hint")
        return
    end

    Renderer.washerVisionHintsRemaining = Renderer.washerVisionHintsRemaining - 1
    Renderer.washerVisionLastHint       = GetGameTimer()
    Debug("Show hint")
    ShowKeybindHint(L("keybinds.washer_vision"))
end

-- ============================================================
-- Draw distance
-- ============================================================

-- Returns draw distance (cached 2s), extended when blips are active
local function GetDrawDistance()
    return UseCache("GetDrawDistance", function()
        if WASH_BLIPS_ACTIVE > 0 then
            return drawDistBlips
        end
        return drawDistNormal
    end, 2000)
end

-- ============================================================
-- Texture cache management
-- ============================================================

-- Remove all cached data for one wash area
local function RemoveAreaCache(areaId)
    textureHandles[areaId]    = nil
    savedOpacityData[areaId]  = nil
    serverOpacityGrid[areaId] = nil
    localOpacityGrid[areaId]  = nil
    extraOpacityCache[areaId] = nil
end

-- Clear all cached data for all areas and force a GC
local function ClearAllCaches()
    for id in pairs(textureHandles)    do textureHandles[id]    = nil end
    for id in pairs(savedOpacityData)  do savedOpacityData[id]  = nil end
    for id in pairs(serverOpacityGrid) do serverOpacityGrid[id] = nil end
    for id in pairs(localOpacityGrid)  do localOpacityGrid[id]  = nil end
    for id in pairs(extraOpacityCache) do extraOpacityCache[id] = nil end
    if WipeAllCache then WipeAllCache() end
    collectgarbage("collect")
    Debug("All caches cleared")
end

-- ============================================================
-- Binary opacity encoding / decoding
-- ============================================================

-- Hash a string (used to detect opacity data changes without deep comparison)
local function HashString(str)
    local hash = 0
    for i = 1, #str do
        hash = (hash * 31 + string.byte(str, i)) % 2147483647
    end
    return hash
end

-- Unpack a packed binary opacity string into a 2D grid [x][y] = 0..3
-- Pixels are packed 4 per byte, 2 bits each, row-major (iterating y then x per pixel).
local function UnpackOpacityData(data, gridWidth, gridHeight)
    local grid   = {}
    local pixelIdx = 0

    for _, byte in ipairs({ data:byte(1, #data) }) do
        for shift = 6, 0, -2 do
            local opacity = (byte >> shift) & 3
            local x = pixelIdx % gridWidth + 1
            local y = math.floor(pixelIdx / gridWidth) + 1
            if y <= gridHeight then
                if not grid[x] then grid[x] = {} end
                grid[x][y] = opacity
            end
            pixelIdx = pixelIdx + 1
        end
    end

    return grid
end

-- Pack a 2D grid [x][y] into a binary string (same layout as UnpackOpacityData)
local function PackOpacityGrid(grid, gridWidth, gridHeight)
    local chunks = {}
    local byte   = 0
    local bitPos = 6

    for y = 1, gridHeight do
        for x = 1, gridWidth do
            local opacity = math.floor(math.min(3, math.max(0, (grid[x] and grid[x][y]) or 3)))
            byte    = byte | (opacity << bitPos)
            bitPos  = bitPos - 2
            if bitPos < 0 then
                table.insert(chunks, string.char(byte))
                byte   = 0
                bitPos = 6
            end
        end
    end
    if bitPos < 6 then
        table.insert(chunks, string.char(byte))
    end
    return table.concat(chunks)
end

-- ============================================================
-- Pixel change detection
-- ============================================================

-- Returns a list of {x, y} pixels that differ between oldGrid and newGrid.
-- If oldGrid is nil, returns all pixels in the grid (full refresh).
local function GetChangedPixels(oldGrid, newGrid, gridWidth, gridHeight)
    local changed = {}

    for x = 1, gridWidth do
        for y = 1, gridHeight do
            local oldVal = (oldGrid and oldGrid[x] and oldGrid[x][y]) or 3
            local newVal = (newGrid       and newGrid[x]  and newGrid[x][y])  or 3
            if oldVal ~= newVal then
                table.insert(changed, { x = x, y = y })
            end
        end
    end

    return changed
end

-- ============================================================
-- Edge fade
-- ============================================================

-- Compute the edge fade factor for pixel (px, py) in a grid of size W×H.
-- Returns 0 at the very edge, 1 well inside.
local function ComputeEdgeFade(px, py, gridW, gridH, edgeFadeout, areaId, pixelSize)
    local upscaleFactor = math.max(2, math.ceil(edgeFadeout / pixelSize))
    local minEdgeDist   = math.min(px - 1, py - 1, gridW - px, gridH - py)

    if minEdgeDist <= 0 then return 0.0 end

    local noiseX = px * 0.03
    local noiseY = py * 0.03

    -- Combine two octave noise layers into an irregular edge modifier
    local noise1 = Perlin.octaveNoise(noiseX, noiseY, 2, 0.5, areaId or 0) * 2 - 1
    local noise2 = Perlin.noise(px * 0.1, py * 0.1, (areaId or 0) + 50) * 2 - 1
    local combined = (noise1 * 0.7 + noise2 * 0.3) * upscaleFactor * (Config.edgeIrregularityStrength or 1.2)

    local adjusted   = minEdgeDist - combined
    local fadeZone   = upscaleFactor * 1.3

    if adjusted <= 0 then return 0.0 end
    if adjusted >= fadeZone then return 1.0 end

    local fade = adjusted / fadeZone

    -- Optional extra blob suppression near dirty borders
    local edgeBlobNoise = Perlin.noise(px * 0.12, py * 0.12, (areaId or 0) + 100)
    if edgeBlobNoise > 0.6 and fade < 0.4 then
        local blobT = (edgeBlobNoise - 0.6) / 0.4
        fade = fade * (1.0 - blobT * (Config.edgeBlobStrength or 0.7))
    end

    return fade
end

-- ============================================================
-- Dirt opacity lookup
-- ============================================================

-- Cached opacity table (loaded once from Config.dirtOpacity)
local cachedOpacityTable = nil
local function GetOpacityTable()
    if not cachedOpacityTable then
        cachedOpacityTable = {
            [0] = Config.dirtOpacity[0] or 0,
            [1] = Config.dirtOpacity[1] or 70,
            [2] = Config.dirtOpacity[2] or 110,
            [3] = Config.dirtOpacity[3] or 150,
        }
    end
    return cachedOpacityTable
end

-- Interpolate the opacity value for a fractional dirt level using the opacity table
local function InterpolateOpacity(dirtLevel, opacityTable)
    local lower = math.floor(dirtLevel)
    local frac  = dirtLevel - lower
    lower = math.max(0, math.min(3, lower))
    local upper = math.min(3, lower + 1)
    return opacityTable[lower] + (opacityTable[upper] - opacityTable[lower]) * frac
end

-- ============================================================
-- Fast integer hash (noise substitute)
-- ============================================================

-- Returns a value in [-1, 1] from three integer seeds
local function IntHash(x, y, seed)
    local h = x * 374761393 + y * 668265263 + seed * 1013904223
    h = h ~ (h >> 13)
    h = h * 1274126177
    h = h ~ (h >> 16)
    return ((h % 65536) / 65536.0) * 2 - 1
end

-- ============================================================
-- Bilinear-interpolated opacity sampling
-- ============================================================

-- Sample the opacity grid at a fractional (scaledX, scaledY) position
-- using bilinear interpolation with distortion noise, returning (opacity, extraBlob)
-- texX, texY: integer texture-space coordinates (sub-pixel resolution).
-- These are required so that IntHash produces a unique value per sub-pixel,
-- avoiding the banding that occurs when float grid-space coords are truncated
-- to the same integer for all sub-pixels inside a grid cell.
local function SampleOpacityBilinear(scaledX, scaledY, grid, gridW, gridH, invScale, areaId,
                                     blendDistort, transNoise, borderNoise, borderExtra, extraBlobOpacity,
                                     texX, texY)
    local fx = math.floor(scaledX)
    local fy = math.floor(scaledY)
    local tx = scaledX - fx
    local ty = scaledY - fy
    local nx = math.min(gridW, fx + 1)
    local ny = math.min(gridH, fy + 1)

    -- Clamp to grid bounds
    fx = math.max(1, math.min(gridW, fx))
    fy = math.max(1, math.min(gridH, fy))

    -- Read the 4 surrounding opacity values (default 3 = fully dirty)
    local q00 = (grid[fx] and grid[fx][fy]) or 3
    local q10 = (grid[nx] and grid[nx][fy]) or 3
    local q01 = (grid[fx] and grid[fx][ny]) or 3
    local q11 = (grid[nx] and grid[nx][ny]) or 3

    -- Use integer texture-space coords for hashing so every sub-pixel gets a unique
    -- noise value (float grid coords truncate to the same int for the whole cell -> bands).
    local hx = texX or math.floor(scaledX * 64)
    local hy = texY or math.floor(scaledY * 64)

    -- Apply noise distortion to the interpolation coordinates
    local distX = IntHash(hx, hy, areaId)               * blendDistort
    local distY = IntHash(hx + 100003, hy + 200003, areaId + 500) * blendDistort
    tx = math.max(0, math.min(1, tx + distX))
    ty = math.max(0, math.min(1, ty + distY))

    -- Bilinear interpolation
    local topBlend    = q00 + (q10 - q00) * tx
    local bottomBlend = q01 + (q11 - q01) * tx
    local blended     = topBlend + (bottomBlend - topBlend) * ty

    -- Transition noise at clean/dirty boundaries
    local minV  = math.min(q00, q10, q01, q11)
    local maxV  = math.max(q00, q10, q01, q11)
    local extra = 0.0

    if minV < maxV then
        local edgeFactor = (1 - math.min(tx, 1 - tx, ty, 1 - ty) * 2)
        edgeFactor = (1 - edgeFactor) ^ 2
        local tNoise   = IntHash(hx, hy, areaId)          * transNoise * edgeFactor * (maxV - minV) / 3
        blended = blended + tNoise

        if maxV == 3 and minV < 3 then
            local bNoise  = IntHash(hx, hy, areaId)       * borderNoise * edgeFactor
            blended       = blended + bNoise

            -- Extra micro-blob at very dirty borders
            local microHash = IntHash(hx * 2, hy * 2, areaId + 7777)
            if microHash > 0.3 then
                local t      = (microHash - 0.3) / 0.7
                extra = (extraBlobOpacity or 0.12) * edgeFactor * t
            end
        end

        blended = blended + extra
    end

    blended = math.max(0, math.min(3, blended))
    return blended, extra
end

-- ============================================================
-- Texture upscaling
-- ============================================================

-- Upscale a grid by `upscaleFactor`, returning (upscaledGrid, newW, newH, extraGrid)
-- Yields every 1500 pixels to avoid frame stalls.
local function UpscaleGrid(inputGrid, gridW, gridH, areaId, upscaleFactor, blendDistort, transNoise, borderNoise, borderExtra)
    local newW      = gridW * upscaleFactor
    local newH      = gridH * upscaleFactor
    local invScale  = 1.0 / upscaleFactor
    local result    = {}
    local extraGrid = {}
    local counter   = 0

    blendDistort = blendDistort or Config.blendDistortionStrength or 0.4
    transNoise   = transNoise   or Config.transitionNoiseStrength or 0.2
    borderNoise  = borderNoise  or Config.dirtyBorderNoiseStrength or 0.3
    borderExtra  = borderExtra  or Config.dirtyBorderExtraOpacity  or 0.12

    for x = 1, newW do
        result[x]    = {}
        extraGrid[x] = {}
        for y = 1, newH do
            local srcX = (x - 1) * invScale + 1
            local srcY = (y - 1) * invScale + 1
            -- Pass x, y as integer texture-space coords so IntHash varies per sub-pixel
            local opacity, extra = SampleOpacityBilinear(
                srcX, srcY, inputGrid, gridW, gridH, invScale, areaId,
                blendDistort, transNoise, borderNoise, borderExtra, nil, x, y
            )
            result[x][y]    = opacity
            extraGrid[x][y] = extra

            counter = counter + 1
            if counter >= 1500 then
                counter = 0
                Wait(5)
            end
        end
    end

    return result, newW, newH, extraGrid
end

-- ============================================================
-- Texture creation
-- ============================================================

-- Create a runtime TXD + texture for a wash area and fill pixels.
-- Returns a handle table: { runtime, txd, txdName, textureName, upscaleFactor, ... }
local function CreateWashTexture(areaData)
    local edgeFadeout      = areaData.edgeFadeout or defaultBlendStrength
    local dirtColor        = areaData.dirtColor   or defaultDirtColor
    local pixelSize        = areaData.pixelSize

    -- Compute upscale factor to hit targetPixelSize
    local effectiveSize = targetPixelSize
    local rawUpscale    = math.max(1, math.floor(pixelSize / effectiveSize + 0.5))
    local texW          = areaData.gridWidth  * rawUpscale
    local texH          = areaData.gridHeight * rawUpscale
    local texPixels     = texW * texH
    local maxPixels     = maxTextureSize * maxTextureSize

    -- Scale back if over the texture budget
    if texPixels > maxPixels then
        local scaleFactor  = math.sqrt(texPixels / maxPixels)
        effectiveSize      = effectiveSize * scaleFactor
        Debug(string.format(
            "Texture would be %dx%d (%d pixels), scaling pixel size to %.4fm to fit within %dx%d (%d pixels) limit",
            texW, texH, texPixels, effectiveSize, maxTextureSize, maxTextureSize, maxPixels
        ))
    end

    local upscaleFactor = math.max(1, math.floor(pixelSize / effectiveSize + 0.5))
    Debug(string.format(
        "Calculated upscale factor: %d (target pixel: %.2fcm, actual: %.2fcm)",
        upscaleFactor, effectiveSize * 100, pixelSize * 100
    ))

    local areaIdHash  = HashString(areaData.id)
    local textureName = "wash_area_" .. areaData.id
    local txdName     = "wash_txd_"  .. areaData.id

    -- Unpack and upscale the opacity data
    Debug("Unpacking opacity data...")
    local inputGrid = UnpackOpacityData(areaData.opacityData, areaData.gridWidth, areaData.gridHeight)
    Debug("Opacity data unpacked")

    Debug("Upscaling texture...")
    local upscaledGrid, finalW, finalH = UpscaleGrid(inputGrid, areaData.gridWidth, areaData.gridHeight, areaIdHash, upscaleFactor)
    Debug(string.format("Upscaled to %dx%d (rendered pixel size: %.2fcm)",
        finalW, finalH, (pixelSize / upscaleFactor) * 100))

    -- Create GPU texture
    Debug("Creating runtime TXD: " .. txdName)
    local txd = CreateRuntimeTxd(txdName)
    Debug("Creating runtime texture: " .. textureName)
    local rtTexture = CreateRuntimeTexture(txd, textureName, finalW, finalH)
    Debug("Runtime handle: " .. tostring(rtTexture))

    -- Noise/dirt visual constants
    local opacityTable     = GetOpacityTable()
    local blobFreq         = Config.dirtBlobFrequency
    local blobMin          = Config.dirtBlobMinOpacity
    local blobMax          = Config.dirtBlobMaxOpacity
    local smallFreq        = Config.smallBlobFrequency
    local smallThresh      = Config.smallBlobThreshold
    local smallIntensity   = Config.smallBlobIntensity
    local opacityMult      = areaData.opacityMultiplier or 1.0
    local colorR, colorG, colorB = dirtColor[1], dirtColor[2], dirtColor[3]
    local microNoise       = Config.microNoiseStrength or 0.06
    local edgePxRadius     = math.ceil(edgeFadeout / effectiveSize * 2)

    -- Noise seed offsets (only the ones actually used below)
    local seedBase     = areaIdHash + 9999
    local seedA        = areaIdHash * 0.001
    local seedB        = areaIdHash * 0.002
    local seedG        = areaIdHash * 0.007
    local seedH        = areaIdHash * 0.008

    -- Per-pixel extra opacity cache for this area
    local pixelExtraGrid = {}
    extraOpacityCache[areaData.id] = pixelExtraGrid

    -- Pixel-writing loop
    Debug("Setting pixels...")
    local writeCount = 0
    local yieldEvery = 1500

    for x = 1, finalW do
        local colGrid     = upscaledGrid[x]
        local colExtra    = nil   -- populated for edge pixels
        local edgesFromLeft  = x - 1
        local edgesFromRight = finalW - x

        -- (no per-column precomputation needed)

        pixelExtraGrid[x] = {}

        for y = 1, finalH do
            local dirtLevel = (colGrid and colGrid[y]) or 3
            local extraBlob = 0

            -- Look up rendered opacity from dirt level
            local baseOpacity = InterpolateOpacity(dirtLevel, opacityTable)

            -- Blob noise: Perlin 2D octave noise para manchas orgánicas sin bandas
            -- Los senos 1D anteriores (sin(x)+sin(y)+sin(x*0.7+y*1.1)+...) siempre producen
            -- bandas paralelas (horizontales, verticales o diagonales). Perlin 2D es isotrópico.
            local blobSum     = Perlin.octaveNoise(x * blobFreq + seedA, y * blobFreq + seedB, 3, 0.55)
            local blobRange   = blobMax - blobMin
            local blobOpacity = baseOpacity * (blobMin + blobSum * blobRange)

            -- Small blob detail layer (Perlin 2D, también sin bandas)
            local smallNoise = Perlin.noise(x * smallFreq + seedG, y * smallFreq + seedH)
            if smallNoise > smallThresh then
                local t     = ((smallNoise - smallThresh) / (1.0 - smallThresh)) ^ 2
                blobOpacity = blobOpacity * (1.0 + (smallNoise - 0.5) * smallIntensity * t)
            end

            -- Edge detection: set fade = 0 at border pixels, else compute full edge fade
            local edgeFade
            if x == 1 or x == finalW or y == 1 or y == finalH then
                edgeFade = 0
                extraBlob = 0
            else
                local edgesFromTop    = y - 1
                local edgesFromBottom = finalH - y
                local minEdge = math.min(edgesFromLeft, edgesFromRight, edgesFromTop, edgesFromBottom)
                if edgePxRadius < minEdge then
                    edgeFade = 1.0
                else
                    edgeFade = ComputeEdgeFade(x, y, finalW, finalH, edgeFadeout, areaIdHash, effectiveSize)
                end

                -- Micro-noise for surface texture variation
                local microHash = IntHash(x, y, seedBase)
                local microMult = 1 + microHash * microNoise

                -- Final alpha: blob opacity × edge × opacity multiplier × micro-noise
                local alpha = math.floor(blobOpacity * edgeFade * opacityMult * microMult)
                if alpha > 240 then alpha = 240 end
                extraBlob = alpha
            end

            pixelExtraGrid[x][y] = edgeFade

            -- Clamp alpha: skip near-zero (< 5) to avoid dirty transparent pixels
            local alpha = extraBlob
            if alpha > 0 and alpha < 5 then alpha = 5 end

            SetRuntimeTexturePixel(rtTexture, x - 1, y - 1, colorR, colorG, colorB, alpha)

            writeCount = writeCount + 1
            if writeCount >= yieldEvery then
                writeCount = 0
                Wait(5)
            end
        end
    end

    Debug("Committing texture...")
    CommitRuntimeTexture(rtTexture)
    Debug("Texture created successfully: " .. textureName)

    return {
        runtime         = rtTexture,
        txd             = txd,
        txdName         = txdName,
        textureName     = textureName,
        upscaleFactor   = upscaleFactor,
        edgeFadeout     = edgeFadeout,
        dirtColor       = dirtColor,
        opacityMultiplier = opacityMult,
        targetPixelSize = effectiveSize,
    }
end

-- ============================================================
-- Incremental pixel update (partial repaint)
-- ============================================================

-- Euclidean distance between two vector3/coord tables
local function Vec3Dist(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local dz = a.z - b.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Repaint only the pixels in `changedList` (and their immediate neighbours)
-- on the already-created runtime texture for `areaId`.
local function UpdateChangedPixels(areaId, changedList, currentGrid, gridW, gridH)
    local handle = textureHandles[areaId]
    if not handle then return end

    local upscaleFactor  = handle.upscaleFactor
    local dirtColor      = handle.dirtColor or defaultDirtColor
    local areaIdHash     = HashString(areaId)
    local invScale       = 1.0 / upscaleFactor
    local opacityTable   = GetOpacityTable()

    local blendDistort = Config.blendDistortionStrength  or 0.4
    local transNoise   = Config.transitionNoiseStrength  or 0.2
    local borderNoise  = Config.dirtyBorderNoiseStrength or 0.3
    local borderExtra  = Config.dirtyBorderExtraOpacity  or 0.12
    local microNoise   = Config.microNoiseStrength        or 0.06

    local seedBase = areaIdHash + 9999
    local blobFreq = Config.dirtBlobFrequency
    local blobMin  = Config.dirtBlobMinOpacity
    local blobMax  = Config.dirtBlobMaxOpacity
    local smallFreq   = Config.smallBlobFrequency
    local smallThresh = Config.smallBlobThreshold
    local smallIntens = Config.smallBlobIntensity
    local opacityMult = handle.opacityMultiplier or 1.0
    local colorR, colorG, colorB = dirtColor[1], dirtColor[2], dirtColor[3]

    -- Expand changed pixels to include neighbours (avoids seams at boundaries)
    local toRepaint = {}
    for _, pixel in ipairs(changedList) do
        for dx = -1, 1 do
            for dy = -1, 1 do
                local px = pixel.x + dx
                local py = pixel.y + dy
                if px >= 1 and px <= gridW and py >= 1 and py <= gridH then
                    local key = px .. "_" .. py
                    toRepaint[key] = { x = px, y = py }
                end
            end
        end
    end

    local extraGrid = extraOpacityCache[areaId]

    for _, pixel in pairs(toRepaint) do
        local srcX = pixel.x
        local srcY = pixel.y

        -- Repaint all upscale sub-pixels for this grid pixel
        for subX = 0, upscaleFactor - 1 do
            for subY = 0, upscaleFactor - 1 do
                local texX = (srcX - 1) * upscaleFactor + subX + 1
                local texY = (srcY - 1) * upscaleFactor + subY + 1

                local scaledX = (texX - 1) * invScale + 1
                local scaledY = (texY - 1) * invScale + 1

                local opacity, extraBlob = SampleOpacityBilinear(
                    scaledX, scaledY, currentGrid, gridW, gridH, invScale, areaIdHash,
                    blendDistort, transNoise, borderNoise, borderExtra, nil, texX, texY
                )

                local baseOpacity = InterpolateOpacity(opacity, opacityTable)

                -- Blob noise (Perlin 2D — idéntico a CreateWashTexture para consistencia)
                local blobSum     = Perlin.octaveNoise(texX * blobFreq + areaIdHash * 0.001, texY * blobFreq + areaIdHash * 0.002, 3, 0.55)
                local blobOpacity = baseOpacity * (blobMin + blobSum * (blobMax - blobMin))

                -- Small blob detail (Perlin 2D)
                local smallNoise = Perlin.noise(texX * smallFreq + areaIdHash * 0.007, texY * smallFreq + areaIdHash * 0.008)
                if smallNoise > smallThresh then
                    local t     = ((smallNoise - smallThresh) / (1.0 - smallThresh)) ^ 2
                    blobOpacity = blobOpacity * (1.0 + (smallNoise - 0.5) * smallIntens * t)
                end

                -- Retrieve pre-computed edge fade
                local edgeFade = extraGrid and extraGrid[texX] and extraGrid[texX][texY] or 0

                -- Micro-noise
                local microHash = IntHash(texX, texY, seedBase) * microNoise
                local microMult = 1 + microHash

                local alpha = math.floor(blobOpacity * edgeFade * opacityMult * microMult * (1 + extraBlob))
                if alpha > 240 then alpha = 240 end
                if alpha > 0 and alpha < 5 then alpha = 5 end

                SetRuntimeTexturePixel(handle.runtime, texX - 1, texY - 1, colorR, colorG, colorB, alpha)
            end
        end
    end

    CommitRuntimeTexture(handle.runtime)
end

-- ============================================================
-- Apply local cleaning delta to the renderer
-- ============================================================

-- Applies `localDeltaMap` to the local opacity grid and updates changed pixels on the texture.
-- Returns a map of changed pixels per area (for server-delta accumulation).
function WashRenderer.ApplyLocalDelta(localDeltaMap)
    local changedPerArea = {}

    for areaId, deltaPixels in pairs(localDeltaMap) do
        -- Find area data in active list
        local areaData = nil
        for _, area in ipairs(activeWashAreas) do
            if area.id == areaId then
                areaData = area
                break
            end
        end
        if not areaData then goto continue end

        -- Ensure local grid exists
        if not localOpacityGrid[areaId] then
            local srcData = savedOpacityData[areaId] or areaData.opacityData
            localOpacityGrid[areaId] = UnpackOpacityData(srcData, areaData.gridWidth, areaData.gridHeight)
        end

        local grid     = localOpacityGrid[areaId]
        local changed  = {}
        changedPerArea[areaId] = {}

        for _, pixel in pairs(deltaPixels) do
            local x, y, amount = pixel.x, pixel.y, pixel.amount
            if x >= 1 and x <= areaData.gridWidth and y >= 1 and y <= areaData.gridHeight then
                local current    = (grid[x] and grid[x][y]) or 3
                local oldClamped = math.floor(math.min(3, math.max(0, current)))
                -- Acumular el amount float en el pixel y luego redondear hacia abajo.
                -- Guardamos el resultado como entero para que el servidor y el cliente
                -- siempre estén de acuerdo en qué nivel (0-3) tiene cada pixel.
                local newVal     = math.floor(math.min(3, math.max(0, current - amount)))

                if not grid[x] then grid[x] = {} end
                grid[x][y] = newVal

                local newClamped = newVal

                if oldClamped ~= newClamped then
                    local key = x .. "_" .. y
                    changedPerArea[areaId][key] = { x = x, y = y, amount = oldClamped - newClamped }
                    table.insert(changed, { x = x, y = y })
                end
            end
        end

        -- Rebuild packed binary and update the texture if pixels changed
        if #changed > 0 then
            local packed = PackOpacityGrid(grid, areaData.gridWidth, areaData.gridHeight)
            savedOpacityData[areaId] = packed

            UpdateChangedPixels(areaId, changed, grid, areaData.gridWidth, areaData.gridHeight)
        end

        ::continue::
    end

    return changedPerArea
end

-- ============================================================
-- Server state update (full texture refresh)
-- ============================================================

-- Sync a server-authoritative wash area state into the client texture.
-- Merges server opacity with any local cleaning not yet acknowledged.
local function UpdateTextureFromServer(existingHandle, serverArea)
    -- Skip if the server sent the same opacity data we already have
    if savedOpacityData[serverArea.id] == serverArea.opacityData then return end

    Debug(string.format("[UpdateTexturePixels] Server state update for %s", serverArea.id))

    -- Decode server data
    local serverGrid = UnpackOpacityData(serverArea.opacityData, serverArea.gridWidth, serverArea.gridHeight)

    -- Merge: for each pixel take the minimum (most cleaned) of server and local
    local localGrid = localOpacityGrid[serverArea.id]
    local mergedGrid = {}
    for x = 1, serverArea.gridWidth do
        mergedGrid[x] = {}
        for y = 1, serverArea.gridHeight do
            local sv = (serverGrid[x] and serverGrid[x][y]) or 3
            local lv = (localGrid and localGrid[x] and localGrid[x][y]) or 3
            mergedGrid[x][y] = math.floor(math.min(3, math.max(0, math.min(sv, lv))))
        end
    end

    -- Detect which pixels actually changed vs what was previously rendered
    local prevRendered = serverOpacityGrid[serverArea.id]
    local changedPixels = GetChangedPixels(prevRendered, mergedGrid, serverArea.gridWidth, serverArea.gridHeight)

    -- Save new state
    -- IMPORTANTE: guardamos el packed del mergedGrid (no el raw del servidor).
    -- Si guardáramos serverArea.opacityData, la próxima vez que el servidor
    -- mande el mismo payload la comparación sería true y se saltaría el update,
    -- dejando pixeles locales sin sincronizar con la textura.
    serverOpacityGrid[serverArea.id] = mergedGrid
    localOpacityGrid[serverArea.id]  = mergedGrid
    savedOpacityData[serverArea.id]  = PackOpacityGrid(mergedGrid, serverArea.gridWidth, serverArea.gridHeight)

    if #changedPixels > 0 then
        Debug(string.format("[UpdateTexturePixels] Updating %d changed pixels", #changedPixels))
        UpdateChangedPixels(serverArea.id, changedPixels, mergedGrid, serverArea.gridWidth, serverArea.gridHeight)
    end

    if Config.debug then
        local total = serverArea.gridWidth * serverArea.gridHeight * 3
        local serverClean, localClean, mergedClean = 0, 0, 0
        for x = 1, serverArea.gridWidth do
            for y = 1, serverArea.gridHeight do
                serverClean = serverClean + (3 - ((serverGrid[x] and serverGrid[x][y]) or 3))
                localClean  = localClean  + (3 - ((localGrid and localGrid[x] and localGrid[x][y]) or 3))
                mergedClean = mergedClean + (3 - mergedGrid[x][y])
            end
        end
        Debug(string.format("[UpdateTexturePixels] Server: %.1f%%, Local: %.1f%%, Merged: %.1f%%",
            serverClean / total * 100, localClean / total * 100, mergedClean / total * 100))
    end
end

-- ============================================================
-- Wash area update handler
-- ============================================================

-- Process a received list of wash areas: create/update textures and clean up stale ones.
local function OnWashAreasUpdate(newAreas)
    Debug("[washRenderer] Received wash areas update")
    Debug("[washRenderer] Value type: " .. type(newAreas))
    if newAreas then
        Debug("[washRenderer] Received " .. #newAreas .. " WashAreas")
    end

    local areas = newAreas or {}

    -- Build per-task cleanliness stats and process each area
    local taskStats = {}

    for idx, area in ipairs(areas) do
        local existingHandle = textureHandles[area.id]

        if existingHandle then
            Debug(string.format("[washRenderer] Updating existing texture for WashArea: %s", area.id))
            UpdateTextureFromServer(existingHandle, area)
        else
            Debug(string.format("[washRenderer] Creating new texture for WashArea %d: %s (grid: %dx%d)",
                idx, area.id, area.gridWidth, area.gridHeight))

            local capturedArea = area
            CreateThread(function()
                local handle = CreateWashTexture(capturedArea)
                textureHandles[capturedArea.id] = handle
                savedOpacityData[capturedArea.id]  = savedOpacityData[capturedArea.id] or capturedArea.opacityData

                local serverGrid = UnpackOpacityData(capturedArea.opacityData, capturedArea.gridWidth, capturedArea.gridHeight)
                serverOpacityGrid[capturedArea.id] = serverGrid
                if not localOpacityGrid[capturedArea.id] then
                    localOpacityGrid[capturedArea.id] = serverGrid
                else
                    -- The texture was just created from the original server data (all dirty),
                    -- but the local grid may already have cleaned pixels from spraying during
                    -- the texture creation window. Find those pixels and repaint them now.
                    local localGrid = localOpacityGrid[capturedArea.id]
                    local stalePixels = GetChangedPixels(serverGrid, localGrid, capturedArea.gridWidth, capturedArea.gridHeight)
                    if #stalePixels > 0 then
                        UpdateChangedPixels(capturedArea.id, stalePixels, localGrid, capturedArea.gridWidth, capturedArea.gridHeight)
                    end
                end

                Debug(string.format("[washRenderer] Texture created: %s/%s", handle.txdName, handle.textureName))
            end)
        end

        -- Accumulate cleanliness per task for the subtext display
        if area then
            local taskId = area.taskId
            if not taskStats[taskId] then
                taskStats[taskId] = { total = 0, clean = 0 }
            end
            taskStats[taskId].total = taskStats[taskId].total + (area.totalPixels or 0)
            taskStats[taskId].clean = taskStats[taskId].clean + (area.cleanPixels or 0)
            -- Usamos math.ceil para que 99.47% muestre 100% en lugar de 99%.
            -- cleanPixels es la suma de fracciones (opacity reducida), por lo que
            -- un area completamente limpia puede dar 99.x% con math.floor.
            local pct = taskStats[taskId].total > 0
                and math.min(100, math.ceil(taskStats[taskId].clean / taskStats[taskId].total * 100))
                or 0
            taskStats[taskId].percentage = pct
        end
    end

    -- Build subtext strings per task and show hint when a task is nearly done
    local subtexts = {}
    for taskId, stats in pairs(taskStats) do
        subtexts[taskId] = stats.percentage .. "%"
        if stats.percentage > 75 then
            HintAtWasherVision()
        end
    end
    TriggerEvent("kq_jobcontracts:client:setTasksSubtext", subtexts)

    -- Remove textures for areas that are no longer active
    local activeIds = {}
    for id in pairs(textureHandles) do activeIds[id] = true end
    for _, area in ipairs(areas) do activeIds[area.id] = nil end

    for removedId in pairs(activeIds) do
        Debug(string.format("[washRenderer] Removing texture for WashArea: %s (no longer active)", removedId))
        RemoveAreaCache(removedId)
    end

    activeWashAreas = areas

    if #areas == 0 then
        ClearAllCaches()
    end
end

-- Network event: server pushes wash areas via latent event
RegisterNetEvent("kq_powerwashing:client:washAreasUpdate", function(areas)
    Debug("[washRenderer] Latent event received")
    OnWashAreasUpdate(areas)
end)

-- State bag: server pushes wash areas via player state bag
local myPlayerBag = string.format("player:%s", GetPlayerServerId(PlayerId()))
AddStateBagChangeHandler("kq_powerwashing_washAreas", myPlayerBag, function(_, _, newAreas)
    Debug("[washRenderer] StateBag changed!")
    OnWashAreasUpdate(newAreas)
end)

-- Export ApplyLocalDelta so washCleaner can call it
WashRenderer = {
    ApplyLocalDelta = WashRenderer.ApplyLocalDelta,
}

-- ============================================================
-- Render loop
-- ============================================================

local isRenderActive = false

CreateThread(function()
    while true do
        Wait(0)

        if #activeWashAreas == 0 then
            if isRenderActive then
                Debug("[washRenderer] No active wash areas, pausing render loop")
                isRenderActive = false
            end
            Wait(1000)
        else
            if not isRenderActive then
                Debug("[washRenderer] Starting render loop for " .. #activeWashAreas .. " areas")
                isRenderActive = true
            end

            local playerPos = GetEntityCoords(PlayerPedId())

            for _, area in ipairs(activeWashAreas) do
                -- Compute area centre from corners
                local cx = (area.corners[1].x + area.corners[2].x + area.corners[3].x + area.corners[4].x) / 4
                local cy = (area.corners[1].y + area.corners[2].y + area.corners[3].y + area.corners[4].y) / 4
                local cz = (area.corners[1].z + area.corners[2].z + area.corners[3].z + area.corners[4].z) / 4
                local center = vector3(cx, cy, cz)

                local dist      = Vec3Dist(playerPos, center)
                local drawDist  = GetDrawDistance()

                if dist < drawDist then
                    local handle = textureHandles[area.id]
                    if handle then
                        local c1, c2, c3, c4 = area.corners[1], area.corners[2], area.corners[3], area.corners[4]

                        -- Draw dirt texture as two triangles covering the quad.
                        -- Corner winding order from server: c1=BL, c2=TL, c3=TR, c4=BR
                        -- UV values and trailing params restored to original bytecode values.
                        DrawTexturedPoly(
                            c1.x, c1.y, c1.z,
                            c2.x, c2.y, c2.z,
                            c3.x, c3.y, c3.z,
                            255, 255, 255, 255,
                            handle.txdName, handle.textureName,
                            0.0, 0.0,  0.0, 1.0,  0.0, 0.0,  1.0, 1.0, 0.0
                        )
                        DrawTexturedPoly(
                            c1.x, c1.y, c1.z,
                            c3.x, c3.y, c3.z,
                            c4.x, c4.y, c4.z,
                            255, 255, 255, 255,
                            handle.txdName, handle.textureName,
                            0.0, 0.0,  0.0, 1.0,  1.0, 0.0,  0.0, 1.0, 0.0
                        )

                        -- Dirt-highlight overlay (washer vision pulse)
                        if Renderer.extraLayerOpacity > 0 then
                            local alpha = Renderer.extraLayerOpacity

                            -- Magenta tint (dirt present)
                            DrawTexturedPoly(
                                c1.x, c1.y, c1.z,
                                c2.x, c2.y, c2.z,
                                c3.x, c3.y, c3.z,
                                255, 0, 255, alpha,
                                handle.txdName, handle.textureName,
                                0.0, 0.0,  0.0, 1.0,  0.0, 0.0,  1.0, 1.0, 0.0
                            )
                            DrawTexturedPoly(
                                c1.x, c1.y, c1.z,
                                c3.x, c3.y, c3.z,
                                c4.x, c4.y, c4.z,
                                255, 0, 255, alpha,
                                handle.txdName, handle.textureName,
                                0.0, 0.0,  0.0, 1.0,  1.0, 0.0,  0.0, 1.0, 0.0
                            )

                            -- Blue tint (clean / highlight overlay)
                            DrawTexturedPoly(
                                c1.x, c1.y, c1.z,
                                c2.x, c2.y, c2.z,
                                c3.x, c3.y, c3.z,
                                0, 100, 255, alpha,
                                handle.txdName, handle.textureName,
                                0.0, 0.0,  0.0, 1.0,  0.0, 0.0,  1.0, 1.0, 0.0
                            )
                            DrawTexturedPoly(
                                c1.x, c1.y, c1.z,
                                c3.x, c3.y, c3.z,
                                c4.x, c4.y, c4.z,
                                0, 100, 255, alpha,
                                handle.txdName, handle.textureName,
                                0.0, 0.0,  0.0, 1.0,  1.0, 0.0,  0.0, 1.0, 0.0
                            )
                        end
                    end
                end
            end
        end
    end
end)