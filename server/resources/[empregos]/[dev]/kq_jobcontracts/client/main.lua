-- Client entry point: initialization, net events, and public exports

local isReady          = false   -- true once the player's network session is active
local myIdentifier     = nil     -- player's unique identifier (set by server)
local activeContractData = nil   -- raw last-synced contract data (for debug)
local statsCache       = {}      -- jobName -> cached player stats table

-- Wait for the network session to be ready, then initialize managers
CreateThread(function()
    Citizen.Wait(500)
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    isReady = true
    StateSyncManager:Init()
    TaskLifecycleManager:Init()
end)

-- ============================================================
-- Net events
-- ============================================================

-- Server sends the player's unique identifier on spawn
RegisterNetEvent("kq_jobcontracts:client:setIdentifier", function(identifier)
    myIdentifier = identifier
    Debug("Client identifier set to:", identifier)
end)

-- Server pushes the player's active contract state (or nil to clear it)
RegisterNetEvent("kq_jobcontracts:client:syncContract", function(contractData)
    if not isReady then return end
    activeContractData = contractData

    local debugLabel = contractData and ("Contract " .. (contractData.id or -1)) or "nil"
    Debug("Contract synced:", debugLabel)

    StateSyncManager:OnPlayerStateChanged(contractData)
end)

