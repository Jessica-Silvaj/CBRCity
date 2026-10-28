Config.Creator = {
    Coords = { x = CreatorCoords.x, y = CreatorCoords.y, z = CreatorCoords.z, h = CreatorCoords.w },
    Spawn = { x = SpawnCoords[1].x, y = SpawnCoords[1].y, z = SpawnCoords[1].z, h = SpawnCoords[1].w },
    Cutscene = Cutscene,

    Default = {
        Appearance = {
            ["m"] = BarbershopInit.mp_m_freemode_01,
            ["f"] = BarbershopInit.mp_f_freemode_01
        },
        Clothes = { 
            ["mask"] = { ["m"] = SkinshopInit.mp_m_freemode_01.mask, ["f"] = SkinshopInit.mp_f_freemode_01.mask },
            ["arms"] = { ["m"] = SkinshopInit.mp_m_freemode_01.arms, ["f"] = SkinshopInit.mp_f_freemode_01.arms },
            ["pants"] = { ["m"] = SkinshopInit.mp_m_freemode_01.pants, ["f"] = SkinshopInit.mp_f_freemode_01.pants },
            ["backpack"] = { ["m"] = SkinshopInit.mp_m_freemode_01.backpack, ["f"] = SkinshopInit.mp_f_freemode_01.backpack },  
            ["shoes"] = { ["m"] = SkinshopInit.mp_m_freemode_01.shoes, ["f"] = SkinshopInit.mp_f_freemode_01.shoes },
            ["accessory"] = { ["m"] = SkinshopInit.mp_m_freemode_01.accessory, ["f"] = SkinshopInit.mp_f_freemode_01.accessory }, 
            ["tshirt"] = { ["m"] = SkinshopInit.mp_m_freemode_01.tshirt, ["f"] = SkinshopInit.mp_f_freemode_01.tshirt }, 
            ["vest"] = { ["m"] = SkinshopInit.mp_m_freemode_01.vest, ["f"] = SkinshopInit.mp_f_freemode_01.vest },
            ["torso"] = { ["m"] = SkinshopInit.mp_m_freemode_01.torso, ["f"] = SkinshopInit.mp_f_freemode_01.torso },
            ["hat"] = { ["m"] = SkinshopInit.mp_m_freemode_01.hat, ["f"] = SkinshopInit.mp_f_freemode_01.hat },  
            ["glass"] = { ["m"] = SkinshopInit.mp_m_freemode_01.glass, ["f"] = SkinshopInit.mp_f_freemode_01.glass }
        }
    }, 

    Fathers = {
        [1] = { id = 0, name = 'benjamin' },
        [2] = { id = 1, name = 'daniel' },
        [3] = { id = 2, name = 'joshua' },
        [4] = { id = 3, name = 'noah' },
        [5] = { id = 4, name = 'andrew' },
        [6] = { id = 5, name = 'joan' },
        [7] = { id = 6, name = 'alex' },
        [8] = { id = 7, name = 'isaac' },
        [9] = { id = 8, name = 'evan' },
        [10] = { id = 9, name = 'ethan' },
        [11] = { id = 10, name = 'vincent' },
        [12] = { id = 11, name = 'angel' },
        [13] = { id = 12, name = 'diego' },
        [14] = { id = 13, name = 'adrian' },
        [15] = { id = 14, name = 'gabriel' },
        [16] = { id = 15, name = 'michael' },
        [17] = { id = 16, name = 'santiago' },
        [18] = { id = 17, name = 'kevin' },
        [19] = { id = 18, name = 'louis' },
        [20] = { id = 19, name = 'samuel' },
        [21] = { id = 20, name = 'anthony' },
        [22] = { id = 42, name = 'claude' },
        [23] = { id = 43, name = 'niko' },
        [24] = { id = 44, name = 'john' },
    },

    Mothers = {
        [1] = { id = 21, name = 'hannah' },
        [2] = { id = 22, name = 'audrey' },
        [3] = { id = 23, name = 'jasmine' },
        [4] = { id = 24, name = 'giselle' },
        [5] = { id = 25, name = 'amelia' },
        [6] = { id = 26, name = 'isabella' },
        [7] = { id = 27, name = 'zoe' },
        [8] = { id = 28, name = 'ava' },
        [9] = { id = 29, name = 'camila' },
        [10] = { id = 30, name = 'violet' },
        [11] = { id = 31, name = 'sophia' },
        [12] = { id = 32, name = 'evelyn' },
        [13] = { id = 33, name = 'nicole' },
        [14] = { id = 34, name = 'ashley' },
        [15] = { id = 35, name = 'grace' },
        [16] = { id = 36, name = 'brianna' },
        [17] = { id = 37, name = 'natalie' },
        [18] = { id = 38, name = 'olivia' },
        [19] = { id = 39, name = 'elizabeth' },
        [20] = { id = 40, name = 'charlotte' },
        [21] = { id = 41, name = 'emma' },
        [22] = { id = 45, name = 'misty' },
    },  

    Characteristics = {
        ["noseWidth"] = {
            title = "Largura do Nariz",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "nose"
        },
        ["noseLength"] = {
            title = "Comprimento do Nariz",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "nose"
        },
        ["noseBridge"] = {
            title = "Curvatura do Nariz",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "nose"
        },
        ["noseTip"] = {
            title = "Ponta do Nariz",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "nose"
        },
        ["noseShift"] = {
            title = "Deslocamento do Nariz",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "nose"
        },
        ["noseHeight"] = {
            title = "Altura do Nariz",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "nose"
        },
        ["cheekboneHeight"] = {
            title = "Altura das Bochechas",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "hair"
        },
        ["cheekboneWidth"] = {
            title = "Largura das Bochechas",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "hair"
        },
        ["cheeksWidth"] = {
            title = "Tamanho das Bochechas",
            min = 0.0,
            max = 0.99,
            step = 0.01,
            camera = "hair"
        },
        ["lips"] = {
            title = "Labios",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "lips"
        },
        ["jawWidth"] = {
            title = "Largura da Mandibula",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "hair"
        },
        ["jawHeight"] = {
            title = "Altura da Mandibula",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "hair"
        },
        ["chinLength"] = {
            title = "Tamanho do Queixo",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "chin"
        },
        ["chinPosition"] = {
            title = "Posição do Queixo",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "chin"
        },
        ["chinWidth"] = {
            title = "Largura do Queixo",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "chin"
        },
        ["chinShape"] = {
            title = "Forma do Queixo",
            min = 0.0,
            max = 0.99,
            step = 0.01,
            camera = "chin"
        },
        ["neckWidth"] = {
            title = "Largura do Pescoço",
            min = 0,
            max = 0.99,
            step = 0.01,
            camera = "neck"
        }
    },

    -- order: posição na tela | type = "color": abre a paleta (palette = "hair" ou "makeup") | type = "opacity": intensidade 0-100%
    Appearance = {
        ["eyesColor"] = {
            title = "Cor dos Olhos",
            min = 0,
            max = 31,
            step = 1,
            camera = "eyes",
            order = 1
        },
        ["eyesOpening"] = {
            title = "Abertura dos Olhos",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "eyes",
            order = 2
        },
        ["eyebrowsHeight"] = {
            title = "Altura da Sobrancelha",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "eyes",
            order = 3
        },
        ["eyebrowsWidth"] = {
            title = "Largura da Sobrancelha",
            min = -0.99,
            max = 0.99,
            step = 0.01,
            camera = "eyes",
            order = 4
        },
        ["eyebrow"] = {
            title = "Sobrancelhas",
            min = 0,
            max = 33,
            step = 1,
            camera = "eyes",
            order = 5
        },
        ["eyebrowColor"] = {
            title = "Cor das Sobrancelhas",
            min = 0,
            max = 63,
            step = 1,
            camera = "eyes",
            order = 6,
            type = "color",
            palette = "hair"
        },
        ["eyebrowOpacity"] = {
            title = "Intensidade das Sobrancelhas",
            min = 0,
            max = 100,
            step = 1,
            camera = "eyes",
            order = 7,
            type = "opacity",
            default = 100
        },
        ["blush"] = {
            title = "Blush",
            min = -1,
            max = 33,
            step = 1,
            camera = "hair",
            order = 8
        },
        ["blushColor"] = {
            title = "Cor do Blush",
            min = 0,
            max = 63,
            step = 1,
            camera = "hair",
            order = 9,
            type = "color",
            palette = "makeup"
        },
        ["blushOpacity"] = {
            title = "Intensidade do Blush",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 10,
            type = "opacity",
            default = 100
        },
        ["lipstick"] = {
            title = "Batom",
            min = -1,
            max = 63,
            step = 1,
            camera = "lips",
            order = 11
        },
        ["lipstickColor"] = {
            title = "Cor do Batom",
            min = 0,
            max = 63,
            step = 1,
            camera = "lips",
            order = 12,
            type = "color",
            palette = "makeup"
        },
        ["lipstickOpacity"] = {
            title = "Intensidade do Batom",
            min = 0,
            max = 100,
            step = 1,
            camera = "lips",
            order = 13,
            type = "opacity",
            default = 100
        },
        ["makeup"] = {
            title = "Maquiagem",
            min = -1,
            max = 81,
            step = 1,
            camera = "hair",
            order = 14
        },
        ["makeupOpacity"] = {
            title = "Intensidade da Maquiagem",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 15,
            type = "opacity",
            default = 100
        },
        ["blemishes"] = {
            title = "Manchas",
            min = -1,
            max = 23,
            step = 1,
            camera = "hair",
            order = 16
        },
        ["blemishesOpacity"] = {
            title = "Intensidade das Manchas",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 17,
            type = "opacity",
            default = 100
        },
        ["ageing"] = {
            title = "Envelhecimento",
            min = -1,
            max = 14,
            step = 1,
            camera = "hair",
            order = 18
        },
        ["ageingOpacity"] = {
            title = "Intensidade do Envelhecimento",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 19,
            type = "opacity",
            default = 100
        },
        ["complexion"] = {
            title = "Aspecto",
            min = -1,
            max = 11,
            step = 1,
            camera = "hair",
            order = 20
        },
        ["complexionOpacity"] = {
            title = "Intensidade do Aspecto",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 21,
            type = "opacity",
            default = 100
        },
        ["sundamage"] = {
            title = "Dano Solar",
            min = -1,
            max = 10,
            step = 1,
            camera = "hair",
            order = 22
        },
        ["sundamageOpacity"] = {
            title = "Intensidade do Dano Solar",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 23,
            type = "opacity",
            default = 100
        },
        ["freckles"] = {
            title = "Sardas",
            min = -1,
            max = 17,
            step = 1,
            camera = "hair",
            order = 24
        },
        ["frecklesOpacity"] = {
            title = "Intensidade das Sardas",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 25,
            type = "opacity",
            default = 100
        },
    },

    Hair = {
        ["hair"] = {
            title = "Corte de Cabelo",
            min = 0,
            max = 79,
            step = 1,
            camera = "hair",
            order = 1
        },
        ["hairColor"] = {
            title = "Cor do Cabelo",
            min = 0,
            max = 63,
            step = 1,
            camera = "hair",
            order = 2,
            type = "color",
            palette = "hair"
        },
        ["hairSecondColor"] = {
            title = "Luzes do Cabelo",
            min = 0,
            max = 63,
            step = 1,
            camera = "hair",
            order = 3,
            type = "color",
            palette = "hair"
        },
        ["beard"] = {
            title = "Corte de Barba",
            min = -1,
            max = 28,
            step = 1,
            camera = "hair",
            order = 4
        },
        ["beardColor"] = {
            title = "Cor da Barba",
            min = 0,
            max = 63,
            step = 1,
            camera = "hair",
            order = 5,
            type = "color",
            palette = "hair"
        },
        ["beardOpacity"] = {
            title = "Intensidade da Barba",
            min = 0,
            max = 100,
            step = 1,
            camera = "hair",
            order = 6,
            type = "opacity",
            default = 100
        },
        ["chest"] = {
            title = "Pelos Corporais",
            min = -1,
            max = 16,
            step = 1,
            camera = "torso",
            order = 7
        },
        ["chestColor"] = {
            title = "Cor dos Pelos Corporais",
            min = 0,
            max = 63,
            step = 1,
            camera = "torso",
            order = 8,
            type = "color",
            palette = "hair"
        },
        ["chestOpacity"] = {
            title = "Intensidade dos Pelos Corporais",
            min = 0,
            max = 100,
            step = 1,
            camera = "torso",
            order = 9,
            type = "opacity",
            default = 100
        },
    }
}
