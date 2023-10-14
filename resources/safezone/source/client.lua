--================================--
--      Breezy_Safezones 1.0      --
--      by BreezyTheDev           --
--		GNU License v3.0		  --
--================================--
local InSafeZone = true
CreateThread(function()
    while true do
        playerCoords = GetEntityCoords(PlayerPedId()) -- Gets player coords every 5th of a second
        Wait(500)

        if InSafeZone then
            for _, i in ipairs(GetActivePlayers()) do
                if i ~= PlayerId() then
                  local closestPlayerPed = GetPlayerPed(i)
                  local veh = GetVehiclePedIsIn(closestPlayerPed, false)
                  SetEntityCollision(veh, GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
        else  
            for _, i in ipairs(GetActivePlayers()) do
                if i ~= PlayerId() then
                    local closestPlayerPed = GetPlayerPed(i)
                    local veh = GetVehiclePedIsIn(closestPlayerPed, false)
                            SetEntityCollision(veh, GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
                end
            end
        end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local locations = Config.Locations
        for i = 1, #locations do
            local x = locations[i][1];
            local y = locations[i][2];
            local z = locations[i][3];
            local radius = Config.Radius
            if #(playerCoords - vector3(x, y, z)) <= radius then
                InSafeZone = true
                NetworkSetFriendlyFireOption(false)
                Citizen.CreateThread(function()
                        Citizen.Wait(0)
                        local veh = GetVehiclePedIsIn(PlayerPedId())
                        local vehList = GetGamePool('CVehicle')
                end)
            else
                InSafeZone = false
                NetworkSetFriendlyFireOption(true)
            end
        end

        exports("insafezone", function ()
            return InSafeZone
        end)
    end
end)
