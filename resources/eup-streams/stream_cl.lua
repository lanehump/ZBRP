Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _,clothing in pairs(Config.Clothing) do
            if (not HasStreamedTextureDictLoaded(clothing.texture)) then
                RequestStreamedTextureDict(clothing.texture, true)
                while (not HasStreamedTextureDictLoaded(clothing.texture)) do
                    Citizen.Wait(0)
                end
            end
        end
    end
end)