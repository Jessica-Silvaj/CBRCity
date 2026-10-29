
fx_version 'cerulean'
game 'gta5'
this_is_a_map 'yes'
author 'NTeam'
description 'Digital N - Tech store'
version '1.0.1'

files {
    'rel/nteam_digitaln_audio.dat151.rel',
    'data/gtxd.meta'
}
client_scripts { 'lua/nteam_digitaln_config.lua', 'lua/nteam_digitaln_radio.lua' }
data_file 'AUDIO_GAMEDATA' 'rel/nteam_digitaln_audio.dat'
data_file 'GTXD_PARENTING_DATA' 'data/gtxd.meta'

escrow_ignore {
    'lua/nteam_digitaln_config.lua'
}


