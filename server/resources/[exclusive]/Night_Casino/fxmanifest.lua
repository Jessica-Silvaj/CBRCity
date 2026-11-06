fx_version 'adamant'
game 'gta5'

client_scripts {
    '@vrp/lib/Utils.lua',
    'config/**/*.lua',
    'src/RMenu.lua',
    'src/menu/RageUI.lua',
    'src/menu/Menu.lua',
    'src/menu/MenuController.lua',
    'src/components/*.lua',
    'src/menu/elements/*.lua',
    'src/menu/items/*.lua',
    'src/menu/panels/*.lua',
    'src/menu/windows/*.lua',
    'translations.lua',
    'shared/shared_utils.lua',
    'client/**/*.lua',
    'client/casino.lua'
}

server_scripts {
    '@vrp/lib/Utils.lua',
    'config/**/*.lua',
    'translations.lua',
    'shared/shared_utils.lua',
    'server/**/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/*.js',
    'html/DEP/*.js',
    'html/img/**',
    'html/ProximaNova.woff'
}
