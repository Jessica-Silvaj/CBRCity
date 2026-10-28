-- This module can be loaded before Main.lua because server scripts are globbed.
-- Keep its dependencies local so Tunnel is always available.
if not Tunnel then
    Tunnel = module("vrp","lib/Tunnel")
end
if not Proxy then
    Proxy = module("vrp","lib/Proxy")
end
if not vRP then
    vRP = Proxy.getInterface("vRP")
end
if not vRPC then
    vRPC = Tunnel.getInterface("vRP")
end

RegisterNetEvent("character:Server:Skinshop:Finish", function(price, clothesData)
    local playerSource = source
    local userId = vRP.getUserId(playerSource)
    local userWallet = vRP.itemAmount(userId, "dollar")
    local userBank = vRP.getBank(userId)

    if price > 0 then
        local proceed = false

        if userWallet >= price then
            vRP.tryGetInventoryItem(userId, "dollar", price)
            proceed = true
        elseif userBank >= price then
            vRP.delBank(userId, price)
            proceed = true
        end


        if proceed then
            vRP.setCharacterData(userId,"Clothings",clothesData)
            TriggerClientEvent("Notify", playerSource, "Sucesso", "Você adquiriu suas novas roupas pelo valor de <b>$"..price.."</b>.", "verde", 5000)
            TriggerClientEvent("character:Client:Skinshop:SaveDefault", playerSource, clothesData)
        else
            TriggerClientEvent("Notify", playerSource, "Erro", "Você não possui <b>"..price.."</b> para adquirir estas roupas.", "vermelho", 5000)
        end
    else
        TriggerClientEvent("character:Client:Skinshop:SaveDefault", playerSource, clothesData)
        
        vRP.setCharacterData(userId,"Clothings",clothesData)
    end

    TriggerClientEvent("character:Client:Skinshop:Close", playerSource)
end)

RegisterNetEvent("character:Server:Skinshop:Save", function(playerSource, clothesData)
    local playerSource = playerSource or source
    local userId = vRP.getUserId(playerSource)

    if userId then
        TriggerClientEvent("character:Client:Skinshop:Close", playerSource)
        TriggerClientEvent("character:Client:Skinshop:SaveDefault", playerSource, clothesData)
            
        vRP.setCharacterData(userId,"Clothings",clothesData)
    end
end)

if Config.Skinshop.Command then
    RegisterCommand(Config.Skinshop.Command.Name, function(playerSource)    
        local userId = vRP.getUserId(playerSource)
        
        if userId then
            local permissionsData = Config.Skinshop.Command.Permissions
            local permissionsAvailable = false
    
            if permissionsData then
                for name, hierarchy in pairs(permissionsData) do
                    if vRP.hasGroup(userId, name, hierarchy) then
                        permissionsAvailable = true
                    end
                end
            else
                permissionsAvailable = true
            end
    
            if permissionsAvailable then
                TriggerClientEvent("character:Client:Skinshop:Open", playerSource)
            end
        end
    end)
end

local Locations = {}
RegisterNetEvent("skinshop:ServerReload")
AddEventHandler("skinshop:ServerReload", function()
	Locations = {}
	local Consult = exports.oxmysql:executeSync("SELECT * FROM skinshop")
	if Consult then
		for _,v in pairs(Consult) do
			table.insert(Locations, {
				x = v.X, y = v.Y, z = v.Z, radius = 2.0, viewRadius = 10.0,
				Permission = (v.Permission and v.Permission ~= "") and v.Permission or nil
			})
		end
	end
	TriggerClientEvent("skinshop:Init", -1, Locations)
end)

CreateThread(function()
	Wait(1000)
	TriggerEvent("skinshop:ServerReload")
end)

AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("skinshop:Init",source,Locations)
end)

RegisterServerEvent("skinshop:Send")
AddEventHandler("skinshop:Send",function()
	local source = source
	local Passport = vRP.getUserId(source)

	if not Passport then
		return false
	end

	local OtherSource = vRPC.ClosestPed(source)
	local OtherPassport = OtherSource and vRP.Passport(OtherSource)
	if not OtherPassport or vRP.GetHealth(OtherSource) <= 100 then
		TriggerClientEvent("Notify",source,"Aviso","Nenhuma pessoa próxima.","amarelo",5000)
		return false
	end

	if vRP.ModelPlayer(source) ~= vRP.ModelPlayer(OtherSource) then
		TriggerClientEvent("Notify",source,"Aviso","As vestimentas não servem nesse modelo de personagem.","amarelo",5000)
		return false
	end

	local vCLIENT = Tunnel.getInterface("character")
	local clothes = vCLIENT.getCustomization(source)
	if type(clothes) ~= "table" then
		TriggerClientEvent("Notify",source,"Aviso","Não foi possível ler suas vestimentas.","amarelo",5000)
		return false
	end

	if vRP.Request(OtherSource,"Vestimentas","Aceitar vestimentas de <b>"..vRP.FullName(Passport).."</b>?") then
		TriggerClientEvent("Notify",source,"Sucesso","Vestimentas enviadas.","verde",5000)
		TriggerClientEvent("character:Client:Skinshop:SaveDefault",OtherSource,clothes)
		vRP.setCharacterData(OtherPassport,"Clothings",clothes)
	else
		TriggerClientEvent("Notify",source,"Aviso","Vestimentas recusadas.","amarelo",5000)
	end
end)

RegisterServerEvent("skinshop:Remove")
AddEventHandler("skinshop:Remove",function(Mode)
	local source = source
	local Passport = vRP.getUserId(source)
	if Passport then
		local ClosestPed = vRPC.ClosestPed(source)
		if ClosestPed and vRP.hasGroup(Passport,"Emergencia") then
			TriggerClientEvent("character:Client:Skinshop:Set"..Mode,ClosestPed)
		end
	end
end)
