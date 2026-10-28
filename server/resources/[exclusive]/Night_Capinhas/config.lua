Config = {}

-- Catálogo de capinhas (prop streamado em [addons]/[props]/phone_cases)
-- gems = preço em gemas | money = preço em dinheiro (nil = não vendida por dinheiro)
Config.Cases = {
    { prop = "ipbrown", label = "Bear Marrom", gems = 30 },
    { prop = "bearx_or", label = "Bear X Laranja", gems = 45 },
    { prop = "bearx_b", label = "Bear X Preta", gems = 45 },
    { prop = "bearx_whiteor", label = "Bear X Branca/Laranja", gems = 50 },
    { prop = "bearx_w", label = "Bear X Branca", gems = 40 },
    { prop = "bowconque_phone", label = "Bow Conque", gems = 40 },
    { prop = "bunnywish", label = "Coelho Sonhador", gems = 60 },
    { prop = "chin_phone", label = "Chin", gems = 30 },
    { prop = "conque_phone", label = "Conque", gems = 40 },
    { prop = "redpanda_phone", label = "Red Panda", gems = 45 },
    { prop = "shiro_phone", label = "Shiro", gems = 30 },
    { prop = "y2k_phone", label = "Y2K", gems = 30 }
}

-- Celulares default do GTA que aceitam swap pela capinha (consultado no tvRP.createObjects)
Config.DefaultPhones = {
    "prop_npc_phone_02",
    "prop_npc_phone",
    "prop_amb_phone",
    "prop_phone_ing",
    "prop_phone_ing_02",
    "prop_phone_ing_03",
    "prop_amb_vallphone"
}

-- Attach do preview na mão (o uso real do celular anexa via tvRP.createObjects)
Config.Attach = {
    bone = 28422,
    pos = { 0.0, 0.0, 0.0 },
    rot = { 0.0, 0.0, 0.0 }
}

-- Offsets individuais por prop
Config.PropAttach = {
    ["bunnywish"] = { pos = { 0.012, 0.003, -0.045 } }
}

Config.CustomCase = {
    enabled = false,
    label = "Faça sua capinha personalizada",
    url = "https://discord.gg/56xBTWj8Ks"
}

Config.Shop = {
    coords = vector3(-630.01, -279.19, 35.57),
    label = "Abrir Loja de Capinhas",
    icon = "fa-solid fa-mobile-screen-button",
    distance = 2.0,
    blip = {
        enabled = false,
        sprite = 459,
        color = 3,
        scale = 0.4,
        name = "Capinhas de Celular"
    }
}

-- Imagens dos cards: CFG_ServerCDN .. Config.Images.path .. prop .. Config.Images.ext
Config.Images = {
    path = "resources/smartphone/cases/case_phone_",
    ext = "_semtex.webp"
}
