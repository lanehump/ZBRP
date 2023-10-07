local clonedPed = nil

inventoryOpened = false
NUI_LOADED = false
inventoryData = nil

exports("GetPlayerInventory", function()
    return inventoryData 
end)

RegisterNUICallback('nui:arena:mounted', function()
    NUI_LOADED = true
end)

-- MAIN OPENING THREAD
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsDisabledControlJustPressed(0, 37) then
            Scaleform.Show()
            Wait(100)
            SendNUIMessage({action = 'openInventory', isMale = IsPedMale(PlayerPedId()) })

            local playerpos = GetEntityCoords(PlayerPedId())
            local playerinvehicle = IsPedInAnyVehicle(PlayerPedId(), false)

            if playerinvehicle then -- if player is in the vehicle, open glovebox, eg.
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if DoesEntityExist(veh) then
                    local seat_driver = GetPedInVehicleSeat(veh, -1)
                    local seat_second = GetPedInVehicleSeat(veh, 0)
                    
                    if seat_driver or seat_second then
                        local plate = Functions.Trim(GetVehicleNumberPlateText(veh))
                        TriggerServerEvent('arena:openSecondInventory', {
                            type = 'carglovebox',
                            plate = plate
                        })
                    end
                end
            else
                local foundAny = false

                for i=1, #Config.FactionSafes, 1 do
                    local d = Config.FactionSafes[i]
                    local dist = #(playerpos - d.pos)
                    if dist < 3.5 then
                        foundAny = true
                        TriggerServerEvent('arena:openSecondInventory', {
                            type = 'faction',
                            faction = d.faction
                        })
                    end
                end

                if not foundAny then
                    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
                    local rayHandle = CastRayPointToPoint(playerpos, entityWorld, 10, PlayerPedId(), 0)
                    local a, b, c, d, veh = GetRaycastResult(rayHandle)
                    if veh ~= nil and DoesEntityExist(veh) and IsEntityAVehicle(veh) and not Config.NoTrunk[GetEntityModel(veh)] then 
                        local vehpos = GetEntityCoords(veh)
                        local boneIndex = GetEntityBoneIndexByName(veh, 'boot')
                        local bootCoords = nil

                        if boneIndex ~= -1 then
                            bootCoords = GetWorldPositionOfEntityBone(veh, boneIndex)
                        end
                        
                        if bootCoords ~= nil then
                            local offset = GetObjectOffsetFromCoords(bootCoords.x, bootCoords.y, bootCoords.z, GetEntityHeading(veh), 0.0, -1.0, 0.0)
                            local dist = #(playerpos - offset)
                            if dist < 2.0 then
                                local plate = Functions.Trim(GetVehicleNumberPlateText(veh))
                                local lockStatus = GetVehicleDoorLockStatus(veh)
                                if lockStatus == 1 then
                                    foundAny = true
                                    TriggerServerEvent('arena:openSecondInventory', {
                                        type = 'cartrunk',
                                        plate = plate,
                                        vehiclemodel = GetEntityModel(veh)
                                    })
                                    SetVehicleDoorOpen(veh, 5, false)
                                    selectedTrunkOpened = veh

                                    local dict, anim = 'mini@repair', 'fixing_a_ped'
                                    RequestAnimDict(dict)
                                    while not HasAnimDictLoaded(dict) do
                                        Citizen.Wait(1)
                                    end
                                    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                                else
                                    Functions.SendNotification(_U('veh_closed'), 'info')
                                end
                            end
                        else
                            if #(playerpos - vehpos) < 5.0 then
                                local plate = Functions.Trim(GetVehicleNumberPlateText(veh))
                                local lockStatus = GetVehicleDoorLockStatus(veh)
                                if lockStatus == 1 then
                                    foundAny = true
                                    TriggerServerEvent('arena:openSecondInventory', {
                                        type = 'cartrunk',
                                        plate = plate,
                                        vehiclemodel = GetEntityModel(veh)
                                    })
                                    SetVehicleDoorOpen(veh, 5, false)
                                    selectedTrunkOpened = veh
                                else
                                    Functions.SendNotification(_U('veh_closed'), 'info')
                                end
                            end
                        end
                    end
                end

                if not foundAny then
                    for i=1, #Config.OtherInventories, 1 do
                        local d = Config.OtherInventories[i]
                        if #(playerpos - d.pos) < 3.0 and Player.CanSwitch then
                            foundAny = true
                            TriggerServerEvent('arena:openSecondInventory', {
                                type = 'other',
                                id = i
                            }, GetPlayer())
                        end
                    end
                end
            end
        end
    end
