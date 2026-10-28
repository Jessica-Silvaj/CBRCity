-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
	-- Status "Jogando CBR CITY" no Discord (app criado no Discord Developer Portal)
	SetDiscordAppId("1563674784724942938")
	-- Nome da imagem cadastrada em Rich Presence > Art Assets do app
	SetDiscordRichPresenceAsset("cbrcity")
	SetDiscordRichPresenceAssetText("CBR CITY")
	SetRichPresence("#"..Passport.." "..Name)
end)
