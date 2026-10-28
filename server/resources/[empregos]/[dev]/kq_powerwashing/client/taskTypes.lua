-- Client-side task type handlers for kq_powerwashing
-- Registered with kq_jobcontracts so it can drive client-side lifecycle events

WASH_BLIPS_ACTIVE = 0       -- count of active wash-area/go-to blips on the map
CONTRACT_ACTIVE   = false   -- true while a contract is in progress

-- Helper: play the standard mission-pass sound
local function PlaySuccessSound()
    PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
end

-- ============================================================
-- Task type: "enter_vehicle"
-- Player must enter the assigned work vehicle to proceed.
-- ============================================================
exports.kq_jobcontracts:RegisterTaskType("enter_vehicle", {
    tickDelay = 1500,

    onStart = function(task, contract)
        CONTRACT_ACTIVE = true
        WaterTank:Refill()

        local netId = contract.vars.vehicleNetId
        Debug("vehicleNetId", netId)
        if not netId then return task end

        -- Verify the net object exists
        if not NetworkDoesNetworkIdExist(netId) or not NetworkDoesEntityExistWithNetworkId(netId) then
            Debug("Net ID does not exist")
            return task
        end

        -- Wait up to 5s for the vehicle to be available on this client
        local veh     = NetToVeh(netId)
        local attempts = 0
        while (not veh or veh == 0) and attempts < 50 do
            Debug("Waiting for vehicle to be available on client", netId)
            Wait(100)
            veh      = NetToVeh(netId)
            attempts = attempts + 1
        end

        if veh and veh ~= 0 then
            -- Add a blip with GPS route to the vehicle
            local blip = AddBlipForEntity(veh)
            SetBlipSprite(blip, 326)
            SetBlipColour(blip, 12)
            SetBlipRoute(blip, true)
            SetBlipRouteColour(blip, 12)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(L("blips.work_vehicle"))
            EndTextCommandSetBlipName(blip)

            task.data.blip         = blip
            task.data.vehicleNetId = netId
            task.data.finishing    = false

            -- Take network control so we can modify the vehicle
            if not NetworkHasControlOfEntity(veh) then
                NetworkRequestControlOfEntity(veh)
            end
        end

        return task
    end,

    onTick = function(task, contract)
        if task.data.finishing then
            Debug("Task already finishing")
            return
        end

        local netId = contract.vars.vehicleNetId
        if not netId then
            Debug("vehicleNetId not found.")
            return
        end

        if not NetworkDoesNetworkIdExist(netId) or not NetworkDoesEntityExistWithNetworkId(netId) then
            Debug("Net ID does not exist")
            return task
        end

        local veh = NetToVeh(netId)
        if not veh or veh == 0 then
            Debug("Vehicle net found from NetToVeh", veh)
            return
        end

        -- Apply default vehicle mods if configured
        for _, vehicleCfg in pairs(Config.jobVehicles) do
            if vehicleCfg.defaultMods and GetEntityModel(veh) == GetHashKey(vehicleCfg.model) then
                Debug("Apply vehicle default mods")
                SetVehicleModKit(veh, 0)
                SetVehicleFuelLevel(veh, 50.0)
                for modType, modIndex in pairs(vehicleCfg.defaultMods) do
                    SetVehicleMod(veh, modType, modIndex, false)
                    Debug("Apply vehicle default mod", modType, modIndex)
                end
            end
        end

        -- Apply level-based upgrades once
        if not task.data.vehicleUpgrades then
            local upgradeLevel = Entity(veh).state.kq_powerwashing_level
            if upgradeLevel then
                task.data.vehicleUpgrades = true
                if upgradeLevel > 0 then
                    ApplyVehicleLevelUpgrades(veh, upgradeLevel)
                end
            end
        end

        -- Complete the task once the player is inside the vehicle
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        if playerVeh == veh then
            task.data.finishing = true
            exports.kq_jobcontracts:FinishTask(task.id)
        end

        return task
    end,

    onComplete = function(task, contract)
        PlaySuccessSound()
    end,

    onEnd = function(task, contract)
        if task.data.blip then
            RemoveBlip(task.data.blip)
        end
    end,
})