end)



RegisterNUICallback('nui:arena:blurState', function(blur)
    if blur == 'on' then
        TriggerScreenblurFadeIn()
    elseif blur == 'off' then
        TriggerScreenblurFadeOut()
    end
end)

RegisterNUICallback('nui:arena:openedState', function(data)
    local state = data.state
    local blur = data.blur
    
    inventoryOpened = state

    -- global
    SetNuiFocus(state, state)
    Scaleform.Cursor()
    

    if state then
        if blur == 'on' then TriggerScreenblurFadeIn() end
    else
        if selectedTrunkOpened and DoesEntityExist(selectedTrunkOpened) then
            
            if NetworkGetEntityIsNetworked(selectedTrunkOpened) then
                NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(selectedTrunkOpened))
                while DoesEntityExist(selectedTrunkOpened) and
                    NetworkGetEntityOwner(selectedTrunkOpened) ~= PlayerId() and
                    DoesEntityExist(selectedTrunkOpened) do
                    Citizen.Wait(1)
                end
            end

            SetVehicleDoorShut(selectedTrunkOpened, 5, false)
            selectedTrunkOpened = nil
            ClearPedTasksImmediately(PlayerPedId())
        end

        TriggerServerEvent('arena:removeSecondary')
        TriggerScreenblurFadeOut()
        Scaleform.Hide()
    end
end)

RegisterNetEvent('arena:updateSecondInventory')
AddEventHandler('arena:updateSecondInventory', function(inventory, maxweight)
    while not NUI_LOADED do
        Citizen.Wait(100)
    end
    SendNUIMessage({
        action = 'updateSecondInventory',
        inventory = inventory,
        maxweight = maxweight
    })
end)

RegisterNetEvent('arena:updatePlayerInventory')
AddEventHandler('arena:updatePlayerInventory', function(inventory)
    while not NUI_LOADED do
        Citizen.Wait(100)
    end
    SendNUIMessage({
        action = 'updatePlayerInventory',
        inventory = inventory
    })
    inventoryData = inventory
end)

RegisterNetEvent('arena:setPlayerStaticData')
AddEventHandler('arena:setPlayerStaticData', function(maxweight, name)
    while not NUI_LOADED do
        Citizen.Wait(100)
    end
    SendNUIMessage({ action = 'setPlayerStaticData', maxweight = maxweight, name = name})
end)

RegisterNUICallback('nui:arena:moveInside', function(data)
    TriggerServerEvent('nui:arena:moveInside', data)
end)
RegisterNUICallback('nui:arena:moveToFirst', function(data)
    print("farting")
    TriggerServerEvent('nui:arena:moveToFirst', data)
end)
RegisterNUICallback('nui:arena:moveToSecond', function(data)
    TriggerServerEvent('nui:arena:moveToSecond', data)
end)
RegisterNUICallback('nui:arena:instantToSecond', function(index)
    TriggerServerEvent('nui:arena:instantToSecond', index)
end)
RegisterNUICallback('nui:arena:instantToMain', function(index)
    TriggerServerEvent('nui:arena:instantToMain', index)
end)
RegisterNUICallback('nui:arena:useItem', function(index)
    TriggerServerEvent('nui:arena:useItem', index)
end)
RegisterNUICallback('nui:arena:giveItemToTarget', function(data)
    local targetSrc = tonumber(data.targetSrc)
    local targetHandle = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    local playerpos = GetEntityCoords(PlayerPedId())
    if targetHandle and #(playerpos - GetEntityCoords(targetHandle)) < 5.0 then
        TriggerServerEvent('nui:arena:giveItemToTarget', data)
    else
        Functions.SendNotification(_U('target_notnear'), 'warning')
    end
end)

