--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
--------------------------------------

RegisterCommand(Config.commandName, function(source, args, rawCommand, user)
TriggerClientEvent("wld:delallveh", -1) end, Config.restricCommand)


local delay = 1000 * 60 * 5 -- just edit this to your needed delay (30 minutes in this example)
Citizen.CreateThread(function()
print("Vehicles Deleted")
TriggerClientEvent("wld:delallvehauto", -1)
end)
