-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- UI STATUS
-----------------------------------------------------------------------------------------------------------------------------------------
local uiOpen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Night.showOverlay()
    SendNUIMessage({ action = "setVisibility", data = "/overlay" })
end

function openLetters()
    local letters = Server.openPanel()
    if letters then
        SendNUIMessage({ action = "setReceived", data = letters.received })
        SendNUIMessage({ action = "setSent", data = letters.sent })
        SendNUIMessage({ action = "setVisibility", data = "/painel" })
        SendNUIMessage({ action = "setColor", data = Config.interfaceColor })
        SetNuiFocus(true, true)
        uiOpen = true
    end
end

function openLastLetter()
    local lastLetter = Server.getLastLetter()
    if lastLetter then
        SendNUIMessage({ action = "setLetter", data = lastLetter })
        SendNUIMessage({ action = "setVisibility", data = "/letter" })
        SendNUIMessage({ action = "setColor", data = Config.interfaceColor })
        SetNuiFocus(true, true)
        uiOpen = true
    else
        TriggerEvent("Notify", "Erro", "Você não tem nenhuma carta recente para abrir.", "vermelho", 5000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Commands.fullPanel, function()
    openLetters()
end)

RegisterCommand(Config.Commands.lastLetter, function()
    openLastLetter()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("removeFocus", function(data, cb)
    SetNuiFocus(false, false)
    uiOpen = false
    cb("ok")
end)

RegisterNUICallback("sendRomanticMail", function(data, cb)
    local result = Server.sendRomanticMail(data)
    cb(result)
end)

RegisterNUICallback("deleteLetter", function(data, cb)
    local result = Server.deleteLetter(data)
    if result then
        -- Refresh letters after delete
        local letters = Server.getLetters()
        if letters then
            SendNUIMessage({ action = "setReceived", data = letters.received })
            SendNUIMessage({ action = "setSent", data = letters.sent })
        end
    end
    cb("ok")
end)
