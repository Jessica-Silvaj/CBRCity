-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("Night_Maquininha", Creative)
vCLIENT = Tunnel.getInterface("Night_Maquininha")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.getUserData()
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local userName = ""

    if Identity then
        userName = Identity.Name .. " " .. Identity.Lastname
    end

    return Passport, userName
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERDATAFROMID
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.getUserDataFromId(Passport)
    if not Passport or Passport == 0 then return end

    local Identity = vRP.Identity(Passport)
    local userName = ""

    if Identity then
        userName = Identity.Name .. " " .. Identity.Lastname
    end

    return userName, Passport
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.createObject(model, x, y, z)
    local spawnObjects = 0
    local mHash = GetHashKey(model)
    local Object = CreateObject(mHash, x, y, z, true, true, false)

    while not DoesEntityExist(Object) and spawnObjects <= 1000 do
        spawnObjects = spawnObjects + 1
        Wait(1)
    end

    if DoesEntityExist(Object) then
        return true, NetworkGetNetworkIdFromEntity(Object)
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.tryDeleteObject(entIndex)
    local idNetwork = NetworkGetEntityFromNetworkId(entIndex)
    if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) and GetEntityType(idNetwork) == 3 then
        DeleteEntity(idNetwork)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDBILL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.sendBill(targetPassport, value)
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local FullName = Identity.Name .. " " .. Identity.Lastname
    local targetSource = vRP.Source(targetPassport)

    if targetSource then
        if vRP.Request(targetSource, string.format("O jogador %s está te cobrando $%s. Deseja efetuar o pagamento?", FullName, Dotted(value))) then
            if vRP.PaymentFull(targetPassport, value) then
                vRP.GiveBank(Passport, value)
                TriggerClientEvent("Notify", targetSource, "Sucesso", "Você efetuou o pagamento com sucesso.", "verde", 5000)
                TriggerClientEvent("Notify", source, "Sucesso", string.format("Sua cobrança foi paga com sucesso e você recebeu $%s.", value), "verde", 5000)
            else
                TriggerClientEvent("Notify", targetSource, "Erro", "Você não possui dinheiro suficiente.", "vermelho",5000)
                TriggerClientEvent("Notify", source, "Erro", "O jogador não possui dinheiro suficiente.", "vermelho", 5000)
            end
        else
            TriggerClientEvent("Notify", source, "Erro", "O jogador recusou sua cobrança.", "vermelho", 5000)
        end
    else
        TriggerClientEvent("Notify", source, "Erro", "Jogador não encontrado ou offline.", "vermelho",5000)
    end

    return false
end