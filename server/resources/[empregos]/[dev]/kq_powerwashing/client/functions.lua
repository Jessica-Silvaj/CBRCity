-- Data: cached accessors for frequently-needed local player state
Data = {}

-- Return the player ped's current world coordinates (cached 500ms)
function Data.coords()
    return UseCache("player_coords", function()
        return GetEntityCoords(PlayerPedId())
    end, 500)
end

-- Return the vehicle the player is currently in (0 if on foot, cached 500ms)
function Data.vehicle()
    return UseCache("player_vehicle", function()
        return GetVehiclePedIsIn(PlayerPedId(), false)
    end, 500)
end

-- Return the local player ped handle (cached 1000ms)
function Data.ped()
    return UseCache("player_ped", function()
        return PlayerPedId()
    end, 1000)
end