local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_creator")
func = {}
Tunnel.bindInterface("nation_creator", func)
vHUD = Tunnel.getInterface("hud")
REQUEST = Tunnel.getInterface("request")
vCLIENT = Tunnel.getInterface("nation_creator")

local Licensed = {}
local Connected = {}

AddEventHandler("playerDropped", function(reason)
    local source = source
    for k, v in pairs(Licensed) do
        if v == source then
            Licensed[k] = nil
        end
    end
    for k, v in pairs(Connected) do
        if v == source then
            Connected[k] = nil
        end
    end
end)

if MultiCharacter == nil then MultiCharacter = true end
if MultiCharacter then
    vRP.Prepare("nation_creator/createAgeColumn","ALTER TABLE characters ADD COLUMN IF NOT EXISTS Age INT(11) NOT NULL DEFAULT 20")
    vRP.Prepare("nation_creator/createSexColumn","ALTER TABLE characters ADD COLUMN IF NOT EXISTS Sex VARCHAR(1) DEFAULT 'M'")
    vRP.Prepare("nation_creator/update_user_first_spawn","UPDATE characters SET Lastname = @firstname, name = @name, Age = @age, Sex = @sex WHERE id = @Passport")
    vRP.Prepare("nation_creator/create_characters","INSERT INTO characters(license,name,Lastname,phone,blood,skin,created) VALUES(@steam,@name,@firstname,@phone,@blood,'mp_m_freemode_01',UNIX_TIMESTAMP() + (86400 * 3))")
    vRP.Prepare("nation_creator/remove_characters","UPDATE characters SET deleted = 1 WHERE id = @id")
    vRP.Prepare("nation_creator/get_characters","SELECT * FROM characters WHERE license = @steam and deleted = 0")
    vRP.Prepare("nation_creator/get_character","SELECT * FROM characters WHERE license = @steam and deleted = 0 and id = @Passport")
    vRP.Prepare("nation_creator/get_bank","SELECT * FROM characters WHERE id = @Passport")
    CreateThread(function() 
        vRP.Query("nation_creator/createAgeColumn")
        vRP.Query("nation_creator/createSexColumn")
    end) 
else
    vRP.Prepare("nation_creator/update_user_first_spawn","UPDATE vrp_Passportentities SET firstname = @firstname, name = @name, age = @age WHERE Passport = @Passport")
