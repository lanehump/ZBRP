local hudState, listening, currentValues, lastValues, survival = false, false, {
    health = 0,
    food = 100,
    armor = 0,
    water = 100
}, {}, false

local hasFocus = false

local hudValues = {
    up = nil,
    left = nil
}

local kills = 0
local deaths = 0

AddEventHandler('baseevents:onPlayerDied', function()
    deaths = deaths + 1
end)
AddEventHandler('baseevents:onPlayerKilled', function()
    kills = kills + 1
end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(100) end 
    hudValues.up = GetResourceKvpString("arena_hud_up")
    hudValues.left = GetResourceKvpString("arena_hud_left")
    if hudValues.up == nil or hudValues.left == nil then  -- check if they are not set
        SetResourceKvp("arena_hud_up", "default")
        SetResourceKvp("arena_hud_left", "default")
    end
    Wait(1000)
    SendNUIMessage({
        action = "position",
        up = hudValues.up,
        left = hudValues.left
    })
    print("sent message")
end)
    

RegisterCommand("movehud", function()
    hasFocus = not hasFocus 
    SetNuiFocus(hasFocus, hasFocus)
end)

RegisterNUICallback("exit", function(data)
    print(data.up, data.left)
    hasFocus = false
    SetNuiFocus(hasFocus, hasFocus)
    SetResourceKvp("arena_hud_up", data.up)
    SetResourceKvp("arena_hud_left", data.left)
    TriggerEvent("notifyClient", "~g~Saving hud position", "centerRight", 2500)
end)

function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


Citizen.CreateThread(function()
    listening = true
    local playerPed, count = PlayerPedId(), 0
    currentValues["health"] = GetEntityHealth(playerPed)
    currentValues["armor"] = GetPedArmour(playerPed)

    while true do
        Wait(1)
        if (count == 0) then
            local playerPed = PlayerPedId()

            currentValues["health"] = GetEntityHealth(playerPed) - 100
            currentValues["armor"] = GetPedArmour(playerPed)


            -- if (currentValues['health'] < 1) then currentValues['food'] = 100 end

            -- local valueChanged = false

            -- for k, v in pairs(currentValues) do
            --     if (lastValues[k] == nil or lastValues[k] ~= v) then
            --         valueChanged = true
            --         lastValues[k] = v
            --     end
            -- end

            -- if (valueChanged) then

                SendNUIMessage({
                    action = 'updateall',
                    values = {
                        health = currentValues.health,
                        armor = currentValues.armor,
                        dead = IsEntityDead(PlayerPedId())
                    }
                })
            -- end

            count = 25
        end

        count = count - 1
    end
end)





toggleHud = function()
    hudState = not hudState

    SendNUIMessage({
        action = 'toggle',
        state = hudState
    })
end

CreateThread(function()
    Wait(5000)
    SendNUIMessage({
        action = 'toggle',
        state = true
    })
    hudState = true
end)

exports('toggleHud', toggleHud)


local HUD_ELEMENTS = {
    HUD = { id = 0, hidden = false },
    HUD_WANTED_STARS = { id = 1, hidden = true },
    HUD_WEAPON_ICON = { id = 2, hidden = true },
    HUD_CASH = { id = 3, hidden = true },
    HUD_MP_CASH = { id = 4, hidden = true },
    HUD_MP_MESSAGE = { id = 5, hidden = true },
    HUD_VEHICLE_NAME = { id = 6, hidden = true },
    HUD_AREA_NAME = { id = 7, hidden = true },
    HUD_VEHICLE_CLASS = { id = 8, hidden = true },
    HUD_STREET_NAME = { id = 9, hidden = true },
    HUD_HELP_TEXT = { id = 10, hidden = false },
    HUD_FLOATING_HELP_TEXT_1 = { id = 11, hidden = false },
    HUD_FLOATING_HELP_TEXT_2 = { id = 12, hidden = false },
    HUD_CASH_CHANGE = { id = 13, hidden = true },
    HUD_RETICLE = { id = 14, hidden = true },
    HUD_SUBTITLE_TEXT = { id = 15, hidden = false },
    HUD_RADIO_STATIONS = { id = 16, hidden = false },
    HUD_SAVING_GAME = { id = 17, hidden = false },
    HUD_GAME_STREAM = { id = 18, hidden = false },
    HUD_WEAPON_WHEEL = { id = 19, hidden = false },
    HUD_WEAPON_WHEEL_STATS = { id = 20, hidden = false },
    MAX_HUD_COMPONENTS = { id = 21, hidden = false },
    MAX_HUD_WEAPONS = { id = 22, hidden = false },
    MAX_SCRIPTED_HUD_COMPONENTS = { id = 141, hidden = false }
}

-- Parameter for hiding radar when not in a vehicle
local HUD_HIDE_RADAR_ON_FOOT = true

-- Main thread
Citizen.CreateThread(function()
    -- Loop forever and update HUD every frame
    while true do
        Citizen.Wait(0)
        -- If enabled only show radar when in a vehicle (use a zoomed out view)
        DisplayRadar(false)
        Draw2DText(0.01, 0.9, 'Kills: ' .. kills, 0.50)
        Draw2DText(0.01, 0.93, 'Deaths: ' .. deaths, 0.50)
        -- Hide other HUD components
        for key, val in pairs(HUD_ELEMENTS) do
            DisplayAmmoThisFrame(true)
            if val.hidden then
                HideHudComponentThisFrame(val.id)
            else
                ShowHudComponentThisFrame(val.id)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		for i = 1, 12 do
			EnableDispatchService(i, false)
		end
		SetPlayerWantedLevel(PlayerId(), 0, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
	end
end)


RegisterCommand("switchhud", function()
    if hudState then 
        SendNUIMessage({
            action = 'toggle',
            state = false
        })
        hudState = false 
        TriggerEvent("oldhud:show")
    elseif not hudState then 
        TriggerEvent("oldhud:hide")
        SendNUIMessage({
            action = 'toggle',
            state = true
        })
        hudState = true 
    end
end)

