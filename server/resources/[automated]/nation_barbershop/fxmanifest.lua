fx_version "adamant"
game "gta5"

ui_page_preload 'yes'

ui_page "nui/index.html"

files {
	"nui/**",
}

client_scripts {
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"client_config.lua",
	"client.lua"
} 

server_script {
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"server_config.lua",
	"server.lua"
}