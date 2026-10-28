Spawn = {
    mainCamera = nil,
    selecting = false,

    Open = function(self, gender, coords, appearance, clothes, tattoos)
        Character.started = true
        self.selecting = true
        TriggerEvent("hud:Active", false)
        DisplayRadar(false)

        if Selector.mainCamera then
            DestroyCam(Selector.mainCamera)
            Selector.mainCamera = nil
        end

        self.mainCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(self.mainCamera, 243.55, -389.67, 46.25)
        SetCamRot(self.mainCamera, 0.0, 0.0, 157.0, 2)
        RenderScriptCams(true, false, 0, true, true)
        StartScreenEffect("MenuMGSelectionIn", 0, true)

        local playerPed = Utils.UpdateGender(gender)

        Wait(500)

        Utils.UpdateAppearance(playerPed, appearance)
        Utils.UpdateClothes(playerPed, clothes)

        SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z - 1.0, false, false, false)
        SetEntityHeading(playerPed, coords.h or 0.0)
        FreezeEntityPosition(playerPed, true)
        SetEntityCollision(playerPed, false, false)
        SetEntityVisible(playerPed, false)
        SetEntityInvincible(playerPed, true)

        Utils.UI("spawn")
        SetNuiFocus(true, true)

        CreateThread(function()
            while self.selecting and self.mainCamera do
                Utils.UI("spawn")
                SetNuiFocus(true, true)
                Wait(1500)
            end
        end)
    end,

    Camera = function(self, coords)
        if not self.mainCamera or not coords then
            return
        end

        PointCamAtCoord(self.mainCamera, coords.x, coords.y, coords.z)

        for _, height in ipairs(Config.Spawn.CamHeights or {}) do
            SetCamCoord(self.mainCamera, coords.x, coords.y, coords.z + height)
            StartScreenEffect("DeathFailNeutralIn", 0, true)
            Wait(550)
        end

        Wait(250)
        DestroyCam(self.mainCamera)
        self.mainCamera = nil
        RenderScriptCams(false, false, 500, true, true)
    end,

    Location = function(self, coords)
        if not coords then
            return false
        end

        self.selecting = false
        local playerPed = PlayerPedId()
        local x = coords.x
        local y = coords.y
        local z = coords.z
        local h = coords.h or coords.w or GetEntityHeading(playerPed)

        Utils.UI()
        SendNUIMessage({ action = "setVisibility", data = false })
        SetNuiFocus(false, false)

        DoScreenFadeOut(250)
        Wait(300)

        StopScreenEffect("MenuMGSelectionIn")
        StopScreenEffect("DeathFailNeutralIn")

        RequestCollisionAtCoord(x, y, z)
        SetFocusPosAndVel(x, y, z, 0.0, 0.0, 0.0)
        SetEntityVisible(playerPed, true, false)
        SetEntityCollision(playerPed, true, true)
        SetEntityCoordsNoOffset(playerPed, x, y, z + 0.25, false, false, false)
        SetEntityHeading(playerPed, h)

        local timeout = GetGameTimer() + 5000
        while not HasCollisionLoadedAroundEntity(playerPed) and GetGameTimer() < timeout do
            RequestCollisionAtCoord(x, y, z)
            Wait(50)
        end

        local okCamera = pcall(function()
            self:Camera(vec3(x, y, z))
        end)

        if not okCamera then
            RenderScriptCams(false, false, 0, true, true)
            DestroyAllCams(true)
        end

        ClearFocus()
        SetEntityCollision(playerPed, true, true)
        SetEntityInvincible(playerPed, false)
        SetEntityVisible(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasksImmediately(playerPed)

        StopScreenEffect("MenuMGSelectionIn")
        StopScreenEffect("DeathFailNeutralIn")
        RenderScriptCams(false, false, 0, true, true)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        NetworkFadeInEntity(playerPed, true)
        Character.started = true
        Character.spawnRequested = false
        LocalPlayer.state:set("Active", true, false)
        LocalPlayer.state:set("Invisible", false, false)
        DoScreenFadeIn(500)

        CreateThread(function()
            Wait(1500)
            Utils.UI()
            SendNUIMessage({ action = "setVisibility", data = false })
            SetNuiFocus(false, false)
            RenderScriptCams(false, false, 0, true, true)
            DestroyAllCams(true)
            StopScreenEffect("MenuMGSelectionIn")
            StopScreenEffect("DeathFailNeutralIn")
            if IsScreenFadedOut() or IsScreenFadingOut() then
                DoScreenFadeIn(500)
            end
        end)

        TriggerServerEvent("vRP:WaitCharacters")
        TriggerEvent("hud:Active", true)

        return true
    end
}

RegisterNUICallback("Spawn:GetLocations", function(_, Callback)
    local locations = {}

    for _, data in ipairs(Config.Spawn.Locations or {}) do
        locations[#locations + 1] = {
            id = data.id,
            name = data.name,
            image = Config.AssetsUrl.."spawn/"..data.id..".png"
        }
    end

    Callback(locations)
end)

RegisterNUICallback("Spawn:Location", function(data, Callback)
    local coords = nil

    for _,v in pairs(Config.Spawn.Locations) do
        if v.id == data.id then
            coords = {
                x = v.coords.x,
                y = v.coords.y,
                z = v.coords.z,
                h = v.coords.h or v.coords.w or v.heading or 0.0
            }
            break
        end
    end

    Callback(coords ~= nil)

    if coords then
        CreateThread(function()
            Spawn:Location(coords)
        end)
    end
end)

RegisterNUICallback("Spawn:LastLocation", function(data, Callback)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    Callback(true)

    CreateThread(function()
        Spawn:Location(playerCoords)
    end)
end)

RegisterNetEvent("character:Client:Spawn:Open", function(...)
    Spawn:Open(...)
end)
