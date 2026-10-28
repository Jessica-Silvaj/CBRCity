-- Registry of task type handlers (server-side)
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
-- For "isFinished": returns result directly
-- For other methods: runs in a new thread and merges returned .data back into task
function TaskTypes.Call(typeName, methodName, ...)
    local handler = TaskTypes.registered[typeName]
    if not handler then return nil end

    local method = handler[methodName]
    if not method then return nil end

    if methodName == "isFinished" then
        -- Synchronous call, return result directly
        return method(...)
    else
        local args = { ... }
        local task = args[1]

        -- Call synchronously to get the result
        local result = method(table.unpack(args))

        -- Merge returned .data into the task if applicable
        if type(result) == "table" and result.data and task then
            if task.data then
                task.data = result.data
            end
        end

        return true
    end
end

-- Check whether a task type exists
function TaskTypes.Exists(typeName)
    return TaskTypes.registered[typeName] ~= nil
end
