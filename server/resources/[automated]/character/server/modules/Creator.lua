RegisterNetEvent("character:Server:Creator:Open", function(playerSource)
    math.randomseed(os.time() + playerSource)
    local dimension = math.ceil(math.random(1000, 2000) * math.pi)

    exports["vrp"]:Bucket(playerSource, "Enter", dimension)

    TriggerClientEvent("character:Client:Creator:Open", playerSource)
end)

RegisterNetEvent("character:Server:Creator:Finish", function(genetics, appearance, clothes)
    local playerSource = source
    math.randomseed(os.time() + playerSource)

    local userLicense = vRP.getIdentities(playerSource)
    local Skin = "mp_"..genetics.gender.."_freemode_01"

    vRP.Query("characters/createCharacter", {
        License = userLicense,
        Name = genetics.name,
        Lastname = genetics.surname,
        Age = genetics.age,
        Skin = Skin,
        Blood = math.random(0,4)
    })

    local queryData = vRP.SingleQuery("characters/lastCreated",{ License = userLicense })
    local Passport = queryData and queryData.id

    if Passport then
        vRP.setCharacterData(Passport,"Character",appearance)
        vRP.setCharacterData(Passport,"Clothings",clothes)
        vRP.setCharacterData(Passport,"Tattoos",{})
        vRP.setCharacterData(Passport,"Position",Config.Creator.Spawn)

        TriggerClientEvent("character:Client:Skinshop:Close", playerSource)
        
        Wait(500)
        vRP.characterChosen(playerSource,Passport,Skin)
        vRP.setCharacterData(Passport,"Character",appearance)
        vRP.setCharacterData(Passport,"Clothings",clothes)
        vRP.setCharacterData(Passport,"Tattoos",{})
        vRP.setCharacterData(Passport,"Position",Config.Creator.Spawn)

        Wait(1000)
        
        TriggerClientEvent("character:Client:Skinshop:SaveDefault", playerSource, clothes)

        TriggerClientEvent("character:Client:Sync:Start", playerSource, {
            appearance = appearance,
            tattoos = {}
        })
        TriggerClientEvent("character:Client:Creator:Spawn", playerSource)

        exports["vrp"]:Bucket(playerSource, "Exit", 0)
    end
end)