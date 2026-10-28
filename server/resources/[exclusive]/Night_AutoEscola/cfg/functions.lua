-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy  = module("vrp","lib/Proxy")
vRP    = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILS
-----------------------------------------------------------------------------------------------------------------------------------------
if not parseInt then
    parseInt = function(v) return math.floor(tonumber(v) or 0) end
end
-----------------------------------------------------------------------------------------------------------------------------------------
Functions = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.Passport(source)
    return vRP.Passport(source)
end

-- Resolve/valida o PASSPORT de um alvo (o valor digitado/selecionado JÁ é o passaporte,
-- NÃO é o source). Espelha a convenção da base: parseInt + vRP.Identity para validar.
function Functions.TargetPassport(value)
    local Passport = parseInt(value)
    if not Passport or Passport <= 0 then return nil end
    if not vRP.Identity(Passport) then return nil end
    return Passport
end

function Functions.FullName(Passport)
    if not Passport then return "Desconhecido" end
    if vRP.FullName then
        local Nome = vRP.FullName(Passport)
        if Nome and Nome ~= NameDefault then return Nome end
    end
    local Identity = vRP.Identity and vRP.Identity(Passport) or nil
    if Identity then
        local N = Identity.Name     or ""
        local L = Identity.Lastname or ""
        if N ~= "" and L ~= "" then return N .. " " .. L end
        if N ~= "" then return N end
    end
    return "Passaporte " .. tostring(Passport)
end

-- Foto/avatar do jogador (tabela `avatars` da base) para mostrar no documento
function Functions.GetAvatar(Passport)
    if not Passport then return nil end
    local Ok, Img = pcall(function() return vRP.Avatar(Passport) end)
    if Ok and type(Img) == "string" and Img ~= "" then return Img end
    return nil
end

