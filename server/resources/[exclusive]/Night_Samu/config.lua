-----------------------------------------------------------------------------------------------------------------------------------------
-- SAMU DE NPC
-- O comando só funciona depois que o jogador passou o tempo de desmaio do survival (5 minutos),
-- ou seja, quando LocalPlayer.state.Death = true.
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {
	Command = "samu",

	-- Segundos entre o /samu e a ambulância aparecer
	Delay = 30,
	-- Distância (metros) em que a ambulância aparece, sempre numa rua
	SpawnDistance = 100,
	-- Vida após a reanimação, em porcentagem (100 = morto, 200 = vida cheia no GTA)
	HealthPercent = 15,

	-- Valor cobrado do banco ao chamar (0 = gratuito). Sem saldo, o atendimento é feito mesmo assim.
	Price = 0,
	-- Bloqueia o /samu se houver paramédicos em serviço (0 = nunca bloqueia)
	BlockIfParamedics = 0,
	ParamedicGroup = "Paramedico",
	-- Segundos que o jogador precisa esperar para usar o /samu de novo
	Cooldown = 600,

	-- Tempo máximo (segundos) da ambulância dirigindo; depois disso ela é posicionada ao lado do jogador
	DriveTimeout = 90,
	-- Tempo (segundos) de massagem cardíaca antes de reanimar
	ReviveTime = 10,
	-- Segundos até a ambulância ser apagada depois de ir embora
	DespawnTime = 30,

	Vehicle = "ambulance",
	Driver = "s_m_m_paramedic_01",
	Medic = "s_m_m_paramedic_01",
	DriveSpeed = 22.0,

	Blip = { Sprite = 61, Color = 1, Scale = 0.8, Name = "SAMU" }
}
