local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("vrp","lib/Tunnel")
local vRP = Proxy.getInterface("vRP")
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local cortaGiroLigado = Config.sempreLigado

RegisterCommand(Config.comando, function()
    if vSERVER.checkPermission() then 
        local player = PlayerPedId()
        local veh = GetVehiclePedIsIn(player, false)
        
        -- Se o corta giro estiver desligado e ele estiver tentando ligar
        if not cortaGiroLigado then
            if veh == 0 then
                TriggerEvent("Notify", "Erro", "Você precisa estar em um veículo!", "vermelho", 5000)
                return
            end
            
            local vehicleModel = GetEntityModel(veh)
            local isConfigured = false
            for _, cars in pairs(Config.Cars) do
                if GetHashKey(cars) == vehicleModel then
                    isConfigured = true
                    break
                end
            end
            
            if not isConfigured then
                TriggerEvent("Notify", "Erro", "Este veículo não possui sistema de corta giro configurado!", "vermelho", 5000)
                return
            end
        end

        cortaGiroLigado = not cortaGiroLigado
        TriggerEvent("Notify", "Atenção", "Corta giro está "..(cortaGiroLigado and "LIGADO" or "DESLIGADO").."!", "amarelo", 5000)
    end
end, false)

local reverse = 0

CreateThread(function()
    while true do
        local sleep = 1000
        local player = PlayerPedId()
        local veh = GetVehiclePedIsIn(player, false)
        local delay = math.random(25, Config.explosionSpeed)

        local explosionTypes = {
            {type = 61, noDamage = true},
            -- {type = 62, noDamage = true},
        }

        if GetPedInVehicleSeat(veh, -1) == player and cortaGiroLigado then
            sleep = 0
            local RPM = GetVehicleCurrentRpm(veh)
            local gear = GetVehicleCurrentGear(veh)
            if veh ~= 0 then  -- Verifica se o ped está em um veículo
                local vehiclePos = GetEntityCoords(veh)  -- Obtem as coordenadas do veículo
                for _, cars in pairs(Config.Cars) do
                    local vehicleModel = GetEntityModel(veh)
                    if GetHashKey(cars) == vehicleModel then
                        if gear ~= reverse then
                            if not IsEntityInAir(veh) then
                                if not IsControlPressed(1, 71) and not IsControlPressed(1, 72) then
                                    if RPM > Config.RPM then
                                        TriggerServerEvent("foguinho", VehToNet(veh))
                                        TriggerServerEvent("sound_server:TocarPorDistancia", 25.0, tostring(math.random(1, 6)), Config.volume)
                                        SetVehicleTurboPressure(veh, 900)

                                        -- Seleciona um tipo de explosão aleatório
                                        local explosionChoice = explosionTypes[math.random(#explosionTypes)]
                                        AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, explosionChoice.type, 0.0, true, explosionChoice.noDamage, 0.0, false)

                                        TriggerFlareEffect(veh)
                                        Wait(delay)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)


-- Definição dos tipos de explosão baseado na lista fornecida
local explosionTypes = {
    [0] = "GRENADE",
    [1] = "GRENADELAUNCHER",
    [2] = "STICKYBOMB",
    [3] = "MOLOTOV",
    [4] = "ROCKET",
    [5] = "TANKSHELL",
    [6] = "HI_OCTANE",
    [7] = "CAR",
    [8] = "PLANE",
    [9] = "PETROL_PUMP",
    [10] = "BIKE",
    [11] = "DIR_STEAM",
    [12] = "DIR_FLAME",
    [13] = "DIR_WATER_HYDRANT",
    [14] = "DIR_GAS_CANISTER",
    [15] = "BOAT",
    [16] = "SHIP_DESTROY",
    [17] = "TRUCK",
    [18] = "BULLET",
    [19] = "SMOKEGRENADELAUNCHER",
    [20] = "SMOKEGRENADE",
    [21] = "BZGAS",
    [22] = "FLARE",
    [23] = "GAS_CANISTER",
    [24] = "EXTINGUISHER",
    [25] = "PROGRAMMABLEAR",
    [26] = "TRAIN",
    [27] = "BARREL",
    [28] = "PROPANE",
    [29] = "BLIMP",
    [30] = "DIR_FLAME_EXPLODE",
    [31] = "TANKER",
    [32] = "PLANE_ROCKET",
    [33] = "VEHICLE_BULLET",
    [34] = "GAS_TANK",
    [35] = "BIRD_CRAP",
    [36] = "RAILGUN",
    [37] = "BLIMP2",
    [38] = "FIREWORK",
    [39] = "SNOWBALL",
    [40] = "PROXMINE",
    [41] = "VALKYRIE_CANNON",
    [42] = "AIR_DEFENCE",
    [43] = "PIPEBOMB",
    [44] = "VEHICLEMINE",
    [45] = "EXPLOSIVEAMMO",
    [46] = "APCSHELL",
    [47] = "BOMB_CLUSTER",
    [48] = "BOMB_GAS",
    [49] = "BOMB_INCENDIARY",
    [50] = "BOMB_STANDARD",
    [51] = "TORPEDO",
    [52] = "TORPEDO_UNDERWATER",
    [53] = "BOMBUSHKA_CANNON",
    [54] = "BOMB_CLUSTER_SECONDARY",
    [55] = "HUNTER_BARRAGE",
    [56] = "HUNTER_CANNON",
    [57] = "ROGUE_CANNON",
    [58] = "MINE_UNDERWATER",
    [59] = "ORBITAL_CANNON",
    [60] = "BOMB_STANDARD_WIDE",
    [61] = "EXPLOSIVEAMMO_SHOTGUN",
    [62] = "OPPRESSOR2_CANNON",
    [63] = "MORTAR_KINETIC",
    [64] = "VEHICLEMINE_KINETIC",
    [65] = "VEHICLEMINE_EMP",
    [66] = "VEHICLEMINE_SPIKE",
    [67] = "VEHICLEMINE_SLICK",
    [68] = "VEHICLEMINE_TAR",
    [69] = "SCRIPT_DRONE",
    [70] = "RAYGUN",
    [71] = "BURIEDMINE",
    [72] = "SCRIPT_MISSILE",
    [73] = "RCTANK_ROCKET",
    [74] = "BOMB_WATER",
    [75] = "BOMB_WATER_SECONDARY",
    [76] = "STICKYBOMB_GRENADE",
    [77] = "STUNGRENADE",
    [78] = "FLASHGRENADE",
    [79] = "STUNGRENADE",
    [80] = "TEARGAS",
    [81] = "SCRIPT_MISSILE_LARGE",
    [82] = "SUBMARINE_BIG"
}

function TriggerFlareEffect(veh)
    local exhausts = { "exhaust", "exhaust_2", "exhaust_3", "exhaust_4" }
    local fxName = "veh_backfire"
    local fxGroup = "core"
    local flameSize = 1.0  -- Ajuste conforme necessário

    for _, boneName in ipairs(exhausts) do
        local boneIndex = GetEntityBoneIndexByName(veh, boneName)
        if boneIndex ~= -1 then
            UseParticleFxAssetNextCall(fxGroup)
            local flare = StartParticleFxLoopedOnEntityBone(fxName, veh, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, flameSize, false, false, false)
            -- Citizen.Wait(1000)  -- Durante 1 segundo, mantém o flare ativo
            StopParticleFxLooped(flare, true)
        end
    end
end

local exhausts = { "exhaust", "exhaust_2", "exhaust_3", "exhaust_4" }
local fxName = "veh_backfire"
local fxGroup = "core"

RegisterNetEvent('sound_client:TocarPorDistancia')
AddEventHandler('sound_client:TocarPorDistancia', function(coords, disMax, audoFile, audioVol)
    local entityCoords   = GetEntityCoords(PlayerPedId())
    local distance       = #(entityCoords - coords)
    local distanceRatio  = distance / disMax        -- calcular a distância
    local adjustedVolume = audioVol / distanceRatio -- Ajusta o valor baseado na distância

    if (distance <= disMax) then
        SendNUIMessage({
            transactionType   = 'playSound',
            transactionFile   = audoFile,
            transactionVolume = adjustedVolume -- Usado para ajustar o volume
        })
    end
end)

RegisterNetEvent("client_foguinho")
AddEventHandler("client_foguinho", function(vehicle,vehiclePos )
    local player = PlayerPedId()
    local veh = GetVehiclePedIsIn(player, false)
    local vehiclePos = GetEntityCoords(veh)  -- Obtem as coordenadas do veículo
    if NetworkDoesEntityExistWithNetworkId(vehicle) then
        for _, bones in pairs(exhausts) do
            local boneIndex = GetEntityBoneIndexByName(NetToVeh(vehicle), bones)
            if boneIndex ~= -1 then
                UseParticleFxAssetNextCall(fxGroup)
                local startParticle = StartParticleFxLoopedOnEntityBone(fxName, NetToVeh(vehicle), 0.0, 0.0, 0.0, 0.0,0.0,0.0,
                GetEntityBoneIndexByName(NetToVeh(vehicle), bones), Config.flameSize, 0.0, 0.0, 0.0)
                StopParticleFxLooped(startParticle, true)
                AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
            end
        end
    end
end)

