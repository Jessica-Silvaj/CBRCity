fx_version "cerulean"
game "gta5"

-- Blip Info Utility (glitchdetector, licença MIT - ver LICENSE)
-- Cartão com imagem, título e texto ao passar o mouse nos blips do mapa (P / ESC)
name "blip_info"
author "glitchdetector"

client_script "blip_info.lua"

files {
	"banner.png",
	"images/*.png"
}

exports {
	"ResetBlipInfo",
	"SetBlipInfo",
	"SetBlipInfoTitle",
	"SetBlipInfoImage",
	"SetBlipInfoEconomy",
	"AddBlipInfoText",
	"AddBlipInfoName",
	"AddBlipInfoHeader",
	"AddBlipInfoIcon"
}
