fx_version "cerulean"
game "gta5"
lua54 "yes"
ui_page "web-side/dist/index.html"

shared_scripts {
    "@vrp/lib/Utils.lua",
    "config/config.lua",
}

client_scripts {
    "client-side/core.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server-side/core.lua",
}

files {
    "web-side/dist/index.html",
    "web-side/dist/**/*",
}

data_file "DLC_ITYP_REQUEST" "stream/totem.ytyp"