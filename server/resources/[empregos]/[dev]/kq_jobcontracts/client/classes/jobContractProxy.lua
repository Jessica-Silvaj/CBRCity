-- Client-side proxy objects for the active job contract and its tasks.
-- These mirror server state received via sync events.

-- Module-level reference to the currently active contract proxy (nil if none)
local activeContract = nil

-- ============================================================
-- JobTaskProxy: lightweight client-side mirror of a server task
-- ============================================================
JobTaskProxy = {}
JobTaskProxy.__index = JobTaskProxy

-- Create a new JobTaskProxy from server task data
function JobTaskProxy._create(taskData, contractId)
    local self       = setmetatable({}, JobTaskProxy)
    self.id          = taskData.id
    self.index       = taskData.index
    self.type        = taskData.type
    self.name        = taskData.name
    self.description = taskData.description
    self.status      = taskData.status
    self.stepIndex   = taskData.stepIndex
    self.vars        = taskData.vars or {}
    self.hidden      = taskData.hidden or false
    self.contractId  = contractId
    self.lastFinishAttempt = 0
    self.data        = {}
    return self
end

-- Update mutable fields from a new server sync
function JobTaskProxy._updateProperties(self, taskData)
    self.index     = taskData.index
    self.type      = taskData.type
    self.name      = taskData.name
    self.description = taskData.description
    self.status    = taskData.status
    self.stepIndex = taskData.stepIndex
    self.vars      = taskData.vars or {}
    self.hidden    = taskData.hidden or false
end

-- Get a task variable by key
function JobTaskProxy.GetVar(self, key)
    return self.vars[key]
end

-- Set a task variable on the server
function JobTaskProxy.SetVar(self, key, value)
    TriggerServerEvent("kq_jobcontracts:server:setTaskVar", self.contractId, self.index, key, value)
end

-- Tell the server this task is finished
function JobTaskProxy.Finish(self)
    TriggerServerEvent("kq_jobcontracts:server:finishTask", self.id)
end

-- Return true if this task is currently active
function JobTaskProxy.IsActive(self)
    return self.status == Settings.taskStatus.ACTIVE
end

-- Start the per-tick loop for this task's task-type handler
-- Respects tickDelay from task vars, then handler defaults, then Settings default
function JobTaskProxy.StartTick(self)
    if not TaskTypes.Get(self.type) then return end

    -- Resolve tick delay: task var > handler default > Settings default
    local tickDelay = self.vars.tickDelay
    if not tickDelay then
        local handler = TaskTypes.Get(self.type)
        tickDelay = (handler and handler.tickDelay) or Settings.taskTick.defaultDelay
    end

    self.tickRunning = true

    CreateThread(function()
        while true do
            if not self.tickRunning then break end
            local contract = JobContractProxy.GetActive()
            if not contract then break end
            TaskTypes.Call(self.type, "onTick", self, contract)
            Wait(tickDelay)
        end
    end)
end

-- Stop the tick loop on the next iteration
function JobTaskProxy.StopTick(self)
    self.tickRunning = false
end

-- ============================================================
-- JobContractProxy: lightweight client-side mirror of a server contract
-- ============================================================
JobContractProxy = {}
JobContractProxy.__index = JobContractProxy

-- Internal: set (or clear) the active contract from synced server data
function JobContractProxy._setActive(contractData)
    if contractData then
        if activeContract and activeContract.id == contractData.id then
            -- Same contract — update in place
            activeContract:_updateProperties(contractData)
        else
            -- New contract
            activeContract = JobContractProxy._create(contractData)
        end
    else
        activeContract = nil
    end
end

-- Create a new JobContractProxy from server contract data
function JobContractProxy._create(contractData)
    local self             = setmetatable({}, JobContractProxy)
    self.id                = contractData.id
    self.name              = contractData.name
    self.description       = contractData.description
    self.reward            = contractData.reward
    self.job               = contractData.job
    self.minPlayers        = contractData.minPlayers
    self.maxPlayers        = contractData.maxPlayers
    self.status            = contractData.status
    self.leaderId          = contractData.leaderId
    self.players           = contractData.players or {}
    self.playerCount       = contractData.playerCount or 0
    self.onlineCount       = contractData.onlineCount or 0
    self.currentStepIndex  = contractData.currentStepIndex or 0
    self.steps             = contractData.steps or {}
    self.createdAt         = contractData.createdAt
    self.metadata          = contractData.metadata or {}
    self.location          = contractData.location
    self.canStart          = contractData.canStart
    self.vars              = contractData.vars or {}
    self.settings          = contractData.settings or {}
    self.data              = {}
    self.tasks             = {}

    -- Wrap each task in a proxy
    if contractData.tasks then
        for _, taskData in ipairs(contractData.tasks) do
            table.insert(self.tasks, JobTaskProxy._create(taskData, contractData.id))
        end
    end

    return self
end

