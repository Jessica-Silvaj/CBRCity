fx_version 'cerulean'
game 'gta5'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/functions.lua',
    'client/hud.lua',
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/script.js'
}

exports {
    'getGear',
    'setMode',
    'getRPM',
    'getEngineState'
}