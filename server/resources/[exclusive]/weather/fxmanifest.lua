fx_version 'bodacious'
game 'gta5'

lua54 'yes'

shared_scripts {
    '@vrp/lib/utils.lua',
    'config.lua'
}

client_scripts {
    'client/**.*',
}

server_scripts {
    'server/**',
}

ui_page 'web-side/build/index.html'

files {
    'web-side/build/**'
}
