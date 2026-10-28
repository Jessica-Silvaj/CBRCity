-- JobContract: represents a full job contract with players, tasks, and steps
JobContract = {}
JobContract.__index = JobContract

-- Create a new JobContract instance from a contract definition
-- contractDef: table with contract config, invoker: resource name that created it
-- Returns (contract, nil) on success, (nil, errorMsg) on failure
function JobContract.new(contractDef, invoker)
    -- Validate required fields
    if not contractDef.name or type(contractDef.name) ~= "string" then
        return nil, "Contract name is required"
    end
    if not contractDef.maxPlayers or type(contractDef.maxPlayers) ~= "number" or contractDef.maxPlayers < 1 then
        return nil, "maxPlayers is required and must be at least 1"
    end

    local minPlayers = contractDef.minPlayers or 1
    if minPlayers > contractDef.maxPlayers then
        return nil, "minPlayers cannot exceed maxPlayers"
    end

    local contract = setmetatable({}, JobContract)

    -- Build contract ID, optionally prefixed with invoker namespace
    local baseId = contractDef.id or GenerateUuid()
    contract.id = invoker and (invoker .. ":" .. baseId) or baseId

    contract.name             = contractDef.name
    contract.invoker          = invoker
    contract.description      = contractDef.description or ""
    contract.job              = contractDef.job or "unemployed"
    contract.minPlayers       = minPlayers
    contract.maxPlayers       = contractDef.maxPlayers
    contract.status           = Settings.status.WAITING
    contract.leaderId         = nil
    contract.players          = {}
    contract.tasks            = {}
    contract.steps            = {}
    contract.currentStepIndex = 0
    contract.createdAt        = os.time()
    contract.startedAt        = nil
    contract.reward           = contractDef.reward
    contract.rewardPerPlayer  = contractDef.rewardPerPlayer
    contract.metadata         = contractDef.metadata or {}
    contract.location         = contractDef.location
    contract.onStart          = contractDef.onStart
    contract.onComplete       = contractDef.onComplete
    contract.onEnd            = contractDef.onEnd
    contract.onLeave          = contractDef.onLeave
    contract.data             = {}
    contract.vars             = contractDef.vars or {}
    contract.settings         = {}

    -- Parse task list: each entry can be a plain task, a parallel group, or a labeled step
    if contractDef.tasks then
        local globalTaskIndex = 1

        for stepIdx, stepEntry in ipairs(contractDef.tasks) do
            local isParallel  = false
            local stepLabel   = nil
            local taskIndices = {}

            if type(stepEntry) == "table" then
                if stepEntry.type then
                    -- Single plain task (has a .type field)
                    local task, err = JobTask.new(stepEntry, globalTaskIndex, stepIdx, contract)
                    if not task then
                        return nil, string.format("Task %d error: %s", globalTaskIndex, err)
                    end
                    table.insert(contract.tasks, task)
                    table.insert(taskIndices, globalTaskIndex)
                    globalTaskIndex = globalTaskIndex + 1

                elseif stepEntry.label and stepEntry.tasks then
                    -- Labeled parallel step (has .label and .tasks)
                    isParallel = true
                    stepLabel  = stepEntry.label
                    for subIdx, subTask in ipairs(stepEntry.tasks) do
                        if type(subTask) == "table" and subTask.type then
                            local task, err = JobTask.new(subTask, globalTaskIndex, stepIdx, contract)
                            if not task then
                                return nil, string.format("Task %d (step %d, subtask %d) error: %s",
                                    globalTaskIndex, stepIdx, subIdx, err)
                            end
                            table.insert(contract.tasks, task)
                            table.insert(taskIndices, globalTaskIndex)
                            globalTaskIndex = globalTaskIndex + 1
                        end
                    end

                else
                    -- Unlabeled parallel step (array of tasks)
                    isParallel = true
                    for subIdx, subTask in ipairs(stepEntry) do
                        if type(subTask) == "table" and subTask.type then
                            local task, err = JobTask.new(subTask, globalTaskIndex, stepIdx, contract)
                            if not task then
                                return nil, string.format("Task %d (step %d, subtask %d) error: %s",
                                    globalTaskIndex, stepIdx, subIdx, err)
                            end
                            table.insert(contract.tasks, task)
                            table.insert(taskIndices, globalTaskIndex)
                            globalTaskIndex = globalTaskIndex + 1
                        end
                    end
                end
            end

            table.insert(contract.steps, {
                index       = stepIdx,
                taskIndices = taskIndices,
                isParallel  = isParallel,
                label       = stepLabel,
            })
        end
    end

    Debug(string.format("Created contract: %s (%s) with %d tasks",
        contract.name, contract.id, #contract.tasks))

    return contract, nil
end

-- Return the total number of players in the contract
function JobContract.GetPlayerCount(self)
    local count = 0
    for _ in pairs(self.players) do count = count + 1 end
    return count
end

-- Return the number of online players
function JobContract.GetOnlinePlayerCount(self)
    local count = 0
    for _, playerData in pairs(self.players) do
        if playerData.online then count = count + 1 end
    end
    return count
end

-- Return an array of server IDs for all currently online players
function JobContract.GetOnlineServerIds(self)
    local ids = {}
    for identifier, playerData in pairs(self.players) do
        if playerData.online then
            local serverId = self:GetServerIdFromIdentifier(identifier)
            if serverId then
                table.insert(ids, serverId)
            end
        end
    end
    return ids
end

-- Resolve a player identifier to their current server ID (nil if offline)
function JobContract.GetServerIdFromIdentifier(self, identifier)
    local playerData = self.players[identifier]
    if playerData and playerData.online and playerData.serverId then
        return playerData.serverId
    end
    return nil
end

-- Return the current step object, or nil if not started / all steps done
function JobContract.GetCurrentStep(self)
    if self.currentStepIndex > 0 and self.currentStepIndex <= #self.steps then
        return self.steps[self.currentStepIndex]
    end
    return nil
end

-- Return the first task of the current step (for single-task steps)
function JobContract.GetCurrentTask(self)
    local step = self:GetCurrentStep()
    if not step or #step.taskIndices == 0 then return nil end
    return self.tasks[step.taskIndices[1]]
end

-- Return all tasks belonging to the current step
function JobContract.GetCurrentTasks(self)
    local step = self:GetCurrentStep()
    if not step then return {} end
    local tasks = {}
    for _, taskIndex in ipairs(step.taskIndices) do
        table.insert(tasks, self.tasks[taskIndex])
    end
    return tasks
end

-- Find a task by its UUID
function JobContract.FindTaskById(self, taskId)
    for _, task in ipairs(self.tasks) do
        if task.id == taskId then return task end
    end
    return nil
end

-- Build the player map for client data (safe public fields only)
local function buildClientPlayerMap(contract)
    local map = {}
    for identifier, playerData in pairs(contract.players) do
        map[identifier] = {
            name     = playerData.name or "Unknown",
            online   = playerData.online,
            joinedAt = playerData.joinedAt,
            isLeader = contract.leaderId == identifier,
            serverId = contract:GetServerIdFromIdentifier(identifier),
        }
    end
    return map
end

-- Return full contract data safe to send to the client (used for active contract HUD)
function JobContract.GetClientData(self)
    local taskList = {}
    for _, task in ipairs(self.tasks) do
        table.insert(taskList, task:GetClientData())
    end

    local clientData = {
        id               = self.id,
        name             = self.name,
        description      = self.description,
        job              = self.job,
        minPlayers       = self.minPlayers,
        maxPlayers       = self.maxPlayers,
        status           = self.status,
        leaderId         = self.leaderId,
        players          = buildClientPlayerMap(self),
        playerCount      = self:GetPlayerCount(),
        onlineCount      = self:GetOnlinePlayerCount(),
        tasks            = taskList,
        currentStepIndex = self.currentStepIndex,
        steps            = table.clone(self.steps),
        createdAt        = self.createdAt,
        reward           = self.reward,
        rewardPerPlayer  = self.rewardPerPlayer,
        metadata         = table.clone(self.metadata),
        vars             = table.clone(self.vars),
        location         = self.location,
        canStart         = self:CanStart(),
        -- Only include settings when contract is in progress
        settings         = self.status == Settings.status.IN_PROGRESS and table.clone(self.settings) or nil,
    }
    return clientData
end

-- Return full contract data for use in server-side callbacks (includes runtime .data)
function JobContract.GetCallbackData(self)
    if not self then return nil end

    local taskList = {}
    for _, task in ipairs(self.tasks) do
        table.insert(taskList, task:GetCallbackData())
    end

    return {
        id               = self.id,
        name             = self.name,
        description      = self.description,
        job              = self.job,
        data             = self.data or {},
        vars             = self.vars or {},
        settings         = self.settings or {},
        minPlayers       = self.minPlayers,
        maxPlayers       = self.maxPlayers,
        status           = self.status,
        leaderId         = self.leaderId,
        players          = buildClientPlayerMap(self),
        playerCount      = self:GetPlayerCount(),
        onlineCount      = self:GetOnlinePlayerCount(),
        tasks            = taskList,
        currentStepIndex = self.currentStepIndex,
        steps            = table.clone(self.steps),
        createdAt        = self.createdAt,
        reward           = self.reward,
        rewardPerPlayer  = self.rewardPerPlayer,
        metadata         = table.clone(self.metadata),
        location         = self.location,
        canStart         = self:CanStart(),
    }
end

-- Return minimal data for the contract list UI (lightweight, no task details)
function JobContract.GetLightweightData(self)
    local visibleTaskCount = 0
    for _, task in ipairs(self.tasks) do
        if not task.hidden then visibleTaskCount = visibleTaskCount + 1 end
    end

    return {
        id          = self.id,
        name        = self.name,
        job         = self.job,
        stepsCount  = #self.steps,
        tasksCount  = visibleTaskCount,
        status      = self.status,
        description = self.description,
        playerCount = self:GetPlayerCount(),
        maxPlayers  = self.maxPlayers,
        minPlayers  = self.minPlayers,
        reward      = self.reward,
    }
end

-- Return true if the contract is in a state where it can be started
function JobContract.CanStart(self)
    return self.status == Settings.status.WAITING or self.status == Settings.status.READY
end

-- Return true if this player identifier is in the contract
function JobContract.HasPlayer(self, identifier)
    return self.players[identifier] ~= nil
end

-- Return true if this identifier is the contract leader
function JobContract.IsLeader(self, identifier)
    return self.leaderId == identifier
end

-- Return true if all players have been offline past the grace period (contract should be abandoned)
function JobContract.ShouldAbandon(self)
    if self.status ~= Settings.status.IN_PROGRESS then return false end

    local now         = os.time()
    local gracePeriod = Config.abandonGracePeriod

    for _, playerData in pairs(self.players) do
        if playerData.online then return false end                    -- someone is still online
        if gracePeriod > (now - playerData.lastSeen) then return false end  -- still in grace period
    end
    return true
end

-- Validate that the player is within interaction distance of the contract board
-- Returns (true, nil) or (false, errorMsg)
function JobContract.ValidatePlayerDistance(self, serverId)
    if not self.location then return true, nil end

    local ped = GetPlayerPed(serverId)
    if not ped or ped == 0 then
        return false, "Invalid player"
    end

    local coords   = GetEntityCoords(ped)
    local distance = #(coords - self.location)
    if distance > Settings.security.maxInteractionDistance then
        return false, "Too far from contract board"
    end
    return true, nil
end

-- Add a player (by server ID) to the contract
-- Returns (true, nil) or (false, errorMsg)
function JobContract.Join(self, serverId)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then return false, "Could not get player identifier" end

    -- Contract must be open
    if self.status ~= Settings.status.WAITING and self.status ~= Settings.status.READY then
        return false, "Contract is not accepting players"
    end

    if self:HasPlayer(identifier) then return false, "Already in this contract" end
    if self:GetPlayerCount() >= self.maxPlayers then return false, "Contract is full" end

    -- Player must not already be in another contract
    if Registry:GetPlayerContract(identifier) then
        return false, "Already in another contract"
    end

    -- Distance check
    local ok, err = self:ValidatePlayerDistance(serverId)
    if not ok then return false, err end

    -- Resolve display name
    local name = exports.kq_link:GetPlayerCharacterName(serverId)
                 or GetPlayerName(serverId)
                 or "Unknown"

    local now = os.time()
    self.players[identifier] = {
        joinedAt = now,
        lastSeen = now,
        online   = true,
        name     = name,
        serverId = serverId,
    }

    -- First player becomes leader
    if self:GetPlayerCount() == 1 then
        self.leaderId = identifier
    end

    -- Promote to READY when minimum player count is reached
    if self:GetPlayerCount() >= self.minPlayers and #self.tasks > 0 then
        self.status = Settings.status.READY
    end

    Registry:SyncToContractMembers(self)
    Registry:NotifyViewersForJob(self.job)
    return true, nil
end

-- Remove a player (by server ID) from the contract voluntarily
-- Returns (true, nil) or (false, errorMsg)
function JobContract.Leave(self, serverId)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then return false, "Could not get player identifier" end
    if not self:HasPlayer(identifier) then return false, "Not in this contract" end

    local wasInProgress = self.status == Settings.status.IN_PROGRESS

    self.players[identifier] = nil

    -- Notify client that they have no contract
    Registry:SyncToPlayer(serverId, nil)

    -- Fire onLeave callback if contract was in progress
    if wasInProgress and self.onLeave then
        CreateThread(function()
            self.onLeave(self:GetCallbackData(), serverId, identifier)
        end)
    end

    -- Reassign leader if needed
    if self.leaderId == identifier then
        self.leaderId = nil
        for newLeader in pairs(self.players) do
            self.leaderId = newLeader
            break
        end
    end

    -- Cancel if last player left during active contract
    if self:GetPlayerCount() == 0 and self.status == Settings.status.IN_PROGRESS then
        self:Cancel("All players left")
        return true, nil
    end

    -- Drop back to WAITING if below minimum
    if self.status == Settings.status.READY and self:GetPlayerCount() < self.minPlayers then
        self.status = Settings.status.WAITING
    end

    Registry:SyncToContractMembers(self)
    Registry:NotifyViewersForJob(self.job)
    return true, nil
end

-- Mark a player as offline when they disconnect
function JobContract.HandlePlayerDisconnect(self, serverId)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier or not self:HasPlayer(identifier) then return end

    self.players[identifier].online   = false
    self.players[identifier].lastSeen = os.time()

    if self.status ~= Settings.status.IN_PROGRESS then
        -- Remove from contract entirely if not in progress
        self.players[identifier] = nil

        -- Reassign leader if needed
        if self.leaderId == identifier then
            self.leaderId = nil
            for newLeader in pairs(self.players) do
                self.leaderId = newLeader
                break
            end
        end

        -- Drop back to WAITING if below minimum
        if self.status == Settings.status.READY and self:GetPlayerCount() < self.minPlayers then
            self.status = Settings.status.WAITING
        end
    end

    Registry:SyncToContractMembers(self)
    Registry:NotifyViewersForJob(self.job)
end

-- Mark a player as online again when they reconnect
function JobContract.HandlePlayerReconnect(self, serverId)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier or not self:HasPlayer(identifier) then return end

    self.players[identifier].online   = true
    self.players[identifier].lastSeen = os.time()
    self.players[identifier].serverId = serverId

    Registry:SyncToContractMembers(self)
    Registry:NotifyViewersForJob(self.job)
end

-- Start the contract (leader only); optionally pass runtime settings
-- Returns (true, nil) or (false, errorMsg)
function JobContract.Start(self, serverId, runtimeSettings)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then return false, "Could not get player identifier" end
    if not self:IsLeader(identifier) then return false, "Only the leader can start" end

    if self.status == Settings.status.IN_PROGRESS then return false, "Already in progress" end
    if self.status == Settings.status.COMPLETED    then return false, "Already completed"   end
    if self:GetPlayerCount() < self.minPlayers     then return false, "Not enough players"  end
    if #self.tasks == 0                            then return false, "No tasks"             end

    local ok, err = self:ValidatePlayerDistance(serverId)
    if not ok then return false, err end

    self.settings         = runtimeSettings or {}
    self.status           = Settings.status.IN_PROGRESS
    self.currentStepIndex = 1
    self.startedAt        = GetGameTimer()

    -- Start tasks in the first step
    local firstStep = self:GetCurrentStep()
    if firstStep then
        for _, taskIndex in ipairs(firstStep.taskIndices) do
            self.tasks[taskIndex]:Start()
        end
    end

    -- Fire onStart callback
    if self.onStart then
        local onlineIds   = self:GetOnlineServerIds()
        local callbackData = self:GetCallbackData()
        local result      = self.onStart(callbackData, onlineIds)
        if type(result) == "table" then
            if result.data then self.data = result.data end
            if result.vars then self.vars = result.vars end
        end
    end

    Registry:SyncToContractMembers(self)
    Registry:NotifyViewersForJob(self.job)
    return true, nil
end

-- Mark a task as finished, advance to the next step or complete the contract
-- serverId: optional player who triggered the finish; taskIdOrIndex: optional specific task
-- Returns (true, nil) or (false, errorMsg)
function JobContract.FinishTask(self, serverId, taskIdOrIndex)
    if self.status ~= Settings.status.IN_PROGRESS then
        return false, "Contract is not in progress"
    end

    -- Resolve the calling player's identifier (optional)
    local identifier = nil
    if serverId then
        identifier = GetPlayerUniqueIdentifier(serverId)
        if not identifier then return false, "Could not get player identifier" end
        if not self:HasPlayer(identifier) then return false, "Not in this contract" end
    end

    -- Resolve the target task
    local targetTask = nil
    if taskIdOrIndex then
        if type(taskIdOrIndex) == "string" then
            targetTask = self:FindTaskById(taskIdOrIndex)
        else
            targetTask = self.tasks[taskIdOrIndex]
        end

        if targetTask then
            if targetTask.status ~= Settings.taskStatus.ACTIVE then
                return false, "Task is not active"
            end
        end
    else
        -- Server-side auto-detection: find first current task that reports finished
        if not identifier then
            return false, "Task ID or index required for server-side finish"
        end
        for _, task in ipairs(self:GetCurrentTasks()) do
            if task:CheckFinished(identifier, serverId) then
                targetTask = task
                break
            end
        end
    end

    if not targetTask then return false, "No finishable task found" end

    -- If player-triggered, verify task requirements are met
    if serverId and identifier then
        if not targetTask:CheckFinished(identifier, serverId) then
            return false, "Task requirements not met"
        end
    end

    targetTask:Complete()

    -- Check if all tasks in the current step are done
    local currentStep = self:GetCurrentStep()
    if currentStep then
        local allDone = true
        for _, taskIndex in ipairs(currentStep.taskIndices) do
            if self.tasks[taskIndex].status ~= Settings.taskStatus.COMPLETED then
                allDone = false
                break
            end
        end

        if allDone then
            if self.currentStepIndex < #self.steps then
                -- Advance to next step and start its tasks
                self.currentStepIndex = self.currentStepIndex + 1
                local nextStep = self:GetCurrentStep()
                if nextStep then
                    for _, taskIndex in ipairs(nextStep.taskIndices) do
                        self.tasks[taskIndex]:Start()
                    end
                end
            else
                -- All steps done — complete the contract
                self:Complete()
            end
        end
    end

    Registry:SyncToContractMembers(self)
    return true, nil
end

-- Complete the contract: updates stats, fires callbacks, notifies all members
-- Returns (true, nil) or (false, errorMsg)
function JobContract.Complete(self)
    if self.status ~= Settings.status.IN_PROGRESS then
        return false, "Contract is not in progress"
    end

    self.status = Settings.status.COMPLETED

    local onlineIds = self:GetOnlineServerIds()

    -- End any still-active tasks
    for _, task in ipairs(self.tasks) do
        if task.status == Settings.taskStatus.ACTIVE then
            task:End()
        end
    end

    -- Fire onComplete callback and collect per-player reward data
    local rewardData = {}
    if self.onComplete then
        local result = self.onComplete(self:GetCallbackData(), onlineIds)
        if type(result) == "table" then
            rewardData = result
        end
    end

    -- Update DB stats for each online player
    for identifier, playerData in pairs(self.players) do
        if playerData.online then
            local serverId = self:GetServerIdFromIdentifier(identifier)
            if serverId then
                local xp = 0
                if rewardData[serverId] and rewardData[serverId].xp then
                    xp = rewardData[serverId].xp
                end
                DB.UpdatePlayerJobStats(identifier, self.job, xp, 1)
                WipeCache("DB.GetPlayerJobStats" .. identifier .. self.job)
            end
        end
    end

    -- Fire onEnd callback
    if self.onEnd then
        local result = self.onEnd(self:GetCallbackData(), "completed", onlineIds)
        if type(result) == "table" and result.data then
            self.data = result.data
        end
    end

    -- Calculate duration
    local durationMs = self.startedAt and (GetGameTimer() - self.startedAt) or 0

    -- Count visible tasks
    local visibleTaskCount = 0
    for _, task in ipairs(self.tasks) do
        if not task.hidden then visibleTaskCount = visibleTaskCount + 1 end
    end

    -- Build summary payload for each online player
    local summary = {
        contractId          = self.id,
        contractName        = self.name,
        contractDescription = self.description,
        job                 = self.job,
        baseReward          = self.reward,
        playerCount         = self:GetPlayerCount(),
        maxPlayers          = self.maxPlayers,
        minPlayers          = self.minPlayers,
        stepsCount          = #self.steps,
        tasksCount          = visibleTaskCount,
        durationMs          = durationMs,
        metadata            = self.metadata,
    }

    for _, serverId in ipairs(onlineIds) do
        local playerReward = rewardData[serverId] or {}
        summary.xpGained   = playerReward.xp or 0
        TriggerClientEvent("kq_jobcontracts:client:contractCompleted", serverId, summary, playerReward)
    end

    -- Sync nil contract to all online members (they are no longer in a contract)
    -- IMPORTANTE: GetServerIdFromIdentifier recibe el identifier (string),
    -- NO playerData.serverId (número). Antes se pasaba el número y devolvía nil siempre,
    -- por eso el cliente nunca recibía el nil y el contrato seguía activo en el HUD.
    for identifier, playerData in pairs(self.players) do
        if playerData.online then
            local serverId = self:GetServerIdFromIdentifier(identifier)
            if serverId then
                Registry:SyncToPlayer(serverId, nil)
            end
        end
    end

    self.players = {}
    return true, nil
end

-- Cancel the contract with an optional reason; fires onEnd callback
-- Returns (true, nil) or (false, errorMsg)
function JobContract.Cancel(self, reason)
    if self.status == Settings.status.COMPLETED then
        return false, "Cannot cancel completed contract"
    end

    self.status = Settings.status.CANCELLED

    local onlineIds = self:GetOnlineServerIds()

    -- End any still-active tasks
    for _, task in ipairs(self.tasks) do
        if task.status == Settings.taskStatus.ACTIVE then
            task:End()
        end
    end

    -- Sync nil to all online members
    for identifier, playerData in pairs(self.players) do
        if playerData.online then
            local serverId = self:GetServerIdFromIdentifier(identifier)
            if serverId then
                Registry:SyncToPlayer(serverId, nil)
            end
        end
    end

    self.players = {}

    -- Fire onEnd callback
    if self.onEnd then
        local result = self.onEnd(self:GetCallbackData(), "cancelled", onlineIds)
        if type(result) == "table" and result.data then
            self.data = result.data
        end
    end

    return true, nil
end

-- Transfer contract leadership from the current leader to another member
-- Returns (true, nil) or (false, errorMsg)
function JobContract.TransferLeadership(self, leaderServerId, targetServerId)
    local leaderId = GetPlayerUniqueIdentifier(leaderServerId)
    local targetId = GetPlayerUniqueIdentifier(targetServerId)
    if not leaderId or not targetId then return false, "Could not get player identifier" end
    if not self:IsLeader(leaderId)   then return false, "Only the leader can transfer"   end
    if not self:HasPlayer(targetId)  then return false, "Target not in contract"          end
    if leaderId == targetId          then return false, "Cannot transfer to yourself"     end

    self.leaderId = targetId
    Registry:SyncToContractMembers(self)
    Registry:NotifyViewersForJob(self.job)
    return true, nil
end

-- Kick a player from the contract (leader only, not allowed during active contract)
-- Returns (true, nil) or (false, errorMsg)
function JobContract.Kick(self, leaderServerId, targetServerId)
    local leaderId = GetPlayerUniqueIdentifier(leaderServerId)
    local targetId = GetPlayerUniqueIdentifier(targetServerId)
    if not leaderId or not targetId then return false, "Could not get player identifier" end
    if not self:IsLeader(leaderId)  then return false, "Only the leader can kick"       end
    if leaderId == targetId         then return false, "Cannot kick yourself"            end
    if not self:HasPlayer(targetId) then return false, "Target not in contract"         end

    if self.status == Settings.status.IN_PROGRESS then
        return false, "Cannot kick during active contract"
    end

    self.players[targetId] = nil
    Registry:SyncToPlayer(targetServerId, nil)

    -- Drop back to WAITING if below minimum
    if self:GetPlayerCount() < self.minPlayers then
        self.status = Settings.status.WAITING
    end

    Registry:SyncToContractMembers(self)
    Registry:NotifyViewersForJob(self.job)
    return true, nil
end