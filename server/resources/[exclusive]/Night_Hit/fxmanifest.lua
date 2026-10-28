fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Gabs Development'
description 'Hitmarker e confirmação de abate com preferências persistentes por jogador'
version '2.0.0'

dependencies {
    'vrp',
    'oxmysql'
}

shared_scripts {
    '@vrp/lib/Utils.lua',
    'config/config.lua'
}

client_script 'client-side/client.lua'

server_scripts {
    '@vrp/lib/Utils.lua',
    '@oxmysql/lib/MySQL.lua',
    'server-side/server.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/script.js',
    'nui/style.css',
    'nui/assets/*.woff2',
    'nui/sounds/*.mp3',
    'nui/sounds/*.png'
}