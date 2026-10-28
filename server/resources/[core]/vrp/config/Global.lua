-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
Works = {
	Taxi = "Taxista",
	Towed = "Rebocador",
	Dismantle = "Desmanche",
	Grime = "Entregador",
	Transporter = "Transportador",
	Lumberman = "Lenhador",
	Milkman = "Leiteiro",
	Trucker = "Caminhoneiro",
	Fisherman = "Pescador",
	Driver = "Motorista de Ônibus",
	Traffic = "Traficante",
	Hunting = "Caçador",
	Garbageman = "Lixeiro",
	Race = "Corredor",
	Throwing = "Entregador de Jornal",
	Minerman = "Minerador",
	Cemitery = "Coveiro",
	FoodRush = "Entregador Food Rush",
	Powerwasher = "Lavador de Veículos",
	TrainDriver = "Maquinista"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE
-- Itens exclusivos para a polícia. Jogadores normais (sem a permissão) não conseguirão manusear, usar, dropar no chão, guardar em baús, etc.
-----------------------------------------------------------------------------------------------------------------------------------------
PoliceItemsSystem = true
PoliceItems = {
	["barrier"] = true,
	["gdtkit"] = true,
	["gsrkit"] = true,
	["spikestrips"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNDISCARDABLE
-- Itens que não podem ser descartados (não podem ser jogados no chão ou guardados em nenhum tipo de baú).
-----------------------------------------------------------------------------------------------------------------------------------------
UndiscardableSystem = true
UndiscardableItems = {
	["gemstone"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNHANDLEABLE
-- Itens intransferíveis (não saem do inventário para nada). Não podem ser jogados no chão, guardados em baú, roubados por revistar, ou enviados para outros.
-----------------------------------------------------------------------------------------------------------------------------------------
UnhandleableSystem = true
UnhandleableItems = {
	["gemstone"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEEPITEMSONDEATH
-- Itens que não são perdidos quando o jogador morre (limpeza de inventário).
-----------------------------------------------------------------------------------------------------------------------------------------
KeepItemsOnDeathSystem = true
KeepItemsOnDeath = {
	["gemstone"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
MaxRepair = 1
MinimumWeight = 15
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOTS
-----------------------------------------------------------------------------------------------------------------------------------------
EnableLoots = false -- Configuração para habilitar/desabilitar loots (LootMedics, LootWeapons, LootSupplies, LootLegendary, LootCode) e seus blips
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
PrisonCoords = vec3(1896.15,2604.44,45.75)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNED
-----------------------------------------------------------------------------------------------------------------------------------------
Banned = {
	Enter = true,
	Mute = true,
	Route = 9999998,
	Leave = vec3(242.77,-392.07,46.3)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
Currency = "R$"
DiscordBot = true
BaseMode = "steam"
Whitelisted = true
Liberation = "id"
DisconnectReason = 30
NameDefault = "Indivíduo Indigente"
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
ServerName = "CBR CITY"
ServerLink = "https://discord.gg/56xBTWj8Ks"
ServerAvatar = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTOSAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AutoSave = true                                						-- Salvar o Banco de dados automático
AutoSaveTime = 60000                           						-- (60000 = 1 Minuto)
AutoSaveSilenced = true                       						-- Printar no CMD quando o save for feito
AutoSaveMessage = "Banco de Dados foi salvo."						-- Mensagem que vai aparecer no CMD
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
Maintenance = false
--{
--	["11000010c6d36de"] = true
--}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
Cutscene = false
CreatorCoords = vec4(-793.42,326.06,210.79,357.17)
SpawnCoords = {
	vec4(-1070.1,-2793.79,20.96,331.66)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTUREPACK
-----------------------------------------------------------------------------------------------------------------------------------------
TexturePack = {
	{ Width = 19, Height = 20, Image = "E" },
	{ Width = 19, Height = 20, Image = "H" },
	{ Width = 72, Height = 72, Image = "Drop" },
	{ Width = 43, Height = 67, Image = "Races" },
	{ Width = 72, Height = 72, Image = "Normal" },
	{ Width = 102, Height = 20, Image = "EPress" },
	{ Width = 102, Height = 20, Image = "HPress" },
	{ Width = 72, Height = 72, Image = "Selected" },
	{ Width = 72, Height = 72, Image = "Marker" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
VehiclesGarages = { -- Veículos que não podem ser vendidos e transferidos
	"BCs_VpAr8pl",
	"BCs_VpLph18",
	"BCs_VpVh60r"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS
-----------------------------------------------------------------------------------------------------------------------------------------
CharacterItens = {
	soda = 2,
	identity = 1,
	hamburger = 2,
	cellphone = 1
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOXES
-----------------------------------------------------------------------------------------------------------------------------------------
Boxes = {
	treasurebox = {
		Multiplier = { Min = 1, Max = 1 },
		List = {
			{ Item = "dollar", Chance = 100, Min = 4250, Max = 6250 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPPERLEVEL
-----------------------------------------------------------------------------------------------------------------------------------------
UpperLevel = {
	Trucker = {
		{
			{ Item = "bandage", Min = 1, Max = 2 },
			{ Item = "advtoolbox", Min = 1, Max = 1 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
SkinshopInit = {
	mp_m_freemode_01 = { -- roupa intima: cueca, sem camisa, descalço
		pants = { item = 61, texture = 0 },
		arms = { item = 15, texture = 0 },
		tshirt = { item = 15, texture = 0 },
		torso = { item = 15, texture = 0 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 34, texture = 0 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = 0, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	},
	mp_f_freemode_01 = { -- roupa intima: sutiã, calcinha, descalça
		pants = { item = 15, texture = 0 },
		arms = { item = 15, texture = 0 },
		tshirt = { item = 14, texture = 0 },
		torso = { item = 15, texture = 0 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 35, texture = 0 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = -1, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
BarbershopInit = {
	mp_m_freemode_01 = {
        eyesColor = 5, eyesOpening = 0, eyebrowsHeight = 0, eyebrowsWidth = 0, noseWidth = 0,
        noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0,
        cheekboneHeight = 0, cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0,
        jawHeight = 0, chinLength = 0, chinPosition = 0,
        chinWidth = 0, chinShape = 0, neckWidth = 0,
        hair = 4, hairColor = 0, hairSecondColor = 0, eyebrow = 0, eyebrowColor = 0,
        beard = -1, beardColor = 0, chest = -1, chestColor = 0, blush = -1, blushColor = 0, lipstick = -1, lipstickColor = 0,
        blemishes = -1, ageing = -1, complexion = -1, sundamage = -1, freckles = -1, makeup = -1
    },
	mp_f_freemode_01 = {
        eyesColor = 5, eyesOpening = 0, eyebrowsHeight = 0, eyebrowsWidth = 0, noseWidth = 0,
        noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0,
        cheekboneHeight = 0, cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0,
        jawHeight = 0, chinLength = 0, chinPosition = 0,
        chinWidth = 0, chinShape = 0, neckWidth = 0,
        hair = 4, hairColor = 0, hairSecondColor = 0, eyebrow = 0, eyebrowColor = 0,
        beard = -1, beardColor = 0, chest = -1, chestColor = 0, blush = -1, blushColor = 0, lipstick = -1, lipstickColor = 0,
        blemishes = -1, ageing = -1, complexion = -1, sundamage = -1, freckles = -1, makeup = -1
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCAÇÕES NO CHÃO (garagens, concessionárias, loja de roupas, barbearia, tatuagem)
-----------------------------------------------------------------------------------------------------------------------------------------
MarkerColor = { 46, 139, 87, 170 } -- #2E8B57 (cor da cidade) + transparência (0-255)

local MarkerGround = {}

-- Anel fino (tipo 25) rente ao chão; a altura do chão é buscada uma vez por ponto e guardada
function DrawGroundMarker(x,y,z,Size)
	local Key = ("%.1f:%.1f:%.1f"):format(x,y,z)
	local Ground = MarkerGround[Key]

	if not Ground then
		local Found,GroundZ = GetGroundZFor_3dCoord(x,y,z + 0.5,false)
		if Found and (z - GroundZ) < 3.0 then
			Ground = GroundZ + 0.03
			MarkerGround[Key] = Ground
		else
			Ground = z - 0.97
		end
	end

	Size = Size or 1.2
	DrawMarker(25,x,y,Ground,0.0,0.0,0.0,0.0,0.0,0.0,Size,Size,1.0,MarkerColor[1],MarkerColor[2],MarkerColor[3],MarkerColor[4],false,false,2,false,nil,nil,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
Theme = {
	shadow = true,
	main = "#2E8B57",
	mainText = "#ffffff",
	currency = Currency,
	items = ListItem,
	vehicles = ListVehicles,
	groups = Groups,
	levels = Levels,
	common = "#6fc66a",
	rare = "#6ac6c5",
	epic = "#c66a75",
	legendary = "#c6986a",
	accept = {
		letter = "#dcffe9",
		background = "#2E8B57"
	},
	reject = {
		letter = "#ffe8e8",
		background = "#ad4443"
	},
	loading = {
		mode = "dark", -- [ Opções disponíveis: dark,light ],
		model = 2, -- [ Opções disponíveis: 1,2 ],
		progress = true -- [ Opções disponíveis: true, false ],
	},
	chat = {
		Importante = {
			background = "#9d194e",
			letter = "#f7c1d6"
		},
		Policia = {
			background = "#16468b",
			letter = "#ffffff"
		},
		Paramedico = {
			background = "#9f1918",
			letter = "#ffffff"
		}
	},
	hud = {
		modes = {
			info = 3, -- [ Opções disponíveis: 1,2,3 ],
			icon = "fill", -- [ Opções disponíveis: fill,line ],
			status = 10, -- [ Opções disponíveis: 1 a 12 ],
			vehicle = 3 -- [ Opções disponíveis: 1,2,3 ]
		},
		logo = 75, -- tamanho da logo
		alwaysWanted = true,
		percentage = true,
		icons = "#FFFFFF",
		nitro = "#F69D2A",
		rpm = "#FFFFFF",
		fuel = "#F94C54",
		engine = "#FF4C55",
		health = "#2E8B57",
		armor = "#A66FED",
		hunger = "#F4B266",
		thirst = "#7FC8F8",
		oxygen = "#38F8F8",
		stress = "#E287C9",
		luck = "#F18A7C",
		dexterity = "#E4E76E",
		repose = "#7FCCC7",
		pointer = "#EF4444",
		progress = {
			background = "#FFFFFF",
			circle = "#2E8B57",
			letter = "#FFFFFF"
		}
	},
	notifyitem = {
		add = {
			letter = "#dcffe9",
			background = "#2E8B57"
		},
		remove = {
			letter = "#ffe8e8",
			background = "#ad4443"
		}
	},
	pause = {
		premium = true,
		propertys = true,
		store = true,
		battlepass = true,
		boxes = true,
		marketplace = true,
		skinweapon = true,
		ranking = true,
		statistics = true,
		daily = true,
		code = true,
		map = true,
		settings = true,
		hud = true,
		disconnect = true,
		furnitures = true
	},
	scripts = {
		taximeter = {
			main = "#2E8B57",
			mainText = "#ffffff"
		}
	},
	inventory = {
		missions = false,
		blueprint = false,
		slots = {
			max = 100,
			default = 25,
			gemstone = { 250,275,300,325,350,375,400,425,450,475,500,525,550,575,600,625,650,675,700,725,750,775,800,825,850,875,900,925,950,975,1000,1025,1050,1075,1100,1125,1150,1175,1200,1225,1250,1275,1300,1325,1350,1375,1400,1425,1450,1475,1500,1525,1550,1575,1600,1625,1650,1675,1700,1725,1750,1775,1800,1825,1850,1875,1900,1925,1950,1975,2000,2025,2050,2075,2100,2125,2150,2175,2200,2225,2250,2275,2300,2325,2350,2375,2400,2425,2450,2475,2500,2525,2550,2575,2600,2625,2650,2675,2700,2725,2750,2775,2800,2825,2850,2875,2900,2925,2950,2975,3000,3025,3050,3075,3100,3125,3150,3175,3200,3225,3250,3275,3300,3325,3350,3375,3400,3425,3450,3475,3500,3525,3550,3575,3600,3625,3650,3675,3700,3725,3750,3775,3800,3825,3850,3875,3900,3925,3950,3975,4000,4025,4050,4075,4100,4125,4150,4175,4200,4225,4250,4275,4300,4325,4350,4375,4400,4425,4450,4475,4500,4525,4550,4575,4600,4625,4650,4675,4700,4725,4750,4775,4800,4825,4850,4875,4900,4925,4950,4975,5000,5025,5050,5075,5100,5125,5150,5175,5200,5225 },
			bank = { 100000,110000,120000,130000,140000,150000,160000,170000,180000,190000,200000,210000,220000,230000,240000,250000,260000,270000,280000,290000,300000,310000,320000,330000,340000,350000,360000,370000,380000,390000,400000,410000,420000,430000,440000,450000,460000,470000,480000,490000,500000,510000,520000,530000,540000,550000,560000,570000,580000,590000,600000,610000,620000,630000,640000,650000,660000,670000,680000,690000,700000,710000,720000,730000,740000,750000,760000,770000,780000,790000,800000,810000,820000,830000,840000,850000,860000,870000,880000,890000,900000,910000,920000,930000,940000,950000,960000,970000,980000,990000,1000000,1010000,1020000,1030000,1040000,1050000,1060000,1070000,1080000,1090000,1100000,1110000,1120000,1130000,1140000,1150000,1160000,1170000,1180000,1190000,1200000,1210000,1220000,1230000,1240000,1250000,1260000,1270000,1280000,1290000,1300000,1310000,1320000,1330000,1340000,1350000,1360000,1370000,1380000,1390000,1400000,1410000,1420000,1430000,1440000,1450000,1460000,1470000,1480000,1490000,1500000,1510000,1520000,1530000,1540000,1550000,1560000,1570000,1580000,1590000,1600000,1610000,1620000,1630000,1640000,1650000,1660000,1670000,1680000,1690000,1700000,1710000,1720000,1730000,1740000,1750000,1760000,1770000,1780000,1790000,1800000,1810000,1820000,1830000,1840000,1850000,1860000,1870000,1880000,1890000,1900000,1910000,1920000,1930000,1940000,1950000,1960000,1970000,1980000,1990000,2000000,2010000,2020000,2030000,2040000,2050000,2060000,2070000,2080000,2090000 }
		}
	},
	eyeColorAtBarbershop = true
}
