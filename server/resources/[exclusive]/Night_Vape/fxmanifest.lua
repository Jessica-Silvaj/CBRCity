fx_version "cerulean"
game "gta5"
lua54 "yes"

description "Vape com tanque recarregável, sabores e vapor colorido visível para todos"

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

files {
	"stream/prop_astra_vape_01.ydr",
	"stream/oxlyn_vape.ytyp"
}

data_file "DLC_ITYP_REQUEST" "stream/oxlyn_vape.ytyp"
