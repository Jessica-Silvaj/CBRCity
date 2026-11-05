---------------------------------------------------------------------------
-- VRP
---------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("nation_skinshop")
fclient = {}
Tunnel.bindInterface("nation_skinshop", fclient)
---------------------------------------------------------------------------
-- ANIMAÇÃO DE PARADO
---------------------------------------------------------------------------
function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function freezeAnim(dict, anim, flag, keep)
    if not keep then
        ClearPedTasks(PlayerPedId())
    end
    LoadAnim(dict)
    TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, flag or 1, 0, false, false, false)
    RemoveAnimDict(dict)
end

handsUp = false
handsup = function()
    handsUp = not handsUp
    if handsUp then
        freezeAnim("random@mugging3", "handsup_standing_base", 49)
    else
        freezeAnim("move_f@multiplayer", "idle")
    end
end
---------------------------------------------------------------------------
-- CÂMERAS
---------------------------------------------------------------------------
local cameras = {
    body = { coords = vec3(0.4, 2.1, 0.9), point = vec3(-0.7,-0.1,-0.2) }, 
    head = { coords = vec3(0.0, 0.7, 0.8), point = vec3(-0.1,0.0,0.6) },
    chest = { coords = vec3(0.0, 1.4, 0.7), point = vec3(-0.4,0.0,0.2) },
    legs = { coords = vec3(0.0, 1.3, 0.2), point = vec3(-0.4,0.0,-0.5) },
    feet = { coords = vec3(0.0, 0.8, -0.5), point = vec3(-0.25,0.0,-1.0) }
}

componentCams = {
    ["masks"] = "head",
    ["torsos"] = "chest",
    ["legs"] = "legs",
    ["bags"] = "chest",
    ["shoes"] = "feet",
    ["accessories"] = "body",
    ["undershirts"] = "chest",
    ["bodyArmors"] = "chest",
    ["decals"] = "body",
    ["tops"] = "chest",
    ["hats"] = "head",
    ["glasses"] = "head",
    ["ears"] = "head",
    ["watches"] = "legs",
    ["bracelets"] = "legs",
}

local activeCam

function interpCamera(cameraName)
    if cameras[cameraName] then
        if cameraName == activeCam then return end
        activeCam = cameraName
        local ped = PlayerPedId()
        local cam = cameras[cameraName]
        local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords)
        local tempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord, 0,0,0, 50.0)
        local pointCoords = GetOffsetFromEntityInWorldCoords(ped,cam.point)
        SetCamActive(tempCam, true)
        SetCamActiveWithInterp(tempCam, fixedCam, 600, true, true)
        PointCamAtCoord(tempCam, pointCoords)
        CreateThread(function()
            Wait(600)
            DestroyCam(fixedCam)
            fixedCam = tempCam
        end)
    end
end

function createCamera()
    local ped = PlayerPedId()
    local groundCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    if store and store.coords then
        SetEntityCoords(ped, store.coords.x, store.coords.y, store.coords.z-0.97)
        if store.h then
            SetEntityHeading(ped, store.h)
        end
    end
    AttachCamToEntity(groundCam, ped, 0.5, -1.6, 0.0)
    SetCamRot(groundCam, 0, 0.0, 0.0)
    SetCamActive(groundCam, true)
    RenderScriptCams(true, false, 1, true, true)
    activeCam = "body"
    local cam = cameras[activeCam]
    local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords)
    fixedCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord, 0,0,0, 50.0)
    local pointCoords = GetOffsetFromEntityInWorldCoords(ped,cam.point)
    PointCamAtCoord(fixedCam, pointCoords)
    SetCamActive(fixedCam, true)
    SetCamActiveWithInterp(fixedCam, groundCam, 1000, true, true)
    CreateThread(function()
        Wait(1000)
        DestroyCam(groundCam)
    end)
