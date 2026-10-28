fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
	'locales/*.lua',
	'config.lua'
}

client_script 'client/client.lua'

escrow_ignore {
  'config.lua',
  'locales/*.lua'
}