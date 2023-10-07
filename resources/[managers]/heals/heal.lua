

RegisterCommand('h', function(source, args, rawCommand)
    RequestAnimDict("mp_suicide")
    TaskPlayAnim(GetPlayerPed(-1), "mp_suicide", "pill", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    local finished = exports["erp_progressbar"]:taskBar({
        length = 3500,
        text = "Vicodin"
      })
	ClearPedTasks(GetPlayerPed(-1))
    if (finished == 100) then
        local count = math.random(30, 60)

        while count > 0 do
            Wait(1000)
            count = count - 1
            healAmount = math.random(1, 4)
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) + healAmount)
        end
    end
end)



RegisterCommand('a', function(source, args, rawCommand)
    RequestAnimDict("clothingshirt")
    TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 1.0, -1, -1, 50, 0, 0, 0, 0)
    local finished = exports["erp_progressbar"]:taskBar({
        length = 7500,
        text = "Medium Armor"
      })
    ClearPedTasks(GetPlayerPed(-1))
    if (finished == 100) then
        AddArmourToPed(GetPlayerPed(-1), 60)
    end
end)

RegisterCommand('kill', function(source, args, rawCommand)
    SetEntityHealth(GetPlayerPed(-1), 0)
end)

