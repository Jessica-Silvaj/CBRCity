-- Handles syncing server contract state to the client-side proxy and NUI
StateSyncManager = {}

-- Initialize the manager
function StateSyncManager.Init(self)
    Debug("StateSyncManager initialized")
end

-- Called whenever the player's active contract state changes (server sync)
-- prevContract: previous active contract (or nil), newContractData: new data from server (or nil)
function StateSyncManager.OnPlayerStateChanged(self, newContractData)
    local prevContract      = JobContractProxy.GetActive()
    local prevWasInProgress = prevContract and prevContract.status == Settings.status.IN_PROGRESS

    -- Determine state change and update log ID for debug
    local debugId
    if newContractData and newContractData.id then
        debugId = newContractData.id
    else
        debugId = "nil"
    end
    Debug("StateSyncManager: Player.state changed -", debugId)

    -- Track what properties changed
    local changedProperties = nil

    if newContractData then
        if prevContract and prevContract.id == newContractData.id then
            -- Same contract — update existing proxy
            changedProperties = prevContract:_updateProperties(newContractData)
        else
            -- New contract arrived
            JobContractProxy._setActive(newContractData)
        end
    else
        -- No contract — clear the proxy
        JobContractProxy._setActive(nil)
    end

    local activeContract      = JobContractProxy.GetActive()
    local activeWasInProgress = activeContract and activeContract.status == Settings.status.IN_PROGRESS

    -- Notify task lifecycle manager of changes
    if activeContract and activeContract:IsInProgress() then
        TaskLifecycleManager:HandleContractUpdate(prevContract, activeContract)
    elseif prevContract and not activeContract then
        TaskLifecycleManager:CleanupContract(prevContract)
    end

    self:SendToNUI(activeContract)
    self:HandleNavigation(prevContract, activeContract, prevWasInProgress, activeWasInProgress)
end

-- Send the current active contract state to the NUI
-- Sends nil if there is no active contract (clears the HUD)
function StateSyncManager.SendToNUI(self, contract)
    if not contract then
        Debug("StateSyncManager: Sending nil to NUI (clearing active contract)")
        SendNUIMessage({ type = "setActiveContract", contract = nil })
        return
    end

    local myIdentifier = GetMyIdentifier()

    -- Build player list for NUI
    local players = {}
    for identifier, playerData in pairs(contract.players or {}) do
        table.insert(players, {
            identifier = identifier,
            name       = playerData.name or "Unknown",
            online     = playerData.online,
            isLeader   = playerData.isLeader or false,
            isMe       = myIdentifier and identifier == myIdentifier,
            joinedAt   = playerData.joinedAt or 0,
            serverId   = playerData.serverId,
        })
    end

    -- Build task list for NUI (only public task fields)
    local tasks = {}
    for _, task in ipairs(contract.tasks or {}) do
        table.insert(tasks, {
            index     = task.index,
            id        = task.id,
            name      = task.name,
            type      = task.type,
            status    = task.status,
            stepIndex = task.stepIndex,
            hidden    = task.hidden,
        })
    end

    -- Build the full NUI contract payload
    local nuiContract = {
        id               = contract.id,
        name             = contract.name,
        description      = contract.description,
        status           = contract.status,
        reward           = contract.reward,
        rewardPerPlayer  = contract.rewardPerPlayer,
        playerCount      = contract.playerCount,
        maxPlayers       = contract.maxPlayers,
        minPlayers       = contract.minPlayers,
        currentStepIndex = contract.currentStepIndex,
        leaderId         = contract.leaderId,
        canStart         = contract.canStart,
        players          = players,
        tasks            = tasks,
        steps            = contract.steps or {},
        metadata         = contract.metadata,
        settings         = contract.settings,
        isLeader         = myIdentifier and contract.leaderId == myIdentifier,
    }

    Debug("StateSyncManager: Sending to NUI -", nuiContract.id,
          "with", #players, "players,", #tasks, "tasks")

    SendNUIMessage({ type = "setActiveContract", contract = nuiContract })
    SendNUIMessage({ type = "set-styling", colors = Config.uiStyling })
end

-- Handle NUI navigation based on contract state transitions
function StateSyncManager.HandleNavigation(self, prevContract, newContract, prevWasInProgress, nowInProgress)
    if not NUIManager.isOpen then return end
    if NUIManager.isShowingCompletion then
        Debug("StateSyncManager: Completion summary active, skipping navigation")
        return
    end

    -- Contract just started (board was open) → close the board
    if not prevWasInProgress and nowInProgress then
        Debug("StateSyncManager: Contract started, closing board")
        NUIManager:Close()
        return
    end

    -- New contract arrived while board is open → navigate to it
    if not prevContract and newContract then
        Debug("StateSyncManager: Navigating to contract", newContract.id)
        NUIManager:NavigateToContract(newContract.id)
        return
    end

    -- Contract ended while board is open → go back to home
    if prevContract and not newContract then
        Debug("StateSyncManager: Navigating to home")
        NUIManager:NavigateToHome()
    end
end