-- ============================================================
-- Task type: "go_to_area"
-- Player must travel to a designated location.
-- ============================================================
exports.kq_jobcontracts:RegisterTaskType("go_to_area", {
    tickDelay = 1250,

    onStart = function(task, contract)
        CONTRACT_ACTIVE = true
        local coords = task.vars.coords
        if not coords then return task end

        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 12)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 12)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(task.vars.locationName or L("blips.go_to_area"))
        EndTextCommandSetBlipName(blip)

        task.data.blip     = blip
        task.data.finishing = false
        WASH_BLIPS_ACTIVE  = WASH_BLIPS_ACTIVE + 1

        return task
    end,

    onTick = function(task, contract)
        if task.data.finishing then return end

        local ped       = Data.ped()
        local playerPos = GetEntityCoords(ped)
        local target    = task.vars.coords
        local dist      = CalculateTravelDistanceBetweenPoints(
            playerPos.x, playerPos.y, playerPos.z,
            target.x, target.y, target.z
        )

        -- Update subtext with distance in configured units
        local subtext
        if Config.useMetricUnits then
            if dist >= 1000.0 then
                subtext = string.format("%.1f", dist / 1000.0) .. " " .. L("units.kilometers")
            else
                subtext = math.ceil(dist) .. " " .. L("units.meters")
            end
        else
            local yards = dist * 1.09361
            if yards >= 1000.0 then
                subtext = string.format("%.1f", yards / 1760.0) .. " " .. L("units.miles")
            else
                subtext = math.ceil(yards) .. " " .. L("units.yards")
            end
        end
        TriggerEvent("kq_jobcontracts:client:setTasksSubtext", { [task.id] = subtext })

        -- Finish when within 20m of the target
        if IsWithinDistance(playerPos, target, 20) then
            task.data.finishing = true
            exports.kq_jobcontracts:FinishTask(task.id)
            return task
        end
    end,

    onComplete = function(task, contract)
        PlaySuccessSound()
    end,

    onEnd = function(task, contract)
        if task.data.blip then
            RemoveBlip(task.data.blip)
            WASH_BLIPS_ACTIVE = WASH_BLIPS_ACTIVE - 1
        end
    end,
})

-- ============================================================
-- Task type: "wash_area"
-- Player must wash a designated area. Completion is triggered
-- externally by the wash renderer when the area reaches 100%.
-- ============================================================
exports.kq_jobcontracts:RegisterTaskType("wash_area", {
    onStart = function(task, contract)
        CONTRACT_ACTIVE = true
        local coords = task.vars.coords
        if not coords then return task end

        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 12)
        SetBlipScale(blip, 0.5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(task.name or L("blips.clean"))
        EndTextCommandSetBlipName(blip)

        task.data.blip    = blip
        WASH_BLIPS_ACTIVE = WASH_BLIPS_ACTIVE + 1

        return task
    end,

    onComplete = function(task, contract)
        PlaySuccessSound()
    end,

    onEnd = function(task, contract)
        if task.data.blip then
            RemoveBlip(task.data.blip)
            WASH_BLIPS_ACTIVE = WASH_BLIPS_ACTIVE - 1
        end
    end,
})

-- ============================================================
-- Task type: "finish_at_npc"
-- Player must return to the HQ NPC to hand in the contract.
-- ============================================================
exports.kq_jobcontracts:RegisterTaskType("finish_at_npc", {
    tickDelay = 500,

    onStart = function(task, contract)
        local npcCfg = Config.headquarters.npc
        if not npcCfg then return task end

        local coords = npcCfg.coords
        local blip   = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 480)
        SetBlipColour(blip, 12)
        SetBlipRoute(blip, true)
        SetBlipScale(blip, 0.7)
        SetBlipRouteColour(blip, 12)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(L("blips.supervisor"))
        EndTextCommandSetBlipName(blip)

        task.data.blip = blip
        HeadquartersNpc:SetActiveTask(task.id)

        return task
    end,

    onComplete = function(task, contract)
        PlaySuccessSound()
    end,

    onEnd = function(task, contract)
        if task.data.blip then
            RemoveBlip(task.data.blip)
        end
        HeadquartersNpc:ClearActiveTask()
        CONTRACT_ACTIVE = false
    end,
})

Debug("Client task types registered")