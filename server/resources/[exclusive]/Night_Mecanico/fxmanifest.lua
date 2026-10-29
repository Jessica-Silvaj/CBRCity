fx_version "cerulean"
game "gta5"
lua54 "yes"

description "Mecânico de NPC: /mec chama um guincho que repara o motor do veículo"

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
