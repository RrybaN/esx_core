if Config.CustomInventory ~= "ox" then return end

MySQL.ready(function()
    TriggerEvent("__cfx_export_ox_inventory_Items", function(ref)
        if ref then
            ESX.Items = ref()
        end
    end)

    AddEventHandler("ox_inventory:itemList", function(items)
        ESX.Items = items
    end)
end)

---@diagnostic disable-next-line: duplicate-set-field
ESX.GetItemLabel = function(item)
    item = exports.ox_inventory:Items(item)
    if item then
        return item.label
    end
end

function setPlayerInventory(playerId, xPlayer, inventory, isNew)
    local shared = json.decode(GetConvar("inventory:accounts", '["money"]'))

    local accounts = xPlayer.getAccounts(true)

    exports.ox_inventory:setPlayerInventory(xPlayer, inventory)

    for i = 1, #shared do
        local name = shared[i]

        if isNew then
            local startingAmount = Config.StartingAccountMoney[name]
            if startingAmount then
                exports.ox_inventory:AddItem(playerId, name, startingAmount)
            end
        else
            local amount = accounts[name]

            if amount >= 0 then
                exports.ox_inventory:SetItem(playerId, name, amount)
            end
        end
    end
end
