-- Registry of task type handlers (client-side)
TaskTypes = {
    registered = {}
}

-- Register a new task type handler by name
function TaskTypes.Register(typeName, handler)
    TaskTypes.registered[typeName] = handler
    Debug("Registered task type: " .. typeName)
end

-- Get a registered task type handler by name
function TaskTypes.Get(typeName)
    return TaskTypes.registered[typeName]
end

-- Call a specific method on a registered task type
-- "onTick" and "onEnd" are called synchronously and can update task.data
-- All other methods are called in a new thread
function TaskTypes.Call(typeName, methodName, task, extraArg)
    local handler = TaskTypes.registered[typeName]
    if not handler then return nil end

    local method = handler[methodName]
    if not method then return nil end

    if methodName == "onTick" or methodName == "onEnd" then
        -- Synchronous call
        local result = method(task, extraArg)
        if type(result) == "table" and result.data then
            task.data = result.data
        end
        return result
    else
        -- Async call in a new thread
        CreateThread(function()
            local result = method(task, extraArg)
            if type(result) == "table" and result.data then
                task.data = result.data
            end
        end)
        return true
    end
end
