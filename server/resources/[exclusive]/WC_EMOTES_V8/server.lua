local requests = {}

RegisterServerEvent("ServerEmoteRequest")
AddEventHandler("ServerEmoteRequest", function(target, emotename, etype)
    local source = source
    requests[target] = { requester = source, emote = emotename, type = etype }
    TriggerClientEvent("ClientEmoteRequestReceive", target, emotename, etype, source)
end)

RegisterServerEvent("mrl:ServerValidEmote")
AddEventHandler("mrl:ServerValidEmote", function(otheremote)
    local source = source
    if requests[source] then
        local requester = requests[source].requester
        local requestedemote = requests[source].emote
        TriggerClientEvent("SyncPlayEmote", source, otheremote, requester)
        TriggerClientEvent("SyncPlayEmoteSource", requester, requestedemote, source)
        requests[source] = nil
    end
end)

RegisterServerEvent("ServerEmoteCancel")
AddEventHandler("ServerEmoteCancel", function(target)
    local source = source
    TriggerClientEvent("SyncCancelEmote", target, source)
end)
