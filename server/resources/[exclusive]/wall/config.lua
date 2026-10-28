Config = {}

-- [[ CONFIGURAÇÕES GERAIS ]] --
Config.Permissao = "Admin" -- Permissão vRP necessária
Config.Comando = "wall"    -- Comando para ativar (ex: /wall)

-- [[ CONFIGURAÇÕES DE TECLAS ]] --
-- Consulte: https://docs.fivem.net/docs/game-references/controls/
Config.TeclaMenu = 289 -- Tecla F2 para abrir o painel visual rápido

-- [[ CONFIGURAÇÕES VISUAIS (ESP) ]] --
Config.DistanciaESP = 350.0  -- Distância máxima em metros para renderizar
Config.RenderizarVeiculos = true -- Renderizar ESP de veículos?

-- Estados iniciais ao ligar o wall
Config.Visual = {
    Box = true,       -- Começar com a caixa ao redor do player ligada?
    Lines = true,     -- Começar com as linhas (snaplines) ligadas?
    Info = true       -- Começar com as informações de texto ligadas?
}

-- [[ CORES (R, G, B, A) ]] --
Config.Cores = {
    Staff = {0, 255, 0, 200},       -- Verde (Admin)
    Player = {255, 255, 255, 200},  -- Branco (Player normal)
    Armado = {255, 0, 0, 200},      -- Vermelho (Player armado)
    Veiculo = {0, 100, 255, 200},   -- Azul (Veículos)
    Snapline = {255, 255, 255, 150} -- Cor da linha que liga você ao alvo
}

-- [[ CONFIGURAÇÕES DE LOGS (DISCORD) ]] --
Config.Webhook = "" -- COLOQUE SEU WEBHOOK AQUI
Config.BotName = "CBR CITY" -- Nome do Bot que aparecerá no Discord
Config.BotAvatar = "" -- URL da imagem do bot (opcional)

-- Tipos de Logs para ativar/desativar
Config.Logs = {
    AtivarWall = true,  -- Logar quando admin liga/desliga o wall
    Headshot = true     -- Logar quando detecta HS
}

-- [[ CONFIGURAÇÕES AVANÇADAS ]] --
-- Bone Index para detecção de HS (31086 = Cabeça)
Config.BoneHead = 31086