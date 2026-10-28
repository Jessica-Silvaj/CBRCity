local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface(GetCurrentResourceName(),src)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local aberto = false
local HudAtiva = false
local radios = {}
local radioAtual = nil
local indiceRadioAtual = 1

RegisterCommand("radio", function(source, args, rawCommand)
    if not aberto and vSERVER.hasRadio() and GetEntityHealth(PlayerPedId()) > 101 then
        aberto = true
        SetNuiFocus(true,true)
        SetCursorLocation(0.5, 0.5)
        SendNUIMessage({ action = "openRadio" })

		if not IsPedInAnyVehicle(PlayerPedId()) then
			vRP.CreateObjects("cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
		end
    end
end)

RegisterNetEvent('radio:Open')
AddEventHandler('radio:Open', function()
    if not aberto and vSERVER.hasRadio() and GetEntityHealth(PlayerPedId()) > 101 then
        aberto = true
        SetNuiFocus(true,true)
        SetCursorLocation(0.5, 0.5)
        SendNUIMessage({ action = "openRadio" })

		if not IsPedInAnyVehicle(PlayerPedId()) then
			vRP.CreateObjects("cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
		end
    end
end)

RegisterNUICallback("close",function(data)
    if aberto then
        aberto = false
        SetNuiFocus(false,false)
        vRP.Destroy()
        SendNUIMessage({ action = "closeRadio" })
    end
end)

RegisterNUICallback("conectarFrequencia", function(data, cb)
    local frequencia = tonumber(data.frequencia)

    if frequencia and frequencia >= 1 and frequencia <= 1000 then
        local permitido, isPrivate = vSERVER.CheckRadio(frequencia)
        if not permitido then
            TriggerEvent("Notify", "Erro", "Você não tem permissão para conectar a esta frequência","vermelho",5000)
            return cb('ok')
        end

        local jaConectado = false
        for k, v in pairs(radios) do
            if v.frequencia == frequencia then
                jaConectado = true
                break
            end
        end
        
        if not jaConectado then
            local novoRadio = {
                id = GetGameTimer(),
                frequencia = frequencia,
                nome = "Rádio " .. frequencia,
                tipo = isPrivate and "privada" or "publica",
                volume = 60,
                mic = false,
                ligado = true
            }
            
            table.insert(radios, novoRadio)
            radioAtual = novoRadio
            indiceRadioAtual = #radios
            
            exports["pma-voice"]:setRadioChannel(frequencia)
            exports["pma-voice"]:setVoiceProperty('radioEnabled', true)
            TriggerEvent("hud:Radio",parseInt(frequencia))
            
            SendNUIMessage({ 
                action = "adicionarRadio", 
                radio = novoRadio 
            })

            vSERVER.EntrarRadio(frequencia)

            TriggerEvent("Notify", "Sucesso", "Conectado à frequência: " .. frequencia,"verde",5000)
        else
            TriggerEvent("Notify", "Erro", "Já está conectado nesta frequência","vermelho",5000)
        end
    else
        TriggerEvent("Notify", "Erro", "Frequência inválida","vermelho",5000)
    end
    cb('ok')
end)

-- Desconectar da frequência
RegisterNUICallback("desconectarFrequencia", function(data, cb)
    local radioId = tonumber(data.radioId)
    for k, v in pairs(radios) do
        if v.id == radioId then
            table.remove(radios, k)
            if radioAtual and radioAtual.id == radioId then
                radioAtual = nil
                exports["pma-voice"]:removePlayerFromRadio()
                exports["pma-voice"]:setVoiceProperty('radioEnabled', false)
                TriggerEvent("hud:Radio",parseInt(0))
            end
            SendNUIMessage({ 
                action = "removerRadio", 
                radioId = radioId 
            })

            vSERVER.SairRadio(v.frequencia)

            TriggerEvent("Notify", "Sucesso", "Desconectado da frequência: " .. v.frequencia,"verde",5000)
            break
        end
    end
    cb('ok')
end)

RegisterNUICallback("atualizarVolume", function(data, cb)
    local volume = tonumber(data.volume)
    local radioId = tonumber(data.radioId)
    if volume and volume >= 0 and volume <= 100 and radioId then
        for k, v in pairs(radios) do
            if v.id == radioId then
                v.volume = volume
                if radioAtual and radioAtual.id == radioId then
                    exports["pma-voice"]:setRadioVolume(volume / 100)
                end
                SendNUIMessage({ 
                    action = "atualizarVolume", 
                    volume = volume,
                    radioId = radioId
                })
                TriggerEvent("Notify", "Sucesso", "Volume do rádio: " .. volume .. "%","verde",5000)
                break
            end
        end
    end
    cb('ok')
end)


RegisterNUICallback("toggleHudRadio", function(data, cb)
    HudAtiva = not HudAtiva
    SendNUIMessage({ 
        action = "toggleHudRadio", 
        hudAtiva = HudAtiva 
    })
    
    if HudAtiva then
        TriggerEvent("Notify", "Sucesso", "HUD do rádio ativado","verde",5000)
    else
        TriggerEvent("Notify", "Erro", "HUD do rádio desativado","vermelho",5000)
    end
    cb('ok')
end)

RegisterNUICallback("desligarTodos", function(data, cb)
    for k, v in pairs(radios) do
        exports["pma-voice"]:removePlayerFromRadio()
        exports["pma-voice"]:setVoiceProperty('radioEnabled', false)
    end
    
    radios = {}
    radioAtual = nil
    
    SendNUIMessage({ 
        action = "limparRadios" 
    })
    
    TriggerEvent("Notify", "Sucesso", "Todos os rádios foram desligados","verde",5000)
    cb('ok')
end)

function getHudAtiva()
    return HudAtiva
end

function navegarRadio(direcao)
    if #radios == 0 then
        TriggerEvent("Notify", "Erro", "Nenhum rádio conectado","vermelho",5000)
        return
    end
    
    if direcao == "up" then
        indiceRadioAtual = indiceRadioAtual + 1
        if indiceRadioAtual > #radios then
            indiceRadioAtual = 1
        end
    elseif direcao == "down" then
        indiceRadioAtual = indiceRadioAtual - 1
        if indiceRadioAtual < 1 then
            indiceRadioAtual = #radios
        end
    end
    
    local radioSelecionado = radios[indiceRadioAtual]
    radioAtual = radioSelecionado
    
    exports["pma-voice"]:setRadioChannel(radioSelecionado.frequencia)
    exports["pma-voice"]:setVoiceProperty('radioEnabled', true)
    TriggerEvent("hud:Radio",parseInt(radioSelecionado.frequencia))
    SendNUIMessage({ 
        action = "navegarRadio", 
        radioId = radioSelecionado.id,
        indice = indiceRadioAtual
    })
    
    local direcaoTexto = direcao == "up" and "subiu" or "desceu"
    TriggerEvent("Notify", "Sucesso", "Você " .. direcaoTexto .. " para a rádio " .. radioSelecionado.frequencia,"verde",5000)
end

RegisterKeyMapping('radio_up', 'Rádio - Subir Frequência', 'keyboard', 'PAGEUP')
RegisterKeyMapping('radio_down', 'Rádio - Descer Frequência', 'keyboard', 'PAGEDOWN')

RegisterCommand('radio_up', function()
    if #radios > 0 then
        navegarRadio("up")
    end
end)

RegisterCommand('radio_down', function()
    if #radios > 0 then
        navegarRadio("down")
    end
end)

exports('getHudAtiva', getHudAtiva)


AddEventHandler("onClientResourceStart", function(resName)
	if GetCurrentResourceName() ~= resName and "pma-voice" ~= resName then
		return
	end
	exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
end)

RegisterNetEvent("radio:outServers")
AddEventHandler("radio:outServers",function()
	if radioAtual and radioAtual.frequencia then

        for k, v in pairs(radios) do
            vSERVER.SairRadio(v.frequencia)
            vSERVER.atualizarplayer(v.frequencia)
        end
        radios = {}
        radioAtual = nil
        TriggerEvent("hud:Radio",parseInt(0))
		exports["pma-voice"]:SetRadioChannel(0)
		exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
        SendNUIMessage({ 
            action = "limparRadios" 
        })
        TriggerEvent("Notify", "Sucesso", "Você foi desconectado de todas as rádios","verde",5000)
	end
end)

local animacaoSelect = 1

Citizen.CreateThread(function()
	if GetResourceKvpString('pmaradioanim') then
		animacaoSelect = GetResourceKvpString('pmaradioanim')
	end
end)


RegisterNUICallback("selecionarAnimacao", function(data, cb)
    local id = tonumber(data.id)
    animacaoSelect = id
    SetResourceKvp('pmaradioanim', id)
    TriggerEvent("radio:setAnimacao",id)
    TriggerEvent("Notify", "Sucesso", "Animação de rádio alterada para a " .. id, "verde", 5000)
end)

exports('pmaradioanim', function()
	return tostring(animacaoSelect)
end)

RegisterNUICallback("GetPlayers",function(data,cb)
    if radioAtual and radioAtual.frequencia then
	    local players = vSERVER.GetPlayers(radioAtual.frequencia)
		if players then
			cb({ players = players })
		end
	end
end)

RegisterNetEvent('client:pessoafalando')
AddEventHandler('client:pessoafalando',function (status,freq,id,nome)
	if HudAtiva then
        if freq == radioAtual.frequencia then
            SendNUIMessage({ action = "atualizarUsuarioConectado", id = id, status = false })
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		if aberto then
			Citizen.Wait(1)
			DisableControlAction(0, 1, aberto) -- LookLeftRight
			DisableControlAction(0, 2, aberto) -- LookUpDown
			DisableControlAction(0, 14, aberto) -- INPUT_WEAPON_WHEEL_NEXT
			DisableControlAction(0, 15, aberto) -- INPUT_WEAPON_WHEEL_PREV
			DisableControlAction(0, 16, aberto) -- INPUT_SELECT_NEXT_WEAPON
			DisableControlAction(0, 17, aberto) -- INPUT_SELECT_PREV_WEAPON
			DisableControlAction(0, 99, aberto) -- INPUT_VEH_SELECT_NEXT_WEAPON
			DisableControlAction(0, 100, aberto) -- INPUT_VEH_SELECT_PREV_WEAPON
			DisableControlAction(0, 115, aberto) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
			DisableControlAction(0, 116, aberto) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
			DisableControlAction(0, 142, aberto) -- MeleeAttackAlternate
			DisableControlAction(0, 106, aberto) -- VehicleMouseControlOverride
		else
			Citizen.Wait(20)
		end    
	end
end)

RegisterNetEvent("radio:forceDisconnect")
AddEventHandler("radio:forceDisconnect", function(frequencia)
    for k, v in pairs(radios) do
        if v.frequencia == frequencia then
            local radioId = v.id
            table.remove(radios, k)
            if radioAtual and radioAtual.id == radioId then
                radioAtual = nil
                exports["pma-voice"]:removePlayerFromRadio()
                exports["pma-voice"]:setVoiceProperty('radioEnabled', false)
                TriggerEvent("hud:Radio", parseInt(0))
            end
            SendNUIMessage({ 
                action = "removerRadio", 
                radioId = radioId 
            })
            TriggerEvent("Notify", "Erro", "Você perdeu o acesso à frequência " .. frequencia .. " e foi desconectado.","vermelho",5000)
            break
        end
    end
end)
