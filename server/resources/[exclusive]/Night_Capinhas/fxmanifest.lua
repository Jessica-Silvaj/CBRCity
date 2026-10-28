fx_version 'bodacious'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@vrp/lib/Utils.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    '@vrp/config/Native.lua',
    'client/main.lua'
}

ui_page 'interface/build/index.html'

files {
    'interface/build/**/*'
}