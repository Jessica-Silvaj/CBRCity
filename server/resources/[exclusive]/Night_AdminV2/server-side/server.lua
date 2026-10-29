-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("Night_AdminV2",Creative)
vCLIENT = Tunnel.getInterface("Night_AdminV2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
local function ItemList(...) return exports["vrp"]:ItemList(...) end
local function ItemName(...) return exports["vrp"]:ItemName(...) end
local function ItemIndex(...) return exports["vrp"]:ItemIndex(...) end
local function ItemDurability(...) return exports["vrp"]:ItemDurability(...) end
local function VehicleList(...) return exports["vrp"]:VehicleList(...) end
local function VehicleName(...) return exports["vrp"]:VehicleName(...) end
local function VehicleWeight(...) return exports["vrp"]:VehicleWeight(...) end
local function VehicleMode(...) return exports["vrp"]:VehicleMode(...) end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
-- Removido jesterInstagram: vRP.Prepare("night_adminv2/jesterInstagram", "SELECT * FROM smartphone_instagram WHERE user_id = @user_id")
vRP.Prepare("night_adminv2/infosTeleports", "SELECT * FROM night_teleportes WHERE user_id = @user_id") 
vRP.Prepare("night_adminv2/insertTeleports", "INSERT INTO night_teleportes(user_id,id,nome,coords) VALUES(@user_id,@id,@nome,@coords)") 
vRP.Prepare("night_adminv2/deleteTeleport","DELETE FROM night_teleportes WHERE id = @id")
vRP.Prepare("night_adminv2/infosPunicoes", "SELECT * FROM night_punicoes")
vRP.Prepare("accounts/GetAllBanned", [[SELECT License, Banned, Reason FROM accounts WHERE Banned <> 0]])
vRP.Prepare("user/getIdentityByLicense", "SELECT id, Name, Lastname FROM characters WHERE license = @license LIMIT 1")
vRP.Prepare("night_adminv2/selectPunicao", "SELECT * FROM night_punicoes WHERE user_id = @user_id")
vRP.Prepare("night_adminv2/insertPunicao", "INSERT INTO night_punicoes (user_id, staffid, motivo, status, contagem, data, tempo_restante) VALUES (@user_id, @staffid, @motivo, @status, @contagem, @data, @tempo_restante)")
vRP.Prepare("night_adminv2/selectActiveWarnings", "SELECT * FROM night_punicoes WHERE tempo_restante > 0 AND status = 'ADVERTÊNCIA'")
vRP.Prepare("night_adminv2/updateWarningTime", "UPDATE night_punicoes SET tempo_restante = @tempo_restante WHERE user_id = @user_id AND status = @status AND contagem = @contagem")
vRP.Prepare("night_adminv2/deletePunicao", "DELETE FROM night_punicoes WHERE user_id = @user_id AND status = @status AND contagem = @contagem")
vRP.Prepare("characters/getBank", "SELECT bank FROM characters WHERE id = @user_id LIMIT 1")
vRP.Prepare("night_adminv2/AllUsers","SELECT id FROM characters ORDER BY id ASC")
vRP.Prepare("night_adminv2/UserPermissions", "SELECT Name FROM entitydata WHERE Name LIKE 'Permissions:%' AND Information LIKE @Key")
vRP.Prepare("night_adminv2/getHouseVaults", "SELECT Name, Information FROM entitydata WHERE Name LIKE @Name")
vRP.Prepare("night_adminv2/CheckPhone", "SELECT id FROM characters WHERE Phone = @Phone")
vRP.Prepare("night_adminv2/UpdatePhonePhones", "UPDATE phone_phones SET phone_number = @Phone WHERE owner_id = @Passport")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DB
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    vRP.Prepare("night_adminv2/night_teleportes", [[
        CREATE TABLE IF NOT EXISTS night_teleportes(
            user_id INTEGER,
            id longtext,
            nome longtext,
            coords longtext
        )
    ]])
    
    vRP.Prepare("night_adminv2/night_punicoes", [[
        CREATE TABLE IF NOT EXISTS night_punicoes(
            user_id INTEGER,
            staffid LONGTEXT,
            motivo LONGTEXT,
            status LONGTEXT,
            contagem LONGTEXT,
            data LONGTEXT,
            tempo_restante INTEGER
        )
    ]])

    vRP.Query("night_adminv2/night_teleportes")
    vRP.Query("night_adminv2/night_punicoes")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local PainelLogs = {}
local FreezePlayer = {}
local Spectate = {}
ScreenShotInstances = {}
local anunciosLogs = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckPermission()
    local Source = source
    local Passport = vRP.Passport(Source)

    return vRP.HasPermission(Passport, Config["Perms"]["OpenPainel"][1],Config["Perms"]["OpenPainel"][2])
end

function Creative.ReturnNames()
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    if Passport then
        return Identity["Name"],Identity["Lastname"],"./images/profile.png"
    end
end

function Creative.ReturnServices()
    local Source = source
    local Passport = vRP.Passport(Source)

    local Players = 0
    local Police = 0
    local Ilegal = 0
    local Staff = 0

    Players = GetNumPlayerIndices()
    _,Police = vRP.NumPermission(Config["Perms"]["Policia"])
    _,Staff = vRP.NumPermission(Config["Perms"]["Staff"])

    for index,PermissionName in pairs(Config["Perms"]["Bandits"]) do
        local IService, Iamount = vRP.NumPermission(PermissionName)
        Ilegal = Ilegal + Iamount
    end

    return Players,Police,Ilegal,Staff
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ConsultCoordsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    teleportTables = {}

    if Passport then
        local SelectQuery = vRP.Query("night_adminv2/infosTeleports", {user_id = Passport})
        if SelectQuery[1] then
            for k,v in pairs(SelectQuery) do
                table.insert(teleportTables,{id = v["id"],nome = v["nome"], coord = json.decode(v["coords"]) })
            end
        end
    end

    return teleportTables
end

function Creative.AddTeleport(ReturnName)
    local Source = source
    local Passport = vRP.Passport(Source)
    if Passport then
        if vRP.HasPermission(Passport,Config["Perms"]["AddTeleport"][1],Config["Perms"]["AddTeleport"][2]) then
            if ReturnName ~= "" then 
                local PlayerPed = GetPlayerPed(Source)
                local CoordsPlayer = GetEntityCoords(PlayerPed)
                local RandomIdentification = math.random(1,99999)

                local Identity = vRP.Identity(Passport)
                if Identity then
                    table.insert(PainelLogs,{ user_id = Passport, cor = "azul",nome = Identity["Name"].." "..Identity["Lastname"],motivo = "Adicionou um novo teleport, nome do teleport: "..ReturnName.."." })
                end

                vRP.Query("night_adminv2/insertTeleports", { user_id = Passport, id = RandomIdentification, nome = ReturnName, coords = json.encode(CoordsPlayer)})
                return true
            else
                TriggerClientEvent("Notify",Source,"Erro","Você precisa inserir um Nome.","vermelho",10000)
            end
        else
            TriggerClientEvent("Notify",Source,"Erro","Você não tem Permissão.","vermelho",10000)
        end
    end
end

function Creative.DeleteTeleport(ReturnIdentification,ReturnName)
    local Source = source
    local Passport = vRP.Passport(Source)

    if Passport and vRP.HasPermission(Passport,Config["Perms"]["AddTeleport"][1],Config["Perms"]["AddTeleport"][2]) then
        local Identity = vRP.Identity(Passport)
        if Identity then
            table.insert(PainelLogs,{ user_id = Passport, cor = "vermelho",nome = Identity["Name"].." "..Identity["Lastname"],motivo = "Deletou um teleport, nome do teleport: "..ReturnName.."." })
        end

        vRP.Query("night_adminv2/deleteTeleport", { id = ReturnIdentification })
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnLogsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local ReturnLogsList = {}

    if Passport then
        for k,v in ipairs(PainelLogs) do
            local ColorLog = "#ff0000"
            if v["cor"] == "vermelho" then
                ColorLog = "#ff0000"
            elseif v["cor"] == "azul" then
                ColorLog = "#00a2ff"
            elseif v["cor"] == "amarelo" then
                ColorLog = "#ffc400"
            end

            table.insert(ReturnLogsList,{ cor = ColorLog,img = "./images/warning.png",nome = v["nome"],user_id = v["user_id"],motivo = v["motivo"] })
        end
    end

    return ReturnLogsList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnPlayerList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local ControleTables = {}

    local AllUsers = vRP.Query("night_adminv2/AllUsers")
    local OnlinePlayers = vRP.Players()

    for _, user in pairs(AllUsers) do
        local SelectedPassport = user.id
        local Identity = vRP.Identity(SelectedPassport)
        local Status = OnlinePlayers[SelectedPassport] and "ONLINE" or "OFFLINE"

        local foto = "./images/profile.png"

        table.insert(ControleTables, {
            user_id = SelectedPassport,
            nome = Identity["Name"].." "..Identity["Lastname"],
            foto = foto,
            status = Status
        })
    end

    return ControleTables
end

function Creative.SeeInformationsProfile(SelectedPassport)
    local SelectedPassport = tonumber(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)
    if not Identity then return nil end

    local WalletMoney = 0
    if vRP.Source(SelectedPassport) then
        WalletMoney = vRP.ItemAmount(SelectedPassport, "dollar")
    else
        WalletMoney = vRP.ItemAmountOffline(SelectedPassport, "dollar") 
    end

    local BankMoney = 0
    local BankResult = vRP.Query("characters/getBank", { user_id = SelectedPassport })
    if BankResult[1] and BankResult[1].bank then
        BankMoney = tonumber(BankResult[1].bank)
    end

    -- Uma única consulta traz os grupos do jogador, em vez de uma consulta por grupo existente
    local UserGroups = {}
    for _, Row in ipairs(vRP.Query("night_adminv2/UserPermissions", { Key = '%"'..SelectedPassport..'":%' })) do
        local Permission = Row.Name:sub(13)
        if vRP.HasPermission(SelectedPassport, Permission) then
            UserGroups[Permission] = true
        end
    end

    local SelectedWork = "Desempregado"
    for Permission in pairs(UserGroups) do
        if vRP.GroupType(Permission) == "Work" then
            SelectedWork = Permission
            break
        end
    end

    local Vips = {}

    if Config.Perms.VipRoles then
        for _, vipRole in ipairs(Config.Perms.VipRoles) do
            if UserGroups[vipRole.perm] then
                table.insert(Vips, vipRole.name)
            end
        end
    end

    local VipStatus = (#Vips > 0) and table.concat(Vips, ", ") or false
    local VipCoins = vRP.UserGemstone(Identity.License)
    local Img = "./images/profile.png"
    local BannerImage = "./images/banner.gif"

    return 
        Dotted(WalletMoney),
        Dotted(BankMoney),
        Identity.Name,
        Identity.Lastname,
        Identity.License,
        Identity.Phone,
        Sanguine(Identity.Blood),
        SelectedWork,
        VipStatus,
        Dotted(VipCoins),
        Img,
        BannerImage
end

function Creative.GetNameByPassport(passaporte)
    local Identity = vRP.Identity(passaporte)
    if Identity then
        return Identity.Name, Identity.Lastname
    end
end

function Creative.SeeInformationsWarnings()
    local Source = source
    local Passport = vRP.Passport(Source)
    local PunicoesList = {}
    local BanidosRegistrados = {}

    if Passport then
        local Punicoes = vRP.Query("night_adminv2/infosPunicoes", {})
        if Punicoes then
            for _, v in pairs(Punicoes) do
                local SelectedPassport = tonumber(v["user_id"])
                local StaffPassport = tonumber(v["staffid"])
                local Identity = vRP.Identity(SelectedPassport)
                local Identity2 = vRP.Identity(StaffPassport)
                local Identity3 = vRP.Identity(Passport)

                if Identity and Identity2 then
                    local ImageUrl = "./images/profile.png"

                    local SelectedColor = "#fff"
                    local SelectedBackground = "#fff"

                    if string.find(v["status"], "ADVERTÊNCIA") then 
                        SelectedBackground = "rgb(255,102,0)"
                    elseif string.find(v["status"], "BANIDO") then 
                        SelectedBackground = "rgb(255,0,0)"
                    end

                    table.insert(PunicoesList,{
                        user_id = SelectedPassport,
                        myname = Identity3["Name"].." "..Identity3["Lastname"],
                        nome = Identity["Name"].." "..Identity["Lastname"],
                        status = v["status"],
                        contagem = v["contagem"],
                        color = SelectedColor,
                        background = SelectedBackground,
                        motivo = v["motivo"],
                        staff = Identity2["Name"].." "..Identity2["Lastname"].." ["..StaffPassport.."]",
                        foto = ImageUrl,
                        data = v["data"],
                        duracao = tostring(v["contagem"]).." dia(s)"
                    })

                    if v["status"] == "BANIDO" then
                        BanidosRegistrados[SelectedPassport] = true
                    end
                end
            end
        end

        local Banimentos = vRP.Query("accounts/GetAllBanned", {})
        if Banimentos then
            for _, ban in pairs(Banimentos) do
                local IdentityQuery = vRP.Query("user/getIdentityByLicense", { license = ban["License"] })
                if identityQuery and identityQuery[1] then
                    local IdentityAffected = identityQuery[1]
                    local SelectedPassport = tonumber(IdentityAffected.id)

                    if not BanidosRegistrados[SelectedPassport] then
                        local Identity3 = vRP.Identity(Passport)
                        local banTime = tonumber(ban["Banned"]) or 0
                        local duration = "Permanente"

                        if banTime > 0 then
                            duration = os.date("%d/%m/%Y %H:%M", banTime)
                        end

                        table.insert(PunicoesList, {
                            user_id = SelectedPassport,
                            myname = Identity3["Name"].." "..Identity3["Lastname"],
                            nome = IdentityAffected.Name.." "..IdentityAffected.Lastname,
                            status = "BANIDO",
                            contagem = duration,
                            color = "#fff",
                            background = "rgb(255,0,0)",
                            motivo = ban["Reason"] or "Banimento ativo",
                            staff = "Sistema",
                            foto = "./images/profile.png",
                            data = os.date("%d/%m/%Y"),
                            duracao = duration
                        })
                    end
                end
            end
        end
    end

    return PunicoesList
end

function Creative.DeleteAdv(SelectedPassport, SelectedStatus, SelectedContagem)
    local Source = source
    local Passport = vRP.Passport(Source)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["AddAdv"][1], Config["Perms"]["AddAdv"][2]) then

            vRP.Query("night_adminv2/deletePunicao", {
                user_id = SelectedPassport,
                status = SelectedStatus,
                contagem = SelectedContagem
            })

            local Account = vRP.AccountOptimize(SelectedPassport)
            local Identity = vRP.Identity(SelectedPassport)
            local Punicoes = vRP.Query("night_adminv2/selectPunicao", { user_id = SelectedPassport })

            if Account and Identity then
                if #Punicoes <= 0 then
                    vRP.Update("hwid/All", { Account = Account.id, Banned = 1 })
                    vRP.Update("accounts/RemoveBanned", { License = Account.License })
                end

                if SelectedStatus == "BANIDO" then
                    vRP.Update("hwid/All", { Account = Account.id, Banned = 1 })
                    vRP.Update("accounts/RemoveBanned", { License = Account.License })
                end
            end

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = IdentityLog["Name"] .. " " .. IdentityLog["Lastname"],
                    motivo = "Deletou advertência do ID ["..SelectedPassport.."] status ["..SelectedStatus.." "..SelectedContagem.."]."
                })
            end

            return true
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão.", "vermelho", 10000)
        end
    end

    return false
