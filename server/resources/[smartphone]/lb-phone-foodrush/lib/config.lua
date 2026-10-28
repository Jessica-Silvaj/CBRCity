
-- config.lua - FoodRush Delivery App
Config = {}

-- Configurações Gerais
Config.createTables = true -- Define se as tabelas do banco de dados devem ser criadas automaticamente
Config.Debug = false
Config.UseNotifications = true
Config.DeliveryRadius = 500.0 -- Raio máximo de entrega em metros
Config.OrderTimeout = 1800 -- Tempo limite do pedido em segundos (30 min)
Config.DeliveryTimeout = 3600 -- Tempo limite da entrega em segundos (60 min)

-- Configurações de Pagamento
Config.Payment = {
    Methods = {"dinheiro", "cartao", "pix"},
    MinDeliveryFee = 500, 
    pricePerKm = 900 

}

-- Configurações dos Entregadores
Config.Deliverer = {
    EarningsPercentage = 0.15, -- 15% do valor do pedido para o entregador
    BonusPerDelivery = 200, -- Bônus fixo por entrega (R$ 2,00)
    MaxActiveDeliveries = 3, -- Máximo de entregas simultâneas
}

-- Localização dos Restaurantes
Config.Restaurants = {
    {
        id = 1,
        name = "CatCafe",
        description = "O paraíso dos amantes de gatos! Desfrute de doces irresistíveis, cafés artesanais e lanches temáticos em um ambiente super aconchegante e fofinho.",
        logo = "catcafe.png",
        category = "diversos",
        rating = 5.0,
        deliveryTime = "15-30 min",
        isOpen = true,
        coords = vector3(-1536.03,-451.79,35.87),
        deliveryFee = 150,
        minOrder = 50,
        menu = {
            {
                id = "nigirizushi",
                name = "Nigirizushi",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/nigirizushi.png",
                category = "diversos",
                available = true
            },
            {
                id = "sushi",
                name = "Sushi",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sushi.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcake",
                name = "Cupcake",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcake.png",
                category = "diversos",
                available = true
            },
            {
                id = "applelove",
                name = "Maça do Amor",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/applelove.png",
                category = "diversos",
                available = true
            },
            {
                id = "cookies",
                name = "Cookies",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cookies.png",
                category = "diversos",
                available = true
            },
            {
                id = "hamburger2",
                name = "Hambúrguer Artesanal",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/hamburger2.png",
                category = "diversos",
                available = true
            },
            {
                id = "hamburger3",
                name = "Hambúrguer Vegetariano",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/hamburger3.png",
                category = "diversos",
                available = true
            },
            {
                id = "pizzamozzarella",
                name = "Pizza de Muçarela",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pizzamozzarella.png",
                category = "diversos",
                available = true
            },
            {
                id = "pizzabanana",
                name = "Pizza de Banana",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pizzabanana.png",
                category = "diversos",
                available = true
            },
            {
                id = "pizzachocolate",
                name = "Pizza de Chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pizzachocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "donut",
                name = "Rosquinha",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/donut.png",
                category = "diversos",
                available = true
            },
            {
                id = "fries",
                name = "Fritas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/fries.png",
                category = "diversos",
                available = true
            },
            {
                id = "hotdog",
                name = "Cachorro-Quente",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/hotdog.png",
                category = "diversos",
                available = true
            },
            {
                id = "sandwich",
                name = "Sanduiche",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sandwich.png",
                category = "diversos",
                available = true
            },
            {
                id = "tacos",
                name = "Tacos",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/tacos.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkshake",
                name = "Milk-shake",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkshake.png",
                category = "diversos",
                available = true
            },
            {
                id = "cappuccino",
                name = "Cappuccino",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cappuccino.png",
                category = "diversos",
                available = true
            },
            {
                id = "passionjuice",
                name = "Suco de Maracujá",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/passionjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "tangejuice",
                name = "Suco de Tangerina",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/tangejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "orangejuice",
                name = "Suco de Laranja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/orangejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "applejuice",
                name = "Suco de Maça",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/applejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "grapejuice",
                name = "Suco de Uva",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/grapejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "lemonjuice",
                name = "Suco de Limão",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/lemonjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "bananajuice",
                name = "Suco de Banana",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bananajuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "acerolajuice",
                name = "Suco de Acerola",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/acerolajuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "strawberryjuice",
                name = "Suco de Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/strawberryjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "blueberryjuice",
                name = "Suco de Blueberry",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/blueberryjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "coffeemilk",
                name = "Café com Leite",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coffeemilk.png",
                category = "diversos",
                available = true
            },
            {
                id = "water",
                name = "Garrafa de Água",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/water.png",
                category = "diversos",
                available = true
            },
            {
                id = "combo1",
                name = "Combo 1",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/combo1.png",
                category = "diversos",
                available = true
            },
            {
                id = "combo2",
                name = "Combo 2",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/combo2.png",
                category = "diversos",
                available = true
            },
            {
                id = "combo3",
                name = "Combo 3",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/combo3.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOPFELINO",
                name = "Combo Felino",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOPFELINO.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOMMIAW",
                name = "Combo Miaw",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOMMIAW.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOGGARFIELD",
                name = "Combo Garfield",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOGGARFIELD.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOBABYCAT",
                name = "Combo Baby",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOBABYCAT.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOPATINHAS",
                name = "Combo Patinhas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOPATINHAS.png",
                category = "diversos",
                available = true
            },
            {
                id = "catburger",
                name = "Cat burger",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/catburger.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkcereja",
                name = "Milkshake Cereja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkcereja.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkfrutos",
                name = "Milkshake Frutas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkfrutos.png",
                category = "diversos",
                available = true
            },
            {
                id = "mlkmorango",
                name = "Milkshake Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/mlkmorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkchocolate",
                name = "Milkshake Chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkchocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "pirulito",
                name = "Pirulito",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pirulito.png",
                category = "diversos",
                available = true
            },
            {
                id = "sorvete",
                name = "Sorvete",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sorvete.png",
                category = "diversos",
                available = true
            },
            {
                id = "cafe",
                name = "Cafe",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cafe.png",
                category = "diversos",
                available = true
            },
            {
                id = "mamadeira",
                name = "Mamadeira",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/mamadeira.png",
                category = "diversos",
                available = true
            },
            {
                id = "sorvete2",
                name = "Napolitano",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sorvete2.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkuwu",
                name = "Cat Milkshake",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkuwu.png",
                category = "diversos",
                available = true
            },
            {
                id = "marshmellow",
                name = "Marshmellow",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/marshmellow.png",
                category = "diversos",
                available = true
            },
            {
                id = "coxinha",
                name = "Coxinha",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coxinha.png",
                category = "diversos",
                available = true
            },
            {
                id = "chaverde",
                name = "Cha verde",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/chaverde.png",
                category = "diversos",
                available = true
            },
            {
                id = "melancia",
                name = "Melancia",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/melancia.png",
                category = "diversos",
                available = true
            },
            {
                id = "catpanqueca",
                name = "Cat panqueca",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/catpanqueca.png",
                category = "diversos",
                available = true
            },
            {
                id = "ursoburger",
                name = "Urso burger",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/ursoburger.png",
                category = "diversos",
                available = true
            },
            {
                id = "iogurtedemaca",
                name = "Iogurte de Maça",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/iogurtedemaca.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodekiwi",
                name = "Suco de Kiwi",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodekiwi.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodelimao",
                name = "Suco de Limão",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodelimao.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodelaranja",
                name = "Suco de Laranja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodelaranja.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodemorango",
                name = "Suco de Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "pudimdeuva",
                name = "Pudim de uva",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pudimdeuva.png",
                category = "diversos",
                available = true
            },
            {
                id = "tortadeamendoim",
                name = "Torta de Amendoim",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/tortadeamendoim.png",
                category = "diversos",
                available = true
            },
            {
                id = "torrada",
                name = "Torrada",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/torrada.png",
                category = "diversos",
                available = true
            },
            {
                id = "churros",
                name = "Churros",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/churros.png",
                category = "diversos",
                available = true
            },
            {
                id = "capuccino",
                name = "Capuccino",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/capuccino.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitecomcanela",
                name = "Leite com canela",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitecomcanela.png",
                category = "diversos",
                available = true
            },
            {
                id = "chocolatecremoso",
                name = "Chocolate cremoso",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/chocolatecremoso.png",
                category = "diversos",
                available = true
            },
            {
                id = "coelhodechocolate",
                name = "Coelho de chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coelhodechocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakerecheado",
                name = "Cupcake recheado",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakerecheado.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakedeabobora",
                name = "Cupcake de abóbora",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakedeabobora.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakededefranboesa",
                name = "Cupcake de franboesa",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakededefranboesa.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakedemorango",
                name = "Cupcake de morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakedemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakedelaranja",
                name = "Cupcake de laranja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakedelaranja.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolinhodecereja",
                name = "Bolinho de cereja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolinhodecereja.png",
                category = "diversos",
                available = true
            },
            {
                id = "supermilkshakerosa",
                name = "Super Milkshake Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/supermilkshakerosa.png",
                category = "diversos",
                available = true
            },
            {
                id = "supermilkshakechocolate",
                name = "Super Milkshake Choco",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/supermilkshakechocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "iogurtemorango",
                name = "Iogurte Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/iogurtemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolococo",
                name = "Bolo de coco",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolococo.png",
                category = "diversos",
                available = true
            },
            {
                id = "rocambolemorango",
                name = "Rocambole Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/rocambolemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodeuva",
                name = "Suco de Uva",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodeuva.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodemaca",
                name = "Suco de Maça",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodemaca.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodefrutas",
                name = "Suco de Frutas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodefrutas.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolodemorango",
                name = "Bolo de morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolodemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedemorango",
                name = "Leite de Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedebanana",
                name = "Leite de Banana",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedebanana.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedechocolate",
                name = "Leite de Chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedechocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "cereal",
                name = "Cereal",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cereal.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOSUNSET",
                name = "Combo Sunset",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOSUNSET.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOTROPICAL",
                name = "Combo Tropical",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOTROPICAL.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOMARECLASSICA",
                name = "Combo Maré Classica",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOMARECLASSICA.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOTROPICALIA",
                name = "Combo Tropicalia",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOTROPICALIA.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOFLAMINGOSUPREMO",
                name = "Combo Flamingo Supremo",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOFLAMINGOSUPREMO.png",
                category = "diversos",
                available = true
            },
            {
                id = "abacateovos",
                name = "Guacamole",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/abacateovos.png",
                category = "diversos",
                available = true
            },
            {
                id = "bibimbap",
                name = "Bibimbap",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bibimbap.png",
                category = "diversos",
                available = true
            },
            {
                id = "bifeepao",
                name = "Bife e Pao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bifeepao.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolocarne",
                name = "Bolo de Carne",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolocarne.png",
                category = "diversos",
                available = true
            },
            {
                id = "caviarvermelho",
                name = "Caviar vermelho",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/caviarvermelho.png",
                category = "diversos",
                available = true
            },
            {
                id = "eggsbenedict",
                name = "Eggs benedict",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/eggsbenedict.png",
                category = "diversos",
                available = true
            },
            {
                id = "peixebatata",
                name = "Peixe Batata",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/peixebatata.png",
                category = "diversos",
                available = true
            },
            {
                id = "purebatata",
                name = "Pure de Batata",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/purebatata.png",
                category = "diversos",
                available = true
            },
            {
                id = "salada",
                name = "Salada",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/salada.png",
                category = "diversos",
                available = true
            },
            {
                id = "salmaomolho",
                name = "Salmao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/salmaomolho.png",
                category = "diversos",
                available = true
            },
            {
                id = "wafflesgelado",
                name = "Waffles gelado",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/wafflesgelado.png",
                category = "diversos",
                available = true
            },
            {
                id = "coquetelcarambola",
                name = "Coquetel Carambola",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coquetelcarambola.png",
                category = "diversos",
                available = true
            },
            {
                id = "coquetellaranjaelimao",
                name = "Coquetel Laranjae Limao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coquetellaranjaelimao.png",
                category = "diversos",
                available = true
            },
            {
                id = "daiquiridemorango",
                name = "Daiquiride morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/daiquiridemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedecoco",
                name = "Leite de coco",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedecoco.png",
                category = "diversos",
                available = true
            },
            {
                id = "limonada",
                name = "Limonada",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/limonada.png",
                category = "diversos",
                available = true
            },
            {
                id = "mangaelimao",
                name = "Batida de Manga",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/mangaelimao.png",
                category = "diversos",
                available = true
            },
            {
                id = "morangoemanga",
                name = "Vitamina",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/morangoemanga.png",
                category = "diversos",
                available = true
            },
            {
                id = "morangoepesego",
                name = "Limonada de Pessego",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/morangoepesego.png",
                category = "diversos",
                available = true
            },
            {
                id = "uvalimao",
                name = "Suco uva limao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/uvalimao.png",
                category = "diversos",
                available = true
            },
        }
    },
    {
        id = 2,
        name = "MooMooCafe",
        description = "A melhor cafeteria da cidade com deliciosos pratos rápidos, sobremesas refrescantes e combos incríveis para qualquer hora do seu dia!",
        logo = "moomoocafe.png",
        category = "diversos",
        rating = 5.0,
        deliveryTime = "15-30 min",
        isOpen = true,
        coords = vector3(-576.55,-1070.55,22.33),
        deliveryFee = 150,
        minOrder = 50,
        menu = {
            {
                id = "nigirizushi",
                name = "Nigirizushi",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/nigirizushi.png",
                category = "diversos",
                available = true
            },
            {
                id = "sushi",
                name = "Sushi",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sushi.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcake",
                name = "Cupcake",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcake.png",
                category = "diversos",
                available = true
            },
            {
                id = "applelove",
                name = "Maça do Amor",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/applelove.png",
                category = "diversos",
                available = true
            },
            {
                id = "cookies",
                name = "Cookies",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cookies.png",
                category = "diversos",
                available = true
            },
            {
                id = "hamburger2",
                name = "Hambúrguer Artesanal",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/hamburger2.png",
                category = "diversos",
                available = true
            },
            {
                id = "hamburger3",
                name = "Hambúrguer Vegetariano",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/hamburger3.png",
                category = "diversos",
                available = true
            },
            {
                id = "pizzamozzarella",
                name = "Pizza de Muçarela",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pizzamozzarella.png",
                category = "diversos",
                available = true
            },
            {
                id = "pizzabanana",
                name = "Pizza de Banana",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pizzabanana.png",
                category = "diversos",
                available = true
            },
            {
                id = "pizzachocolate",
                name = "Pizza de Chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pizzachocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "donut",
                name = "Rosquinha",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/donut.png",
                category = "diversos",
                available = true
            },
            {
                id = "fries",
                name = "Fritas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/fries.png",
                category = "diversos",
                available = true
            },
            {
                id = "hotdog",
                name = "Cachorro-Quente",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/hotdog.png",
                category = "diversos",
                available = true
            },
            {
                id = "sandwich",
                name = "Sanduiche",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sandwich.png",
                category = "diversos",
                available = true
            },
            {
                id = "tacos",
                name = "Tacos",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/tacos.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkshake",
                name = "Milk-shake",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkshake.png",
                category = "diversos",
                available = true
            },
            {
                id = "cappuccino",
                name = "Cappuccino",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cappuccino.png",
                category = "diversos",
                available = true
            },
            {
                id = "passionjuice",
                name = "Suco de Maracujá",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/passionjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "tangejuice",
                name = "Suco de Tangerina",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/tangejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "orangejuice",
                name = "Suco de Laranja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/orangejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "applejuice",
                name = "Suco de Maça",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/applejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "grapejuice",
                name = "Suco de Uva",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/grapejuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "lemonjuice",
                name = "Suco de Limão",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/lemonjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "bananajuice",
                name = "Suco de Banana",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bananajuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "acerolajuice",
                name = "Suco de Acerola",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/acerolajuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "strawberryjuice",
                name = "Suco de Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/strawberryjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "blueberryjuice",
                name = "Suco de Blueberry",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/blueberryjuice.png",
                category = "diversos",
                available = true
            },
            {
                id = "coffeemilk",
                name = "Café com Leite",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coffeemilk.png",
                category = "diversos",
                available = true
            },
            {
                id = "water",
                name = "Garrafa de Água",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/water.png",
                category = "diversos",
                available = true
            },
            {
                id = "combo1",
                name = "Combo 1",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/combo1.png",
                category = "diversos",
                available = true
            },
            {
                id = "combo2",
                name = "Combo 2",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/combo2.png",
                category = "diversos",
                available = true
            },
            {
                id = "combo3",
                name = "Combo 3",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/combo3.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOPFELINO",
                name = "Combo Felino",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOPFELINO.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOMMIAW",
                name = "Combo Miaw",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOMMIAW.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOGGARFIELD",
                name = "Combo Garfield",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOGGARFIELD.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOBABYCAT",
                name = "Combo Baby",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOBABYCAT.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOPATINHAS",
                name = "Combo Patinhas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOPATINHAS.png",
                category = "diversos",
                available = true
            },
            {
                id = "catburger",
                name = "Cat burger",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/catburger.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkcereja",
                name = "Milkshake Cereja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkcereja.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkfrutos",
                name = "Milkshake Frutas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkfrutos.png",
                category = "diversos",
                available = true
            },
            {
                id = "mlkmorango",
                name = "Milkshake Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/mlkmorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkchocolate",
                name = "Milkshake Chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkchocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "pirulito",
                name = "Pirulito",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pirulito.png",
                category = "diversos",
                available = true
            },
            {
                id = "sorvete",
                name = "Sorvete",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sorvete.png",
                category = "diversos",
                available = true
            },
            {
                id = "cafe",
                name = "Cafe",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cafe.png",
                category = "diversos",
                available = true
            },
            {
                id = "mamadeira",
                name = "Mamadeira",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/mamadeira.png",
                category = "diversos",
                available = true
            },
            {
                id = "sorvete2",
                name = "Napolitano",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sorvete2.png",
                category = "diversos",
                available = true
            },
            {
                id = "milkuwu",
                name = "Cat Milkshake",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/milkuwu.png",
                category = "diversos",
                available = true
            },
            {
                id = "marshmellow",
                name = "Marshmellow",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/marshmellow.png",
                category = "diversos",
                available = true
            },
            {
                id = "coxinha",
                name = "Coxinha",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coxinha.png",
                category = "diversos",
                available = true
            },
            {
                id = "chaverde",
                name = "Cha verde",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/chaverde.png",
                category = "diversos",
                available = true
            },
            {
                id = "melancia",
                name = "Melancia",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/melancia.png",
                category = "diversos",
                available = true
            },
            {
                id = "catpanqueca",
                name = "Cat panqueca",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/catpanqueca.png",
                category = "diversos",
                available = true
            },
            {
                id = "ursoburger",
                name = "Urso burger",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/ursoburger.png",
                category = "diversos",
                available = true
            },
            {
                id = "iogurtedemaca",
                name = "Iogurte de Maça",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/iogurtedemaca.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodekiwi",
                name = "Suco de Kiwi",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodekiwi.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodelimao",
                name = "Suco de Limão",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodelimao.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodelaranja",
                name = "Suco de Laranja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodelaranja.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodemorango",
                name = "Suco de Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "pudimdeuva",
                name = "Pudim de uva",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/pudimdeuva.png",
                category = "diversos",
                available = true
            },
            {
                id = "tortadeamendoim",
                name = "Torta de Amendoim",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/tortadeamendoim.png",
                category = "diversos",
                available = true
            },
            {
                id = "torrada",
                name = "Torrada",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/torrada.png",
                category = "diversos",
                available = true
            },
            {
                id = "churros",
                name = "Churros",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/churros.png",
                category = "diversos",
                available = true
            },
            {
                id = "capuccino",
                name = "Capuccino",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/capuccino.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitecomcanela",
                name = "Leite com canela",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitecomcanela.png",
                category = "diversos",
                available = true
            },
            {
                id = "chocolatecremoso",
                name = "Chocolate cremoso",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/chocolatecremoso.png",
                category = "diversos",
                available = true
            },
            {
                id = "coelhodechocolate",
                name = "Coelho de chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coelhodechocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakerecheado",
                name = "Cupcake recheado",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakerecheado.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakedeabobora",
                name = "Cupcake de abóbora",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakedeabobora.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakededefranboesa",
                name = "Cupcake de franboesa",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakededefranboesa.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakedemorango",
                name = "Cupcake de morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakedemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "cupcakedelaranja",
                name = "Cupcake de laranja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cupcakedelaranja.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolinhodecereja",
                name = "Bolinho de cereja",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolinhodecereja.png",
                category = "diversos",
                available = true
            },
            {
                id = "supermilkshakerosa",
                name = "Super Milkshake Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/supermilkshakerosa.png",
                category = "diversos",
                available = true
            },
            {
                id = "supermilkshakechocolate",
                name = "Super Milkshake Choco",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/supermilkshakechocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "iogurtemorango",
                name = "Iogurte Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/iogurtemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolococo",
                name = "Bolo de coco",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolococo.png",
                category = "diversos",
                available = true
            },
            {
                id = "rocambolemorango",
                name = "Rocambole Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/rocambolemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodeuva",
                name = "Suco de Uva",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodeuva.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodemaca",
                name = "Suco de Maça",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodemaca.png",
                category = "diversos",
                available = true
            },
            {
                id = "sucodefrutas",
                name = "Suco de Frutas",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/sucodefrutas.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolodemorango",
                name = "Bolo de morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolodemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedemorango",
                name = "Leite de Morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedebanana",
                name = "Leite de Banana",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedebanana.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedechocolate",
                name = "Leite de Chocolate",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedechocolate.png",
                category = "diversos",
                available = true
            },
            {
                id = "cereal",
                name = "Cereal",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/cereal.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOSUNSET",
                name = "Combo Sunset",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOSUNSET.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOTROPICAL",
                name = "Combo Tropical",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOTROPICAL.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOMARECLASSICA",
                name = "Combo Maré Classica",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOMARECLASSICA.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOTROPICALIA",
                name = "Combo Tropicalia",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOTROPICALIA.png",
                category = "diversos",
                available = true
            },
            {
                id = "COMBOFLAMINGOSUPREMO",
                name = "Combo Flamingo Supremo",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/COMBOFLAMINGOSUPREMO.png",
                category = "diversos",
                available = true
            },
            {
                id = "abacateovos",
                name = "Guacamole",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/abacateovos.png",
                category = "diversos",
                available = true
            },
            {
                id = "bibimbap",
                name = "Bibimbap",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bibimbap.png",
                category = "diversos",
                available = true
            },
            {
                id = "bifeepao",
                name = "Bife e Pao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bifeepao.png",
                category = "diversos",
                available = true
            },
            {
                id = "bolocarne",
                name = "Bolo de Carne",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/bolocarne.png",
                category = "diversos",
                available = true
            },
            {
                id = "caviarvermelho",
                name = "Caviar vermelho",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/caviarvermelho.png",
                category = "diversos",
                available = true
            },
            {
                id = "eggsbenedict",
                name = "Eggs benedict",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/eggsbenedict.png",
                category = "diversos",
                available = true
            },
            {
                id = "peixebatata",
                name = "Peixe Batata",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/peixebatata.png",
                category = "diversos",
                available = true
            },
            {
                id = "purebatata",
                name = "Pure de Batata",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/purebatata.png",
                category = "diversos",
                available = true
            },
            {
                id = "salada",
                name = "Salada",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/salada.png",
                category = "diversos",
                available = true
            },
            {
                id = "salmaomolho",
                name = "Salmao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/salmaomolho.png",
                category = "diversos",
                available = true
            },
            {
                id = "wafflesgelado",
                name = "Waffles gelado",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/wafflesgelado.png",
                category = "diversos",
                available = true
            },
            {
                id = "coquetelcarambola",
                name = "Coquetel Carambola",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coquetelcarambola.png",
                category = "diversos",
                available = true
            },
            {
                id = "coquetellaranjaelimao",
                name = "Coquetel Laranjae Limao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/coquetellaranjaelimao.png",
                category = "diversos",
                available = true
            },
            {
                id = "daiquiridemorango",
                name = "Daiquiride morango",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/daiquiridemorango.png",
                category = "diversos",
                available = true
            },
            {
                id = "leitedecoco",
                name = "Leite de coco",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/leitedecoco.png",
                category = "diversos",
                available = true
            },
            {
                id = "limonada",
                name = "Limonada",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/limonada.png",
                category = "diversos",
                available = true
            },
            {
                id = "mangaelimao",
                name = "Batida de Manga",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/mangaelimao.png",
                category = "diversos",
                available = true
            },
            {
                id = "morangoemanga",
                name = "Vitamina",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/morangoemanga.png",
                category = "diversos",
                available = true
            },
            {
                id = "morangoepesego",
                name = "Limonada de Pessego",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/morangoepesego.png",
                category = "diversos",
                available = true
            },
            {
                id = "uvalimao",
                name = "Suco uva limao",
                description = "",
                price = 150,
                image = "nui://vrp/config/inventory/uvalimao.png",
                category = "diversos",
                available = true
            },
        }
    },
}

