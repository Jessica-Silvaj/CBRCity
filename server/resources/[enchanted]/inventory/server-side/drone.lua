-----------------------------------------------------------------------------------------------------------------------------------------
-- DRONES:DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Drones:Disconnect")
AddEventHandler('Drones:Disconnect', function(drone, drone_data, pos)
    if DroneActive then
        DroneActive[source] = nil
    end

    TriggerClientEvent('Drones:DropDrone', source, drone, drone_data, pos)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRONES:BACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Drones:Back")
-- Só devolve 1 drone para quem realmente está usando um (antes devolvia qualquer item que o client pedisse)
DroneActive = DroneActive or {}

AddEventHandler('Drones:Back', function(drone_data)
	local source = source
	local Passport = vRP.Passport(source)
    if Passport and DroneActive[source] then
        DroneActive[source] = nil
        vRP.GenerateItem(Passport,"drone",1,true)
    end
end)

AddEventHandler("playerDropped",function()
	DroneActive[source] = nil
end)