end

function Creative.AddKick(SelectedMotivo, SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["AddKick"][1], Config["Perms"]["AddKick"][2]) then
            local SelectedSource = vRP.Source(SelectedPassport)
            if SelectedSource then
                local IdentityLog = vRP.Identity(Passport)
                local IdentityAffected = vRP.Identity(SelectedPassport)
                if IdentityLog and IdentityAffected then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "amarelo",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Aplicou um kick no id ["..SelectedPassport.."]."
                    })

                    PerformHttpRequest(Config["Webhooks"]["Kick"], function() end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Aplicou um kick**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "👤 No passaporte:", 
                                        value = IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "📌 Motivo:", 
                                        value = SelectedMotivo or "Não informado",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                vRP.Kick(SelectedSource, SelectedMotivo)
                return true
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem Permissão.", "vermelho",10000)
        end
    end

    return false
end

function Creative.AddBan(SelectedMotivo, SelectedPassport, Dias)
    local Source = source
    local Passport = vRP.Passport(Source)

    if not vRP.HasPermission(Passport, Config["Perms"]["AddBan"][1], Config["Perms"]["AddBan"][2]) then
        TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão.", "vermelho", 10000)
        return false
    end

    local Identity = vRP.Identity(SelectedPassport)
    if not Identity then
        TriggerClientEvent("Notify", Source, "Erro", "Jogador não encontrado.", "vermelho", 10000)
        return false
    end

    if not SelectedMotivo or SelectedMotivo == "" or tonumber(SelectedMotivo) then
        SelectedMotivo = "Entre em contato com o Administração da Cidade."
    end

    vRP.SetBanned(SelectedPassport, Dias, "Dias", SelectedMotivo)

    TriggerClientEvent("Notify", Source, "Sucesso", "Você baniu o player por " .. Dias .. " dia(s) com sucesso!", "verde", 10000)

    local IdentityLog = vRP.Identity(Passport)
    if IdentityLog then
        table.insert(PainelLogs, {
            user_id = Passport,
            cor = "vermelho",
            nome = IdentityLog["Name"] .. " " .. IdentityLog["Lastname"],
            motivo = "Aplicou um ban no passaporte [" .. SelectedPassport .. "] motivo [" .. SelectedMotivo .. "] por " .. Dias .. " dias"
        })

        PerformHttpRequest(Config["Webhooks"]["Ban"], function(err, text, headers) end, "POST", json.encode({
            embeds = {{
                title = "**Ban aplicado: " .. SelectedMotivo .. "**",
                fields = {
                    { name = "📝 Autor", value = IdentityLog["Name"] .. " " .. IdentityLog["Lastname"] .. " **#" .. Passport .. "**" },
                    { name = "📝 No passaporte", value = Identity["Name"] .. " " .. Identity["Lastname"] .. " **#" .. SelectedPassport .. "**" },
                    { name = "⏳ Duração", value = Dias .. " dia(s)" }
                },
                footer = {
                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                },
                thumbnail = { url = Config["Webhooks"]["DiscordImageThumbanil"] },
                color = 3092790
            }}
        }), { ["Content-Type"] = "application/json" })
    end

    return true
end

function Creative.AddWarning(SelectedMotivo, SelectedPassport, TempoDias)
    local Source = source
    local Passport = vRP.Passport(Source)
    if not Passport then return false end

    if not vRP.HasPermission(Passport, Config["Perms"]["AddAdv"][1], Config["Perms"]["AddAdv"][2]) then
        TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão.", "vermelho", 10000)
        return false
    end

    local Identity = vRP.Identity(SelectedPassport)
    local Punicoes = vRP.Query("night_adminv2/selectPunicao", {user_id = SelectedPassport})
    local totalAdv = #Punicoes
    local maxAdv = Config.NumeroDeAdvParaBan
    local tempoAdvSegundos = (TempoDias and tonumber(TempoDias) or 7) * 24 * 60 * 60
    local dataAtual = os.date("%d/%m/%Y")

    vRP.Query("night_adminv2/insertPunicao", {
        user_id = SelectedPassport,
        staffid = Passport,
        motivo = SelectedMotivo,
        status = "ADVERTÊNCIA",
        contagem = tostring(totalAdv + 1),
        data = dataAtual,
        tempo_restante = tempoAdvSegundos
    })

    if totalAdv + 1 >= maxAdv then
        vRP.Query("night_adminv2/insertPunicao", {
            user_id = SelectedPassport,
            staffid = Passport,
            motivo = "Banido por excesso de advertências",
            status = "BANIDO",
            contagem = "PERMANENTE",
            data = dataAtual,
            tempo_restante = nil
        })

        vRP.SetBanned(SelectedPassport, Config.TempoDeBanMotivoAdv, "Dias", "Banido por excesso de advertências")
        TriggerClientEvent("Notify", Source, "Sucesso", "Você baniu o player com sucesso!", "verde", 10000)

        local SelectedSource = vRP.Source(SelectedPassport)
        if SelectedSource then
            vRP.Kick(SelectedSource, "Você foi banido! Motivo: Banido por excesso de advertências")
        end
    else
        TriggerClientEvent("Notify", Source, "Sucesso", "Você adverteu o player com sucesso!", "verde", 10000)
    end

    return true
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60 * 1000)

        local advs = vRP.Query("night_adminv2/selectActiveWarnings", {})

        for _, adv in pairs(advs) do
            local newTempo = tonumber(adv.tempo_restante) - 60

            if newTempo <= 0 then
                vRP.Query("night_adminv2/deletePunicao", {
                    user_id = adv.user_id,
                    status = adv.status,
                    contagem = adv.contagem
                })
            else
                vRP.Query("night_adminv2/updateWarningTime", {
                    user_id = adv.user_id,
                    status = adv.status,
                    contagem = adv.contagem,
                    tempo_restante = newTempo
                })
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SeeInformationsItemList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local Result = {}

    if Passport then
        for Item,ItemTable in pairs(ItemList()) do
            table.insert(Result,{
                item = Item,
                name = ItemTable["Name"],
                index = ItemIndex(Item),
                linkinventario = Config["ImagensInventario"]
            })
        end
    end

    return Result
end

