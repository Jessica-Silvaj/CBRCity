Config = {}

Config.Command = "hit"

-- Tempo máximo entre abates para continuar a sequência do Valorant.
Config.TimeAceValorant = 30000

-- Evita que o mesmo evento de dano, que pode chegar mais de uma vez no mesmo
-- disparo, reproduza o som ou confirme o mesmo abate repetidamente.
Config.HitCooldown = 80
Config.KillDeduplicationTime = 15000

-- Tempo entre tentativas de preparar a tabela caso o banco ainda esteja
-- iniciando quando o recurso for carregado.
Config.DatabaseRetryTime = 5000

Config.DefaultSettings = {
    soundId = 0,
    visualState = 0,
    hitFeedState = false,
    bodySound = 0,
    volume = 0.5,
    color = "#2E8B57" -- cor principal do projeto
}
