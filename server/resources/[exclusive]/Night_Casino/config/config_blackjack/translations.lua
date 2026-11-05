Translations = {}

function _(str, ...) -- Translate string
    if Translations[Config.TranslationSelected] ~= nil then
        if Translations[Config.TranslationSelected][str] ~= nil then
            return string.format(Translations[Config.TranslationSelected][str], ...)
        else
            return 'Translation [' .. Config.TranslationSelected .. '][' .. str .. '] does not exist'
        end
    else
        return 'Locale [' .. Config.TranslationSelected .. '] does not exist'
    end
end

function _U(str, ...) -- Translate string first char uppercase
    return tostring(_(str, ...):gsub('^%l', string.upper))
end

Translations['pt'] = {
    ['limit_exceed'] = 'Sua aposta é muito baixa ou muito alta para esta mesa.',
    ['invalid_bet'] = 'Valor de aposta inválido.',
    ['chair_used'] = 'Esta cadeira está ocupada.',
    ['can_not_bet_because_started'] = 'O jogo começou, você não pode apostar no momento.',
    ['not_enough_chips'] = 'Você não tem fichas suficientes para fazer apostas.',
    ['input_place_bet'] = 'Quantas fichas você gostaria de apostar?',
    -- help msg
    ['help_sit_rulett'] = '~INPUT_CONTEXT~ Sente-se à mesa da roleta.',
    ['help_rulett_all'] = '~INPUT_CELLPHONE_CANCEL~ Ficar de pé\n~INPUT_CONTEXT~ Mudar Camera\n~INPUT_LOOK_LR~ Selecione o número\n~INPUT_ATTACK~ Número da aposta\n~INPUT_CELLPHONE_UP~ Aumente a aposta\n~INPUT_CELLPHONE_DOWN~ Reduzir aposta\n~INPUT_JUMP~ Montante de aposta personalizado',
    -- nui
    ['starting_soon'] = 'O jogo vai começar em breve..',
    ['game_going_on'] = 'O jogo está em andamento..',
    ['seconds'] = 'segundos.',
    -- formatted msg
    ['won_chips'] = 'Você venceu %s chips. Mutiplicador: x%s',
    ['placed_bet'] = 'Aposta feita com %s chips.'

}
Translations['en'] = {
    ['limit_exceed'] = 'Your bet it too low or too high for this table.',
    ['invalid_bet'] = 'Invalid bet amount.',
    ['chair_used'] = 'This chair is occupied.',
    ['can_not_bet_because_started'] = 'The game started, you can not bet at the moment.',
    ['not_enough_chips'] = 'You do not have enough chips to place bet.',
    ['input_place_bet'] = 'How many chips you would like to bet?',
    -- help msg
    ['help_sit_rulett'] = '~INPUT_CONTEXT~ Sit down to the roulette table.',
    ['help_rulett_all'] = '~INPUT_CELLPHONE_CANCEL~ Stand up\n~INPUT_CONTEXT~ Change camera\n~INPUT_LOOK_LR~ Select number\n~INPUT_ATTACK~ Bet number\n~INPUT_CELLPHONE_UP~ Raise bet\n~INPUT_CELLPHONE_DOWN~ Reduce bet\n~INPUT_JUMP~ Custom bet amount',
    -- nui
    ['starting_soon'] = 'The game is starting soon..',
    ['game_going_on'] = 'The game is in progress..',
    ['seconds'] = 'seconds.',
    -- formatted msg
    ['won_chips'] = 'You have won %s chips. Multiplier: x%s',
    ['placed_bet'] = 'Placed bet with %s chips.'
}

Translations['hu'] = {
    ['limit_exceed'] = 'Túl nagy vagy túl alacsony a téted.',
    ['invalid_bet'] = 'Érvénytelen tét érték.',
    ['chair_used'] = 'Ez a szék foglalt.',
    ['can_not_bet_because_started'] = 'Már elkezdődött a játszma, nem rakhatsz tétet.',
    ['not_enough_chips'] = 'Nincs elég chipsed hogy megtedd a tétet.',
    ['input_place_bet'] = 'Tét megadása',
    -- help msg
    ['help_sit_rulett'] = '~INPUT_CONTEXT~ Leülés a rulett asztalhoz.',
    ['help_rulett_all'] = '~INPUT_CELLPHONE_CANCEL~ Felállás\n~INPUT_CONTEXT~ Kameranézet váltás.\n~INPUT_LOOK_LR~ Szám kiválasztása\n~INPUT_ATTACK~ Szám megrakása\n~INPUT_CELLPHONE_UP~ Tét emelése\n~INPUT_CELLPHONE_DOWN~ Tét csökkentése\n~INPUT_JUMP~ Tét megadása',
    -- nui
    ['starting_soon'] = 'Játék hamarosan kezdődik..',
    ['game_going_on'] = 'Játék jelenleg folyamatban..',
    ['seconds'] = 'másodperc.',
    -- formatted msg
    ['won_chips'] = 'Nyertél %s chipset.\n(Szorzó x%s)',
    ['placed_bet'] = 'Tét megrakva %s chipssel.'
}