end
---------------------------------------------------------------------------
-- DEIXAR OS PLAYERS INVISÍVEIS
---------------------------------------------------------------------------
function setPlayersVisible(bool)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, not bool)
    SetEntityInvincible(ped, false)--mqcu
    if bool then
        for _, player in ipairs(GetActivePlayers()) do
            local otherPlayer = GetPlayerPed(player)
            if ped ~= otherPlayer then
                SetEntityVisible(otherPlayer, bool)
            end
        end
    else
        CreateThread(function()
            while inMenu do
                for _, player in ipairs(GetActivePlayers()) do
                    local otherPlayer = GetPlayerPed(player)
                    if ped ~= otherPlayer then
                        SetEntityVisible(otherPlayer, bool)
                    end
                end
                InvalidateIdleCam()
                Wait(1)
            end
        end)
    end
end
---------------------------------------------------------------------------
-- LOJA DE ROUPAS
---------------------------------------------------------------------------
defaultPrices = {
    ["masks"] = 50,
    ["torsos"] = 20,
    ["legs"] = 200,
    ["bags"] = 150,
    ["shoes"] = 200,
    ["accessories"] = 90,
    ["undershirts"] = 100,
    ["bodyArmors"] = 300,
    ["decals"] = 50,
    ["tops"] = 300,
    ["hats"] = 120,
    ["glasses"] = 180,
    ["ears"] = 40,
    ["watches"] = 40,
    ["bracelets"] = 35,
}

customClothes = {
    ["test"] = {
        ['tops'] = {
            male = {
                defaultPrice = 500,
                type = "insert",
                [0] = true,
                [1] = true,
                [2] = 1000,
                [3] = true,
            }
        },

        ['glasses'] = {
            male = {
                defaultPrice = 500,
                type = "insert",
                [1] = { price = 250,
                    textures = {
                        [0] = { blocked = true }
                    }
                },
            }
        },

        ['legs'] = {
            male = {
                type = "remove",
                [0] = 5000,
                [1] = true,
                [2] = true,
                [3] = true,
            }
        },
    },
}

function format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function isCloth(index, value)
    return type(index) == "number" and type(value) == "table" -- verificar se está acessando o indice de uma roupa
end

isComponentBlocked = function(id, component)
    --if component == "bodyArmors" then return true end
    return customClothes[id] and customClothes[id][component] and customClothes[id][component].blocked
end

isClothBlocked = function(id, component, index, gender)
    if customClothes[id] and customClothes[id][component] and customClothes[id][component][gender] then
        local c = customClothes[id][component][gender]
        return (c.type == "insert" and (not c[index] or (type(c[index]) == "table" and c[index].blocked))) or (c.type == "remove" and c[index] and (type(c[index]) == "boolean" or (type(c[index]) == "table" and c[index].blocked)))
    end
    return false
end

getBlockedComponentTextures = function(cloth, id, component, index, gender)
    for i = 0, cloth.textures do
        if not cloth[i] then
            cloth[i] = { blocked = false }
        else
            cloth[i].blocked = false
        end
        if customClothes[id] and customClothes[id][component] and customClothes[id][component][gender] and customClothes[id][component][gender][index] then
            local c = customClothes[id][component][gender][index]
            if type(c) == "table" and c.textures and c.textures[i] then
                cloth[i].blocked =  c.textures[i].blocked
            end
        end
    end
    return cloth
end

getClothPrice = function(id, component, index, gender)
    if id == "nation_creator" then return 0 end
    if customClothes[id] and customClothes[id][component] and customClothes[id][component][gender] then
        local c = customClothes[id][component][gender]
        if c[index] then
            local price = c[index]
            if type(price) == "table" then
                price = price.price or c.defaultPrice or defaultPrices[component]
            elseif type(price) == "boolean" then
                price = c.defaultPrice
            end
            return price
        else 
            return c.defaultPrice or defaultPrices[component]
        end
    end
    return defaultPrices[component]
end

getClothes = function(id)
    local clothes = getAllClothes()
    local gender = getGender()
    for component, v in pairs(clothes) do
        v.blocked = isComponentBlocked(id, component)
        for index, j in pairs(v) do
            if isCloth(index, j) then 
                j.price = getClothPrice(id, component, index, gender)
                j.blocked = isClothBlocked(id, component, index, gender)
                j = getBlockedComponentTextures(j, id, component, index, gender)
            end
        end
    end
    return clothes
