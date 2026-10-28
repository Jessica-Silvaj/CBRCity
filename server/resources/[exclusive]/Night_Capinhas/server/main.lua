local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local Creative = {}
Tunnel.bindInterface(GetCurrentResourceName(), Creative)

local Cases = {}
local Busy = {}

for _, Case in ipairs(Config.Cases) do
    Cases[Case.prop] = Case
end

-- Used by phone resources that spawn the prop server-side (for example lb-phone).
-- Keeping this lookup here prevents clients from requesting arbitrary object models.
exports("IsPhoneCase", function(Model)
    if type(Model) == "number" then
        for Prop in pairs(Cases) do
            if GetHashKey(Prop) == Model then
                return true
            end
        end

        return false
    end

    return type(Model) == "string" and Cases[Model] ~= nil
end)

local function GetData(Passport)
    local Data = vRP.UserData(Passport, "PhoneCases")

    if type(Data) ~= "table" then
        Data = {}
    end

    if type(Data.owned) ~= "table" then
        Data.owned = {}
    end

    if Config.Cases[1] then
        Data.owned[Config.Cases[1].prop] = true
    end

    if Data.equipped and (not Cases[Data.equipped] or not Data.owned[Data.equipped]) then
        Data.equipped = nil
    end

    return Data
end

local function SaveData(Passport, Data)
    vRP.Query("playerdata/SetData", {
        Passport = Passport,
        Name = "PhoneCases",
        Information = json.encode(Data)
    })
end

local function Gemstones(Passport)
    local Identity = vRP.Identity(Passport)
    return Identity and Identity.License and parseInt(vRP.UserGemstone(Identity.License)) or 0
end

function Creative.GetShopData()
    local Source = source
    local Passport = vRP.Passport(Source)
    if not Passport then
        return false
    end

    local Data = GetData(Passport)
    local Catalog = {}

    for _, Case in ipairs(Config.Cases) do
        Catalog[#Catalog + 1] = {
            prop = Case.prop,
            label = Case.label,
            gems = Case.gems,
            money = Case.money,
            owned = Data.owned[Case.prop] == true
        }
    end

    Player(Source).state:set("PhoneCase", Data.equipped or false, true)

    return {
        cases = Catalog,
        equipped = Data.equipped,
        gems = Gemstones(Passport)
    }
end

function Creative.BuyCase(Prop, Currency)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Case = type(Prop) == "string" and Cases[Prop]
    if not Passport or not Case or Currency ~= "gems" or Busy[Passport] then
        return { success = false }
    end

    Busy[Passport] = true
    local Data = GetData(Passport)

    if Data.owned[Prop] or not tonumber(Case.gems) or Case.gems <= 0 or not vRP.PaymentGems(Passport, Case.gems) then
        Busy[Passport] = nil
        return { success = false }
    end

    Data.owned[Prop] = true
    SaveData(Passport, Data)
    Busy[Passport] = nil

    return {
        success = true,
        gems = Gemstones(Passport)
    }
end

function Creative.EquipCase(Prop)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Case = type(Prop) == "string" and Cases[Prop]
    if not Passport or not Case or Busy[Passport] then
        return { success = false }
    end

    Busy[Passport] = true
    local Data = GetData(Passport)

    if not Data.owned[Prop] then
        Busy[Passport] = nil
        return { success = false }
    end

    Data.equipped = Prop
    SaveData(Passport, Data)
    Player(Source).state:set("PhoneCase", Prop, true)
    Busy[Passport] = nil

    return { success = true }
end

function Creative.UnequipCase()
    local Source = source
    local Passport = vRP.Passport(Source)
    if not Passport or Busy[Passport] then
        return { success = false }
    end

    Busy[Passport] = true
    local Data = GetData(Passport)
    Data.equipped = nil
    SaveData(Passport, Data)
    Player(Source).state:set("PhoneCase", false, true)
    Busy[Passport] = nil

    return { success = true }
end

AddEventHandler("Connect", function(Passport, Source)
    local Data = GetData(Passport)
    Player(Source).state:set("PhoneCase", Data.equipped or false, true)
end)

AddEventHandler("Disconnect", function(Passport)
    Busy[Passport] = nil
end)
