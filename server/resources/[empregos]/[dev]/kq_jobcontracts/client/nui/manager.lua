-- NUIManager: controls visibility and state of the contract board NUI
NUIManager = {
    isOpen              = false,
    currentJobName      = nil,
    currentJobLabel     = nil,
    currentUnlocks      = nil,
    currentSettingsConfig = nil,
    isShowingCompletion = false,
}

-- Open the contract board for a given job
-- jobName: internal job identifier (required)
-- jobLabel: display name (optional, defaults to Capitalize(jobName))
-- unlocks: level-unlock table keyed by level number (optional)
-- settingsConfig: extra settings passed to the NUI (optional)
function NUIManager.OpenBoard(self, jobName, jobLabel, unlocks, settingsConfig)
    if not jobName or jobName == "" then
        Debug("^1[JobContracts] Error: OpenBoard requires jobName parameter^7")
        return false
    end

    PlayerReady()
    Debug("NUIManager: Opening board for job", jobName)

    self.currentJobName      = jobName
    self.currentJobLabel     = jobLabel or Capitalize(jobName)
    self.currentUnlocks      = unlocks or {}
    self.currentSettingsConfig = settingsConfig
    self.isOpen              = true

    SetNuiFocus(true, true)
    TriggerServerEvent("kq_jobcontracts:server:startViewing", jobName)

    -- Fetch current contract list for this job
    local contractList = exports.kq_link:TriggerServerCallback("kq_jobcontracts:callback:getContractList", jobName) or {}
    SendNUIMessage({ type = "setContracts",      contracts = contractList })
    SendNUIMessage({ type = "setJobLabel",        jobLabel  = self.currentJobLabel })
    SendNUIMessage({ type = "setSettingsConfig",  config    = self.currentSettingsConfig })

    -- Send player stats and headshot
    local stats      = FetchPlayerStats(jobName)
    local headshotUrl = HeadshotManager:GetNuiUrl()
    SendNUIMessage({
        type        = "setPlayerStats",
        stats       = stats,
        unlocks     = self.currentUnlocks,
        headshotUrl = headshotUrl,
    })

    -- Send UI color theme
    SendNUIMessage({ type = "set-styling", colors = Config.uiStyling })

    -- If already in a contract, navigate directly to it
    local activeContract = JobContractProxy.GetActive()
    local initialPage    = "/"
    if activeContract then
        Debug("NUIManager: Sending existing active contract to NUI")
        StateSyncManager:SendToNUI(activeContract)
        initialPage = "/contract/" .. activeContract.id
    end

    SendNUIMessage({ type = "display", value = true, page = initialPage })
    return true
end

-- Close the contract board and clean up state
function NUIManager.Close(self)
    Debug("NUIManager: Closing board")

    -- Leave the contract lobby if it hasn't started yet
    local activeContract = JobContractProxy.GetActive()
    if activeContract and activeContract.status ~= Settings.status.IN_PROGRESS then
        TriggerServerEvent("kq_jobcontracts:server:leave", activeContract.id)
    end

    SetNuiFocus(false, false)
    SendNUIMessage({ type = "display", value = false })

    -- Unsubscribe from contract list updates
    if self.currentJobName then
        TriggerServerEvent("kq_jobcontracts:server:stopViewing", self.currentJobName)
    end

    self.isOpen               = false
    self.isShowingCompletion  = false
    self.currentJobName       = nil
    self.currentJobLabel      = nil
    self.currentUnlocks       = nil
    self.currentSettingsConfig = nil
end

-- Navigate the NUI to a specific contract's detail page
function NUIManager.NavigateToContract(self, contractId)
    if not self.isOpen then return end
    Debug("NUIManager: Navigating to contract", contractId)
    SendNUIMessage({ type = "navigate", path = "/contract/" .. contractId })
end

-- Navigate the NUI back to the home/list page
function NUIManager.NavigateToHome(self)
    if not self.isOpen then return end
    Debug("NUIManager: Navigating to home")
    SendNUIMessage({ type = "navigate", path = "/" })
end

-- Push subtext data for the active task display
function NUIManager.SetTasksSubtext(self, subtextData)
    SendNUIMessage({ type = "setTasksSubtext", data = subtextData })
end

-- Update the contract list shown in the board
function NUIManager.UpdateContractList(self, contracts)
    if not self.isOpen then return end
    Debug("NUIManager: Updating contract list with", #contracts, "contracts")
    SendNUIMessage({ type = "updateContracts", contracts = contracts })
end

-- Open the post-completion summary screen
function NUIManager.OpenCompletionSummary(self, completionData)
    Debug("NUIManager: Opening completion summary for", completionData.contractName)

    self.isOpen             = true
    self.isShowingCompletion = true

    SetNuiFocus(true, true)
    SendNUIMessage({ type = "set-styling",          colors         = Config.uiStyling })
    SendNUIMessage({ type = "setCompletionSummary", completionData = completionData })
    SendNUIMessage({ type = "display",              value          = true, page = "/completion" })
end

-- Clean up the NUI when this resource stops
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if NUIManager.isOpen then
        NUIManager:Close()
    end
end)