-- Central registry holding all active contracts, viewer subscriptions, and player cooldowns
Registry = {
    contracts      = {},
    playerCooldowns = {},
    viewers        = {},
}

-- Send a contract sync event to a specific player
function Registry.SyncToPlayer(self, playerId, contractData)
    TriggerClientEvent("kq_jobcontracts:client:syncContract", playerId, contractData)
end

-- (Re)initialize the registry tables
function Registry.Init(self)
    self.contracts       = {}
    self.playerCooldowns = {}
    self.viewers         = {}
    Debug("Registry initialized")
end

-- Check and update a per-player cooldown for a given action
-- Returns true if the action is allowed, false if still on cooldown
function Registry.CheckCooldown(self, identifier, actionName)
    local rateLimit = Settings.rateLimits[actionName]
    if not rateLimit or rateLimit <= 0 then
        return true
    end

    local now = GetGameTimer()

    -- Ensure per-player cooldown table exists
    if not self.playerCooldowns[identifier] then
        self.playerCooldowns[identifier] = {}
    end

    local lastUsed = self.playerCooldowns[identifier][actionName] or 0
    local elapsed  = now - lastUsed

    if rateLimit > elapsed then
        return false  -- still on cooldown
    end

    -- Update timestamp and allow
    self.playerCooldowns[identifier][actionName] = now
    return true
end

-- Create a new contract and register it; notifies viewers
-- Returns (contract, nil) on success, (nil, errorMsg) on failure
function Registry.CreateContract(self, contractDef, extraData)
    local contract, err = JobContract.new(contractDef, extraData)
    if not contract then
        return nil, err
    end

    self.contracts[contract.id] = contract
    self:NotifyViewersForJob(contract.job)
    return contract, nil
end

-- Get a contract by its ID
function Registry.GetContract(self, contractId)
    return self.contracts[contractId]
end

-- Get all active contracts
function Registry.GetAllContracts(self)
    return self.contracts
end

-- Find the contract a given player identifier is part of
function Registry.GetPlayerContract(self, identifier)
    for _, contract in pairs(self.contracts) do
        if contract:HasPlayer(identifier) then
            return contract
        end
    end
    return nil
end

-- Find a player's contract by server ID (resolves identifier first)
function Registry.GetPlayerContractByServerId(self, serverId)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then return nil end
    return self:GetPlayerContract(identifier)
end

-- Remove a contract by ID, sync nil to all online members, and notify viewers
function Registry.RemoveContract(self, contractId)
    local contract = self.contracts[contractId]
    if not contract then return false end

    local job = contract.job

    -- Notify all online members that the contract is gone
    for identifier, playerData in pairs(contract.players) do
        if playerData.online then
            local serverId = contract:GetServerIdFromIdentifier(identifier)
            if serverId then
                self:SyncToPlayer(serverId, nil)
            end
        end
    end

    self.contracts[contractId] = nil
    self:NotifyViewersForJob(job)
    return true
end

-- Subscribe a player to receive contract list updates for a job
function Registry.AddViewer(self, playerId, job)
    if not self.viewers[job] then
        self.viewers[job] = {}
    end
    self.viewers[job][playerId] = true
    Debug("Viewer added:", playerId, "for job:", job)
end

-- Unsubscribe a player from contract list updates for a job
function Registry.RemoveViewer(self, playerId, job)
    if self.viewers[job] then
        self.viewers[job][playerId] = nil
        Debug("Viewer removed:", playerId, "for job:", job)
    end
end

-- Push the current available contract list for a job to all subscribed viewers
function Registry.NotifyViewersForJob(self, job)
    Debug("Notify viewers now")
    local viewers = self.viewers[job]
    if not viewers then return end

    -- Collect lightweight data for contracts that are WAITING or READY
    local contractList = {}
    for _, contract in ipairs(self:GetContractsForJob(job)) do
        local status = contract.status
        if status == Settings.status.WAITING or status == Settings.status.READY then
            local lightData = contract:GetLightweightData()
            table.insert(contractList, lightData)
        end
    end

    -- Send updated list to every viewer
    for viewerId in pairs(viewers) do
        Debug("updating viewers now")
        TriggerClientEvent("kq_jobcontracts:client:contractListUpdated", viewerId, contractList)
    end
end

-- Sync a contract's full data to all online members
function Registry.SyncToContractMembers(self, contract)
    Debug("Syncing contract to members")
    local clientData = contract:GetClientData()
    for identifier, playerData in pairs(contract.players) do
        if playerData.online then
            local serverId = contract:GetServerIdFromIdentifier(identifier)
            if serverId then
                self:SyncToPlayer(serverId, clientData)
            end
        end
    end
end

-- Return all contracts that belong to a given job
function Registry.GetContractsForJob(self, job)
    local result = {}
    for _, contract in pairs(self.contracts) do
        if contract.job == job then
            table.insert(result, contract)
        end
    end
    return result
end

-- Remove old completed/cancelled contracts that are older than `maxAgeSeconds`
function Registry.Cleanup(self, maxAgeSeconds)
    local now = os.time()
    local jobsToNotify = {}

    for id, contract in pairs(self.contracts) do
        local status = contract.status
        local isFinished = status == Settings.status.COMPLETED or status == Settings.status.CANCELLED
        if isFinished then
            local age = now - contract.createdAt
            if age > maxAgeSeconds then
                jobsToNotify[contract.job] = true
                self.contracts[id] = nil
            end
        end
    end

    -- Notify viewers for each affected job
    for job in pairs(jobsToNotify) do
        self:NotifyViewersForJob(job)
    end
end

-- Cancel any contracts where all players have abandoned
function Registry.CheckAbandoned(self)
    for _, contract in pairs(self.contracts) do
        if contract:ShouldAbandon() then
            contract:Cancel("All players abandoned")
        end
    end
end

-- Handle a player disconnecting: notify their contract and remove viewer entries
function Registry.HandlePlayerDisconnect(self, serverId)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then return end

    local contract = self:GetPlayerContract(identifier)
    if contract then
        contract:HandlePlayerDisconnect(serverId)
    end

    -- Remove from all viewer lists
    for _, viewerList in pairs(self.viewers) do
        viewerList[serverId] = nil
    end

    self.playerCooldowns[identifier] = nil
end

-- Handle a player reconnecting: notify their contract and re-sync contract data
function Registry.HandlePlayerConnect(self, serverId)
    local identifier = GetPlayerUniqueIdentifier(serverId)
    if not identifier then return end

    local contract = self:GetPlayerContract(identifier)
    if contract then
        contract:HandlePlayerReconnect(serverId)
        local clientData = contract:GetClientData()
        self:SyncToPlayer(serverId, clientData)
    end
end
