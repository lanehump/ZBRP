function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterCommand('car', function(source, args, rawCommand)
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0, 0.5))
    local veh = args[1] or "adder" -- Default to "adder" if no vehicle name is provided
    local vehiclehash = GetHashKey(veh)
    
    RequestModel(vehiclehash)
    
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                return
            end
        end

        local vehicle = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId()) + 90, 1, 0)
        SetVehicleModKit(vehicle, 0) -- Set the mod kit to default (0)

        -- Apply upgrades to the spawned vehicle
        SetVehicleMod(vehicle, 16, 4) -- Armor Upgrade Max = 4
        SetVehicleMod(vehicle, 11, 3) -- Engine Upgrade Max = 3
        SetVehicleMod(vehicle, 13, 3) -- Transmision Upgrade Max = 3
        SetVehicleMod(vehicle, 15, 3) -- Suspension Upgrade Max = 3
        SetVehicleMod(vehicle, 18, 0) -- Turbo Upgrade Max = ? Can't find max Upgrade Integer :(
        SetVehicleMod(vehicle, 12, 2) -- Brakes Upgrade Max = 2

        -- Add a spoiler as a visual upgrade using the representation you provided
        SetVehicleMod(vehicle, 0, 2) --  spoiler visual upgrade
        SetVehicleMod(vehicle, 1, 9) -- 
        SetVehicleMod(vehicle, 2, 2)
        SetVehicleMod(vehicle, 4, 2)
        SetVehicleMod(vehicle, 0, 2)
        
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)


        ShowNotification("Spawned " .. veh .. " with max upgrades including a spoiler.")
    end)
end)
