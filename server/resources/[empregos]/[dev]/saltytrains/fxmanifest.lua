
fx_version 'cerulean'

games {"gta5"}

author "SaltyHub Development"
description "SaltyTrains - SaltyHub Development"
version '1.2.3'

lua54 'yes'

ui_page 'web/dist/index.html'

client_scripts {
    "config.lua",
    "client/*.lua", 
}

server_scripts {
    "@vrp/lib/Utils.lua",
    "@oxmysql/lib/MySQL.lua", 
    "config.lua",
    "server/utils.lua",
    "server/framework.lua",
    "server/main.lua"
}

escrow_ignore {
    "config.lua",
    "client/utils.lua",
    "server/*.lua",
}

data_file 'TRAINCONFIGS_FILE' 'data/trains.xml'

files {'web/dist/**/*', 'web/dist/index.html', 'data/trains.xml'}
dependency '/assetpacks'

