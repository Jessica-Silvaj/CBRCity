-- table.contains: returns true if the array tbl contains value
function table.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

-- table.clone: deep-clones a table, converting vector-like tables to vector2/3/4
function table.clone(original)
    local seen = {}  -- tracks already-cloned tables to handle circular refs

    local function cloneValue(val)
        if type(val) ~= "table" then
            return val
        end

        -- Return already-cloned reference to avoid infinite loops
        if seen[val] then
            return seen[val]
        end

        -- Detect vector tables by checking x/y numeric fields
        if val.x and val.y and type(val.x) == "number" and type(val.y) == "number" then
            local fieldCount = 0
            for _ in pairs(val) do fieldCount = fieldCount + 1 end

            if fieldCount == 2 then
                return vector2(val.x, val.y)
            elseif fieldCount == 3 and val.z and type(val.z) == "number" then
                return vector3(val.x, val.y, val.z)
            elseif fieldCount == 4 and val.z and val.w and type(val.z) == "number" and type(val.w) == "number" then
                return vector4(val.x, val.y, val.z, val.w)
            end
        end

        -- Deep clone the table
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

-- table.mapValues: maps over all values of a table, returning a flat array
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
        if fn(v, k, tbl) then
            result[k] = v
        end
    end
    return result
end

-- table.length: counts all keys in a table (including non-integer keys)
function table.length(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- table.merge: deep-merges multiple tables into one, handling both arrays and dicts
function table.merge(...)
    -- Checks whether a table is a pure array (sequential integer keys)
    local function isArray(t)
        if type(t) ~= "table" then return false end
        local count = 0
        for _ in pairs(t) do count = count + 1 end
        for i = 1, count do
            if t[i] == nil then return false end
        end
        return true
    end

    -- Deep-clones a value (tables only, scalars returned as-is)
    local function deepClone(val)
        if type(val) ~= "table" then return val end
        local copy = {}
        for k, v in pairs(val) do
            copy[deepClone(k)] = deepClone(v)
        end
        return copy
    end

    -- Recursively merge src into dst
    local function mergeInto(dst, src)
        if isArray(dst) and isArray(src) then
            -- Array: append cloned items
            for i = 1, #src do
                dst[#dst + 1] = deepClone(src[i])
            end
        else
            -- Dict: deep-merge each key
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
        if type(arg) == "table" then
            mergeInto(result, arg)
        end
    end
    return result
end

-- math.round: rounds a number to `decimals` decimal places (default 0)
function math.round(value, decimals)
    if not decimals then decimals = 0 end
    local factor = 10 ^ decimals
    local shifted = value * factor
    local frac = shifted % 1
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
    local fmt = string.format
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

-- Capitalize: title-cases every word in a string
function Capitalize(str)
    return str:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
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

-- IsWithinDistance: returns true if two positions are within `radius` of each other (supports 2D/3D)
function IsWithinDistance(posA, posB, radius)
    local dx = posA.x - posB.x
    local dy = posA.y - posB.y
    local dz = (posA.z or 0.0) - (posB.z or 0.0)
    local distSq = dx * dx + dy * dy + dz * dz
    return distSq <= radius * radius
end
