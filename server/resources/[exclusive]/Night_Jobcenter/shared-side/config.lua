-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.Jobs = {
	{
		name = "Lavador de Veiculos", icon = "fa-droplet", image = "Tows.png", rank = "Powerwasher",
		description = "Limpe veiculos e complete contratos de lavagem pela cidade.",
		instructions = "Assine a carteira e va ate a base do lavador para iniciar um contrato.",
		paidActions = { "Lavagem", "Limpeza", "Contratos", "Veiculos" }, tags = { "Salario Medio", "Com Veiculo", "Rota Curta" }
	},

	{
		name = "Maquinista",
		icon = "fa-train",
		image = "Bus.png",
		rank = "TrainDriver",
		description = "Conduza trens e transporte passageiros pelas linhas da cidade.",
		instructions = "Assine a carteira, vá até a estação marcada no GPS e inicie uma rota de metrô ou trem.",
		paidActions = { "Condução", "Passageiros", "Estações", "Rotas ferroviárias" },
		tags = { "Salário Médio", "Com Veículo", "Rota Longa" }
	},
	{
		name = "Lixeiro",
		icon = "fa-trash",
		image = "Garbageman.png",
		rank = "Garbageman",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, retire o veículo da garagem e saia pela cidade de forma livre vasculhando todas as lixeiras pela sua frente.",
		paidActions = { "Coleta", "Limpeza", "Descarte", "Resíduos", "Saneamento" },
		tags = { "Salário Baixo", "Com Veículo", "Rota Curta", "Risco à Saúde" }
	},
	{
		name = "Taxista",
		icon = "fa-taxi",
		image = "Taxi.png",
		rank = "Taxi",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, retire o veículo da garagem e vá até a rota marcada no GPS, espere o passageiro embarcar e leve o mesmo até a rota final marcada no GPS.",
		paidActions = { "Transporte", "Condução", "Mobilidade", "Passageiros", "Itinerante" },
		tags = { "Salário Médio", "Com Veículo", "Rota Longa" }
	}, 
	{
		name = "Caminhoneiro",
		icon = "fa-truck-fast",
		image = "Trucker.png",
		rank = "Trucker",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS, escolha a sua carga e inicie o serviço, retire o veículo da garagem e engate a carga escolhida no caminhão, vá até a rota marcada no GPS, deixe a carga e depois siga a rota final.",
		paidActions = { "Transporte", "Rodovias", "Carga", "Logística", "Percursos longos" },
		tags = { "Salário Alto", "Com Veículo", "Rota Longa" }
	}, 
	{
		name = "Motorista de Ônibus",
		icon = "fa-bus",
		image = "Bus.png",
		rank = "Driver",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, retire o veículo da garagem e siga em direção aos pontos de recolha marcados no GPS.",
		paidActions = { "Rota", "Itinerante", "Rodoviário", "Passageiros", "Transporte coletivo" },
		tags = { "Salário Médio", "Com Veículo", "Rota Longa" }
	}, 
	{
		name = "Transportador de Valores",
		icon = "fa-sack-dollar",
		image = "Transporter.png",
		rank = "Transporter",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, retire o veículo da garagem, entre dentro do cofre do banco central e recolha quantos malotes conseguir, guarde no veículo e saia para a destribuição seguindo a rota no GPS.",
		paidActions = { "Valores", "Vigilância", "Transporte", "Segurança", "Responsabilidade" },
		tags = { "Salário Alto", "Com Veículo", "Rota Curta" }
	}, 
	{
		name = "Lenhador",
		icon = "fa-tree",
		image = "Lumberman.png",
		rank = "Lumberman",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, procure pelas árvores grandes e corte quantas conseguir, após isso venda no mesmo NPC que Iniciou o Serviço.",
		paidActions = { "Manejo florestal", "Corte de madeira", "Trabalho ao ar livre", "Derrubada de árvores", "Equipamentos de serraria" },
		tags = { "Salário Alto", "Sem Veículo", "Rota Curta" }
	},
	{
		name = "Entregador de Leite",
		icon = "fa-cow",
		image = "Milkman.png",
		rank = "Milkman",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, retire o veículo da garagem, procure pelas vacas dentro das baias e com a garrafa vazia retire o leite de quantas conseguir, após isso saia vendendo pela rota no GPS.",
		paidActions = { "Rota", "Cliente", "Entrega", "Laticínios", "Distribuição" },
		tags = { "Salário Médio", "Com Veículo", "Rota Longa" }
	},
	{
		name = "Rebocador",
		icon = "fa-truck-moving",
		image = "Tows.png",
		rank = "Towed",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, retire o veículo da garagem, siga a rota marcada e reboque o veículo que está no local, após isso retorne a central do rebocador e deixe o veículo rebocado no local, utilize o Entity Target(Alt) no veículo para finalizar o serviço.",
		paidActions = { "Veículos", "Resgate", "Reboque", "Assistência", "Emergência" },
		tags = { "Salário Alto", "Com Veículo", "Rota Longa" }
	},
	{
		name = "Correios",
		icon = "fa-box",
		image = "Grime.png",
		rank = "Grime",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, retire o veículo da garagem, pegue a caixa e leve até a van armazenando a mesma dentro do veículo, após encher o caminhão basta sair entregando pela rota marcada no GPS.",
		paidActions = { "Entregas", "Distribuição", "Encomendas", "Serviço Postal", "Correspondência" },
		tags = { "Salário Alto", "Com Veículo", "Rota Longa" }
	},
	{
		name = "Minerador",
		icon = "fa-hammer",
		image = "Minerman.png",
		rank = "Minerman",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e Use a Picareta para Minerar as Pedras, após isso você pode ir até a Joalheria marcada no GPS, refinar e vender todas as pedras colhidas.",
		paidActions = { "Mina", "Geologia", "Extração", "Mineração", "Exploração" },
		tags = { "Salário Alto", "Sem Veículo", "Rota Curta", "Risco à Saúde" }
	}, 
	{
		name = "Caçador",
		icon = "fa-crosshairs",
		image = "Hunter.png",
		rank = "Hunting",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e compre os materiais necessários, dentro da área de caça use a ração e vá a caça do animal marcado em seu GPS, após isso você pode ir até a cabana de caça marcada no GPS e vender todas as caixas coletadas.",
		paidActions = { "Natureza", "Exploração", "Sustentabilidade", "Sobrevivência", "Exploração" },
		tags = { "Salário Alto", "Sem Veículo", "Sem Rota", "Risco à Saúde" }
	},
	{
		name = "Pescador",
		icon = "fa-fish",
		image = "Fisherman.png",
		rank = "Fisherman",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e pegue o trator, dentro da área do serviço use a vara de pescar para pescar peixes.",
		paidActions = { "Natureza", "Exploração", "Sustentabilidade", "Sobrevivência", "Exploração" },
		tags = { "Salário Alto", "Com Veículo", "Rota Curta" }
	},
	{
		name = "Coveiro",
		icon = "fa-skull-crossbones",
		image = "Cemitery.png",
		rank = "Cemitery",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e pegue o trator, dentro da área do serviço e procure os cadáveres",
		paidActions = { "Inspeção", "Exploração", "Buscar", "Coletar" },
		tags = { "Salário Alto", "Sem Veículo", "Rota Curta" }
	},
	{
		name = "Entregador de Jornal",
		icon = "fa-newspaper",
		image = "Throwing.png",
		rank = "Throwing",
		description = "Saiba mais sobre o emprego logo a baixo.",
		instructions = "Após aceitar o emprego, vá até a marcação do mesmo no GPS e inicie o serviço, pegue sua bicicleta e distribua os jornais nas casas demarcadas na rota.",
		paidActions = { "Pedalar", "Agilidade", "Entrega", "Pontualidade" },
		tags = { "Salário Médio", "Com Veículo", "Rota Longa" }
	},
	{
		name = "Entregador Food Rush",
		icon = "fa-motorcycle",
		image = "FoodRush.png",
		rank = "FoodRush",
		description = "Trabalhe como entregador de comida por aplicativo.",
		instructions = "Após aceitar o emprego, abra o aplicativo Food Rush no seu celular, fique disponível e aguarde os pedidos.",
		paidActions = { "Motoboy", "Entrega", "Comida", "Aplicativo" },
		tags = { "Salário Variável", "Com Veículo", "Rota Dinâmica" }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAGCOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
Config.tagColors = {
	"bg-orange-500",
	"bg-green-500",
	"bg-rose-500",
	"bg-rose-500"
}

if Works then
	for _, job in ipairs(Config.Jobs) do
		if Works[job.rank] then
			job.name = Works[job.rank]
		end
	end
end
