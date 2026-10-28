
--------------------------------
-- [ CONEXAO ] --
--------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()
src = {}
Tunnel.bindInterface(GetCurrentResourceName(),src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())
Config = module(GetCurrentResourceName(), "config/config")

local loaded = false
local loaded2 = false

local TabelasAnims = {}
TabelasAnims["carregar"] = {}
TabelasAnims["carregarb"] = {}
TabelasAnims["beijar"] = {}
TabelasAnims["all"] = {}

local TabelaUsos = {}
local TabelaFavoritos = {}


SetSQL1 = function()
    vRP.Prepare("Night_AnimDupla/SQL", [[
        CREATE TABLE IF NOT EXISTS Night_AnimDupla(
            id int(11) NOT NULL AUTO_INCREMENT,
            user_id INTEGER,
            animacao TEXT,
            PRIMARY KEY (id)
        )
    ]])

    vRP.Query("Night_AnimDupla/SQL")
    vRP.Prepare("Night_AnimDupla/GetFavoritos", "SELECT * FROM Night_AnimDupla")
    vRP.Prepare("Night_AnimDupla/GetFavoritos2", "SELECT * FROM Night_AnimDupla WHERE user_id = @user_id and animacao = @animacao")
    vRP.Prepare("Night_AnimDupla/GetFavoritos3", "SELECT * FROM Night_AnimDupla WHERE user_id = @user_id and id = @id")
    vRP.Prepare("Night_AnimDupla/insert_favoritos", "INSERT INTO Night_AnimDupla(user_id, animacao) VALUES(@user_id, @animacao)")
    vRP.Prepare("Night_AnimDupla/delete_favoritos","DELETE FROM Night_AnimDupla WHERE id = @id")
end

SetSQL = function()

    TabelasAnims["carregar"] = {}
    TabelasAnims["carregarb"] = {}
    TabelasAnims["beijar"] = {}
    TabelasAnims["dancas"] = {}
    TabelasAnims["all"] = {}

    local totalUsos = CalcularTotalUsos(TabelaUsos)

    for k, v in pairs(Config.Comandos) do
        TabelaUsos[k] = PuxarIndexQuantidade(k)
        local quantidade = TabelaUsos[k]
        local porcentagem = totalUsos > 0 and (quantidade / totalUsos * 100) or 0
        porcentagem = math.floor(porcentagem * 100) / 100
        local entrada = {
            k = k, 
            nome = v.nome_anim, 
            quantidade = TabelaUsos[k],
            porcentagem = porcentagem
        }

        if string.match(k, "^carregar%d*$") then
            table.insert(TabelasAnims["carregar"], entrada)
        elseif v.forcar_categoria and v.forcar_categoria == "carregarb" then
            table.insert(TabelasAnims["carregarb"], entrada)
        elseif string.match(k, "^carregarb") then
            table.insert(TabelasAnims["carregarb"], entrada)
        elseif k == "beijar" then
            table.insert(TabelasAnims["beijar"], entrada)
        end

        table.insert(TabelasAnims["all"], entrada)
    end

    if not loaded2 then
        loaded2 = true
        local SQLROUBOS2 = vRP.Query("Night_AnimDupla/GetFavoritos")
        if SQLROUBOS2[1] then
            for k,v in pairs(SQLROUBOS2) do
                if not TabelaFavoritos[v.user_id] then
                    TabelaFavoritos[v.user_id] = {}
                end

                testeDsa = PuxarIndexQuantidade(v.animacao)
                local quantidade = testeDsa
                local porcentagem = totalUsos > 0 and (quantidade / totalUsos * 100) or 0
                porcentagem = math.floor(porcentagem * 100) / 100

                local entrada = {
                    user_id = v.user_id, 
                    nome = Config.Comandos[v.animacao].nome_anim, 
                    animacao = v.animacao,
                    id = v.id,
                    quantidade = testeDsa,
                    porcentagem = porcentagem
                }

                table.insert(TabelaFavoritos[v.user_id], entrada)
            end
        end
    end

end

SQLAtt = function()
    TabelaFavoritos = {}
    local totalUsos = CalcularTotalUsos(TabelaUsos)
    local SQLROUBOS2 = vRP.Query("Night_AnimDupla/GetFavoritos")
    if SQLROUBOS2[1] then
        for k,v in pairs(SQLROUBOS2) do
            if not TabelaFavoritos[v.user_id] then
                TabelaFavoritos[v.user_id] = {}
            end

            testeDsa = PuxarIndexQuantidade(v.animacao)
            local quantidade = testeDsa
            local porcentagem = totalUsos > 0 and (quantidade / totalUsos * 100) or 0
            porcentagem = math.floor(porcentagem * 100) / 100

            local entrada = {
                user_id = v.user_id, 
                nome = Config.Comandos[v.animacao].nome_anim, 
                animacao = v.animacao,
                id = v.id,
                quantidade = testeDsa,
                porcentagem = porcentagem
            }

            table.insert(TabelaFavoritos[v.user_id], entrada)
        end
    end