-- Update mutable fields from a new server sync; returns a change summary table
function JobContractProxy._updateProperties(self, contractData)
    local prevStatus    = self.status
    local prevStepIndex = self.currentStepIndex

    self.name             = contractData.name
    self.description      = contractData.description
    self.status           = contractData.status
    self.leaderId         = contractData.leaderId
    self.players          = contractData.players or {}
    self.playerCount      = contractData.playerCount or 0
    self.canStart         = contractData.canStart
    self.rewardPerPlayer  = contractData.rewardPerPlayer

    -- Recount online players
    local onlineCount = 0
    for _, playerData in pairs(self.players) do
        if playerData.online then
            onlineCount = onlineCount + 1
        end
    end
    self.onlineCount      = onlineCount

    self.currentStepIndex = contractData.currentStepIndex or 0
    self.steps            = contractData.steps or {}
    self.metadata         = contractData.metadata or {}
    self.location         = contractData.location
    self.vars             = contractData.vars or {}
    self.settings         = contractData.settings or {}

    -- Reconcile task list: update existing proxies or create new ones
    local taskById = {}
    for _, task in ipairs(self.tasks) do
        taskById[task.id] = task
    end

    self.tasks = {}
    if contractData.tasks then
        for _, taskData in ipairs(contractData.tasks) do
            local existing = taskById[taskData.id]
            if existing then
                existing:_updateProperties(taskData)
            else
                existing = JobTaskProxy._create(taskData, contractData.id)
            end
            table.insert(self.tasks, existing)
        end
    end

    return {
        statusChanged  = prevStatus    ~= contractData.status,
        stepChanged    = prevStepIndex ~= contractData.currentStepIndex,
        oldStatus      = prevStatus,
        oldStepIndex   = prevStepIndex,
    }
end

-- Wrap raw contract data in a proxy without setting it as active
function JobContractProxy._wrap(contractData)
    return JobContractProxy._create(contractData)
end

-- Return the currently active contract proxy (or nil)
function JobContractProxy.GetActive()
    return activeContract
end

-- Return true if the player is currently in any contract
function JobContractProxy.IsInContract()
    return activeContract ~= nil
end

-- Find a contract by ID: returns the active proxy if it matches,
-- otherwise fetches details from the server
function JobContractProxy.Find(contractId)
    if activeContract and activeContract.id == contractId then
        return activeContract
    end

    local contractData = exports.kq_link:TriggerServerCallback(
        "kq_jobcontracts:callback:getContractDetails", contractId
    )
    if not contractData then return nil end
    return JobContractProxy._wrap(contractData)
end

-- Tell the server to join this contract
function JobContractProxy.Join(self)
    TriggerServerEvent("kq_jobcontracts:server:join", self.id)
end

-- Tell the server to leave this contract
function JobContractProxy.Leave(self)
    TriggerServerEvent("kq_jobcontracts:server:leave", self.id)
end

-- Tell the server to start this contract
function JobContractProxy.Start(self)
    TriggerServerEvent("kq_jobcontracts:server:start", self.id)
end

-- Transfer leadership to another player (server ID)
function JobContractProxy.TransferLeadership(self, targetServerId)
    TriggerServerEvent("kq_jobcontracts:server:transferLeadership", self.id, targetServerId)
end

-- Kick a player from the contract (server ID)
function JobContractProxy.Kick(self, targetServerId)
    TriggerServerEvent("kq_jobcontracts:server:kick", self.id, targetServerId)
end

-- Return all task proxies for this contract
function JobContractProxy.GetTasks(self)
    return self.tasks
end

-- Return the task proxy at a given index (1-based)
function JobContractProxy.GetTask(self, index)
    return self.tasks[index]
end

-- Return the current step definition, or nil if no step is active
function JobContractProxy.GetCurrentStep(self)
    if self.currentStepIndex > 0 and self.currentStepIndex <= #self.steps then
        return self.steps[self.currentStepIndex]
    end
    return nil
end

-- Return the first task of the current step, or nil
function JobContractProxy.GetCurrentTask(self)
    local step = self:GetCurrentStep()
    if not step or not step.taskIndices or #step.taskIndices == 0 then
        return nil
    end
    return self.tasks[step.taskIndices[1]]
end

-- Return all tasks belonging to the current step
function JobContractProxy.GetCurrentTasks(self)
    local step = self:GetCurrentStep()
    if not step or not step.taskIndices then
        return {}
    end

    local result = {}
    for _, taskIndex in ipairs(step.taskIndices) do
        local task = self.tasks[taskIndex]
        if task then
            table.insert(result, task)
        end
    end
    return result
end

-- Return the total number of tasks
function JobContractProxy.GetTaskCount(self)
    return #self.tasks
end

-- Find a task by its UUID
function JobContractProxy.FindTaskById(self, taskId)
    for _, task in ipairs(self.tasks) do
        if task.id == taskId then
            return task
        end
    end
    return nil
end

-- Return true if this contract is currently in progress
function JobContractProxy.IsInProgress(self)
    return self.status == Settings.status.IN_PROGRESS
end