end
function func.checkPermission(permission, src)
    local source = src or source
    local Passport = vRP.Passport(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.HasGroup(Passport, perm, {1,2,3}) then
                return true
            end
        end
        return false
    end
    return vRP.HasGroup(Passport, permission, {1,2,3})
end
function func.saveChar(name, lastName, age, char, id)
    local source = source
    local Passport = vRP.Passport(source) or id
    if Passport then
        if char then
            local val = json.encode(char,{indent=false})
            vRP.Query("playerdata/SetData", { Passport = Passport, Name = "nation_char", Information = val })
            vRP.Query("playerdata/SetData", { Passport = Passport, Name = "Barbershop", Information = val })
            if vRP.setUData then
                vRP.setUData(Passport, "nation_char", val)
                vRP.setUData(Passport, "Barbershop", val)
            end
        end
        local sex = "M"
        if name and lastName and age then
            if GetEntityModel(GetPlayerPed(source)) == GetHashKey("mp_f_freemode_01") then
                sex = "F"
            else
                sex = "M"
            end
            vRP.UpgradeNames(Passport, name, lastName)
            local success, result = pcall(function()
                return vRP.Query("nation_creator/update_user_first_spawn", { Passport = Passport, firstname = lastName, name = name, age = age, sex = sex })
            end)
            if not success then
            end
            TriggerClientEvent("vRP:Active", source, Passport, name .. " " .. lastName)
        end
        local skin = "mp_m_freemode_01"
        if sex == "F" then
            skin = "mp_f_freemode_01"
        else
            skin = "mp_m_freemode_01"
        end
        vRP.SkinCharacter(Passport, skin)
        TriggerEvent("SaveServer",source,true)
        Wait(400)
        TriggerClientEvent("nation_barbershop:init", source, char)
        return true
    else
        return false
    end
end
function getUserChar(Passport, source, nation)
    local char
    local data = vRP.UserData(Passport, "nation_char")
    if not data or data == "" or (type(data) == "table" and isEmpty(data)) then
        data = vRP.Query("playerdata/GetData", { Passport = Passport, Name = "nation_char" })
        if type(data) == "table" and data[1] then
            data = data[1].Information or data[1].dvalue or data[1].data
        end
    end
    if not data or data == "" or (type(data) == "table" and isEmpty(data)) then
        data = vRP.UserData(Passport, "Barbershop")
        if not data or data == "" or (type(data) == "table" and isEmpty(data)) then
            data = vRP.Query("playerdata/GetData", { Passport = Passport, Name = "Barbershop" })
            if type(data) == "table" and data[1] then
                data = data[1].Information or data[1].dvalue or data[1].data
            end
        end
    end
    if type(data) == "string" and data ~= "" then
        data = json.decode(data)
    end
    if data and type(data) == "table" and (data.hair or data.hairModel or (data[1] == nil and next(data) ~= nil)) then
        char = data
        char.gender = getGender(Passport) or char.gender or "male"
        if char.hair then char.hairModel = char.hair end
        if char["hair-color"] then char.firstHairColor = char["hair-color"] end
        if char["hair-highlightcolor"] then char.secondHairColor = char["hair-highlightcolor"] end
    else
        char = { gender = getGender(Passport) or "male" }
    end
    return char
end
local userlogin = {}
function playerSpawn(Passport, source, first_spawn)
    if first_spawn then
        Wait(1000)
        processSpawnController(source,getUserChar(Passport, source),Passport)
    end
end
AddEventHandler("vRP:playerSpawn",playerSpawn)
function processSpawnController(source, char, Passport)
    getUserLastPosition(source, Passport)
    local source = source
    if char then
        if not userlogin[Passport] then
            userlogin[Passport] = true
            fclient._spawnPlayer(source, false)
        else
            fclient._spawnPlayer(source, true)
        end
        fclient.setPlayerChar(source, char, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, Passport)
        fclient._setClothing(source, getUserClothes(Passport))
        TriggerClientEvent("skinshop:Apply",source,vRP.UserData(Passport,"Clothings"))
        setPlayerTattoos(source, Passport)
        TriggerEvent("Creative:playerSpawn",Passport,source)
    else
        userlogin[Passport] = true
        local data = vRP.UserData(Passport, "Barbershop")
        if data then 
            local gender = getGender(Passport)
            fclient._spawnPlayer(source, false)
            fclient._setOldChar(source, data, getUserClothes(Passport), gender, Passport)
        else
            fclient._startCreator(source)
        end
    end
end
function setPlayerTattoos(source, Passport)
    local tattoos = getUserTattoos(Passport)
    TriggerClientEvent("tattoos:setTattoos", source, tattoos)
    TriggerClientEvent("tattoos:Apply", source, tattoos)
    TriggerClientEvent("reloadtattos", source, tattoos)
    TriggerEvent('dpn_tattoo:setPedServer', source)
    TriggerClientEvent("nyoModule:tattooUpdate", source, false)
end
function func.setPlayerTattoos(id)
    local source = source
    local Passport = id or vRP.Passport(source)
    if Passport then
        setPlayerTattoos(source, Passport)
    end
end
function getUserLastPosition(source, Passport)
    local coords = {402.76,-996.28,-99.00}
    local datatable = vRP.getUserDataTable(Passport)
    if datatable and datatable.Pos then
        local p = datatable.Pos
        coords = { p.x, p.y, p.z }
    else
        local data = vRP.UserData(Passport, "Datatable")
        if data and data.Pos then
            local p = data.Pos
            coords = { p.x, p.y, p.z }
        end
    end
    fclient._setPlayerLastCoords(source, coords)
    return coords
end
function func.getUserLastPosition()
    local source = source
    local Passport = vRP.Passport(source)
    getUserLastPosition(source, Passport)
end
function format(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end
function func.changeSession(session)
    local source = source
    SetPlayerRoutingBucket(source, session)
end
function func.updateLogin()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        userlogin[Passport] = true
        local char = getUserChar(Passport, source)
        if char then 
            TriggerClientEvent("nation_barbershop:init", source, char)
            setPlayerTattoos(source, Passport)
        end
    end
end
function func.getCharsInfo()
    local source = source
    local steam = getPlayerSteam(source)

    if not MultiAccount then
        if not steam then
            DropPlayer(source,"Não foi possível efetuar conexão com a "..(BaseMode == "steam" and "Steam" or BaseMode == "license" and "Rockstar" or BaseMode == "universal" and "Universal" or BaseMode or "Licença")..".")
            return { chars = {} }
        end
    end

    local data = vRP.Query("nation_creator/get_characters",{ steam = steam })
    local info = { chars = {} }
    for k,v in ipairs(data) do
        local char = getUserChar(v.id, source) or {}
        local clothes = getUserClothes(v.id)
        local gender = "masculino"
        local charSex = v.sex or v.Sex or "M"
        if charSex == "F" then
            gender = "feminino"
        elseif charSex == "M" then
            gender = "masculino"
        else
            gender = "outros"
        end
        local data = vRP.Query("nation_creator/get_bank",{ Passport = v.id })
        local bank = 0
        if data and data[1] then
            bank = data[1].bank or data[1].Bank or 0
        end
        local firstName = v.name or v.Name or "Individuo"
        local lastName = v.Lastname or v.lastname or "Indigente"
        local ageVal = v.Age or v.age or 20
        local bloodVal = v.blood or v.Blood or 1
        local phoneVal = v.phone or v.Phone or "000-000"
        local tattoos = getUserTattoos(v.id)
        local Account = vRP.Account(steam) or {}
        local gemsVal = (Account and (Account.Gemstone or Account.gemstone or Account.Gems)) or (vRP.UserGemstone and vRP.UserGemstone(steam)) or 0
        table.insert(info.chars, {
            name = firstName.." "..lastName, age = ageVal.." anos", bank = "R$ "..format(bank),
            gems = format(gemsVal), clothes = clothes,
            registration = Sanguine(bloodVal), phone = phoneVal, Passport = v.id, id = "#"..v.id, gender = gender, char = char,
            tattoos = tattoos
        })
    end
    info.maxChars = getUserMaxChars(source) 
    local Account = vRP.Account(steam) or {}
    local gemsVal = (Account and (Account.Gemstone or Account.gemstone or Account.Gems)) or (vRP.UserGemstone and vRP.UserGemstone(steam)) or 0
    info.gems = format(gemsVal)
    return info
end
function countTable(t)
    local c = 0
    if type(t) == "table" then
        for k,v in pairs(t) do c = c + 1 end
    end
    return c
end
function getUserMaxChars(source)
    local steam = getPlayerSteam(source)
    local Account = vRP.Account(steam) or {}
    local amountCharacters = parseInt(Account["Characters"] or Account["characters"] or Account["chars"] or 1)
    if vRP.steamPremium and vRP.steamPremium(steam) then
        amountCharacters = amountCharacters + 2
    end
    if amountCharacters < 1 then amountCharacters = 1 end
    return amountCharacters 
end
local compMap = {
    ["pants"] = "legs",
    ["mask"] = "masks",
    ["arms"] = "torsos",
    ["backpack"] = "bags",
    ["accessory"] = "accessories",
    ["tshirt"] = "undershirts",
    ["vest"] = "bodyArmors",
    ["torso"] = "tops",
    ["hat"] = "hats",
    ["glass"] = "glasses",
    ["ear"] = "ears",
    ["watch"] = "watches",
    ["bracelet"] = "bracelets",
    ["decals"] = "decals",
    ["shoes"] = "shoes",
    ["1"] = "masks", ["3"] = "torsos", ["4"] = "legs", ["5"] = "bags", ["6"] = "shoes", 
    ["7"] = "accessories", ["8"] = "undershirts", ["9"] = "bodyArmors", ["10"] = "decals", 
    ["11"] = "tops", ["p0"] = "hats", ["p1"] = "glasses", ["p2"] = "ears", ["p6"] = "watches", ["p7"] = "bracelets"
}
function getUserClothes(Passport)
    local data = vRP.UserData(Passport, "Clothings")
    if not data or data == "" or (type(data) == "table" and isEmpty(data)) then
        data = vRP.Query("playerdata/GetData", { Passport = Passport, Name = "Clothings" })
        if type(data) == "table" and data[1] then data = data[1].Information or data[1].dvalue or data[1].data end
    end
    if type(data) == "string" and data ~= "" then
        data = json.decode(data)
    end
    if type(data) == "table" and not isEmpty(data) then
        return data
    end
    return {}
end
function getUserTattoos(Passport)
    local data = vRP.UserData(Passport,"Tatuagens")
    if not data or data == "" or (type(data) == "table" and isEmpty(data)) then
        data = vRP.Query("playerdata/GetData", { Passport = Passport, Name = "Tatuagens" })
        if type(data) == "table" and data[1] then data = data[1].Information or data[1].dvalue or data[1].data end
    end
    if type(data) == "string" and data ~= "" then
        data = json.decode(data)
    end
    if type(data) == "table" then
        return data
    end
    return {}
end
function isEmpty(t)
    if not t then return true end
    if type(t) == "string" then
        return t == "" or t == "{}"
    end
    if type(t) == "table" then
        return next(t) == nil
    end
    return false
end
function getGender(Passport)
    local datatable = vRP.getUserDataTable(Passport) or vRP.UserData(Passport, "Datatable")
    local model = datatable.Skin or datatable.gender
    if model then
        if type(model) == "table" then
            model = model.modelhash or model.model
        end
        if model == GetHashKey("mp_m_freemode_01") or model == "mp_m_freemode_01" then
            return "male"
        elseif model == GetHashKey("mp_f_freemode_01") or model == "mp_f_freemode_01" then
            return "female"
        else
            return model
        end
    end
end
function func.getOverlay()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local char = getUserChar(Passport, source, true)
        if char and char.overlay then
            return char.overlay
        end
    end
    return 0
end
function func.playChar(info)
    local source = source
    local steam = getPlayerSteam(source)

    if not MultiAccount then
        if Licensed[steam] and Licensed[steam] ~= source then
            DropPlayer(source,"Não foi possível efetuar conexão, sua conta já está logada no servidor.")
            return
        end
    end

    local data = vRP.Query("nation_creator/get_character", { steam = steam, Passport = info.Passport })
    if #data > 0 then
        if not MultiAccount then
            Connected[info.Passport] = source
            Licensed[steam] = source
        end
        vRP.CharacterChosen(source, info.Passport, nil)
        local Passport = vRP.Passport(source)
        playerSpawn(info.Passport, source, true)
        TriggerClientEvent("skinshop:Apply",source,vRP.UserData(Passport,"Clothings"))
        setPlayerTattoos(source, Passport)
        TriggerClientEvent("nation_creator:finishSpawn", source)
    end
end
function func.tryDeleteChar(info)
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_character",{ steam = steam, Passport = info.Passport })
    if #data > 0 then
        local char_id = data[1].id 
        vRP.Prepare("nation_creator/remove_characters","UPDATE characters SET deleted = 1 WHERE id = @id") 
        local success = vRP.Query("nation_creator/remove_characters", {id = char_id}) 
        if success then
            return true, "Deletado com sucesso"
        else
            return false, "Erro ao deletar o personagem"
        end
    else
        return false, "Personagem não encontrado"
    end
end
function func.tryCreateChar()
    local source = source
    local steam = getPlayerSteam(source)

    if not MultiAccount then
        if Licensed[steam] and Licensed[steam] ~= source then
            DropPlayer(source,"Não foi possível efetuar conexão, sua conta já está logada no servidor.")
            return false
        end
    end

    local data = vRP.Query("nation_creator/get_characters",{ steam = steam })
    if #data < getUserMaxChars(source)  then 
        vRP.Query("nation_creator/create_characters",{ steam = steam, name = "Individuo", firstname = "Indigente", phone = vRP.GeneratePhone(), blood = math.random(4) })
        local myChars = vRP.Query("nation_creator/get_characters",{ steam = steam })
        local Passport = myChars[#myChars].id
        if Passport  then
            if not MultiAccount then
                Connected[Passport] = source
                Licensed[steam] = source
            end
            local Model = "mp_m_freemode_01"
            vRP.CharacterChosen(source,Passport,Model)
            return true
        end
    end
end
function getPlayerSteam(source)
    return vRP.Identities(source)
end
local function reloadPlayerChar(source)
    local Passport = vRP.Passport(source)
    local char = getUserChar(Passport, source)
    if char then
        fclient._setPlayerChar(source, char, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, Passport)
        fclient._setClothing(source, getUserClothes(Passport))
    end
end
RegisterCommand("char", function(source) reloadPlayerChar(source) end)
RegisterCommand("bvida", function(source) reloadPlayerChar(source) end)
RegisterCommand('resetchar',function(source, args)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport, "Admin") then
        if args[1] then 
            local id = tonumber(args[1])
            if id then
                local src = vRP.Source(id)
                if src and vRP.Request(source, "Deseja resetar o id "..id.." ?") then
                    fclient._startCreator(src)
                end
            end
        end
    end
end)
RegisterCommand('cirurgia',function(source, args)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport, "Paramedic") then
        if args[1] then 
            local id = tonumber(args[1])
            if id then
                local src = vRP.Source(id)
                if src and vRP.Request(source, "Deseja resetar o id "..id.." ?") then
                    fclient._startCreator(src)
                end
            end
        end
    end
end)
RegisterCommand('spawn',function(source)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport,"Admin", 1) then
        if MultiCharacter == nil then MultiCharacter = true end
if MultiCharacter then
            if vRP.Logout then
                vRP.Logout(source)
            end
            Wait(1000)
            TriggerClientEvent("spawn:setupChars", source)
        else
            playerSpawn(vRP.Passport(source), source, true)
        end
    end
end)
RegisterServerEvent("nation:resetplayer")
AddEventHandler("nation:resetplayer",function(source,Passport)
    if source ~= nil then
        fclient._startCreator(source)
    end
end)