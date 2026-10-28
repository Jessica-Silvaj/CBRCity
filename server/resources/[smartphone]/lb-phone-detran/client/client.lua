
local Proxy = module('vrp', 'lib/Proxy')
local Tunnel = module('vrp', 'lib/Tunnel')
local vRP = Proxy.getInterface('vRP')
local Server = Tunnel.getInterface('detran-app')
local polling = {}

CreateThread(function()
    exports['lb-phone']:AddCustomApp({
        identifier = 'detran',
        name = 'CNH Digital',
        description = 'A Carteira Digital de Trânsito é a evolução da CNH Digital.',
        developer = 'CBR CITY',
        defaultApp = false,
        fixBlur = true,
        size = 21700,
        ui = GetCurrentResourceName() .. '/web/index.html',
        icon = 'https://cfx-nui-' .. GetCurrentResourceName() .. '/web/assets/detran.png',
    })
end)

RegisterNUICallback('getData', function(data, cb)
    local data = Server.getData()
    local model = GetEntityModel(PlayerPedId())
    local sexStr = "OUTRO"
    if model == `mp_m_freemode_01` then
        sexStr = "MASCULINO"
    elseif model == `mp_f_freemode_01` then
        sexStr = "FEMININO"
    end
    
    cb({
        name = data.name,
        id = data.id,
        cpf = data.id,
        rg = data.id,
        categories = data.categories,
        licensePoints = data.licensePoints or 0,
        createdAt = data.createdAt,
        sex = sexStr
    })
end)

RegisterNUICallback('getVehicles', function(data, cb)
    cb(Server.getVehicles())
end)

RegisterNUICallback('getVehicle', function(data, cb)
    cb(Server.getVehicle(data.plate))
end)

RegisterNUICallback('payImpound', function(data, cb)
    cb(Server.payImpound(data.plate))
end)

RegisterNUICallback('payTax', function(data, cb)
    cb(Server.payTax(data.plate))
end)

RegisterNetEvent('detran-app:emitMessage', function(data)
    table.insert(polling, data)
end)

RegisterNUICallback('polling', function(_, cb)
    local timeWaiting = 0
    while #polling == 0 and timeWaiting < 300 do
        Wait(100)
        timeWaiting = timeWaiting + 0.1
    end
    cb(polling)
    polling = {}
end)
