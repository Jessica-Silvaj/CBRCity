fx_version "cerulean"
game "gta5"
lua54 "yes"

description "Vape com tanque recarregável, sabores e vapor colorido visível para todos"

shared_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua"
}

client_scripts {
	"client-side/core.lua"
}

server_scripts {
	"server-side/core.lua"
}

ui_page "web-side/index.html"

files {
	"web-side/index.html"
}
