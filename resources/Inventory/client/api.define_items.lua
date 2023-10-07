

function Item.Register(item, data) -- register item to the ReigsteredItems table 
    RegisteredItems[item] = data
end

function Item.RequiresAnimClearance(item) -- check if InAnim check is required for this item to be used
    return RegisteredItems[item].animClearance 
end

function Item.Use(itemid, slot)
    if Item.RequiresAnimClearance(itemid) and Player.InAnim then return end 
    RegisteredItems[itemid].func(itemid)
end

function API.UseItem(item, slot) -- this is just a translator, its really useless
    Item.Use(item, slot)
end
def("inventory.api:useItem", API.UseItem)





--[[
    MAIN ITEM REGISTER THREAD
]]

CreateThread(function()
    Item.Register("oxy", {
        func = function(item)
            if Player.Health() == 200 then return false end
            if Player.InVehicle() then 
            elseif not Player.InVehicle() then 
                loadAnimDict("mp_suicide")
                Player.InAnim = true
                TaskPlayAnim(Player.Ped(), "mp_suicide", "pill", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
                Wait(2000)
                StopAnimTask(Player.Ped(), "mp_suicide", "pill", 1.0)
            end
            print("Starting Oxy")
            API.RemoveItem(item, 1)
            if not healing then
                healing = true
            else
                return
            end
            
            local count = 30
            while count > 0 do
                Citizen.Wait(1000)
                count = count - 1
                SetEntityHealth(Player.Ped(), GetEntityHealth(Player.Ped()) + 4) 
            end
            healing = false
            return true
        end,
        animClearance = true
    })

    Item.Register("armour", {
        func = function(item)
            if Player.Armour() == 100 then return false end 
            Player.InAnim = true
            -- loadAnimDict("clothingshirt")  
            loadAnimDict("clothingtie")  	
            -- TaskPlayAnim(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_negative_a", 1.0, -1, -1, 50, 0, 0, 0, 0)
            exports["arena-newhud"]:progress("armor", "applying armour", 4000, false, true, {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                SetPlayerMaxArmour(PlayerId(), 100)
                SetPedArmour(Player.Ped(), 100)
                -- StopAnimTask(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 1.0)
                StopAnimTask(Player.Ped(), "clothingtie", "try_tie_negative_a", 1.0)
                Player.InAnim = false
                API.RemoveItem(item, 1)
            end, function()
                Player.InAnim = false
            end)
            return true
        end,
        animClearance = true
    })

    Item.Register("bandage", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.Health() >= 175 then return false end 
            local currentHealth = Player.Health()
            local healthToSet = currentHealth + 15
            if healthToSet >= 175 then 
                healthToSet = 175 
            end
            -- animation + set health
            TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
            Player.InAnim = true 
            exports["arena-newhud"]:progress("joint", "BANDAGING", 1500, false, true, {disableMovement = true, disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                SetEntityHealth(Player.Ped(), healthToSet)
                ClearPedTasksImmediately(Player.Ped())
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end, function()
                ClearPedTasksImmediately(Player.Ped())
                Player.InAnim = false
            end)
            return true
        end,
        animClearance = true
    })




    Item.Register("repairkit", {
        func = function(item)
            if Player.InVehicle() then return false end 
            local a = GetEntityCoords(Player.Ped(), 1)
            local b = GetOffsetFromEntityInWorldCoords(Player.Ped(), 0.0, 100.0, 0.0)
            local veh = Player.GetTargetVehicle(a, b)
            if veh == 0 then return false end 
            loadAnimDict("mini@repair")
            Player.InAnim = true
            TaskPlayAnim(Player.Ped(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
            SetVehicleDoorOpen(veh, 4, 1, 1)
            exports["arena-newhud"]:progress("armor", "repairing", 7500, false, true, {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                SetVehicleEngineHealth(veh, 9999)
                SetVehiclePetrolTankHealth(veh, 9999)
                SetVehicleFixed(veh)
                TriggerEvent("InteractSound_CL:PlayOnOne","airwrench", 0.1)
                StopAnimTask(Player.Ped(), "mini@repair", "fixing_a_player", 1.0)
                Player.InAnim = false
                API.RemoveItem(item, 1)
            end, function()
                Player.InAnim = false
            end)
            return true
        end,
        animClearance = true
    })

    Item.Register("radio", {
        func = function(item)
            TriggerEvent("radioGui")
            return true
        end,
        animClearance = false,
        onDrop = function(item)
            TriggerEvent("disableRadio")
        end,
    })

    Item.Register("joint", {
        func = function(item)
            if Player.InVehicle() then TriggerEvent("noticeme:Warn", "Cannot use joints in a car!") return false end 
            TaskStartScenarioInPlace(Player.Ped(), "WORLD_HUMAN_SMOKING_POT", 0, false)
            Player.InAnim = true
            exports["arena-newhud"]:progress("joint", "using joint", 2500, false, true, {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                SetPedArmour(Player.Ped(), Player.Armour() + 25)
                ClearPedTasks(Player.Ped())
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end, function()
                Player.InAnim = false
            end)
        end,
        animClearance = true
    })

    Item.Register("kevlar", {
        func = function(item)
            if Player.Armour() == 100 then return false end 
            if Player.InVehicle() and GetEntitySpeed(PlayerPedId()) < 1.0 then 
                exports["arena-newhud"]:progress("joint", "using kevlar", 1000, false, true, {disableMovement = false, disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                    SetPedArmour(Player.Ped(), 100)
                    API.RemoveItem(item, 1)
                    Player.InAnim = false
                end, function()
                    Player.InAnim = false
                end)
                return 
            elseif Player.InVehicle() and GetEntitySpeed(PlayerPedId()) > 1.0 then 
                return false
            elseif not Player.InVehicle() then 
                TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
                Player.InAnim = true 
                exports["arena-newhud"]:progress("joint", "using kevlar", 1000, false, true, {disableMovement = true, disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                    SetPedArmour(Player.Ped(), 100)
                    ClearPedTasksImmediately(Player.Ped())
                    API.RemoveItem(item, 1)
                    Player.InAnim = false
                end, function()
                    ClearPedTasksImmediately(Player.Ped())
                    Player.InAnim = false
                end)
            end
        end,
        animClearance = true
    })

    Item.Register("medkit", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.Health() == 200 then return false end 
            TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
            Player.InAnim = true 
            exports["arena-newhud"]:progress("joint", "healing", 2000, false, true, {disableMovement = true, disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                SetEntityHealth(Player.Ped(), 200)
                ClearPedTasksImmediately(Player.Ped())
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end, function()
                ClearPedTasksImmediately(Player.Ped())
                Player.InAnim = false
            end)
        end,
        animClearance = true
    })

    Item.Register("stamina", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.InStim then return false end 
            Player.InStim = true 
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
            API.RemoveItem(item, 1)
            TriggerEvent("notifyClient", "Using Stamina Shot", "centerRight", 5000)
            Wait(15000)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            Player.InStim = false 
        end,
        animClearance = true
    })


    -- Config.Loadouts = {
    --     {name = "LOADOUT_HEAVYPISTOL", format = "Heavy Pistol Loadout", kit = "heavypistol"},
    --     {name = "LOADOUT_M9", format = "M9 Beretta Loadout", kit = "m9"},
    --     {name = "LOADOUT_MP9", format = "MP9 Loadout", kit = "mp9"},
    --     {name = "LOADOUT_MCX", format = "MCX Loadout", kit = "mcx"},
    --     {name = "LOADOUT_AK47", format = "AK-47 Loadout", kit = "akm"},
    -- }


    for k,v in pairs(Config.Loadouts) do 
        local kit = v.kit 
        local name = v.name 
        local format = v.format 
        Item.Register(name, {
            func = function(item)
                if Player.InVehicle() then return false end 
                exports["arena-newhud"]:progress("loadout", "applying loadout", 2000, false, true, {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true,}, {}, {}, {}, function() -- Done
                    DoKitStuff(kit)
                    API.RemoveItem(item, 1)
                end, function() end)
            end,
        })
    end
end)
