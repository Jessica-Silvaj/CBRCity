-----------------------------------------------------------------------------------------------------------------------------------------
-- NIGHT TOTEM - CONFIGURACAO
-----------------------------------------------------------------------------------------------------------------------------------------
Totem = {}

-- Cor hexadecimal padrao exibida nos paineis do totem
-- Pode ser sobrescrita individualmente em cada entrada de Totem.Restaurants
Totem.DefaultThemeColor = "#2E8B57"

-----------------------------------------------------------------------------------------------------------------------------------------
-- MOEDA
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.Currency = {
    -- Prefixo exibido antes do valor monetario (ex: "R$ ", "$ ", "EUR ")
    Prefix = "R$ ",
    -- Sufixo exibido apos o valor monetario (ex: "", " BRL")
    Suffix = "",
    -- Separador de milhar (ex: "." para 1.000.000 ou "," para 1,000,000)
    Separator = ".",
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- IMAGENS
-----------------------------------------------------------------------------------------------------------------------------------------
Totem.Images = {
    -- URL base para as imagens dos itens
    BaseUrl = "nui://vrp/config/inventory/",
    -- Extensao dos arquivos de imagem
    Extension = ".png",
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.Stock = {
    -- Estoque inicial ao criar o item no banco de dados
    DefaultStock = 0,
    -- Estoque maximo por item
    MaxStock = 200,
    -- Se true, o admin precisa ter os itens no inventario para reabastecer
    RequireItems = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SMART STOCK (fallback de operacao)
-- Ajuda quando nao ha funcionarios online para reabastecer.
-----------------------------------------------------------------------------------------------------------------------------------------
Totem.SmartStock = {
    -- Ativa toda a rotina de validacao automatica
    Enabled = true,

    -- Notifica quando este totem estiver sem estoque, mas existir outro totem da cidade com estoque
    NotifyWhenOtherTotemHasStock = true,

    -- Marca automaticamente o GPS do jogador para o totem com estoque mais proximo
    MarkNearestTotemWithStock = true,

    -- Notifica quando nao existir nenhum membro online no GroupName do restaurante
    NotifyWhenNoGroupOnline = true,

    -- Notifica quando o totem continuar sem estoque apos as validacoes
    NotifyWhenOutOfStock = true,

    -- Notifica todos os membros online do grupo do restaurante quando
    -- um jogador abrir o totem e ele estiver sem estoque.
    NotifyRestaurantMembersWhenOutOfStock = true,

    -- Cooldown por totem para evitar spam dessas notificacoes para a equipe
    RestaurantNotifyCooldownSeconds = 120,

    Messages = {
        OtherTotemStock = "Sem estoque aqui. Use o totem %s (estoque total: %s).",
        WaypointSetShort = "GPS marcado no mapa para esse totem.",
        NoGroupOnline = "Nao ha funcionarios de %s online para reabastecer agora.",
        OutOfStock = "Este totem esta sem estoque no momento.",
        AutoRestocked = "Reposicao automatica aplicada (%s itens em %s totem(ns)).",
        NotifyRestaurantMembers = "[Totem %s] %s abriu o totem sem estoque. Reabastecam quando possivel.",
    },

    AutoRestock = {
        -- Se true, aplica reposicao automatica quando TODOS os totens da cidade estiverem sem estoque
        Enabled = true,

        -- Se true, so permite reposicao automatica quando nao houver ninguem online no grupo do restaurante atual
        OnlyWhenNoGroupOnline = true,

        -- Quantidade adicionada por item em cada totem afetado
        AmountPerItem = 25,

        -- Cooldown global para evitar reposicoes repetidas em curto intervalo
        CooldownSeconds = 900,
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- REABASTECER TUDO (ADMIN)
-- Botao extra na NUI: aplica a mesma quantidade em todos os itens do totem (ate o teto de MaxStock).
-- Nao verifica nem remove itens do inventario do jogador (diferente do reabastecer por item).
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.BulkRestock = {
    -- Permissao vRP (HasPermission/HasGroup) para staff/adm usar o comando.
    -- Se nil ou "", o botao nao e exibido.
    Permission = "Dono",
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- FAIXA DE PRECO
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.PriceRange = {
    -- Preco minimo permitido ao alterar o valor de um item
    Min = 1,
    -- Preco maximo permitido ao alterar o valor de um item
    Max = 1000000,
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTINO DA RECEITA (VENDAS)
-- Define para onde vai o valor das vendas apos o cliente pagar.
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.Revenue = {
    -- "painel" = credita direto no caixa da faccao (export night_painel:DirectAddMoney). Exige GroupName no restaurante.
    -- "totem"  = acumula em `revenue` no banco do totem ate um admin usar a retirada (Totem.Withdraw).
    Destination = "painel",
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- RETIRADA
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.Withdraw = {
    -- Nome do item entregue ao dono do totem ao retirar a receita
    -- Se nil ou false, o valor sera depositado na conta bancaria (giveBankMoney)
    Item = "dollar",
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOQUEIO
-- Verifica se ha funcionarios com ServicePermission online e dentro do raio do totem.
-- Se houver, o totem e bloqueado para compras de clientes.
-- Admins (AdminPermission) continuam podendo acessar o painel normalmente.
-- Essa configuracao e global - nao ha ajustes por totem.
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.Blocking = {
    -- Se true, ativa a verificacao de bloqueio por funcionarios em servico
    Enabled = true,
    -- Raio em metros ao redor do totem para verificar presenca de funcionarios
    Radius = 50.0,
    -- Mensagem exibida ao jogador quando o totem esta bloqueado
    BlockedMessage = "O totem esta fechado. Há funcionários em serviço no restaurante.",
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJETO / PROP
-- Modelo padrao utilizado para spawnar os totens no mundo.
-- Pode ser sobrescrito individualmente em cada totem via Machine.Model.
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.MachineObject = {
    -- Nome do modelo do prop (hash ou string)
    Model = "totem",
    -- Se true, congela o objeto no lugar
    Freeze = true,
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERACAO
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.Blips = {
    -- Exibe os totens no mapa/minimapa
    Enabled = false,
    Name = "Totem",
    Sprite = 52,
    Color = 1,
    Scale = 0.65,
    Display = 4,
    ShortRange = true,
}

Totem.Interaction = {
    -- Sistema de interacao utilizado para abrir os totens
    -- Valores aceitos: "sleepless" | "ox_target" | "marker"
    System = "marker",

    -- Distancia em metros em que o painel e fechado automaticamente ao se afastar do totem
    AutoCloseDistance = 5.0,

    -- Distancia maxima (servidor) para permitir a abertura do totem.
    -- Deve ser maior que a distancia de interacao do cliente para tolerar latencia.
    -- Jogadores fora deste raio sao silenciosamente ignorados (anti-cheat).
    ServerOpenDistance = 10.0,

    -- Configuracoes do sleepless_interact (utilizado quando System = "sleepless")
    Sleepless = {
        Label = "Abrir Totem",
        Icon = "utensils",
        -- Distancia maxima para exibir a interacao
        Distance = 2.5,
        -- Distancia maxima para permitir a interacao
        InteractDistance = 2.5,
    },

    -- Configuracoes do ox_target (utilizado quando System = "ox_target")
    OxTarget = {
        Label = "Abrir Totem",
        Icon = "fa-solid fa-utensils",
        -- Distancia maxima para exibir a opcao
        Distance = 2.5,
        -- Raio da zona esferica criada ao redor do totem
        Radius = 1.0,
    },

    -- Configuracoes do marcador 3D no chao (utilizado quando System = "marker")
    Marker = {
        -- Se true, esconde a bolinha azul do marcador e deixa so o texto flutuante
        DisableMarker = true,
        -- Se true, desenha o marcador mesmo usando sleepless/ox_target
        Enabled = false,
        -- Se true, permite abrir com E mesmo usando sleepless/ox_target
        EnableKey = true,
        -- Distancia em que o marcador comeca a ser desenhado
        DrawDistance = 12.0,
        -- Distancia em que a tecla de interacao e exibida e pode ser pressionada
        OpenDistance = 1.5,
        -- Tecla de interacao (38 = E)
        Key = 38,
        -- Texto exibido sobre o marcador quando o jogador esta proximo
        Text = "~g~E~w~  ABRIR TOTEM",
        -- Tipo do marcador GTA (2 = cilindro, 1 = seta)
        Type = 2,
        -- Deslocamento vertical do marcador em relacao a coordenada Z
        ZOffset = 0.15,
        -- Deslocamento vertical do texto em relacao a coordenada Z
        TextZOffset = 0.35,
        -- Escala do marcador
        Scale = vec3(0.18, 0.18, 0.18),
        -- Cor do marcador (R, G, B, A)
        Color = { 59, 130, 246, 160 },
    },
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTAURANTES
-- Cada entrada representa um totem (ponto de venda) independente com seu proprio estado no banco de dados.
-- O nome da chave e o identificador unico do totem - nunca reutilize um nome ja usado.
--
-- GroupName        -> Nome do grupo vRP (e da organizacao no night_painel).
--                     Unico grupo por totem - hierarquias internas definem o nivel de acesso.
--
-- AdminHierarchy   -> Hierarquia maxima para acesso ao painel administrativo.
--                     Ex: 2 = jogadores com hierarquia 1 ou 2 no grupo podem administrar.
--                     (numero menor = rank mais alto no vRP)
--
-- ServiceHierarchy -> Hierarquia maxima para contar como "funcionario em servico" no bloqueio.
--                     Quando Totem.Blocking.Enabled = true e houver alguem com hierarquia
--                     <= ServiceHierarchy online e dentro do raio, o totem e bloqueado para clientes.
--                     Use false ou nil para nunca bloquear por presenca de funcionarios.
-----------------------------------------------------------------------------------------------------------------------------------------

Totem.Restaurants = {
    CatCafe = {
        ThemeColor = "#2E8B57",
        Banner = "assets/totem.png",

        Machine = {
            Object = true,
            Coords = vec4(-1544.71,-461.81,35.89,226.78),
        },

        GroupName        = "CatCafe",
        AdminHierarchy   = 1,   -- hierarquia 1-2 = dono/chefe
        ServiceHierarchy = nil, -- nil = qualquer membro do grupo bloqueia

        Items = {
            nigirizushi = { DefaultPrice = 150 },
            sushi = { DefaultPrice = 150 },
            cupcake = { DefaultPrice = 150 },
            applelove = { DefaultPrice = 150 },
            cookies = { DefaultPrice = 150 },
            hamburger2 = { DefaultPrice = 150 },
            hamburger3 = { DefaultPrice = 150 },
            pizzamozzarella = { DefaultPrice = 150 },
            pizzabanana = { DefaultPrice = 150 },
            pizzachocolate = { DefaultPrice = 150 },
            donut = { DefaultPrice = 150 },
            fries = { DefaultPrice = 150 },
            hotdog = { DefaultPrice = 150 },
            sandwich = { DefaultPrice = 150 },
            tacos = { DefaultPrice = 150 },
            milkshake = { DefaultPrice = 150 },
            cappuccino = { DefaultPrice = 150 },
            passionjuice = { DefaultPrice = 150 },
            tangejuice = { DefaultPrice = 150 },
            orangejuice = { DefaultPrice = 150 },
            applejuice = { DefaultPrice = 150 },
            grapejuice = { DefaultPrice = 150 },
            lemonjuice = { DefaultPrice = 150 },
            bananajuice = { DefaultPrice = 150 },
            acerolajuice = { DefaultPrice = 150 },
            strawberryjuice = { DefaultPrice = 150 },
            blueberryjuice = { DefaultPrice = 150 },
            coffeemilk = { DefaultPrice = 150 },
            water = { DefaultPrice = 150 },
            combo1 = { DefaultPrice = 150 },
            combo2 = { DefaultPrice = 150 },
            combo3 = { DefaultPrice = 150 },
            COMBOPFELINO = { DefaultPrice = 150 },
            COMBOMMIAW = { DefaultPrice = 150 },
            COMBOGGARFIELD = { DefaultPrice = 150 },
            COMBOBABYCAT = { DefaultPrice = 150 },
            COMBOPATINHAS = { DefaultPrice = 150 },
            catburger = { DefaultPrice = 150 },
            milkcereja = { DefaultPrice = 150 },
            milkfrutos = { DefaultPrice = 150 },
            mlkmorango = { DefaultPrice = 150 },
            milkchocolate = { DefaultPrice = 150 },
            pirulito = { DefaultPrice = 150 },
            sorvete = { DefaultPrice = 150 },
            cafe = { DefaultPrice = 150 },
            mamadeira = { DefaultPrice = 150 },
            sorvete2 = { DefaultPrice = 150 },
            milkuwu = { DefaultPrice = 150 },
            marshmellow = { DefaultPrice = 150 },
            coxinha = { DefaultPrice = 150 },
            chaverde = { DefaultPrice = 150 },
            melancia = { DefaultPrice = 150 },
            catpanqueca = { DefaultPrice = 150 },
            ursoburger = { DefaultPrice = 150 },
            iogurtedemaca = { DefaultPrice = 150 },
            sucodekiwi = { DefaultPrice = 150 },
            sucodelimao = { DefaultPrice = 150 },
            sucodelaranja = { DefaultPrice = 150 },
            sucodemorango = { DefaultPrice = 150 },
            pudimdeuva = { DefaultPrice = 150 },
            tortadeamendoim = { DefaultPrice = 150 },
            torrada = { DefaultPrice = 150 },
            churros = { DefaultPrice = 150 },
            capuccino = { DefaultPrice = 150 },
            leitecomcanela = { DefaultPrice = 150 },
            chocolatecremoso = { DefaultPrice = 150 },
            coelhodechocolate = { DefaultPrice = 150 },
            cupcakerecheado = { DefaultPrice = 150 },
            cupcakedeabobora = { DefaultPrice = 150 },
            cupcakededefranboesa = { DefaultPrice = 150 },
            cupcakedemorango = { DefaultPrice = 150 },
            cupcakedelaranja = { DefaultPrice = 150 },
            bolinhodecereja = { DefaultPrice = 150 },
            supermilkshakerosa = { DefaultPrice = 150 },
            supermilkshakechocolate = { DefaultPrice = 150 },
            iogurtemorango = { DefaultPrice = 150 },
            bolococo = { DefaultPrice = 150 },
            rocambolemorango = { DefaultPrice = 150 },
            sucodeuva = { DefaultPrice = 150 },
            sucodemaca = { DefaultPrice = 150 },
            sucodefrutas = { DefaultPrice = 150 },
            bolodemorango = { DefaultPrice = 150 },
            leitedemorango = { DefaultPrice = 150 },
            leitedebanana = { DefaultPrice = 150 },
            leitedechocolate = { DefaultPrice = 150 },
            cereal = { DefaultPrice = 150 },
            COMBOSUNSET = { DefaultPrice = 150 },
            COMBOTROPICAL = { DefaultPrice = 150 },
            COMBOMARECLASSICA = { DefaultPrice = 150 },
            COMBOTROPICALIA = { DefaultPrice = 150 },
            COMBOFLAMINGOSUPREMO = { DefaultPrice = 150 },
            abacateovos = { DefaultPrice = 150 },
            bibimbap = { DefaultPrice = 150 },
            bifeepao = { DefaultPrice = 150 },
            bolocarne = { DefaultPrice = 150 },
            caviarvermelho = { DefaultPrice = 150 },
            eggsbenedict = { DefaultPrice = 150 },
            peixebatata = { DefaultPrice = 150 },
            purebatata = { DefaultPrice = 150 },
            salada = { DefaultPrice = 150 },
            salmaomolho = { DefaultPrice = 150 },
            wafflesgelado = { DefaultPrice = 150 },
            coquetelcarambola = { DefaultPrice = 150 },
            coquetellaranjaelimao = { DefaultPrice = 150 },
            daiquiridemorango = { DefaultPrice = 150 },
            leitedecoco = { DefaultPrice = 150 },
            limonada = { DefaultPrice = 150 },
            mangaelimao = { DefaultPrice = 150 },
            morangoemanga = { DefaultPrice = 150 },
            morangoepesego = { DefaultPrice = 150 },
            uvalimao = { DefaultPrice = 150 },
        },
    },
    MooMooCafe = {
        ThemeColor = "#2E8B57",
        Banner = "assets/totem.png",

        Machine = {
            Object = true,
            Coords = vec4(-587.41,-1059.17,22.33,178.59),
        },

        GroupName        = "MooMooCafe",
        AdminHierarchy   = 1,   -- hierarquia 1-2 = dono/chefe
        ServiceHierarchy = nil, -- nil = qualquer membro do grupo bloqueia

        Items = {
            nigirizushi = { DefaultPrice = 150 },
            sushi = { DefaultPrice = 150 },
            cupcake = { DefaultPrice = 150 },
            applelove = { DefaultPrice = 150 },
            cookies = { DefaultPrice = 150 },
            hamburger2 = { DefaultPrice = 150 },
            hamburger3 = { DefaultPrice = 150 },
            pizzamozzarella = { DefaultPrice = 150 },
            pizzabanana = { DefaultPrice = 150 },
            pizzachocolate = { DefaultPrice = 150 },
            donut = { DefaultPrice = 150 },
            fries = { DefaultPrice = 150 },
            hotdog = { DefaultPrice = 150 },
            sandwich = { DefaultPrice = 150 },
            tacos = { DefaultPrice = 150 },
            milkshake = { DefaultPrice = 150 },
            cappuccino = { DefaultPrice = 150 },
            passionjuice = { DefaultPrice = 150 },
            tangejuice = { DefaultPrice = 150 },
            orangejuice = { DefaultPrice = 150 },
            applejuice = { DefaultPrice = 150 },
            grapejuice = { DefaultPrice = 150 },
            lemonjuice = { DefaultPrice = 150 },
            bananajuice = { DefaultPrice = 150 },
            acerolajuice = { DefaultPrice = 150 },
            strawberryjuice = { DefaultPrice = 150 },
            blueberryjuice = { DefaultPrice = 150 },
            coffeemilk = { DefaultPrice = 150 },
            water = { DefaultPrice = 150 },
            combo1 = { DefaultPrice = 150 },
            combo2 = { DefaultPrice = 150 },
            combo3 = { DefaultPrice = 150 },
            COMBOPFELINO = { DefaultPrice = 150 },
            COMBOMMIAW = { DefaultPrice = 150 },
            COMBOGGARFIELD = { DefaultPrice = 150 },
            COMBOBABYCAT = { DefaultPrice = 150 },
            COMBOPATINHAS = { DefaultPrice = 150 },
            catburger = { DefaultPrice = 150 },
            milkcereja = { DefaultPrice = 150 },
            milkfrutos = { DefaultPrice = 150 },
            mlkmorango = { DefaultPrice = 150 },
            milkchocolate = { DefaultPrice = 150 },
            pirulito = { DefaultPrice = 150 },
            sorvete = { DefaultPrice = 150 },
            cafe = { DefaultPrice = 150 },
            mamadeira = { DefaultPrice = 150 },
            sorvete2 = { DefaultPrice = 150 },
            milkuwu = { DefaultPrice = 150 },
            marshmellow = { DefaultPrice = 150 },
            coxinha = { DefaultPrice = 150 },
            chaverde = { DefaultPrice = 150 },
            melancia = { DefaultPrice = 150 },
            catpanqueca = { DefaultPrice = 150 },
            ursoburger = { DefaultPrice = 150 },
            iogurtedemaca = { DefaultPrice = 150 },
            sucodekiwi = { DefaultPrice = 150 },
            sucodelimao = { DefaultPrice = 150 },
            sucodelaranja = { DefaultPrice = 150 },
            sucodemorango = { DefaultPrice = 150 },
            pudimdeuva = { DefaultPrice = 150 },
            tortadeamendoim = { DefaultPrice = 150 },
            torrada = { DefaultPrice = 150 },
            churros = { DefaultPrice = 150 },
            capuccino = { DefaultPrice = 150 },
            leitecomcanela = { DefaultPrice = 150 },
            chocolatecremoso = { DefaultPrice = 150 },
            coelhodechocolate = { DefaultPrice = 150 },
            cupcakerecheado = { DefaultPrice = 150 },
            cupcakedeabobora = { DefaultPrice = 150 },
            cupcakededefranboesa = { DefaultPrice = 150 },
            cupcakedemorango = { DefaultPrice = 150 },
            cupcakedelaranja = { DefaultPrice = 150 },
            bolinhodecereja = { DefaultPrice = 150 },
            supermilkshakerosa = { DefaultPrice = 150 },
            supermilkshakechocolate = { DefaultPrice = 150 },
            iogurtemorango = { DefaultPrice = 150 },
            bolococo = { DefaultPrice = 150 },
            rocambolemorango = { DefaultPrice = 150 },
            sucodeuva = { DefaultPrice = 150 },
            sucodemaca = { DefaultPrice = 150 },
            sucodefrutas = { DefaultPrice = 150 },
            bolodemorango = { DefaultPrice = 150 },
            leitedemorango = { DefaultPrice = 150 },
            leitedebanana = { DefaultPrice = 150 },
            leitedechocolate = { DefaultPrice = 150 },
            cereal = { DefaultPrice = 150 },
            COMBOSUNSET = { DefaultPrice = 150 },
            COMBOTROPICAL = { DefaultPrice = 150 },
            COMBOMARECLASSICA = { DefaultPrice = 150 },
            COMBOTROPICALIA = { DefaultPrice = 150 },
            COMBOFLAMINGOSUPREMO = { DefaultPrice = 150 },
            abacateovos = { DefaultPrice = 150 },
            bibimbap = { DefaultPrice = 150 },
            bifeepao = { DefaultPrice = 150 },
            bolocarne = { DefaultPrice = 150 },
            caviarvermelho = { DefaultPrice = 150 },
            eggsbenedict = { DefaultPrice = 150 },
            peixebatata = { DefaultPrice = 150 },
            purebatata = { DefaultPrice = 150 },
            salada = { DefaultPrice = 150 },
            salmaomolho = { DefaultPrice = 150 },
            wafflesgelado = { DefaultPrice = 150 },
            coquetelcarambola = { DefaultPrice = 150 },
            coquetellaranjaelimao = { DefaultPrice = 150 },
            daiquiridemorango = { DefaultPrice = 150 },
            leitedecoco = { DefaultPrice = 150 },
            limonada = { DefaultPrice = 150 },
            mangaelimao = { DefaultPrice = 150 },
            morangoemanga = { DefaultPrice = 150 },
            morangoepesego = { DefaultPrice = 150 },
            uvalimao = { DefaultPrice = 150 },
        },
    },
}