-- Categorias de Comida
Config.FoodCategories = {
    {id = "hamburger",
                name = "Hambúrguer", icon = "🍔"},
    {id = "pizza", name = "Pizzas", icon = "🍕"},
    {id = "japonesa", name = "Japonesa", icon = "🍣"},
    {id = "mexicana", name = "Mexicana", icon = "🌮"},
    {id = "italiana", name = "Italiana", icon = "🍝"},
    {id = "brasileira", name = "Brasileira", icon = "🍛"},
    {id = "bebida", name = "Bebidas", icon = "🥤"},
    {id = "sobremesa", name = "Sobremesas", icon = "🍰"}
}

-- Status dos Pedidos
Config.OrderStatus = {
    PENDING = "pending",           -- Aguardando confirmação
    CONFIRMED = "confirmed",       -- Confirmado pelo restaurante
    PREPARING = "preparing",       -- Em preparo
    READY = "ready",              -- Pronto para entrega
    PICKUP = "pickup",            -- Coletado pelo entregador
    DELIVERING = "delivering",     -- Em rota de entrega
    DELIVERED = "delivered",       -- Entregue
    CANCELLED = "cancelled"        -- Cancelado
}

-- Tipos de Usuário
Config.UserTypes = {
    CUSTOMER = "customer",
    DELIVERER = "deliverer",
    RESTAURANT = "restaurant"
}

