local wallAtivo = false

-- Variáveis de estado inicializadas pela Config
local showLines = Config.Visual.Lines
local showBox = Config.Visual.Box
local showInfo = Config.Visual.Info
local showVehicles = Config.RenderizarVeiculos

local playersSyncData = {}
local showMenu = true

local weaponNames = {
    [tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal', [tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar', [tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
    [tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol', [tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle', [tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2'))] = 'Assault Rifke Mk2',
    [tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun', [tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG', [tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
    [tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle', [tostring(GetHashKey('WEAPON_BULLPUPRIFLE_MK2'))] = 'Bullpup Rifle Mk2',[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
    [tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle', [tostring(GetHashKey('WEAPON_CARBINERIFLE_MK2'))] = 'Carbine Rifle Mk2', [tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
    [tostring(GetHashKey('WEAPON_COMBATMG_MK2'))] = 'Combat MG Mk2', [tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW', [tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
    [tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle', [tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun', [tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Double Action Revolver',
    [tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare gun', [tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg', [tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
    [tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun', [tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper', [tostring(GetHashKey('WEAPON_HEAVYSNIPER_MK2'))] = 'Heavy Sniper',
    [tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol', [tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol', [tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
    [tostring(GetHashKey('WEAPON_MARKSMANRIFLE_MK2'))] = 'Marksman Rifle Mk2', [tostring(GetHashKey('WEAPON_MG'))] = 'MG', [tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
    [tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun', [tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG', [tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
    [tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol', [tostring(GetHashKey('WEAPON_PISTOL_MK2'))] = 'Pistol Mk2', [tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
    [tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun', [tostring(GetHashKey('WEAPON_PUMPSHOTGUN_MK2'))] = 'Pump Shotgun Mk2', [tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
    [tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Revolver', [tostring(GetHashKey('WEAPON_REVOLVER_MK2'))] = 'Revolver Mk2', [tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawnoff Shotgun',
    [tostring(GetHashKey('WEAPON_SMG'))] = 'SMG', [tostring(GetHashKey('WEAPON_SMG_MK2'))] = 'SMG Mk2', [tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
    [tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol', [tostring(GetHashKey('WEAPON_SNSPISTOL_MK2'))] = 'SNS Pistol Mk2', [tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
    [tostring(GetHashKey('WEAPON_SPECIALCARBINE_MK2'))] = 'Special Carbine Mk2', [tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger', [tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stungun',
    [tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol', [tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Vehicle Lasers',
    [tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire', [tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare', [tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flaregun',
    [tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov', [tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Petrol Can', [tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Helicopter Crash',
    [tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Vehicle', [tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Ranover by Vehicle', [tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Vehicle Space Rocket',
    [tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank', [tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket', [tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
    [tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Launcher', [tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion', [tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework',
    [tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade', [tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher', [tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
    [tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket', [tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipe bomb', [tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
    [tostring(GetHashKey('WEAPON_RPG'))] = 'RPG', [tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb', [tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
    [tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas', [tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher', [tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Smoke Grenade',
    [tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battleaxe', [tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle', [tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
    [tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete', [tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switch Blade', [tostring(GetHashKey('OBJECT'))] = 'Object',
    [tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Vehicle Rotors', [tostring(GetHashKey('WEAPON_BALL'))] = 'Ball', [tostring(GetHashKey('WEAPON_BAT'))] = 'Bat',
    [tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar', [tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight', [tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golfclub',
    [tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer', [tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet', [tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Water Cannon',
    [tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle', [tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Night Stick', [tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Pool Cue',
    [tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball', [tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench', [tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowned',
    [tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowned in Vehicle', [tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire', [tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleed',
    [tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence', [tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion', [tostring(GetHashKey('WEAPON_FALL'))] = 'Falling'
}

RegisterNetEvent("admin_wall:updateSyncData")
AddEventHandler("admin_wall:updateSyncData", function(data)
    playersSyncData = data
end)

--------------------------------------------------------------------------------
-- FUNÇÕES AUXILIARES
--------------------------------------------------------------------------------
local function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextEntry("CELL_EMAIL_BCON")
        SetTextCentre(1)
        for i = 1, string.len(text), 99 do
            AddTextComponentSubstringPlayerName(string.sub(text, i, i + 98))
        end
        DrawText(_x, _y)
    end
end

local function DrawBoxESP(entity, r, g, b)
    local x, y, z = table.unpack(GetEntityCoords(entity, true))
    local h = 1.8; local w = 0.5
    
    -- Desenha linhas verticais
    DrawLine(x-w, y-w, z-1.0, x-w, y-w, z+h, r, g, b, 255)
    DrawLine(x+w, y-w, z-1.0, x+w, y-w, z+h, r, g, b, 255)
    DrawLine(x-w, y+w, z-1.0, x-w, y+w, z+h, r, g, b, 255)
    DrawLine(x+w, y+w, z-1.0, x+w, y+w, z+h, r, g, b, 255)
    
    -- Desenha topos e bases
    DrawLine(x-w, y-w, z+h, x+w, y-w, z+h, r, g, b, 255)
    DrawLine(x-w, y+w, z+h, x+w, y+w, z+h, r, g, b, 255)
    DrawLine(x-w, y-w, z+h, x-w, y+w, z+h, r, g, b, 255)
    DrawLine(x+w, y-w, z+h, x+w, y+w, z+h, r, g, b, 255)
end

--------------------------------------------------------------------------------
-- LÓGICA DO WALL
--------------------------------------------------------------------------------
RegisterNetEvent("admin_wall:toggle")
AddEventHandler("admin_wall:toggle", function(status)
    wallAtivo = status
    if wallAtivo then
        TriggerEvent("Notify", "Sucesso", "Wall Admin: <b>ATIVADO</b>", "verde", 5000)
        StartWallLoop()
    else
        TriggerEvent("Notify", "Atenção", "Wall Admin: <b>DESATIVADO</b>", "amarelo", 5000)
    end
end)

function StartWallLoop()
    CreateThread(function()
        while wallAtivo do
            local sleep = 5
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)
            
            -- Jogadores
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                
                if ped ~= myPed and DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local distance = #(myCoords - coords)
                    
                    if distance <= Config.DistanciaESP then
                        local r, g, b = table.unpack(Config.Cores.Player)
                        local isArmed = IsPedArmed(ped, 4)
                        
                        if isArmed then
                            r, g, b = table.unpack(Config.Cores.Armado)
                        end
                        
                        if showBox then DrawBoxESP(ped, r, g, b) end
                        
                        if showLines then
                            local lr, lg, lb = table.unpack(Config.Cores.Snapline)
                            DrawLine(myCoords.x, myCoords.y, myCoords.z, coords.x, coords.y, coords.z, lr, lg, lb, 255)
                        end
                        
                        if showInfo then
                            local armor = GetPedArmour(ped)
                            local health = GetEntityHealth(ped) - 100
                            local serverId = GetPlayerServerId(player)
                            
                            local pData = playersSyncData[tostring(serverId)] or playersSyncData[serverId] or { wall = false, perm = "N/A", passport = serverId }
                            local pWallStatus = pData.wall and "~g~ON" or "~r~OFF"
                            local pPerm = pData.perm
                            local displayId = pData.passport or serverId
                            
                            local weaponHash = GetSelectedPedWeapon(ped)
                            local weaponStr = "Desarmado"
                            
                            if weaponHash ~= `WEAPON_UNARMED` and weaponHash ~= 0 then
                                local hashString = tostring(weaponHash)
                                if weaponNames[hashString] then
                                    weaponStr = weaponNames[hashString]
                                else
                                    weaponStr = "Armado ("..hashString..")"
                                end
                            end
                            
                            local infoText = string.format(
                                "~w~ID: ~b~%s ~w~| Dist: ~y~%d m\n~w~HP: ~g~%d%% ~w~| Armor: ~b~%d%%\n~w~Grupo: ~y~%s ~w~| Wall: %s\n~w~Arma: ~c~%s",
                                displayId, math.floor(distance), (health > 0 and health or 0), armor, pPerm, pWallStatus, weaponStr
                            )
                            DrawText3D(coords.x, coords.y, coords.z + 1.2, infoText, {r, g, b})
                        end
                    end
                end
            end

            -- Veículos
            if showVehicles then
                local vehicles = GetGamePool('CVehicle')
                for _, veh in ipairs(vehicles) do
                    local coords = GetEntityCoords(veh)
                    local distance = #(myCoords - coords)
                    
                    if distance <= Config.DistanciaESP and distance > 5.0 then
                        if IsEntityOnScreen(veh) then
                            local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                            local plate = GetVehicleNumberPlateText(veh)
                            local speed = math.ceil(GetEntitySpeed(veh) * 3.6)
                            
                            DrawText3D(coords.x, coords.y, coords.z + 0.5, 
                                string.format("~b~%s ~w~[%s]\n~y~%d km/h", model, plate, speed), 
                                Config.Cores.Veiculo
                            )
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

--------------------------------------------------------------------------------
-- MENU RÁPIDO E DETECTOR HS
--------------------------------------------------------------------------------

-- Menu F2
-- Interface Wall e Comandos
CreateThread(function()
    while true do
        local sleep = 1000
        if wallAtivo then
            sleep = 5
            if showMenu then
                -- Interface com múltiplas linhas (evita o limite de 99 chars do FiveM)
                DrawRect(0.92, 0.55, 0.11, 0.17, 0, 0, 0, 170)
                
                local startY = 0.465
                local linhas = {
                    "~y~INTERFACE WALL",
                    "~w~Box (/wallbox): "..(showBox and "~g~ON" or "~r~OFF"),
                    "~w~Lines (/walllines): "..(showLines and "~g~ON" or "~r~OFF"),
                    "~w~Info (/wallinfo): "..(showInfo and "~g~ON" or "~r~OFF"),
                    "~w~Veículos (/wallveh): "..(showVehicles and "~g~ON" or "~r~OFF"),
                    "~c~Fechar/Abrir (/wallmenu)"
                }
                
                for i, texto in ipairs(linhas) do
                    SetTextFont(4); SetTextScale(0.30, 0.30); SetTextColour(255, 255, 255, 255)
                    SetTextEntry("STRING")
                    AddTextComponentString(texto)
                    DrawText(0.87, startY + (i - 1) * 0.024)
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterCommand("wallmenu", function()
    if wallAtivo then
        showMenu = not showMenu
    end
end)

RegisterCommand("wallbox", function()
    if wallAtivo then
        showBox = not showBox
        TriggerEvent("Notify", "Atenção", "Box: "..(showBox and "<b>ATIVADO</b>" or "<b>DESATIVADO</b>"), "amarelo", 5000)
    end
end)

RegisterCommand("walllines", function()
    if wallAtivo then
        showLines = not showLines
        TriggerEvent("Notify", "Atenção", "Lines: "..(showLines and "<b>ATIVADO</b>" or "<b>DESATIVADO</b>"), "amarelo", 5000)
    end
end)

RegisterCommand("wallinfo", function()
    if wallAtivo then
        showInfo = not showInfo
        TriggerEvent("Notify", "Atenção", "Info: "..(showInfo and "<b>ATIVADO</b>" or "<b>DESATIVADO</b>"), "amarelo", 5000)
    end
end)

RegisterCommand("wallveh", function()
    if wallAtivo then
        showVehicles = not showVehicles
        TriggerEvent("Notify", "Atenção", "Veículos: "..(showVehicles and "<b>ATIVADO</b>" or "<b>DESATIVADO</b>"), "amarelo", 5000)
    end
end)

-- Detector de HS Simples
if Config.Logs.Headshot then
    CreateThread(function()
        while true do
            Wait(100)
            local ped = PlayerPedId()
            if IsPedShooting(ped) then
                local _, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if IsEntityAPed(entity) and not IsPedAPlayer(entity) then
                     -- Verifica se acertou o osso da cabeça configurado na Config
                    local found, bone = GetPedLastDamageBone(entity)
                    if found and (bone == Config.BoneHead) then
                       if GetEntityHealth(entity) <= 100 then
                           TriggerServerEvent("admin_wall:logHeadshot", "Arma de Fogo")
                           Wait(1000)
                       end
                    end
                end
            end
        end
    end)
end