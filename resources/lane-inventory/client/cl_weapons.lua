local animPlaying = false
local playerArmed = false

RegisterNetEvent('arena:useWeapon')
AddEventHandler('arena:useWeapon', function(weaponName)
    Citizen.CreateThread(function()
        local weaponHash = GetHashKey(weaponName)

        if not playerHasWeapon() then

            local bulletType = findAmmoType(weaponHash)
            local ammoCount = ammoCount(bulletType)

            GiveWeaponToPed(PlayerPedId(), weaponHash, tonumber(ammoCount), false, true)
            ClearPedTasks(PlayerPedId())
            ApplyWeaponComponents(weaponName)
        else
            putawayGun()
        end
    end)
end)

function playerHasWeapon()
    if not IsPedArmed(PlayerPedId(), 1) and not IsPedArmed(PlayerPedId(), 2) and not IsPedArmed(PlayerPedId(), 4) then
        return false
    else
        return true
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        playerArmed = IsPedArmed(PlayerPedId(), 4)
    end
end)



function ammoCount(bullet)
    local count = 0
    if inventoryData and type(inventoryData) == 'table' then
        for k,v in pairs(inventoryData) do
            if v and v.item then
                if v.item == bullet then
                    count = count + v.quantity
                end
            end
        end
    end

    return count
end

function setDefaultAmmo(forbullet, count)
    if inventoryData and type(inventoryData) == 'table' then
        for k,v in pairs(inventoryData) do 
            if v and v.item then 
                if v.item == bullet then 
                    v.quantity = count
                end
            end
        end
    end
end

function findAmmoType(weaponHash)
    for weaponName, bullet in pairs(Config.Weapons) do
        if GetHashKey(weaponName) == weaponHash then
            if type(bullet) == 'string' then
                return bullet
            end
        end
    end
    return
end

AddEventHandler('arena:updatePlayerInventory', function(inventory)
    local localPlayer = PlayerPedId()
    if IsPedArmed(localPlayer, 4) then
        local currentWeapon = GetSelectedPedWeapon(localPlayer)
        local ammoType = findAmmoType(currentWeapon)
        local ammoCount = ammoCount(ammoType)
        SetPedAmmo(localPlayer, currentWeapon, ammoCount)

        local hasWeapon = false
        for k,v in pairs(inventory) do
            if v and v.item then
                if GetHashKey(v.item) == currentWeapon then
                    hasWeapon = true
                end
            end
        end

        if not hasWeapon then
            RemoveAllPedWeapons(localPlayer, false)
        end
    end
end)

Citizen.CreateThread(
    function()
        while true do
            local localPlayer = PlayerPedId()
            -- ammo update
            if playerArmed then
                local currentWeapon = GetSelectedPedWeapon(localPlayer)

                if IsPedShooting(localPlayer) then
                    local ammoType = findAmmoType(currentWeapon)
                    if ammoType then
                        TriggerServerEvent('arena:reduceWeaponAmmo', ammoType)
                    end
                end
            end

            Citizen.Wait(0)
        end
    end
)


function putawayGun()
    Citizen.CreateThread(
        function()
            local localPlayer = PlayerPedId()

            if playerHasWeapon() then
                RemoveAllPedWeapons(localPlayer, false)
            end
        end)
end