function Creative.CatchItem(idjogador, ItemAmount, ItemCatch)
    local Source = source
    local ExecutorPassport = vRP.Passport(Source)
    local ExecutorIdentity = vRP.Identity(ExecutorPassport)
    local TargetPassport = tonumber(idjogador)
    local TargetIdentity = vRP.Identity(TargetPassport)
    local TargetSource = vRP.Source(TargetPassport)

    if not TargetSource then
        TriggerClientEvent("Notify", Source, "Erro", "Jogador Offline.", "vermelho",10000)
        return false
    end

    if not TargetPassport then
        TriggerClientEvent("Notify", Source, "Erro", "ID do jogador inválido.", "vermelho",10000)
        return false
    end

    if vRP.HasPermission(ExecutorPassport, Config["Perms"]["AddItens"][1], Config["Perms"]["AddItens"][2]) then
        if not ItemCatch or ItemCatch == "" then
            TriggerClientEvent("Notify", Source, "Erro", "Item inválido.", "vermelho",10000)
            return false
        end

        vRP.GenerateItem(TargetPassport, ItemCatch, ItemAmount, true)

        if TargetPassport == ExecutorPassport then
            TriggerClientEvent("Notify", TargetPassport, "Sucesso", "Você pegou "..ItemAmount.."x "..ItemName(ItemCatch)..".", "verde",10000)
        else
            TriggerClientEvent("Notify", TargetPassport, "Sucesso", "Você recebeu "..ItemAmount.."x "..ItemName(ItemCatch)..".", "verde",10000)
            TriggerClientEvent("Notify", Source, "Sucesso", "Você deu "..ItemAmount.."x "..ItemName(ItemCatch).." para "..TargetIdentity.Name.." "..TargetIdentity.Lastname.." (#"..TargetPassport..").", "verde",10000)
        end

        table.insert(PainelLogs, {
            user_id = ExecutorPassport,
            cor = "azul",
            nome = ExecutorIdentity.Name.." "..ExecutorIdentity.Lastname,
            motivo = "Deu um item ["..ItemCatch.."] "..ItemAmount.."x para "..TargetIdentity.Name.." "..TargetIdentity.Lastname.." (#"..TargetPassport..")."
        })

        PerformHttpRequest(Config["Webhooks"]["Itens"], function(err, text, headers) end, "POST", json.encode({
            embeds = {
                {
                    title = "**Spawn de Item**",
                    fields = {
                        { name = "📝 Author:", value = ExecutorIdentity.Name.." "..ExecutorIdentity.Lastname.." **#"..ExecutorPassport.."**" },
                        { name = "📦 Jogador:", value = TargetIdentity.Name.." "..TargetIdentity.Lastname.." **#"..TargetPassport.."**" },
                        { name = "🎁 Item:", value = ItemAmount.."x "..ItemName(ItemCatch) }
                    },
                    footer = { 
                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                    },
                    thumbnail = { 
                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                    },
                    color = 3092790
                }
            }
        }), { ["Content-Type"] = "application/json" })

        return true
    else
        TriggerClientEvent("Notify", Source, "Erro", "Você não tem Permissão", "vermelho",10000)
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SeeInformationsAllVeiculos()
	local Source = source
	local Passport = vRP.Passport(Source)
    local GaragemList = {}

	if Passport then
        for NameVehicle,Ignorar in pairs(VehicleList()) do
            table.insert(GaragemList,{ 	
                carro = NameVehicle,
                name = VehicleName(NameVehicle), 
                linkgaragem = Config["ImagensGaragem"]
            })
        end
	end

    return GaragemList
end

function Creative.GiveVehicle(NameVehicle, SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    SelectedPassport = parseInt(SelectedPassport)

    if not SelectedPassport then
        TriggerClientEvent("Notify", Source, "Erro", "Você precisa colocar um Passaporte!", "vermelho", 10000)
        return
    end

    local Identity2 = vRP.Identity(SelectedPassport)
    if not Identity2 then
        TriggerClientEvent("Notify", Source, "Erro", "Passaporte não encontrado.", "vermelho", 10000)
        return
    end

    if not vRP.HasPermission(Passport, Config["Perms"]["CatchVehicles"][1], Config["Perms"]["CatchVehicles"][2]) then
        TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 10000)
        return
    end

    exports["oxmysql"]:query_async(
        "INSERT IGNORE INTO vehicles (Passport,Vehicle,Plate,Weight,Work,Tax,Block) VALUES (@Passport,@Vehicle,@Plate,@Weight,@Work,UNIX_TIMESTAMP() + 2592000,@Block)",
        {
            Passport = SelectedPassport,
            Vehicle = NameVehicle,
            Plate = vRP.GeneratePlate(),
            Weight = VehicleWeight(NameVehicle),
            Work = (VehicleMode(NameVehicle) == "Work"),
            Block = false
        }
    )

    TriggerClientEvent("Notify", Source, "Sucesso","Você setou o <b>"..VehicleName(NameVehicle).."</b> no passaporte: "..Identity2["Name"].." "..Identity2["Lastname"].." ["..SelectedPassport.."].","verde", 10000)

    local IdentityLog = vRP.Identity(Passport)
    local x, y, z = vCLIENT.GetPosition(Source)

    PerformHttpRequest(Config.Webhooks.seeGaragem, function(err, text, headers) end,
        "POST",
        json.encode({
            embeds = {{
                title = "**Setou Carro (Permanente)**",
                fields = {
                    { name = "📝 Author:", value = IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."**" },
                    { name = "📝 Player:", value = Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."**" },
                    { name = "🚗 Carro:", value = VehicleName(NameVehicle) },
                    { name = "🌐 Coordenada do Staff:", value = x..", "..y..", "..z }
                },
                footer = {
                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                    icon_url = "./images/profile.png"
                },
                thumbnail = { url = "./images/profile.png" },
                color = 3092790
            }}
        }),
        { ["Content-Type"] = "application/json" }
    )

    return true
end

function Creative.ServerVehicle2(Model, x, y, z, Heading, Plate, Nitrox, Doors, Body, Fuel)
    -- Mesmo padrão da garagem: modelo em hash e coordenadas separadas
    if type(Model) == "string" then
        Model = GetHashKey(Model)
    end

    local CurrentTimer = os.time() + 10
    local Vehicle = CreateVehicle(Model, x + 0.0, y + 0.0, z + 0.0, (Heading or 0.0) + 0.0, true, true)
    if not Vehicle or Vehicle == 0 then
        return false
    end

    while not DoesEntityExist(Vehicle) or NetworkGetNetworkIdFromEntity(Vehicle) == 0 do
        if os.time() >= CurrentTimer then
            return false
        end
        Wait(100)
    end

    Plate = Plate or vRP.GeneratePlate()
    SetVehicleNumberPlateText(Vehicle, Plate)
    SetVehicleBodyHealth(Vehicle, (Body or 1000) + 0.0)

    if Doors then
        local Decoded = json.decode(Doors)
        if type(Decoded) == "table" then
            for Number, v in pairs(Decoded) do
                if v then
                    SetVehicleDoorBroken(Vehicle, parseInt(Number), true)
                end
            end
        end
    end

    local State = Entity(Vehicle).state
    State:set("Nitro", Nitrox or 0, true)
    State:set("Fuel", Fuel or 100.0, true)
    State:set("Drift", false, true)
    State:set("Seatbelt", false, true)

    return true, NetworkGetNetworkIdFromEntity(Vehicle), Vehicle, Plate
end

