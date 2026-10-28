local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local function checkPerm(source, perm)
    local Passport = vRP.Passport(source)
    if not perm or perm == "" then return true end
    
    local t = {}
    for str in string.gmatch(perm, "([^,]+)") do
        table.insert(t, str)
    end

    if #t == 2 then
        return vRP.HasGroup(Passport, t[1], tonumber(t[2]))
    else
        return vRP.HasPermission(Passport, perm) or vRP.HasGroup(Passport, perm)
    end
end

RegisterNetEvent("cloakroom:checkPermAndOpen")
AddEventHandler("cloakroom:checkPermAndOpen", function(orgName, perm, presetsDataStr)
    local source = source
    if checkPerm(source, perm) then
        TriggerClientEvent("cloakroom:openDynamic", source, orgName, presetsDataStr)
    else
        TriggerClientEvent("Notify", source, "Erro", "Você não tem permissão para acessar este vestiário.", "vermelho", 5000)
    end
end)

RegisterNetEvent("cloakroom:applyPreset")
AddEventHandler("cloakroom:applyPreset", function(arg)
    local source = source
    local split = {}
    for str in string.gmatch(arg, "([^|]+)") do
        table.insert(split, str)
    end
    
    local org = split[1]
    local presetName = split[2]

    local cloakrooms = exports.oxmysql:executeSync("SELECT * FROM cloakrooms WHERE Name = ?", {org})
    if cloakrooms and cloakrooms[1] then
        local presets = json.decode(cloakrooms[1].Presets) or {}
        local presetInfo = presets[presetName]
        if presetInfo then
            local presetPerm = presetInfo.perm
            if presetPerm and presetPerm ~= "" then
                if not checkPerm(source, presetPerm) then
                    TriggerClientEvent("Notify", source, "Erro", "Você não possui a permissão: " .. presetPerm, "vermelho", 5000)
                    return
                end
            end
            
            local Model = vRP.ModelPlayer(source)
            if presetInfo[Model] then
                TriggerClientEvent("skinshop:Apply", source, presetInfo[Model])
            else
                TriggerClientEvent("Notify", source, "Erro", "Esse preset não possui roupas para o seu modelo atual.", "vermelho", 5000)
            end
        end
    end
end)

RegisterNetEvent("cloakroom:removePreset")
AddEventHandler("cloakroom:removePreset", function()
    local source = source
    TriggerClientEvent("skinshop:setremover", source)
end)