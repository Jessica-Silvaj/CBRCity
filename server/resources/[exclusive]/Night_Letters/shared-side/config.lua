Config = {
    -- Comandos para abrir interfaces
    Commands = {
        lastLetter = "correio",
        fullPanel = "cartas"
    },

    -- Tema principal da interface
    interfaceColor = "255, 99, 171",

    -- Se true, desabilita a limpeza automática do banco de dados. Mantendo os dados permanentes. <Não recomendado>
    disableAutoCleaner = false,

    -- Dia em que todas as cartas são deletadas, para limpeza.
    -- (modelo semanal: 1 > domingo)
    letterResetDay = 2,

    -- Tempo <minutos> máximo que uma pessoa pode ler a última carta enviada.
    lastLetterTimeout = 1, 

    -- Preço pra enviar uma carta romântica à alguém (false<boolean> se quiser desabilitar)
    letterPrice = 150000,

    -- Mostra a HUD da carta para todos os jogadores quando alguém envia
    showLetterOverlay = true,

    -- Sons do Sistema
    Sounds = {
        --> Desativado
        -- Send = {
        --     Sound = "vaidanamoro",
        --     Volume = 0.1,
        --     Everyone = true
        -- }
    },

    -- Tamanho máximo de uma mensagem
    maxMessageSize = 45000,
}