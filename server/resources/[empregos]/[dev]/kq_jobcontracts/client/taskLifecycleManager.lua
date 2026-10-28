-- TaskLifecycleManager: drives client-side task type callbacks (onStart, onTick, onEnd, onComplete)
-- as the active contract's step and task states change.
TaskLifecycleManager = {
    activeTasks        = {},  -- set of task indices currently running (index -> true)
    previousStepIndex  = 0,
}

-- Reset internal state
function TaskLifecycleManager.Init(self)
    Debug("TaskLifecycleManager initialized")
    self.activeTasks       = {}
    self.previousStepIndex = 0
end

-- Called whenever the active contract is updated.
-- Routes to HandleStepChange if the step advanced, or HandleTaskUpdates otherwise.
function TaskLifecycleManager.HandleContractUpdate(self, prevContract, newContract)
    local newStepIndex = newContract.currentStepIndex
    if newStepIndex ~= self.previousStepIndex then
        self:HandleStepChange(prevContract, newContract, newStepIndex)
    else
        self:HandleTaskUpdates(newContract)
    end
end

-- Called when the contract advances to a new step.
-- Ends all tasks from the previous step, then starts all active tasks in the new step.
function TaskLifecycleManager.HandleStepChange(self, prevContract, newContract, newStepIndex)
    Debug("TaskLifecycleManager: Step changed from", self.previousStepIndex, "to", newStepIndex)

    -- End tasks that were running in the previous step
    if self.previousStepIndex > 0 and prevContract then
        for taskIndex in pairs(self.activeTasks) do
            local prevTask = prevContract:GetTask(taskIndex)
            local newTask  = newContract:GetTask(taskIndex)

            if prevTask and newTask then
                local handler = TaskTypes.Get(prevTask.type)
                if handler then
                    -- Fire onComplete if the task finished during the previous step
                    if newTask.status == Settings.taskStatus.COMPLETED then
                        TaskTypes.Call(prevTask.type, "onComplete", prevTask, prevContract)
                    end
                    prevTask:StopTick()
                    TaskTypes.Call(prevTask.type, "onEnd", prevTask, prevContract)
                end
            end
        end
    end

    -- Reset and start tasks for the new step
    self.activeTasks = {}
    if newStepIndex > 0 then
        for _, task in ipairs(newContract:GetCurrentTasks()) do
            if task:IsActive() then
                local handler = TaskTypes.Get(task.type)
                if handler then
                    Debug("TaskLifecycleManager: Starting task", task.index, "-", task.name)
                    TaskTypes.Call(task.type, "onStart", task, newContract)
                    task:StartTick()
                end
                self.activeTasks[task.index] = true
            end
        end
    end

    self.previousStepIndex = newStepIndex
end

-- Called when the step hasn't changed but task statuses may have.
-- Detects newly completed tasks and fires onComplete / onEnd for them.
function TaskLifecycleManager.HandleTaskUpdates(self, contract)
    for _, task in ipairs(contract:GetCurrentTasks()) do
        if task.status == Settings.taskStatus.COMPLETED then
            if self.activeTasks[task.index] then
                local handler = TaskTypes.Get(task.type)
                if handler then
                    Debug("TaskLifecycleManager: Task completed", task.index, "-", task.name)
                    TaskTypes.Call(task.type, "onComplete", task, contract)
                    task:StopTick()
                    TaskTypes.Call(task.type, "onEnd", task, contract)
                end
                self.activeTasks[task.index] = nil
            end
        end
    end
end

-- Called when the contract ends (cancelled, completed, or player leaves).
-- Stops all running task ticks and fires onEnd for each.
function TaskLifecycleManager.CleanupContract(self, contract)
    Debug("TaskLifecycleManager: Cleaning up contract", contract.id)

    for taskIndex in pairs(self.activeTasks) do
        local task = contract:GetTask(taskIndex)
        if task then
            local handler = TaskTypes.Get(task.type)
            if handler then
                task:StopTick()
                TaskTypes.Call(task.type, "onEnd", task, contract)
            end
        end
    end

    self.previousStepIndex = 0
    self.activeTasks       = {}
end