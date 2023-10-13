--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
--------------------------------------

RegisterNetEvent("wld:delallveh")
AddEventHandler("wld:delallveh", function ()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
                DeleteVehicle(vehicle) 
            end
        end
    end
end)

RegisterNetEvent("wld:delallvehauto")
AddEventHandler("wld:delallvehauto", function ()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
                DeleteVehicle(vehicle) 
            end
        end
    end
end)

RegisterKeyMapping('dv', 'Delete Vehicle', 'keyboard', 'k')

RegisterCommand('dv', function()
    local InSafeZone = exports['safezone']:insafezone()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    if InSafeZone then
        SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
        SetEntityAsMissionEntity(vehicle, true, true) 
        DeleteVehicle(vehicle)
        print("i worked")
    end

end)
