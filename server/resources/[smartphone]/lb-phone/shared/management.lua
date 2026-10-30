-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINEL GESTOR (Night_Management) - aplica por cima do config.lua os grupos de cada app e as empresas do app Serviços.
-- O painel publica GlobalState.NightPhone = { Apps = { [app] = { grupos } }, Companies = { ... } | nil }.
-----------------------------------------------------------------------------------------------------------------------------------------
local DefaultWhitelist = json.decode(json.encode(Config.WhitelistApps or {}))
local DefaultServices = json.decode(json.encode(Config.Companies.Services or {}))
-- Apps que tinham restrição antes da última mudança, para liberar no celular os que saíram da lista
local PreviousApps = {}

local function Apply(Data)
    Data = type(Data) == "table" and Data or {}

    PreviousApps = {}
    for App in pairs(Config.WhitelistApps or {}) do PreviousApps[App] = true end

    local Whitelist = json.decode(json.encode(DefaultWhitelist))
    for App,Groups in pairs(type(Data.Apps) == "table" and Data.Apps or {}) do
        -- Lista vazia no painel libera o app para todos
        Whitelist[App] = #Groups > 0 and Groups or nil
    end
    Config.WhitelistApps = Whitelist

    -- A tabela é esvaziada e preenchida no lugar porque outros arquivos guardam a referência
    local Services = Config.Companies.Services
    for Index = #Services,1,-1 do Services[Index] = nil end
    for _,Company in ipairs(type(Data.Companies) == "table" and Data.Companies or DefaultServices) do
        Services[#Services + 1] = Company
    end
end

Apply(GlobalState.NightPhone)

AddStateBagChangeHandler("NightPhone","global",function(_,_,Value)
    Apply(Value)

    if not IsDuplicityVersion() then
        TriggerEvent("lb-phone:management:refresh")
    end
end)

if IsDuplicityVersion() then
    exports("ManagementDefaults",function()
        return { Whitelist = DefaultWhitelist, Companies = DefaultServices }
    end)
else
    exports("ManagementApps",function()
        local Apps = {}
        local Raw = json.decode(LoadResourceFile(GetCurrentResourceName(),"config/config.json") or "{}") or {}
        for Identifier,App in pairs(Raw.apps or {}) do
            Apps[#Apps + 1] = { id = Identifier, name = App.name or Identifier }
        end
        for Identifier,App in pairs(Config.CustomApps or {}) do
            Apps[#Apps + 1] = { id = Identifier, name = App.name or Identifier, custom = true }
        end
        table.sort(Apps,function(A,B) return A.name:lower() < B.name:lower() end)
        return Apps
    end)

    -- Reenvia ao celular o acesso de cada app com o emprego atual
    AddEventHandler("lb-phone:management:refresh",function()
        if not GetJob or not GetJobGrade then
            return
        end

        local Job,Grade = GetJob(),GetJobGrade()
        local Apps = PreviousApps
        for App in pairs(Config.WhitelistApps) do Apps[App] = true end
        for App in pairs(Apps) do
            SendReactMessage("app:setHasAccess",{ app = App,hasAccess = HasAccessToApp(App,Job,Grade) })
        end
    end)
end
