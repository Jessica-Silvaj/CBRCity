Config = {
    NotificationDistance = 10.0,
    PropsToRemove = {
        vector3(1992.803, 3047.312, 46.22865),
        vector3(-36.301, 6391.44, 31.6047),
        vector3(550.147, -174.76, 50.6930),
        vector3(-574.17, 288.834, 79.1766),
    },

    --[[
        -- To use custom notifications, implement client event handler, example:

        AddEventHandler('sinuca:notification', function(serverId, message)
            print(serverId, message)
        end)
    ]]
    CustomNotifications = false,

    --[[
        -- To use custom menu, implement following client handlers
        AddEventHandler('sinuca:openMenu', function()
            -- open menu with your system
        end)

        AddEventHandler('sinuca:closeMenu', function()
            -- close menu, player has walked far from table
        end)


        -- After selecting game type, trigger one of the following setupTable events
        TriggerEvent('sinuca:setupTable', 'BALL_SETUP_8_BALL')
        TriggerEvent('sinuca:setupTable', 'BALL_SETUP_STRAIGHT_POOL')
    ]]
    CustomMenu = false,

    --[[
        When you want your players to pay to play pool, set this to true
        AND implement the following server handler in your framework of choice.
        The handler MUST deduct money from the player and then CALL the callback
        if the payment is successful, or inform the player of payment failure.

        This script itself DOES NOT implement ESX/vRP logic, you have to do that yourself.

        AddEventHandler('sinuca:payForPool', function(playerServerId, cb)
            print("This should be replaced by deducting money from " .. playerServerId)
            cb() -- successfuly set balls on table
        end)
    ]]
    PayForSettingBalls = false,
    BallSetupCost = nil, -- for example: "$1" or "$200" - any text

    --[[
        You can integrate pool cue into your system with

        SERVERSIDE HANDLERS
            - sinuca:onReturnCue - called when player takes cue
            - sinuca:onTakeCue   - called when player returns cue

        CLIENTSIDE EVENTS
            - sinuca:takeCue   - forces player to take cue in hand
            - sinuca:removeCue - removes cue from player's hand

        This prevents players from taking cue from cue rack if `false`
    ]]
    AllowTakePoolCueFromStand = true,

    --[[
        This option is for servers whose anticheats prevents
        this script from setting players invisible.

        When player's ped is blocking camera when aiming,
        set this to true
    ]]
    DoNotRotateAroundTableWhenAiming = false,

    MenuColor = {46, 139, 87}, -- cor principal #2E8B57
    Keys = {
        BACK = {code = 200, label = 'INPUT_FRONTEND_PAUSE_ALTERNATE'},
        ENTER = {code = 38, label = 'INPUT_PICKUP'},
        SETUP_MODIFIER = {code = 21, label = 'INPUT_SPRINT'},
        CUE_HIT = {code = 179, label = 'INPUT_CELLPHONE_EXTRA_OPTION'},
        CUE_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        CUE_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        AIM_SLOWER = {code = 21, label = 'INPUT_SPRINT'},
        BALL_IN_HAND = {code = 29, label = 'INPUT_SPECIAL_ABILITY_SECONDARY'},

        BALL_IN_HAND_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        BALL_IN_HAND_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        BALL_IN_HAND_UP = {code = 172, label = 'INPUT_CELLPHONE_UP'},
        BALL_IN_HAND_DOWN = {code = 173, label = 'INPUT_CELLPHONE_DOWN'},
    },
    Text = {
        BACK = "Voltar",
        HIT = "Bater",
        BALL_IN_HAND = "Pegue a bola",
        BALL_IN_HAND_BACK = "Voltar",
        AIM_LEFT = "Vire à esquerda",
        AIM_RIGHT = "Vire à direita",
        AIM_SLOWER = "Mira lenta",

        POOL = 'Bilhar',
        POOL_GAME = 'Pool game',
        POOL_SUBMENU = 'Modo de jogo',
        TYPE_8_BALL = '8-Ball',
        TYPE_STRAIGHT = 'Straight pool',

        HINT_SETUP = 'Escolher um jogo',
        HINT_TAKE_CUE = 'Pegue o taco',
        HINT_RETURN_CUE = 'Coloque o taco de volta',
        HINT_HINT_TAKE_CUE = 'Para jogar bilhar, você precisa de um taco.',
        HINT_PLAY = 'Jogar',

        BALL_IN_HAND_LEFT = 'Esquerda',
        BALL_IN_HAND_RIGHT = 'Direita',
        BALL_IN_HAND_UP = 'Cima',
        BALL_IN_HAND_DOWN = 'Baixo',
        BALL_POCKETED = '%s você coloca a bola no buraco',
        BALL_IN_HAND_NOTIFY = 'Você pegou a bola de bilhar',
        BALL_LABELS = {
            [-1] = 'Cue',
            [1] = '~y~Lisa 1~s~',
            [2] = '~b~Lisa 2~s~',
            [3] = '~r~Lisa 3~s~',
            [4] = '~p~Lisa 4~s~',
            [5] = '~o~Lisa 5~s~',
            [6] = '~g~Lisa 6~s~',
            [7] = '~r~Lisa 7~s~',
            [8] = 'Bola 8 lisa',
            [9] = '~y~Listrado 9~s~',
            [10] = '~b~Listrado 10~s~',
            [11] = '~r~Listrado 11~s~',
            [12] = '~p~Listrado 12~s~',
            [13] = '~o~Listrado 13~s~',
            [14] = '~g~Listrado 14~s~',
            [15] = '~r~Listrado 15~s~',
         }
    },
}
