RegisterNetEvent("character:Server:Barbershop:Finish", function(price, appearanceData)
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
            vRP.setCharacterData(userId,"Character",appearanceData)
            TriggerClientEvent("Notify", playerSource, "Sucesso", "Você salvou sua nova aparência pelo valor de <b>$"..price.."</b>.", "verde", 5000)
            TriggerClientEvent("character:Client:Sync:Start", playerSource, {
                appearance = appearanceData
            })
        else
            TriggerClientEvent("Notify", playerSource, "Erro", "Você não possui <b>"..price.."</b> para salvar sua aparência.", "vermelho",5000)
        end
    else
        TriggerClientEvent("character:Client:Sync:Start", playerSource, {
            appearance = appearanceData
        })
        
        vRP.setCharacterData(userId,"Character",appearanceData)
    end

    TriggerClientEvent("character:Client:Barbershop:Close", playerSource)
end)

RegisterNetEvent("character:Server:Barbershop:Save", function(playerSource, appearanceData)
    local playerSource = playerSource or source
    local userId = vRP.getUserId(playerSource)

    if userId then
        TriggerClientEvent("character:Client:Barbershop:Close", playerSource)
        TriggerClientEvent("character:Client:Sync:Start", playerSource, {
            appearance = appearanceData
        })
        
        vRP.setCharacterData(userId,"Character",appearanceData)
    end
end)

if Config.Barbershop.Command then
    RegisterCommand(Config.Barbershop.Command.Name, function(playerSource)
        local userId = vRP.getUserId(playerSource)

        if userId then
            local permissionsData = Config.Barbershop.Command.Permissions
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
                TriggerClientEvent("character:Client:Barbershop:Open", playerSource)
            end
        end
    end)
end

local Locations = {}
RegisterNetEvent("barbershop:ServerReload")
AddEventHandler("barbershop:ServerReload", function()
	Locations = {}
	local Consult = exports.oxmysql:executeSync("SELECT * FROM barbershop")
	if Consult then
		for _,v in pairs(Consult) do
			table.insert(Locations, {
				x = v.X, y = v.Y, z = v.Z, radius = 2.0, viewRadius = 10.0,
				Permission = (v.Permission and v.Permission ~= "") and v.Permission or nil
			})
		end
	end
	TriggerClientEvent("barbershop:Init", -1, Locations)
end)

CreateThread(function()
	Wait(1000)
	TriggerEvent("barbershop:ServerReload")
end)

AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("barbershop:Init",source,Locations)
end)