-- Server pushes an updated list of available contracts for the open board
RegisterNetEvent("kq_jobcontracts:client:contractListUpdated", function(contracts)
    Debug("Contract list updated -", #contracts, "contracts")
    NUIManager:UpdateContractList(contracts)
end)

-- Server notifies that a contract was completed; show the summary screen
-- El servidor envía (summary, playerReward):
--   summary     = datos del contrato (nombre, duracion, reward base, etc.)
--   playerReward = datos del jugador (stars, totalAmount, bonuses, xp, etc.)
RegisterNetEvent("kq_jobcontracts:client:contractCompleted", function(summary, playerReward)
    Debug("Contract completed -", summary.contractName)

    -- Construir completionData fusionando ambos objetos
    local completionData        = summary
    completionData.summary      = playerReward
    -- Subir campos de playerReward al nivel raíz para que la GUI los encuentre
    if playerReward then
        completionData.stars          = playerReward.stars
        completionData.totalAmount    = playerReward.totalAmount
        completionData.data           = playerReward.data
        completionData.notes          = playerReward.notes
        completionData.xpGained       = playerReward.xp or 0
        completionData.rewardPerPlayer = playerReward.rewardPerPlayer
    end

    -- Update local stats cache with the XP gained
    if completionData.xpGained and completionData.xpGained > 0 and completionData.job then
        UpdateCachedStatsWithXp(completionData.job, completionData.xpGained)

        local updatedStats = GetCachedPlayerStats(completionData.job)
        if updatedStats then
            SendNUIMessage({
                type        = "setPlayerStats",
                stats       = updatedStats,
                unlocks     = NUIManager.currentUnlocks or {},
                headshotUrl = HeadshotManager:GetNuiUrl(),
            })
        end
    end

    NUIManager:OpenCompletionSummary(completionData)
end)

-- Server requests the client to open the contract board directly
RegisterNetEvent("kq_jobcontracts:client:openBoard", function(jobName, jobLabel, unlocks, settingsConfig)
    NUIManager:OpenBoard(jobName, jobLabel, unlocks, settingsConfig)
end)

-- Local event: update the tasks subtext in the active contract HUD
AddEventHandler("kq_jobcontracts:client:setTasksSubtext", function(subtextData)
    NUIManager:SetTasksSubtext(subtextData)
end)

-- ============================================================
-- Helper functions
-- ============================================================

-- Return the local player's unique identifier (set by server)
function GetMyIdentifier()
    return myIdentifier
end

-- Return the last raw contract data received from the server
function GetActiveContractData()
    return activeContractData
end

-- Fetch player stats for a job from the server and cache locally
function FetchPlayerStats(jobName)
    local stats = exports.kq_link:TriggerServerCallback(
        "kq_jobcontracts:callback:getPlayerStats", jobName
    )
    if stats then
        statsCache[jobName] = stats
    end
    return stats
end

-- Return cached player stats for a job (nil if not fetched yet)
function GetCachedPlayerStats(jobName)
    return statsCache[jobName]
end

-- Apply an XP gain to the local stats cache (optimistic update before server confirms)
function UpdateCachedStatsWithXp(jobName, xpGained)
    local stats = statsCache[jobName]
    if not stats then return end

    stats.xp            = math.floor(stats.xp + xpGained)
    stats.jobs_finished = stats.jobs_finished + 1

    local levelData      = CalculateLevelFromXp(stats.xp)
    stats.level          = levelData.level
    stats.xpIntoLevel    = math.floor(levelData.xpIntoLevel)
    stats.xpForNextLevel = math.floor(levelData.xpForNextLevel)
    stats.progress       = levelData.progress
end

-- ============================================================
-- Exports
-- ============================================================

-- Register a task type handler (namespaced to the invoking resource)
exports("RegisterTaskType", function(typeName, handler)
    local invoker = GetInvokingResource()
    local fullName = invoker and (invoker .. ":" .. typeName) or typeName
    TaskTypes.Register(fullName, handler)
end)

-- Return cached or freshly fetched player stats for a job
exports("GetPlayerJobStats", function(jobName)
    if type(jobName) ~= "string" or jobName == "" then return nil end
    return GetCachedPlayerStats(jobName) or FetchPlayerStats(jobName)
end)

-- Return all contracts for a job (including in-progress ones)
exports("GetAll", function(jobName)
    if type(jobName) ~= "string" or jobName == "" then return {} end
    return exports.kq_link:TriggerServerCallback(
        "kq_jobcontracts:callback:getContractList", jobName
    ) or {}
end)

-- Return only joinable (WAITING / READY) contracts for a job
exports("GetAvailable", function(jobName)
    if type(jobName) ~= "string" or jobName == "" then return {} end
    local all = exports.kq_link:TriggerServerCallback(
        "kq_jobcontracts:callback:getContractList", jobName
    ) or {}

    local result = {}
    for _, contract in ipairs(all) do
        local s = contract.status
        if s == Settings.status.WAITING or s == Settings.status.READY then
            table.insert(result, contract)
        end
    end
    return result
end)

-- Return a lightweight summary of a contract by ID (fetches from server if needed)
exports("Find", function(contractId)
    local contract = JobContractProxy.Find(contractId)
    if not contract then return nil end

    return {
        id               = contract.id,
        name             = contract.name,
        status           = contract.status,
        playerCount      = contract.playerCount,
        maxPlayers       = contract.maxPlayers,
        currentStepIndex = contract.currentStepIndex,
        taskCount        = contract:GetTaskCount(),
    }
end)

-- Return the active contract's public state (or nil)
exports("GetActive", function()
    local contract = JobContractProxy.GetActive()
    if not contract then return nil end

    local currentTask  = contract:GetCurrentTask()
    local currentTasks = contract:GetCurrentTasks()

    -- Serialize current tasks to plain tables
    local activeTaskList = {}
    for _, task in ipairs(currentTasks) do
        table.insert(activeTaskList, {
            index  = task.index,
            name   = task.name,
            type   = task.type,
            status = task.status,
            vars   = task.vars,
        })
    end

    -- Serialize the primary current task (or nil)
    local currentTaskData = nil
    if currentTask then
        currentTaskData = {
            index  = currentTask.index,
            name   = currentTask.name,
            type   = currentTask.type,
            status = currentTask.status,
            vars   = currentTask.vars,
        }
    end

    return {
        id               = contract.id,
        name             = contract.name,
        status           = contract.status,
        playerCount      = contract.playerCount,
        currentStepIndex = contract.currentStepIndex,
        taskCount        = contract:GetTaskCount(),
        currentTask      = currentTaskData,
        activeTasks      = activeTaskList,
    }
end)

-- Return true if the local player is currently in a contract
exports("IsInContract", function()
    return JobContractProxy.IsInContract()
end)

-- Join a contract by ID; returns true on success
exports("Join", function(contractId)
    local contract = JobContractProxy.Find(contractId)
    if contract then
        contract:Join()
        return true
    end
    return false
end)

-- Leave a contract by ID; returns true on success
exports("Leave", function(contractId)
    local contract = JobContractProxy.Find(contractId)
    if contract then
        contract:Leave()
        return true
    end
    return false
end)

-- Start a contract by ID; returns true on success
exports("Start", function(contractId)
    local contract = JobContractProxy.Find(contractId)
    if contract then
        contract:Start()
        return true
    end
    return false
end)

-- Finish a task by task object or task ID string.
-- Enforces a 5-second cooldown between finish attempts for the same task.
exports("FinishTask", function(taskOrId)
    -- Accept either a task table (with .id) or a raw ID string
    local taskId = (type(taskOrId) == "table") and taskOrId.id or taskOrId
    if type(taskId) ~= "string" then return false end

    -- Enforce per-task cooldown
    local activeContract = JobContractProxy.GetActive()
    if activeContract then
        local task = activeContract:FindTaskById(taskId)
        if task then
            local now = GetGameTimer()
            if task.lastFinishAttempt and (now - task.lastFinishAttempt) < 5000 then
                return false
            end
            task.lastFinishAttempt = now
        end
    end

    TriggerServerEvent("kq_jobcontracts:server:finishTask", taskId)
    return true
end)

-- Copy a string to the player's clipboard via NUI
exports("CopyToClipboard", function(text)
    if type(text) ~= "string" then return false end
    SendNUIMessage({ action = "copyToClipboard", text = text })
    return true
end)

-- ============================================================
-- Debug commands (only registered when Config.debug = true)
-- ============================================================
if Config.debug then
    RegisterCommand("contracts", function()
        print("=== Contracts ===")
        print("Use server command 'listcontracts' to see all contracts")
    end, false)

    RegisterCommand("debugstate", function()
        print("=== Debug State ===")
        local raw = GetActiveContractData()
        if raw then
            print("activeContractData:")
            print("  Contract ID:",   raw.id   or "nil")
            print("  Contract Name:", raw.name  or "nil")
            print("  Status:",        raw.status or "nil")
        else
            print("activeContractData is nil")
        end

        local proxy = JobContractProxy.GetActive()
        if proxy then
            print("JobContractProxy.GetActive():")
            print("  Contract ID:",   proxy.id)
            print("  Contract Name:", proxy.name)
            print("  Status:",        proxy.status)
        else
            print("JobContractProxy.GetActive() is nil")
        end
    end, false)

    RegisterCommand("mycontract", function()
        local contract = JobContractProxy.GetActive()
        if not contract then
            return print("Not in any contract")
        end
        print(string.format(
            "Contract: %s (%s) - %s - %d/%d - Step %d/%d (%d tasks)",
            contract.name, contract.id, contract.status,
            contract.playerCount, contract.maxPlayers,
            contract.currentStepIndex, #contract.steps, #contract.tasks
        ))
        local tasks = contract:GetCurrentTasks()
        if #tasks > 0 then
            print(string.format("Active tasks: %d", #tasks))
            for _, task in ipairs(tasks) do
                print(string.format("  [%d] %s (%s) - %s",
                    task.index, task.name, task.type, task.status))
            end
        end
    end, false)

    RegisterCommand("clearstate", function()
        print("Clearing local contract state...")
        JobContractProxy._setActive(nil)
        TaskLifecycleManager.activeTasks      = {}
        TaskLifecycleManager.previousStepIndex = 0
        print("Local state cleared")
    end, false)

    RegisterCommand("joincontract", function(source, args)
        if args[1] then
            local contract = JobContractProxy.Find(args[1])
            if contract then
                contract:Join()
            else
                print("Not found")
            end
        else
            print("Usage: /joincontract <contractId>")
            print("Use 'listcontracts' in server console to see available contracts")
        end
    end, false)

    RegisterCommand("leavecontract", function()
        local contract = JobContractProxy.GetActive()
        if contract then contract:Leave() else print("Not in contract") end
    end, false)

    RegisterCommand("startcontract", function()
        local contract = JobContractProxy.GetActive()
        if contract then contract:Start() else print("Not in contract") end
    end, false)
end