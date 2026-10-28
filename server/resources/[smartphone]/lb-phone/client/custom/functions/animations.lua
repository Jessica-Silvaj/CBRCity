local loadedDicts = {}
local phoneModel = Config.PhoneModel or `prop_amb_phone`
local currentAction, phone
local disableAnimation = false
local rotation = Config.PhoneRotation or vector3(0.0, 0.0, 180.0)
local offset = Config.PhoneOffset or vector3(0.0, -0.005, 0.0)
local textureVariation

local function GetPhoneModel()
    local phoneCase = LocalPlayer.state.PhoneCase

    if type(phoneCase) ~= "string" or GetResourceState("Night_Capinhas") ~= "started" then
        return phoneModel, nil
    end

    local success, props = pcall(function()
        return exports["Night_Capinhas"]:PhoneProps()
    end)

    if not success
        or type(props) ~= "table"
        or type(props.cases) ~= "table"
        or not props.cases[phoneCase]
    then
        return phoneModel, nil
    end

    local caseModel = GetHashKey(phoneCase)

    if not IsModelValid(caseModel) then
        return phoneModel, nil
    end

    local attach = props.attach and props.attach.default or nil
    local customAttach = props.attach
        and props.attach.props
        and props.attach.props[phoneCase]
        or nil

    return caseModel, {
        pos = customAttach and customAttach.pos or attach and attach.pos,
        rot = customAttach and customAttach.rot or attach and attach.rot
    }
end

CreateThread(function()
    while not loaded do
        Wait(500)
    end

    phoneModel = Config.PhoneModel or phoneModel

    if not IsModelValid(phoneModel) then
        phoneModel = `prop_amb_phone`
    end
end)

local phoneAnimations = {
    default = {
        onFoot = {
            open = {
                dict = "cellphone@",
                anim = "cellphone_text_in",
                flag = 50
            },
            base = {
                dict = "cellphone@",
                anim = "cellphone_text_read_base",
                flag = 50,
                blendInSpeed = 1000.0,
            },
            close = {
                dict = "cellphone@",
                anim = "cellphone_text_out",
                flag = 48
            }
        },
        inCar = {
            open = {
                dict = "cellphone@in_car@ds",
                anim = "cellphone_text_in",
                flag = 50
            },
            base = {
                dict = "cellphone@in_car@ds",
                anim = "cellphone_text_read_base",
                flag = 50,
                blendInSpeed = 1000.0,
            },
            close = {
                dict = "cellphone@in_car@ds",
                anim = "cellphone_text_out",
                flag = 48
            }
        },
    },
    call = {
        onFoot = {
            open = {
                dict = "cellphone@",
                anim = "cellphone_call_in",
                flag = 50
            },
            base = {
                dict = "cellphone@",
                anim = "cellphone_call_listen_base",
                flag = 50,
            },
            close = {
                dict = "cellphone@",
                anim = "cellphone_call_out",
                flag = 48
            }
        },
        inCar = {
            open = {
                dict = "cellphone@in_car@ds",
                anim = "cellphone_call_in",
                flag = 50
            },
            base = {
                dict = "cellphone@in_car@ds",
                anim = "cellphone_call_listen_base",
                flag = 50,
            },
            close = {
                dict = "cellphone@in_car@ds",
                anim = "cellphone_call_out",
                flag = 48
            }
        },
    },
    camera = {
        onFoot = {
            open = {
                dict = "cellphone@self",
                anim = "selfie_in",
                flag = 50
            },
            base = {
                dict = "cellphone@self",
                anim = "selfie_in",
                flag = 50,
                blendInSpeed = 1000.0,
                blendOutSpeed = -1000.0,
            },
            close = {
                dict = "cellphone@self",
                anim = "selfie_out",
                flag = 48
            }
        },
        inCar = {
            open = {
                dict = "cellphone@self",
                anim = "selfie_in",
                flag = 50
            },
            base = {
                dict = "cellphone@self",
                anim = "selfie",
                flag = 50,
            },
            close = {
                dict = "cellphone@self",
                anim = "selfie_out",
                flag = 48
            }
        },
    }
}

local function LoadDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    loadedDicts[dict] = true

    return dict
end

-- Handle phone object
local function CreatePhone()
    if DoesEntityExist(phone) then
        return
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed, false)
    local objectModel, caseAttach = GetPhoneModel()

    local objectOffset = offset
    local objectRotation = rotation

    if caseAttach then
        local casePos = caseAttach.pos or { 0.0, 0.0, 0.0 }
        local caseRot = caseAttach.rot or { 0.0, 0.0, 0.0 }

        objectOffset = vector3(casePos[1], casePos[2], casePos[3])
        objectRotation = vector3(caseRot[1], caseRot[2], caseRot[3])
    end

    if Config.ServerSideSpawn then
        if not IsModelValid(objectModel) then
            debugprint("phoneModel is not valid")
            return
        end

        local netId = AwaitCallback("createPhoneObject", objectModel)

        if not netId then
            debugprint("Failed to create phone object")
            return
        end

        local entity = WaitForNetworkId(netId)

        if not entity then
            debugprint("Failed to get phone object")
            TriggerServerEvent("phone:failedControl", netId)
            return
        end

        if not TakeControlOfEntity(entity) then
            debugprint("Failed to take control of phone object")
            TriggerServerEvent("phone:failedControl", netId)
            return
        end

        phone = entity
    else
        if not IsModelValid(objectModel) then
            debugprint("Could not load phone model")
            return
        end

        LoadModel(objectModel)

        phone = CreateObject(objectModel, coords.x, coords.y, coords.z, true, true, true)
    end

    if textureVariation then
        SetObjectTextureVariation(phone, textureVariation)
    end

    SetEntityCollision(phone, false, false)
    AttachEntityToEntity(
        phone,
        playerPed,
        GetPedBoneIndex(playerPed, 28422),
        objectOffset.x,
        objectOffset.y,
        objectOffset.z,
        objectRotation.x,
        objectRotation.y,
        objectRotation.z,
        false,
        false,
        false,
        false,
        2,
        true
    )
    SetModelAsNoLongerNeeded(objectModel)

    TriggerServerEvent("phone:setPhoneObject", NetworkGetNetworkIdFromEntity(phone))
