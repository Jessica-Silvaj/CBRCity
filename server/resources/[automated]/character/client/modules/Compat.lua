local function PedGender()
    return GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") and "f" or "m"
end

RegisterNetEvent("skinshop:Open", function()
    if Skinshop then
        Skinshop:Open()
    end
end)

RegisterNetEvent("barbershop:Open", function()
    if Barbershop then
        Barbershop:Open()
    end
end)

RegisterNetEvent("tattooshop:Open", function()
    if Tattooshop then
        Tattooshop:Open()
    end
end)

RegisterNetEvent("skinshop:Apply", function(Data, Save)
    if type(Data) == "table" then
        Utils.UpdateClothes(PlayerPedId(),Data)
        if Skinshop and Save then
            Skinshop.defaultClothes = Utils.CopyTable(Data)
        end
    end
end)

RegisterNetEvent("barbershop:Apply", function(Data)
    if type(Data) == "table" then
        Sync.appearance = Utils.CopyTable(Data)
        Utils.UpdateAppearance(PlayerPedId(),Sync.appearance)
        Sync.applied = true
    end
end)

RegisterNetEvent("tattooshop:Apply", function(Data)
    if type(Data) == "table" then
        Sync.tattoos = Utils.CopyTable(Data)
        Utils.UpdateTattoos(PlayerPedId(),Sync.tattoos)
        Sync.applied = true
    end
end)

RegisterNetEvent("spawn:Finish", function(Coords)
end)

RegisterNetEvent("spawn:StartSelector", function()
    TriggerServerEvent("character:Server:Spawn")
end)

exports("ApplySkinshop", function(Data)
    TriggerEvent("skinshop:Apply",Data,true)
end)

exports("ApplyBarbershop", function(Data)
    TriggerEvent("barbershop:Apply",Data)
end)

exports("OpenSkinshop", function()
    TriggerEvent("skinshop:Open")
end)

exports("OpenBarbershop", function()
    TriggerEvent("barbershop:Open")
end)

exports("OpenTattooshop", function()
    TriggerEvent("tattooshop:Open")
end)

exports("Creation", function(Gender)
    if Creator then
        Creator.genetics.gender = Gender or PedGender()
        Creator:Open(Creator.genetics.gender)
    end
end)
