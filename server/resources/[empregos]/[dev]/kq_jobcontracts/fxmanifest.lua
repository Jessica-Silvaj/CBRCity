fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Job Contract management system by KuzQuality'
version '1.0.0'

dependency 'kq_link'

ui_page 'nui/dist/nui.html'

shared_scripts {
    'config.lua',
    'shared/settings.lua',
    'shared/cache.lua',
    'shared/utils.lua',
    'shared/editable/xp.lua',
    'shared/locale.lua',
}

server_scripts {
    'server/editable/init.lua',
    'server/editable/sql.lua',
    'server/editable/editable.lua',
    'server/taskTypes.lua',
    'server/classes/jobTask.lua',
    'server/classes/jobContract.lua',
    'server/registry.lua',
    'server/main.lua',
}

client_scripts {
    'client/taskTypes.lua',
    'client/classes/jobContractProxy.lua',
    'client/taskLifecycleManager.lua',
    'client/stateSyncManager.lua',
    'client/headshot.lua',
    'client/nui/manager.lua',
    'client/main.lua',
    'client/nui/callbacks.lua',
    'client/editable/editable.lua',
}

files {
    'locales/*.json',

    'nui/dist/nui.html',
    'nui/dist/app.js',
    'nui/dist/app.css',
    'nui/dist/theme.css',

    'shared/utils.lua',
    'shared/settings.lua',
    'client/main.lua',
    'client/taskTypes.lua',
}

escrow_ignore {
    'config.lua',
    'client/editable/**.*',
    'shared/editable/**.*',
    'server/editable/**.*',
    'locales/*.json',
}

dependency '/assetpacks'

