-----------------------------------------------------------------------------------------------------------------------------------------
-- VEICULOS ADICIONADOS (carrosteste e AnjosVehicles)
-- Este arquivo é lido pelo Vehicle.lua e junta estes carros à lista da base.
--
-- COMO CADASTRAR:
--   ["modelo"] = {          -- nome do modelo (spawn), em minúsculo
--     Name = "Nome no jogo",
--     Weight = 40,          -- capacidade do porta-malas (kg)
--     Price = 500000,       -- preço na concessionária
--     Mode = "Cars",        -- "Cars" (carro à venda), "Bikes" (moto à venda), "Rental" (aluguel por gemas), nil (não vende: viaturas)
--     Gemstone = 0,         -- preço em gemas (só para "Rental")
--     Class = "Importados"  -- categoria da concessionária: Importados, Esportivos, SUVs, Motocicletas, Compactos, Muscles, Emergência, Helicópteros...
--   },
-----------------------------------------------------------------------------------------------------------------------------------------
return {
	-- CARROSTESTE ([addons]/[Veiculos]/carrosteste) - precos provisorios
	["mclaren765"] = {
		Name = "McLaren 765LT",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13000,
		Class = "Importados"
	},
	["mbbs20"] = {
		Name = "Mercedes-AMG GT Black Series",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13000,
		Class = "Importados"
	},
	["ariant"] = {
		Name = "Karin Ariant",
		Weight = 50,
		Price = 0,
		Mode = "Cars",
		Gemstone = 10000,
		Class = "Importados"
	},
	["rs6avant16t"] = {
		Name = "Audi RS6 Avant",
		Weight = 60,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["asteropers"] = {
		Name = "Karin Asterope RS",
		Weight = 50,
		Price = 0,
		Mode = "Cars",
		Gemstone = 10000,
		Class = "Importados"
	},
	["bati901"] = {
		Name = "Pegassi Bati 901",
		Weight = 20,
		Price = 0,
		Mode = "Bikes",
		Gemstone = 8000,
		Class = "Importados"
	},
	["bmistralw16"] = {
		Name = "Bugatti Mistral",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13500,
		Class = "Importados"
	},
	["23trx16t"] = {
		Name = "Ram TRX 2023",
		Weight = 80,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["dubsta22"] = {
		Name = "Benefactor Dubsta 2022",
		Weight = 80,
		Price = 0,
		Mode = "Cars",
		Gemstone = 10000,
		Class = "Importados"
	},
	["elegyx"] = {
		Name = "Annis Elegy X",
		Weight = 50,
		Price = 0,
		Mode = "Cars",
		Gemstone = 10000,
		Class = "Importados"
	},
	["gemera2021"] = {
		Name = "Koenigsegg Gemera",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13000,
		Class = "Importados"
	},
	["laferrari"] = {
		Name = "Ferrari LaFerrari",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13000,
		Class = "Importados"
	},
	["g6516t"] = {
		Name = "Mercedes-AMG G65",
		Weight = 80,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["nznismo24"] = {
		Name = "Nissan GT-R Nismo 2024",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 14000,
		Class = "Importados"
	},
	["pgt32216t"] = {
		Name = "Porsche 911 GT3 2022",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["por718gt4"] = {
		Name = "Porsche 718 Cayman GT4",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 12000,
		Class = "Importados"
	},
	["purosangue"] = {
		Name = "Ferrari Purosangue",
		Weight = 60,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["sf90xx"] = {
		Name = "Ferrari SF90 XX",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13000,
		Class = "Importados"
	},
	["gsttac1"] = {
		Name = "Chevrolet Tahoe",
		Weight = 80,
		Price = 0,
		Mode = "Cars",
		Gemstone = 14000,
		Class = "Importados"
	},

	-- ANJOSVEHICLES ([addons]/[Veiculos]/AnjosVehicles) - precos provisorios
	["180sx"] = {
		Name = "Nissan 180SX",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 15000,
		Class = "Importados"
	},
	["argento"] = {
		Name = "Obey Argento",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 10000,
		Class = "Importados"
	},
	["cara"] = {
		Name = "Vapid Caracara",
		Weight = 70,
		Price = 0,
		Mode = "Cars",
		Gemstone = 1000,
		Class = "Importados"
	},
	["coquette4c"] = {
		Name = "Invetero Coquette C4",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 15000,
		Class = "Importados"
	},
	["cullinan"] = {
		Name = "Rolls-Royce Cullinan",
		Weight = 60,
		Price = 0,
		Mode = "Cars",
		Gemstone = 30000,
		Class = "Importados"
	},
	["darkfate"] = {
		Name = "V-Rod Dark Fate",
		Weight = 20,
		Price = 0,
		Mode = "Bikes",
		Gemstone = 7500,
		Class = "Importados"
	},
	["eclipse"] = {
		Name = "Mitsubishi Eclipse",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 14000,
		Class = "Importados"
	},
	["elegyrh7"] = {
		Name = "Annis Elegy RH7",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 15000,
		Class = "Importados"
	},
	["gtr17"] = {
		Name = "Nissan GT-R 2017",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["harley1"] = {
		Name = "Harley-Davidson",
		Weight = 20,
		Price = 0,
		Mode = "Bikes",
		Gemstone = 8000,
		Class = "Importados"
	},
	["harleydavidsonfx"] = {
		Name = "Harley-Davidson FX",
		Weight = 20,
		Price = 0,
		Mode = "Bikes",
		Gemstone = 7500,
		Class = "Importados"
	},
	["harleydavidsonrg"] = {
		Name = "Harley-Davidson Road Glide",
		Weight = 20,
		Price = 0,
		Mode = "Bikes",
		Gemstone = 7500,
		Class = "Importados"
	},
	["hycrh7"] = {
		Name = "Annis RH7",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 14000,
		Class = "Importados"
	},
	["hycsun"] = {
		Name = "Maibatsu Sun",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 14000,
		Class = "Importados"
	},
	["i7m"] = {
		Name = "BMW i7 M",
		Weight = 50,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13000,
		Class = "Importados"
	},
	["is300"] = {
		Name = "Lexus IS300",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 12000,
		Class = "Importados"
	},
	["lfz"] = {
		Name = "Lexus LFA",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["mini20"] = {
		Name = "Mini Cooper",
		Weight = 30,
		Price = 0,
		Mode = "Cars",
		Gemstone = 13000,
		Class = "Importados"
	},
	["na6"] = {
		Name = "Mazda MX-5 NA",
		Weight = 30,
		Price = 0,
		Mode = "Cars",
		Gemstone = 12000,
		Class = "Importados"
	},
	["r1250"] = {
		Name = "BMW R1250",
		Weight = 20,
		Price = 0,
		Mode = "Bikes",
		Gemstone = 8000,
		Class = "Importados"
	},
	["r342"] = {
		Name = "Nissan Skyline R34",
		Weight = 40,
		Price = 800000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Importados"
	},
	["rimac"] = {
		Name = "Rimac Nevera",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["rx7bandido"] = {
		Name = "Mazda RX-7 Bandido",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["swordbreaker"] = {
		Name = "V-Rod Swordbreaker",
		Weight = 20,
		Price = 0,
		Mode = "Bikes",
		Gemstone = 7500,
		Class = "Importados"
	},
	["titanh"] = {
		Name = "Nissan Titan",
		Weight = 70,
		Price = 0,
		Mode = "Cars",
		Gemstone = 12000,
		Class = "Importados"
	},
	["toysupmk4"] = {
		Name = "Toyota Supra MK4",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 15000,
		Class = "Importados"
	},
	["urus19nov"] = {
		Name = "Lamborghini Urus Novitec",
		Weight = 60,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["x6mf96"] = {
		Name = "BMW X6 M",
		Weight = 60,
		Price = 0,
		Mode = "Cars",
		Gemstone = 30000,
		Class = "Importados"
	},
	["x7m60i"] = {
		Name = "BMW X7 M60i",
		Weight = 70,
		Price = 0,
		Mode = "Cars",
		Gemstone = 30000,
		Class = "Importados"
	},
	["yang"] = {
		Name = "Yang",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["zeekr001"] = {
		Name = "Zeekr 001",
		Weight = 50,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["zlay_e36"] = {
		Name = "BMW M3 E36",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["zlay_rx8zs"] = {
		Name = "Mazda RX-8",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["zupra"] = {
		Name = "Toyota Supra A90",
		Weight = 40,
		Price = 0,
		Mode = "Cars",
		Gemstone = 100000,
		Class = "Importados"
	},
	["22m5sal"] = {
		Name = "BMW M5 (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["amarokchoque"] = {
		Name = "VW Amarok Choque",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["atpolice"] = {
		Name = "Honda Africa Twin (Polícia)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["bravadopol"] = {
		Name = "Bravado (Polícia)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["caveiraobope"] = {
		Name = "Caveirão BOPE",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["challenger"] = {
		Name = "Dodge Challenger (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["corvette"] = {
		Name = "Corvette (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["duranpol"] = {
		Name = "Duran (Polícia)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["fordmustanggt"] = {
		Name = "Ford Mustang GT (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["hp_x6"] = {
		Name = "BMW X6 (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["lspdbri2"] = {
		Name = "Declasse LSPD 2",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["lspdbri"] = {
		Name = "Declasse LSPD",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["lspdcara2"] = {
		Name = "Caracara LSPD 2",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["lspdcara"] = {
		Name = "Caracara LSPD",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["lssdbri"] = {
		Name = "Declasse Sheriff",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["newsfrog"] = {
		Name = "Frogger da Imprensa",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Helicópteros"
	},
	["nkcoquette"] = {
		Name = "Coquette (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["pmsupervolito2"] = {
		Name = "Supervolito PM 2",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Helicópteros"
	},
	["pmsupervolito"] = {
		Name = "Supervolito PM",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Helicópteros"
	},
	["polcoq4"] = {
		Name = "Coquette C4 (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["polmustang"] = {
		Name = "Mustang (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["polswatstoc"] = {
		Name = "Stockade SWAT",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["rx7policia"] = {
		Name = "Mazda RX-7 (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["rx7veilside"] = {
		Name = "Mazda RX-7 Veilside (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["sahpbri"] = {
		Name = "Declasse Rodoviária",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["sheriffswatstoc"] = {
		Name = "Stockade Sheriff SWAT",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["stockade4"] = {
		Name = "Brute Stockade 4",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["vtrlexuslfa"] = {
		Name = "Lexus LFA (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["vtrtiger"] = {
		Name = "Triumph Tiger 900 (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	["wrpanamera"] = {
		Name = "Porsche Panamera (Viatura)",
		Weight = 0,
		Price = 100,
		Mode = nil,
		Gemstone = 0,
		Class = "Emergência"
	},
	-- Veiculos que ja existiam no servidor (mantidos)
	["buffalosxt"] = {
		Name = "Bravado Buffalo STX",
		Weight = 50,
		Price = 250000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Muscles"
	},
	["elegyrh72"] = {
		Name = "Annis Elegy RH7 2",
		Weight = 40,
		Price = 300000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Esportivos"
	},
	["fascalamo2"] = {
		Name = "Declasse Alamo",
		Weight = 60,
		Price = 250000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "SUVs"
	},
	["hycrh72"] = {
		Name = "Annis RH7 2",
		Weight = 40,
		Price = 300000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Esportivos"
	},
	["i7x"] = {
		Name = "BMW i7",
		Weight = 50,
		Price = 1400000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Importados"
	},
	["rev"] = {
		Name = "Lamborghini Revuelto",
		Weight = 40,
		Price = 3000000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Importados"
	},
	["silvia2"] = {
		Name = "Nissan Silvia 2",
		Weight = 40,
		Price = 300000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Importados"
	},
	["silvia"] = {
		Name = "Nissan Silvia",
		Weight = 40,
		Price = 300000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Importados"
	},
	["skyline"] = {
		Name = "Nissan Skyline",
		Weight = 40,
		Price = 700000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Importados"
	},
	["venatusc"] = {
		Name = "Lamborghini Urus Venatus",
		Weight = 60,
		Price = 2000000,
		Mode = "Cars",
		Gemstone = 0,
		Class = "Importados"
	},
}