function Creative.SpawnVehicle(VehicleName)
    local Source = source
    local Passport = vRP.Passport(Source)
    if not Passport then return end

    if not vRP.HasPermission(Passport, Config["Perms"]["CatchVehicles"][1], Config["Perms"]["CatchVehicles"][2]) then
        TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 5000)
        return
    end

    local Ped = GetPlayerPed(Source)
    local Coords = GetEntityCoords(Ped)
    local Heading = GetEntityHeading(Ped)
    local Plate = "VEH"..(10000 + Passport)

    local Exist, Network, Vehicle = Creative.ServerVehicle2(VehicleName, Coords.x, Coords.y, Coords.z, Heading, Plate, 2000, nil, 1000, 100)

    if not Exist then
        TriggerClientEvent("Notify", Source, "Erro", "Não foi possível criar o veículo <b>"..tostring(VehicleName).."</b>.", "vermelho", 5000)
        return
    end

    SetEntityRoutingBucket(Vehicle, GetPlayerRoutingBucket(Source))

    for _, OtherSource in pairs(vRPC.Players(Source)) do
        async(function()
            vCLIENT.CreateVehicle2(OtherSource, VehicleName, Network, 1000, 1000, nil, false, false, false)
        end)
    end

    Entity(Vehicle).state:set("Lockpick", Passport, true)
    TaskWarpPedIntoVehicle(Ped, Vehicle, -1)

    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AÇÕES RÁPIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.FastActionsToogle(SelectedPassport,tipo)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedSourcePed = vRP.Source(SelectedPassport)

    if Passport then
        if SelectedSourcePed then
            local Identity2 = vRP.Identity(SelectedPassport)
            local x, y, z = vCLIENT.GetPosition(Source)
            if tipo == "reviver" then
				vRP.Revive(SelectedSourcePed,200)
				vRP.UpgradeThirst(SelectedPassport,100)
				vRP.UpgradeHunger(SelectedPassport,100)
				vRP.DowngradeStress(SelectedPassport,100)
                TriggerClientEvent("Notify", Source, "Sucesso", "Você reviveu o "..Identity2["Name"].." ".. Identity2["Lastname"].." ["..SelectedPassport.."].", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    local IdentityTarget = vRP.Identity(SelectedPassport)
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Reviveu o jogador ["..SelectedPassport.."] "..(IdentityTarget and IdentityTarget["Name"].." "..IdentityTarget["Lastname"] or "").."."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["God"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Reviveu**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
           

            elseif tipo == "matar" then
                vRPC.SetHealth(SelectedSourcePed, 0)
                TriggerClientEvent("Notify", Source, "Sucesso", "Você matou o "..Identity2["Name"].." ".. Identity2["Lastname"].." ["..SelectedPassport.."].", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    local IdentityTarget = vRP.Identity(SelectedPassport)
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Matou o jogador ["..SelectedPassport.."] "..(IdentityTarget and IdentityTarget["Name"].." "..IdentityTarget["Lastname"] or "").."."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Kill"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Matou**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

            elseif tipo == "colete" then
                vRP.SetArmour(SelectedSourcePed, 100)
                TriggerClientEvent("Notify", Source, "Sucesso", "Colete Setado no "..Identity2["Name"].." ".. Identity2["Lastname"].." ["..SelectedPassport.."].", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Deu um colete para o passaporte ["..SelectedPassport.."]."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Vest"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Deu Colete**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

            elseif tipo == "tpto" then
                local SelectedSourcePlayerPed = GetPlayerPed(SelectedSourcePed)
				local Coords = GetEntityCoords(SelectedSourcePlayerPed)

				vRP.Teleport(Source, Coords["x"],Coords["y"],Coords["z"])
                TriggerClientEvent("Notify", Source,"Sucesso","Você foi até o "..Identity2["Name"].." ".. Identity2["Lastname"].." ["..SelectedPassport.."].", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Teleportou até o passaporte ["..SelectedPassport.."]."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Tpto"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Tpto**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

            elseif tipo == "tptome" then
                local MyPed = GetPlayerPed(Source)
				local Coords = GetEntityCoords(MyPed)

				vRP.Teleport(SelectedSourcePed,Coords["x"],Coords["y"],Coords["z"])	
                TriggerClientEvent("Notify", Source, "Sucesso", "Você puxou o "..Identity2["Name"].." ".. Identity2["Lastname"].." ["..SelectedPassport.."].", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Trouxe o passaporte no tptome ["..SelectedPassport.."] até si mesmo."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Tptome"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Trouxe um player até ele**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "fix" then
                    local Vehicle, VehNet, VehPlate = vRPC.VehicleList(SelectedSourcePed, 10)
                    if Vehicle then
                        TriggerClientEvent("Painel:repairAdmin", -1, VehNet, VehPlate)

                        TriggerClientEvent("Notify", Source, "Sucesso", "Você deu fix no carro do " .. Identity2["Name"] .. " " .. Identity2["Lastname"] .. " [" .. SelectedPassport .. "].", "verde", 7000)

                        local IdentityLog = vRP.Identity(Passport)
                        if IdentityLog then
                            table.insert(PainelLogs, {
                                user_id = Passport,
                                cor = "azul",
                                nome = IdentityLog["Name"] .. " " .. IdentityLog["Lastname"],
                                motivo = "Reparou o veículo do passaporte [" .. SelectedPassport .. "]."
                            })
                        end

                        local Identity = vRP.Identity(Passport)
                        PerformHttpRequest(Config["Webhooks"]["Fix"], function(err, text, headers) end, "POST", json.encode({
                            embeds = {
                                {     
                                    title = "**Reparou o veículo do jogador**",
                                    fields = {
                                        { 
                                            name = "📝 Autor:", 
                                            value = Identity["Name"] .. " " .. Identity["Lastname"] .. " **#".. Passport .."**",
                                        },
                                        { 
                                            name = "📝 Alvo:", 
                                            value = Identity2["Name"] .. " " .. Identity2["Lastname"] .. " **#".. SelectedPassport .."**",
                                        },
                                    }, 
                                    footer = { 
                                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                    },
                                    thumbnail = { 
                                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                                    },
                                    color = 3092790
                                }
                            }
                        }), { ["Content-Type"] = "application/json" })
                    else
                        TriggerClientEvent("Notify", Source, "Erro", "O " .. Identity2["Name"] .. " " .. Identity2["Lastname"] .. " [" .. SelectedPassport .. "] não está perto de um veículo.", "vermelho", 7000)
                    end
                    elseif tipo == "reset" then
                        if vRP.Request(Source, "Você deseja resetar o passaporte: "..SelectedPassport.." ?", "Sim", "Não") then
                            -- NationCreato = Tunnel.getInterface("nation_creator")
                            -- NationCreato.startCreator(SelectedSourcePed)
                            vRP.Query("playerdata/SetData", { Passport = SelectedPassport, dkey = "Creator", dvalue = 0 })
                            TriggerClientEvent("Notify", Source, "Sucesso", "Você resetou o personagem "..Identity2["Name"].." "..Identity2["Lastname"].." ["..SelectedPassport.."].","verde",5000)

                            local ExecutorPassport = vRP.Passport(Source)
                            local ExecutorIdentity = vRP.Identity(ExecutorPassport)
                            local TargetIdentity = Identity2

                            table.insert(PainelLogs, {
                                user_id = ExecutorPassport,
                                cor = "azul",
                                nome = ExecutorIdentity.Name.." "..ExecutorIdentity.Lastname,
                                motivo = "Resetou o personagem do passaporte ["..SelectedPassport.."]."
                            })

                            PerformHttpRequest(Config["Webhooks"]["Reset"], function(err, text, headers) end, "POST", json.encode({
                                embeds = {
                                    {
                                        title = "**Reset de Personagem**",
                                        fields = {
                                            {
                                                name = "📝 Author:",
                                                value = ExecutorIdentity.Name.." "..ExecutorIdentity.Lastname.." **#"..ExecutorPassport.."**"
                                            },
                                            {
                                                name = "📝 Jogador:",
                                                value = TargetIdentity.Name.." "..TargetIdentity.Lastname.." **#"..SelectedPassport.."**"
                                            }
                                        },
                                        footer = { 
                                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                        },
                                        thumbnail = { 
                                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                                        },
                                        color = 3092790
                                    }
                                }
                            }), { ["Content-Type"] = "application/json" })
                        end
            elseif tipo == "algema" then
                local TargetSource = SelectedSourcePed
                local TargetPed = GetPlayerPed(TargetSource)

                local Identity = vRP.Identity(Passport)

                if Player(TargetSource)["state"]["Handcuff"] then
                    Player(TargetSource)["state"]["Handcuff"] = false
                    Player(TargetSource)["state"]["Commands"] = false

                    vRPC.Destroy(TargetSource)
                    vRPC.Destroy(Source)

                    TriggerClientEvent("Notify", Source, "Sucesso","Você desalgemou o "..Identity2.Name.." "..Identity2.Lastname.." ["..SelectedPassport.."].", "verde", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs,{
                            user_id = Passport,
                            cor = "azul",
                            nome = IdentityLog.Name.." "..IdentityLog.Lastname,
                            motivo = "Desalgemou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    PerformHttpRequest(Config["Webhooks"]["Algema"], function(err, text, headers) end,
                        "POST",
                        json.encode({
                            embeds = {{
                                title = "**Desalgemou**",
                                fields = {
                                    { name = "📝 Author:", value = Identity.Name.." "..Identity.Lastname.." **#"..Passport.."**" },
                                    { name = "📝 Jogador:", value = Identity2.Name.." "..Identity2.Lastname.." **#"..SelectedPassport.."**" },
                                },
                                footer = { text = os.date("Dia: %d/%m/%Y - %H:%M:%S"), icon_url = Config["Webhooks"]["DiscordImageFooter"] },
                                thumbnail = { url = Config["Webhooks"]["DiscordImageThumbanil"] },
                                color = 3092790
                            }}
                        }),
                        { ["Content-Type"] = "application/json" }
                    )

                else
                    Player(TargetSource)["state"]["Handcuff"] = true
                    Player(TargetSource)["state"]["Commands"] = true

                    vRPC.Destroy(TargetSource)
                    vRPC.Destroy(Source)
                    TriggerClientEvent("inventory:Close", TargetSource)
                    TriggerClientEvent("radio:RadioClean", TargetSource)

                    TriggerClientEvent("Notify", Source, "Sucesso","Você algemou o "..Identity2.Name.." "..Identity2.Lastname.." ["..SelectedPassport.."].", "verde", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs,{
                            user_id = Passport,
                            cor = "amarelo",
                            nome = IdentityLog.Name.." "..IdentityLog.Lastname,
                            motivo = "Algemou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    PerformHttpRequest(Config["Webhooks"]["Algema"], function(err, text, headers) end,
                        "POST",
                        json.encode({
                            embeds = {{
                                title = "**Algemou**",
                                fields = {
                                    { name = "📝 Author:", value = Identity.Name.." "..Identity.Lastname.." **#"..Passport.."**" },
                                    { name = "📝 Jogador:", value = Identity2.Name.." "..Identity2.Lastname.." **#"..SelectedPassport.."**" },
                                },
                                footer = { text = os.date("Dia: %d/%m/%Y - %H:%M:%S"), icon_url = Config["Webhooks"]["DiscordImageFooter"] },
                                thumbnail = { url = Config["Webhooks"]["DiscordImageThumbanil"] },
                                color = 3092790
                            }}
                        }),
                        { ["Content-Type"] = "application/json" }
                    )
                end
            elseif tipo == "ragdoll" then
                TriggerClientEvent("TackleAdmin:Start", SelectedSourcePed)

                local IdentityLog = vRP.Identity(Passport)
                local Identity2 = vRP.Identity(SelectedPassport)

                if IdentityLog and Identity2 then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "amarelo",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Derrubou o passaporte ["..SelectedPassport.."]."
                    })

                    TriggerClientEvent("Notify", vRP.Source(Passport), "Atenção", "Você derrubou <b>"..Identity2["Name"].." "..Identity2["Lastname"].."</b> (#"..SelectedPassport..")", "amarelo", 5000)
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Ragdoll"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Derrubou**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "fogo" then
                    TriggerClientEvent("StartEntity:Fire", SelectedSourcePed)

                    local IdentityLog = vRP.Identity(Passport)
                    local Identity2 = vRP.Identity(SelectedPassport)

                    if IdentityLog and Identity2 then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "amarelo",
                            nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                            motivo = "Tacou fogo no passaporte ["..SelectedPassport.."]."
                        })

                        TriggerClientEvent("Notify", vRP.Source(Passport), "Atenção", "Você incendiou <b>"..Identity2["Name"].." "..Identity2["Lastname"].."</b> (#"..SelectedPassport..")", "amarelo", 5000)
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Fire"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Tacou Fogo**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "fome" then
                    vRP.DowngradeThirst(SelectedPassport, 50)
                    vRP.DowngradeHunger(SelectedPassport, 50)
                    vRP.DowngradeStress(SelectedPassport, 50)

                    local IdentityLog = vRP.Identity(Passport)
                    local Identity2 = vRP.Identity(SelectedPassport)

                    if IdentityLog and Identity2 then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "vermelho",
                            nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                            motivo = "Alterou a fome/sede do passaporte ["..SelectedPassport.."]."
                        })

                        TriggerClientEvent("Notify", vRP.Source(Passport), "Atenção", "Você alterou a fome/sede de <b>"..Identity2["Name"].." "..Identity2["Lastname"].."</b> (#"..SelectedPassport..")", "amarelo", 5000)
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["HungerThirst"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Fome / Sede**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "spec" then
                    if Spectate[Passport] then
                        local ped = GetPlayerPed(Spectate[Passport])
                        if DoesEntityExist(ped) then
                            SetEntityDistanceCullingRadius(ped, 0.0)
                        end

                        TriggerClientEvent("admin:resetSpectate", Source)
                        Spectate[Passport] = nil

                        TriggerClientEvent("Notify", Source, "Atenção", "Modo espião desativado.", "amarelo", 5000)
                    else
                        local SelectedSource = vRP.Source(SelectedPassport)
                        if SelectedSource then
                            local ped = GetPlayerPed(SelectedSource)
                            if DoesEntityExist(ped) then
                                SetEntityDistanceCullingRadius(ped, 999999999.0)
                                Wait(1000)
                                TriggerClientEvent("admin:initSpectate", Source, SelectedSource)
                                Spectate[Passport] = SelectedSource

                                local IdentityLog = vRP.Identity(Passport)
                                if IdentityLog then
                                    table.insert(PainelLogs, {
                                        user_id = Passport,
                                        cor = "amarelo",
                                        nome = IdentityLog["Name"] .. " " .. IdentityLog["Lastname"],
                                        motivo = "Está espectando o passaporte [" .. SelectedPassport .. "]."
                                    })
                                end

                                local Identity = vRP.Identity(Passport)
                                local Identity2 = vRP.Identity(SelectedPassport)
                                PerformHttpRequest(Config["Webhooks"]["Spectate"], function(err, text, headers) end, "POST", json.encode({
                                    embeds = {
                                        {
                                            title = "**Spectando o jogador**",
                                            fields = {
                                                {
                                                    name = "📝 Autor:",
                                                    value = Identity["Name"] .. " " .. Identity["Lastname"] .. " **#" .. Passport .. "**",
                                                },
                                                {
                                                    name = "📝 Alvo:",
                                                    value = Identity2["Name"] .. " " .. Identity2["Lastname"] .. " **#" .. SelectedPassport .. "**",
                                                },
                                            },
                                            footer = { 
                                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                            },
                                            thumbnail = { 
                                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                                            },
                                            color = 3092790
                                        }
                                    }
                                }), { ["Content-Type"] = "application/json" })

                                TriggerClientEvent("Notify", Source, "Sucesso", "Você está espectando <b>" .. Identity2["Name"] .. " " .. Identity2["Lastname"] .. "</b>.", "verde", 5000)
                            end
                        else
                            TriggerClientEvent("Notify", Source, "Erro", "Jogador não encontrado.", "vermelho", 5000)
                        end
                    end
            elseif tipo == "freezar" then
                if FreezePlayer[tostring(SelectedPassport)] then
                    FreezePlayer[tostring(SelectedPassport)] = false
                    FreezeEntityPosition(SelectedSourcePed, false)

                    TriggerClientEvent("Notify", Source, "Sucesso", "Você tirou o freeze do "..Identity2["Name"].." ".. Identity2["Lastname"].." ["..SelectedPassport.."].", "verde", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "vermelho",
                            nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                            motivo = "Descongelou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Freeze"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Descongelou**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                else
                    FreezePlayer[tostring(SelectedPassport)] = true
                    FreezeEntityPosition(SelectedSourcePed, true)

                    TriggerClientEvent("Notify", Source, "Sucesso", "Você freezou o "..Identity2["Name"].." ".. Identity2["Lastname"].." ["..SelectedPassport.."].", "verde", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "vermelho",
                            nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                            motivo = "Congelou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Freeze"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Congelou**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Jogador Offline", "vermelho", 7000)
            return false
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCREENSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TakeScreenshot(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    local SelectedSource = vRP.Source(SelectedPassport)
    if not SelectedSource then
        TriggerClientEvent("Notify", Source, "Erro", "Jogador offline.","vermelho",5000)
        return false
    end

    vCLIENT.ScreenShotAction(SelectedSource, Config["Webhooks"]["ScreenShots"], SelectedPassport)

    local time = 0
    while not ScreenShotInstances[SelectedPassport] do
        time = time + 1
        if time >= 5 then
            break
        end
        Wait(1500)
    end

    local screen = ScreenShotInstances[SelectedPassport]
    ScreenShotInstances[SelectedPassport] = nil
    TriggerClientEvent("Notify", Source, "Sucesso", "Você tirou uma screenshot do passaporte: "..SelectedPassport,"verde",5000)
    
    return screen, Passport
end

function Creative.AddScreenShot(ScreenShot,ScreenShotID)
    ScreenShotInstances[ScreenShotID] = ScreenShot
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SendMessageStaff(SelectedPassport,SelectedMessage)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        TriggerClientEvent("Notify", Source, "Sucesso", "Você enviou uma mensagem para o passaporte: "..SelectedPassport.."", "verde", 7000)
        TriggerClientEvent("Notify", SelectedSource, "Sucesso", "Administração: "..SelectedMessage.."", "verde", 20000)

        local IdentityLog = vRP.Identity(Passport)
        if IdentityLog then
            table.insert(PainelLogs, {
                user_id = Passport,
                cor = "amarelo",
                nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                motivo = "Enviou a mensagem: \""..SelectedMessage.."\" para o passaporte ["..SelectedPassport.."]."
            })
        end

        local Identity = vRP.Identity(Passport)
        local Identity2 = vRP.Identity(SelectedPassport)
        PerformHttpRequest(Config["Webhooks"]["Message"], function(err, text, headers) end, "POST", json.encode({
            embeds = {
                {     
                    title = "**Enviou Mensagem**",
                    fields = {
                        { 
                            name = "📝 Author:", 
                            value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                        },
                        { 
                            name = "📝 Jogador:", 
                            value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                        },
                        { 
                            name = "📦 Mensagem:", 
                            value = ""..SelectedMessage.." ",
                        },
                    }, 
                    footer = { 
                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                    },
                    thumbnail = { 
                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                    },
                    color = 3092790
                }
            }
        }), { ["Content-Type"] = "application/json" })
        return true
    else
        TriggerClientEvent("Notify", Source, "Erro", "Esse jogador está offline.","vermelho",5000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnSkinsList()
	local Source = source
	local Passport = vRP.Passport(Source)
    local ReturnTable = {}

	if Passport then
        for Ignore,TableSkin in pairs(Config["Skins"]) do
            table.insert(ReturnTable, { nome = TableSkin["Nome"], set = TableSkin["Spawn"], linkskins = Config["ImagensSkins"], sexo = TableSkin["Sex"] })
        end
	end

    return ReturnTable
end

function Creative.SetSkinStaff(SelectedPassport, SelectedSkin)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)

    SelectedPassport = parseInt(SelectedPassport)
    local SelectedSource = vRP.Source(SelectedPassport)

    if not SelectedSource then
        TriggerClientEvent("Notify", Source, "Erro", "Esse jogador está offline.", "vermelho", 7000)
        return
    end

    if not vRP.HasPermission(Passport, Config["Perms"]["AddSkins"][1], Config["Perms"]["AddSkins"][2]) then
        TriggerClientEvent("Notify", Source, "Erro", "Skin indisponível.", "vermelho", 7000)
        return
    end

    if not vRPC.ModelExist(Source, SelectedSkin) then
        TriggerClientEvent("Notify", Source, "Erro", "Modelo de skin inválido.", "vermelho", 7000)
        return
    end

    vRPC.Skin(SelectedSource, SelectedSkin)
    vRP.SkinCharacter(SelectedPassport, SelectedSkin)

    TriggerClientEvent("Notify", Source, "Sucesso", "Você setou a skin "..SelectedSkin.." no passaporte "..SelectedPassport..".", "verde", 7000)

    local Identity2 = vRP.Identity(SelectedPassport)
    local x, y, z = vCLIENT.GetPosition(SelectedSource)

    local IdentityLog = vRP.Identity(Passport)
    if IdentityLog then
        table.insert(PainelLogs, {
            user_id = Passport,
            cor = "azul",
            nome = IdentityLog.Name.." "..IdentityLog.Lastname,
            motivo = "Setou a skin **"..SelectedSkin.."** no passaporte ["..SelectedPassport.."] nas coordenadas ("..x..", "..y..", "..z..")."
        })
    end

    PerformHttpRequest(Config["Webhooks"]["Skin"], function(err, text, headers) end, "POST", json.encode({
        embeds = {
            {
                title = "*Skin setada: "..SelectedSkin.."*",
                fields = {
                    {
                        name = "📝 Author:",
                        value = Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."**"
                    },
                    {
                        name = "📝 Jogador:",
                        value = Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."**"
                    },
                    {
                        name = "🌐 Coordenada do Jogador:",
                        value = x..","..y..","..z
                    }
                },
                footer = {
                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                },
                thumbnail = {
                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                },
                color = 3092790
            }
        }
    }), {
        ["Content-Type"] = "application/json"
    })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAÚ FAC
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnChestOrganizationsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local Remember = {}
    local BausFaccoes = {}

    local chestsDB = exports.oxmysql:executeSync("SELECT * FROM chests")
    if chestsDB then
        for _, chestRow in pairs(chestsDB) do
            local OrganizationName = chestRow.Name
            local Configs = {}
            if chestRow.Configuration then
                Configs = json.decode(chestRow.Configuration) or {}
            end

            if #Configs > 0 then
                for ModeIndex, Access in ipairs(Configs) do
                    local storeSuffix = ModeIndex > 1 and (":"..ModeIndex) or ""
                    local chestStoreName = OrganizationName .. storeSuffix
                    
                    local ChestData = vRP.GetSrvData("Chest:"..chestStoreName, true)
                    local AmountItens = 0
                    if ChestData then
                        for x,b in pairs(ChestData) do
                            AmountItens = AmountItens + b["amount"]
                        end
                    end

                    local chestColor = "#ff4f4f"
                    local chestBg = "rgba(255, 79, 79, 0.1)"
                    if AmountItens > 0 then
                        chestColor = "#6C63FF"
                        chestBg = "rgba(108, 99, 255, 0.1)"
                    end

                    local displayName = "Baú " .. OrganizationName .. " (" .. (Access.label or "Geral") .. ")"

                    table.insert(BausFaccoes,{ 	
                        user_id = Passport,
                        nome = Identity["Name"].." ".. Identity["Lastname"],
                        color = chestColor,
                        background = chestBg,
                        bau = chestStoreName,
                        displayName = displayName,
                        tipo = AmountItens.."X Itens"
                    })
                end
            else
                local ChestData = vRP.GetSrvData("Chest:"..OrganizationName, true)
                local AmountItens = 0
                if ChestData then
                    for x,b in pairs(ChestData) do
                        AmountItens = AmountItens + b["amount"]
                    end
                end

                local chestColor = "#ff4f4f"
                local chestBg = "rgba(255, 79, 79, 0.1)"
                if AmountItens > 0 then
                    chestColor = "#6C63FF"
                    chestBg = "rgba(108, 99, 255, 0.1)"
                end

                table.insert(BausFaccoes,{ 	
                    user_id = Passport,
                    nome = Identity["Name"].." ".. Identity["Lastname"],
                    color = chestColor,
                    background = chestBg,
                    bau = OrganizationName,
                    displayName = "Baú " .. OrganizationName,
                    tipo = AmountItens.."X Itens"
                })
            end
        end
    end

    return BausFaccoes
end

function Creative.ReturnChestOrganizationSelected(OrganizationName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedBauList = {}

    local Chest = vRP.GetSrvData("Chest:"..OrganizationName,true)
    if Chest then
        for k,v in pairs(Chest) do
            table.insert(SelectedBauList,{ 	
                user_id = Passport,
                nome = Identity["Name"].." ".. Identity["Lastname"],
                slot = k,
                item = v["item"],
                amount = parseInt(v["amount"]), 
                name = ItemName(v["item"]), 
                index = ItemIndex(v["item"]),
                days = v["days"],
                durability = v["durability"],
                linkinventario = Config["ImagensInventario"]
            })
        end
    end

    return SelectedBauList
end

function Creative.DeleteItemChestOrganization(OrganizationName, ItemName, ItemAmount, ItemSlot)
    local Source = source
    local Passport = vRP.Passport(Source)

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageChests"][1], Config["Perms"]["ManageChests"][2]) then
        vRP.TakeChestRemoveOnly(Passport, "Chest:"..OrganizationName, ItemAmount, ItemSlot)
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRUPOS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnAllGroupsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local AllGroupList = {}

    local AllGroups = vRP.Groups()
    for OrganizationName,Ignore in pairs(AllGroups) do
        local Services, Amount = vRP.NumPermission(OrganizationName)

        table.insert(AllGroupList,{
            user_id = Passport,
            nome = Identity["Name"].." ".. Identity["Lastname"],
            color = "#fff",
            background = "#fff",
            empresa = OrganizationName,
            contador = Amount
        })
    end

    return AllGroupList
end

function Creative.ReturnOrganizationListSelected(GroupName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local MyIdentity = vRP.Identity(Passport)
    local SelectedGroupList = {}

    local AllGroups = vRP.Groups()
    local DataGroup = vRP.DataGroups(GroupName)
    if DataGroup then
        if AllGroups[GroupName] then
            for SelectedPass,SelectedHierarchy in pairs(DataGroup) do
                local SelectedPassport = parseInt(SelectedPass)
                local Identity = vRP.Identity(SelectedPassport)
                if Identity then
                    -- local InfoImage = vRP.Query("night_adminv2/jesterInstagram", {user_id = SelectedPassport})
                    local SelectedImage = "./images/profile.png"
                    -- if InfoImage and InfoImage[1] then
                    --     SelectedImage = InfoImage[1]["avatarURL"]
                    -- end

                    local ThisGroup = AllGroups[GroupName]
                    local MyHierarchy = ThisGroup["Hierarchy"][SelectedHierarchy]

                    table.insert(SelectedGroupList,{
                        user_id = SelectedPassport,
                        myname = Identity["Name"].." "..Identity["Lastname"],
                        nome = Identity["Name"],
                        sobrenome = Identity["Lastname"],
                        color = "#fff",
                        background = "#fff",
                        emprego = MyHierarchy,
                        img = SelectedImage
                    })
                end
            end
        end
    end

    return SelectedGroupList
end

function Creative.ManageSelectedGroups(SelectedPassport, GroupName, Type)
    local Source = source
    local Passport = vRP.Passport(Source)
    local AllGroups = vRP.Groups()

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageGroups"][1],Config["Perms"]["ManageGroups"][2]) and vRP.HasPermission(SelectedPassport, GroupName) then
        if Type == "upar" then
            local SelectedLevel = 0
            local Datatable = vRP.GetSrvData("Permissions:"..GroupName)
            if Datatable[tostring(SelectedPassport)] then
                if Datatable[tostring(SelectedPassport)] - 1 >= 1 then
                    SelectedLevel = Datatable[tostring(SelectedPassport)] - 1
                else
                    SelectedLevel = Datatable[tostring(SelectedPassport)]
                end
            end

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog then
                table.insert(PainelLogs, { user_id = Passport, cor = "amarelo", nome = IdentityLog["Name"].." "..IdentityLog["Lastname"], motivo = "Realizou um up no id ["..SelectedPassport.."] no grupo ["..GroupName.."]." })

                PerformHttpRequest(Config["Webhooks"]["UpgradeHierarchy"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "*Player upado do grupo: "..GroupName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            vRP.SetPermission(SelectedPassport, GroupName, SelectedLevel, false)
        end
        if Type == "rebaixar" then
            local SelectedLevel = 0
            local Datatable = vRP.GetSrvData("Permissions:"..GroupName)
            if Datatable[tostring(SelectedPassport)] then
                if Datatable[tostring(SelectedPassport)] + 1 <= #AllGroups[GroupName]["Hierarchy"] then
                    SelectedLevel = Datatable[tostring(SelectedPassport)] + 1
                else
                    SelectedLevel = Datatable[tostring(SelectedPassport)]
                end
            end

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog then
                table.insert(PainelLogs, { user_id = Passport, cor = "amarelo", nome = IdentityLog["Name"].." "..IdentityLog["Lastname"], motivo = "Realizou um rebaixar no id ["..SelectedPassport.."] no grupo ["..GroupName.."]." })

                PerformHttpRequest(Config["Webhooks"]["DowngradeHierarchy"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "*Player rebaixado do grupo: "..GroupName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Player:", 
                                    value = "" ..IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            vRP.SetPermission(SelectedPassport, GroupName, SelectedLevel, false)
        end
        if Type == "demitir" then
            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog then
                table.insert(PainelLogs, { user_id = Passport, cor = "amarelo", nome = IdentityLog["Name"].." "..IdentityLog["Lastname"], motivo = "Realizou uma demissão no id ["..SelectedPassport.."] no grupo ["..GroupName.."]." })

                PerformHttpRequest(Config["Webhooks"]["Dismiss"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "Player removido do grupo: "..GroupName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Player:", 
                                    value = "" ..IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            vRP.RemovePermission(SelectedPassport, GroupName)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnInventorySelected(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local ReturnInventoryTable = {}

    local SelectedPassport = parseInt(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)

    local SelectedInventory
    if vRP.Source(SelectedPassport) then
        SelectedInventory = vRP.Inventory(SelectedPassport)
    else
        SelectedInventory = vRP.InventoryOffline(SelectedPassport)
    end

    if SelectedInventory then
        for _,TableInventory in pairs(SelectedInventory) do
            if ItemName(TableInventory["item"]) then
                local splitName = splitString(TableInventory["item"], "-")

                if splitName[2] ~= nil then
                    if ItemDurability(TableInventory["item"]) then
                        TableInventory["durability"] = parseInt(os.time() - splitName[2])
                        TableInventory["days"] = ItemDurability(TableInventory["item"])
                    else
                        TableInventory["durability"] = 0
                        TableInventory["days"] = 1
                    end
                else
                    TableInventory["durability"] = 0
                    TableInventory["days"] = 1
                end

                table.insert(ReturnInventoryTable,{
                    item = TableInventory["item"],
                    amount = parseInt(TableInventory["amount"]),
                    name = ItemName(TableInventory["item"]),
                    index = ItemIndex(TableInventory["item"]),
                    days = TableInventory["days"],
                    durability = TableInventory["durability"],
                    linkinventario = Config["ImagensInventario"]
                })
            end
        end
    end

    return {
        nome = Identity["Name"].." "..Identity["Lastname"],
        user_id = SelectedPassport,
        inventario = ReturnInventoryTable
    }
end

function Creative.RemoveItemSelectedInventory(SelectedPassport,SelectedItem,SelectedAmount)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedSource = vRP.Source(SelectedPassport)
    
    if not SelectedSource then
        TriggerClientEvent("Notify", Source, "Erro", "Jogador offline.", "vermelho", 7000)
        return false
    end

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageInventory"][1],Config["Perms"]["ManageInventory"][2]) then
            vRP.TakeItem(SelectedPassport, SelectedItem, SelectedAmount, true)
        
            local Identity2 = vRP.Identity(SelectedPassport)
            TriggerClientEvent("Notify", Source, "Sucesso", "Você retirou "..SelectedAmount.."x "..ItemName(SelectedItem).." do "..Identity2["Name"].." "..Identity2["Lastname"].." ["..SelectedPassport.."]", "verde", 7000)
            local x, y, z = vCLIENT.GetPosition(SelectedSource)

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                    motivo = "Removeu o item **"..Dotted(SelectedAmount).."x "..ItemName(SelectedItem).."** do passaporte ["..SelectedPassport.."]."
                })
            end
        
            PerformHttpRequest(Config["Webhooks"]["RemoveItemInventory"], function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {     
                        title = "**Removeu Item**",
                        fields = {
                            { 
                                name = "📝 Author:", 
                                value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                            },
                            { 
                                name = "📝 Jogador:", 
                                value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                            },
                            { 
                                name = "🎁 Item:", 
                                value = " "..Dotted(SelectedAmount).."x " ..ItemName(SelectedItem).."",
                            },
                            { 
                                name = "🌐 Coordenada do Jogador:", 
                                    value = ""..x..","..y..","..z.." \n \n " 
                            },
                        }, 
                        footer = { 
                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                        },
                        thumbnail = { 
                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                        },
                        color = 3092790
                    }
                }
            }), { ["Content-Type"] = "application/json" })

            return true
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão para executar esta ação.", "vermelho", 7000)
        end
    end
    
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPRIEDADES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnSelectedCasasList(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local CasasTable = {}
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        local Identity = vRP.Identity(SelectedPassport)
        local CasasQuery = vRP.Query("propertys/AllUser", { Passport = SelectedPassport })
        local CasasList = false

        for _, Casa in pairs(CasasQuery) do
            CasasList = true
            table.insert(CasasTable, {
                user_id = SelectedPassport,
                nome = Identity["Name"] .. " " .. Identity["Lastname"],
                home = Casa["Name"]
            })
        end

        if not CasasList then
            table.insert(CasasTable, {
                user_id = SelectedPassport,
                nome = Identity["Name"] .. " " .. Identity["Lastname"],
                home = nil
            })
        end
    end

    return CasasTable
end

function Creative.ReturnChestCasaList(SelectedPassport, SelectedCasa)
    local Source = source
    local Passport = vRP.Passport(Source)
    local CasaChestData = {}
    SelectedPassport = parseInt(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)

    if Passport then
        local Query = vRP.Query("night_adminv2/getHouseVaults", { Name = "Vault:"..SelectedCasa..":%" })
        if Query and #Query > 0 then
            for _, vault in pairs(Query) do
                local vaultName = vault.Name
                local Result = vRP.GetSrvData(vaultName)
                if Result then
                    for k, v in pairs(Result) do
                    local splitName = splitString(v["item"], "-")
                    if splitName[2] ~= nil then
                        if ItemDurability(v["item"]) then
                            v["durability"] = parseInt(os.time() - splitName[2])
                            v["days"] = ItemDurability(v["item"])
                        else
                            v["durability"] = 0
                            v["days"] = 1
                        end
                    else
                        v["durability"] = 0
                        v["days"] = 1
                    end

                    table.insert(CasaChestData, {
                        slot = k,
                        item = v["item"],
                        amount = parseInt(v["amount"]),
                        name = ItemName(v["item"]),
                        index = ItemIndex(v["item"]),
                        days = v["days"],
                        durability = v["durability"],
                        linkinventario = Config["ImagensInventario"],
                        chest = vaultName
                    })
                end
                end
            end
        else
            local Result = vRP.GetSrvData("Vault:"..SelectedCasa)
            if Result then
                for k, v in pairs(Result) do
                    local splitName = splitString(v["item"], "-")
                    if splitName[2] ~= nil then
                        if ItemDurability(v["item"]) then
                            v["durability"] = parseInt(os.time() - splitName[2])
                            v["days"] = ItemDurability(v["item"])
                        else
                            v["durability"] = 0
                            v["days"] = 1
                        end
                    else
                        v["durability"] = 0
                        v["days"] = 1
                    end

                    table.insert(CasaChestData, {
                        slot = k,
                        item = v["item"],
                        amount = parseInt(v["amount"]),
                        name = ItemName(v["item"]),
                        index = ItemIndex(v["item"]),
                        days = v["days"],
                        durability = v["durability"],
                        linkinventario = Config["ImagensInventario"],
                        chest = "Vault:"..SelectedCasa
                    })
                end
            end
        end
    end

    return {
        nome = Identity and (Identity["Name"].." "..Identity["Lastname"]),
        user_id = SelectedPassport,
        casasBau = CasaChestData
    }
end

function Creative.removerCasa(nomeCasa)
    local source = source
    local passport = vRP.Passport(source)
    if passport and nomeCasa then
        vRP.Query("propertys/Sell", { Name = nomeCasa })

        vRP.RemSrvData("Vault:"..nomeCasa)
        vRP.RemSrvData("Fridge:"..nomeCasa)
        vRP.RemSrvData("Propertys:"..nomeCasa)

        local Query = vRP.Query("night_adminv2/getHouseVaults", { Name = "Vault:"..nomeCasa..":%" })
        if Query and #Query > 0 then
            for _, vault in pairs(Query) do
                vRP.RemSrvData(vault.Name)
            end
        end

        return true
    end
    return false
end

function Creative.DeleteSelectedItemChestCasa(SelectedPassport, CasaName, ItemName, ItemAmount, ItemSlot, ChestName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageHouses"][1], Config["Perms"]["ManageHouses"][2]) then
        local IdentityLog = vRP.Identity(Passport)
        local IdentityAffected = vRP.Identity(SelectedPassport)
        if IdentityLog and IdentityAffected then
            
            TriggerClientEvent("Notify", Source, "Sucesso", "Você removeu "..ItemAmount.."x "..ItemName.." do "..IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." ["..SelectedPassport.."]", "verde", 7000)

            table.insert(PainelLogs, { 
                user_id = Passport, 
                cor = "vermelho", 
                nome = IdentityLog["Name"].." "..IdentityLog["Lastname"], 
                motivo = "Removeu **"..ItemAmount.."x "..ItemName.."** do baú da casa ["..CasaName.."] do passaporte ["..SelectedPassport.."]."
            })

            PerformHttpRequest(Config["Webhooks"]["RemoveItemChestHouse"], function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {     
                        title = "**Removeu um item do baú da casa**",
                        fields = {
                            {
                                name = "📝 Author:", 
                                value = IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."** ",
                            },
                            {
                                name = "🏠 Na casa de:", 
                                value = IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."** ",
                            },
                            {
                                name = "🏠 Casa:", 
                                value = "**"..CasaName.."** ",
                            },
                            {
                                name = "🎁 Item:", 
                                value = " "..ItemAmount.."x "..ItemName,
                            },
                        }, 
                        footer = { 
                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                        },
                        thumbnail = { 
                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                        },
                        color = 3092790
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        end

        local TargetChest = ChestName or ("Vault:"..CasaName)
        vRP.TakeChestRemoveOnly(SelectedPassport, TargetChest, ItemAmount, ItemSlot)
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnSelectedGarageList(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local GaragemTables = {}
    local SelectedPassport = parseInt(SelectedPassport)

    local VehicleQuery = vRP.Query("vehicles/UserVehicles", { Passport = SelectedPassport })
    local Identity = vRP.Identity(SelectedPassport)

    if Passport then
        for Index,TableVehicle in pairs(VehicleQuery) do
            
            local veh = TableVehicle["Vehicle"]
            local vehName = VehicleName(veh)

            if vehName then
                table.insert(GaragemTables,{
                    user_id = SelectedPassport,
                    nome = Identity["Name"].." ".. Identity["Lastname"],
                    index = veh,
                    name = vehName,
                    linkgaragem = Config["ImagensGaragem"]
                })
            end
        end
    end

    return {
        nome = Identity["Name"].." ".. Identity["Lastname"],
        user_id = SelectedPassport,
        garagem = GaragemTables
    }
end

function Creative.DeleteVehicleSelected(SelectedPassport,NameVehicle)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageVehicles"][1],Config["Perms"]["ManageVehicles"][2]) then
            if not vRP.SelectVehicle(SelectedPassport, NameVehicle) then
                TriggerClientEvent("Notify", Source, "Atenção", "O passaporte ["..SelectedPassport.."] não possui o veículo <b>"..VehicleName(NameVehicle).."</b>.", "amarelo", 7000)
                return false
            end

            vRP.Query("vehicles/removeVehicles", { Passport = SelectedPassport, Vehicle = NameVehicle })

            local Identity2 = vRP.Identity(SelectedPassport)
            if not Identity2 then
                return true
            end
            TriggerClientEvent("Notify", Source, "Sucesso", "Você retirou o carro "..NameVehicle.." do "..Identity2["Name"].." "..Identity2["Lastname"].." ["..SelectedPassport.."]", "verde", 7000)

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                    motivo = "Removeu o veículo **"..VehicleName(NameVehicle).."** do passaporte ["..SelectedPassport.."]."
                })
            end

            -- Jogador offline não tem posição; sem isso o callback quebrava e o painel travava
            local OtherSource = vRP.Source(SelectedPassport)
            local x, y, z = 0, 0, 0
            if OtherSource then
                x, y, z = vCLIENT.GetPosition(OtherSource)
            end
            PerformHttpRequest(Config["Webhooks"]["RemoveVehicle"], function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {     
                        title = "**Removeu Carro**",
                        fields = {
                            { 
                                name = "📝 Author:", 
                                value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."**",
                            },
                            { 
                                name = "📝 Player:", 
                                value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."**",
                            },
                            { 
                                name = "🚗 Carro:", 
                                value = " "..VehicleName(NameVehicle).." ",
                            },
                            { 
                                name = "🌐 Coordenada do Player:", 
                                value = ""..x..","..y..","..z.." \n \n " 
                            },
                        }, 
                        footer = { 
                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                        },
                        thumbnail = { 
                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                        },
                        color = 3092790
                    }
                }
            }), { ["Content-Type"] = "application/json" })

            return true
        end
    end

    return false
end

function Creative.ReturnChestVehicleList(SelectedPassport, SelectedVehicle)
    local Source = source
    local Passport = vRP.Passport(Source)
    local VehicleChestData = {}
    local SelectedPassport = parseInt(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)

    if Passport then
        local Result = vRP.GetSrvData("Trunkchest:"..SelectedPassport..":"..SelectedVehicle)
        if Result then
            for k,v in pairs(Result) do
                local splitName = splitString(v["item"], "-")
                if splitName[2] ~= nil then
                    if ItemDurability(v["item"]) then
                        v["durability"] = parseInt(os.time() - splitName[2])
                        v["days"] = ItemDurability(v["item"])
                    else
                        v["durability"] = 0
                        v["days"] = 1
                    end
                else
                    v["durability"] = 0
                    v["days"] = 1
                end

                table.insert(VehicleChestData,{
                    slot = k,
                    item = v["item"],
                    amount = parseInt(v["amount"]), 
                    name = ItemName(v["item"]), 
                    index = ItemIndex(v["item"]),
                    days = v["days"],
                    durability = v["durability"],
                    linkinventario = Config["ImagensInventario"]
                })
            end
        end
    end

    return {
        nome = Identity["Name"].." ".. Identity["Lastname"],
        user_id = SelectedPassport,
        carroBau = VehicleChestData
    }
end

function Creative.DeleteSelectedItemChestVehicle(SelectedPassport, VehicleName, ItemName, ItemAmount, ItemSlot)
    local Source = source
    local Passport = vRP.Passport(Source)
    SelectedPassport = parseInt(SelectedPassport)

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageVehicles"][1], Config["Perms"]["ManageVehicles"][2]) then
        local IdentityLog = vRP.Identity(Passport)
        local IdentityAffected = vRP.Identity(SelectedPassport)

        if IdentityLog and IdentityAffected then
            TriggerClientEvent("Notify", Source, "Sucesso", "Você removeu "..ItemAmount.."x "..ItemName.." do veículo "..VehicleName.." do "..IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." ["..SelectedPassport.."]", "verde", 7000)

            table.insert(PainelLogs, {
                user_id = Passport,
                cor = "vermelho",
                nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                motivo = "Removeu **"..ItemAmount.."x "..ItemName.."** do baú do veículo ["..VehicleName.."] do passaporte ["..SelectedPassport.."]."
            })

            PerformHttpRequest(Config["Webhooks"]["RemoveItemChestVehicle"], function(err, text, headers) end, "POST", json.encode({
                embeds = { {
                    title = "**Removeu um item do baú do veículo**",
                    fields = {
                        { name = "📝 Author:", value = IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."**" },
                        { name = "📝 No passaporte:", value = IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."**" },
                        { name = "🚗 Veículo:", value = "**"..VehicleName.."**" },
                        { name = "🎁 Item:", value = "**"..ItemAmount.."x "..ItemName.."**" }
                    },
                    footer = { 
                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                    },
                    thumbnail = { 
                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                    },
                    color = 3092790
                } }
            }), { ["Content-Type"] = "application/json" })
        end

        vRP.TakeChestRemoveOnly(SelectedPassport, "Trunkchest:"..SelectedPassport..":"..VehicleName, ItemAmount, ItemSlot)
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ChangeWalletValues(SelectedPassport,SelectedValue,SelectedType)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedValue = parseInt(SelectedValue)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageMoney"][1],Config["Perms"]["ManageMoney"][2]) then
            if SelectedType == "mais" then
                vRP.GenerateItem(SelectedPassport, "dollar", SelectedValue, true)
    
                TriggerClientEvent("Notify", Source, "Sucesso", "Você adicionou "..Dotted(SelectedValue).." $ para o passaporte: "..SelectedPassport.."", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.Name.." "..IdentityLog.Lastname,
                        motivo = "Spawnou dinheiro na carteira **"..Dotted(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    -- Jogador offline não tem posição; sem isso o callback quebrava e o painel travava
            local OtherSource = vRP.Source(SelectedPassport)
            local x, y, z = 0, 0, 0
            if OtherSource then
                x, y, z = vCLIENT.GetPosition(OtherSource)
            end
                    PerformHttpRequest(Config["Webhooks"]["ChangeWalletMore"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Spawn Dinheiro Carteira**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..Dotted(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
            if SelectedType == "menos" then
                vRP.TakeItem(SelectedPassport, "dollar", SelectedValue, true)

                TriggerClientEvent("Notify", Source, "verde", "Você retirou "..Dotted(SelectedValue).." $ do passaporte: "..SelectedPassport.."", 7000)

                local Identity2 = vRP.Identity(SelectedPassport)
                local x,y,z = vCLIENT.GetPosition(Source)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.Name.." "..IdentityLog.Lastname,
                        motivo = "Removeu dinheiro no banco **"..Dotted(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    -- Jogador offline não tem posição; sem isso o callback quebrava e o painel travava
            local OtherSource = vRP.Source(SelectedPassport)
            local x, y, z = 0, 0, 0
            if OtherSource then
                x, y, z = vCLIENT.GetPosition(OtherSource)
            end
                    PerformHttpRequest(Config["Webhooks"]["ChangeWalletLess"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Remover Dinheiro Banco**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..Dotted(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "Erro", "Esse jogador está offline", "vermelho", 7000)
    end

    return false
end

function Creative.ChangeBankValues(SelectedPassport,SelectedValue,SelectedType)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedValue = parseInt(SelectedValue)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageMoney"][1],Config["Perms"]["ManageMoney"][2]) then
            if SelectedType == "mais" then
                vRP.GiveBank(SelectedPassport, SelectedValue)
    
                TriggerClientEvent("Notify", Source, "Sucesso", "Você adicionou "..Dotted(SelectedValue).." $ para o passaporte: "..SelectedPassport.."", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.Name.." "..IdentityLog.Lastname,
                        motivo = "Spawnou dinheiro no banco **"..Dotted(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    -- Jogador offline não tem posição; sem isso o callback quebrava e o painel travava
            local OtherSource = vRP.Source(SelectedPassport)
            local x, y, z = 0, 0, 0
            if OtherSource then
                x, y, z = vCLIENT.GetPosition(OtherSource)
            end
                    PerformHttpRequest(Config["Webhooks"]["ChangeBankMore"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Spawn Dinheiro Banco**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..Dotted(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
            if SelectedType == "menos" then
                vRP.PaymentBank(SelectedPassport, SelectedValue)

                TriggerClientEvent("Notify", Source, "Sucesso", "Você retirou "..Dotted(SelectedValue).." $ do passaporte: "..SelectedPassport.."", "verde", 7000)

                local Identity2 = vRP.Identity(SelectedPassport)
                local x,y,z = vCLIENT.GetPosition(Source)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.Name.." "..IdentityLog.Lastname,
                        motivo = "Retirou dinheiro do banco **"..Dotted(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    -- Jogador offline não tem posição; sem isso o callback quebrava e o painel travava
            local OtherSource = vRP.Source(SelectedPassport)
            local x, y, z = 0, 0, 0
            if OtherSource then
                x, y, z = vCLIENT.GetPosition(OtherSource)
            end
                    PerformHttpRequest(Config["Webhooks"]["ChangeBankLess"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Remover Dinheiro Banco**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..Dotted(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "Erro", "Esse jogador está offline", "vermelho", 7000)
    end

    return false
end

function Creative.ChangeCoinsValues(SelectedPassport, SelectedValue, SelectedType)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedValue = parseInt(SelectedValue)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageCoins"][1], Config["Perms"]["ManageCoins"][2]) then
            local Identity = vRP.Identity(Passport)
            local Identity2 = vRP.Identity(SelectedPassport)

            if SelectedType == "mais" then
                vRP.UpgradeGemstone(SelectedPassport, SelectedValue, true)

                TriggerClientEvent("Notify", Source, "Sucesso","Você adicionou "..Dotted(SelectedValue).." gemas para o passaporte: "..SelectedPassport,"verde", 7000)

                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "verde",
                    nome = Identity.Name.." "..Identity.Lastname,
                    motivo = "Adicionou **"..Dotted(SelectedValue).." gemas** no passaporte ["..SelectedPassport.."]."
                })

                return true
            end

            if SelectedType == "menos" then
                vRP.Query("accounts/RemoveGemstone", {
                    License = Identity2["License"],
                    Gemstone = SelectedValue
                })

                TriggerClientEvent("hud:RemoveGemstone", SelectedSource, SelectedValue)

                TriggerClientEvent("Notify", Source, "Sucesso","Você removeu "..Dotted(SelectedValue).." gemas do passaporte: "..SelectedPassport,"verde", 7000)

                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = Identity.Name.." "..Identity.Lastname,
                    motivo = "Removeu **"..Dotted(SelectedValue).." gemas** do passaporte ["..SelectedPassport.."]."
                })

                return true
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "Erro", "Esse jogador está offline", "vermelho", 7000)
    end
    
    return false
end

function Creative.ChangeNumberPhoneSelected(SelectedPassport,NewPhoneNumber)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)

    local SelectedSource = vRP.Source(SelectedPassport)
    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ChangeNumber"][1],Config["Perms"]["ChangeNumber"][2]) then
            local CheckPhone = vRP.Query("night_adminv2/CheckPhone", { Phone = NewPhoneNumber })
            if not CheckPhone or #CheckPhone == 0 then
                local Identity2 = vRP.Identity(SelectedPassport)
                local OldPhoneNumber = Identity2 and Identity2["Phone"] or "Desconhecido"

                if Identity2 then
                    Identity2["Phone"] = NewPhoneNumber
                end

                vRP.Query("characters/UpdatePhone", { Passport = SelectedPassport, Phone = NewPhoneNumber })
                vRP.Query("night_adminv2/UpdatePhonePhones", { Passport = SelectedPassport, Phone = NewPhoneNumber })

                TriggerClientEvent("Notify", Source, "Sucesso", "Telefone atualizado.", "verde", 5000)
                TriggerClientEvent("Notify", Source, "Sucesso", "Você alterou o celular para "..NewPhoneNumber.." do passaporte: "..SelectedPassport.."", "verde", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                        motivo = "Trocou o número de celular do passaporte ["..SelectedPassport.."]: de **"..OldPhoneNumber.."** para **"..NewPhoneNumber.."**."
                    })

                    -- Jogador offline não tem posição; sem isso o callback quebrava e o painel travava
            local OtherSource = vRP.Source(SelectedPassport)
            local x, y, z = 0, 0, 0
            if OtherSource then
                x, y, z = vCLIENT.GetPosition(OtherSource)
            end
                    PerformHttpRequest(Config["Webhooks"]["ChangeNumber"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Trocou o Celular**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["Name"].." "..Identity2["Lastname"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "📱 Antigo Numero:", 
                                        value = " "..OldPhoneNumber.."",
                                    },
                                    { 
                                        name = "📱 Novo Numero:", 
                                        value = " "..NewPhoneNumber.."",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end
    
                return true
            else
                TriggerClientEvent("Notify", Source, "Erro", "Esse celular não está disponivel!", "vermelho", 7000)
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "Erro", "Esse jogador está offline!", "vermelho", 7000)
    end

    return false
end

function Creative.ChangeSelectedName(SelectedPassport,FirstName,SecondName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)

    if SelectedPassport then
        if vRP.HasPermission(Passport, Config["Perms"]["ChangeName"][1],Config["Perms"]["ChangeName"][2]) then
            local Identity3 = vRP.Identity(SelectedPassport)
            local OldName = "" ..Identity3["Name"].." "..Identity3["Lastname"]..""

            vRP.UpgradeNames(SelectedPassport, FirstName, SecondName)

            local Identity2 = vRP.Identity(SelectedPassport)
            TriggerClientEvent("Notify", Source, "Sucesso", "Você trocou o nome do passaporte: "..SelectedPassport.." para "..FirstName.." "..SecondName..".", "verde", 7000)

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = IdentityLog["Name"].." "..IdentityLog["Lastname"],
                    motivo = "Trocou o nome do passaporte ["..SelectedPassport.."]: de **"..OldName.."** para **"..Identity2["Name"].." "..Identity2["Lastname"].."**."
                })

                local OtherSource = vRP.Source(SelectedPassport)
                local x,y,z = 0,0,0
                if OtherSource then
                    x,y,z = vCLIENT.GetPosition(OtherSource)
                end
                PerformHttpRequest(Config["Webhooks"]["ChangeName"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Troca de Nome**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["Name"].." "..Identity["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..OldName.." **#"..SelectedPassport.."** ",
                                },
                                { 
                                    name = "✨ Antigo Nome:", 
                                    value = " "..OldName.."",
                                },
                                { 
                                    name = "✨ Novo Nome:", 
                                    value = "" ..Identity2["Name"].." "..Identity2["Lastname"].."",
                                },
                                { 
                                    name = "🌐 Coordenada do Jogador:", 
                                    value = ""..x..","..y..","..z.." \n \n " 
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            return true
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "Erro", "Você precisa colocar um Passaporte!", "vermelho",  7000)
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AlllJobsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local JobsListTable = {}

    if Passport then
        local AllGroups = vRP.Groups()
        local Identity = vRP.Identity(Passport)
    
        for JobName,Ignore in pairs(AllGroups) do
            table.insert(JobsListTable, {user_id = Passport, nome = Identity["Name"].." ".. Identity["Lastname"], emprego = JobName, empregotitle = JobName})
        end
    end

    return JobsListTable
end

function Creative.SelectedPassportJobsList(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local JobsListTable = {}
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        local Identity = vRP.Identity(SelectedPassport)
        local AllGroups = vRP.Groups()
        local Jobs = false
    
        for JobName,_ in pairs(AllGroups) do
            local DataGroup = vRP.DataGroups(JobName)
    
            if DataGroup[tostring(SelectedPassport)] then
                Jobs = true
                table.insert(JobsListTable, {
                    user_id = SelectedPassport,
                    nome = Identity["Name"].." "..Identity["Lastname"],
                    emprego = JobName,
                    empregotitle = JobName
                })
            end
        end

        if not Jobs then
            table.insert(JobsListTable, {
                user_id = SelectedPassport,
                nome = Identity["Name"].." "..Identity["Lastname"],
                emprego = nil,
                empregotitle = nil
            })
        end
    end

    return JobsListTable
end

function Creative.SetNewJobSelectedPassport(SelectedPassport, JobName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageGroups"][1], Config["Perms"]["ManageGroups"][2]) then
            vRP.SetPermission(SelectedPassport, JobName)

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog and IdentityAffected then
                table.insert(PainelLogs, { 
                    user_id = Passport, 
                    cor = "amarelo", 
                    nome = IdentityLog["Name"].." "..IdentityLog["Lastname"], 
                    motivo = "Adicionou um novo grupo ["..JobName.."] no passaporte ["..SelectedPassport.."]." 
                })

                PerformHttpRequest(Config["Webhooks"]["SetNewPermission"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "Player adicionado no grupo: "..JobName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

                TriggerClientEvent("Notify", Source, "Sucesso", "Você adicionou o passaporte "..SelectedPassport.." ao grupo "..JobName..".", "verde", 7000)
                return true
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 7000)
        end
    end

    return false
end

function Creative.DeleteSelectedJobPassport(SelectedPassport, JobName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageGroups"][1], Config["Perms"]["ManageGroups"][2]) then
            vRP.RemovePermission(SelectedPassport, JobName)

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog and IdentityAffected then
                table.insert(PainelLogs, { 
                    user_id = Passport, 
                    cor = "amarelo", 
                    nome = IdentityLog["Name"].." "..IdentityLog["Lastname"], 
                    motivo = "Removeu um grupo ["..JobName.."] no passaporte ["..SelectedPassport.."]." 
                })

                PerformHttpRequest(Config["Webhooks"]["RemovePermission"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "Player removido do grupo: "..JobName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = IdentityLog["Name"].." "..IdentityLog["Lastname"].." **#"..Passport.."**",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = IdentityAffected["Name"].." "..IdentityAffected["Lastname"].." **#"..SelectedPassport.."**",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

                TriggerClientEvent("Notify", Source, "Sucesso", "Você removeu o passaporte "..SelectedPassport.." do grupo "..JobName..".", "verde", 7000)
                return true
            end
        else
            TriggerClientEvent("Notify", Source, "Erro", "Você não tem permissão!", "vermelho", 7000)
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANÚNCIOS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetAnunciosLogs()
    return anunciosLogs
end

function Creative.CriarAnuncio(modo, extra, mensagem)
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local NomeAdmin = Identity.Name .. " " .. Identity.Lastname
    local data = os.date("%d/%m/%Y (%H:%M)")
    local finalMessage = mensagem .. "<br></br>Enviado por: " .. NomeAdmin
    local novoId = #anunciosLogs + 1
    local destinatario = nil
    local organizacao = nil

    if modo == "Todos" then
        destinatario = "Todos"
        TriggerClientEvent("Notify", -1, "Aviso", finalMessage, "default", 30000)

    elseif modo == "Individual" then
        local targetId = parseInt(extra)
        destinatario = targetId
        if targetId > 0 then
            local targetSource = vRP.Source(targetId)
            if targetSource then
                TriggerClientEvent("Notify", targetSource, "Aviso", finalMessage, "default" ,30000)
            end
        end

    elseif modo == "Permissao" then
        organizacao = extra
        local playersInService, _ = vRP.NumPermission(extra)
        for passport, tSource in pairs(playersInService) do
            if tSource then
                TriggerClientEvent("Notify", tSource, "Aviso", finalMessage, "default", 30000)
            end
        end
    end

    table.insert(anunciosLogs, {
        id = novoId,
        admin = NomeAdmin,
        mensagem = mensagem,
        data = data,
        modo = modo,
        destinatario = destinatario,
        organizacao = organizacao
    })

    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Spectate[Passport] then
		Spectate[Passport] = nil
	end
end)
