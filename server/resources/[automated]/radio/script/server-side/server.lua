--------------------------------
-- [ CONEXAO ] --
--------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
local idgens = Tools.newIDGenerator()
src = {}
Tunnel.bindInterface(GetCurrentResourceName(),src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

-- Prepara a query para puxar informações da rádio do banco de dados (Night_Management)
vRP.Prepare("radio/get_radio", "SELECT * FROM radios WHERE frequencia = @frequencia")

local JogadoresConectados = {}

local function splitString(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function CheckRadioPermission(Passport, permsString)
    if not permsString or permsString == "" then return true end
    
    local hasPerm = false
    local splitPerms = splitString(permsString, ";")
    for _, p in ipairs(splitPerms) do
        local pTrim = trim(p)
        if pTrim ~= "" then
            local splitComma = splitString(pTrim, ",")
            local group = trim(splitComma[1])
            local level = splitComma[2] and tonumber(splitComma[2]) or nil
            
            if level then
                if vRP.HasGroup(Passport, group, level) then
                    hasPerm = true
                    break
                end
            else
                if vRP.HasGroup(Passport, group) then
                    hasPerm = true
                    break
                end
            end
        end
    end
    
    return hasPerm
end

local CachedRadios = {}
local isRadiosLoaded = false

RegisterNetEvent("Night_Management:requestRadios")
AddEventHandler("Night_Management:requestRadios", function()
    local source = source
    if source ~= "" and source ~= nil then return end
    local radios = exports.oxmysql:executeSync("SELECT * FROM radios") or {}
    CachedRadios = {}
    for _, r in pairs(radios) do
        CachedRadios[r.frequencia] = r.permissao
    end
    isRadiosLoaded = true
end)

src.CheckRadio = function(frequencia)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if isRadiosLoaded and CachedRadios[frequencia] then
            local perms = CachedRadios[frequencia]
            if perms and perms ~= "" then
                -- Checa a permissão do jogador com hierarquia e múltiplos grupos
                if CheckRadioPermission(Passport, perms) then
                    return true, true -- permitted, private
                else
                    return false, true -- not permitted, private
                end
            else
                -- Rádio registrada, mas sem restrição de permissão
                return true, false -- permitted, not private
            end
        end
        -- Rádio não registrada na tabela ou base não carregada, então é pública e permitida
        return true, false 
    end
    return false, false
end

RegisterNetEvent("radio:radioUpdated")
AddEventHandler("radio:radioUpdated", function(frequencia, permissao)
    if permissao and permissao ~= "" then
        CachedRadios[frequencia] = permissao
    else
        CachedRadios[frequencia] = nil
    end

    if JogadoresConectados[frequencia] then
        for Passport, srcId in pairs(JogadoresConectados[frequencia]) do
            if not CheckRadioPermission(Passport, permissao) then
                JogadoresConectados[frequencia][Passport] = nil
                TriggerClientEvent("radio:forceDisconnect", srcId, frequencia)
            end
        end
    end
end)

src.EntrarRadio = function(frequencia)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then

        if not JogadoresConectados[frequencia] then
            JogadoresConectados[frequencia] = {}
        end

        JogadoresConectados[frequencia][Passport] = source
    end
end

src.SairRadio = function(frequencia)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then

        if not JogadoresConectados[frequencia] then
            JogadoresConectados[frequencia] = {}
        end

        JogadoresConectados[frequencia][Passport] = nil
    end
end

local TableReturn = {}

src.GetPlayers = function(frequencia)
    local source = source
    local Passport = vRP.Passport(source)
    TableReturn[Passport] = {}

    if JogadoresConectados[frequencia] then
        for k,v in pairs(JogadoresConectados[frequencia]) do
            local identity = vRP.Identity(k)
            if identity then
                table.insert(TableReturn[Passport], { nome = identity.Name .. " " .. identity.Lastname, id = k })
            end
        end
    end

    return TableReturn[Passport]
end

AddEventHandler("playerDisconnect",function(Passport)

	for k, v in pairs(JogadoresConectados) do
		if v[Passport] then
			v[Passport] = nil
		end
	end

end)

function src.hasRadio()
    local source = source
    local Passport = vRP.Passport(source)
    return vRP.ConsultItem(Passport, 'radio',1)
end

RegisterNetEvent('pessoafalando')
AddEventHandler('pessoafalando',function(status,freq)
	local source = source
	local Passport = vRP.Passport(source)
    local identity = vRP.Identity(Passport)
    if JogadoresConectados[freq] then
        for key, value in pairs(JogadoresConectados[freq]) do
            async(function ()
                if identity then
                    TriggerClientEvent('client:pessoafalando',value,status,freq,Passport,identity.Name .. " " .. identity.Lastname)
                end
            end)
        end
    end
end)

AddEventHandler("Connect",function(Passport,source)
    TriggerClientEvent("radio:GetRadio",source)
end)