-- Converte o campo Daily "DD-MM-YYYY-X" para "DD/MM/YYYY"
function Functions.Nascimento(Passport)
    local Identity = vRP.Identity and vRP.Identity(Passport) or nil
    if not Identity or not Identity.Daily then return "N/D" end
    local P = {}
    for v in Identity.Daily:gmatch("[^%-]+") do P[#P+1] = v end
    if #P >= 3 then return P[1] .. "/" .. P[2] .. "/" .. P[3] end
    return "N/D"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.HasPermission(Passport, Permission)
    if not Passport then return false end
    if not Permission or Permission == "" then return true end
    local Group, Level = Permission:match("^(.+)@(%d+)$")
    if Group then
        return vRP.HasGroup(Passport, Group, tonumber(Level)) and true or false
    end
    return (vRP.HasPermission(Passport, Permission) or vRP.HasGroup(Passport, Permission, 1)) and true or false
end

function Functions.HasAnyPermission(Passport, Perms)
    if not Passport then return false end
    if not Perms or #Perms == 0 then return true end
    for _, Perm in ipairs(Perms) do
        if Functions.HasPermission(Passport, Perm) then return true end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFICAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.Notify(source, kind, message)
    if not source or source <= 0 then return end
    TriggerClientEvent("Notify", source, "Auto Escola", tostring(message or ""), tostring(kind or "info"), 6000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CNH (categorias aprovadas)
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.GetCNH(Passport)
    local Data = vRP.UserData(Passport, "autoescola_cnh")
    if type(Data) == "string" then
        local Ok, Parsed = pcall(json.decode, Data)
        if Ok and Parsed then Data = Parsed end
    end
    if type(Data) ~= "table" then return {} end
    
    -- Normalize corrupted data from old /acnh command
    for k, v in pairs(Data) do
        if type(v) == "number" then
            Data[k] = true
        end
    end
    
    return Data
end

function Functions.SaveCNH(Passport, Data)
    vRP.Query("playerdata/SetData", {
        Passport    = Passport,
        Name        = "autoescola_cnh",
        Information = json.encode(Data or {}),
    })
end

function Functions.HasCNH(Passport, Category)
    return Functions.GetCNH(Passport)[Category] and true or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PONTOS (sistema de 12 pontos - Portugal)
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.GetPontos(Passport)
    local v = vRP.UserData(Passport, "autoescola_pontos")
    local n = tonumber(v)
    if n ~= nil then return n end
    return pontosConfig.inicial
end

function Functions.SetPontos(Passport, Qty)
    Qty = math.max(0, math.min(pontosConfig.maximo, tonumber(Qty) or 0))
    vRP.Query("playerdata/SetData", {
        Passport    = Passport,
        Name        = "autoescola_pontos",
        Information = tostring(Qty),
    })
    return Qty
end

function Functions.RemovePontos(Passport, Qty)
    local Current = Functions.GetPontos(Passport)
    return Functions.SetPontos(Passport, Current - (tonumber(Qty) or 1))
end

function Functions.AddPontos(Passport, Qty)
    local Current = Functions.GetPontos(Passport)
    return Functions.SetPontos(Passport, Current + (tonumber(Qty) or 1))
end

function Functions.CartaSuspensa(Passport)
    return Functions.GetPontos(Passport) >= pontosConfig.maximo
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VALIDADE (data de expiração por categoria)
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.GetValidade(Passport)
    local v = vRP.UserData(Passport, "autoescola_validade")
    if type(v) == "string" then
        local Ok, Parsed = pcall(json.decode, v)
        if Ok and Parsed then v = Parsed end
    end
    if type(v) == "table" then return v end
    return {}
end

function Functions.SetValidade(Passport, Cat, DateStr)
    local V = Functions.GetValidade(Passport)
    V[Cat]  = DateStr
    vRP.Query("playerdata/SetData", {
        Passport    = Passport,
        Name        = "autoescola_validade",
        Information = json.encode(V),
    })
end

-- Retorna true se a data "DD/MM/YYYY" já passou
function Functions.IsExpirada(DateStr)
    if not DateStr then return false end
    local D, M, Y = DateStr:match("(%d+)/(%d+)/(%d+)")
    if not D then return false end
    local Ts = os.time({ year = tonumber(Y), month = tonumber(M), day = tonumber(D), hour = 23, min = 59, sec = 59 })
    return os.time() > Ts
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWNS (espera após reprovar)
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.GetCooldowns(Passport)
    local v = vRP.UserData(Passport, "autoescola_cooldown")
    if type(v) == "string" then
        local Ok, Parsed = pcall(json.decode, v)
        if Ok and Parsed then v = Parsed end
    end
    if type(v) == "table" then return v end
    return {}
end

function Functions.SetCooldown(Passport, Cat, Timestamp)
    local C = Functions.GetCooldowns(Passport)
    C[Cat]  = Timestamp
    vRP.Query("playerdata/SetData", {
        Passport    = Passport,
        Name        = "autoescola_cooldown",
        Information = json.encode(C),
    })
end

function Functions.GetCooldownRestante(Passport, Cat)
    local Cooldowns = Functions.GetCooldowns(Passport)
    local Ts = Cooldowns[Cat]
    if not Ts or os.time() >= Ts then return 0 end
    return Ts - os.time()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATESTADO MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.GetAtestadoTs(Passport)
    local v = vRP.UserData(Passport, "autoescola_atestado")
    return tonumber(v)
end

function Functions.SetAtestado(Passport, Timestamp)
    vRP.Query("playerdata/SetData", {
        Passport    = Passport,
        Name        = "autoescola_atestado",
        Information = tostring(Timestamp),
    })
end

function Functions.AtestadoValido(Passport)
    local Ts = Functions.GetAtestadoTs(Passport)
    return Ts ~= nil and os.time() < Ts
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTÁRIO / PAGAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
function Functions.HasItem(Passport, Item)
    local Inv = vRP.Inventory(Passport) or {}
    for _, Slot in pairs(Inv) do
        if type(Slot) == "table" and Slot.item == Item and (Slot.amount or 0) >= 1 then
            return true
        end
    end
    return false
end

function Functions.PayExam(Passport, Amount)
    return vRP.PaymentFull(Passport, Amount) and true or false
end

function Functions.GiveItem(Passport, Item, Amount)
    vRP.GenerateItem(Passport, Item, Amount or 1, false)
end

function Functions.TakeItem(Passport, Item, Amount)
    return vRP.TakeItem(Passport, Item, Amount or 1, false) and true or false
end
