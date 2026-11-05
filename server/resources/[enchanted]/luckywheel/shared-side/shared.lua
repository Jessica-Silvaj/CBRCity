-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Wheel = vec4(1111.05,229.78,-49.15,0.0)
Podium = {
	Model = "vigero2", -- Modelo do veículo
	Coords = vec4(1100.0,220.0,-50.95,0.0), -- Coordenadas de spawn (X, Y, Z, Heading)
	PrimaryColor = { 0, 0, 0 }, -- Cor Primária em RGB { R, G, B }
	SecondaryColor = { 0, 0, 0 }, -- Cor Secundária em RGB { R, G, B }
	Rotate = true -- Girar o veículo e o pódio suavemente
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REWARDS
-----------------------------------------------------------------------------------------------------------------------------------------
Rewards = {
	{ Item = "casinovehicle", Chance = 1, Amount = 1 },
	{ Item = "dollar", Chance = 15, Amount = 20000 },
	{ Item = "chips", Chance = 15, Amount = 2500 },
	{ Item = "bandage", Chance = 18, Amount = 5 },
	{ Item = "dollar", Chance = 12, Amount = 50000 },
	{ Item = "energetic", Chance = 18, Amount = 5 },
	{ Item = "luckywheelpass", Chance = 5, Amount = 1 },
	{ Item = "chips", Chance = 12, Amount = 5000 },
	{ Item = "repairkit01", Chance = 12, Amount = 2 },
	{ Item = "dollar", Chance = 8, Amount = 75000 },
	{ Item = "lockpick", Chance = 12, Amount = 3 },
	{ Item = "chips", Chance = 8, Amount = 10000 },
	{ Item = "medkit", Chance = 10, Amount = 3 },
	{ Item = "dollar", Chance = 14, Amount = 30000 },
	{ Item = "backpackp", Chance = 6, Amount = 1 },
	{ Item = "gemstone", Chance = 4, Amount = 2 },
	{ Item = "chips", Chance = 6, Amount = 20000 },
	{ Item = "luckywheelpass", Chance = 3, Amount = 2 },
	{ Item = "dollar", Chance = 4, Amount = 100000 },
	{ Item = "chips", Chance = 10, Amount = 7500 }
}