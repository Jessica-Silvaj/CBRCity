selectorSending = {}

RegisterNetEvent("character:Server:Selector:Open", function(playerSource)
    -- Evita enviar selector múltiplas vezes para o mesmo player
    if selectorSending[playerSource] then
        print("[Selector] Selector já está sendo enviado para player "..playerSource)
        return
    end
    
    selectorSending[playerSource] = true
    
    local playerSteam = vRP.getIdentities(playerSource)
    if not playerSteam then
        print("[Selector] Erro: playerSteam nil")
        selectorSending[playerSource] = nil
        return
    end

    local playerInfos = vRP.infoAccount(playerSteam)
    local playerCharacters = vRP.Query("characters/getCharacters", { License = playerSteam }) or {}
    local dimension = math.ceil(math.random(1000, 2000) * math.pi)

    if playerInfos then
        exports["vrp"]:Bucket(playerSource, "Enter", dimension)

        local characters = {}
    
        for index = 1, playerInfos["chars"] do
            local characterData = playerCharacters[index]
            
            if characterData then
                local characterAppearance = vRP.userData(characterData.id, "Character")
                local characterClothings = vRP.userData(characterData.id, "Clothings")
                local characterTattoos = vRP.userData(characterData.id, "Tattoos")
                local characterSkin = characterData.Skin or characterData.skin or "mp_m_freemode_01"
                local characterGender = characterSkin == "mp_f_freemode_01" and "f" or "m"

                characters[index] = {
                    type = "character",
                    name = (characterData.Name or characterData.name).." "..(characterData.Lastname or characterData.name2 or ""),
                    id = characterData.id,
                    gender = characterGender,
                    age = characterData.Age or characterData.age or 0,
                    bank = characterData.Bank or characterData.bank or 0,
                    phone = characterData.Phone or characterData.phone or "000-000",
                    appearance = characterAppearance,
                    clothes = characterClothings,
                    tattoos = characterTattoos,
                    gems = playerInfos.gems or 0
                }
                
            else
                characters[index] = {
                    type = "slot",
                    price = Config.Selector.Price
                }
            end 
        end
    
        TriggerClientEvent("character:Client:Selector:Open", playerSource, characters)
        
        -- Libera a trava após enviar
        Wait(1000)
        selectorSending[playerSource] = nil
    else
        selectorSending[playerSource] = nil
    end
end)

RegisterNetEvent("character:Server:Selector:Delete", function(data)
    local playerSource = source
    local playerSteam = vRP.getIdentities(playerSource)

    vRP.Update("characters/deleteCharacter", { License = playerSteam, Passport = data.id })
    TriggerClientEvent("character:Client:AddNotify", playerSource, { 
        title = "Sucesso",
        description = "Personagem <b>"..data.name.." foi deletado com sucesso.",
        delay = 5000
    })
end)

RegisterNetEvent("character:Server:Selector:SelectCharacter", function(data)
    local playerSource = source
    local queryPosition = vRP.userData(data.id,"Position")
    local playerGender = string.lower(string.sub(data.gender, 1, 1))

    TriggerClientEvent("character:Client:Selector:Close", playerSource)

    vRP.characterChosen(playerSource, data.id)
    TriggerClientEvent("vRP:playerActive", playerSource, data.id, data.name)

    Wait(500)

    exports["vrp"]:Bucket(playerSource, "Exit", 0)
    TriggerClientEvent("character:Client:Skinshop:SaveDefault", playerSource, data.clothes)
    TriggerClientEvent("character:Client:Sync:Start", playerSource, {
        appearance = data.appearance,
        tattoos = data.tattoos
    })

    if PlayersSpawned[data.id] then
        TriggerClientEvent("character:Client:Selector:Spawn", playerSource, playerGender, queryPosition, data.appearance, data.clothes, data.tattoos)
    else
        PlayersSpawned[data.id] = true
        TriggerClientEvent("character:Client:Spawn:Open", playerSource, playerGender, queryPosition, data.appearance, data.clothes, data.tattoos)
    end
end)

if Config.Selector.Command then
    RegisterCommand(Config.Selector.Command.Name, function(playerSource)    
        local userId = vRP.getUserId(playerSource)
        local playerPed = GetPlayerPed(playerSource)
        local playerCoords = GetEntityCoords(playerPed)
        
        if userId then
            local permissionsData = Config.Selector.Command.Permissions
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
                vRP.RejoinPlayer(playerSource)

                TriggerEvent("character:Server:Selector:Open", playerSource)
            end
        end
    end)
end
