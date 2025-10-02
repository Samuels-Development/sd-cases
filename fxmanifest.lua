fx_version 'cerulean'
game 'gta5'

author 'Samuel#0008'
description 'FiveM Lootbox System'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'bridge/init.lua',
    'config.lua'
}

client_scripts {
    'bridge/client.lua',
    'client/*.lua'
}

server_scripts {
    'bridge/server.lua',
    'server/*.lua'
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/asset-manifest.json',
    'web/build/static/css/*.css',
    'web/build/static/css/*.css.map',
    'web/build/static/js/*.js',
    'web/build/static/js/*.js.map'
}

lua54 'yes'