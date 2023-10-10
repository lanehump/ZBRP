--================================--
--      Breezy_Safezones 1.0      --
--      by BreezyTheDev           --
--		GNU License v3.0		  --
--================================--

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
                NetworkSetFriendlyFireOption(false)
            else
                NetworkSetFriendlyFireOption(true)
            end
        end
    end
end)