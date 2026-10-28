local interiorCoords = vector3(-219.719025, -1338.33691, 38.2293968)
local interiorName = "horizon_bennys_mlo"
local enableLift = true
local propColor = 0

Citizen.CreateThread(function()
    local interiorId = GetInteriorAtCoordsWithType(interiorCoords.x, interiorCoords.y, interiorCoords.z, interiorName)
    
    if not interiorId or interiorId == 0 then
        return
    end
    
    if enableLift then
        EnableInteriorProp(interiorId, "carlift")
    else
        DisableInteriorProp(interiorId, "carlift")
    end
    
    EnableInteriorProp(interiorId, "mechprops")
    SetInteriorPropColor(interiorId, "mechprops", propColor)
    RefreshInterior(interiorId)
end)

CreateThread(function()
    local interiorId = GetInteriorAtCoordsWithType(-209.759, -1319.61707, 30.0836735, "lr_supermod_int")
    
    if interiorId and interiorId ~= 0 then
        DisableInterior(interiorId, true)
        UnpinInterior(interiorId)
    end
end)
