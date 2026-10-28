-----------------------------------------------------------------------------------------------------------------------------------------
-- COLLECTIONSCATALOG
-----------------------------------------------------------------------------------------------------------------------------------------
CollectionsCatalog = {
	-- CAQUINHOS
	["caquinha"] = {
		hidden = true,
		category = "Caquinhos",
		rarity = "common",
		icon = "caquinha.png",
		blocks = { run = true, hit = true },
		bonus = {
			salary = 0.1, -- 10% de bônus no salário
			illegal = 0.05 -- 5% de bônus em vendas ilegais
		},
		prop = {
			model = "caquinhasummer_by_joao",
			positions = {
				{
					id = "no_ombro",
					label = "Ombro",
					bone = 24818,
					pos = { x = 0.280, y = -0.0948, z = 0.022 },
					rot = { x = -0.78, y = 90.0, z = 180.0 },
					anim = { dict = "chimapamze2@joao", name = "noombro_clip", flag = 49 }
				},
				{
					id = "segurando",
					label = "Segurando",
					bone = 18905,
					pos = { x = 0.702, y = -0.13155, z = -0.0102 },
					rot = { x = 180.0, y = 67.81, z = 0.48 },
					anim = { dict = "chimapamze2@joao", name = "segurando2_clip", flag = 49 }
				},
				{
					id = "na_perna",
					label = "Perna",
					bone = 51826,
					pos = { x = 0.267, y = 0.0, z = 0.138 },
					rot = { x = 0.0, y = -86.95, z = 167.49 },
					anim = { dict = "chimapamze2@joao", name = "naperna_clip", flag = 49 }
				},
				{
					id = "segurando2",
					label = "Segurando 2",
					bone = 18905,
					pos = { x = 0.653, y = -0.086, z = 0.0176 },
					rot = { x = 180.0, y = 67.45, z = -3.52 },
					anim = { dict = "chimapamze2@joao", name = "segurando_clip", flag = 49 }
				},
				{
					id = "no_colo",
					label = "Colo",
					bone = 24818,
					pos = { x = -0.094, y = 0.164, z = 0.0 },
					rot = { x = 180.0, y = -90.0, z = 0.42 },
					anim = { dict = "chimapamze2@joao", name = "nocolo_clip", flag = 49 }
				},
				{
					id = "nas_costas",
					label = "Costas",
					bone = 24818,
					pos = { x = 0.2, y = -0.12, z = -0.1 },
					rot = { x = 0.0, y = 90.0, z = 180.0 },
					anim = { dict = "chimapamze2@joao", name = "nascostas_clip", flag = 49 }
				}
			}
		},
		name = "Caquinha"
	},
	["caquinho2"] = {
		hidden = true,
		category = "Caquinhos",
		rarity = "common",
		icon = "caquinho.png",
		blocks = { run = true, hit = true },
		prop = {
			model = "caquinhosummer2_by_joao",
			positions = {
				{
					id = "no_ombro",
					label = "Ombro",
					bone = 24818,
					pos = { x = 0.280, y = -0.0948, z = 0.022 },
					rot = { x = -0.78, y = 90.0, z = 180.0 },
					anim = { dict = "chimapamze2@joao", name = "noombro_clip", flag = 49 }
				},
				{
					id = "segurando",
					label = "Segurando",
					bone = 18905,
					pos = { x = 0.702, y = -0.13155, z = -0.0102 },
					rot = { x = 180.0, y = 67.81, z = 0.48 },
					anim = { dict = "chimapamze2@joao", name = "segurando2_clip", flag = 49 }
				},
				{
					id = "na_perna",
					label = "Perna",
					bone = 51826,
					pos = { x = 0.267, y = 0.0, z = 0.138 },
					rot = { x = 0.0, y = -86.95, z = 167.49 },
					anim = { dict = "chimapamze2@joao", name = "naperna_clip", flag = 49 }
				},
				{
					id = "segurando2",
					label = "Segurando 2",
					bone = 18905,
					pos = { x = 0.653, y = -0.086, z = 0.0176 },
					rot = { x = 180.0, y = 67.45, z = -3.52 },
					anim = { dict = "chimapamze2@joao", name = "segurando_clip", flag = 49 }
				},
				{
					id = "no_colo",
					label = "Colo",
					bone = 24818,
					pos = { x = -0.094, y = 0.164, z = 0.0 },
					rot = { x = 180.0, y = -90.0, z = 0.42 },
					anim = { dict = "chimapamze2@joao", name = "nocolo_clip", flag = 49 }
				},
				{
					id = "nas_costas",
					label = "Costas",
					bone = 24818,
					pos = { x = 0.2, y = -0.12, z = -0.1 },
					rot = { x = 0.0, y = 90.0, z = 180.0 },
					anim = { dict = "chimapamze2@joao", name = "nascostas_clip", flag = 49 }
				}
			}
		},
		name = "Caquinho"
	},

	-- PATOS
	["daisyduck"] = {
		category = "Patos",
		hidden = true, -- personagem com direitos autorais (marca)
		rarity = "rare",
		prop = {
			model = "jpx_daisy_duck_sit",
			positions = {
				{
					id = "sit",
					label = "Sentada",
					bone = 31086,
					pos = { x = 0.1, y = 0.0, z = 0.0 },
					rot = { x = -90.0, y = -90.0, z = 10.0 },
					model = "jpx_daisy_duck_sit",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "fly",
					label = "Agarrada",
					bone = 16335,
					pos = { x = -0.14, y = -0.14, z = -0.13 },
					rot = { x = -70.0, y = -110.0, z = 0.0 },
					model = "jpx_daisy_duck_fly",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "dance",
					label = "Dançando",
					bone = 24818,
					pos = { x = 0.25, y = 0.0, z = 0.2 },
					rot = { x = -90.0, y = -90.0, z = 0.0 },
					model = "jpx_daisy_duck_dance",
					anim = { dict = "", name = "", flag = 49 }
				},
			}
		},
		icon = "daisyduck.png",
		name = "Daisy"
	},
	["donaldduck"] = {
		category = "Patos",
		hidden = true, -- personagem com direitos autorais (marca)
		rarity = "rare",
		prop = {
			model = "jpx_donald_duck_hold",
			positions = {
				{
					id = "hold",
					label = "Segurando",
					bone = 45509,
					pos = { x = 0.55, y = 0.0, z = 0.1 },
					rot = { x = 190.0, y = 90.0, z = 0.0 },
					model = "jpx_donald_duck_hold",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "walk",
					label = "Andando",
					bone = 20190,
					pos = { x = -0.6, y = 0.0, z = -1.0 },
					rot = { x = -90.0, y = -180.0, z = 0.0 },
					model = "jpx_donald_duck_walk",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "dance",
					label = "Dançando",
					bone = 24818,
					pos = { x = 0.25, y = 0.0, z = 0.2 },
					rot = { x = -90.0, y = -90.0, z = 0.0 },
					model = "jpx_donald_duck_dance",
					anim = { dict = "", name = "", flag = 49 }
				},
			}
		},
		icon = "donaldduck.png",
		name = "Donald"
	},

	-- FADAS
	["pixel1"] = {
		category = "Fadas",
		rarity = "rare",
		icon = "pixel1.png",
		bonus = {
			salary = 0.05 -- 5% de bônus no salário
		},
		prop = {
			model = "pixiefairy_by_joao",
			positions = {
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.15 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.15 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.25, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Fada Rosa"
	},
	["pixie2"] = {
		category = "Fadas",
		rarity = "rare",
		icon = "pixel2.png",
		prop = {
			model = "pixiefairy2_by_joao",
			positions = {
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.15 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.15 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.25, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Fada Roxa"
	},
	["pixie3"] = {
		category = "Fadas",
		icon = "pixel3.png",
		prop = {
			model = "pixiefairy3_by_joao",
			positions = {
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.15 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.15 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.25, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Fada Lilás"
	},
	["pixie4"] = {
		category = "Fadas",
		icon = "pixel4.png",
		prop = {
			model = "pixiefairy4_by_joao",
			positions = {
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.15 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.15 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.25, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Fada Laranja"
	},
	["pixie5"] = {
		category = "Fadas",
		icon = "pixel5.png",
		prop = {
			model = "pixiefairy5_by_joao",
			positions = {
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.15 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.15 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.25, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Fada Verde"
	},
	["pixie6"] = {
		category = "Fadas",
		icon = "pixel6.png",
		prop = {
			model = "pixiefairy6_by_joao",
			positions = {
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.15 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.15 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.25, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Fada Amarela"
	},

	-- DRAGÕES
	["baby1"] = {
		category = "Dragões",
		icon = "baby1.png",
		bonus = {
			illegal = 0.15 -- 15% de bônus em atividades ilegais
		},
		prop = {
			model = "babydragon_by_joao",
			positions = {
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.06 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.06 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.18, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Dragão Vermelho"
	},
	["baby2"] = {
		category = "Dragões",
		icon = "baby2.png",
		prop = {
			model = "babydragon2_by_joao",
			positions = {
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.06 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.06 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.18, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Dragão Azul"
	},
	["baby3"] = {
		category = "Dragões",
		icon = "baby3.png",
		prop = {
			model = "babydragon3_by_joao",
			positions = {
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.06 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.06 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.18, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Dragão Rosa"
	},
	["baby4"] = {
		category = "Dragões",
		icon = "baby4.png",
		prop = {
			model = "babydragon4_by_joao",
			positions = {
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.06 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.06 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.18, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Dragão Verde"
	},
	["baby5"] = {
		category = "Dragões",
		icon = "baby5.png",
		prop = {
			model = "babydragon5_by_joao",
			positions = {
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.06 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.06 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.18, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Dragão Laranja"
	},
	["baby6"] = {
		category = "Dragões",
		icon = "baby6.png",
		prop = {
			model = "babydragon6_by_joao",
			positions = {
				{ id = "ombro_esquerdo", label = "Ombro Esquerdo", bone = 10706, pos = { x = 0.10, y = 0.0, z = 0.06 }, rot = { x = 0.0, y = -14.0, z = 195.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "ombro_direito", label = "Ombro Direito", bone = 64729, pos = { x = 0.10, y = 0.0, z = -0.06 }, rot = { x = -180.0, y = 14.0, z = 20.0 }, anim = { dict = "", name = "", flag = 49 } },
				{ id = "cabeca", label = "Cabeça", bone = 31086, pos = { x = 0.18, y = 0.03, z = 0.0 }, rot = { x = 0.0, y = 90.0, z = 180.0 }, anim = { dict = "", name = "", flag = 49 } }
			}
		},
		name = "Dragão Preto"
	},

	-- GATOS
	["britishcat_joao"] = {
		category = "Gatos",
		icon = "britishcat.png",
		blocks = { run = true, hit = true },
		prop = {
			model = "britishicat_by_joao",
			bone = 24818,
			pos = { x = -0.04, y = 0.163, z = 0.0176 },
			rot = { x = 0.0, y = 90.0, z = -180.0 },
			anim = { dict = "petcarinhoanimation@joao", name = "carinho_clip", flag = 49 }
		},
		name = "Gato Britânico"
	},
	["munchkincat_joao"] = {
		category = "Gatos",
		icon = "munchkincat.png",
		blocks = { run = true, hit = true },
		prop = {
			model = "munchkincat_by_joao",
			bone = 24818,
			pos = { x = -0.02, y = 0.163, z = 0.0176 },
			rot = { x = 0.0, y = 90.0, z = -180.0 },
			anim = { dict = "petcarinhoanimation@joao", name = "carinho_clip", flag = 49 }
		},
		name = "Gato Munchkin"
	},
	["siamescat_joao"] = {
		category = "Gatos",
		icon = "siamescat.png",
		blocks = { run = true, hit = true },
		prop = {
			model = "siamescat_by_joao",
			bone = 24818,
			pos = { x = -0.04, y = 0.163, z = 0.0176 },
			rot = { x = 0.0, y = 90.0, z = -180.0 },
			anim = { dict = "petcarinhoanimation@joao", name = "carinho_clip", flag = 49 }
		},
		name = "Gato Siamês"
	},
	["blackcat_joao"] = {
		category = "Gatos",
		icon = "blackcat2.png",
		blocks = { run = true, hit = true },
		prop = {
			model = "blackcat_by_joao",
			bone = 24818,
			pos = { x = -0.04, y = 0.163, z = 0.0176 },
			rot = { x = 0.0, y = 90.0, z = -180.0 },
			anim = { dict = "petcarinhoanimation@joao", name = "carinho_clip", flag = 49 }
		},
		name = "Gato Preto"
	},

	-- CACHORROS
	["husky"] = {
		category = "Pets",
		icon = "husky.png",
		prop = {
			model = "husky_by_joao",
			bone = 18905,
			pos = { x = 0.057, y = 0.019, z = 0.099 },
			rot = { x = 108.73, y = 14.53, z = -176.56 },
			anim = { dict = "segurandodoguinhoanim@joao", name = "doguinho_clip", flag = 49 }
		},
		name = "Husky"
	},
	["chowchow"] = {
		category = "Pets",
		icon = "chowchow.png",
		prop = {
			model = "chowchow_by_joao",
			bone = 18905,
			pos = { x = 0.06, y = 0.019, z = 0.12 },
			rot = { x = 108.73, y = 14.53, z = -176.56 },
			anim = { dict = "segurandodoguinhoanim@joao", name = "doguinho_clip", flag = 49 }
		},
		name = "Chowchow"
	},
	["sharpei"] = {
		category = "Pets",
		icon = "sharpei.png",
		prop = {
			model = "sharpei_by_joao",
			bone = 18905,
			pos = { x = 0.06, y = 0.019, z = 0.12 },
			rot = { x = 108.73, y = 14.53, z = -176.56 },
			anim = { dict = "segurandodoguinhoanim@joao", name = "doguinho_clip", flag = 49 }
		},
		name = "Sharpei"
	},
	["pug"] = {
		category = "Pets",
		icon = "pug.png",
		prop = {
			model = "pug_by_joao",
			bone = 18905,
			pos = { x = 0.06, y = 0.019, z = 0.12 },
			rot = { x = 108.73, y = 14.53, z = -176.56 },
			anim = { dict = "segurandodoguinhoanim@joao", name = "doguinho_clip", flag = 49 }
		},
		name = "Pug"
	},
	["spitz"] = {
		category = "Pets",
		icon = "spitz.png",
		prop = {
			model = "luludapomerania_by_joao",
			bone = 18905,
			pos = { x = 0.06, y = 0.019, z = 0.12 },
			rot = { x = 108.73, y = 14.53, z = -176.56 },
			anim = { dict = "segurandodoguinhoanim@joao", name = "doguinho_clip", flag = 49 }
		},
		name = "Spitz"
	},

	-- PODEROSAS
	["docinho"] = {
		category = "Poderosas",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "docinho.png",
		prop = {
			model = "jpx_molly_powerpuff_buttercup",
			bone = 24818,
			pos = { x = 0.30, y = 0.04, z = -0.30 },
			rot = { x = -90.0, y = -90.0, z = 0.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Docinho"
	},
	["florzinha"] = {
		category = "Poderosas",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "florzinha.png",
		prop = {
			model = "jpx_molly_powerpuff_blossom",
			bone = 64729,
			pos = { x = 0.20, y = 0.10, z = -0.08 },
			rot = { x = 90.0, y = 195.0, z = 170.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Florzinha"
	},
	["lindinha"] = {
		category = "Poderosas",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "lindinha.png",
		prop = {
			model = "jpx_molly_powerpuff_bubbles",
			bone = 12844,
			pos = { x = 0.15, y = 0.04, z = 0.00 },
			rot = { x = -90.0, y = -90.0, z = 0.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Lindinha"
	},

	-- POKEMON
	["pokemon2"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_pidgey.png",
		prop = {
			model = "jpx_pidgey",
			bone = 24818,
			pos = { x = 0.5, y = 0.0, z = 0.5 },
			rot = { x = 0.0, y = 90.0, z = 180.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Pidgey"
	},
	["pokemon3"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_butterfree.png",
		prop = {
			model = "jpx_butterfree",
			bone = 24818,
			pos = { x = 0.45, y = 0.0, z = 0.05 },
			rot = { x = 0.0, y = 90.0, z = 180.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Butterfree"
	},
	["pokemon4"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_jigglypuff.png",
		prop = {
			model = "jpx_jigglypuff",
			bone = 10706,
			pos = { x = 0.15, y = 0.0, z = 0.15 },
			rot = { x = 0.0, y = 10.0, z = 200.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Jigglypuff"
	},
	["pokemon5"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_bulbasaur.png",
		prop = {
			model = "jpx_bulbasaur",
			bone = 20190,
			pos = { x = -0.2, y = 0.0, z = -1.0 },
			rot = { x = 0.0, y = 0.0, z = 180.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Bulbasaur"
	},
	["pokemon6"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_poliwhirl.png",
		prop = {
			model = "jpx_poliwhirl",
			bone = 20190,
			pos = { x = 0.5, y = 0.0, z = -0.82 },
			rot = { x = 0.0, y = 0.0, z = 180.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Poliwhirl"
	},
	["pokemon7"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_magikarp.png",
		prop = {
			model = "jpx_magikarp",
			bone = 20190,
			pos = { x = 0.0, y = 0.0, z = -0.45 },
			rot = { x = 0.0, y = 0.0, z = 0.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Magikarp"
	},
	["pokemon8"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_squirtle.png",
		prop = {
			model = "jpx_squirtle",
			bone = 40269,
			pos = { x = 0.3, y = 0.05, z = 0.12 },
			rot = { x = 0.0, y = 0.0, z = 180.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Squirtle"
	},
	["pokemon9"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_meowth.png",
		prop = {
			model = "jpx_meowth",
			bone = 46078,
			pos = { x = -0.03, y = 0.07, z = -0.17 },
			rot = { x = 30.0, y = 200.0, z = 190.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Meowth"
	},
	["pokemon10"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_psyduck.png",
		prop = {
			model = "jpx_psyduck",
			bone = 16335,
			pos = { x = 0.05, y = 0.0, z = 0.18 },
			rot = { x = 0.0, y = 0.0, z = 180.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Psyduck"
	},
	["pokemon11"] = {
		category = "Pokemon",
		hidden = true, -- personagem com direitos autorais (marca)
		icon = "jpx_charmander.png",
		prop = {
			model = "jpx_charmander",
			bone = 45509,
			pos = { x = 0.01, y = -0.04, z = -0.1 },
			rot = { x = 0.0, y = 220.0, z = 180.0 },
			anim = { dict = "", name = "", flag = 49 }
		},
		name = "Charmander"
	},

	-- BANGUELA
	["banguela_branco"] = {
		category = "Banguela",
		hidden = true, -- personagem com direitos autorais (marca)
		prop = {
			model = "jpx_light_fury_mount",
			positions = {
				{
					id = "na_mao",
					label = "Mão",
					bone = 12844,
					pos = { x = -0.03, y = 0.15, z = 0.03 },
					rot = { x = 0.0, y = 90.0, z = 180.0 },
					model = "jpx_light_fury_mount",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "no_ombro",
					label = "Ombro",
					bone = 64729,
					pos = { x = 0.18, y = -0.02, z = -0.13 },
					rot = { x = -10.0, y = 180.0, z = -190.0 },
					model = "jpx_light_fury_shoulder",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "segurando",
					label = "Segurando",
					bone = 45509,
					pos = { x = 0.55, y = 0.07, z = -0.07 },
					rot = { x = 0.0, y = 240.0, z = 180.0 },
					model = "jpx_light_fury_hold",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "no_chao",
					label = "Chão",
					bone = 20190,
					pos = { x = 0.85, y = 0.0, z = -0.82 },
					rot = { x = 0.0, y = 0.0, z = 210.0 },
					model = "jpx_light_fury_ground",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "flutuando",
					label = "Flutuando",
					bone = 20190,
					pos = { x = -0.5, y = 0.0, z = 0.8 },
					rot = { x = 0.0, y = 0.0, z = 180.0 },
					model = "jpx_light_fury_float",
					anim = { dict = "", name = "", flag = 49 }
				}
			}
		},
		icon = "Light.png",
		name = "Fúria da Luz"
	},
	["banguela_preto"] = {
		category = "Banguela",
		hidden = true, -- personagem com direitos autorais (marca)
		rarity = "epic",
		prop = {
			model = "jpx_toothless_head",
			positions = {
				{
					id = "na_mao",
					label = "Mão",
					bone = 12844,
					pos = { x = 0.29, y = 0.08, z = 0.0 },
					rot = { x = 0.0, y = -270.0, z = 180.0 },
					model = "jpx_toothless_head",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "no_ombro",
					label = "Ombro",
					bone = 10706,
					pos = { x = 0.11, y = 0.01, z = 0.21 },
					rot = { x = 0.0, y = 15.0, z = 170.0 },
					model = "jpx_toothless_shoulder",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "segurando",
					label = "Segurando",
					bone = 40269,
					pos = { x = 0.4, y = 0.06, z = 0.1 },
					rot = { x = 0.0, y = -70.0, z = 200.0 },
					model = "jpx_toothless_hold",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "no_chao",
					label = "Chão",
					bone = 20190,
					pos = { x = 0.45, y = -0.2, z = -1.0 },
					rot = { x = 0.0, y = 0.0, z = 180.0 },
					model = "jpx_toothless_ground",
					anim = { dict = "", name = "", flag = 49 }
				},
				{
					id = "flutuando",
					label = "Flutuando",
					bone = 20190,
					pos = { x = 0.5, y = 0.0, z = 0.8 },
					rot = { x = 0.0, y = 0.0, z = 180.0 },
					model = "jpx_toothless_float",
					anim = { dict = "", name = "", flag = 49 }
				}
			}
		},
		icon = "Toothless.png",
		name = "Banguela"
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLUSHIESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlushieSlot(plushieId, positionId)
	local item = CollectionsCatalog[plushieId]
	if not item or not item.prop then return "default" end

	local posData = nil
	if positionId and item.prop.positions then
		for _, p in ipairs(item.prop.positions) do
			if p.id == positionId then
				posData = p
				break
			end
		end
	end

	local posId = positionId or (posData and posData.id)
	if posId then
		if posId == "no_ombro" or posId == "ombro" then return "ombro" end
		if posId == "ombro_direito" then return "ombro_direito" end
		if posId == "ombro_esquerdo" then return "ombro_esquerdo" end
		if posId == "na_mao" or posId == "segurando" or posId == "segurando2" or posId == "hold" then return "mao" end
		if posId == "na_perna" then return "perna" end
		if posId == "no_colo" then return "colo" end
		if posId == "nas_costas" then return "costas" end
		if posId == "cabeca" then return "cabeca" end
		if posId == "no_chao" or posId == "walk" then return "chao" end
		if posId == "flutuando" or posId == "fly" then return "flutuando" end
		if posId == "dance" then return "dance" end
		return posId
	end

	local bone = item.prop.bone
	if bone == 18905 or bone == 40269 or bone == 45509 or bone == 12844 then
		return "mao"
	elseif bone == 64729 then
		return "ombro_direito"
	elseif bone == 10706 then
		return "ombro_esquerdo"
	elseif bone == 31086 then
		return "cabeca"
	elseif bone == 51826 then
		return "perna"
	elseif bone == 20190 then
		return "chao"
	elseif bone == 16335 then
		return "flutuando"
	elseif bone == 24818 then
		if item.category == "Gatos" then
			return "colo"
		else
			return "costas"
		end
	end

	return "default"
end