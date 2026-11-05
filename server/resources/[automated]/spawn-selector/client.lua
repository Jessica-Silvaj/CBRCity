local inSelector = false

local spawns = {
    {
        label = "Sandy",
        coords = {591.17,2744.02,42.04},
        desc = 'Ótima localizção para se chegar no deserto de forma rápida e segura.'
    },
    {
        label = 'Garagem',
        coords  = {38.33,-902.28,29.98},
        desc  = 'Para quem quer chegar mais rápido no lado sul da cidade essa é a melhor parada.'
    },
	{
        label = 'Paleto',
        coords  = {-145.08,6370.92,31.49},
        desc  = 'Bairro de Paleto é calmo e pacífico, seus moradores estão sempre bem humorados.'
    },
}

RegisterNUICallback('selectSpawn',function(data,cb)
    local ped = PlayerPedId()

    local mode = data.mode
    local coord = data.coord
    SetNuiFocus(false,false)

	TriggerEvent("hud:Active", false)
	DisplayRadar(false)

    if mode == 1 then
        brokenCamera = false
		DoScreenFadeOut(0)

		Citizen.Wait(500)

		if not DoesCamExist(characterCamera) then
			characterCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord[1], coord[2], coord[3] + 200.0, 270.0, 0.0, 0.0, 60.0, true, 2)
		end
		SetCamRot(characterCamera,270.0)
		SetCamActive(characterCamera,true)
		RenderScriptCams(true,false,0,true,true)
		brokenCamera = true
		local speed = 0.7
		weight = 270.0

		DoScreenFadeIn(500)
		SetEntityCoords(ped,coord[1],coord[2],coord[3],1,0,0,0)
		local coords = GetEntityCoords(ped)

		SetCamCoord(characterCamera,coord[1],coord[2],coord[3] + 200.0)
		local i = coord[3] + 200.0

		while i > coord[3] + 1.5 do
			i = i - speed
			SetCamCoord(characterCamera,coord[1],coord[2],i)

			if i <= coord[3] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(characterCamera,weight)
			end

			if not brokenCamera then
				break
			end

			Citizen.Wait(0)
		end

		inSelector = false
		RenderScriptCams(false,false,0,true,true)
		if DoesCamExist(characterCamera) then
			SetCamActive(characterCamera,false)
			DestroyCam(characterCamera,true)
		end
		characterCamera = nil
		brokenCamera = false

		FreezeEntityPosition(ped, false)
		SetEntityVisible(ped, true, false)
		LocalPlayer["state"]:set("Invisible", false, true)
		TriggerServerEvent("pma-voice:toggleMute", false)

		SetTimeout(2000, function()
			local p = PlayerPedId()
			SetEntityInvincible(p, false)
			LocalPlayer["state"]:set("Invincible", false, true)
		end)

		TriggerEvent("hud:Active", true)
    else
		lastSpawn()
    end

	SetNuiFocus(false,false)
end)

function lastSpawn()
	local ped = PlayerPedId()
	TriggerEvent("hud:Active", false)
	DisplayRadar(false)
	DoScreenFadeOut(300)
	Wait(500)

	SetNuiFocus(false,false)

	inSelector = false
	RenderScriptCams(false,false,0,true,true)
	if DoesCamExist(characterCamera) then
		SetCamActive(characterCamera,false)
		DestroyCam(characterCamera,true)
	end
	characterCamera = nil
	brokenCamera = false

	Citizen.Wait(500)

	FreezeEntityPosition(ped, false)
	SetEntityVisible(ped, true, false)
	LocalPlayer["state"]:set("Invisible", false, true)
	TriggerServerEvent("pma-voice:toggleMute", false)

	SetTimeout(2000, function()
		local p = PlayerPedId()
		SetEntityInvincible(p, false)
		LocalPlayer["state"]:set("Invincible", false, true)
	end)

	DoScreenFadeIn(300)
	TriggerEvent("hud:Active", true)
end

RegisterNetEvent("hookSelector")
AddEventHandler("hookSelector",function(firstSpawn)
	if firstSpawn then
		for t,v in pairs(spawns) do
			local hash = GetStreetNameAtCoord(v.coords[1],v.coords[2],v.coords[3])
			if hash then
				local streetName = GetStreetNameFromHashKey(hash)
				spawns[t].streetName = streetName
			end
		end

		local ped = PlayerPedId()
		inSelector = true
		SetEntityVisible(ped, false, false)
		SetEntityInvincible(ped, true)
		FreezeEntityPosition(ped, true)
		LocalPlayer["state"]:set("Invisible", true, true)
		LocalPlayer["state"]:set("Invincible", true, true)
		TriggerServerEvent("pma-voice:toggleMute", true)

		CreateThread(function()
			while inSelector do
				local p = PlayerPedId()
				SetEntityVisible(p, false, false)
				SetEntityInvincible(p, true)
				Wait(250)
			end
		end)

		TriggerEvent("hud:Active", false)
		DisplayRadar(false)
		DoScreenFadeIn(500)
		SetNuiFocus(true,true)
		SendNUIMessage({
			'openMenu',GetEntityCoords(PlayerPedId()),spawns
		})
	else
		lastSpawn()
	end
end)