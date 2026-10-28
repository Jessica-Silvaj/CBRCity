-- HeadquartersNpc: manages the NPC, its finish-contract interaction, and the job board zone
HeadquartersNpc = {
    ped                  = nil,
    interaction          = nil,
    jobBoardInteraction  = nil,
    activeTaskId         = nil,
}

-- Spawn the NPC and set up both interaction points
function HeadquartersNpc.Init(self)
    local npcCfg = Config.headquarters.npc
    if not npcCfg then return end

    -- Load the ped model
    local modelHash = GetHashKey(npcCfg.model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(10) end

    -- Spawn the ped (z offset -1 because CreatePed places at foot level)
    local coords = npcCfg.coords
    self.ped = CreatePed(4, modelHash, coords.x, coords.y, coords.z - 1, coords.w, false, true)

    SetEntityInvincible(self.ped, true)
    SetBlockingOfNonTemporaryEvents(self.ped, true)
    FreezeEntityPosition(self.ped, true)

    if npcCfg.scenario then
        TaskStartScenarioInPlace(self.ped, npcCfg.scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(modelHash)

    self:SetupInteraction()
    self:SetupJobBoard()
end

-- Register the "finish contract" interaction on the NPC entity
function HeadquartersNpc.SetupInteraction(self)
    if not self.ped then return end
    local npcCfg = Config.headquarters.npc

    self.interaction = exports.kq_link:AddInteractionEntity(
        self.ped,
        vec3(0.0, 0.0, 0.5),                          -- offset above ped
        L("headquarters.finish_contract_3d"),          -- 3D label
        L("headquarters.finish_contract_target"),      -- target label
        38,                                            -- icon
        function()                                     -- onInteract
            if not self.activeTaskId then return end
            exports.kq_jobcontracts:FinishTask(self.activeTaskId)
        end,
        function()                                     -- isVisible
            if not self.activeTaskId then return false end
            if IsPlayerUnreachable() then return false end
            local playerPos = Data.coords()
            local npcPos    = vec3(npcCfg.coords.x, npcCfg.coords.y, npcCfg.coords.z)
            return IsWithinDistance(playerPos, npcPos, 2.5)
        end,
        {},                                            -- extra options
        2.5,                                           -- interact distance
        "fas fa-clipboard-check"                       -- icon class
    )
end

-- Register the job board interaction zone near the HQ
function HeadquartersNpc.SetupJobBoard(self)
    local boardCfg = Config.headquarters.jobBoard
    if not boardCfg then return end

    self.jobBoardInteraction = exports.kq_link:AddInteractionZone(
        boardCfg.coords,
        vec3(0.0, 0.0, 0.0),
        boardCfg.scale,
        L("headquarters.job_board_3d"),
        L("headquarters.job_board_target"),
        38,
        function()                                     -- onInteract
            if not IsPlayerWearingJobOutfit() then
                exports.kq_link:Notify(L("outfit.required"), "error")
                return
            end
            TriggerServerEvent("kq_powerwashing:server:openJobBoard")
        end,
        function()                                     -- isVisible
            if IsPlayerUnreachable() then return false end
            return DoesPlayerHavePowerwashingJob()
        end,
        {},
        boardCfg.interactDist,
        "fas fa-clipboard-list"
    )
end

-- Set the task ID that the "finish contract" interaction will complete
function HeadquartersNpc.SetActiveTask(self, taskId)
    self.activeTaskId = taskId
end

-- Clear the active task (hides the finish-contract interaction)
function HeadquartersNpc.ClearActiveTask(self)
    self.activeTaskId = nil
end

-- Delete the NPC and remove all interaction points
function HeadquartersNpc.Destroy(self)
    if self.interaction then
        self.interaction.Delete()
        self.interaction = nil
    end
    if self.jobBoardInteraction then
        self.jobBoardInteraction.Delete()
        self.jobBoardInteraction = nil
    end
    if self.ped and DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
        self.ped = nil
    end
    self.activeTaskId = nil
end

-- Initialise on resource start
CreateThread(function()
    Wait(1000)
    HeadquartersNpc:Init()
end)

-- Clean up when resource stops
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    HeadquartersNpc:Destroy()
end)