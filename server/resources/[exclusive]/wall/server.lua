local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-- Função de Log Genérica Otimizada
function SendDiscordLog(title, message, color)
    if Config.Webhook == "" then return end
    
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. title .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = Config.BotName .. " • " .. os.date("%d/%m/%Y %H:%M:%S"),
                ["icon_url"] = Config.BotAvatar
            },
        }
    }
    
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, avatar_url = Config.BotAvatar, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local wallUsers = {}

-- Comando Dinâmico (Lê Config.Comando)
RegisterCommand(Config.Comando, function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasPermission(Passport, Config.Permissao) then
            wallUsers[source] = not wallUsers[source]
            TriggerClientEvent("admin_wall:toggle", source, wallUsers[source])
            
            if Config.Logs.AtivarWall then
                local identity = vRP.Identity(Passport)
                SendDiscordLog("Wall Admin Alterado", 
                    "Admin: **" .. (identity and identity.Name or "Desconhecido") .. "** (ID: " .. Passport .. ")\nStatus: **" .. (wallUsers[source] and "Ativado" or "Desativado") .. "**", 
                    3447003 -- Azul
                )
            end
        else
            TriggerClientEvent("Notify", source, "Erro", "Permissão insuficiente.", "vermelho", 5000)
        end
    end
end)

-- Sincronização de dados para o painel de quem está com Wall Ativo
CreateThread(function()
    while true do
        Wait(2000) -- Atualiza os dados a cada 2 segundos
        
        local hasWallActive = false
        for _, active in pairs(wallUsers) do
            if active then hasWallActive = true; break; end
        end
        
        if hasWallActive then
            local syncData = {}
            for _, player in ipairs(GetPlayers()) do
                local src = tonumber(player)
                local Passport = vRP.Passport(src)
                if Passport then
                    local hierarquia = "Cidadão"
                    
                    -- Puxa todos os grupos que o jogador tem dinamicamente
                    if vRP.UserGroups then
                        local grupos = vRP.UserGroups(Passport)
                        local myGroupsList = {}
                        
                        for gName, _ in pairs(grupos) do
                            local tipo = vRP.GroupType and vRP.GroupType(gName) or ""
                            table.insert(myGroupsList, { name = gName, type = tipo })
                        end
                        
                        if #myGroupsList > 0 then
                            -- Define a prioridade de exibição
                            local prioridade = { ["Staff"] = 1, ["Work"] = 2, ["Vip"] = 3 }
                            
                            -- Ordena os grupos baseado na prioridade (Staff vem primeiro, etc.)
                            table.sort(myGroupsList, function(a, b)
                                local pA = prioridade[a.type] or 99
                                local pB = prioridade[b.type] or 99
                                if pA == pB then return a.name < b.name end
                                return pA < pB
                            end)
                            
                            local exibicao = {}
                            -- Pega no máximo os 3 primeiros grupos
                            for i = 1, math.min(3, #myGroupsList) do
                                local formatado = myGroupsList[i].name:gsub("^%l", string.upper)
                                table.insert(exibicao, formatado)
                            end
                            
                            hierarquia = table.concat(exibicao, " | ")
                        end
                    end
                    
                    syncData[tostring(src)] = {
                        wall = wallUsers[src] or false,
                        perm = hierarquia,
                        passport = Passport
                    }
                end
            end
            
            for src, active in pairs(wallUsers) do
                if active then
                    TriggerClientEvent("admin_wall:updateSyncData", src, syncData)
                end
            end
        end
    end
end)

-- Evento de Log de Headshot
RegisterNetEvent("admin_wall:logHeadshot")
AddEventHandler("admin_wall:logHeadshot", function(weaponName)
    if not Config.Logs.Headshot then return end
    
    local source = source
    local Passport = vRP.Passport(source) 
    
    if Passport then
        local identity = vRP.Identity(Passport)
        SendDiscordLog("Headshot Detectado", 
            "Jogador: **" .. identity.Name .. "** (ID: " .. Passport .. ")\nArma: " .. weaponName .. "\nInfo: Acertou HS fatal.", 
            15158332 -- Vermelho
        )
    end
end)