-- Helper: validate a source player and check their action cooldown
-- Returns (serverId, identifier, nil) on success, or (nil, nil, errorMsg) on failure
local function ValidateAndCheckCooldown(serverId, actionName)
    if not serverId or serverId <= 0 then
        return nil, nil, "Invalid source"
    end

    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then
        return nil, nil, "Could not get player identifier"
    end

    if not Registry:CheckCooldown(identifier, actionName) then
        return nil, nil, "Please wait before performing another action"
    end

    return serverId, identifier, nil
end

-- ─── Resource Lifecycle ───────────────────────────────────────────────────────

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    Registry:Init()

    -- Clear contract state for all currently connected players
    for _, playerIdStr in ipairs(GetPlayers()) do
        Registry:SyncToPlayer(tonumber(playerIdStr), nil)
        Debug("Cleared contract state for player", playerIdStr, "on resource start")
    end

    -- Background loop: cleanup old contracts and check for abandoned ones
    CreateThread(function()
        while true do
            Wait(60000)
            Registry:Cleanup(300)
            Registry:CheckAbandoned()
        end
    end)
end)

AddEventHandler("onResourceStop", function(resourceName)
    -- Cancel all contracts created by the stopping resource
    if resourceName == GetCurrentResourceName() then return end

    for _, contract in pairs(Registry:GetAllContracts()) do
        local invoker = contract.invoker or ""
        if invoker == resourceName then
            Debug(string.format("Resource '%s' stopped - removing contract", resourceName), contract.id)
            Registry:RemoveContract(contract.id)

            -- Cancel if the contract was still active
            local status = contract.status
            if status == Settings.status.IN_PROGRESS
            or status == Settings.status.READY
            or status == Settings.status.WAITING then
                contract:Cancel("Resource stopped")
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    Registry:HandlePlayerDisconnect(source)
end)

-- ─── Net Events ───────────────────────────────────────────────────────────────

RegisterNetEvent("kq_jobcontracts:server:playerReady")
AddEventHandler("kq_jobcontracts:server:playerReady", function()
    local playerId   = source
    local identifier = GetPlayerUniqueIdentifier(playerId)
    if identifier then
        TriggerClientEvent("kq_jobcontracts:client:setIdentifier", playerId, identifier)
    end
    Registry:HandlePlayerConnect(playerId)
end)

RegisterNetEvent("kq_jobcontracts:server:join")
AddEventHandler("kq_jobcontracts:server:join", function(contractId)
    local playerId, _, err = ValidateAndCheckCooldown(source, "join")
    if err then return end
    if type(contractId) ~= "string" or contractId == "" then return end

    local contract = Registry:GetContract(contractId)
    if not contract then return end

    -- Ensure client has the correct identifier before joining
    local identifier = GetPlayerUniqueIdentifier(playerId)
    if identifier then
        TriggerClientEvent("kq_jobcontracts:client:setIdentifier", playerId, identifier)
    end

    local ok, joinErr = contract:Join(playerId)
    if not ok then
        Debug("Failed to join", joinErr)
    end
end)

RegisterNetEvent("kq_jobcontracts:server:leave")
AddEventHandler("kq_jobcontracts:server:leave", function(contractId)
    local playerId, _, err = ValidateAndCheckCooldown(source, "leave")
    if err then return end
    if type(contractId) ~= "string" then return end

    local contract = Registry:GetContract(contractId)
    if not contract then return end

    contract:Leave(playerId)
end)

RegisterNetEvent("kq_jobcontracts:server:start")
AddEventHandler("kq_jobcontracts:server:start", function(contractId, runtimeSettings)
    local playerId, _, err = ValidateAndCheckCooldown(source, "start")
    if err then return end
    if type(contractId) ~= "string" then return end

    local contract = Registry:GetContract(contractId)
    if not contract then return end

    -- Sanitize settings: must be a table or nil
    if runtimeSettings ~= nil and type(runtimeSettings) ~= "table" then
        runtimeSettings = nil
    end

    contract:Start(playerId, runtimeSettings)
end)

RegisterNetEvent("kq_jobcontracts:server:kick")
AddEventHandler("kq_jobcontracts:server:kick", function(contractId, targetServerId)
    local playerId, _, err = ValidateAndCheckCooldown(source, "kick")
    if err then return end

    -- Validate argument types
    if type(contractId) ~= "string" or type(targetServerId) ~= "number" then return end

    local contract = Registry:GetContract(contractId)
    if not contract then return end

    contract:Kick(playerId, targetServerId)
end)

