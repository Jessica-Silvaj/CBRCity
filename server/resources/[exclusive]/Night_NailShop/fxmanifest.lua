fx_version 'cerulean'
game {'gta5'}

author '0resmon & vezironi'
description 'Modern, relastic, and fully customizable Nailshop job for FiveM.'

scriptname 'Night_NailShop'
version '1.0.2'

shared_scripts {
    '@vrp/lib/Utils.lua',
    'shared/config.lua',
    'shared/locales.lua',
    'shared/utils.lua',
}

client_scripts {
    'modules/framework/vrp/client.lua',
    'client/cl_functions.lua',
    'client/cl_main.lua',
    'client/cl_nui.lua',
}

server_scripts {
    '@vrp/lib/Utils.lua',
    'modules/framework/vrp/server.lua',
    'server/sv_sql.lua',
    'server/sv_functions.lua',
    'server/sv_main.lua',
}

escrow_ignore {
    'config/*.lua',
    'locales/*.lua',
    'shared/*.lua',
    'modules/**/**/*.lua',
}

files {
    'config/main.lua',
    'web/build/*.*',
    'web/build/**/*.*',
    'locales/*.json'
}

ui_page 'web/build/index.html'

lua54 'yes'
use_experimental_fxv2_oal 'yes'