end

getCartTotal = function(cart, initialClothes, storeId)
    local total = 0
    local gender = getGender()
    for component, index in pairs(cart) do
        if initialClothes[component] then
            local i = initialClothes[component][1]
            if index >= 0 and index ~= i then
                total = total + getClothPrice(storeId, component, index, gender)
            end
        end
    end
    return math.floor(total)
end

getPopupText = function(total) -- TEXTO QUE VAI APARECER NO POPUP NA HORA DE COMPRAR
    return "você deseja pagar o valor de $ <b>"..format(total or 0).."</b> ?"
end

skinshops = {
    [1] = { clothes = getClothes, permission = nil, coords = vec3(72.78, -1399.34, 29.37) },
    [2] = { clothes = getClothes, permission = nil, coords = vec3(-703.92, -152.22, 37.41) },
    [3] = { clothes = getClothes, permission = nil, coords = vec3(-168.11, -298.89, 39.73) },
    [4] = { clothes = getClothes, permission = nil, coords = vec3(-829.16, -1074.3, 11.32) },
    [5] = { clothes = getClothes, permission = nil, coords = vec3(-1188.06, -768.69, 17.32) },
    [6] = { clothes = getClothes, permission = nil, coords = vec3(-1450.43, -237.04, 49.81) },
    [7] = { clothes = getClothes, permission = nil, coords = vec3(11.28, 6514.82, 31.88) },
    [8] = { clothes = getClothes, permission = nil, coords = vec3(428.6, -799.93, 29.49) },
    [9] = { clothes = getClothes, permission = nil, coords = vec3(-1107.66, 2707.98, 19.11) },
    [10] = { clothes = getClothes, permission = nil, coords = vec3(-3175.35, 1042.19, 20.86) },
    [11] = { clothes = getClothes, permission = nil, coords = vec3(1190.27, 2712.99, 38.22) },
    [12] = { clothes = getClothes, permission = nil, coords = vec3(617.75, 2766.35, 42.09) },
    [13] = { clothes = getClothes, permission = nil, coords = vec3(121.01, -225.53, 54.56) },
    [14] = { clothes = getClothes, permission = nil, coords = vec3(1695.53, 4829.45, 42.06) },
    [15] = { clothes = getClothes, permission = nil, coords = vec3(741.67, 1300.03, 360.3) },

    ["admin"] = {
        clothes = getClothes
    },

    ["nation_creator"] = {
        clothes = getClothes
    },

    ["propertys"] = {
        clothes = getClothes
    },
}

RegisterNetEvent("skinshop:openShop")
AddEventHandler("skinshop:openShop", function(menu)
    toggleMenu(menu or "admin")
end)  

nearestSkinshops = {}
mainThread = function()
    local getNearestSkinshops = function()
        while true do
            if not inMenu then
                local myCoords = GetEntityCoords(PlayerPedId())
                for k,v in pairs(skinshops) do
                    if v and v.coords then
                        local distance = #(myCoords - v.coords)
                        if nearestSkinshops[k] then
                            if distance > 10 then
                                nearestSkinshops[k] = nil
                            end
                        else
                            if distance <= 10 then
                                nearestSkinshops[k] = v
                            end
                        end
                    end
                end
            end
            Wait(500)
        end
    end

    CreateThread(getNearestSkinshops)

    while true do
        local idle = 500
        local ped = PlayerPedId()
        local myCoords = GetEntityCoords(ped)
        if not inMenu then
            for skinShopId, v in pairs(nearestSkinshops) do
                if v and v.coords and GetEntityHealth(ped) > 101 then 
                    idle = 0 
                    local coords = v.coords
                    DrawMarker(25, coords.x, coords.y, coords.z - 0.97, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 150, false, false, 2, false, nil, nil, false)
                    local distance = #(myCoords - v.coords)
                    if IsDisabledControlJustPressed(0,38) and distance < 1.5 then
                        if v.permission then
                            if func.checkPermission(v.permission) then
                                toggleMenu(skinShopId)
                            end
                        else
                            toggleMenu(skinShopId)
                        end
                    end
                end
            end
        end
        Wait(idle)
    end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.45, 0.45)
    SetTextFont(6)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

