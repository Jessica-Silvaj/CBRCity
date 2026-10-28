MySQL.ready(function()
    -- Adiciona a coluna Transmission na tabela vehicles caso não exista
    pcall(function()
        MySQL.query([[
            ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Transmission` VARCHAR(10) NOT NULL DEFAULT 'auto';
        ]])
    end)
end)

RegisterNetEvent("transmissao:server:requestMode", function(plate)
    local src = source
    if not plate then return end
    
    -- Trim trailing spaces from native GTA plate if necessary
    local cleanPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1")

    MySQL.query("SELECT Transmission FROM vehicles WHERE Plate = ?", {cleanPlate}, function(result)
        local mode = "auto"
        if result and result[1] and result[1].Transmission then
            mode = result[1].Transmission
        end
        TriggerClientEvent("transmissao:client:receiveMode", src, mode)
    end)
end)

exports('setTransmissionMode', function(plate, mode)
    if not plate then return end
    local cleanPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1")
    MySQL.query("UPDATE vehicles SET Transmission = ? WHERE Plate = ?", {mode, cleanPlate})
    TriggerClientEvent("transmissao:client:updateVehicleMode", -1, plate, mode)
end)