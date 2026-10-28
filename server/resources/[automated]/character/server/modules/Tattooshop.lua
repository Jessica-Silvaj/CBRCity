RegisterNetEvent("character:Server:Tattooshop:Finish", function(price, tattooData)
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
            vRP.setCharacterData(userId,"Tattoos",tattooData)
            TriggerClientEvent("Notify", playerSource, "Sucesso", "Você salvou suas novas tatuagens pelo valor de <b>$"..price.."</b>.", "verde", 5000)
            TriggerClientEvent("character:Client:Sync:Start", playerSource, {
                tattoos = tattooData
            })        
        else
            TriggerClientEvent("Notify", playerSource, "Erro", "Você não possui <b>"..price.."</b> para salvar suas tatuagens.", "vermelho", 5000)
        end
    else
        TriggerClientEvent("character:Client:Tattooshop:Close", playerSource)
        TriggerClientEvent("character:Client:Sync:Start", playerSource, {
            tattoos = tattooData
        })
        
        vRP.setCharacterData(userId,"Tattoos",tattooData)
    end

    TriggerClientEvent("character:Client:Tattooshop:Close", playerSource)
end)

RegisterNetEvent("character:Server:Tattooshop:Save", function(playerSource, tattooData)
    local playerSource = playerSource or source
    local userId = vRP.getUserId(playerSource)

    if userId then
        TriggerClientEvent("character:Client:Tattooshop:Close", playerSource)
        TriggerClientEvent("character:Client:Sync:Start", playerSource, {
            tattoos = tattooData
        })
        
        vRP.setCharacterData(userId,"Tattoos",tattooData)
    end
end)

if Config.Tattooshop.Command then
    RegisterCommand(Config.Tattooshop.Command.Name, function(playerSource)
        local userId = vRP.getUserId(playerSource)

        if userId then
            local permissionsData = Config.Tattooshop.Command.Permissions
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
                TriggerClientEvent("character:Client:Tattooshop:Open", playerSource)
            end
        end
    end)
end

local Locations = {}
RegisterNetEvent("tattooshop:ServerReload")
AddEventHandler("tattooshop:ServerReload", function()
	Locations = {}
	local Consult = exports.oxmysql:executeSync("SELECT * FROM tattooshop")
	if Consult then
		for _,v in pairs(Consult) do
			table.insert(Locations, {
				x = v.X, y = v.Y, z = v.Z, radius = 2.0, viewRadius = 10.0,
				Permission = (v.Permission and v.Permission ~= "") and v.Permission or nil
			})
		end
	end
	TriggerClientEvent("tattooshop:Init", -1, Locations)
end)

CreateThread(function()
	Wait(1000)
	TriggerEvent("tattooshop:ServerReload")
end)

AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("tattooshop:Init",source,Locations)
end)
