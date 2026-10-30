-----------------------------------------------------------------------------------------------------------------------------------------
-- VAPE
-- Usar um item de Config.Vapes (inventário ou hotbar 1-4) dá uma puxada completa; com o tanque vazio abre o painel de recarga.
-- Usar um líquido recarrega o tanque com aquele sabor. Cada vape tem o próprio tanque, salvo por personagem.
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {
	-- Capacidade padrão do tanque (cada vape pode ter a sua em Vapes) e gasto base por puxada (ml)
	Capacity = 5.0,
	PerPuff = 0.1,
	-- Cada frasco tem isto (ml). O que não couber no tanque fica no frasco aberto para a próxima recarga
	BottleSize = 5.0,
	-- true: qualquer frasco completa qualquer tanque e o líquido novo define o sabor/cor do tanque inteiro.
	-- false: um sabor diferente só entra com o tanque vazio. A quantidade é sempre conservada
	AllowMix = true,
	-- Avisa (notificação + 3 bipes, uma vez por recarga) quando o tanque fica abaixo desta fração da capacidade
	LowTank = 0.15,
	-- Volume do som da puxada (0.0 a 1.0), só quem puxa ouve
	PuffVolume = 0.35,

	-- Tamanho da puxada ao usar o vape (0.0 = curta, 1.0 = longa): define a nuvem e o gasto (0.5x a 1.5x PerPuff)
	Intensity = 0.6,
	-- Segurando a tecla da hotbar a puxada dura até isto (segundos); quanto mais longa, mais vapor, gasto e pulmão
	MaxHold = 6,
	-- Segundos mínimos entre puxadas
	PuffCooldown = 2,
	-- Mostra o card do vape (sabor, tanque e efeito) no canto da tela
	Card = false,

	-- Pulmão (0-100): cada puxada enche, recupera sozinho com o tempo. Puxar com ele cheio faz tossir e tira vida
	Lung = {
		Enabled = true,     -- false desliga o pulmão (círculo na HUD e tosse)
		PerPuff = 22,       -- quanto cada puxada enche
		Recover = 1.5,      -- quanto recupera por segundo
		Warning = 70,       -- a partir daqui avisa que a garganta está irritada
		Damage = 6,         -- vida perdida em cada crise de tosse
		MinHealth = 120     -- a tosse nunca deixa a vida abaixo disso (o vrp derruba em 100)
	},
	-- Estresse reduzido por puxada (qualquer sabor)
	Stress = 2,

	-- Avisa (notificação curta) qual efeito começou e por quanto tempo
	EffectNotify = true,
	-- Tempo máximo (ms) da mão subindo até a boca antes de a puxada começar
	RaiseTimeout = 3500,

	-- Efeitos dos sabores (campo Effect em Flavors). Duration em segundos; puxar o mesmo sabor renova o tempo.
	-- Visuais (nomes do próprio GTA): Timecycle + Strength (filtro de tela), Postfx (efeito de tela),
	-- Shake + ShakeAmp (câmera balançando), Walk (jeito de andar).
	-- Jogo: Sprint (corrida, máx 1.49), Swim (nado, máx 1.49), Stamina (fôlego infinito), Heal (vida a cada 2 s),
	-- Thirst / Hunger (sede / fome por puxada), Stress (estresse extra tirado por puxada)
	Effects = {
		["stress"] = {
			Label = "Relaxante", Description = "Tira o triplo de estresse e deixa leve", Duration = 15,
			Timecycle = "drug_wobbly", Strength = 0.5, Shake = "DRUNK_SHAKE", ShakeAmp = 0.5, Stress = 4
		},
		["stamina"] = {
			Label = "Fôlego", Description = "Stamina infinita", Duration = 20,
			Postfx = "RaceTurbo", Stamina = true
		},
		["focus"] = {
			Label = "Foco", Description = "Visão focada e nítida", Duration = 20,
			Postfx = "FocusIn", Timecycle = "NG_filmic19", Strength = 0.5
		},
		["speed"] = {
			Label = "Energia", Description = "Corre 15% mais rápido", Duration = 20,
			Timecycle = "drug_drive_blend01", Strength = 0.55, Shake = "HAND_SHAKE", ShakeAmp = 0.5, Sprint = 1.15
		},
		["heal"] = {
			Label = "Doce", Description = "Recupera vida aos poucos", Duration = 20,
			Postfx = "SuccessFranklin", Heal = 4
		},
		["fresh"] = {
			Label = "Refrescante", Description = "Mata a sede a cada puxada", Duration = 15,
			Timecycle = "MP_Arena_theme_atlantis", Strength = 0.5, Thirst = 6
		},
		["breath"] = {
			Label = "Gelado", Description = "Pulmão se recupera 3x mais rápido", Duration = 30,
			Timecycle = "glasses_blue", Strength = 0.45
		},
		["tropical"] = {
			Label = "Tropical", Description = "Mata a fome a cada puxada", Duration = 15,
			Timecycle = "MP_Arena_theme_evening", Strength = 0.5, Hunger = 6
		},
		["swim"] = {
			Label = "Nadador", Description = "Nada 30% mais rápido", Duration = 30,
			Timecycle = "underwater_deep", Strength = 0.3, Swim = 1.30
		},
		["serene"] = {
			Label = "Sereno", Description = "Tira estresse aos poucos", Duration = 25,
			Postfx = "ChopVision"
		},
		["awake"] = {
			Label = "Desperto", Description = "Pulmão enche pela metade", Duration = 30,
			Timecycle = "NG_filmic10", Strength = 0.5
		},
		["trip"] = {
			Label = "Viagem", Description = "Tontura, visão alterada e andar mole", Duration = 25,
			Timecycle = "drug_flying_base", Strength = 0.8, Shake = "DRUNK_SHAKE", ShakeAmp = 1.2, Walk = "move_m@drunk@slightlydrunk"
		}
	},
	-- Distância (metros) em que outros jogadores veem o vapor
	SyncDistance = 60.0,

	-- Vapes: item do inventário => prop na mão direita.
	-- Capacity = tanque (ml), Consumption = gasto por puxada (x), Cloud = tamanho da nuvem (x), Style = visual na estação de recarga
	Vapes = {
		["vape"] = {
			Name = "Vape",
			Capacity = 5.0, Consumption = 1.0, Cloud = 1.0, Style = "classic",
			Model = "ba_prop_battle_vape_01",
			Bone = 28422,
			Offset = vec3(-0.0290,0.0070,-0.0050),
			Rotation = vec3(91.0,270.0,-360.0)
		},
		["vape_pro"] = {
			Name = "Vape Pro",
			Capacity = 4.0, Consumption = 1.3, Cloud = 1.4, Style = "pro",
			Model = "xm3_prop_xm3_vape_01a",
			Bone = 28422,
			Offset = vec3(-0.02,-0.02,0.02),
			Rotation = vec3(58.0,110.0,10.0)
		},
		["vape_volt"] = {
			Name = "Vape Volt",
			Capacity = 3.0, Consumption = 1.6, Cloud = 0.65, Style = "volt",
			Model = "prop_oxlyn_vape_volt",
			Bone = 57005,
			Offset = vec3(0.0950,0.0177,-0.0280),
			Rotation = vec3(-69.42,-19.05,-31.89),
			Order = 2
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
		["liquido_morango"] = { Name = "Morango", Effect = "heal", Color = { 255, 60, 90 } },
		["liquido_menta"] = { Name = "Menta", Effect = "breath", Color = { 40, 230, 160 } },
		["liquido_mirtilo"] = { Name = "Mirtilo", Effect = "focus", Color = { 50, 110, 255 } },
		["liquido_uva"] = { Name = "Uva", Effect = "speed", Color = { 160, 50, 230 } },
		["liquido_manga"] = { Name = "Manga", Effect = "fresh", Color = { 255, 150, 30 } },
		["liquido_limao"] = { Name = "Limão", Effect = "stamina", Color = { 230, 240, 40 } },
		["liquido_chiclete"] = { Name = "Chiclete", Effect = "trip", Color = { 255, 110, 220 } },
		["liquido_coco"] = { Name = "Coco", Effect = "tropical", Color = { 250, 245, 225 } },
		["liquido_melancia"] = { Name = "Melancia", Effect = "swim", Color = { 255, 80, 70 } },
		["liquido_maracuja"] = { Name = "Maracujá", Effect = "serene", Color = { 255, 205, 0 } },
		["liquido_cafe"] = { Name = "Café", Effect = "awake", Color = { 120, 70, 35 } }
	}
}
