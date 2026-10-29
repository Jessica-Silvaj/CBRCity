-----------------------------------------------------------------------------------------------------------------------------------------
-- MECÂNICO DE NPC
-- Só funciona sem mecânicos (Bennys/Redline) em serviço. O veículo atendido é o que o jogador
-- está dentro ou o mais próximo dele no momento do /mec.
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {
	Command = "mec",

	-- Segundos entre o /mec e o guincho aparecer (10 minutos)
	Delay = 600,
	-- Segundos que o jogador precisa esperar para usar o /mec de novo (30 minutos)
	Cooldown = 1800,
	-- Vida do motor após o reparo, em porcentagem (1000 = motor perfeito no GTA)
	EnginePercent = 50,

	-- Grupo cujos membros em serviço bloqueiam o /mec
	MechanicGroup = "Mecanicas",
	-- Distância máxima (metros) do veículo ao usar o comando
	VehicleDistance = 10.0,
	-- Distância (metros) em que o guincho aparece, sempre numa rua
	SpawnDistance = 100,
	-- Valor cobrado do banco ao chamar (0 = gratuito)
	Price = 0,

	-- Tempo máximo (segundos) do guincho dirigindo; depois disso ele é posicionado ao lado do veículo
	DriveTimeout = 90,
	-- Tempo (segundos) do mecânico trabalhando no motor
	RepairTime = 15,
	-- Segundos até o guincho ser apagado depois de ir embora
	DespawnTime = 30,

	Vehicle = "slamtruck",
	Mechanic = "ig_benny",
	DriveSpeed = 20.0,

	Blip = { Sprite = 68, Color = 47, Scale = 0.8, Name = "Mecânico" }
}