end

CreateThread(function()
    SetSQL1()
    SetSQL()
    loaded = true
end)

CreateThread(function()
    while true do 
        for k,v in pairs(TabelaUsos) do
            if loaded then
                AdicionarNumero(k,v)
            end
        end
        if loaded then
            SetSQL()
        end
        Wait(5*60000)
        --Wait(5000)
    end
end)

local carregando = {}

local function GetNearestPlayer(source, radius)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local nearestPlayer = nil
    local nearestDistance = radius + 0.0001

    for _, target in ipairs(GetPlayers()) do
        local targetSrc = tonumber(target)
        if targetSrc ~= source then
            local targetPed = GetPlayerPed(targetSrc)
            if targetPed ~= 0 then
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(coords - targetCoords)
                if distance <= nearestDistance then
                    nearestDistance = distance
                    nearestPlayer = targetSrc
                end
            end
        end
    end
    return nearestPlayer
end

src.PegarJogador = function(index,nomeanim)

    local source = source
    local user_id = vRP.Passport(source)
    local identity = vRP.Identity(user_id)
    local identity_name = identity and identity.Name or "Sem"
    local identity_name2 = identity and identity.Lastname or "Nome"

    local reqItem = Config.Comandos[index] and Config.Comandos[index].item
    if reqItem and reqItem ~= "" then
        if not vRP.ConsultItem(user_id, reqItem, 1) then
            TriggerClientEvent("Notify", source, "Erro", "Você não possui uma corda!", "vermelho",5000)
            return
        end
    end

    local otherPlayer = GetNearestPlayer(source, 5.0)
    if otherPlayer then
        local nuser_id = vRP.Passport(otherPlayer)
        local request = true

        if vCLIENT.carregandoVerify(otherPlayer) then
            TriggerClientEvent("Notify",source,"Erro","Não é possível iniciar essa animação com esse usuário no momento","vermelho",5000)
            return 
        end

        local isSourceAdult = vCLIENT.ModelPlayer(source, Config.Peds.adultos)
        local isSourceBaby = vCLIENT.ModelPlayer(source, Config.Peds.baby)

        local isOtherAdult = vCLIENT.ModelPlayer(otherPlayer, Config.Peds.adultos)
        local isOtherBaby = vCLIENT.ModelPlayer(otherPlayer, Config.Peds.baby)
        if isSourceBaby and Config.Comandos[index].adulto then
            TriggerClientEvent("Notify", source, "Erro", "Crianças não podem iniciar animações de adultos","vermelho",5000)
            return
        end

        if isSourceAdult and Config.Comandos[index].baby then
            TriggerClientEvent("Notify", source, "Erro", "Adultos não podem iniciar animações de crianças","vermelho",5000)
            return
        end

        if isSourceBaby and isOtherAdult then
            TriggerClientEvent("Notify", source, "Erro", "Crianças não podem iniciar animações com adultos","vermelho",5000)
            TriggerClientEvent("Notify", otherPlayer, "Erro", "Uma criança tentou iniciar uma animação com você","vermelho",5000)
            return
        end

        if Config.Comandos[index].adulto and isOtherBaby then
            TriggerClientEvent("Notify", source, "Erro", "Não é possível iniciar essa animação com uma criança","vermelho",5000)
            TriggerClientEvent("Notify", otherPlayer, "Erro", "Um adulto tentou iniciar uma animação de adulto com você","vermelho",5000)
            return
        end

        if Config.Comandos[index].baby and isOtherAdult then
            TriggerClientEvent("Notify", source, "Erro", "Não é possível iniciar essa animação com um adulto","vermelho",5000)
            TriggerClientEvent("Notify", otherPlayer, "Erro", "Uma criança tentou iniciar uma animação de criança com você","vermelho",5000)
            return
        end

        local request = vRP.Request(otherPlayer, "Animações", "O jogador <b>"..identity_name.." "..identity_name2.."</b> deseja te <b>"..nomeanim.."</b>. Você aceita?")
        if request then
            local anim = Config.Comandos[index]
            local attachs = Config.Comandos[index].attachsInfos
            carregando[user_id] = otherPlayer
            carregando[nuser_id] = source
            TabelaUsos[index] = parseInt(TabelaUsos[index]) + 1
                        
            if anim.attachsInfosM then
                TriggerClientEvent(""..GetCurrentResourceName()..":SetId",otherPlayer,source)
                TriggerClientEvent(""..GetCurrentResourceName()..":Pegar",source,otherPlayer,index)
            else
                TriggerClientEvent(""..GetCurrentResourceName()..":SetId",source,otherPlayer)
                TriggerClientEvent(""..GetCurrentResourceName()..":Pegar",otherPlayer,source,index)
            end
            if anim.anim1 then
                vCLIENT.playAnim(source,attachs[8], anim.anim1,attachs[9],attachs[10])
            end
            if attachs[11] then
                vCLIENT.playAnim(otherPlayer,false,anim.anim2,attachs[11])
            else
                vCLIENT.playAnim(otherPlayer,false,anim.anim2,true)
            end
            Citizen.Wait(500)
            if anim.anim3 then
                vCLIENT.playAnim(otherPlayer,true,anim.anim3,true)
            end
        end
    else
        return false
    end
