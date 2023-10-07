Components = {
    ["WEAPON_CARBINERIFLE"] = {
        {comp = "COMPONENT_AT_AR_FLSH"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM"},
        {comp = "COMPONENT_CARBINERIFLE_CLIP_02"}
    },
    ["WEAPON_APPISTOL"] = {
        {comp = "COMPONENT_APPISTOL_CLIP_02"},
    },
    ["WEAPON_COMBATMG"] = {
        {comp = "COMPONENT_AT_AR_AFGRIP"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM"},
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        {comp = "COMPONENT_AT_SCOPE_MEDIUM_MK2"},
        {comp = "COMPONENT_AT_AR_AFGRIP_02"},
        {comp = "COMPONENT_AT_AR_SUPP"},
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        {comp = "COMPONENT_SPECIALCARBINE_MK2_CLIP_02"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM_MK2"},
        {comp = "COMPONENT_AT_AR_SUPP_02"},
        {comp = "COMPONENT_AT_AR_AFGRIP_02"}
    },
    ["WEAPON_COMBATMG_MK2"] = {
        {comp = "COMPONENT_AT_AR_AFGRIP"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM_MK2"},
        {comp = "COMPONENT_AT_MG_BARREL_02"},
    },
    ["WEAPON_SPECIALCARBINE"] = {
        {comp = "COMPONENT_SPECIALCARBINE_CLIP_03"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM"},
        {comp = "COMPONENT_AT_AR_SUPP_02"},
        {comp = "COMPONENT_AT_AR_AFGRIP"},
        {comp = "COMPONENT_AT_AR_FLSH"}
    }

}



function ApplyWeaponComponents(primary)
    print("COMP: " .. primary)
    if Components[primary] == nil then return end 
    for k,v in pairs(Components[primary]) do 
        print(v.comp)
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(primary), GetHashKey(v.comp))
    end
end

