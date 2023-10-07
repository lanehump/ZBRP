fx_version 'adamant'
game 'gta5'
description 'EchoRP - Meta Files Pack'
version '1.0.1'

files {
    --allcars
    'data/**/**/vehiclelayouts.meta',
    'data/**/**/vehicles.meta',
    'data/**/**/carvariations.meta',
    'data/**/**/carcols.meta',
    'data/**/**/handling.meta',
    --'data/**/**/clips_sets.xml',
    'handlings/*.meta',
    'weapons/*.meta',
    "peds/peds.meta",

}

--allcars
data_file 'HANDLING_FILE' 'handlings/*.meta'
data_file 'HANDLING_FILE' 'data/**/**/handling.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'data/**/**/vehiclelayouts.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/**/**/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/**/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/**/**/carvariations.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/*.meta'
data_file "PED_METADATA_FILE" "peds/peds.meta"
data_file 'WEAPONCOMPONENTSINFO_FILE' 'weapons/weaponanimations.meta'
data_file 'WEAPON_METADATA_FILE' 'weapons/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'weapons/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'weapons/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'weapons/weapons_tazer.meta'

client_script 'vehicle_names.lua'