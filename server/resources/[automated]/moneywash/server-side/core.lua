-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("moneywash",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
local Cooldown = 0

CreateThread(function()
    Wait(1000)
    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    local changed = false
    for k,v in pairs(Moneywash) do
        if v.IsAdmin then
            Moneywash[k] = nil
            changed = true
        end
    end
    if changed then
        vRP.SetSrvData("MoneyWash", Moneywash, true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER: Check Permissions (Supports "Admin,1;Policia,2")
-----------------------------------------------------------------------------------------------------------------------------------------
local function CheckPermissions(Passport, PermString)
    if not PermString or PermString == "" then return true end
    
    for permSet in string.gmatch(PermString, "([^;]+)") do
        local parts = {}
        for p in string.gmatch(permSet, "([^,]+)") do
            table.insert(parts, p)
        end
        
        local group = parts[1]
        local level = parts[2]
        
        if group and group ~= "" then
            if level and tonumber(level) then
                if vRP.HasGroup(Passport, group, tonumber(level)) then
                    return true
                end
            else
                if vRP.HasGroup(Passport, group) then
                    return true
                end
            end
        end
    end
    
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("UpdateObjects",function(OldPassport,NewPassport)
	local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
	
	for Number, Machines in pairs(Moneywash) do
		if Machines.Passport and Machines.Passport == OldPassport then
			Moneywash[Number].Passport = NewPassport
			TriggerClientEvent("objects:Update",-1,Number,NewPassport)
		end
	end
	
	vRP.SetSrvData("MoneyWash",Moneywash,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCOOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local Moneywash = vRP.GetSrvData("MoneyWash", true) or {}
        local updated = false

        for Number, Machines in pairs(Moneywash) do
            if Machines.Timer and Machines.Timer > os.time() then
                
                -- Process Dirty Money
                if Machines.Money > 0 then
                    local WashTime = Machines.WashTime or 10
                    if not Machines.NextWash then
                        Machines.NextWash = os.time() + WashTime
                        updated = true
                    end

                    if os.time() >= Machines.NextWash then
                        Machines.NextWash = os.time() + WashTime
                        local Amount = Machines.WashAmount or 500
                        
                        if Machines.Bleach and Machines.Bleach > os.time() then
                            local Bonus = Machines.BleachBonus or 50
                            Amount = math.floor(Amount * (1 + (Bonus / 100)))
                        end

                        if Amount > Machines.Money then Amount = Machines.Money end

                        if Amount > 0 then
                            local TaxPercent = Machines.Tax or 5
                            local NetAmount = math.floor(Amount * (100 - TaxPercent) / 100)
                            
                            Moneywash[Number].Money = Machines.Money - Amount
                            Moneywash[Number].Washed = (Machines.Washed or 0) + NetAmount
                            Moneywash[Number].Last = os.time() + 300
                        end
                        updated = true
                    end
                end

                -- Process Wet Money (Estufa)
                if Machines.WetMoney and Machines.WetMoney > 0 then
                    local DryTime = Machines.DryTime or 30
                    if not Machines.NextDry then
                        Machines.NextDry = os.time() + DryTime
                        updated = true
                    end

                    if os.time() >= Machines.NextDry then
                        Machines.NextDry = os.time() + DryTime
                        local Amount = Machines.DryAmount or 200

                        if Amount > Machines.WetMoney then Amount = Machines.WetMoney end

                        if Amount > 0 then
                            local TaxPercent = Machines.DryTax or 30
                            local NetAmount = math.floor(Amount * (100 - TaxPercent) / 100)
                            
                            Moneywash[Number].WetMoney = Machines.WetMoney - Amount
                            Moneywash[Number].Washed = (Machines.Washed or 0) + NetAmount
                            Moneywash[Number].Last = os.time() + 300
                        end
                        updated = true
                    end
                end
            end
        end

        if updated then
            vRP.SetSrvData("MoneyWash", Moneywash, true)
            TriggerClientEvent("moneywash:Table", -1, Moneywash)
        end
        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Information(Number)
    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    return Moneywash[Number] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OSTIME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OsTime()
    return os.time()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WASH
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wash", function(Passport, Item, Hash, Coords, Route)
    local Moneywash = vRP.GetSrvData("MoneyWash", true) or {}

    repeat
        Number = GenerateString("DDLLDDLL")
    until not Moneywash[Number]

    Moneywash[Number] = { Route = Route, Coords = Coords, Hash = Hash, Item = Item, Money = 0, Washed = 0, Timer = 0, Bleach = 0, Last = 0, Passport = Passport, Password = nil }

    vRP.SetSrvData("MoneyWash",Moneywash,true)
    TriggerClientEvent("moneywash:New",-1,Number,Moneywash[Number])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Add")
AddEventHandler("moneywash:Add", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if Moneywash[Selected] and Moneywash[Selected].Permission and not CheckPermissions(Passport, Moneywash[Selected].Permission) then
        TriggerClientEvent("Notify",source,"Negado","Você não possui permissão para usar esta máquina.","vermelho",5000)
        return
    end

    if Moneywash[Selected].Timer <= os.time() then
        TriggerClientEvent("Notify",source,"Aviso","Adicione uma bateria primeiro.","vermelho",5000)
        return
    end

    local DirtyItem = Moneywash[Selected].DirtyItem or "dirtydollar"
    local Keyboard = vKEYBOARD.Primary(source, "Quantidade:")
    if Keyboard and Keyboard[1] then
        TriggerClientEvent("dynamic:Close", source)
        local Quantity = parseInt(Keyboard[1])
        if Quantity <= 0 then return end

        if vRP.TakeItem(Passport, DirtyItem, Quantity, true) then
            Moneywash[Selected].Money = (Moneywash[Selected].Money or 0) + Quantity
            vRP.SetSrvData("MoneyWash",Moneywash,true)
            TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
        else
            TriggerClientEvent("Notify",source,"Aviso","Você precisa de " .. Quantity .. "x " .. vRP.ItemName(DirtyItem) .. "","amarelo",5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:ADDWET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:AddWet")
AddEventHandler("moneywash:AddWet", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    if Moneywash[Selected].Permission and not CheckPermissions(Passport, Moneywash[Selected].Permission) then
        TriggerClientEvent("Notify",source,"Negado","Você não possui permissão para usar esta máquina.","vermelho",5000)
        return
    end

    local WetItem = Moneywash[Selected].WetItem or "wetdollar"
    local Keyboard = vKEYBOARD.Primary(source, "Quantidade:")
    if Keyboard and Keyboard[1] then
        TriggerClientEvent("dynamic:Close", source)
        local Quantity = parseInt(Keyboard[1])
        if Quantity <= 0 then return end

        if vRP.TakeItem(Passport, WetItem, Quantity, true) then
            Moneywash[Selected].WetMoney = (Moneywash[Selected].WetMoney or 0) + Quantity
            vRP.SetSrvData("MoneyWash",Moneywash,true)
            TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
        else
            TriggerClientEvent("Notify",source,"Aviso","Você precisa de " .. Quantity .. "x " .. vRP.ItemName(WetItem) .. "","amarelo",5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Money")
AddEventHandler("moneywash:Money", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    if Moneywash[Selected].Permission and not CheckPermissions(Passport, Moneywash[Selected].Permission) then
        TriggerClientEvent("Notify",source,"Negado","Você não possui permissão para usar esta máquina.","vermelho",5000)
        return
    end

    local WetItem = Moneywash[Selected].WetItem or "wetdollar"
    local Amount = Moneywash[Selected].Money or 0
    if Amount > 0 then
        vRP.GenerateItem(Passport, WetItem, Amount, true)
        Moneywash[Selected].Money = 0
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:TAKEWET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:TakeWet")
AddEventHandler("moneywash:TakeWet", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    if Moneywash[Selected].Permission and not CheckPermissions(Passport, Moneywash[Selected].Permission) then
        TriggerClientEvent("Notify",source,"Negado","Você não possui permissão para usar esta máquina.","vermelho",5000)
        return
    end

    local WetItem = Moneywash[Selected].WetItem or "wetdollar"
    local Amount = Moneywash[Selected].WetMoney or 0
    if Amount > 0 then
        vRP.GenerateItem(Passport, WetItem, Amount, true)
        Moneywash[Selected].WetMoney = 0
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:WASHED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Washed")
AddEventHandler("moneywash:Washed", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    if Moneywash[Selected].Permission and not CheckPermissions(Passport, Moneywash[Selected].Permission) then
        TriggerClientEvent("Notify",source,"Negado","Você não possui permissão para usar esta máquina.","vermelho",5000)
        return
    end

    local CleanItem = Moneywash[Selected].CleanItem or "dollar"
    local Amount = Moneywash[Selected].Washed or 0
    if Amount > 0 then
        vRP.GenerateItem(Passport, CleanItem, Amount, true)
        Moneywash[Selected].Washed = 0
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:BATTERY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Battery")
AddEventHandler("moneywash:Battery", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    if Moneywash[Selected].Permission and not CheckPermissions(Passport, Moneywash[Selected].Permission) then
        TriggerClientEvent("Notify",source,"Negado","Você não possui permissão para usar esta máquina.","vermelho",5000)
        return
    end

    if Moneywash[Selected].Timer > os.time() then
        TriggerClientEvent("Notify", source, "Aviso", "Já tem uma bateria ativa.", "amarelo", 5000)
        return
    end

    local BatteryItem = Moneywash[Selected].BatteryItem or "washbattery"
    local BatteryDur = Moneywash[Selected].BatteryDuration or 604800

    if vRP.TakeItem(Passport, BatteryItem, 1, true) then
        Moneywash[Selected].Timer = os.time() + BatteryDur
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("Notify",source,"Sucesso","Bateria colocada.","verde",5000)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    else
        TriggerClientEvent("Notify",source,"Aviso","Você precisa de 1x " .. vRP.ItemName(BatteryItem) .. "","amarelo",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:BLEACH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Bleach")
AddEventHandler("moneywash:Bleach", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    if Moneywash[Selected].Permission and not CheckPermissions(Passport, Moneywash[Selected].Permission) then
        TriggerClientEvent("Notify",source,"Negado","Você não possui permissão para usar esta máquina.","vermelho",5000)
        return
    end

    if Moneywash[Selected].Bleach > os.time() then
        TriggerClientEvent("Notify", source, "Aviso", "Já tem alvejante ativo.", "amarelo", 5000)
        return
    end

    local BleachItem = Moneywash[Selected].BleachItem or "washbleach"
    local BleachDur = Moneywash[Selected].BleachDuration or 21600

    if vRP.TakeItem(Passport, BleachItem, 1, true) then
        Moneywash[Selected].Bleach = os.time() + BleachDur
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("Notify",source,"Sucesso","Alvejante adicionado","verde",5000)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    else
        TriggerClientEvent("Notify",source,"Aviso","Você precisa de 1x " .. vRP.ItemName(BleachItem) .. "","amarelo",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:PASSWORD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Password")
AddEventHandler("moneywash:Password",function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    
    local Keyboard = vKEYBOARD.Password(source,"Senha")
    if Keyboard then
        TriggerClientEvent("dynamic:Close",source)
        local Password = Keyboard[1]
        Moneywash[Selected].Password = Password
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("Notify",source,"Sucesso","Palavra chave atualizada","verde",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:STOREOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:StoreObjects")
AddEventHandler("moneywash:StoreObjects", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    if Moneywash[Selected].IsAdmin then
        TriggerClientEvent("Notify",source,"Negado","Você não pode recolher uma máquina fixa.","vermelho",5000)
        return
    end

    local Item = Moneywash[Selected].Item

    Moneywash[Selected] = nil
    vRP.SetSrvData("MoneyWash",Moneywash,true)
    TriggerClientEvent("moneywash:Remove",-1,Selected)

    if Item then
        vRP.GenerateItem(Passport,Item,1,true)
    end

    TriggerClientEvent("Notify",source,"Sucesso","Máquina recolhida.","verde",5000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
  local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
	TriggerClientEvent("moneywash:Table",source,Moneywash)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE ADMIN MACHINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("moneywash:UpdateAdminMachines")
AddEventHandler("moneywash:UpdateAdminMachines", function()
    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    local query = exports.oxmysql:executeSync("SELECT * FROM moneywash")
    
    for k,v in pairs(Moneywash) do
        if v.IsAdmin then
            Moneywash[k] = nil
            TriggerClientEvent("moneywash:Remove", -1, k)
        end
    end

    for _,v in pairs(query) do
        local idStr = "ADMIN_"..v.id
        Moneywash[idStr] = {
            Route = 0,
            Coords = {v.X, v.Y, v.Z, v.H},
            Hash = v.Hash,
            Item = nil,
            Money = 0,
            Washed = 0,
            Timer = 0,
            Bleach = 0,
            Last = 0,
            Passport = nil,
            Permission = (v.Permission ~= "" and v.Permission) or nil,
            Password = nil,
            IsAdmin = true,
            Tax = v.Tax or 5,
            BatteryItem = (v.BatteryItem ~= "" and v.BatteryItem) or "washbattery",
            BleachItem = (v.BleachItem ~= "" and v.BleachItem) or "washbleach",
            DirtyItem = (v.DirtyItem ~= "" and v.DirtyItem) or "dirtydollar",
            CleanItem = (v.CleanItem ~= "" and v.CleanItem) or "dollar",
            WetItem = (v.WetItem ~= "" and v.WetItem) or "wetdollar",
            WashAmount = v.WashAmount or 500,
            WashTime = v.WashTime or 10,
            BatteryDuration = v.BatteryDuration or 604800,
            BleachDuration = v.BleachDuration or 21600,
            BleachBonus = v.BleachBonus or 50,
            DryAmount = v.DryAmount or 200,
            DryTime = v.DryTime or 30,
            DryTax = v.DryTax or 30
        }
        TriggerClientEvent("moneywash:New", -1, idStr, Moneywash[idStr])
    end
    
    vRP.SetSrvData("MoneyWash",Moneywash,true)
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Passport then
		Passport = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaveServer",function(Silenced)
  local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
	vRP.Query("entitydata/SetData",{ Name = "MoneyWash", Information = json.encode(Moneywash) })

	if not Silenced then
		print("O resource ^2Moneywash^7 salvou os dados.")
	end
end)