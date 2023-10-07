

function API.GiveItem(item, count, slot) -- slot is not a required param
    abc("arena:Player:addItem", {item = item, slot = slot}, count)
end


function API.RemoveItem(item, count)
    abc("arena:Player:removeItem", item, count)
    Player.InAnim = false -- when oxy and armour is removed etc...
    SendNUIMessage({action = 'slotNotification', name = item, formatname = item})
end

RegisterNetEvent("arena:inv.RemoveItem", API.RemoveItem)
RegisterNetEvent("arena:inv.GiveItem", API.GiveItem)

function API.HasItem(item) -- check if player has item
    for k,v in pairs(inventoryData) do 
        if v.item == item then return v end 
    end
    return false 
end


function API.GetItemInSlot(slot)
    return inventoryData[slot].item 
end


function API.SyncAmmo() -- when a player picks up an item or something changes in their inventory it syncs the ammo
    local currentWeapon = GetSelectedPedWeapon(Player.Ped())
    local ammoType = findAmmoType(currentWeapon)
    local ammoCount = ammoCount(ammoType)
    SetPedAmmo(Player.Ped(), currentWeapon, ammoCount)
end


function API.ThrowItem(itemData, atCoords) -- experimental, not to be used in live environment yet
    abc('nui:arena:throwItem', data, atCoords)
end


function API.OnDrop(i, item) 
    if item["item"].itemdata.type == "ammo" then return end 
    local func = RegisteredItems[item["item"].itemdata.item]
    if fun == nil then return end 
    if func.onDrop == nil then return end 
    func.onDrop() 
end

RegisterNetEvent("arena:addDroppedItem", API.OnDrop)
