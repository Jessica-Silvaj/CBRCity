fx_version "cerulean"
game "gta5"
lua54 "yes"

version '1.0.0'

ui_page "web-side/dist/index.html"

shared_scripts {
    "@vrp/lib/utils.lua",
    "cfg/lang.lua",
    "cfg/perguntas.lua",
    "cfg/config.lua",
}

client_scripts {
    "@vrp/config/Global.lua",
    "client/core.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "cfg/functions.lua",
    "server/core.lua",
}

files {
    "web-side/dist/index.html",
    "web-side/dist/**/*",
}