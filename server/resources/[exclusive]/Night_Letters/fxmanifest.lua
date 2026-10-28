fx_version "cerulean"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

files {
    "web-side/**/*"
}

client_scripts {
    "client-side/core.lua"
}

shared_scripts {
    "@vrp/lib/utils.lua",
    "shared-side/config.lua",
    "shared-side/core.lua"
}

server_scripts {
    "server-side/core.lua"
}

escrow_ignore {
    "shared-side/*",
    "server-side/*"
}