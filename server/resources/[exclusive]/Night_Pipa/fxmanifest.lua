fx_version 'adamant'
game 'gta5'

lua54 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/vdg_pipas.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/myc_carretel.ytyp'

shared_scripts {
    '@vrp/lib/utils.lua',
    'lib/*.lua',
    'config/*.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'framework/vrp.lua',
    'server/*.lua',
}

ui_page 'nui/build/index.html'

files {
    'nui/build/index.html',
    'nui/build/**/*',
}
