fx_version 'cerulean'
game 'gta5'
lua54 "yes"

ui_page 'web-side/index.html'

shared_scripts {
    '@vrp/lib/utils.lua',
    '@vrp/config/Vehicle.lua',
    "shared-side/*.lua",
}

client_scripts {
    "@PolyZone/client.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Global.lua",
    "shared-side/*.lua",
    "client-side/client.lua",
    "client-side/props.lua",
    "client-side/atms.lua",
    "client-side/catalogs.lua"
}

server_scripts {
    "@vrp/lib/Utils.lua",
    "shared-side/*.lua",
    "server-side/server.lua",
    "server-side/props.lua",
    "server-side/atms.lua",
    "server-side/catalogs.lua"
}

files {
    'web-side/index.html',
    'web-side/style.css',
    'web-side/index.js'
}