fx_version 'bodacious'
game 'gta5'
lua54 'yes'

dependency_check 'warn'

ui_page 'client/nui/index.html'

shared_scripts {
    '@vrp/lib/utils.lua',
    '@vrp/config/Global.lua',
    'Config.lua',
    'config/*.lua'
}

server_scripts {
    'server/*.lua',
    'server/modules/*.lua'
}

client_scripts {
    'client/*.lua',
    'client/modules/*.lua'
}

files {
    'client/nui/*',
    'client/nui/**/*',
    'assets/*',
    'assets/**/*'
}
