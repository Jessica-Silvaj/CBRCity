-- Tracks which wash areas are near the player and syncs proximity to the server

local nearbyAreaIds   = {}
local checkInterval   = 1000   -- ms between proximity checks
local drawDistNormal  = 35.0   -- draw distance when no blips are active
local drawDistBlips   = 80.0   -- draw distance when blips are active


-- Returns the effective draw distance, cached for 2 seconds
local function GetDrawDistance()
    return UseCache("GetDrawDistance_proximity", function()
        if WASH_BLIPS_ACTIVE > 0 then
            return drawDistBlips
        end
        return drawDistNormal
    end, 2000)
end

-- Main proximity loop: every checkInterval ms, find all wash areas within draw distance
-- and notify the server if the nearby set has changed
CreateThread(function()
    while true do
        Wait(checkInterval)

        local allAreas   = GlobalState.washAreas or {}
        local playerPos  = GetEntityCoords(PlayerPedId())
        local foundIds   = {}
        local drawDist   = GetDrawDistance()

        -- Collect IDs of areas within draw distance
        for _, area in ipairs(allAreas) do
            local dist = #(playerPos - area.center)
            if drawDist > dist then
                table.insert(foundIds, area.id)
            end
        end

        -- Only update the server when the nearby set actually changed
        if not table.compare(nearbyAreaIds, foundIds) then
            Debug(string.format(
                "GlobalState has %d total areas, %d nearby (drawDist=%.1f)",
                #allAreas, #foundIds, drawDist
            ))

            -- Debug: log each area's distance and whether it qualifies as nearby
            for _, area in ipairs(allAreas) do
                local dist   = #(playerPos - area.center)
                local nearby = drawDist > dist and "YES" or "NO"
                Debug(string.format(
                    "Area %s: center=(%.1f,%.1f,%.1f), dist=%.1f, nearby=%s",
                    area.id, area.center.x, area.center.y, area.center.z, dist, nearby
                ))
            end

            nearbyAreaIds = foundIds
            TriggerServerEvent("kq_powerwashing:server:updateProximity", foundIds)
        end
    end
end)