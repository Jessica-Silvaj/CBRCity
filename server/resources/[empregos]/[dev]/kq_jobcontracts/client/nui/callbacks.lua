-- NUI Callbacks: bridge between the NUI frontend and client-side Lua logic

-- Return all UI locale strings to the NUI
RegisterNUICallback("fetch-locale", function(data, cb)
    cb({ success = true, data = L("ui") })
end)

-- Return HUD and UI config to the NUI
RegisterNUICallback("fetch-config", function(data, cb)
    cb({ success = true, data = { hud = Config.hud, ui = Config.ui } })
end)

-- Close the contract board
RegisterNUICallback("exit", function(data, cb)
    NUIManager:Close()
    cb({ success = true })
end)

-- Join a contract by ID
RegisterNUICallback("joinContract", function(data, cb)
    if not data.contractId then
        cb({ success = false })
        return
    end
    TriggerServerEvent("kq_jobcontracts:server:join", data.contractId)
    cb({ success = true })
end)

-- Leave the current contract
RegisterNUICallback("leaveContract", function(data, cb)
    if not data.contractId then
        cb({ success = false })
        return
    end
    TriggerServerEvent("kq_jobcontracts:server:leave", data.contractId)
    cb({ success = true })
end)

-- Start a contract (leader only)
RegisterNUICallback("startContract", function(data, cb)
    if not data.contractId then
        cb({ success = false })
        return
    end
    TriggerServerEvent("kq_jobcontracts:server:start", data.contractId, data.settingsValues)
    cb({ success = true })
end)

-- Kick a player from the contract (leader only)
RegisterNUICallback("kickPlayer", function(data, cb)
    if not data.contractId or not data.targetServerId then
        cb({ success = false })
        return
    end
    TriggerServerEvent("kq_jobcontracts:server:kick", data.contractId, data.targetServerId)
    cb({ success = true })
end)

-- Acknowledge that the NUI has finished loading
RegisterNUICallback("nuiLoaded", function(data, cb)
    cb({ success = true })
end)

-- Close the board after a contract is finished
RegisterNUICallback("finishContract", function(data, cb)
    NUIManager:Close()
    cb({ success = true })
end)

-- Export: open the contract board for a given job
exports("OpenBoard", function(source, jobName, jobLabel, settingsConfig)
    return NUIManager:OpenBoard(source, jobName, jobLabel, settingsConfig)
end)

-- Debug command: open the board with dummy data (/cb [jobName] [jobLabel])
if Config.debug then
    RegisterCommand("cb", function(source, args)
        local jobName   = args[1] or "delivery"
        local jobLabel  = args[2] or jobName
        local unlocks   = {
            [5]  = "Vehicle upgrade!",
            [10] = "New work outfit!",
            [20] = "5% income bonus",
        }
        NUIManager:OpenBoard(source, jobName, jobLabel, unlocks)
    end, false)
end