Creator = {
    inside = false,
    mainCamera = nil,
    isSwitchingCamera = false,

    appearance = Config.Creator.Default.Appearance["m"],
    genetics = {
        name = "",
        surname = "",
        age = 0,
        gender = "m"
    },

    Open = function(self, gender)
        Character.started = true
        DisplayRadar(false)
        DoScreenFadeOut(250)
        Wait(250)
        
        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()

        self.inside = true
        Utils.UI("creator")

        gender = gender or self.genetics.gender or "m"
        self.genetics.gender = gender

        local playerPed = Utils.UpdateGender(gender)
        local defaultClothes = {}

        for k,v in pairs(Config.Creator.Default.Clothes) do
            defaultClothes[k] = v[gender]
        end

        self.appearance = Utils.CopyTable(Config.Creator.Default.Appearance[gender])
        Utils.UpdateAppearance(playerPed, self.appearance)
        Utils.UpdateClothes(playerPed, defaultClothes)

        RequestCollisionAtCoord(Config.Creator.Coords.x, Config.Creator.Coords.y, Config.Creator.Coords.z - 1)
        local timeout = GetGameTimer() + 3000
        while not HasCollisionLoadedAroundEntity(playerPed) and GetGameTimer() < timeout do
            Wait(10)
        end

        SetEntityCollision(playerPed, true, true)
        SetEntityVisible(playerPed, true)
        SetEntityCoords(playerPed, Config.Creator.Coords.x, Config.Creator.Coords.y, Config.Creator.Coords.z - 1)
        SetEntityHeading(playerPed, Config.Creator.Coords.h)
        FreezeEntityPosition(playerPed, true)
                
        local cameraCoords = Config.Cameras["face"]
        local forwardCoords = Utils.GetForwardCoord(Config.Creator.Coords, Config.Creator.Coords.h, cameraCoords.distance)

        if Selector.mainCamera then
            DestroyCam(Selector.mainCamera)
            Selector.mainCamera = nil
        end

        self.mainCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(self.mainCamera, forwardCoords + vec3(0, 0, cameraCoords.height))
        PointCamAtEntity(self.mainCamera, playerPed, 0, 0, cameraCoords.pointOffSet)
        RenderScriptCams(true, false, 0, true, true)

        Wait(250)
        DoScreenFadeIn(250)

        if Config.Anim then
            Utils.PlayAnim(playerPed, Config.Anim.Dict, Config.Anim.Name)
        end
    end,

    ChangeGenetics = function(self, data)
        local playerPed = PlayerPedId()

        if data.gender ~= self.genetics.gender then
            local playerPed = Utils.UpdateGender(data.gender)
            local defaultClothes = {}

            for k,v in pairs(Config.Creator.Default.Clothes) do
                defaultClothes[k] = v[data.gender]
            end

            self.appearance = Utils.CopyTable(Config.Creator.Default.Appearance[data.gender])
            Utils.UpdateAppearance(playerPed, self.appearance)
            Utils.UpdateClothes(playerPed, defaultClothes)    
        end

        self.genetics = data
        self.appearance.skinColor = data.color
        self.appearance.shapeMix =  (data.paternity / 100) + .0

        -- Índices vêm de uma lista única (pais e depois mães), então pai pode ser rosto de mulher e vice-versa
        local father = self:ParentByIndex(data.father) or Config.Creator.Fathers[1]
        local mother = self:ParentByIndex(data.mother) or Config.Creator.Mothers[1]
        self.appearance.fathersID = father.id
        self.appearance.mothersID = mother.id

        -- 2º pai / 2ª mãe: ficam salvos no personagem, sem alterar o rosto
        local father2 = self:ParentByIndex(data.father2)
        local mother2 = self:ParentByIndex(data.mother2)
        self.appearance.fathersID2 = father2 and father2.id or nil
        self.appearance.mothersID2 = mother2 and mother2.id or nil
    end,

    ParentByIndex = function(self, index)
        index = tonumber(index)
        if not index or index < 0 then
            return nil
        end

        local fatherCount = #Config.Creator.Fathers
        if index < fatherCount then
            return Config.Creator.Fathers[index + 1]
        end

        return Config.Creator.Mothers[index - fatherCount + 1]
    end,

    ChangeData = function(self, data)
        for k,v in pairs(data) do
            self.appearance[k] = v.value
        end
    end,

    Cutscene = function(self)
        local playerPed = PlayerPedId()
        local coords = {
            vec3(-1170.57, -1644.02, 4.38),
            vec3(-1638.71, -2738.75, 3.44),
            vec3(-1361.12, -2267.97, 3.44)
        }

        SetNuiFocus(true, true)
        DoScreenFadeOut(500)
        Wait(750)

        SetEntityCoordsNoOffset(playerPed, coords[1].x, coords[1].y, coords[1].z, false, false, false)

        for _, v in ipairs(coords) do
            LoadScene(v.x, v.y, v.z)
            RequestCollisionAtCoord(v.x, v.y, v.z)

            local timeout = GetGameTimer() + 3000
            while not HasCollisionLoadedAroundEntity(playerPed) and GetGameTimer() < timeout do
                Wait(10)
            end
        end

        if isMale then
            RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 31, 8)
        else
            RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 103, 8)
        end

        while not HasCutsceneLoaded() do
            Wait(10)
        end

        PrefetchSrl('GTAO_INTRO_MALE')
        PrefetchSrl('GTAO_INTRO_FEMALE')

        while not IsSrlLoaded() do
            Wait(10)
        end

        BeginSrl()
        
        if isMale then
            RegisterEntityForCutscene(0, 'MP_Male_Character', 3, GetEntityModel(playerPed), 0)
            RegisterEntityForCutscene(playerPed, 'MP_Male_Character', 0, 0, 0)
            SetCutsceneEntityStreamingFlags('MP_Male_Character', 0, 1) 
            local female = RegisterEntityForCutscene(0,"MP_Female_Character",3,0,64) 
            NetworkSetEntityInvisibleToNetwork(female, true)
        else
            RegisterEntityForCutscene(0, 'MP_Female_Character', 3, GetEntityModel(playerPed), 0)
            RegisterEntityForCutscene(playerPed, 'MP_Female_Character', 0, 0, 0)
            SetCutsceneEntityStreamingFlags('MP_Female_Character', 0, 1) 
            local male = RegisterEntityForCutscene(0,"MP_Male_Character",3,0,64) 
            NetworkSetEntityInvisibleToNetwork(male, true)
        end

        local dummyPeds = {}
        for v_3=0, 6, 1 do
            if v_3 == 1 or v_3 == 2 or v_3 == 4 or v_3 == 6 then
                dummyPeds[v_3] = CreatePed(26, GetHashKey("mp_f_freemode_01"), -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
            else
                dummyPeds[v_3] = CreatePed(26, GetHashKey("mp_m_freemode_01"), -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
            end
            
            if not IsEntityDead(dummyPeds[v_3]) then
                DecorSetBool(dummyPeds[v_3], "CREATIVE_PED", true)
                RegisterEntityForCutscene(dummyPeds[v_3], "MP_Plane_Passenger_"..(v_3+1), 0, 0, 64)
            end
        end

        NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0)

        NetworkSetEntityInvisibleToNetwork(playerPed, true)
        StartCutscene(4) 
        
        CreateThread(function()
            while IsCutsceneActive() do
                SetPlayerControl(PlayerId(), true, false)
                Wait(1)
            end
        end)
        
        Wait(500)
        DoScreenFadeIn(500)
        Wait(26500)

        DoScreenFadeOut(500)
        Wait(1000)

        StopCutsceneImmediately()
        NetworkSetEntityInvisibleToNetwork(playerPed, false)
        
        for v_3=0, 6, 1 do
            if DoesEntityExist(dummyPeds[v_3]) then
                DeleteEntity(dummyPeds[v_3])
            end
        end

        SetNuiFocus(false, false)
        Wait(1000)
        DoScreenFadeIn(1000)

        EndSrl()
    end,

    Spawn = function(self)
        Character.started = true
        local playerPed = PlayerPedId()
        local spawnCoords = Config.Creator.Spawn
                
        if Config.Creator.Cutscene then
            self:Cutscene()
        end

        RequestCollisionAtCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z - 1)
        local timeout = GetGameTimer() + 3000
        while not HasCollisionLoadedAroundEntity(playerPed) and GetGameTimer() < timeout do
            Wait(10)
        end

        SetEntityCollision(playerPed, true, true)
        SetEntityCoords(playerPed, spawnCoords.x, spawnCoords.y, spawnCoords.z - 1)
        SetEntityHeading(playerPed, spawnCoords.h)
        SetEntityInvincible(playerPed, false)
        FreezeEntityPosition(playerPed, false)
        -- NOVO
        if not Config.Creator.Cutscene then
            Wait(500)
            DoScreenFadeIn(1000)
        end

        TriggerServerEvent("vRP:WaitCharacters")
        TriggerEvent("referrals:Open")
        TriggerEvent("hud:Active", true)
    end
}

