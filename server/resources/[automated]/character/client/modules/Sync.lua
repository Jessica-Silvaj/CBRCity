Sync = {
    status = false,
    appearance = Config.Creator.Default.Appearance,
    tattoos = {}
}

CreateThread(function()
    local lastModel = nil

	while true do
		local timestamp = 1000

		if Sync.status and not Creator.inside and not (Skinshop and Skinshop.inside) and not (Barbershop and Barbershop.inside) and not (Tattooshop and Tattooshop.inside) then
            local playerPed = PlayerPedId()
            local playerModel = GetEntityModel(playerPed)

			if (playerModel == GetHashKey("mp_m_freemode_01")) or (playerModel == GetHashKey("mp_f_freemode_01")) then
                if lastModel ~= playerModel or not Sync.applied then
                    Utils.UpdateAppearance(playerPed, Sync.appearance)
                    Utils.UpdateTattoos(playerPed, Sync.tattoos)
                    lastModel = playerModel
                    Sync.applied = true
                end
            else
                lastModel = playerModel
            end
		end

		Wait(timestamp)
	end
end)

RegisterNetEvent("character:Client:Sync:Start", function(data)
    Sync.status = true
    Sync.applied = false

    if data then
        for k,v in pairs(data) do
            Sync[k] = v
        end
    end
end)

-- Reaplica aparência, tatuagens e roupas (usado pelo "Desbugar")
RegisterNetEvent("character:Client:Reload", function()
    Sync.applied = false

    if Skinshop and Skinshop.defaultClothes then
        Utils.UpdateClothes(PlayerPedId(), Skinshop.defaultClothes)
    end
end)
