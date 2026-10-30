-----------------------------------------------------------------------------------------------------------------------------------------
-- APLICATIVOS DO CELULAR - grupos com acesso a cada app e empresas do app Serviços
-- Salvo no banco (data/phone_apps.json e data/phone_companies.json) e publicado em GlobalState.NightPhone,
-- que o lb-phone (shared/management.lua) aplica por cima do config.lua sem reiniciar.
-----------------------------------------------------------------------------------------------------------------------------------------
local PhoneVRP = module("vrp","lib/Proxy").getInterface("vRP")

local AppsFile = "data/phone_apps.json"
local CompaniesFile = "data/phone_companies.json"

local function Admin(Source)
    local Passport = PhoneVRP.Passport(Source)
    return Passport and PhoneVRP.HasPermission(Passport,Config.Permissions.Permission)
end

local function Notify(Source,Message)
    TriggerClientEvent("Notify",Source,"Painel gestor",Message,"amarelo",5000)
end

local function Text(Value,Max)
    if type(Value) ~= "string" then return end
    Value = Value:gsub("^%s+",""):gsub("%s+$","")
    if Value ~= "" and #Value <= Max then return Value end
end

-- Empresas ainda não salvas pelo painel seguem as do config.lua do lb-phone
local function Companies()
    local Saved = Storage.Read(CompaniesFile)
    if Saved.List then return Saved.List end
    if GetResourceState("lb-phone") == "started" then
        return exports["lb-phone"]:ManagementDefaults().Companies or {}
    end
    return {}
end

local function Publish()
    GlobalState:set("NightPhone",{ Apps = Storage.Read(AppsFile), Companies = Storage.Read(CompaniesFile).List },true)
end

local function Send(Source)
    local Groups = {}
    for Name in pairs(PhoneVRP.Groups() or {}) do Groups[#Groups + 1] = Name end
    table.sort(Groups)

    local Defaults = GetResourceState("lb-phone") == "started" and exports["lb-phone"]:ManagementDefaults() or {}
    TriggerClientEvent("Night_Management:catalog",Source,"Phone",{
        Apps = Storage.Read(AppsFile),
        Defaults = Defaults.Whitelist or {},
        Companies = Companies(),
        Groups = Groups
    })
end

CreateThread(function()
    Publish()
end)

RegisterNetEvent("Night_Management:requestPhone",function()
    if Admin(source) then Send(source) end
end)

RegisterNetEvent("Night_Management:savePhoneApp",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" then return end

    local App = Text(Data.App,64)
    if not App or type(Data.Groups) ~= "table" then return end

    local Groups = PhoneVRP.Groups() or {}
    local List = {}
    for _,Name in ipairs(Data.Groups) do
        if type(Name) == "string" and Groups[Name] then List[#List + 1] = Name end
    end

    local Apps = Storage.Read(AppsFile)
    -- Lista vazia libera o app para todos; Reset volta ao que está no config.lua
    Apps[App] = not Data.Reset and List or nil
    if not Storage.Write(AppsFile,Apps) then Notify(Source,"Não foi possível salvar no banco de dados.") return end

    Publish()
    Send(Source)
    Notify(Source,"Acesso do aplicativo salvo.")
end)

RegisterNetEvent("Night_Management:savePhoneCompany",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" then return end

    local Job = Text(Data.job,50)
    local Name = Text(Data.name,50)
    if not Job or not Name or not (PhoneVRP.Groups() or {})[Job] then
        Notify(Source,"Escolha um grupo existente e informe o nome.")
        return
    end

    local Ranks = {}
    for Rank in tostring(Data.bossRanks or ""):gmatch("[^,]+") do
        Rank = Text(Rank,50)
        if Rank then Ranks[#Ranks + 1] = Rank end
    end

    local Company = {
        job = Job,
        name = Name,
        icon = Text(Data.icon,300) or "",
        canCall = Data.canCall == true,
        canMessage = Data.canMessage == true,
        bossRanks = Ranks,
        location = {
            name = Text(Data.locationName,80) or Name,
            coords = { x = tonumber(Data.x) or 0.0, y = tonumber(Data.y) or 0.0 }
        }
    }

    local List = Companies()
    local Index = tonumber(Data.index)
    for Position,Entry in ipairs(List) do
        if Entry.job == Job and Position ~= Index then
            Notify(Source,"Esse grupo já tem uma empresa no celular.")
            return
        end
    end

    if Index and List[Index] then List[Index] = Company else List[#List + 1] = Company end
    if not Storage.Write(CompaniesFile,{ List = List }) then Notify(Source,"Não foi possível salvar no banco de dados.") return end

    Publish()
    Send(Source)
    Notify(Source,"Empresa salva.")
end)

RegisterNetEvent("Night_Management:deletePhoneCompany",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" then return end

    local List = Companies()
    local Index = tonumber(Data.index)
    if not Index or not List[Index] then return end

    table.remove(List,Index)
    if not Storage.Write(CompaniesFile,{ List = List }) then Notify(Source,"Não foi possível salvar no banco de dados.") return end

    Publish()
    Send(Source)
    Notify(Source,"Empresa removida.")
end)
