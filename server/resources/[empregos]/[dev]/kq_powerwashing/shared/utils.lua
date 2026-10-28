-- table.contains: returns true if the array tbl contains value
function table.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then return true end
    end
    return false
end

-- table.clone: deep-clones a table (handles circular references)
function table.clone(original)
    local seen = {}

    local function cloneValue(val)
        if type(val) ~= "table" then return val end
        if seen[val] then return seen[val] end

        local copy = {}
        seen[val] = copy
        for k, v in pairs(val) do
            copy[cloneValue(k)] = cloneValue(v)
        end
        return copy
    end

    return cloneValue(original)
end

-- table.valuesByOrder: returns values sorted by their .order field
function table.valuesByOrder(tbl)
    local ordered = {}
    for key, value in pairs(tbl) do
        if value.order then
            table.insert(ordered, { key = key, value = value, order = value.order })
        end
    end
    table.sort(ordered, function(a, b) return a.order < b.order end)

    local result = {}
    for _, item in ipairs(ordered) do
        table.insert(result, item.value)
    end
    return result
end

-- table.compare: returns true if two arrays contain the same values (order-independent)
function table.compare(a, b)
    if #a ~= #b then return false end
    local set = {}
    for _, v in ipairs(b) do set[v] = true end
    for _, v in ipairs(a) do
        if not set[v] then return false end
    end
    return true
end

-- table.values: returns all values of a table as an array
function table.values(tbl)
    local result = {}
    for _, v in pairs(tbl) do
        table.insert(result, v)
    end
    return result
end

-- table.map: maps over arrays (by index) or dictionaries (by key)
function table.map(tbl, fn)
    local result = {}
    if #tbl > 0 and tbl[1] ~= nil then
        -- Array
        for i = 1, #tbl do
            result[i] = fn(tbl[i], i, tbl)
        end
    else
        -- Dictionary
        for k, v in pairs(tbl) do
            result[k] = fn(v, k, tbl)
        end
    end
    return result
end

-- table.mapValues: maps over all values, returning a flat array
function table.mapValues(tbl, fn)
    local result = {}
    local i = 1
    for k, v in pairs(tbl) do
        result[i] = fn(v, k, tbl)
        i = i + 1
    end
    return result
end

-- table.filter: returns a dictionary of key/value pairs where fn returns truthy
function table.filter(tbl, fn)
    local result = {}
    for k, v in pairs(tbl) do
        if fn(v, k, tbl) then result[k] = v end
    end
    return result
end