RegisterNUICallback("Creator:UpdatePedPreview", function(data, Callback)
    local playerPed = PlayerPedId()

    if data.section == "genetics" then
        Creator:ChangeGenetics(data.data)
    elseif data.section == "characteristics" or data.section == "appearance" or data.section == "hair" then
        Creator:ChangeData(data.data)
    end

    Utils.UpdateAppearance(playerPed, Creator.appearance)

    Callback(true)
end)

RegisterNUICallback("Creator:ChangeGender", function(data, Callback)
    local playerPed = Utils.UpdateGender(data.gender)
    local defaultClothes = {}

    for k,v in pairs(Config.Creator.Default.Clothes) do
        defaultClothes[k] = v[data.gender]
    end

    Creator.appearance = Utils.CopyTable(Config.Creator.Default.Appearance[data.gender])
    Utils.UpdateAppearance(playerPed, Creator.appearance)
    Utils.UpdateClothes(playerPed, defaultClothes)    

    if Config.Anim then
        Utils.PlayAnim(playerPed, Config.Anim.Dict, Config.Anim.Name)
    end

    Callback(true)
end)

RegisterNUICallback("Creator:GetParents", function(data, Callback)
    local fathers = {}
    local mothers = {}

    for k,v in pairs(Config.Creator.Fathers) do
        local image = Config.AssetsUrl.."creator/fathers/"..v.name..".png"

        fathers[k] = v
        fathers[k].image = image
    end

    for k,v in pairs(Config.Creator.Mothers) do
        local image = Config.AssetsUrl.."creator/mothers/"..v.name..".png"

        mothers[k] = v
        mothers[k].image = image
    end

    Callback({
        fathers = fathers,
        mothers = mothers
    })
end)

