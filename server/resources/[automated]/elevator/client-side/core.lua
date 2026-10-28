-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Creative = Tunnel.getInterface("elevator")

RegisterNetEvent("elevator:updateConfig")
AddEventHandler("elevator:updateConfig", function(newConfig)
    Config = newConfig
end)

local Hovering = false
local isDynamicOpen = false

RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active", function(status)
    isDynamicOpen = not status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()

    while true do
        local TimeDistance = 999
        local Ped = PlayerPedId()
        local Found = false

        if not IsPedInAnyVehicle(Ped) then
            local Coords = GetEntityCoords(Ped)

            for Number,Table in pairs(Config) do
                for _,v in pairs(Table) do
                    local Distance = #(Coords - v.Coords)
                    if Distance <= 1.75 then
                        TimeDistance = 1
                        Found = true

                        if isDynamicOpen then
                            if Hovering then
                                Hovering = false
                                TriggerEvent("hoverfy:Hide")
                            end
                        else
                            if not Hovering then
                                Hovering = true
                                TriggerEvent("hoverfy:Show", { Key = "E", Title = "Pressione", Legend = "para abrir o Elevador" })
                            end
                        end

                        if IsControlJustPressed(1,38) and not exports.hud:Wanted() and not exports["lb-phone"]:IsOpen() then
                            if v.Permission and v.Permission ~= "" then
                                if Creative.checkPermission(v.Permission) then
                                    SetNuiFocus(true,true)
                                    SendNUIMessage({ Action = "Open", Payload = { Id = Number, Floors = Table } })
                                else
                                    TriggerEvent("Notify","vermelho","Você não tem permissão para acessar este elevador.",5000)
                                end
                            else
                                SetNuiFocus(true,true)
                                SendNUIMessage({ Action = "Open", Payload = { Id = Number, Floors = Table } })
                            end
                        end
                    end
                end
            end
        end

        if not Found and Hovering then
            Hovering = false
            TriggerEvent("hoverfy:Hide")
        end

        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Select",function(Data,Callback)
    local Floor = Data.Floor
    local Selected = Data.Id
    local Ped = PlayerPedId()

    if Config[Selected] and Config[Selected][Floor] then
        local dest = Config[Selected][Floor]

        if dest.Permission and dest.Permission ~= "" then
            if not Creative.checkPermission(dest.Permission) then
                TriggerEvent("Notify","vermelho","Você não tem acesso a este andar.",5000)
                Callback("Ok")
                return
            end
        end

        DoScreenFadeOut(0)
        SetNuiFocus(false,false)
        TriggerEvent("hud:Active",false)
        SetEntityCoordsNoOffset(Ped, dest.Coords.x, dest.Coords.y, dest.Coords.z, false, false, false)
        if dest.Heading then
            SetEntityHeading(Ped, dest.Heading)
        end

        SetTimeout(2500,function()
            TriggerEvent("hud:Active",true)
            DoScreenFadeIn(2500)
        end)
    end

    Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
    SetNuiFocus(false,false)

    Callback("Ok")
end)