end

src.CancelarAnim = function()
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        if carregando[user_id] then
            TriggerClientEvent(""..GetCurrentResourceName()..":CancelarAnim",source)
            TriggerClientEvent(""..GetCurrentResourceName()..":CancelarAnim",carregando[user_id])
            local anotherSource = carregando[user_id]
            vRPclient.removeObjects(source)
            vRPclient.removeObjects(anotherSource)
            carregando[user_id] = nil
            carregando[anotherSource] = nil
        end
    end
end

src.GetTabelas = function(tipo)
    local source = source
    local user_id = vRP.Passport(source)
    if tipo == "favoritos" and TabelaFavoritos[user_id] then
        return TabelaFavoritos[user_id]
    else
        return TabelasAnims[tipo]
    end
end

src.Contadores = function()
    local source = source
    local user_id = vRP.Passport(source)
    return #((TabelasAnims and TabelasAnims['all']) or {}),
           #((TabelasAnims and TabelasAnims['carregar']) or {}),
           #((TabelasAnims and TabelasAnims['carregarb']) or {}),
           #((TabelasAnims and TabelasAnims['beijar']) or {}),
           CalcularTotalUsos(TabelaUsos or {}),
           #((TabelaFavoritos and TabelaFavoritos[user_id]) or {}),
           #((TabelasAnims and TabelasAnims['dancas']) or {})
end

local filePath = 'usos.json'

function LoadNumbers()
    local file = LoadResourceFile(GetCurrentResourceName(), filePath)
    if file then
        return json.decode(file) or {}
    end
    return {}
end

function SaveNumbers(data)
    SaveResourceFile(GetCurrentResourceName(), filePath, json.encode(data), -1)
end

function AdicionarNumero(index, quantidade)
    local numbers = LoadNumbers()
    numbers[index] = quantidade
    SaveNumbers(numbers)
    return true
end

function PuxarIndexQuantidade(index)
    local numbers = LoadNumbers()
    return numbers[index] or 0
end

function CalcularTotalUsos(tabelaUsos)
    local tabela_N = LoadNumbers()
    local total = 0
    for _, quantidade in pairs(tabela_N) do
        total = total + quantidade
    end
    return total
end

local LastAddTime = {}

src.addFavoritos = function(k)
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then

        local currentTime = os.time()
        if LastAddTime[user_id] and (currentTime - LastAddTime[user_id] < 15) then
            TriggerClientEvent("Notify", source, "Erro", "Aguarde " .. (15 - (currentTime - LastAddTime[user_id])) .. " segundos para adicionar outro favorito.","vermelho",5000)
            return
        end

        LastAddTime[user_id] = currentTime

        local SQL = vRP.Query("Night_AnimDupla/GetFavoritos2", {user_id = user_id, animacao = k })
        if SQL[1] then
            TriggerClientEvent("Notify",source,"Erro","Essa animaçao ja esta nos favoritos.","vermelho",5000)
            return
        end

        vRP.Query("Night_AnimDupla/insert_favoritos", { user_id = user_id, animacao = k })

        if not TabelaFavoritos[user_id] then
            TabelaFavoritos[user_id] = {}
        end

        local totalUsos = CalcularTotalUsos(TabelaUsos)
        local quantidade = PuxarIndexQuantidade(k)
        local porcentagem = totalUsos > 0 and (quantidade / totalUsos * 100) or 0
        porcentagem = math.floor(porcentagem * 100) / 100

        local entrada = {
            user_id = user_id,
            nome = Config.Comandos[k].nome_anim,
            animacao = k,
            id = #TabelaFavoritos[user_id] + 1, 
            quantidade = quantidade,
            porcentagem = porcentagem
        }

        table.insert(TabelaFavoritos[user_id], entrada)

        --SQLAtt()
    end
end

local LastAddTime2 = {}

src.remFavoritos = function(id)
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then

        local currentTime = os.time()
        if LastAddTime2[user_id] and (currentTime - LastAddTime2[user_id] < 15) then
            TriggerClientEvent("Notify", source, "Erro", "Aguarde " .. (15 - (currentTime - LastAddTime2[user_id])) .. " segundos para remover outro favorito.","vermelho",5000)
            return
        end

        LastAddTime2[user_id] = currentTime

        if TabelaFavoritos[user_id] then
            for i, v in ipairs(TabelaFavoritos[user_id]) do
                if parseInt(v.id) == parseInt(id) then
                    table.remove(TabelaFavoritos[user_id], i)
                    break
                end
            end
        end

        local SQL = vRP.Query("Night_AnimDupla/GetFavoritos3", {user_id = user_id, id = id })
        if SQL[1] then
            vRP.Query("Night_AnimDupla/delete_favoritos", { id = parseInt(id) })
            --SQLAtt()
        end
    end
end
