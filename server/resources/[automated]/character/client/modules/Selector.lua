local SelectorDebug = false
local function selectorPrint(...)
    if SelectorDebug then print(...) end
end


Selector = {
    mainCamera = nil,
    characters = {},
    runningCamera = false,

    Open = function(self, characters)
        Character.started = true
        TriggerEvent("hud:Active", false)
        DisplayRadar(false)

        DoScreenFadeOut(500)
        Wait(750)
        
        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()

        StopScreenEffect("MenuMGSelectionIn")
        StopScreenEffect("DeathFailNeutralIn")

        local playerPed = PlayerPedId()

        FreezeEntityPosition(playerPed, true)
        SetEntityVisible(playerPed, false)
        SetEntityCollision(playerPed, false, false)
        SetEntityCoords(playerPed, Config.Selector.Main)
        
        self.characters = characters
        self.runningCamera = true
        
        Utils.UI("selector")
        self:Peds()
        
        Wait(1000)

        self:Camera()
    end,

    Close = function(self)        
        Utils.UI()
        DoScreenFadeOut(250)
        Wait(750)

        for _, character in pairs(self.characters) do
            if character.ped then
                DeleteEntity(character.ped)
            end
        end

        self.runningCamera = false
        self.characters = {}

        if self.mainCamera then
            DestroyCam(self.mainCamera)
            self.mainCamera = nil
        end

        Wait(750)
        DoScreenFadeIn(250)
    end,

    Peds = function(self)
        local spawnsData = Config.Selector.Spawns
        selectorPrint("[Selector] Peds() chamada, characters: "..#self.characters)
        
        for index = 1, math.max(#self.characters, #(Config.Selector.Spawns or {})) do
            local character = self.characters[index]
            selectorPrint("[Selector] Processando character "..index..": type="..(character and character.type or "nil"))
            
            if character and character.type == "character" and spawnsData and spawnsData[index] then
                selectorPrint("[Selector] Criando PED para "..character.name)
                
                character.gender = character.gender == "f" and "f" or "m"
                local modelHash = GetHashKey("mp_"..character.gender.."_freemode_01")
                selectorPrint("[Selector] Model hash: "..tostring(modelHash))

                RequestModel(modelHash)
                local timeout = GetGameTimer() + 5000
                while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do
                    Wait(10)
                end
                
                if not HasModelLoaded(modelHash) then
                    selectorPrint("[Selector] Erro: Model não carregou para "..character.name)
                    goto continue
                end
                
                local playerCoords = spawnsData[index].Coords
                local animData = spawnsData[index].Anim
                local z = type(playerCoords.z) == "table" and playerCoords.z[character.gender] or playerCoords.z
                
                selectorPrint("[Selector] Coords: x="..playerCoords.x.." y="..playerCoords.y.." z="..z)

                RequestCollisionAtCoord(playerCoords.x,playerCoords.y,z)
                local timeout = GetGameTimer() + 3000
                while not HasCollisionLoadedAroundEntity(PlayerPedId()) and GetGameTimer() < timeout do
                    Wait(10)
                end

                character.ped = CreatePed(4, modelHash, playerCoords.x, playerCoords.y, z, playerCoords.h or 0.0, true, true)
                selectorPrint("[Selector] PED criado: "..tostring(character.ped))
                 
                SetEntityAsMissionEntity(character.ped, true, true)
                SetBlockingOfNonTemporaryEvents(character.ped, true)
                SetEntityInvincible(character.ped, true)
                SetPedCanRagdoll(character.ped, false)
                FreezeEntityPosition(character.ped, true)
                Wait(100)
                SetEntityCollision(character.ped, true, true)
                SetEntityVisible(character.ped, true)
                SetEntityAlpha(character.ped, 255, false)
                ResetEntityAlpha(character.ped)

                if character.clothes and type(character.clothes) == "table" and next(character.clothes) then
                    selectorPrint("[Selector] Aplicando clothes personalizadas")
                    Utils.UpdateClothes(character.ped, character.clothes)
                else
                    selectorPrint("[Selector] Usando clothes default")
                    local defaultClothes = Config.Creator and Config.Creator.Default and Config.Creator.Default.Clothes
                    if defaultClothes then
                        local genderClothes = {}
                        for k,v in pairs(defaultClothes) do
                            genderClothes[k] = v[character.gender]
                        end
                        Utils.UpdateClothes(character.ped, genderClothes)
                    end
                end

                if character.appearance and type(character.appearance) == "table" then
                    selectorPrint("[Selector] Aplicando appearance")
                    Utils.UpdateAppearance(character.ped, character.appearance)
                end

                if character.tattoos and type(character.tattoos) == "table" and next(character.tattoos) then
                    selectorPrint("[Selector] Aplicando tattoos")
                    Utils.UpdateTattoos(character.ped, character.tattoos)
                end

                if animData and animData.Dict and animData.Name then
                    selectorPrint("[Selector] Tocando animação: "..animData.Dict.." - "..animData.Name)
                    Utils.PlayAnim(character.ped, animData.Dict, animData.Name)
                else
                    selectorPrint("[Selector] Sem animação ou animação inválida")
                end

                ::continue::
            else
                selectorPrint("[Selector] Pulando character "..index..": character="..(character and "sim" or "nil")..", type="..(character and character.type or "nil")..", spawnsData="..tostring(spawnsData and spawnsData[index]))
            end
        end
        selectorPrint("[Selector] Peds() finalizada")
    end,

    RandomPeds = function(self, cameraIndex)
        local spawnsData = Config.Selector.Spawns or {}
        local totalSpawns = #spawnsData
        selectorPrint("[Selector] RandomPeds() chamada")

        if totalSpawns <= 0 then
            return
        end

        cameraIndex = tonumber(cameraIndex) or 1

        for index, character in pairs(self.characters) do
            if character and character.type == "character" and character.ped and DoesEntityExist(character.ped) then
                character.gender = character.gender == "f" and "f" or "m"

                local spawnIndex = ((cameraIndex + index - 2) % totalSpawns) + 1
                local spawnData = spawnsData[spawnIndex]
                local playerCoords = spawnData.Coords
                local z = type(playerCoords.z) == "table" and playerCoords.z[character.gender] or playerCoords.z

                character.currentSpawn = spawnIndex
                selectorPrint("[Selector] RandomPeds: Movendo PED "..tostring(character.ped).." para spawn "..spawnIndex.." coords "..playerCoords.x..","..playerCoords.y)

                ClearPedTasksImmediately(character.ped)
                SetEntityCoordsNoOffset(character.ped, playerCoords.x, playerCoords.y, z, false, false, false)
                SetEntityHeading(character.ped, playerCoords.h or 0.0)
                FreezeEntityPosition(character.ped, true)

                local animData = spawnData.Anim
                if animData and animData.Dict and animData.Name then
                    Utils.PlayAnim(character.ped, animData.Dict, animData.Name)
                end
            end
        end
    end,
    Camera = function(self)
        local playerPed = PlayerPedId()
        local camerasData = Utils.ShuffleTable(Config.Selector.Cameras or {})

        if #camerasData <= 0 then
            camerasData = {
                {
                    Duration = 8000,
                    List = {
                        {
                            Coords = { x = Config.Selector.Main.x, y = Config.Selector.Main.y, z = Config.Selector.Main.z + 2.0 },
                            Point = { x = Config.Selector.Main.x, y = Config.Selector.Main.y, z = Config.Selector.Main.z }
                        },
                        {
                            Coords = { x = Config.Selector.Main.x + 3.0, y = Config.Selector.Main.y, z = Config.Selector.Main.z + 2.0 },
                            Point = { x = Config.Selector.Main.x, y = Config.Selector.Main.y, z = Config.Selector.Main.z }
                        }
                    }
                }
            }
        end

        if self.mainCamera then
            DestroyCam(self.mainCamera)
        end

        self.mainCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        RenderScriptCams(true, false, 0, true, true)

        CreateThread(function()
            local currentData, currentIndex = 1, 1
            local dataChanged = false

            while self.runningCamera do
                local sequence = camerasData[currentData] and camerasData[currentData].List

                if sequence and sequence[currentIndex] then
                    local from, to = sequence[currentIndex], sequence[currentIndex + 1]
                    DoScreenFadeIn(1000)

                    if not to then
                        currentIndex = 1
                        dataChanged = false
                    else
                        self:RandomPeds(currentData)

                        local startTime = GetGameTimer()
                        local duration = camerasData[currentData].Duration or 10000

                        while (GetGameTimer() - startTime) < duration and self.runningCamera do
                            local now = GetGameTimer()
                            local alpha = (now - startTime) / duration

                            local function interpolate(a, b)
                                return a + (b - a) * alpha
                            end

                            local pos = {
                                x = interpolate(from.Coords.x, to.Coords.x),
                                y = interpolate(from.Coords.y, to.Coords.y),
                                z = interpolate(from.Coords.z, to.Coords.z),
                            }

                            local point = {
                                x = interpolate(from.Point.x, to.Point.x),
                                y = interpolate(from.Point.y, to.Point.y),
                                z = interpolate(from.Point.z, to.Point.z),
                            }

                            SetCamCoord(self.mainCamera, pos.x, pos.y, pos.z)
                            PointCamAtCoord(self.mainCamera, point.x, point.y, point.z)
                            SetEntityCoords(playerPed, pos.x, pos.y, pos.z)

                            if not dataChanged and (now - startTime) > (duration - 1500) and not sequence[currentIndex + 2] then
                                currentData = camerasData[currentData + 1] and currentData + 1 or 1
                                currentIndex = 1
                                dataChanged = true
                                DoScreenFadeOut(1000)
                            end

                            Wait(0)
                        end

                        currentIndex = currentIndex + 1
                    end
                else
                    currentData = 1
                    currentIndex = 1
                end

                Wait(0)
            end
        end)
    end,
    PreviewCharacter = function(self, index)
        index = tonumber(index) or index
        selectorPrint("[Selector] PreviewCharacter() chamada para index "..tostring(index))

        -- A NUI chama preview automaticamente. Nao recria ped nem prende a camera nele;
        -- o personagem permanece na posicao da camera atual.
        if self.characters[index] and self.characters[index].type == "character" then
            return
        end

        if not self.runningCamera then
            DoScreenFadeOut(250)
            Wait(500)

            if self.mainCamera then
                DestroyCam(self.mainCamera)
            end

            self.runningCamera = true
            self:Camera()
            Wait(500)
            DoScreenFadeIn(250)
        end
    end,
    DeleteCharacter = function(self, data)
        self:PreviewCharacter(-1)

        for k,v in pairs(self.characters) do
            if v.id == data.id then
                DeleteEntity(v.ped)
                self.characters[k] = {
                    type = "slot",
                }

                TriggerServerEvent("character:Server:Selector:Delete", data)

                break
            end
        end
    end,

    Spawn = function(self, gender, coords, appearance, clothes, tattoos)
        local playerPed = Utils.UpdateGender(gender)

        Utils.UI()
        Utils.UpdateAppearance(playerPed, appearance)
        Utils.UpdateClothes(playerPed, clothes)

        SetEntityCoords(playerPed, coords.x, coords.y, coords.z - 1)
        SetEntityHeading(playerPed, coords.h)
        SetEntityVisible(playerPed, true)
        SetEntityCollision(playerPed, true, true)
        SetEntityInvincible(playerPed, false)
        FreezeEntityPosition(playerPed, false)

        RenderScriptCams(false, false, 0, true, true)
        TriggerEvent("hud:Active", true)
    end
}

RegisterNUICallback("Selector:GetData", function(_, Callback)
    Callback(Selector.characters)
end)

RegisterNUICallback("Selector:PreviewCharacter", function(data, Callback)
    Selector:PreviewCharacter(data.index)
    Callback(true)
end)

RegisterNUICallback("Selector:DeleteCharacter", function(data, Callback)
    Selector:DeleteCharacter(data)
    
    Callback(true)
end)

RegisterNUICallback("Selector:SelectCharacter", function(data, Callback)
    TriggerServerEvent("character:Server:Selector:SelectCharacter", data)
    Callback(true)
end)

RegisterNUICallback("Selector:CreateCharacter", function(data, Callback)
    Selector:Close()
    Creator:Open()

    Callback(true)
end)

RegisterNetEvent("character:Client:Selector:Open", function(characters) 
        selectorPrint("[Selector] Open chamado com "..#characters.." personagens")
        for i, char in ipairs(characters) do
            if char.type == "character" then
                selectorPrint("[Selector] "..i..": "..char.name.." - Clothes: "..(char.clothes and "sim" or "nil").." - Appearance: "..(char.appearance and "sim" or "nil"))
            end
        end
        Selector:Open(characters) 
    end)

RegisterNetEvent("character:Client:Selector:Close", function(...) 
    Selector:Close(...) 
end)

RegisterNetEvent("character:Client:Selector:Spawn", function(...)
    Selector:Spawn(...)
end)
