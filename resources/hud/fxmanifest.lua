fx_version 'cerulean'
game 'gta5'

description 'Overtime Hud'
author 'jyouwu'
version '2.0'
description 'Dont steal this, fags, it took me more than 30 mins, k thanks.'

client_scripts {
    -- '@ot-remotecalls/client/cl_main.lua',
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    -- '@ot-remotecalls/server/sv_main.lua',
    'server/*.lua'
}

ui_page {
    'html/ui.html'
}

files {
    'html/ui.html',
    'html/css/main.css',
    'html/js/app.js',
    'html/images/*.png'
}