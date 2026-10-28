Config = {}
------------------------------------------
-- Geral
------------------------------------------
Config.RegisterCommand = "paineladm"                                -- COMANDO PARA ABRIR O PAINEL
Config.NumeroDeAdvParaBan = 3                                       -- NA TERCEIRA ADVERTÊNCIA O JOGADOR É BANIDO
Config.TempoDeBanMotivoAdv = 999                                    -- TEMPO DE BAN EM DIAS, CASO O JOGADOR TOME A QUANTIDADE DE ADVERTÊNCIAS CONFIGURADA ACIMA
------------------------------------------
-- Diretórios
------------------------------------------
Config.ImagensInventario = "nui://vrp/config/inventory/"            -- DIRETÓRIO DAS IMAGENS DOS ITENS
Config.ImagensGaragem = "nui://garages/web-side/vehicles/"                -- DIRETÓRIO DAS IMAGENS DOS VEÍCULOS
Config.ImagensSkins = "http://localhost/skins/"                     -- DIRETÓRIO DAS IMAGENS DAS SKINS
------------------------------------------
-- Permissões
------------------------------------------
Config.Perms = {
    OpenPainel = {"Admin",4},                                       -- PERMISSÃO E HIERARQUIA PARA ABRIR O PAINEL
    AddTeleport = {"Admin",3},                                      -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR ADICIONAR/REMOVER UM TELEPORT
    AddAdv = {"Admin",2},                                           -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR ADICIONAR/REMOVER UMA ADVERTÊNCIA
    AddKick = {"Admin",2},                                          -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR DAR KICK EM UM JOGADOR
    AddBan = {"Admin",2},                                           -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR DAR BAN EM UM JOGADOR
    AddItens = {"Admin",2},                                         -- PERMISSÃO E HIERARQUIA PARA ADICIONAR ITENS NO INVENTÁRIO DE UM JOGADOR
    CatchVehicles = {"Admin",3},                                    -- PERMISSÃO E HIERARQUIA PARA SPAWAR/ADICIONAR VEÍCULOS NA GARAGEM DE UM JOGADOR
    AddSkins = {"Admin",4},                                         -- PERMISSÃO E HIERARQUIA PARA SETAR SKIN JOGADORES
    ManageChests = {"Admin",2},                                     -- PERMISSÃO E HIERARQUIA PARA GERENCIAR OS BAÚS DAS ORGANIZAÇÕES
    ManageGroups = {"Admin",2},                                     -- PERMISSÃO E HIERARQUIA PARA GERENCIAR AS PERMISSÕES DOS JOGADORES
    ManageInventory = {"Admin",2},                                  -- PERMISSÃO E HIERARQUIA PARA GERENCIAR O INVENTÁRIO DOS JOGADORES
    ManageVehicles = {"Admin",2},                                   -- PERMISSÃO E HIERARQUIA PARA GERENCIAR VEÍCULOS DOS JOGADORES
    ManageHouses = {"Admin",2},                                     -- PERMISSÃO E HIERARQUIA PARA GERENCIAR PROPRIEDADES DOS JOGADORES
    ManageMoney = {"Admin",2},                                      -- PERMISSÃO E HIERARQUIA PARA GERENCIAR DINHEIRO DOS JOGADORES
    ManageCoins = {"Admin",2},                                      -- PERMISSÃO E HIERARQUIA PARA GERENCIAR COINS DOS JOGADORES
    ChangeNumber = {"Admin",3},                                     -- PERMISSÃO E HIERARQUIA PARA ALTERAR NÚMERO DOS JOGADORES
    ChangeName = {"Admin",3},                                       -- PERMISSÃO E HIERARQUIA PARA ALTERAR NOME DOS JOGADORES

    Policia = "Policia",                                            -- PERMISSÃO DE POLÍCIA DA BASE
    Staff = "Admin",                                                -- PERMISSÃO DE ADMIN DA BASE
    Bandits = {                                                     -- PERMISSÃO DAS ORGANIZAÇÕES ILEGAIS DA BASE
        -- Favelas desativadas em 25/10/2026: "Et","Barragem","Paleto","Pesqueiro",
        -- "Observatorio","Resort","Curvados","Lago","Helipa","Praia","Tunel","Porto",
        -- "Norte","Corrego"
    },
    VipRoles = {                                                    -- PERMISSÕES VIPS E SEUS NOMES DE EXIBIÇÃO
        { perm = "Ouro", name = "VIP Ouro" },
        { perm = "Prata", name = "VIP Prata" },
        { perm = "Bronze", name = "VIP Bronze" }
    }
}
------------------------------------------
-- Webhooks 
------------------------------------------
Config.Webhooks = {
    ScreenShots = "",                                               -- WEBHOOK RESPONSÁVEL PELAS LOGS DAS IMAGENS
    Kick = "",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DOS KICKS
    Ban = "",                                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DOS BANS
    Itens = "",                                                     -- WEBHOOK RESPONSÁVEL PELAS LOGS DOS ITENS
    God = "",                                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REVIVER
    Kill = "",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE KILL
    Vest = "",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE COLETE
    Tpto = "",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE TPTO
    Tptome = "",                                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE TPTOME
    Fix = "",                                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DE FIX
    Reset = "",                                                     -- WEBHOOK RESPONSÁVEL PELAS LOGS DE RESET
    Algema = "",                                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ALGEMAR E DESALGEMAR
    Ragdoll = "",                                                   -- WEBHOOK RESPONSÁVEL PELAS LOGS DE DERRUBAR
    Fire = "",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE FOGO
    HungerThirst = "",                                              -- WEBHOOK RESPONSÁVEL PELAS LOGS DE FOME E SEDE
    Spectate = "",                                                  -- WEBHOOK RESPONSÁVEL PELAS LOGS DE SPECTAR
    Freeze = "",                                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE CONGELAR E DESCONGELAR
    Message = "",                                                   -- WEBHOOK RESPONSÁVEL PELAS LOGS DE MENSAGEM
    Skin = "",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE SKIN
    UpgradeHierarchy = "",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE UPGRADE NA HIERARQUIA
    DowngradeHierarchy = "",                                        -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REBAIXAR HIERARQUIA
    Dismiss = "",                                                   -- WEBHOOK RESPONSÁVEL PELAS LOGS DE DEMISSÃO
    RemoveItemInventory = "",                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE ITEM NO INVENTÁRIO
    RemoveItemChestHouse = "",                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE ITEM NO BAÚ DE PROPRIEDADE
    RemoveVehicle = "",                                             -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE VEÍCULOS
    RemoveItemChestVehicle = "",                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE ITEM NO BAÚ DE VEÍCULOS
    ChangeWalletMore = "",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ADICIONAR DINHEIRO EM MÃOS
    ChangeWalletLess = "",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOVER DINHEIRO EM MÃOS
    ChangeBankMore = "",                                            -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ADICIONAR DINHEIRO NO BANCO
    ChangeBankLess = "",                                            -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOVER DINHEIRO NO BANCO
    ChangeNumber = "",                                              -- WEBHOOK RESPONSÁVEL PELAS LOGS DE TROCAR DE NÚMERO
    ChangeName = "",                                                -- WEBHOOK RESPONSÁVEL PELAS LOGS DE NOME
    SetNewPermission = "",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ADICIONAR PERMISSÃO
    RemovePermission = "",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOVER PERMISSÃO
    DiscordImageFooter = "",                                        -- LINK DA LOGO DO SEU SERVIDOR
    DiscordImageThumbanil = ""                                      -- LINK DA LOGO DO SEU SERVIDOR
}
------------------------------------------
-- Skins
------------------------------------------
-- RESOLUÇÃO RECOMENDADA PARA AS IMAGENS DAS SKINS: 1100 x 900
-- Caso for mp_m_freemode_01 ou mp_f_freemode_01, mantém o Sex como "Default", caso for outros peds que não são defaults, coloca "M" para Masculino e "F" para Feminino
Config.Skins = {
    [1] = { Nome = "Default M", Spawn = "mp_m_freemode_01", Sex = "Default" },
    [2] = { Nome = "Default F", Spawn = "mp_f_freemode_01" , Sex = "Default" }
}

return Config