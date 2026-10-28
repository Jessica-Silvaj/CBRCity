local loaded = false
function PlayerReady()
    if loaded then
        return
    end

    TriggerServerEvent('kq_jobcontracts:server:playerReady')
    loaded = true
end

local loadedEvents = {
    'esx:playerLoaded',
    'QBCore:Client:OnPlayerLoaded',
}

for k, event in pairs(loadedEvents) do
    AddEventHandler(event, function (playerId, xPlayer, isNew)
        PlayerReady()
    end)
end

-- Fallback for loaded check when none of the popular framework events fire
CreateThread(function()
    local ped

    while true do
        Wait(100)
        ped = PlayerPedId()
        if DoesEntityExist(ped) then
            break
        end
    end

    Citizen.Wait(5000)

    while true do
        Wait(500)

        ped = PlayerPedId()
        if IsPedOnFoot(ped) and not IsPedStill(ped) then
            PlayerReady()
            break
        end
    end
end)