RegisterCommand('skinshop',function()
    if func.checkPermission({"admin.permissao", "mod.permissao", "Admin"}) then
        toggleMenu("admin")
    end
end)

local isCreatorSkinshop = false

RegisterNetEvent("nation_skinshop:toggleMenu")
AddEventHandler("nation_skinshop:toggleMenu", function(menu)
    TriggerEvent("dynamic:Close")
    if not menu or menu == "" or not skinshops[menu] then
        menu = 1
    end
    if menu == "nation_creator" then
        isCreatorSkinshop = true
    else
        isCreatorSkinshop = false
    end
    toggleMenu(menu)
end)
---------------------------------------------------------------------------
-- CREATIVE V3
---------------------------------------------------------------------------
mySkinData = {}

local skinData = {
	["pants"] = "legs",
	["arms"] = "torsos",
	["tshirt"] = "undershirts",
	["torso"] = "tops",
	["vest"] = "bodyArmors",
	["backpack"] = "bags",
	["shoes"] = "shoes",
	["mask"] = "masks",
	["hat"] = "hats",
	["glass"] = "glasses",
	["ear"] = "ears",
	["watch"] = "watches",
	["bracelet"] = "bracelets",
	["accessory"] = "accessories",
	["decals"] = "decals"
}

function fclient.getCloths()
    local myCloths = getMyClothes()
    local cloths = {}
    for cloth, comp in pairs(skinData) do
        local item = myCloths[comp][1]
        local texture = myCloths[comp][2]
        cloths[cloth] = { item = item, texture = texture }
    end
    mySkinData = cloths
    return cloths
end


local originalSetNuiFocus = SetNuiFocus
function SetNuiFocus(hasFocus, hasCursor)
    originalSetNuiFocus(hasFocus, hasCursor)
    if hasFocus then
        TriggerEvent("hud:Active", false)
    else
        if not isCreatorSkinshop and not LocalPlayer["state"]["Invisible"] then
            TriggerEvent("hud:Active", true)
        end
        if isCreatorSkinshop then
            isCreatorSkinshop = false
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPATIBILIDADE SKINSHOP (CLIENT-SIDE)
-----------------------------------------------------------------------------------------------------------------------------------------
local skinshopCompat = {}
Tunnel.bindInterface("skinshop", skinshopCompat)

local compatMap = {
	["pants"] = 4,
	["arms"] = 3,
	["tshirt"] = 8,
	["torso"] = 11,
	["vest"] = 9,
	["backpack"] = 5,
	["shoes"] = 6,
	["mask"] = 1,
	["decals"] = 10,
	["accessory"] = 7
}

local propMap = {
    ["hat"] = 0,
    ["glass"] = 1,
    ["ear"] = 2,
    ["watch"] = 6,
    ["bracelet"] = 7
}

local reverseSkinData = {
    ["legs"] = "pants",
    ["torsos"] = "arms",
    ["undershirts"] = "tshirt",
    ["tops"] = "torso",
    ["bodyArmors"] = "vest",
    ["bags"] = "backpack",
    ["shoes"] = "shoes",
    ["masks"] = "mask",
    ["hats"] = "hat",
    ["glasses"] = "glass",
    ["ears"] = "ear",
    ["watches"] = "watch",
    ["bracelets"] = "bracelet",
    ["accessories"] = "accessory",
    ["decals"] = "decals"
}

function skinshopCompat.Customization()
    local ped = PlayerPedId()
    local custom = {}

    for name, compId in pairs(compatMap) do
        custom[name] = {
            item = GetPedDrawableVariation(ped, compId),
            texture = GetPedTextureVariation(ped, compId)
        }
    end

    for name, propId in pairs(propMap) do
        local item = GetPedPropIndex(ped, propId)
        local texture = math.max(0, GetPedPropTextureIndex(ped, propId))
        if item == -1 then
            texture = 0
        end
        custom[name] = { item = item, texture = texture }
    end

    return custom
