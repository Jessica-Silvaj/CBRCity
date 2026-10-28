local isHudVisible = false

function UpdateHUD(data)
    if not isHudVisible then
        SendNUIMessage({ action = "show" })
        isHudVisible = true
    end
    SendNUIMessage({
        action = "update",
        rpm = data.rpm,
        gear = data.gear,
        speed = data.speed,
        mode = data.mode,
        engineHealth = data.engineHealth
    })
end

function HideHUD()
    if isHudVisible then
        SendNUIMessage({ action = "hide" })
        isHudVisible = false
    end
end