end

local function DeletePhone()
    if phone then
        DeleteEntity(phone)
        phone = nil

        TriggerServerEvent("phone:setPhoneObject", nil)
    end
end

AddStateBagChangeHandler("PhoneCase", nil, function(bagName)
    -- Descobre qual jogador teve o state bag alterado.
    local player = GetPlayerFromStateBagName(bagName)

    -- Ignora outros jogadores e celulares que ainda não foram criados.
    if player ~= PlayerId() or not DoesEntityExist(phone) then
        return
    end

    CreateThread(function()
        -- Aguarda um frame para LocalPlayer.state receber o valor mais recente.
        Wait(0)

        -- Remove o prop antigo e cria imediatamente o novo.
        DeletePhone()
        CreatePhone()
    end)
end)

local function PlayOpenAnim(action)
    local inCar = IsPedInAnyVehicle(PlayerPedId(), true)
    local animData = phoneAnimations[action][inCar and "inCar" or "onFoot"].open
    local dict = LoadDict(animData.dict)
    local anim = animData.anim
    local flag = animData.flag

    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, flag | 1048576, 0, false, false, false)

    return GetAnimDuration(dict, anim) * 1000
end

local function CleanUpAssets()
    for dict, loaded in pairs(loadedDicts) do
        if loaded then
            RemoveAnimDict(dict)
            loadedDicts[dict] = nil
        end
    end

    SetModelAsNoLongerNeeded(phoneModel)
end

function PlayCloseAnim()
    if IsInCall() or InExportCall or not currentAction then
        return
    end

    local inCar = IsPedInAnyVehicle(PlayerPedId(), true)
    local animData = phoneAnimations[currentAction][inCar and "inCar" or "onFoot"].close

    if animData then
        TaskPlayAnim(PlayerPedId(), LoadDict(animData.dict), animData.anim, 8.0, -8.0, 950, animData.flag | 1048576, 0, false, false, false)
        Wait(300)
    end

    DeletePhone()
    CleanUpAssets()
end

function SetPhoneAction(action)
    if (action == currentAction and not phoneOpen) or (action ~= "call" and not phoneOpen) or not phoneAnimations[action] or InExportCall then
        return
    end

    local playOpen = true

    if currentAction then
        for _, v in pairs({"inCar", "onFoot"}) do
            local currentAnim = phoneAnimations[currentAction][v]

            if IsEntityPlayingAnim(PlayerPedId(), currentAnim.open.dict, currentAnim.open.anim, 3) or IsEntityPlayingAnim(PlayerPedId(), currentAnim.base.dict, currentAnim.base.anim, 3) then
                playOpen = false
            end
        end
    end

    if not playOpen then
        currentAction = action
        return
    end

    CreateThread(function()
        PlayOpenAnim(action)

        currentAction = action

        Wait(300)
        CreatePhone()
    end)
end

function GetPhoneObject()
    return phone
end

function TogglePhoneAnimation(enabled, action)
    disableAnimation = enabled == false

    if enabled then
        SetPhoneAction(action or "default")
    else
        PlayCloseAnim()
    end
end

local oldFrameColor

---@param variation number
function SetPhoneVariation(variation)
    local itemData = Config.Item.Names[variation]

    if not itemData then
        infoprint("error", "SetPhoneVariation", "Invalid phone variation: " .. tostring(variation))
        return
    end

    phoneModel = itemData.model or phoneModel
    offset = itemData.offset or Config.PhoneOffset or offset
    rotation = itemData.rotation or Config.PhoneRotation or rotation
    textureVariation = itemData.textureVariation

    SetResourceKvpInt("phone_variation", variation)

    if itemData.frameColor then
        if settings and settings?.display?.frameColor then
            oldFrameColor = settings.display.frameColor
        end

        SendReactMessage("setFrameColor", itemData.frameColor)
    else
        if oldFrameColor then
            SendReactMessage("setFrameColor", oldFrameColor)
        end
    end
end

exports("SetPhoneVariation", SetPhoneVariation)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        DeletePhone()
    end
end)

while true do
    local playerPed = PlayerPedId()

    if (phoneOpen or (IsInCall() and not InExportCall)) and not (cameraOpen and not IsWalkingCamEnabled()) and currentAction and not disableAnimation then
        local inCar = IsPedInAnyVehicle(playerPed, true)
        local animData = phoneAnimations[currentAction][inCar and "inCar" or "onFoot"]

        if animData then
            local baseData = animData.base

            if not IsEntityPlayingAnim(playerPed, animData.open.dict, animData.open.anim, 3) and not IsEntityPlayingAnim(playerPed, baseData.dict, baseData.anim, 3) then
                TaskPlayAnim(playerPed, LoadDict(baseData.dict), baseData.anim, baseData.blendInSpeed or 8.0, baseData.blendOutSpeed or -8.0, -1, baseData.flag | 1048576, 0, false, false, false)
            end
        end

        Wait(500)
    else
        Wait(1000)
    end
end
