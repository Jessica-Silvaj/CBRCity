-----------------------------------------------------------------------------------------------------------------------------------------
-- VAPE
-- Usar o item "vape" no inventário segura/guarda o vape. Com ele na mão: segure [E] para puxar, [G] para guardar.
-- Usar um líquido recarrega o tanque com aquele sabor. O tanque fica salvo por personagem.
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {
	Item = "vape",

	-- Capacidade do tanque e gasto por puxada (ml)
	Capacity = 5.0,
	PerPuff = 0.1,
	-- Cada frasco de líquido recarrega isto (ml); o que passar da capacidade é perdido
	BottleSize = 5.0,

	-- Segundos mínimos entre puxadas
	PuffCooldown = 4,
	-- Estresse reduzido por puxada
	Stress = 2,
	EffectDuration = 12,
	-- Distância (metros) em que outros jogadores veem o vapor
	SyncDistance = 60.0,

	Keys = { Puff = 38, Store = 47 }, -- E, G

	Prop = {
		Model = "prop_astra_vape_01",
		Bone = 57005,
		Offset = vec3(0.095318,0.018300,-0.029924),
		Rotation = vec3(-69.417207,-19.049727,-31.891782)
	},

	-- Sabores: item do inventário => nome e cor do vapor (RGB 0-255)
	Flavors = {
		-- Paleta do projeto: verde #2E8B57 com variações suaves por sabor.
		["liquido_neutro"] = { Name = "Neutro", Effect = "stress", Color = { 220, 255, 232 } },
		["liquido_morango"] = { Name = "Morango", Effect = "stress", Color = { 112, 198, 126 } },
		["liquido_menta"] = { Name = "Menta", Effect = "stamina", Color = { 111, 224, 164 } },
		["liquido_mirtilo"] = { Name = "Mirtilo", Effect = "focus", Color = { 92, 177, 147 } },
		["liquido_uva"] = { Name = "Uva", Effect = "speed", Color = { 79, 151, 113 } }
	}
}