end

RegisterNetEvent("updateRoupas")
AddEventHandler("updateRoupas", function(Table)
    if Table then
        TriggerEvent("skinshop:Apply", Table)
    end
end)

RegisterNetEvent("skinshop:Apply")
AddEventHandler("skinshop:Apply",function(Table)
    if not Table then return end
    local ped = PlayerPedId()

    local isMale = GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")
    if isMale and Table["tshirt"] and (Table["tshirt"]["item"] == 6 or Table["tshirt"]["item"] == 7 or Table["tshirt"]["item"] == 77) then
        Table["tshirt"]["item"] = 15
    else
        if Table["pants"] and Table["pants"]["item"] == 21 then
            Table["pants"]["item"] = 13
        end
    end

    for k, v in pairs(compatMap) do
        if Table[k] then
            SetPedComponentVariation(ped, v, Table[k].item, Table[k].texture, 2)
        end
    end

    for k, v in pairs(propMap) do
        if Table[k] then
            if Table[k].item ~= -1 and Table[k].item ~= 0 then
                SetPedPropIndex(ped, v, Table[k].item, Table[k].texture, 2)
            else
                ClearPedProp(ped, v)
            end
        end
    end

    if fclient and fclient.getCloths then
        local myNewCloths = fclient.getCloths()
        TriggerServerEvent("nation_skinshop:updateClothes", myNewCloths)
    end
end)

local Animation = false
local function toggleComponent(name, animDict, animName, compId, isProp, defaultValue, emptyValue)
    if not Animation and not LocalPlayer["state"]["Buttons"] then
        Animation = true
        local ped = PlayerPedId()
        vRP.playAnim(true, {animDict, animName}, true)
        Wait(1000)

        local currentItem = isProp and GetPedPropIndex(ped, compId) or GetPedDrawableVariation(ped, compId)
        local custom = skinshopCompat.Customization()
        local savedItem = custom[name].item

        if currentItem == savedItem then
            if isProp then
                ClearPedProp(ped, compId)
            else
                SetPedComponentVariation(ped, compId, emptyValue, 0, 2)
                if compId == 8 or compId == 11 then
                    SetPedComponentVariation(ped, 3, 15, 0, 2)
                end
            end
        else
            if isProp then
                SetPedPropIndex(ped, compId, savedItem, custom[name].texture, 2)
            else
                SetPedComponentVariation(ped, compId, savedItem, custom[name].texture, 2)
            end
        end

        vRP.stopAnim()
        Animation = false
    end
end

RegisterNetEvent("skinshop:setHat")
AddEventHandler("skinshop:setHat",function() toggleComponent("hat", "mp_masks@standard_car@ds@", "put_on_mask", 0, true, -1, -1) end)

RegisterNetEvent("skinshop:setMask")
AddEventHandler("skinshop:setMask",function() toggleComponent("mask", "missfbi4", "takeoff_mask", 1, false, 0, 0) end)

RegisterNetEvent("skinshop:setGlasses")
AddEventHandler("skinshop:setGlasses",function() toggleComponent("glass", "clothingspecs", "take_off", 1, true, -1, -1) end)

RegisterNetEvent("skinshop:setShirt")
AddEventHandler("skinshop:setShirt",function() toggleComponent("tshirt", "clothingtie", "try_tie_negative_a", 8, false, 15, 15) end)

RegisterNetEvent("skinshop:setTorso")
AddEventHandler("skinshop:setTorso",function() toggleComponent("torso", "clothingtie", "try_tie_negative_a", 11, false, 15, 15) end)

RegisterNetEvent("skinshop:setArms")
AddEventHandler("skinshop:setArms",function() toggleComponent("arms", "clothingtie", "try_tie_negative_a", 3, false, 15, 15) end)

RegisterNetEvent("skinshop:setVest")
AddEventHandler("skinshop:setVest",function() toggleComponent("vest", "clothingtie", "try_tie_negative_a", 9, false, 0, 0) end)

