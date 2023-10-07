API = {}
Item = {}
RegisteredItems = {}

abc = TriggerServerEvent -- hello cheaters :) 
def = RegisterNetEvent


function GetAPI()
    return API 
end 

exports("inventoryAPI", GetAPI)
exports("Inventory", GetAPI)