-- Server-side task type handlers for kq_powerwashing

-- "enter_vehicle": always considered finished server-side (client drives this)
exports.kq_jobcontracts:RegisterTaskType("enter_vehicle", {
    isFinished = function()
        return true
    end,
})

-- "go_to_area": finished when the player's ped is within 100m of the target coords
exports.kq_jobcontracts:RegisterTaskType("go_to_area", {
    isFinished = function(task, identifier, serverId)
        if not serverId then return false end

        local ped = GetPlayerPed(serverId)
        if not ped or ped == 0 then return false end

        local playerPos = GetEntityCoords(ped)
        local target    = task.vars.coords
        if not target then return false end

        return IsWithinDistance(playerPos, target, 100)
    end,
})

-- "wash_area": server checks WashManager; triggers FinishTask when fully clean
exports.kq_jobcontracts:RegisterTaskType("wash_area", {
    onStart = function(task)
        if WashManager:IsTaskFullyClean(task.id) then
            exports.kq_jobcontracts:FinishTask(task.id)
        end
    end,
})

-- "finish_at_npc": finished when the player is within 5m of the HQ NPC
exports.kq_jobcontracts:RegisterTaskType("finish_at_npc", {
    isFinished = function(task, identifier, serverId)
        if not serverId then return false end

        local ped = GetPlayerPed(serverId)
        if not ped or ped == 0 then return false end

        local playerPos = GetEntityCoords(ped)
        local npcCoords = Config.headquarters.npc.coords
        return IsWithinDistance(playerPos, vec3(npcCoords.x, npcCoords.y, npcCoords.z), 5.0)
    end,
})

Debug("Server task types registered")