-- SECONDARY INVENTORIES RENDER
Citizen.CreateThread(
    function()
        local modelhash = GetHashKey('p_v_43_safe_s')
        RequestModel(modelhash)
        while not HasModelLoaded(modelhash) do
            Citizen.Wait(10)
        end
        for i=1, #Config.FactionSafes, 1 do
            local obj = CreateObject(modelhash, Config.FactionSafes[i].pos, false, false, false)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            SetEntityHeading(obj, Config.FactionSafes[i].heading)
        end
        SetModelAsNoLongerNeeded(modelhash)

        while true do
            local letSleep = true
            Citizen.Wait(0)

            local playerpos = GetEntityCoords(PlayerPedId())

            for i=1, #Config.OtherInventories, 1 do
                local d = Config.OtherInventories[i]
                local dist = #(playerpos - d.pos)
                if dist < 5 then
                    letSleep = false
                    DrawMarker(0,d.pos+vector3(0.0, 0.0, 1.5),0.0,0.0,0.0,0.0,0.0,0.0,0.3,0.3,0.3,255,255,255,80,true,false,0,nil,nil,false)
                end
            end

            if letSleep then
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNUICallback('getNearbyPlayers', function(_, cb)
    local players = GetActivePlayers()
    local tbl = {}
    local playerpos = GetEntityCoords(PlayerPedId())
    for i=1, #players, 1 do
        if players[i] ~= PlayerId() then
            local dist = #(playerpos - GetEntityCoords(GetPlayerPed(players[i])))
            if dist < 5.0 then
                table.insert(tbl, GetPlayerServerId(players[i]))
            end
        end
    end
    if #tbl > 0 then
        cb(tbl)
    else
        Functions.SendNotification(_U('no_player_nearby'), 'info')
    end
end)

RegisterNetEvent('arena:itemNotification')
AddEventHandler('arena:itemNotification', function(name, formatname, count)
    SendNUIMessage({action = 'itemNotification', name = name, formatname = formatname, count = count})
end)

local function GetWeight()
    local weight = 0.0 
    if inventoryData then 
        for k,v in pairs(inventoryData) do 
            if v.itemdata then 
                weight = weight + (v.itemdata.weight * v.quantity)
            end
        end
    end
    return weight
end

-- exports["Inventory"]:GetInvSpace()
exports("GetInvSpace", function()
    
    return GetWeight(), Config.DefaultWeights['player']
end)

Citizen.CreateThread(function()
    while true do
        -- print(GetWeight() / Config.DefaultWeights['player'])
        Citizen.Wait(0)
        if inventoryData then
            if IsDisabledControlJustPressed(0, 157) then -- 1
                if inventoryData[1] ~= 'empty' then
                    if CanUse(1) then TriggerServerEvent('nui:arena:useItem', 1) end
                end
            elseif IsDisabledControlJustPressed(0, 158) then -- 2
                if inventoryData[2] ~= 'empty' then
                    if CanUse(2) then TriggerServerEvent('nui:arena:useItem', 2) end
                end
            elseif IsDisabledControlJustPressed(0, 160) then -- 3
                if inventoryData[3] ~= 'empty' then
                    if CanUse(3) then TriggerServerEvent('nui:arena:useItem', 3) end
                end
            elseif IsDisabledControlJustPressed(0, 164) then -- 4
                if inventoryData[4] ~= 'empty' then
                    if CanUse(4) then TriggerServerEvent('nui:arena:useItem', 4) end
                end
            elseif IsDisabledControlJustPressed(0, 165) then --5
                if inventoryData[5] ~= 'empty' then
                    if CanUse(5) then TriggerServerEvent('nui:arena:useItem', 5) end
                end
            end
        end
    end
end)

function IsWeapon(slot)
    if string.find(inventoryData[slot].item, "WEAPON") then return true end 
    return false 
end


function CanUse(slot)
    -- if they are in animation stop them from pulling out weapon 
    if IsWeapon(slot) and Player.InAnim then return false end 
    return true 
end


-- [[ WEAPON WHEEL ]] --


CreateThread(function()
    while true do
        Wait(0)
        BlockWeaponWheelThisFrame()
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 199, true)  
    end
end)


-- [[ RADIO WITH SHIFT AND G ]]

CreateThread(function()
    while true do 
        Wait(0)
        if IsControlPressed(0, 58) and IsControlPressed(0, 61) then 
            if API.HasItem("radio") then 
            TriggerEvent("radioGui") Wait(2500) end
        end
    end
end)