fx_version 'adamant'
game 'gta5'

client_script {
	"@vrp/lib/Utils.lua",
	"config/config.lua",
	"script/client-side/*.lua",
}

server_scripts{ 
	"@vrp/lib/Utils.lua",
	"script/server-side/*.lua",
}

ui_page 'script/web-side/index.html'

files {
	'script/web-side/*',
	'script/web-side/**'
}