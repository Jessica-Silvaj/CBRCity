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
-- Os caixas eletrônicos agora são cadastrados no painel gestor (Night_Management/data/atms.json).
-- Config.AtmList é preenchida por Config.LoadAtms e indexada pelo id do painel:
-- { Cds = vec3, Prop = hash do modelo, PermittedTime = {20, 2} (opcional: só pode roubar entre 20h e 2h) }
-- Só entram os caixas marcados como "Pode Roubar" e com modelo detectado.
Config.AtmList = {}

function Config.LoadAtms(List)
	local AtmList = {}

	for _,Atm in ipairs(List or {}) do
		if Atm.Kind ~= "agency" and Atm.Rob and Atm.Model then
			AtmList[Atm.id] = {
				Cds = vec3(Atm.X,Atm.Y,Atm.Z),
				Prop = GetHashKey(Atm.Model),
				PermittedTime = Atm.StartHour and Atm.EndHour and { Atm.StartHour,Atm.EndHour } or nil
			}
		end
	end

	Config.AtmList = AtmList
end
