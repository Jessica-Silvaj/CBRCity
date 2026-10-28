-- Cache store: key -> { data, maxAge }
local cacheStore = {}

-- Save a value to the cache with an optional TTL (default 3000ms)
function SaveCache(key, data, ttl)
    local entry = {}
    entry.data = data
    local expireAt = GetGameTimer() + (ttl or 3000)
    entry.maxAge = expireAt
    cacheStore[key] = entry
end

-- Remove a single cache entry by key
function WipeCache(key)
    cacheStore[key] = nil
end

-- Remove all cache entries
function WipeAllCache()
    for key in pairs(cacheStore) do
        cacheStore[key] = nil
    end
end

-- Remove all expired entries and return how many were removed
function CleanExpiredCache()
    local now = GetGameTimer()
    local removed = 0
    for key, entry in pairs(cacheStore) do
        if now > entry.maxAge then
            cacheStore[key] = nil
            removed = removed + 1
        end
    end
    return removed
end

-- Return cached value if still valid; otherwise call fetchFn, cache the result, and return it
function UseCache(key, fetchFn, ttl)
    local entry = cacheStore[key]
    local isCacheValid = entry and not (GetGameTimer() > entry.maxAge)

    if not isCacheValid then
        -- Cache miss or expired: fetch fresh data
        local results = { fetchFn() }
        SaveCache(key, results, ttl)
        return table.unpack(results)
    end

    -- Cache hit: return stored data
    return table.unpack(cacheStore[key].data)
end

-- Periodically clean expired cache entries (client-side only)
if not IsDuplicityVersion() then
    CreateThread(function()
        while true do
            Citizen.Wait(45000)
            CleanExpiredCache()
        end
    end)
end