RegisterNetEvent("skinshop:setPants")
AddEventHandler("skinshop:setPants",function() 
    local ped = PlayerPedId()
    local empty = GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") and 14 or 15
    toggleComponent("pants", "clothingtie", "try_tie_negative_a", 4, false, 0, empty) 
end)

RegisterNetEvent("skinshop:setShoes")
AddEventHandler("skinshop:setShoes",function() toggleComponent("shoes", "clothingtie", "try_tie_negative_a", 6, false, 1, 5) end)

local Defibrillator = false
RegisterNetEvent("skinshop:Defibrillator")
AddEventHandler("skinshop:Defibrillator",function()
	if Defibrillator then
		Defibrillator = false
		SetPedComponentVariation(PlayerPedId(),5,0,0,1)
	else
		Defibrillator = true
		SetPedComponentVariation(PlayerPedId(),5,111,0,1)
	end
end)

RegisterNetEvent("skinshop:setAccessory")
AddEventHandler("skinshop:setAccessory",function() toggleComponent("accessory", "clothingtie", "try_tie_negative_a", 7, false, 0, 0) end)

RegisterNetEvent("skinshop:setBackpack")
AddEventHandler("skinshop:setBackpack",function() toggleComponent("backpack", "clothingtie", "try_tie_negative_a", 5, false, 0, 0) end)

RegisterNetEvent("skinshop:Open")
AddEventHandler("skinshop:Open", function(menu)
    if not menu or menu == "" or not skinshops[menu] then
        menu = "propertys"
    end
    TriggerEvent("nation_skinshop:toggleMenu", menu)
end)

function skinshopCompat.CurrentClothes()
    return skinshopCompat.Customization()
end

exports("Apply", function(Table, Ped)
    if Table then
        TriggerEvent("skinshop:Apply", Table)
    end
end)

exports("openShop", function(menu)
    if not menu or menu == "" or not skinshops[menu] then
        menu = 1
    end
    TriggerEvent("nation_skinshop:toggleMenu", menu)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPATIBILIDADE CHARACTER / PRESETS / OUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("character:Client:Skinshop:SaveDefault", function(data)
    if data then
        TriggerEvent("skinshop:Apply", data)
    end
end)

RegisterNetEvent("character:Client:Skinshop:SetHat", function() TriggerEvent("skinshop:setHat") end)
RegisterNetEvent("character:Client:Skinshop:SetMask", function() TriggerEvent("skinshop:setMask") end)
RegisterNetEvent("character:Client:Skinshop:SetGlasses", function() TriggerEvent("skinshop:setGlasses") end)
RegisterNetEvent("character:Client:Skinshop:SetShirt", function() TriggerEvent("skinshop:setShirt") end)
RegisterNetEvent("character:Client:Skinshop:SetTorso", function() TriggerEvent("skinshop:setTorso") end)
RegisterNetEvent("character:Client:Skinshop:SetJacket", function() TriggerEvent("skinshop:setTorso") end)
RegisterNetEvent("character:Client:Skinshop:SetArms", function() TriggerEvent("skinshop:setArms") end)
RegisterNetEvent("character:Client:Skinshop:SetVest", function() TriggerEvent("skinshop:setVest") end)
RegisterNetEvent("character:Client:Skinshop:SetPants", function() TriggerEvent("skinshop:setPants") end)
RegisterNetEvent("character:Client:Skinshop:SetShoes", function() TriggerEvent("skinshop:setShoes") end)
RegisterNetEvent("character:Client:Skinshop:SetAccessory", function() TriggerEvent("skinshop:setAccessory") end)
RegisterNetEvent("character:Client:Skinshop:SetBackpack", function() TriggerEvent("skinshop:setBackpack") end)

exports("ApplySkinshop", function(Data)
    TriggerEvent("skinshop:Apply", Data)
end)

exports("OpenSkinshop", function(menu)
    TriggerEvent("skinshop:Open", menu)
end)

exports("Customization", function()
    return skinshopCompat.Customization()
end)