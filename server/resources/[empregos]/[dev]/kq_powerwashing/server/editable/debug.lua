
RegisterCommand(GetCurrentResourceName() .. ':restart', function(source)
    local _source = source

    Citizen.Wait(100)
    TriggerClientEvent(GetCurrentResourceName() .. ':client:safeRestart', -1, _source)
end, true)
