function GetPlayerUniqueIdentifier(player)
    local id = exports.kq_link:GetPlayerCharacterId(player)
    
    if id and type(id) == 'string' then
        return id
    end

    -- Fallback, use native license
    return GetPlayerIdentifierByType(player, 'license')
end
