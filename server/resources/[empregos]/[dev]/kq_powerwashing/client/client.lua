-- client.lua: Entry point — registers vehicle name entries and manages the HQ blip

-- Register localised vehicle names for the GTA map/UI
Citizen.CreateThread(function()
    AddTextEntry("kqbison",    L("vehicles.kqbison"))
    AddTextEntry("kqcaracara", L("vehicles.kqcaracara"))
end)

-- Module-level reference to the HQ map blip
local hqBlip = nil

-- Update the HQ blip: show it if the player has the powerwashing job, hide it otherwise
local function UpdateHQBlip()
    local hasJob  = DoesPlayerHavePowerwashingJob()
    local blipCfg = Config.headquarters.blip

    if hasJob then
        if not hqBlip then
            hqBlip = AddBlipForCoord(Config.headquarters.coords)
            SetBlipSprite(hqBlip, blipCfg.sprite)
            SetBlipDisplay(hqBlip, 4)
            SetBlipScale(hqBlip, blipCfg.scale)
            SetBlipColour(hqBlip, blipCfg.color)
            SetBlipAsShortRange(hqBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(L("headquarters.name"))
            EndTextCommandSetBlipName(hqBlip)
        end
    else
        if hqBlip then
            RemoveBlip(hqBlip)
            hqBlip = nil
        end
    end
end

-- Re-check the blip whenever the player's job changes
AddEventHandler("kq_link:jobUpdated", function()
    UpdateHQBlip()
end)

-- Initial blip setup after resource loads
CreateThread(function()
    Wait(1000)
    UpdateHQBlip()
end)