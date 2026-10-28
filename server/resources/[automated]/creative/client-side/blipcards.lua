-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPCARDS
-- Cartão que aparece ao passar o mouse nos blips do mapa (P / ESC). Usa o resource blip_info.
-- Chave = nome do blip (como está no painel gestor). Image = textura (padrão: banner da CBR CITY).
-- Lines = linhas extras { "Esquerda", "Direita" }.
-----------------------------------------------------------------------------------------------------------------------------------------
local BlipCards = {
	["Aeronaves"] = {
		Image = "aeronaves",
		Text = "O céu de Los Santos é de quem pode pagar. Alugue um helicóptero e veja a cidade de cima, longe do trânsito e dos olhares curiosos."
	},
	["Auto Escola"] = {
		Image = "auto_escola",
		Text = "Aqui ninguém nasce sabendo. Estude as leis de trânsito, encare o instrutor e saia com a habilitação na mão."
	},
	["Banco"] = {
		Title = "Banco Fleeca",
		Image = "banco",
		Text = "Seu dinheiro guardado a sete chaves. Saques, depósitos, transferências e aquele boleto de multa que você fingiu não ver."
	},
	["Barbearia"] = {
		Image = "barbearia",
		Text = "Cadeira de couro, navalha afiada e papo bom. Saia daqui irreconhecível: corte, barba, sobrancelha e maquiagem."
	},
	["Bennys"] = {
		Image = "bennys",
		Text = "Se tem motor, a Bennys resolve. Reparos, tunagem e aquela personalização que faz a rua inteira olhar quando você passa."
	},
	["Cat Cafe"] = {
		Image = "cat_cafe",
		Text = "Entre devagar para não acordar os gatos. Café quentinho, doces fofos e um cantinho para fugir do caos da cidade."
	},
	["Central de Empregos"] = {
		Image = "central_de_empregos",
		Text = "Conta para pagar e bolso vazio? Escolha uma profissão, assine a carteira e comece a construir sua vida honesta em Los Santos."
	},
	["Concessionária"] = {
		Image = "concessionaria",
		Text = "Cheiro de carro novo e vendedor sorridente. Faça o test drive, escolha a cor e saia dirigindo o seu próximo xodó."
	},
	["Embarcações"] = {
		Image = "embarcacoes",
		Text = "O mar chama. Retire seu barco ou jet ski e aproveite a costa de Los Santos com o vento na cara."
	},
	["Garagem"] = {
		Image = "garagem",
		Text = "Seu veículo guardado e seguro. Retire, guarde e siga viagem. Na hora de sair, não esqueça: a chave vira no Z."
	},
	["Hotel"] = {
		Image = "hotel",
		Text = "Um quarto simples, uma cama macia e um teto sobre a cabeça. O lugar certo para recomeçar depois de um dia difícil."
	},
	["Loja de Armas"] = {
		Image = "loja_de_armas",
		Text = "Balcão de vidro, prateleiras cheias e um atendente que não faz perguntas demais. Armas, munições e acessórios."
	},
	["Loja de Departamento"] = {
		Image = "loja_de_departamento",
		Text = "A conveniência da esquina que nunca fecha. Lanche, bebida gelada, energético e tudo que faltou na sua mochila."
	},
	["Loja de Eletronicos"] = {
		Image = "loja_de_eletronicos",
		Text = "Tecnologia que cabe no bolso. Celulares, rádios e aparelhos para você nunca ficar fora da linha."
	},
	["Loja de Penhores"] = {
		Image = "loja_de_penhores",
		Text = "Aqui tudo tem seu preço e ninguém pergunta a origem. Troque objetos de valor por dinheiro vivo na hora."
	},
	["Loja de Roupas"] = {
		Image = "loja_de_roupas",
		Text = "Espelhos, provadores e as últimas tendências da cidade. Monte o seu estilo da cabeça aos pés e faça sua entrada."
	},
	["Loja de Tatuagem"] = {
		Image = "loja_de_tatuagem",
		Text = "Agulha, tinta e uma história gravada na pele para sempre. Escolha bem: aqui não tem botão de desfazer."
	},
	["Mercado Central"] = {
		Image = "mercado_central",
		Text = "Feira cheia, preços justos e ingredientes frescos. Abasteça a cozinha de casa ou o estoque do seu negócio."
	},
	["Posto de Combustível"] = {
		Image = "posto_de_combustivel",
		Text = "Abasteça, confira o tanque e siga viagem. Combustível para atravessar a cidade sem ficar pelo caminho."
	},
	["Moo Moo Cafe"] = {
		Image = "moo_moo_cafe",
		Text = "O café mais doce de Los Santos. Milkshakes, sobremesas e lanches servidos com um sorriso e um pouquinho de açúcar a mais."
	}
}

-- Chamado pelo creative logo depois de criar cada blip do banco
function ApplyBlipCard(Blip,Name)
	local Card = BlipCards[Name]
	if not Card or GetResourceState("blip_info") ~= "started" then
		return
	end

	local Info = exports.blip_info
	Info:ResetBlipInfo(Blip)
	Info:SetBlipInfoTitle(Blip,Card.Title or Name,false)
	Info:SetBlipInfoImage(Blip,Card.Dict or "cbr_blipinfo",Card.Image or "banner")
	Info:AddBlipInfoText(Blip,Card.Text)

	for _,Line in ipairs(Card.Lines or {}) do
		Info:AddBlipInfoText(Blip,Line[1],Line[2])
	end
end
