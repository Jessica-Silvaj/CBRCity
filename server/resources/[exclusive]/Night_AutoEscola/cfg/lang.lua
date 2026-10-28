-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO DE PAÍS / IDIOMA
-- "BR" = Brasil  |  "PT" = Portugal
-----------------------------------------------------------------------------------------------------------------------------------------
pais = "BR" -- alterar para "PT" para português de Portugal

-----------------------------------------------------------------------------------------------------------------------------------------
lang = {
    -----------------------------------------------------------------------------------------------------------------------------------------
    BR = {
        -- Documento
        nomeDocumento  = "Carteira Nacional de Habilitação",
        abrevDocumento = "CNH",
        nomePais       = "BRASIL",
        entidade       = "DETRAN",
        numLabel       = "Nº do Registo",
        pontos         = 20,   -- CNH brasileira tem 20 pontos
        moeda          = "R$",  -- símbolo monetário na interface
        localeNum      = "pt-BR",
        -- Auto Escola NUI
        autoescolaNome = "Auto Escola",
        autoescolaDesc = "Centro de Habilitação",
        -- Médico
        medicoItem     = "laudo_medico",
        medicoLabel    = "Laudo Médico",
        -- Itens
        laudoLabel     = "Certificado Teórico",
        -- Notificações gerais
        semIdentificacao   = "Sem identificação.",
        semPermissao       = "Sem permissão.",
        cartaSuspensa      = "A tua CNH está suspensa por excesso de pontos.",
        semAtestado        = "Precisas de um laudo médico válido. Visita o médico da auto escola.",
        jaTemLaudo         = "Já tens o certificado teórico. Realiza o exame prático.",
        saldoInsuficiente  = function(cat, val) return "Saldo insuficiente. A inscrição na categoria " .. cat .. " custa R$" .. val .. "." end,
        semPrerequisito    = function(pre, cat) return "Precisas da categoria " .. pre .. " para te inscreveres na " .. cat .. "." end,
        emCooldown         = function(dias) return "Suspenso. Podes repetir o exame em " .. dias .. " dia(s)." end,
        -- Teórico
        aprovadoTeorico    = function(c, t) return "Aprovado no teórico! " .. c .. "/" .. t .. " certas. Realiza o exame prático." end,
        reprovadoTeorico   = function(c, t, e, m, dt) return "Reprovado! " .. c .. "/" .. t .. " certas (" .. e .. " erros, máx " .. m .. "). Repete em " .. dt .. "." end,
        -- Prático
        veiculoDestruido   = "Veículo destruído. Exame cancelado!",
        saiuVeiculo        = "Saíste do veículo. Exame cancelado!",
        manobrasConcluidas = "Manobras concluídas! A iniciar fase de circulação...",
        manobrasTempo      = function(min) return "Fase de manobras! Estaciona na zona indicada. Tens " .. min .. " minutos." end,
        exameIniciado      = function(n, m) return "Exame iniciado! " .. n .. " checkpoints. Máx. " .. m .. " infração(ões)." end,
        infraVelocidade    = function(spd, lim, e, m) return string.format("Infração! %d km/h (limite %d km/h) | Erros: %d/%d", spd, lim, e, m) end,
        checkpoint         = function(a, t) return "Checkpoint " .. a .. "/" .. t .. " OK!" end,
        aprovadoPratico    = function(cat, val) return "Parabéns! Categoria " .. cat .. " aprovada. Válida até " .. val .. "." end,
        reprovadoPratico   = function(e, m, dt) return "Reprovado! " .. e .. " infração(ões). Máx " .. m .. ". Repetes em " .. dt .. "." end,
        exameRapido        = "Exame concluído rápido demais.",
        -- Atestado / Laudo
        laudoEmitido       = function(dt) return "Laudo médico emitido! Válido até " .. dt .. "." end,
        laudoJaValido      = function(dt) return "Já tens laudo válido até " .. dt .. "." end,
        -- Renovação
        catRenovada        = function(cat, dt) return "Categoria " .. cat .. " renovada até " .. dt .. "!" end,
        -- Polícia
        pontosRemovidos    = function(q, n) return "Foram perdoados " .. q .. " ponto(s) da tua CNH. Total: " .. n .. "/20." end,
        cnhSuspensa        = "A tua CNH foi SUSPENSA por excesso de pontos!",
        categoriaRemovida  = function(cat) return "A tua categoria " .. cat .. " foi cassada por autoridade policial." end,
        pontosAdicionados  = function(q, n) return "Recebeste " .. q .. " ponto(s) de infração. Total: " .. n .. "/20." end,
        -- Cooldown
        cooldownReset      = function(cat, nome) return "Suspensão da categoria " .. cat .. " de " .. nome .. " removida." end,
        cooldownsReset     = function(nome) return "Todas as suspensões de " .. nome .. " foram removidas." end,
        cooldownNotificado = function(cat) return "A tua suspensão para a categoria " .. cat .. " foi removida." end,
        cooldownsNotificado = "Todas as tuas suspensões da auto escola foram removidas.",
    },
    -----------------------------------------------------------------------------------------------------------------------------------------
    PT = {
        -- Documento
        nomeDocumento  = "Carta de Condução",
        abrevDocumento = "CC",
        nomePais       = "PORTUGAL",
        entidade       = "IMT, I.P.",
        numLabel       = "Número",
        pontos         = 12,   -- Carta portuguesa tem 12 pontos
        moeda          = "R$",   -- símbolo monetário na interface
        localeNum      = "pt-PT",
        -- Auto Escola NUI
        autoescolaNome = "Auto Escola",
        autoescolaDesc = "Centro de Habilitação",
        -- Médico
        medicoItem     = "atestadomedico",
        medicoLabel    = "Atestado Médico",
        -- Itens
        laudoLabel     = "Certificado Teórico",
        -- Notificações gerais
        semIdentificacao   = "Sem identificação.",
        semPermissao       = "Sem permissão.",
        cartaSuspensa      = "A tua carta está suspensa por falta de pontos. Faz a recuperação de pontos.",
        semAtestado        = "Precisas de um atestado médico válido. Visita o médico da auto escola.",
        jaTemLaudo         = "Já tens o certificado teórico. Realiza o exame de condução.",
        saldoInsuficiente  = function(cat, val) return "Saldo insuficiente. A inscrição na categoria " .. cat .. " custa R$" .. val .. "." end,
        semPrerequisito    = function(pre, cat) return "Precisas da categoria " .. pre .. " para te inscreveres na " .. cat .. "." end,
        emCooldown         = function(dias) return "Em quarentena. Podes repetir o exame em " .. dias .. " dia(s)." end,
        -- Teórico
        aprovadoTeorico    = function(c, t) return "Aprovado no exame teórico! " .. c .. "/" .. t .. " certas. Prossegue para o exame prático." end,
        reprovadoTeorico   = function(c, t, e, m, dt) return "Reprovado no teórico! " .. c .. "/" .. t .. " certas (" .. e .. " erros, máx " .. m .. "). Podes repetir em " .. dt .. "." end,
        -- Prático
        veiculoDestruido   = "Veículo destruído. Exame cancelado!",
        saiuVeiculo        = "Saíste do veículo. Exame cancelado!",
        manobrasConcluidas = "Manobras concluídas! A iniciar fase de circulação...",
        manobrasTempo      = function(min) return "Fase de manobras! Estaciona o veículo na zona indicada. Tens " .. min .. " minutos." end,
        exameIniciado      = function(n, m) return "Fase de circulação iniciada! " .. n .. " checkpoints. Máx. " .. m .. " infração(ões)." end,
        infraVelocidade    = function(spd, lim, e, m) return string.format("Infração! %d km/h (limite %d km/h) | Erros: %d/%d", spd, lim, e, m) end,
        checkpoint         = function(a, t) return "Checkpoint " .. a .. "/" .. t .. " OK!" end,
        aprovadoPratico    = function(cat, val) return "Parabéns! Categoria " .. cat .. " aprovada. Válida até " .. val .. "." end,
        reprovadoPratico   = function(e, m, dt) return "Reprovado! " .. e .. " infração(ões). Máximo: " .. m .. ". Podes repetir em " .. dt .. "." end,
        exameRapido        = "Exame concluído rápido demais.",
        -- Atestado / Laudo
        laudoEmitido       = function(dt) return "Atestado médico emitido! Válido até " .. dt .. "." end,
        laudoJaValido      = function(dt) return "Já tens atestado válido até " .. dt .. "." end,
        -- Renovação
        catRenovada        = function(cat, dt) return "Categoria " .. cat .. " renovada até " .. dt .. "!" end,
        -- Polícia
        pontosRemovidos    = function(q, n) return "Foram perdoados " .. q .. " ponto(s) da carta. Total: " .. n .. "/20." end,
        cnhSuspensa        = "A tua carta de condução foi SUSPENSA por excesso de pontos!",
        categoriaRemovida  = function(cat) return "A tua categoria " .. cat .. " foi removida por autoridade policial." end,
        pontosAdicionados  = function(q, n) return "Recebeste " .. q .. " ponto(s) de infração. Total: " .. n .. "/20." end,
        -- Cooldown
        cooldownReset      = function(cat, nome) return "Cooldown da categoria " .. cat .. " de " .. nome .. " resetado." end,
        cooldownsReset     = function(nome) return "Todos os cooldowns de " .. nome .. " foram resetados." end,
        cooldownNotificado = function(cat) return "O teu tempo de espera para a categoria " .. cat .. " foi removido." end,
        cooldownsNotificado = "Todos os teus tempos de espera da auto escola foram removidos.",
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- Atalho global: L.xxx para o idioma configurado
L = lang[pais]
dict = {} -- compatibilidade com código antigo
