Pipa = Pipa or {}
Pipa.shopOpen = false
Pipa.flying = false
Pipa.inventory = nil

local shopBlips = {}

local function notify(msg)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(tostring(msg))
    EndTextCommandThefeedPostTicker(false, false)
end

function Pipa.Notify(msg)
    notify(msg)
end

local function setNui(focus, keepInput)
    SetNuiFocus(focus, focus)
    if keepInput ~= nil then
        SetNuiFocusKeepInput(keepInput)
    end
end

function Pipa.OpenShop(inventory)
    Pipa.shopOpen = true
    Pipa.inventory = inventory
    setNui(true, false)
    SendNUIMessage({
        action = 'mostrar',
        money = inventory.money,
        kites = inventory.kites,
        lines = inventory.lines,
        equipped = inventory.equipped,
        pipas = inventory.kites,
        linhas = inventory.lines,
    })
end

function Pipa.CloseShop()
    if not Pipa.shopOpen then return end
    Pipa.shopOpen = false
    setNui(false, false)
    SendNUIMessage({ action = 'esconder' })
end

function Pipa.ApplyInventory(inventory)
    if not inventory then return end
    Pipa.inventory = inventory
    if Pipa.shopOpen then
        SendNUIMessage({
            action = 'mostrar',
            money = inventory.money,
            kites = inventory.kites,
            lines = inventory.lines,
            equipped = inventory.equipped,
            pipas = inventory.kites,
            linhas = inventory.lines,
        })
    end
end

CreateThread(function()
    for _, shop in ipairs(Config.Shops) do
        local blip = AddBlipForCoord(shop.pos.x, shop.pos.y, shop.pos.z)
        SetBlipSprite(blip, Config.ShopBlip.sprite)
        SetBlipColour(blip, Config.ShopBlip.color)
        SetBlipScale(blip, Config.ShopBlip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.ShopBlip.name)
        EndTextCommandSetBlipName(blip)
        shopBlips[#shopBlips + 1] = blip
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, shop in ipairs(Config.Shops) do
            local dist = #(coords - shop.pos)
            if dist < (Config.MarkerDist or 25.0) then
                sleep = 0
                local c = Config.ShopMarker.color
                DrawMarker(
                    1,
                    shop.pos.x, shop.pos.y, shop.pos.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.ShopMarker.radius * 2.0,
                    Config.ShopMarker.radius * 2.0,
                    0.35,
                    c[1], c[2], c[3], c[4],
                    false, false, 2, false, nil, nil, false
                )

                if dist <= (Config.InteractDist or 1.5) and not Pipa.shopOpen and not Pipa.flying then
                    BeginTextCommandDisplayHelp('STRING')
                    AddTextComponentSubstringPlayerName('Pressione ~INPUT_CONTEXT~ para abrir a loja de pipas')
                    EndTextCommandDisplayHelp(0, false, false, -1)

                    if IsControlJustPressed(0, 38) then
                        local inv = RESPONSE.getInventory()
                        if inv then
                            Pipa.OpenShop(inv)
                        else
                            notify('Não foi possível abrir a loja')
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNUICallback('fechar', function(_, cb)
    Pipa.CloseShop()
    cb({ ok = true })
end)

RegisterNUICallback('comprarPipa', function(data, cb)
    local id = data and (data.id or data.kiteId or data.pipa)
    local res = RESPONSE.buyKite(id)
    if res and res.ok then
        Pipa.ApplyInventory(res.inventory)
        notify('Pipa comprada!')
    else
        notify((res and res.msg) or 'Falha na compra')
    end
    cb(res or { ok = false })
end)

RegisterNUICallback('comprarLinha', function(data, cb)
    local id = data and (data.id or data.lineId or data.linha)
    local res = RESPONSE.buyLine(id)
    if res and res.ok then
        Pipa.ApplyInventory(res.inventory)
        notify('Linha comprada!')
    else
        notify((res and res.msg) or 'Falha na compra')
    end
    cb(res or { ok = false })
end)

RegisterNUICallback('equiparPipa', function(data, cb)
    local id = data and (data.id or data.kiteId or data.pipa)
    local res = RESPONSE.equipKite(id)
    if res and res.ok then
        Pipa.ApplyInventory(res.inventory)
        notify('Pipa equipada')
    else
        notify((res and res.msg) or 'Não foi possível equipar')
    end
    cb(res or { ok = false })
end)

RegisterNUICallback('equiparLinha', function(data, cb)
    local id = data and (data.id or data.lineId or data.linha)
    local res = RESPONSE.equipLine(id)
    if res and res.ok then
        Pipa.ApplyInventory(res.inventory)
        notify('Linha equipada')
    else
        notify((res and res.msg) or 'Não foi possível equipar')
    end
    cb(res or { ok = false })
end)

RegisterNUICallback('erguer', function(_, cb)
    Pipa.CloseShop()
    if Pipa.StartFlight then
        local ok, msg = Pipa.StartFlight()
        if not ok then
            notify(msg or 'Não foi possível erguer a pipa')
        end
        cb({ ok = ok == true })
    else
        cb({ ok = false })
    end
end)

RegisterNetEvent('night_pipa:killfeed', function(data)
    SendNUIMessage({
        action = 'killfeed',
        quem = data and data.quem,
        perdeu = data and data.perdeu,
    })
end)

CreateThread(function()
    Wait(1500)
    TriggerServerEvent('night_pipa:requestState')
end)

RegisterCommand('pipa', function()
    if Pipa.flying then
        notify('Guarde a pipa antes de abrir o menu')
        return
    end

    if Pipa.shopOpen then
        Pipa.CloseShop()
        return
    end

    local res = RESPONSE.openShopCommand()
    if res and res.ok and res.inventory then
        Pipa.OpenShop(res.inventory)
    else
        notify((res and res.msg) or 'Não foi possível abrir o menu de pipas')
    end
end, false)
