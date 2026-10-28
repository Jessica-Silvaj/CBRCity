fx_version 'cerulean'
game 'gta5'
lua54 "yes"
this_is_a_map 'yes'
version '1.0'

client_script 'client.lua'

files {
  'meta/gtxd.meta',
}

data_file 'GTXD_PARENTING_DATA' 'meta/gtxd.meta'

escrow_ignore {
  'stream/replace/*', 
  'stream/editable/*', 
  'stream/replace/*/**'
}

version '1.0.0'