RegisterNetEvent("kq_jobcontracts:server:finishTask")
AddEventHandler("kq_jobcontracts:server:finishTask", function(taskId)
    local playerId, _, err = ValidateAndCheckCooldown(source, "finish")
    if err then
        Debug("Something went wrong", err)
        return
    end

    if type(taskId) ~= "string" then
        Debug("taskId is invalid", taskId)
        return
    end

    local contract = Registry:GetPlayerContractByServerId(playerId)
    if not contract then
        Debug("Contract not found")
        return
    end

    local task = contract:FindTaskById(taskId)
    Debug("Getting task", task)

    if task then
        -- Throttle: prevent finishing the same task faster than every 5 seconds
        local nowMs = os.time() * 1000
        if task.lastFinishAttempt and (nowMs - task.lastFinishAttempt) < 5000 then
            Debug("task attempted to be finished too early")
            return
        end
        task.lastFinishAttempt = nowMs
    end

    Debug("do finish task")
    contract:FinishTask(playerId, taskId)
end)

RegisterNetEvent("kq_jobcontracts:server:startViewing")
AddEventHandler("kq_jobcontracts:server:startViewing", function(job)
    if type(job) ~= "string" or job == "" then return end
    Registry:AddViewer(source, job)
end)

RegisterNetEvent("kq_jobcontracts:server:stopViewing")
AddEventHandler("kq_jobcontracts:server:stopViewing", function(job)
    if type(job) ~= "string" or job == "" then return end
    Registry:RemoveViewer(source, job)
end)

-- ─── Server Callbacks ─────────────────────────────────────────────────────────

-- Return lightweight contract list for a job (used by the contract board UI)
exports.kq_link:RegisterServerCallback("kq_jobcontracts:callback:getContractList", function(source, job)
    if type(job) ~= "string" or job == "" then return {} end

    local contracts = Registry:GetContractsForJob(job)
    local list = {}
    for _, contract in ipairs(contracts) do
        table.insert(list, contract:GetLightweightData())
    end
    return list
end, true)

-- Return full client data for a single contract by ID
exports.kq_link:RegisterServerCallback("kq_jobcontracts:callback:getContractDetails", function(source, contractId)
    if type(contractId) ~= "string" or contractId == "" then return nil end

    local contract = Registry:GetContract(contractId)
    if not contract then return nil end
    return contract:GetClientData()
end, true)

-- Return job stats + level for the requesting player
exports.kq_link:RegisterServerCallback("kq_jobcontracts:callback:getPlayerStats", function(source, job)
    if type(job) ~= "string" or job == "" then return nil end

    local identifier = GetPlayerUniqueIdentifier(source)
    if not identifier then return nil end

    local cacheKey = "DB.GetPlayerJobStats" .. identifier .. job
    local stats = UseCache(cacheKey, function()
        return DB.GetPlayerJobStats(identifier, job)
    end, 120000)

    local levelData = CalculateLevelFromXp(stats.xp)
    return {
        xp            = stats.xp,
        jobs_finished = stats.jobs_finished,
        level         = levelData.level,
        xpIntoLevel   = levelData.xpIntoLevel,
        xpForNextLevel = levelData.xpForNextLevel,
        progress      = levelData.progress,
    }
end, true)

-- ─── Exports ──────────────────────────────────────────────────────────────────

-- Register a task type handler from an external resource
exports("RegisterTaskType", function(typeName, handler)
    local invoker = GetInvokingResource()
    local fullName = invoker and (invoker .. ":" .. typeName) or typeName
    TaskTypes.Register(fullName, handler)
end)

-- Create a contract and return its callback data
exports("CreateContract", function(contractDef)
    local invoker = GetInvokingResource()
    local contract, err = Registry:CreateContract(contractDef, invoker)
    if not contract then return nil, err end
    return contract:GetCallbackData(), nil
end)

-- Get a contract's callback data by ID
exports("GetContract", function(contractId)
    local contract = Registry:GetContract(contractId)
    if not contract then return nil end
    return contract:GetCallbackData()
end)

-- Get all contracts as callback data tables
exports("GetAllContracts", function()
    local result = {}
    for id, contract in pairs(Registry:GetAllContracts()) do
        result[id] = contract:GetCallbackData()
    end
    return result
end)

-- Get the active contract of a player by server ID
exports("GetPlayerContract", function(serverId)
    local contract = Registry:GetPlayerContractByServerId(serverId)
    if not contract then return nil end
    return contract:GetCallbackData()
end)

-- Force-complete a contract by ID
exports("CompleteContract", function(contractId)
    local contract = Registry:GetContract(contractId)
    if not contract then return false, "Contract not found" end
    return contract:Complete()
end)

-- Cancel a contract by ID with an optional reason
exports("CancelContract", function(contractId, reason)
    local contract = Registry:GetContract(contractId)
    if not contract then return false, "Contract not found" end
    return contract:Cancel(reason)
end)

-- Remove a contract from the registry entirely
exports("RemoveContract", function(contractId)
    return Registry:RemoveContract(contractId)
end)

-- Force-finish a task by ID or task table (searches all contracts)
exports("FinishTask", function(taskOrId)
    local taskId = type(taskOrId) == "table" and taskOrId.id or taskOrId
    if type(taskId) ~= "string" then return false, "Invalid task ID" end

    Debug("finishing task")
    for _, contract in pairs(Registry:GetAllContracts()) do
        local task = contract:FindTaskById(taskId)
        if task then
            if task.status ~= Settings.taskStatus.ACTIVE then
                return false, "Task is not active"
            end
            Debug("finishing task now")
            return contract:FinishTask(nil, taskId)
        end
    end
    return false, "Task not found"
end)

