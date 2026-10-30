-----------------------------------------------------------------------------------------------------------------------------------------
-- VAPE
-- Usar um item de Config.Vapes (inventário ou hotbar 1-4) dá uma puxada completa; com o tanque vazio abre o painel de recarga.
-- Usar um líquido recarrega o tanque com aquele sabor. O tanque fica salvo por personagem (compartilhado entre os vapes).
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {
	-- Capacidade do tanque e gasto por puxada (ml)
	Capacity = 5.0,
	PerPuff = 0.1,
	-- Cada frasco de líquido recarrega isto (ml); o que passar da capacidade é perdido
	BottleSize = 5.0,
	-- Avisa quando o tanque fica abaixo desta fração da capacidade
	LowTank = 0.2,

	-- Tamanho da puxada ao usar o vape (0.0 = curta, 1.0 = longa): define a nuvem e o gasto (0.5x a 1.5x PerPuff)
	Intensity = 0.6,
	-- Segundos mínimos entre puxadas
	PuffCooldown = 2,

	-- Pulmão (0-100): cada puxada enche, recupera sozinho com o tempo. Puxar com ele cheio faz tossir e tira vida
	Lung = {
		PerPuff = 22,       -- quanto cada puxada enche
		Recover = 1.5,      -- quanto recupera por segundo
		Warning = 70,       -- a partir daqui avisa que a garganta está irritada
		Damage = 6,         -- vida perdida em cada crise de tosse
		MinHealth = 120     -- a tosse nunca deixa a vida abaixo disso (o vrp derruba em 100)
	},
	-- Estresse reduzido por puxada (qualquer sabor)
	Stress = 2,

	-- Efeitos dos sabores (campo Effect em Flavors). Duration em segundos; puxar de novo renova o tempo.
	-- Visuais opcionais (nomes do próprio GTA): Timecycle + Strength (filtro de tela), Postfx (efeito de tela),
	-- Shake + ShakeAmp (câmera balançando), Walk (jeito de andar)
	Effects = {
		["stress"] = {
			Label = "Relaxante", Description = "Tira o triplo de estresse e deixa leve", Duration = 15,
			Timecycle = "drug_wobbly", Strength = 0.35, Shake = "DRUNK_SHAKE", ShakeAmp = 0.3
		},
		["stamina"] = {
			Label = "Fôlego", Description = "Stamina infinita", Duration = 20,
			Postfx = "RaceTurbo"
		},
		["focus"] = {
			Label = "Foco", Description = "Visão focada e nítida", Duration = 20,
			Postfx = "FocusIn"
		},
		["speed"] = {
			Label = "Energia", Description = "Corre 10% mais rápido", Duration = 20,
			Timecycle = "drug_drive_blend01", Strength = 0.4, Shake = "HAND_SHAKE", ShakeAmp = 0.4
		},
		["trip"] = {
			Label = "Viagem", Description = "Tontura, visão alterada e andar mole", Duration = 25,
			Timecycle = "drug_flying_base", Strength = 0.8, Shake = "DRUNK_SHAKE", ShakeAmp = 1.2, Walk = "move_m@drunk@slightlydrunk"
		}
	},
	-- Distância (metros) em que outros jogadores veem o vapor
	SyncDistance = 60.0,

	-- Vapes: item do inventário => prop do próprio GTA na mão direita (mesmas posições dos emotes "vape" e "vape2")
	Vapes = {
		["vape"] = {
			Name = "Vape",
			Model = "ba_prop_battle_vape_01",
			Bone = 28422,
			Offset = vec3(-0.0290,0.0070,-0.0050),
			Rotation = vec3(91.0,270.0,-360.0)
		},
		["vape_pro"] = {
			Name = "Vape Pro",
			Model = "xm3_prop_xm3_vape_01a",
			Bone = 28422,
			Offset = vec3(-0.02,-0.02,0.02),
			Rotation = vec3(58.0,110.0,10.0)
		}
	},

	-- Frasco segurado na mão esquerda durante a recarga
	Refill = {
		Duration = 3000,
		Model = "prop_cs_script_bottle_01",
		Bone = 18905,
		Offset = vec3(0.12,0.03,0.03),
		Rotation = vec3(-90.0,0.0,0.0)
	},

	-- Sabores: item do inventário => nome e cor do vapor (RGB 0-255), uma cor bem distinta por sabor
	Flavors = {
		["liquido_neutro"] = { Name = "Neutro", Effect = "stress", Color = { 235, 235, 235 } },
		["liquido_morango"] = { Name = "Morango", Effect = "stress", Color = { 255, 60, 90 } },
		["liquido_menta"] = { Name = "Menta", Effect = "stamina", Color = { 40, 230, 160 } },
		["liquido_mirtilo"] = { Name = "Mirtilo", Effect = "focus", Color = { 50, 110, 255 } },
		["liquido_uva"] = { Name = "Uva", Effect = "speed", Color = { 160, 50, 230 } },
		["liquido_manga"] = { Name = "Manga", Effect = "stress", Color = { 255, 150, 30 } },
		["liquido_limao"] = { Name = "Limão", Effect = "stamina", Color = { 230, 240, 40 } },
		["liquido_chiclete"] = { Name = "Chiclete", Effect = "trip", Color = { 255, 110, 220 } }
	}
}
