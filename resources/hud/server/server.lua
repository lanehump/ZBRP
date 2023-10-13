RegisterServerEvent('KilledWhateverShit')
AddEventHandler('KilledWhateverShit', function(killer)
    if killer ~= 0 then
        TriggerClientEvent("Kill:Add",killer)
    end
end)