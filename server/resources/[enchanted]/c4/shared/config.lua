-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
-- Configuração dos itens usados no script
Config.ItemC4 = "c4" -- Nome de spawn do item C4 no inventário
Config.MoneyItem = "dirtydollar" -- Nome de spawn do dinheiro sujo/marcado recebido no final do roubo
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEGURANÇA
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Security = {
	StartDistance = 5.0, -- Distância máxima que o jogador pode estar do caixa para iniciar o roubo
	PickupDistance = 15.0, -- Distância máxima permitida pelo servidor na hora de coletar o malote
	PickupTimeout = 180, -- Tempo máximo (em segundos) que o malote fica no chão antes de sumir
	RateLimitMs = 400 -- Proteção anti-flood (em milissegundos) para as chamadas do cliente ao servidor
}

-- Tempo de espera (em milissegundos) da animação inicial instalando a bomba no caixa
Config.AnimWaitMs = 5000 
-- Hash do modelo do prop da bomba (C4) que é fixada no caixa
Config.BombHash = `prop_c4_final`

-- Configuração de ajuste fino (Offset) para cada modelo diferente de caixa eletrônico.
-- 'off': Posição x,y,z onde a C4 vai grudar em relação ao centro do caixa.
-- 'rot': Rotação da C4 para ela ficar alinhada com a tela do caixa.
-- 'money': Coordenada (pos) e raio (range) de onde o malote de dinheiro vai nascer após a explosão.
Config.PropOffset = {
	[`prop_atm_01`] = { off = vec3(0.0, -0.31, 0.75), rot = vec3(0.0, 90.0, 0.0), money = { pos = vec3(0.0, -1.0, 0.0), range = 1.1 } },
	[`prop_atm_02`] = { off = vec3(0.20, 0.02, 1.05), rot = vec3(0.0, 0.0, 0.0), money = { pos = vec3(0.0, -1.0, 0.0), range = 1.1 } },
	[`prop_atm_03`] = { off = vec3(0.20, 0.02, 1.05), rot = vec3(0.0, 0.0, 0.0), money = { pos = vec3(0.0, -1.0, 0.0), range = 1.1 } },
	[`prop_fleeca_atm`] = { off = vec3(0.20, 0.02, 1.05), rot = vec3(0.0, 0.0, 0.0), money = { pos = vec3(0.0, -1.0, 0.0), range = 1.1 } }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Police = {
	MinAmount = 0, -- Número mínimo de policiais em serviço necessários para permitir o roubo

	Permission = "Policia", -- Permissão do grupo que receberá o chamado
	CallPolice = {
		Name = "Roubo a Caixa Eletrônico", -- Título do chamado
		Percentage = 500, -- Se for 1000 a polícia nunca é chamada. Deixe em 0 para 100% de chance de chamar.
		Code = 31, -- Código visual do chamado no mapa (sprite)
		Color = 22, -- Cor do blip do chamado no mapa
		C4 = {
			Wanted = 600 -- Tempo de procurado (wanted) que o jogador recebe ao estourar o C4
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Robbery = {
	Cooldown = 300, -- Tempo (em segundos) de espera até que o mesmo caixa possa ser roubado novamente

	-- C4Time e MinC4Time definem um tempo aleatório para a bomba explodir (neste caso, fixo em 10 segundos).
	C4Time = 10,
	MinC4Time = 10,

	-- Valuation define o cálculo do dinheiro sujo que o ladrão receberá
	Valuation = {
		Min = 2000, -- Valor mínimo base do roubo
		Max = 5000, -- Valor máximo base do roubo
		Multipliers = {
			Party = 1.1, -- Multiplicador de bônus caso o jogador esteja em grupo (party)
			Dexterity = 1.1, -- Multiplicador de bônus caso o jogador possua a habilidade de destreza
			Services = { -- Bônus adicional dependendo de passes VIP/permissões que o jogador possua
				Ouro = 0.1, -- +10%
				Prata = 0.075, -- +7.5%
				Bronze = 0.05 -- +5%
			}
		}
	},
	Pickups = {
		Total = 1, -- Quantidade de malotes físicos que vão aparecer no chão (deixe 1 para evitar prender o jogador muito tempo no caixa)
		Model = "prop_money_bag_01", -- Modelo 3D principal do malote
		FallbackModel = "bkr_prop_money_unsorted_01" -- Modelo reserva caso o jogador não tenha o modelo principal no jogo dele
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATM LIST
-----------------------------------------------------------------------------------------------------------------------------------------
-- Lista contendo as coordenadas (Cds) e modelo (Prop) de todos os caixas eletrônicos disponíveis.
-- Safe = true: Significa que o caixa é protegido em área segura (Safezone) e NÃO pode ser roubado.
-- PermittedTime = {20, 2}: Significa que esse caixa específico só pode ser roubado entre as 20h e as 2h da manhã.
Config.AtmList = {
		{ Cds = vec3(121.17, -3019.62, 7.04), Prop = -870868698 },
		{ Cds = vec3(797.69, -767.52, 26.77), Prop = -870868698 },
		{ Cds = vec3(-1431.17, -447.73, 35.91), Prop = -870868698 },
		{ Cds = vec3(168.55, 6636.81, 31.69), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-32.08, -1104.32, 27.26), Prop = -870868698 },
		{ Cds = vec3(228.28, 338.4, 105.56), Prop = -870868698 },
		{ Cds = vec3(158.64, 234.61, 106.63), Prop = -870868698 },
		{ Cds = vec3(-57.67, -92.62, 57.78), Prop = -870868698 },
		{ Cds = vec3(356.97, 173.54, 103.07), Prop = -870868698 },
		{ Cds = vec3(-1415.94, -212.03, 46.51), Prop = -870868698 },
		{ Cds = vec3(-1430.2, -211.08, 46.51), Prop = -870868698 },
		{ Cds = vec3(-1282.54, -210.9, 42.44), Prop = -870868698 },
		{ Cds = vec3(-1286.25, -213.44, 42.44), Prop = -870868698 },
		{ Cds = vec3(-1289.32, -226.82, 42.44), Prop = -870868698 },
		{ Cds = vec3(-1285.58, -224.28, 42.44), Prop = -870868698 },
		{ Cds = vec3(-1109.8, -1690.82, 4.36), Prop = -870868698 },
		{ Cds = vec3(1686.85, 4815.82, 42.01), Prop = -870868698 },
		{ Cds = vec3(1701.21, 6426.57, 32.76), Prop = -870868698 },
		{ Cds = vec3(-868.7, -2110.35, 9.92), Prop = -870868698 },
		{ Cds = vec3(-867.13, -2111.9, 9.92), Prop = -870868698 },
		{ Cds = vec3(1735.2, 6410.52, 35.03), Prop = -870868698 },
		{ Cds = vec3(2683.11, 3286.57, 55.23), Prop = -870868698 },
		{ Cds = vec3(1171.56, 2702.58, 38.16), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(1172.5, 2702.59, 38.16), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(1683.88, 4848.88, 42.14), Prop = 506770882, PermittedTime = {20, 2} },
		{ Cds = vec3(-1091.49, 2708.66, 18.96), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-766.13, 8783.01, 6.50), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-766.08, 8784.17, 6.50), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-1682.04, 9320.88, 6.67), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-3144.38, 1127.6, 20.86), Prop = -870868698 },
		{ Cds = vec3(527.36, -160.69, 57.09), Prop = -1126237515 },
		{ Cds = vec3(285.45, 143.39, 104.17), Prop = -1126237515 },
		{ Cds = vec3(-846.27, -341.28, 38.67), Prop = -1126237515 },
		{ Cds = vec3(-846.85, -340.2, 38.67), Prop = -1126237515 },
		{ Cds = vec3(-721.06, -415.56, 34.98), Prop = -1126237515 },
		{ Cds = vec3(-1410.34, -98.75, 52.42), Prop = -1126237515 },
		{ Cds = vec3(-1409.78, -100.49, 52.39), Prop = -1126237515 },
		{ Cds = vec3(-712.9, -818.92, 23.72), Prop = -1126237515 },
		{ Cds = vec3(-710.05, -818.9, 23.72), Prop = -1126237515 },
		{ Cds = vec3(-660.71, -854.07, 24.48), Prop = -1126237515 },
		{ Cds = vec3(-594.58, -1161.29, 22.33), Prop = -1126237515 },
		{ Cds = vec3(-596.09, -1161.28, 22.33), Prop = -1126237515 },
		{ Cds = vec3(-821.64, -1081.91, 11.12), Prop = -1126237515 },
		{ Cds = vec3(155.93, 6642.86, 31.59), Prop = -1126237515 },
		{ Cds = vec3(174.14, 6637.94, 31.58), Prop = -1126237515 },
		{ Cds = vec3(-283.01, 6226.11, 31.49), Prop = -1126237515 },
		{ Cds = vec3(-95.55, 6457.19, 31.46), Prop = -1126237515, PermittedTime = {20, 2} },
		{ Cds = vec3(-97.3, 6455.48, 31.46), Prop = -1126237515, PermittedTime = {20, 2} },
		{ Cds = vec3(-132.93, 6366.52, 31.48), Prop = -1126237515 },
		{ Cds = vec3(-386.74, 6046.08, 31.49), Prop = -1126237515, PermittedTime = {20, 2} },
		{ Cds = vec3(24.47, -945.96, 29.35), Prop = -1126237515 },
		{ Cds = vec3(5.24, -919.83, 29.55), Prop = -1126237515 },
		{ Cds = vec3(295.77, -896.1, 29.22), Prop = -1126237515 },
		{ Cds = vec3(296.47, -894.21, 29.23), Prop = -1126237515 },
		{ Cds = vec3(1138.22, -468.93, 66.73), Prop = -1126237515 },
		{ Cds = vec3(1166.97, -456.06, 66.79), Prop = -1126237515 },
		{ Cds = vec3(1077.75, -776.54, 58.23), Prop = -1126237515 },
		{ Cds = vec3(289.1, -1256.8, 29.44), Prop = -1126237515 },
		{ Cds = vec3(288.81, -1282.37, 29.64), Prop = -1126237515 },
		{ Cds = vec3(-1571.05, -547.38, 34.95), Prop = -1126237515 },
		{ Cds = vec3(-1570.12, -546.72, 34.95), Prop = -1126237515 },
		{ Cds = vec3(-1305.4, -706.41, 25.33), Prop = -1126237515 },
		{ Cds = vec3(-2072.36, -317.28, 13.31), Prop = -1126237515 },
		{ Cds = vec3(-2295.48, 358.13, 174.6), Prop = -1126237515 },
		{ Cds = vec3(-2294.7, 356.46, 174.6), Prop = -1126237515 },
		{ Cds = vec3(-2293.92, 354.8, 174.6), Prop = -1126237515 },
		{ Cds = vec3(2558.75, 351.01, 108.61), Prop = -1126237515 },
		{ Cds = vec3(89.69, 2.47, 68.29), Prop = -1364697528 },
		{ Cds = vec3(-866.69, -187.75, 37.84), Prop = -1364697528 },
		{ Cds = vec3(-867.62, -186.09, 37.84), Prop = -1364697528 },
		{ Cds = vec3(-618.22, -708.89, 30.04), Prop = -1364697528 },
		{ Cds = vec3(-618.23, -706.89, 30.04), Prop = -1364697528 },
		{ Cds = vec3(-614.58, -704.83, 31.24), Prop = -1364697528 },
		{ Cds = vec3(-611.93, -704.83, 31.24), Prop = -1364697528 },
		{ Cds = vec3(-537.82, -854.49, 29.28), Prop = -1364697528 },
		{ Cds = vec3(-526.62, -1222.98, 18.45), Prop = -1364697528 },
		{ Cds = vec3(-165.15, 232.7, 94.91), Prop = -1364697528 },
		{ Cds = vec3(-165.17, 234.78, 94.91), Prop = -1364697528 },
		{ Cds = vec3(-303.25, -829.74, 32.42), Prop = -1364697528 },
		{ Cds = vec3(-301.7, -830.01, 32.42), Prop = -1364697528 },
		{ Cds = vec3(-203.81, -861.37, 30.26), Prop = -1364697528 },
		{ Cds = vec3(119.06, -883.72, 31.12), Prop = -1364697528 },
		{ Cds = vec3(112.58, -819.4, 31.34), Prop = -1364697528 },
		{ Cds = vec3(111.26, -775.25, 31.44), Prop = -1364697528 },
		{ Cds = vec3(114.43, -776.38, 31.41), Prop = -1364697528 },
		{ Cds = vec3(-256.23, -715.99, 33.53), Prop = -1364697528 },
		{ Cds = vec3(-258.87, -723.38, 33.48), Prop = -1364697528 },
		{ Cds = vec3(-254.42, -692.49, 33.6), Prop = -1364697528 },
		{ Cds = vec3(-28.0, -724.52, 44.23), Prop = -1364697528 },
		{ Cds = vec3(-30.23, -723.69, 44.23), Prop = -1364697528 },
		{ Cds = vec3(-1315.75, -834.69, 16.95), Prop = -1364697528 },
		{ Cds = vec3(-1314.81, -835.96, 16.95), Prop = -1364697528 },
		{ Cds = vec3(-2956.86, 487.64, 15.47), Prop = -1364697528 },
		{ Cds = vec3(-2958.98, 487.73, 15.47), Prop = -1364697528 },
		{ Cds = vec3(-3043.97, 592.42, 7.9), Prop = -1364697528 },
		{ Cds = vec3(-3241.17, 997.6, 12.55), Prop = -1364697528 },
		{ Cds = vec3(-1205.78, -324.79, 37.86), Prop = 506770882 },
		{ Cds = vec3(-1205.02, -326.3, 37.84), Prop = 506770882 },
		{ Cds = vec3(147.58, -1035.77, 29.34), Prop = 506770882 },
		{ Cds = vec3(146.0, -1035.17, 29.34), Prop = 506770882 },
		{ Cds = vec3(33.55, -1345.0, 29.49), Prop = -870868698 },
		{ Cds = vec3(2555.28, 389.99, 108.61), Prop = -870868698 },
		{ Cds = vec3(1153.65, -326.78, 69.2), Prop = -870868698 },
		{ Cds = vec3(-717.71, -915.66, 19.21), Prop = -870868698 },
		{ Cds = vec3(-56.98, -1752.09, 29.42), Prop = -870868698 },
		{ Cds = vec3(381.93, 326.43, 103.56), Prop = -870868698 },
		{ Cds = vec3(-3243.78, 1009.24, 12.82), Prop = -870868698 },
		{ Cds = vec3(1737.02, 6413.25, 35.03), Prop = -870868698 },
		{ Cds = vec3(540.4, 2667.86, 42.16), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(1966.81, 3746.52, 32.33), Prop = -870868698 },
		{ Cds = vec3(2680.45, 3288.48, 55.23), Prop = -870868698 },
		{ Cds = vec3(1734.8, 3645.64, 34.93), Prop = 506770882, PermittedTime = {20, 2} },
		{ Cds = vec3(1703.0, 4933.6, 42.06), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-1827.3, 784.88, 138.3), Prop = -870868698 },
		{ Cds = vec3(-3043.91, 592.48, 7.9), Prop = -1364697528 },
		{ Cds = vec3(126.82, -1296.6, 29.27), Prop = -870868698 },
		{ Cds = vec3(127.81, -1296.03, 29.27), Prop = -870868698 },
		{ Cds = vec3(-248.04, 6327.51, 32.42), Prop = -870868698 },
		{ Cds = vec3(-677.36, 5834.58, 17.32), Prop = -870868698 },
		{ Cds = vec3(472.3, -1001.57, 30.68), Prop = -870868698 },
		{ Cds = vec3(468.52, -990.55, 26.27), Prop = -870868698 },
		{ Cds = vec3(560.5, 2742.61, 42.87), Prop = -870868698 },
		{ Cds = vec3(2564.5, 2584.79, 38.08), Prop = -870868698 },
		{ Cds = vec3(-383.86, 7198.34, 18.21), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-514.07, 7556.71, 6.52), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-1237.92, 6928.49, 20.47), Prop = -870868698, PermittedTime = {20, 2} },
		{ Cds = vec3(-8.74, 226.3, 109.56), Prop = `prop_atm_01` },
		{ Cds = vec3(-24.47, 227.86, 109.54), Prop = `prop_atm_01` },
		{ Cds = vec3(-2.74, 235.6, 109.54), Prop = `prop_atm_01` },
		{ Cds = vec3(-1816.0, -1197.29, 13.01), Prop = `prop_atm_01` }
}
