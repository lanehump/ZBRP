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
                
                        for k,v in pairs(vehList) do
                            local distance = GetDistanceBetweenCoords(GetEntityCoords(veh), GetEntityCoords(v), false) 
                            if distance < 10 and veh ~= v then
                                SetEntityNoCollisionEntity(v, veh, false)
                            end
                    end
                end)
            else
                InSafeZone = false
                NetworkSetFriendlyFireOption(true)
            end
        end
        exports("insafezone", InSafeZone)
    end
end)
