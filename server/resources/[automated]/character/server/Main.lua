local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

vFunc = {}
Tunnel.bindInterface("character",vFunc)

math.randomseed(os.time())

vRP.Prepare("characters/getCharacters","SELECT * FROM characters WHERE License = @License AND Deleted = 0")
vRP.Prepare("characters/deleteCharacter","UPDATE characters SET Deleted = 1 WHERE id = @Passport AND License = @License")
vRP.Prepare("characters/setCharacterData","REPLACE INTO playerdata (Passport,Name,Information) VALUES (@Passport,@Name,@Information)")
vRP.Prepare("characters/getCharacterData","SELECT Information FROM playerdata WHERE Passport = @Passport AND Name = @Name")
vRP.Prepare("characters/createCharacter","INSERT INTO characters (License,Name,Lastname,Age,Skin,Blood,Created) VALUES (@License,@Name,@Lastname,@Age,@Skin,@Blood,UNIX_TIMESTAMP())")
vRP.Prepare("characters/lastCreated","SELECT id FROM characters WHERE License = @License ORDER BY id DESC LIMIT 1")

local function DataName(Name)
    if Name == "Character" then
        return "Barbershop"
    elseif Name == "Tattoos" then
        return "Tattooshop"
    elseif Name == "Position" then
        return "Datatable"
    end

    return Name
end

function vRP.getIdentities(source)
    return vRP.Identities(source)
end

function vRP.getUserId(source)
    return vRP.Passport(source)
end

function vRP.getUserSource(Passport)
    return vRP.Source(Passport)
end

function vRP.infoAccount(License)
    local Account = vRP.Account(License) or {}
    local maxChars = tonumber(Account.Characters or 1) or 1
    local premium = tonumber(Account.Premium or 0) or 0

    if premium > os.time() then
        maxChars = maxChars + 2
    end

    return { chars = math.max(maxChars,1), gems = tonumber(Account.Gemstone or 0) or 0 }
end

function vRP.hasGroup(Passport,Group,Hierarchy)
    return vRP.HasGroup and vRP.HasGroup(Passport,Group,Hierarchy)
end

function vRP.userData(Passport,Name)
    local Data = vRP.UserData(Passport,DataName(Name))

    if Name == "Position" then
        Data = Data.Pos and Data.Pos or Config.Creator.Spawn
    end

    return Data or {}
end

function vRP.setCharacterData(Passport,Name,Data)
    Name = DataName(Name)

    if Name == "Datatable" then
        local Datatable = vRP.UserData(Passport,"Datatable")
        Datatable.Pos = Data
        vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Datatable", Information = json.encode(Datatable) })
        return
    end

    vRP.Query("playerdata/SetData",{ Passport = Passport, Name = Name, Information = json.encode(Data or {}) })
end

function vRP.itemAmount(Passport,Item)
    Item = Item == "dollars" and "dollar" or Item
    return vRP.ItemAmount(Passport,Item) or 0
end

function vRP.tryGetInventoryItem(Passport,Item,Amount)
    Item = Item == "dollars" and "dollar" or Item
    return vRP.TakeItem(Passport,Item,Amount,true)
end

function vRP.getBank(Passport)
    return vRP.GetBank(Passport)
end

function vRP.delBank(Passport,Amount)
    return vRP.PaymentBank(Passport,Amount,true)
end

function vRP.generatePhone()
    return "000-000"
end

function vRP.generateSerial()
    return tostring(math.random(100000,999999))
end

function vRP.characterChosen(source,Passport,Skin)
    vRP.CharacterChosen(source,Passport,Skin)
end

PlayersSpawned = {}

RegisterNetEvent("character:Server:Sync", function()
    local playerSource = source
    local Passport = vRP.getUserId(playerSource)

    if not Passport then
        return
    end

    local Clothes = vRP.userData(Passport,"Clothings")
    local Appearance = vRP.userData(Passport,"Character")
    local Tattoos = vRP.userData(Passport,"Tattoos")

    if type(Appearance) ~= "table" or not next(Appearance) then
        Appearance = Config.Creator.Default.Appearance
    end

    if type(Clothes) ~= "table" or not next(Clothes) then
        Clothes = Config.Creator.Default.Clothes
    end

    if type(Tattoos) ~= "table" then
        Tattoos = {}
    end

    --if type(Clothes) == "table" and next(Clothes) then
    --    TriggerClientEvent("character:Client:Skinshop:SaveDefault",playerSource,Clothes)
    --end

    TriggerClientEvent("character:Client:Sync:Start",playerSource,{
        appearance = Appearance,
        tattoos = Tattoos
    })
end)

RegisterNetEvent("character:Server:Spawn", function()
    local playerSource = source
    local License = vRP.getIdentities(playerSource)
    if not License then
        return
    end

    local accountInfos = vRP.Account(License)
    local retries = 0
    while (not accountInfos or not next(accountInfos)) and retries < 20 do
        Wait(1000)
        accountInfos = vRP.Account(License)
        retries = retries + 1
    end

    local playerCharacters = vRP.Query("characters/getCharacters", { License = License }) or {}

    if #playerCharacters > 0 then
        TriggerEvent("character:Server:Selector:Open", playerSource)
    else
        TriggerEvent("character:Server:Creator:Open", playerSource)
    end
end)
