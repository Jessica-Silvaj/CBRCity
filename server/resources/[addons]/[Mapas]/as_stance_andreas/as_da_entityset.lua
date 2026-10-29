local interiors = {
    {
        ipl = 'as_drift_antenna_milo_', 
        coords = { x = 756.657, y = 1293.471, z = 365.309 },
        entitySets = {
            

            { name = 'mech_zone', enable = false }, -- main mechanic area
            { name = 'merch_shelves', enable = false }, -- shelves with clothing and auto parts
            { name = 'paint_booth', enable = true }, -- paint booth
            { name = 'lift_demonoil', enable = true }, -- main car lift in demonoil booth
            { name = 'lift_mechanic', enable = false }, -- secondary car lift in mechanic area

        },
    },
}

CreateThread(function()
    for _, interior in ipairs(interiors) do
        if not interior.ipl or not interior.coords or not interior.entitySets then
            print('^5[AS_MLO]^7 ^1Error while loading interior.^7')
            return
        end
        RequestIpl(interior.ipl)
        local interiorID = GetInteriorAtCoords(interior.coords.x, interior.coords.y, interior.coords.z)
        if IsValidInterior(interiorID) then
            for __, entitySet in ipairs(interior.entitySets) do
                if entitySet.enable then
                    EnableInteriorProp(interiorID, entitySet.name)
                    if entitySet.color then
                        SetInteriorPropColor(interiorID, entitySet.name, entitySet.color)
                    end
                else
                    DisableInteriorProp(interiorID, entitySet.name)
                end
            end
            RefreshInterior(interiorID)
        end
    end
    print("^5[AS_MLO]^7 Interiors datas loaded.")
end)