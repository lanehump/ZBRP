local abc = TriggerServerEvent 
local def = RegisterNetEvent


function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(100) end 
    return true 
end


