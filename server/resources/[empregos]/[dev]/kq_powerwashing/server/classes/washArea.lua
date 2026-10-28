-- WashArea class: represents a single cleanable surface on the server.
-- Stores the opacity grid, encodes it as packed binary data, and exposes
-- methods for applying cleaning deltas, querying cleanliness, and serialising.

WashArea          = {}
WashArea.__index  = WashArea


-- Grid resolution settings (may be overridden by shared.lua quality presets)
local networkPixelSize    = Config.networkPixelSize    or 0.13
local networkMaxResolution = Config.networkMaxResolution or 4096


-- ============================================================
-- Internal helpers
-- ============================================================

-- Compute the average position of 4 quad corners
local function ComputeQuadCenter(corners)
    local sumX = corners[1].x + corners[2].x + corners[3].x + corners[4].x
    local sumY = corners[1].y + corners[2].y + corners[3].y + corners[4].y
    local sumZ = corners[1].z + corners[2].z + corners[3].z + corners[4].z
    return vector3(sumX/4, sumY/4, sumZ/4)
end

-- Allocate a fully-dirty (opacity = 3) packed binary string for a W×H grid.
-- Each pixel uses 2 bits; 4 pixels are packed per byte.
local function CreateFullOpacityData(gridWidth, gridHeight)
    local totalPixels  = gridWidth * gridHeight
    local totalBytes   = math.ceil(totalPixels / 4)
    local bytes        = {}
    for i = 1, totalBytes do
        bytes[i] = string.char(255)
    end
    return table.concat(bytes)
end

-- Clamp a raw opacity value to the valid range [0, 3]
local function ClampOpacity(value)
    return math.floor(math.min(3, math.max(0, value)))
end

-- ============================================================
-- Constructor
-- ============================================================

