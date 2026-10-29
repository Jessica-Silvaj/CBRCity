for _,Name in ipairs({ "requestRobberies","saveRobbery","deleteRobbery","requestRobberyPoints","saveRobberyPoint","deleteRobberyPoint","requestHouses","saveHouse","requestStocks","saveStock","requestBlips","saveBlip","deleteBlip" }) do
    local Event = Name
    RegisterNUICallback(Event,function(Data,Callback)
        TriggerServerEvent("Night_Management:"..Event,Data)
        Callback("ok")
    end)
end

RegisterNUICallback("houseHere",function(Data,Callback)
    local Coords = GetEntityCoords(PlayerPedId())
    Callback({ X = Coords.x,Y = Coords.y,Z = Coords.z })
end)

RegisterNetEvent("Night_Management:catalog",function(Name,Data)
    SendNUIMessage({ action = "update"..Name,data = Data })
end)

-- Marcações no mapa do painel gestor
local MapBlips = {}

RegisterNetEvent("Night_Management:blips",function(Entries)
    for _,Blip in pairs(MapBlips) do
        if DoesBlipExist(Blip) then RemoveBlip(Blip) end
    end
    MapBlips = {}

    for _,v in ipairs(Entries or {}) do
        local Blip = AddBlipForCoord(v.X + 0.0,v.Y + 0.0,v.Z + 0.0)
        SetBlipSprite(Blip,v.Sprite)
        SetBlipColour(Blip,v.Color)
        SetBlipScale(Blip,v.Scale + 0.0)
        SetBlipDisplay(Blip,4)
        SetBlipAsShortRange(Blip,v.ShortRange == true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.Name)
        EndTextCommandSetBlipName(Blip)
        MapBlips[#MapBlips + 1] = Blip
    end
end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(500) end
    TriggerServerEvent("Night_Management:loadBlips")
end)