-- Open the contract board UI for a specific player
exports("OpenBoardForPlayer", function(serverId, job, location, boardId, extraData)
    TriggerClientEvent("kq_jobcontracts:client:openBoard", serverId, job, location, boardId, extraData)
end)

-- Add a set of players to a contract and immediately start it
exports("StartContractWithPlayers", function(contractId, playerServerIds, runtimeSettings)
    if type(contractId) ~= "string" then
        return false, "Invalid contract ID"
    end
    if type(playerServerIds) ~= "table" or #playerServerIds == 0 then
        return false, "playerServerIds must be a non-empty array"
    end

    local contract = Registry:GetContract(contractId)
    if not contract then return false, "Contract not found" end

    if contract.status ~= Settings.status.WAITING and contract.status ~= Settings.status.READY then
        return false, "Contract is not accepting players"
    end
    if #playerServerIds > contract.maxPlayers then
        return false, "Too many players for this contract"
    end

    -- Add each player to the contract
    for i, serverId in ipairs(playerServerIds) do
        local identifier = GetPlayerUniqueIdentifier(serverId)
        if not identifier then
            return false, "Could not get identifier for player " .. serverId
        end

        -- Reject if already in a different contract
        local existingContract = Registry:GetPlayerContract(identifier)
        if existingContract and existingContract.id ~= contractId then
            return false, "Player " .. serverId .. " is already in another contract"
        end

        if not contract:HasPlayer(identifier) then
            local name = exports.kq_link:GetPlayerCharacterName(serverId)
                         or GetPlayerName(serverId)
                         or "Unknown"
            local now = os.time()
            contract.players[identifier] = {
                joinedAt = now,
                lastSeen = now,
                online   = true,
                name     = name,
                serverId = serverId,
            }
            -- First player becomes leader
            if i == 1 and not contract.leaderId then
                contract.leaderId = identifier
            end
        end
    end

    -- Promote to READY if minimum reached
    if contract:GetPlayerCount() >= contract.minPlayers then
        contract.status = Settings.status.READY
    end

    -- Force start immediately
    contract.settings         = runtimeSettings or {}
    contract.status           = Settings.status.IN_PROGRESS
    contract.currentStepIndex = 1
    contract.startedAt        = GetGameTimer()

    local firstStep = contract:GetCurrentStep()
    if firstStep then
        for _, taskIndex in ipairs(firstStep.taskIndices) do
            contract.tasks[taskIndex]:Start()
        end
    end

    if contract.onStart then
        local onlineIds    = contract:GetOnlineServerIds()
        local callbackData = contract:GetCallbackData()
        local result       = contract.onStart(callbackData, onlineIds)
        if type(result) == "table" then
            if result.data then contract.data = result.data end
            if result.vars then contract.vars = result.vars end
        end
    end

    Registry:SyncToContractMembers(contract)
    Registry:NotifyViewersForJob(contract.job)
    return true, contract:GetCallbackData()
end)

-- Return job stats + level data for a player by server ID
exports("GetPlayerJobStats", function(serverId, job)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then return nil end

    local cacheKey = "DB.GetPlayerJobStats" .. identifier .. job
    local stats = UseCache(cacheKey, function()
        return DB.GetPlayerJobStats(identifier, job)
    end, 120000)

    local levelData = CalculateLevelFromXp(stats.xp)
    return {
        xp             = stats.xp,
        jobs_finished  = stats.jobs_finished,
        level          = levelData.level,
        xpIntoLevel    = levelData.xpIntoLevel,
        xpForNextLevel = levelData.xpForNextLevel,
        progress       = levelData.progress,
    }
end)

-- ─── Debug Commands ───────────────────────────────────────────────────────────

if Config.debug then
    RegisterCommand("finishtask", function(source, args)
        Debug("FinishTask command started")

        local contract = Registry:GetPlayerContractByServerId(source)
        if not contract then
            Debug("Player " .. source .. " is not in a contract")
            return
        end

        if contract.status ~= Settings.status.IN_PROGRESS then
            Debug("Contract is not in progress (status: " .. contract.status .. ")")
            return
        end

        local tasks = contract:GetCurrentTasks()
        if not tasks or #tasks == 0 then
            Debug("No active tasks to finish")
            return
        end

        Debug(string.format("Finishing %d active task(s) for player %d...", #tasks, source))

        for _, task in ipairs(tasks) do
            if task.status == Settings.taskStatus.ACTIVE then
                local ok, err = exports.kq_jobcontracts:FinishTask(task.id)
                if ok then
                    Debug("  ✓ Finished task: " .. task.name .. " (ID: " .. task.id .. ")")
                else
                    Debug("  ✗ Failed to finish task " .. task.name .. ": " .. tostring(err))
                end
            end
        end
    end, true)
end