-- WashArea.new: create a new WashArea instance.
--   contractId         - owning contract ID
--   taskId             - owning task ID
--   corners            - table of 4 vector3 world positions (quad corners)
--   edgeFadeout        - bool, whether to fade edges
--   dirtColor          - {r, g, b} table (default {30, 26, 22})
--   cleaningMultiplier - cleaning speed multiplier (default 1.0)
--   flipped            - bool, flip corner winding order (default false)
--   opacityMultiplier  - overall opacity multiplier (default 1.0)
--   completionThreshold - % clean required for completion (default 93)
--   playerIdentifiers  - optional player identifier table
function WashArea.new(contractId, taskId, corners, edgeFadeout, dirtColor, cleaningMultiplier, flipped, opacityMultiplier, completionThreshold, playerIdentifiers)
    -- Validate corners
    if not (corners and type(corners) == "table" and #corners == 4) then
        print("[WashArea] ERROR: Invalid corners passed to WashArea.new!")
        print("[WashArea] contractId: " .. tostring(contractId))
        print("[WashArea] taskId: " .. tostring(taskId))
        print("[WashArea] corners type: " .. type(corners))
        if corners then
            print("[WashArea] corners count: " .. #corners)
        end
        return nil, "Invalid corners"
    end

    local self = setmetatable({}, WashArea)

    self.id                  = GenerateUuid()
    self.contractId          = contractId
    self.taskId              = taskId

    -- Optionally flip corner winding order
    if flipped then
        self.corners = { corners[1], corners[4], corners[3], corners[2] }
    else
        self.corners = corners
    end

    self.center              = ComputeQuadCenter(self.corners)
    self.edgeFadeout         = edgeFadeout
    self.dirtColor           = dirtColor      or { 30, 26, 22 }
    self.cleaningMultiplier  = cleaningMultiplier or 1.0
    self.flipped             = flipped        or false
    self.opacityMultiplier   = opacityMultiplier  or 1.0
    self.completionThreshold = completionThreshold or 100
    self.playerIdentifiers   = playerIdentifiers

    -- Compute physical dimensions (metres) from corner distances
    local widthA  = #(self.corners[1] - self.corners[2])
    local widthB  = #(self.corners[3] - self.corners[4])
    local heightA = #(self.corners[1] - self.corners[4])
    local heightB = #(self.corners[2] - self.corners[3])

    self.width  = math.max(widthA,  widthB)
    self.height = math.max(heightA, heightB)

    -- Derive grid dimensions from physical size and pixel size
    self.gridWidth  = math.ceil(self.width  / networkPixelSize)
    self.gridHeight = math.ceil(self.height / networkPixelSize)

    -- Scale down if the grid exceeds the max resolution budget
    local totalPixels = self.gridWidth * self.gridHeight
    if totalPixels > networkMaxResolution then
        local scale         = math.sqrt(networkMaxResolution / totalPixels)
        self.gridWidth      = math.floor(self.gridWidth  * scale)
        self.gridHeight     = math.floor(self.gridHeight * scale)
    end

    -- Actual pixel dimensions in world space
    self.actualPixelWidth  = self.width  / self.gridWidth
    self.actualPixelHeight = self.height / self.gridHeight
    self.actualPixelSize   = math.max(self.actualPixelWidth, self.actualPixelHeight)

    -- Initialise opacity grid: all pixels start dirty (opacity = 3)
    self.opacityGrid = {}
    for x = 1, self.gridWidth do
        self.opacityGrid[x] = {}
        for y = 1, self.gridHeight do
            self.opacityGrid[x][y] = 3
        end
    end

    -- Pack the initial grid into binary string
    self.opacityData = CreateFullOpacityData(self.gridWidth, self.gridHeight)

    return self
end

-- ============================================================
-- Methods
-- ============================================================

-- Apply a cleaning delta (table of pixel entries with x, y, amount fields).
-- Updates the opacityGrid and repacks opacityData.
-- Returns true if any pixel changed.
function WashArea:ApplyCleaningDelta(delta)
    local changed = false

    for _, pixel in pairs(delta) do
        local x, y, amount = pixel.x, pixel.y, pixel.amount

        if x >= 1 and x <= self.gridWidth and y >= 1 and y <= self.gridHeight then
            local current = self.opacityGrid[x][y]
            local newVal  = ClampOpacity(current - amount)

            if newVal ~= current then
                self.opacityGrid[x][y] = newVal
                changed = true
            end
        end
    end

    if changed then
        self:RepackOpacityData()
        -- Invalidar el cache de limpieza para que IsTaskFullyClean
        -- lea los valores reales y no los del ciclo anterior
        WipeCache("WashArea:GetCleanlinessPercentage" .. self.id)
    end

    return changed
end

-- Repack the opacityGrid into the compact binary opacityData string.
-- Each pixel is 2 bits (values 0–3); 4 pixels fit in one byte.
function WashArea:RepackOpacityData()
    local chunks  = {}
    local byte    = 0
    local bitPos  = 6   -- start at the most significant pair of bits

    for y = 1, self.gridHeight do
        for x = 1, self.gridWidth do
            local opacity = ClampOpacity(self.opacityGrid[x][y])
            byte    = byte | (opacity << bitPos)
            bitPos  = bitPos - 2

            if bitPos < 0 then
                table.insert(chunks, string.char(byte))
                byte   = 0
                bitPos = 6
            end
        end
    end

    -- Flush any remaining partial byte
    if bitPos < 6 then
        table.insert(chunks, string.char(byte))
    end

    self.opacityData = table.concat(chunks)
end

-- Returns (cleanPercentage, totalPixels, cleanPixels), cached for 500ms.
-- cleanPercentage is 0–100.
function WashArea:GetCleanlinessPercentage()
    return UseCache("WashArea:GetCleanlinessPercentage" .. self.id, function()
        local totalPixels = 0
        local cleanPixels = 0

        -- Los pixeles literalmente en el borde del quad (minEdgeDist = 0) nunca son
        -- alcanzables por el raycast y el cliente los renderiza invisibles via ComputeEdgeFade.
        -- Los excluimos del conteo para que no bloqueen el 100%.
        -- Solo excluimos minEdgeDist < 1 (borde exacto) para no reducir demasiado el area.
        for x = 1, self.gridWidth do
            for y = 1, self.gridHeight do
                local minEdgeDist = math.min(x - 1, y - 1, self.gridWidth - x, self.gridHeight - y)
                if minEdgeDist >= 1 then
                    totalPixels = totalPixels + 1
                    -- opacity 3 = fully dirty, 0 = clean; normalise to 0-1 clean fraction
                    cleanPixels = cleanPixels + (3 - self.opacityGrid[x][y]) / 3
                end
            end
        end

        if totalPixels == 0 then return 0 end

        local percentage = (cleanPixels / totalPixels) * 100
        return percentage, totalPixels, cleanPixels
    end, 500)
end

-- Returns a minimal table with just id, center, and taskId (for proximity checks)
function WashArea:GetLightweightData()
    return {
        id      = self.id,
        center  = self.center,
        taskId  = self.taskId,
    }
end

-- Returns the full serialisable table (sent to clients for rendering)
function WashArea:GetFullData()
    local pct, totalPixels, cleanPixels = self:GetCleanlinessPercentage()
    return {
        id                 = self.id,
        taskId             = self.taskId,
        contractId         = self.contractId,
        corners            = self.corners,
        gridWidth          = self.gridWidth,
        gridHeight         = self.gridHeight,
        pixelSize          = self.actualPixelSize,
        opacityData        = self.opacityData,
        edgeFadeout        = self.edgeFadeout,
        dirtColor          = self.dirtColor,
        cleaningMultiplier = self.cleaningMultiplier,
        flipped            = self.flipped,
        opacityMultiplier  = self.opacityMultiplier,
        cleanPercentage    = pct,
        totalPixels        = totalPixels,
        cleanPixels        = cleanPixels,
    }
end

-- Simple getters
function WashArea:GetTaskId()     return self.taskId     end
function WashArea:GetContractId() return self.contractId end