RegisterNUICallback("Creator:GetData", function(data, Callback)
    local playerPed = PlayerPedId()
    local dictionary = {}

    for k,v in pairs(Config.Creator[data.section]) do
        dictionary[k] = v
        
        if k == "hair" then
            dictionary[k].max = GetNumberOfPedDrawableVariations(playerPed, 2)
        end

        dictionary[k].value = Creator.appearance[k]
        if dictionary[k].value == nil then
            dictionary[k].value = v.default or v.min
        end
    end

    Callback(dictionary)
end)

RegisterNUICallback("Creator:GetPalettes", function(_, Callback)
    local palettes = { hair = {}, makeup = {} }

    for i = 0, GetNumHairColors() - 1 do
        local r, g, b = GetPedHairRgbColor(i)
        palettes.hair[#palettes.hair + 1] = { r, g, b }
    end

    for i = 0, GetNumMakeupColors() - 1 do
        local r, g, b = GetPedMakeupRgbColor(i)
        palettes.makeup[#palettes.makeup + 1] = { r, g, b }
    end

    Callback(palettes)
end)

RegisterNUICallback("Creator:SaveCharacter", function(_, Callback)
    if tonumber(Creator.genetics.age) >= 18 and tonumber(Creator.genetics.age) <= 60 then
        if #Creator.genetics.name >= 4 and #Creator.genetics.surname >= 4 then
            Skinshop:Open()
            Wait(1000)
            if Creator.mainCamera then
                DestroyCam(Creator.mainCamera)
            end
        end
    end

    Callback(true)
end)

RegisterNetEvent("character:Client:Creator:Open", function(...) 
    Creator:Open(...) 
end)

RegisterNetEvent("character:Client:Creator:Spawn", function(...)
    Creator:Spawn(...)
end)
