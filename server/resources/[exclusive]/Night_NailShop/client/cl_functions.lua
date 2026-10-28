local Config = LoadNailConfig()

local activeBlips = {}
local locationsStarted = false
local pendingEmployeeInvite = nil

NuiLoaded = false

local function DrawText3D(coords,text)
    local onScreen,x,y = World3dToScreen2d(coords.x,coords.y,coords.z)
    if not onScreen then return end

    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255,255,255,215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(x,y)
end

function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)

    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        if GetGameTimer() > timeout then
            return false
        end
    end

    return true
end

function GetClosestObjectAtCoords(coords,radius)
    local selected = nil
    local selectedDistance = radius or 1.5

    for _,object in pairs(GetGamePool("CObject")) do
        local objectCoords = GetEntityCoords(object)
        local distance = #(coords - objectCoords)
        if distance <= selectedDistance then
            selected = object
            selectedDistance = distance
        end
    end

    return selected
end

local function WaitForNuiLoad()
    while not NuiLoaded do
        Wait(100)
    end
end

function NuiMessage(action,payload)
    WaitForNuiLoad()
    SendNUIMessage({ action = action, payload = payload })
end

local function LoadLocales()
    local fileContent = LoadResourceFile(GetCurrentResourceName(),"locales/" .. Config.Locale .. ".json")
    if not fileContent then
        fileContent = LoadResourceFile(GetCurrentResourceName(),"locales/en.json")
    end

    if not fileContent or fileContent == "" then
        return {}
    end

    local ok,decoded = pcall(json.decode,fileContent)
    if not ok or not decoded or not decoded.Web then
        return {}
    end

    return decoded.Web
end

function FetchNui()
    while not NuiLoaded do
        if NetworkIsSessionStarted() then
            SendNUIMessage({ action = "nui/check" })
        end
        Wait(1000)
    end

    NuiMessage("nui/set-locales",{ locales = LoadLocales() })
end

function CreateBlip(coords,settings,label)
    local blip = AddBlipForCoord(coords.x,coords.y,coords.z)
    SetBlipSprite(blip,settings.sprite)
    SetBlipColour(blip,settings.color)
    SetBlipScale(blip,settings.scale)
    SetBlipAsShortRange(blip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function SitCustomer(studioIndex,tableIndex,tableData,openMenu)
    local chairObject = GetClosestObjectAtCoords(vector3(tableData.customer.coords.x,tableData.customer.coords.y,tableData.customer.coords.z),1.5)
    if not chairObject then
        Notify.SendNotify(_T("notify.chair_not_found"),"error",5000)
        return
    end

    if Framework.IsTableBusy(studioIndex,tableIndex) then
        Notify.SendNotify(_T("notify.table_occupied"),"error",5000)
        return
    end

    StudioIndex = studioIndex
    TableIndex = tableIndex

    local seatWorldPos = GetOffsetFromEntityInWorldCoords(chairObject,tableData.customer.chairOffset.x,tableData.customer.chairOffset.y,tableData.customer.chairOffset.z)
    local seatVector = vector4(seatWorldPos.x,seatWorldPos.y,seatWorldPos.z,GetEntityHeading(chairObject) - 180)
    local ped = PlayerPedId()

    SetEntityHeading(ped,seatVector.w or 0.0)
    SetEntityCoords(ped,seatVector.x,seatVector.y,seatVector.z,false,false,false,true)

    if LoadAnimDict("adezanim@anim") then
        TaskPlayAnim(ped,"adezanim@anim","adezanim_clip",8.0,8.0,-1,1,0,false,false,false)
        RemoveAnimDict("adezanim@anim")
    end

    TriggerServerEvent(Scriptname .. ":server:setBusyTable",studioIndex,tableIndex,true)

    local scriptedCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
    Camera = scriptedCamera

    local camOffset = tableData.customer.cameraOffset or vec3(0.0,0.0,1.5)
    local camWorldPos = GetOffsetFromEntityInWorldCoords(chairObject,camOffset.x,camOffset.y,camOffset.z)
    SetCamCoord(scriptedCamera,camWorldPos.x,camWorldPos.y,camWorldPos.z)
    SetCamRot(scriptedCamera,270.0,0.0,GetEntityHeading(chairObject),2)
    SetCamFov(scriptedCamera,70.0)
    SetCamActive(scriptedCamera,true)
    RenderScriptCams(true,true,2000,true,true)

    InNailShop = true
    Wait(2000)

    if openMenu then
        NuiMessage("nui/toggle",{ show = true })
        SetNuiFocus(true,true)
        TriggerServerEvent(Scriptname .. ":server:requestPlayerNailData",vector3(tableData.customer.coords.x,tableData.customer.coords.y,tableData.customer.coords.z))
    end
end

RegisterCommand("nailinvite",function(_,args)
    local targetId = tonumber(args[1])
    if not targetId or not pendingEmployeeInvite then
        Notify.SendNotify("Use /nailinvite [id] perto da mesa de manicure.","info",5000)
        return
    end

    TriggerServerEvent(
        Scriptname .. ":server:inviteCustomerById",
        targetId,
        pendingEmployeeInvite.studioIndex,
        pendingEmployeeInvite.tableIndex
    )
end)

function InitLocations()
    if locationsStarted then return end
    locationsStarted = true

    for studioIndex,studioData in pairs(Config.NailStudios) do
        if Config.BlipSettings.show ~= false then
            local blipLabel = studioData.name .. " - " .. Config.BlipSettings.name
            activeBlips[#activeBlips + 1] = CreateBlip(studioData.coords,{
                sprite = Config.BlipSettings.sprite,
                color = Config.BlipSettings.color,
                scale = Config.BlipSettings.scale
            },blipLabel)
        end
    end

    CreateThread(function()
        while locationsStarted do
            local sleep = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            for studioIndex,studioData in pairs(Config.NailStudios) do
                for tableIndex,tableData in pairs(studioData.tables) do
                    if tableData.customer and tableData.customer.coords and not studioData.job then
                        local targetCoords = vector3(tableData.customer.coords.x,tableData.customer.coords.y,tableData.customer.coords.z)
                        local distance = #(coords - targetCoords)
                        if distance <= 2.0 then
                            sleep = 0
                            DrawText3D(targetCoords + vector3(0.0,0.0,0.35),"~g~E~w~ - " .. _T("target.sit_here"))
                            if IsControlJustPressed(0,38) then
                                SitCustomer(studioIndex,tableIndex,tableData,true)
                            end
                        end
                    end

                    if tableData.employee and tableData.employee.coords and studioData.job then
                        local targetCoords = vector3(tableData.employee.coords.x,tableData.employee.coords.y,tableData.employee.coords.z)
                        local distance = #(coords - targetCoords)
                        if distance <= 2.0 then
                            sleep = 0
                            DrawText3D(targetCoords + vector3(0.0,0.0,0.35),"~g~E~w~ - " .. _T("target.open_nail_design_menu"))
                            if IsControlJustPressed(0,38) then
                                if Framework.HasStudioPermission(studioIndex) then
                                    pendingEmployeeInvite = {
                                        studioIndex = studioIndex,
                                        tableIndex = tableIndex
                                    }
                                    Notify.SendNotify("Use /nailinvite [id] para convidar o cliente.","info",7000)
                                else
                                    Notify.SendNotify("Voce nao tem permissao para usar esta mesa.","error",5000)
                                end
                            end
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end)
end

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    locationsStarted = false
    for _,blip in pairs(activeBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    activeBlips = {}
end)
