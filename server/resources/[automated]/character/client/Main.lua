-- Reserva: se o vRP ainda estiver com o Global.lua antigo (sem DrawGroundMarker), desenha o anel aqui mesmo
if not DrawGroundMarker then
	function DrawGroundMarker(x,y,z,Size)
		local Color = MarkerColor or { 46, 139, 87, 170 }
		Size = Size or 1.2
		DrawMarker(25,x,y,z - 0.97,0.0,0.0,0.0,0.0,0.0,0.0,Size,Size,1.0,Color[1],Color[2],Color[3],Color[4],false,false,2,false,nil,nil,false)
	end
end
local Tunnel = module("vrp","lib/Tunnel")
vFunc = {}

Tunnel.bindInterface("character", vFunc)

Character = {
    cameraHeading = nil,
    lastHeading = nil,
    started = false,
    spawnRequested = false
}

CreateThread(function()
    while not Character.started do
        DisplayRadar(false)
        Wait(0)
    end
end)

CreateThread(function()
    TriggerEvent("hud:Active",false)

    SendNUIMessage({
        action = "setColor",
        data = Config.Color[1]..","..Config.Color[2]..","..Config.Color[3]
    })

    Wait(10000)
    while not Character.started do
        TriggerServerEvent("character:Server:Spawn")
        Wait(5000)
    end
end)

CreateThread(function()
	while true do
		local timestamp = 1000

		if (Skinshop and Skinshop.inside) or (Barbershop and Barbershop.inside) or (Tattooshop and Tattooshop.inside) then
            timestamp = 0

	        for id = 0, 256 do
				if id ~= PlayerId() and NetworkIsPlayerActive(id) then
					NetworkFadeOutEntity(GetPlayerPed(id), false)
				end
			end
		end

        Wait(timestamp)
	end
end)

CreateThread(function()
    RequestStreamedTextureDict("textures", true)
    while not HasStreamedTextureDictLoaded("textures") do
        Wait(1)
    end

    local Hovering = false

    while true do
        local timestamp = 999
        local playerPed = PlayerPedId()
        
        if not IsPedInAnyVehicle(playerPed) then
            local playerCoords = GetEntityCoords(playerPed)
            local found = false

            for _, section in pairs({ "Skinshop", "Barbershop", "Tattooshop" }) do
                local data = _G[section]

                if data and Config[section] and Config[section].Locations then
                    for index, coords in pairs(Config[section].Locations) do
                        if coords and coords.x and coords.y and coords.z then
                            local distance = #(playerCoords - vec3(coords.x, coords.y, coords.z))

                            if not data.inside and distance <= 15.0 then
                                timestamp = 1
                                DrawGroundMarker(coords.x, coords.y, coords.z, 1.2)
                            end
        
                            if not data.inside and distance <= (coords.radius or 2.5) then
                                timestamp = 1
                                found = true
                                
                                if not Hovering then
                                    Hovering = true
                                    TriggerEvent("hoverfy:Show", { Key = "E", Title = "Pressione", Legend = "para abrir" })
                                end
        
                                if IsControlJustPressed(0, 38) and not exports.hud:Wanted() and not exports.hud:Repose() and (not coords.Permission or LocalPlayer.state[coords.Permission]) then
                                    data:Open()
                                end
                            end
                        end
                    end
                end
            end

            if not found and Hovering then
                Hovering = false
                TriggerEvent("hoverfy:Hide")
            end
        end

        Wait(timestamp)
    end
end)

RegisterNUICallback("removeFocus", function(_, Callback)
    for _, section in pairs({ "Skinshop", "Barbershop", "Tattooshop" }) do
        local data = _G[section]

        if data and data.inside then
            data:Close()
        end
    end

    Callback(true)
end)

RegisterNUICallback("Character:RotatePed", function(data, Callback)
	local playerPed = PlayerPedId()
	local playerHeading = GetEntityHeading(playerPed)

	-- Teclas A/D: gira alguns graus por vez
	if data.delta then
		SetEntityHeading(playerPed, (playerHeading + data.delta) % 360)
		Callback(true)
		return
	end

	if data.direction then
        if not Character.lastHeading then
            Character.lastHeading = data.direction

        	Callback(true)
            return
        end
    
        local delta = data.direction - Character.lastHeading
        Character.lastHeading = data.direction
    
        local newHeading = (playerHeading + delta) % 360
    
        SetEntityHeading(playerPed, newHeading)
	end

	Callback(true)
end)

RegisterNUICallback("Character:SetCamera", function(data, Callback)
    local section = _G[data.section]

    if section then
        Callback(not section.isSwitchingCamera)

        if not section.isSwitchingCamera then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local playerHeading = GetEntityHeading(playerPed)
        
            local cameraCoords = Config.Cameras[data.id]
            local forwardCoords = Utils.GetForwardCoord(playerCoords, Creator.inside and Config.Creator.Coords.h or (Character.cameraHeading or playerHeading), cameraCoords.distance)
            local newCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        
            SetCamCoord(newCamera, forwardCoords + vec3(0, 0, cameraCoords.height))
            PointCamAtEntity(newCamera, playerPed, 0, 0, cameraCoords.pointOffSet)
            SetCamActiveWithInterp(newCamera, section.mainCamera, 600, 1, 1)
        
            section.isSwitchingCamera = true
        
            Wait(350)
        
            section.isSwitchingCamera = false
            DestroyCam(section.mainCamera)
            section.mainCamera = newCamera
        end    
    end
end)

RegisterNetEvent("character:Client:AddNotify", function(data)
    SendNUIMessage({
        action = "addNotify",
        data = data
    })
end)

RegisterNetEvent("skinshop:Init")
AddEventHandler("skinshop:Init", function(data)
    if not Config.Skinshop then Config.Skinshop = {} end
    Config.Skinshop.Locations = data
end)

RegisterNetEvent("barbershop:Init")
AddEventHandler("barbershop:Init", function(data)
    if not Config.Barbershop then Config.Barbershop = {} end
    Config.Barbershop.Locations = data
end)

RegisterNetEvent("tattooshop:Init")
AddEventHandler("tattooshop:Init", function(data)
    if not Config.Tattooshop then Config.Tattooshop = {} end
    Config.Tattooshop.Locations = data
end)
