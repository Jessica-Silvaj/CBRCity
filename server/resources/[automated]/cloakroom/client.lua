local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

function getCloakroomsData()
    if GetResourceState("Night_Management") == "started" then
        local success, result = pcall(function() return exports["Night_Management"]:getCloakrooms() end)
        if success then return result end
    end
    return nil
end

Citizen.CreateThread(function()
    local Hovering = false
    isDynamicOpen = false

    RegisterNetEvent("hud:Active")
    AddEventHandler("hud:Active", function(status)
        isDynamicOpen = not status
    end)

    while true do
        local sleep = 1000
        local cloaks = getCloakroomsData()
        if cloaks then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local Found = false
            
            for _,v in pairs(cloaks) do
                local cCoords = vec3(v.X, v.Y, v.Z)
                local distance = #(coords - cCoords) 
                if distance < 1.2 then
                    sleep = 1
                    Found = true
                    
                    if isDynamicOpen then
                        if Hovering then
                            Hovering = false
                            TriggerEvent("hoverfy:Hide")
                        end
                    else
                        if not Hovering then
                            Hovering = true
                            TriggerEvent("hoverfy:Show", { Key = "E", Title = "Pressione", Legend = "para abrir os Presets" })
                        end
                    end
                end
            end

            if not Found and Hovering then
                Hovering = false
                TriggerEvent("hoverfy:Hide")
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterKeyMapping("cloakroom:open","Abrir cloakroom","keyboard","E")

RegisterCommand("cloakroom:open", function()
    local cloaks = getCloakroomsData()
    if not cloaks then return end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for _,v in pairs(cloaks) do
        local cCoords = vec3(v.X, v.Y, v.Z)
        local distance = #(coords - cCoords) 
        if distance < 1 then
            TriggerServerEvent("cloakroom:checkPermAndOpen", v.Name, v.Permission, v.Presets)
            break
        end
    end
end)

RegisterNetEvent("cloakroom:openDynamic")
AddEventHandler("cloakroom:openDynamic", function(orgName, presetsDataStr)
    local presets = {}
    if presetsDataStr and presetsDataStr ~= "" then
        presets = json.decode(presetsDataStr) or {}
    end
    
    local sortedPresets = {}
    for pName, pInfo in pairs(presets) do
        table.insert(sortedPresets, { name = pName, info = pInfo, order = pInfo.order or 999 })
    end
    
    table.sort(sortedPresets, function(a, b)
        return a.order < b.order
    end)
    
    for _, preset in ipairs(sortedPresets) do
        exports["dynamic"]:AddButton(preset.name, "Vestir o preset " .. preset.name .. ".", "cloakroom:applyPreset", orgName .. "|" .. preset.name, false, true)
    end
    
    exports["dynamic"]:Open()
end)