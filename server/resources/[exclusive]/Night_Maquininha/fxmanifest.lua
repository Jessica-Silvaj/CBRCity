fx_version "bodacious"
game "gta5"

ui_page "web-side/index.html"

shared_scripts {
    "@vrp/lib/utils.lua",
}

client_script {
    "client-side/*.lua"
}

server_script {
    "server-side/*.lua"
}

files {
    "web-side/*.html",
    "web-side/*.png",
    "web-side/assets/*.js",
    "web-side/assets/*.css",
    "stream/*"
}

data_file 'DLC_ITYP_REQUEST' 'stream/arts_maquina_cartao.ytyp'