-- Configurações do Banco de Dados
Config.Database = {
    Tables = {
        orders = "foodrush_orders",
        deliverers = "foodrush_deliverers", 
        restaurants = "foodrush_restaurants",
        order_items = "foodrush_order_items",
        deliveries = "foodrush_deliveries"
    }
}

-- Funções Utilitárias
function Config.GetRestaurantById(id)
    for _, restaurant in ipairs(Config.Restaurants) do
        if restaurant.id == id then
            return restaurant
        end
    end
    return nil
end

function Config.GetMenuItem(restaurantId, itemId)
    local restaurant = Config.GetRestaurantById(restaurantId)
    if restaurant then
        for _, item in ipairs(restaurant.menu) do
            if item.id == itemId then
                return item
            end
        end
    end
    return nil
end


function Config.CalculateDeliveryFee(distance, restaurantId)
    local pricePerKm = tonumber(Config.Payment.pricePerKm) or 0

    local restaurant = Config.GetRestaurantById(restaurantId)

    local baseFee = Config.Payment.MinDeliveryFee

    return parseInt(distance / 1000 * pricePerKm + baseFee)
end

function Config.FormatPrice(price)
    return string.format("R$ %d,00", price)
end

function Config.GenerateOrderCode()
    return string.format("%04d", math.random(1000, 9999))
end

return Config