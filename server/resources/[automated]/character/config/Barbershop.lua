Config.Barbershop = {
    MarkerTitle = "BARBEARIA",
	Command = {
		Name = "barbershop",
		Permissions = {
			["Admin"] = 3
		}
	},

    Map = {
        ["hair"] = {
            ["hair"] = {
                price = 250,
            },
            ["hairColor"] = {
                title = "Cor do Cabelo",
                min = 0,
                max = 63,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["hairSecondColor"] = {
                title = "Luzes do Cabelo",
                min = 0,
                max = 63,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["beard"] = {
                title = "Corte de Barba",
                min = -1,
                max = 28,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["beardColor"] = {
                title = "Cor da Barba",
                min = -1,
                max = 63,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["chest"] = {
                title = "Pelos Corporais",
                min = -1,
                max = 16,
                step = 1,
                price = 250,
                camera = "torso"
            },
            ["chestColor"] = {
                title = "Cor dos Pelos Corporais",
                min = 0,
                max = 63,
                step = 1,
                price = 250,
                camera = "torso"
            }
        },
        ["makeup"] = {
            ["blush"] = {
                title = "Blush",
                min = -1,
                max = 33,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["blushColor"] = {
                title = "Cor do Blush",
                min = 0,
                max = 63,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["lipstick"] = {
                title = "Batom",
                min = -1,
                max = 63,
                step = 1,
                price = 250,
                camera = "lips"
            },
            ["blemishes"] = {
                title = "Manchas",
                min = -1,
                max = 23,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["makeup"] = {
                title = "Maquiagem",
                min = -1,
                max = 81,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["ageing"] = {
                title = "Envelhecimento",
                min = -1,
                max = 14,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["complexion"] = {
                title = "Aspecto",
                min = -1,
                max = 11,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["complexion"] = {
                title = "Dano Solar",
                min = -1,
                max = 10,
                step = 1,
                price = 250,
                camera = "hair"
            },
            ["freckles"] = {
                title = "Sardas",
                min = -1,
                max = 17,
                step = 1,
                price = 250,
                camera = "hair"
            }
        }
    },
    
    Locations = {}
}

    