-- table.length: counts all keys (including non-integer)
function table.length(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

-- table.count: alias for table.length
table.count = table.length

-- table.merge: deep-merges multiple tables into one (arrays appended, dicts recursed)
function table.merge(...)
    local function isArray(t)
        if type(t) ~= "table" then return false end
        local count = 0
        for _ in pairs(t) do count = count + 1 end
        for i = 1, count do
            if t[i] == nil then return false end
        end
        return true
    end

    local function deepClone(val)
        if type(val) ~= "table" then return val end
        local copy = {}
        for k, v in pairs(val) do copy[deepClone(k)] = deepClone(v) end
        return copy
    end

    local function mergeInto(dst, src)
        if isArray(dst) and isArray(src) then
            for i = 1, #src do
                dst[#dst + 1] = deepClone(src[i])
            end
        else
            for k, v in pairs(src) do
                if type(v) == "table" and type(dst[k]) == "table" then
                    mergeInto(dst[k], v)
                else
                    dst[k] = deepClone(v)
                end
            end
        end
    end

    local args = { ... }
    if #args == 0 then return {} end

    local result = deepClone(args[1])
    for i = 2, select("#", ...) do
        local arg = args[i]
        if type(arg) == "table" then mergeInto(result, arg) end
    end
    return result
end

-- math.round: rounds a number to `decimals` decimal places (default 0)
function math.round(value, decimals)
    decimals = decimals or 0
    local factor  = 10 ^ decimals
    local shifted = value * factor
    local frac    = shifted % 1
    if frac > 0.5 then
        return math.ceil(shifted) / factor
    else
        return math.floor(shifted) / factor
    end
end

-- math.roundNearest: rounds value to the nearest multiple of `multiple`
function math.roundNearest(value, multiple)
    return math.floor((value + multiple / 2) / multiple) * multiple
end

-- GenerateUuid: generates a random UUID v4 string
function GenerateUuid()
    local fmt     = string.format
    local pattern = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(pattern, "[xy]", function(c)
        local rand
        if c == "x" then
            rand = math.random(0, 15)
        else
            rand = math.random(8, 11)
        end
        return fmt("%x", rand)
    end)
end

-- Slugify: converts a string to a URL-friendly slug
function Slugify(str)
    str = str:lower()
    str = str:gsub("[^%w%s-]", "")
    str = str:gsub("%s+", "-")
    str = str:gsub("-+", "-")
    str = str:gsub("^-+", "")
    str = str:gsub("-+$", "")
    return str
end

-- Debug: prints only when Config.debug is true; accepts a function for lazy evaluation
function Debug(message, ...)
    if Config.debug then
        if type(message) == "function" then
            print(message(), ...)
        else
            print(message, ...)
        end
    end
end

-- IsWithinDistance: returns true if two positions are within `radius` of each other
function IsWithinDistance(posA, posB, radius)
    local dx = posA.x - posB.x
    local dy = posA.y - posB.y
    local dz = (posA.z or 0.0) - (posB.z or 0.0)
    return (dx * dx + dy * dy + dz * dz) <= (radius * radius)
end

-- ============================================================
-- 3D rotation / matrix math helpers
-- ============================================================

local function toRad(deg) return deg * math.pi / 180 end
local function toDeg(rad) return rad * 180 / math.pi end

-- Build a 3x3 rotation matrix from Euler angles (degrees, ZYX order)
local function eulerToMatrix(rot)
    local rx, ry, rz = toRad(rot.x), toRad(rot.y), toRad(rot.z)
    local cx, sx = math.cos(rx), math.sin(rx)
    local cy, sy = math.cos(ry), math.sin(ry)
    local cz, sz = math.cos(rz), math.sin(rz)

    return {
        { cy * cz,  -cx * sz + sx * sy * cz,  sx * sz + cx * sy * cz },
        { cy * sz,   cx * cz + sx * sy * sz,  -sx * cz + cx * sy * sz },
        {    -sy,           sy * sx,                  cy * cx          },
    }
end

-- Multiply two 3x3 matrices
local function matMul(a, b)
    local c = {}
    for i = 1, 3 do
        c[i] = {}
        for j = 1, 3 do
            c[i][j] = 0
            for k = 1, 3 do
                c[i][j] = c[i][j] + a[i][k] * b[k][j]
            end
        end
    end
    return c
end

-- Transform a vector3 by a 3x3 matrix
local function matVecMul(vec, mat)
    return {
        x = vec.x * mat[1][1] + vec.y * mat[1][2] + vec.z * mat[1][3],
        y = vec.x * mat[2][1] + vec.y * mat[2][2] + vec.z * mat[2][3],
        z = vec.x * mat[3][1] + vec.y * mat[3][2] + vec.z * mat[3][3],
    }
end

-- Extract Euler angles (degrees) from a 3x3 rotation matrix
local function matrixToEuler(mat)
    local len = math.sqrt(mat[1][1] * mat[1][1] + mat[2][1] * mat[2][1])
    local rx, ry, rz

    if len > 1e-6 then
        rx = math.atan2(mat[3][2], mat[3][3])
        ry = math.atan2(-mat[3][1], len)
        rz = math.atan2(mat[2][1], mat[1][1])
    else
        rx = math.atan2(-mat[2][3], mat[2][2])
        ry = math.atan2(-mat[3][1], len)
        rz = 0
    end

    return vector3(toDeg(rx), toDeg(ry), toDeg(rz))
end

-- ConvertOffsetToWorld: convert a local-space offset to world position + rotation
-- origin: world position, rotation: world Euler rotation, offset: local offset, offsetRot: local rotation
function ConvertOffsetToWorld(origin, rotation, offset, offsetRot)
    local worldMat    = eulerToMatrix(rotation)
    local offsetMat   = eulerToMatrix(offsetRot)
    local worldPos    = matVecMul(offset, worldMat)
    local combinedMat = matMul(worldMat, offsetMat)
    local combinedRot = matrixToEuler(combinedMat)

    return vector3(origin.x + worldPos.x, origin.y + worldPos.y, origin.z + worldPos.z), combinedRot
end

-- CombineRotations: combine two Euler rotations and return the result
function CombineRotations(rotA, rotB)
    local matA = eulerToMatrix(rotA)
    local matB = eulerToMatrix(rotB)
    return matrixToEuler(matMul(matA, matB))
end

-- GetOffsetFromWorldGivenWorldCoords: get the local-space offset of worldPoint
-- relative to an entity at origin with the given rotation
function GetOffsetFromWorldGivenWorldCoords(origin, rotation, worldPoint)
    local rot = vector3(math.rad(rotation.x), math.rad(rotation.y), math.rad(rotation.z))
    local sz, cz = math.sin(rot.z), math.cos(rot.z)
    local sy, cy = math.sin(rot.y), math.cos(rot.y)
    local sx, cx = math.sin(rot.x), math.cos(rot.x)

    -- Build inverse rotation matrix (transpose of rotation matrix)
    local mat = {
        { cz * cy,  cz * sy * sx - sz * cx,  cz * sy * cx + sz * sx },
        { sz * cy,  sz * sy * sx + cz * cx,  sz * sy * cx - cz * sx },
        {    -sy,          cy * sx,                  cy * cx         },
    }

    local dx = worldPoint.x - origin.x
    local dy = worldPoint.y - origin.y
    local dz = worldPoint.z - origin.z

    return vector3(
        mat[1][1] * dx + mat[2][1] * dy + mat[3][1] * dz,
        mat[1][2] * dx + mat[2][2] * dy + mat[3][2] * dz,
        mat[1][3] * dx + mat[2][3] * dy + mat[3][3] * dz
    )
end