local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local aktivRulettek = {}

function getPlayerChips(source)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        return vRP.getInventoryItemAmount(user_id, "chips")
    end
    return 0
end

function giveChips(source, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.giveInventoryItem(user_id, "chips", amount, false)
    end
end

function removeChips(source, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        return vRP.tryGetInventoryItem(user_id, "chips", amount, false)
    end
    return false
end

function isPlayerExist(source)
    if GetPlayerName(source) ~= nil then
        return true
    else
        return false
    end
end

RegisterNetEvent('server_remote:rulett:taskSitDown')
AddEventHandler(
    'server_remote:rulett:taskSitDown',
    function(rulettIndex, chairData)
        local source = source
        local chairId = chairData.chairId

        if aktivRulettek[rulettIndex] ~= nil then
            if aktivRulettek[rulettIndex].chairsUsed[chairId] ~= nil then
           --     return r_showNotification(source, _U('chair_used'))
                return TriggerClientEvent("Notify",source,"Erro","Esta cadeira está ocupada.","vermelho",5000)

            else
                TriggerClientEvent('client_callback:rulett:taskSitDown', source, rulettIndex, chairData)
            end
        else
            TriggerClientEvent('client_callback:rulett:taskSitDown', source, rulettIndex, chairData)
        end
    end
)

RegisterNetEvent('casinoroleta:taskStartRoulette')
AddEventHandler(
    'casinoroleta:taskStartRoulette',
    function(rulettIndex, chairId)
        local source = source

        if aktivRulettek[rulettIndex] == nil then
            aktivRulettek[rulettIndex] = {
                statusz = false,
                ido = ConfigRoleta.RouletteStart,
                bets = {},
                chairsUsed = {}
            }

            ConfigRoleta.DebugMsg(string.format('created rulett on serverside. table: %s', rulettIndex))
        end

        if aktivRulettek[rulettIndex].chairsUsed[chairId] == nil then
            aktivRulettek[rulettIndex].chairsUsed[chairId] = source
            TriggerClientEvent('client:casinoroleta:openRulett', source, rulettIndex)
            TriggerClientEvent('casinoroleta:nui:updateChips', source, getPlayerChips(source))
        else
          --  r_showNotification(source, _U('chair_used'))
            TriggerClientEvent("Notify",source,"Erro","Esta cadeira está ocupada.","vermelho",5000)
        end
    end
)

function countTablePlayers(rulettIndex)
    local count = 0

    if aktivRulettek[rulettIndex] ~= nil then
        for chairId, _ in pairs(aktivRulettek[rulettIndex].chairsUsed) do
            count = count + 1
        end

        return count
    else
        return count
    end
end

RegisterNetEvent('casinoroleta:rulett:notUsing')
AddEventHandler(
    'casinoroleta:rulett:notUsing',
    function(rulettIndex)
        local source = source
        if aktivRulettek[rulettIndex] ~= nil then
            for chairId, src in pairs(aktivRulettek[rulettIndex].chairsUsed) do
                if src == source then
                    aktivRulettek[rulettIndex].chairsUsed[chairId] = nil
                end
            end
        end
    end
)

AddEventHandler(
    'playerDropped',
    function(reason)
        local source = source
        for rulettIndex, v in pairs(aktivRulettek) do
            for chairId, src in pairs(v.chairsUsed) do
                if src == source then
                    aktivRulettek[rulettIndex].chairsUsed[chairId] = nil
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)

            for rulettIndex, v in pairs(aktivRulettek) do
                if v.statusz == false then
                    if v.ido > 0 then
                        aktivRulettek[rulettIndex].ido = v.ido - 1
                        TriggerClientEvent('client:rulett:updateStatusz', -1, rulettIndex, v.ido, v.statusz)
                    end

                    if v.ido < 1 then
                        local randomSpinNumber = math.random(1, 38)
                        if ConfigRoleta.TestTicker ~= nil then
                            randomSpinNumber = ConfigRoleta.TestTicker
                        end
                        local WinningBetIndex = ConfigRoleta.rouletteSzamok[randomSpinNumber]

                        ConfigRoleta.DebugMsg(string.format('Rulett randomSpinNumber: %s, which is number: %s', randomSpinNumber, WinningBetIndex))

                        aktivRulettek[rulettIndex].statusz = true
                        aktivRulettek[rulettIndex].WinningBetIndex = WinningBetIndex
                        TriggerClientEvent('client:rulett:updateStatusz', -1, rulettIndex, v.ido, v.statusz)

                        Citizen.CreateThread(
                            function()
                                ConfigRoleta.DebugMsg('time remaining 0, starting the spin events.')
                                TriggerClientEvent('casinoroleta:rulett:startSpin', -1, rulettIndex, randomSpinNumber)
                                Citizen.Wait(15500)

                                if #v.bets > 0 then
                                    CheckWinners(v.bets, aktivRulettek[rulettIndex].WinningBetIndex)
                                    aktivRulettek[rulettIndex].statusz = false
                                    aktivRulettek[rulettIndex].ido = ConfigRoleta.RouletteStart
                                    aktivRulettek[rulettIndex].WinningBetIndex = nil
                                    aktivRulettek[rulettIndex].bets = {} -- reset the bets on the table, very importante
                                    TriggerClientEvent('client:rulett:updateTableBets', -1, rulettIndex, aktivRulettek[rulettIndex].bets)
                                else
                                    if countTablePlayers(rulettIndex) < 1 then
                                        aktivRulettek[rulettIndex] = nil -- deleting the table from srv
                                        ConfigRoleta.DebugMsg(string.format('Rulett table id %s, stopped because no one using it.', rulettIndex))
                                        TriggerClientEvent('client:rulett:updateStatusz', -1, rulettIndex, nil, nil)
                                    else
                                        aktivRulettek[rulettIndex].statusz = false
                                        aktivRulettek[rulettIndex].ido = ConfigRoleta.RouletteStart
                                        aktivRulettek[rulettIndex].WinningBetIndex = nil
                                        aktivRulettek[rulettIndex].bets = {} -- reset the bets on the table, very importante
                                        TriggerClientEvent('client:rulett:updateTableBets', -1, rulettIndex, aktivRulettek[rulettIndex].bets)
                                    end
                                end
                            end
                        )
                    end
                end
            end
        end
    end
)

function CheckWinners(bets, WinningBetIndex)
    local playersWon = {}
    local playersLoss = {}

    for i = 1, #bets, 1 do
        local betData = bets[i]

        local targetSrc = betData.playerSrc
        local PLAYER_HANDLE = isPlayerExist(targetSrc)
        if PLAYER_HANDLE then
            betData.betId = tostring(betData.betId)
            if (WinningBetIndex == '0' and betData.betId == '37') or (WinningBetIndex == '00' and betData.betId == '38') then -- dbl zero, and zero
                giveWinningChips(targetSrc, betData.betAmount, 35)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif
                (betData.betId == '39' and RULETT_NUMBERS.Pirosak[WinningBetIndex]) or (betData.betId == '40' and RULETT_NUMBERS.Feketek[WinningBetIndex]) or
                    (betData.betId == '41' and RULETT_NUMBERS.Parosak[WinningBetIndex]) or
                    (betData.betId == '42' and RULETT_NUMBERS.Paratlanok[WinningBetIndex]) or
                    (betData.betId == '43' and RULETT_NUMBERS.to18[WinningBetIndex]) or
                    (betData.betId == '44' and RULETT_NUMBERS.to36[WinningBetIndex])
             then
                giveWinningChips(targetSrc, betData.betAmount, 2)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif betData.betId <= '36' and WinningBetIndex == betData.betId then -- the numbers
                giveWinningChips(targetSrc, betData.betAmount, 35)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif
                (betData.betId == '45' and RULETT_NUMBERS.st12[WinningBetIndex]) or (betData.betId == '46' and RULETT_NUMBERS.sn12[WinningBetIndex]) or
                    (betData.betId == '47' and RULETT_NUMBERS.rd12[WinningBetIndex]) or
                    (betData.betId == '48' and RULETT_NUMBERS.ket_to_1[WinningBetIndex]) or
                    (betData.betId == '49' and RULETT_NUMBERS.ket_to_2[WinningBetIndex]) or
                    (betData.betId == '50' and RULETT_NUMBERS.ket_to_3[WinningBetIndex])
             then
                giveWinningChips(targetSrc, betData.betAmount, 3)
                playersWon[targetSrc] = true

                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            else -- LOSS
                if playersWon[targetSrc] == nil then
                    playersLoss[targetSrc] = true
                else
                    playersLoss[targetSrc] = nil
                end
            end
        end
    end

    for targetSrc, _ in pairs(playersLoss) do
        local chairId = getPlayerTableSeat(targetSrc)
        if chairId ~= nil then
            TriggerClientEvent('client:rulett:playLossAnim', targetSrc, chairId)
        end
    end

    for targetSrc, _ in pairs(playersWon) do
        local chairId = getPlayerTableSeat(targetSrc)
        if chairId ~= nil then
            TriggerClientEvent('client:rulett:playWinAnim', targetSrc, chairId)
        end
    end
end

function giveWinningChips(source, amount, szorzo)
    amount = math.floor(amount * szorzo)

    if amount > 0 then
    --    r_showNotification(source, _('won_chips', amount, szorzo))
        TriggerClientEvent("Notify", source, "Sucesso", "Você ganhou " .. amount .. " fichas. Multiplicador: x" .. szorzo, "verde", 5000)
        giveChips(source, amount)
    end
end

RegisterNetEvent('casinoroleta:taskBetRulett')
AddEventHandler(
    'casinoroleta:taskBetRulett',
    function(rulettIndex, betId, betAmount)
        local source = source
        local user_id = vRP.getUserId(source)
        if aktivRulettek[rulettIndex] ~= nil then
            if aktivRulettek[rulettIndex].statusz then
         --       return r_showNotification(source, _U('can_not_bet_because_started'))
                return TriggerClientEvent("Notify",source,"Erro","O jogo começou, você não pode apostar no momento.","vermelho",5000)
            end

            -- Valida a aposta no servidor: inteiro e dentro do limite da mesa
            local Table = ConfigRoleta.RulettTables[rulettIndex]
            betAmount = tonumber(betAmount)
            if not Table or not betAmount or betAmount ~= math.floor(betAmount) or betAmount < Table.minBet or betAmount > Table.maxBet then
                return
            end
            betAmount = math.floor(betAmount)

            if removeChips(source, betAmount) then

           --     r_showNotification(source, _('placed_bet', betAmount))
                TriggerClientEvent("Notify",source,"Sucesso","Aposta feita com "..betAmount.." fichas.","verde",5000)

                TriggerClientEvent('casinoroleta:nui:updateChips', source, getPlayerChips(source))

                ConfigRoleta.DebugMsg(string.format('player %s betted %s chips on betId: %s', GetPlayerName(source), betAmount, betId))

                local exist = false
                for i = 1, #aktivRulettek[rulettIndex].bets, 1 do
                    local d = aktivRulettek[rulettIndex].bets[i]
                    if d.betId == betId and d.playerSrc == source then
                        exist = true
                        aktivRulettek[rulettIndex].bets[i].betAmount = aktivRulettek[rulettIndex].bets[i].betAmount + betAmount
                    end
                end

                if not exist then
                    table.insert(
                        aktivRulettek[rulettIndex].bets,
                        {
                            betId = betId,
                            playerSrc = source,
                            betAmount = betAmount
                        }
                    )
                end
                TriggerClientEvent('client:rulett:updateTableBets', -1, rulettIndex, aktivRulettek[rulettIndex].bets)
                local chairId = getPlayerTableSeat(source)
                if chairId ~= nil then
                    ConfigRoleta.DebugMsg(string.format('%s chair betanim play', chairId))
                    TriggerClientEvent('client:rulett:playBetAnim', source, chairId)
                end
            else
              --  r_showNotification(source, _U('not_enough_chips'))
                TriggerClientEvent("Notify", source, "Aviso", "Você não tem fichas suficientes para fazer uma aposta.", "amarelo", 5000)
            end
        else
            TriggerClientEvent('Notify', source, "Erro", "Ocorreu um erro: mesa de roleta inexistente no servidor.","vermelho",5000)
        end
    end
)

function getPlayerTableSeat(source)
    for rulettIndex, v in pairs(aktivRulettek) do
        for chairId, src in pairs(v.chairsUsed) do
            if src == source then
                return chairId
            end
        end
    end
end
