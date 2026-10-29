fx_version "cerulean"
game "gta5"
lua54 "yes"

description "SAMU de NPC: /samu chama uma ambulância que reanima o jogador desmaiado"

shared_scripts {
	"@vrp/lib/utils.lua",
	"config.lua"
}

client_scripts {
	"client-side/core.lua"
}

server_scripts {
	"server-side/core.lua"
}
