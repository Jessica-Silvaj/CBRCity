function CalculateLevelFromXp(totalXp)
    local baseXp = Config.xp.baseXp
    local multiplier = Config.xp.multiplier

    local level = 1
    local xpAccumulated = 0

    while true do
        local xpForNextLevel = math.min(Config.xp.maxXpPerLevel, math.floor(baseXp * (multiplier ^ (level - 1))))
        if xpAccumulated + xpForNextLevel > totalXp then
            local xpIntoLevel = totalXp - xpAccumulated
            local progress = xpForNextLevel > 0 and (xpIntoLevel / xpForNextLevel) or 0
            return {
                level = level,
                xp = totalXp,
                xpIntoLevel = xpIntoLevel,
                xpForNextLevel = xpForNextLevel,
                progress = progress,
            }
        end
        xpAccumulated = xpAccumulated + xpForNextLevel
        level = level + 1
    end
end

function GetTotalXpForLevel(targetLevel)
    local baseXp = Config.xp.baseXp
    local multiplier = Config.xp.multiplier
    local total = 0
    for lvl = 0, targetLevel - 1 do
        total = total + math.floor(baseXp * (multiplier ^ lvl))
    end
    return total
end
