ESX, QBCore = nil

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "QBCore" then
    QBCore = exports["qb-core"]:GetCoreObject()
end

function showHelpNotification(text)
    -- call export or trigger event to show a notification
    if Config.Framework == "ESX" then
        ESX.ShowHelpNotification(text)
    elseif Config.Framework == "QBCore" then
        QBCore.Functions.Notify(text, "primary")
    elseif Config.Framework == "vRP" then
        TriggerEvent("inventory:Buttons", {{ Letter = "E", Text = text }})
    end
end

function hideHelpNotification()
    -- call export or trigger event to hide a notification
    if Config.Framework == "vRP" then
        TriggerEvent("inventory:CloseButtons")
    end
end

-- @param duration: Duration in seconds for the progress bar
-- @param text: Text to display on the progress bar
function startProgress(duration, text)
    -- call export or trigger event to start a progress bar

    showProgress(text, duration)
end

function notify(text, type)
    -- call export or trigger event to show a notification

    if Config.Framework == "ESX" then
        ESX.ShowNotification(text)
    elseif Config.Framework == "QBCore" then
        QBCore.Functions.Notify(text, type)
    elseif Config.Framework == "vRP" then
        local color = type == "error" and "vermelho" or type == "success" and "verde" or "default"
        TriggerEvent("Notify", "Trem", text, color, 5000)
    end
end

function addTarget(entity, name, mode)
    exports["ox_target"]:addLocalEntity(entity, {
        name = name,
        label = "Iniciar trabalho",
        distance = 2.5,
        icon = "fa-solid fa-train",
        onSelect = function(data)
            TriggerServerCallback("xorgynoth:jobsLimit", function(result)
                if result then
                    if Config.XPSystem then
                        TriggerEvent("saltytrains:showJobStartUI", mode)
                    else
                        TriggerEvent("saltytrains:startJob", mode) -- This will directly start the job without showing the UI
                    end
                else
                    notify("Você não pode iniciar uma nova viagem agora.", "error")
                end
            end)
        end,
    })
end

function DrawMissionText(msg, time)
    ClearPrints()
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, true)
end

function showProgress(text, duration)
    if not text or not duration then return end

    Citizen.CreateThread(function()
        for i = 0, duration do
            Citizen.Wait(1000)
            DrawMissionText(text .. " ~r~(" .. (duration - i) .. "s)~s~", 1000)
        end
    end)
end

local callbackCounter = 0
local pendingCallbacks = {}

function TriggerServerCallback(name, cb, ...)
    if Config.Framework == "ESX" then
        ESX.TriggerServerCallback(name, cb, ...)
    elseif Config.Framework == "QBCore" then
        QBCore.Functions.TriggerCallback(name, cb, ...)
    elseif Config.Framework == "vRP" then
        callbackCounter = callbackCounter + 1
        pendingCallbacks[callbackCounter] = cb
        TriggerServerEvent("saltytrains:callback:" .. name, callbackCounter, ...)
    end
end

-- A NUI pede a configuração visual ao carregar
RegisterNUICallback("nuiReady", function(data, cb)
    cb({ ok = true })
    SendNUIMessage({ action = "train:getConfig", data = Config.UI })
end)

RegisterNetEvent("saltytrains:callbackResult", function(requestId, ...)
    local cb = pendingCallbacks[requestId]
    if cb then
        pendingCallbacks[requestId] = nil
        cb(...)
    end
end)
