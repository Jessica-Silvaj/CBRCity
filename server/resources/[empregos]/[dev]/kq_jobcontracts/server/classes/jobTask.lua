-- JobTask: represents a single task within a job contract
JobTask = {}
JobTask.__index = JobTask

-- Create a new JobTask instance
-- taskDef: task definition table, taskIndex: position in task list
-- stepIndex: step position, contract: parent JobContract
-- Returns (task, nil) on success, (nil, errorMsg) on failure
function JobTask.new(taskDef, taskIndex, stepIndex, contract)
    if not taskDef.type then
        return nil, "Task type is required"
    end

    -- Prefix type with the contract's invoker namespace (e.g. "myscript:mytype")
    local fullType = contract.invoker .. ":" .. taskDef.type
    taskDef.type = fullType

    if not TaskTypes.Exists(fullType) then
        return nil, "Unknown task type: " .. fullType
    end

    local task = setmetatable({}, JobTask)
    task.id                = GenerateUuid()
    task.index             = taskIndex
    task.stepIndex         = stepIndex
    task.type              = taskDef.type
    task.name              = taskDef.name or ("Task " .. taskIndex)
    task.description       = taskDef.description or ""
    task.status            = Settings.taskStatus.WAITING
    task.vars              = table.clone(taskDef.vars or {})
    task.contract          = contract
    task.lastFinishAttempt = 0
    task.data              = {}
    task.hidden            = taskDef.hidden or false

    return task, nil
end

-- Return task data safe to send to the client (no internal state)
function JobTask.GetClientData(self)
    return {
        id          = self.id,
        index       = self.index,
        type        = self.type,
        name        = self.name,
        description = self.description,
        status      = self.status,
        vars        = table.clone(self.vars),
        hidden      = self.hidden,
    }
end

-- Return task data including runtime .data, used for task type callbacks
function JobTask.GetCallbackData(self)
    return {
        id     = self.id,
        index  = self.index,
        type   = self.type,
        name   = self.name,
        status = self.status,
        vars   = table.clone(self.vars),
        data   = table.clone(self.data),
    }
end

-- Start the task: must be WAITING; transitions to ACTIVE and fires onStart
function JobTask.Start(self)
    if self.status ~= Settings.taskStatus.WAITING then
        return false, "Task is not waiting"
    end

    self.status = Settings.taskStatus.ACTIVE
    TaskTypes.Call(self.type, "onStart", self:GetCallbackData())
    return true
end

-- Complete the task: must be ACTIVE; transitions to COMPLETED and fires onComplete + onEnd
function JobTask.Complete(self)
    if self.status ~= Settings.taskStatus.ACTIVE then
        return false, "Task is not active"
    end

    self.status = Settings.taskStatus.COMPLETED
    TaskTypes.Call(self.type, "onComplete", self:GetCallbackData())
    TaskTypes.Call(self.type, "onEnd",      self:GetCallbackData())
    return true
end

-- Fire onEnd without changing status (used for cancellation cleanup)
function JobTask.End(self)
    TaskTypes.Call(self.type, "onEnd", self:GetCallbackData())
    return true
end

-- Ask the task type handler whether this task is finished
-- Returns true only if the handler explicitly returns true
function JobTask.CheckFinished(self, arg1, arg2)
    local result = TaskTypes.Call(self.type, "isFinished", self:GetCallbackData(), arg1, arg2)
    return result == true
end
