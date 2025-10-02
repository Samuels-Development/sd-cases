ShowNotification = function(src, message, type)
    TriggerClientEvent('sd-lootbox:client:ShowNotification', src, message, type)
end

--- Dynamically selects and returns the appropriate function for retrieving a player object
--- based on the configured framework.
---@return function A function that returns the player object when called with server ID
local CreateGetPlayerFunction = function()
    if Framework == 'esx' then
        return function(source)
            return ESX.GetPlayerFromId(source)
        end
    elseif Framework == 'qb' or Framework == 'qbx' then
        return function(source)
            return QBCore.Functions.GetPlayer(source)
        end
    else
        return function(source)
            error(string.format("Unsupported framework. Unable to retrieve player object for source: %s", source))
            return nil
        end
    end
end

GetPlayer = CreateGetPlayerFunction()

Inventory = {}

local codemInv = 'codem-inventory'
local oxInv = 'ox_inventory'
local qbInv = 'qb-inventory'
local qsInv = 'qs-inventory'
local qsProInv = 'qs-inventory-pro'
local origenInv = 'origen_inventory'

local inventorySystem
if GetResourceState(codemInv) == 'started' then
    inventorySystem = 'codem'
elseif GetResourceState(oxInv) == 'started' then
    inventorySystem = 'ox'
elseif GetResourceState(qbInv) == 'started' then
    inventorySystem = 'qb'
elseif GetResourceState(qsProInv) == 'started' then
    inventorySystem = 'qs-pro'
elseif GetResourceState(qsInv) == 'started' then
    inventorySystem = 'qs'
elseif GetResourceState(origenInv) == 'started' then
    inventorySystem = 'origen'
end

--- Dynamically selects the appropriate function to check if a player has an item.
--- @return function The function to check if a player has an item.
local HasItem = function()
    if inventorySystem == 'codem' then
        return function(player, item, source)
            return exports[codemInv]:GetItemsTotalAmount(source, item)
        end
    elseif inventorySystem == 'ox' then
        return function(player, item, source)
            return exports[oxInv]:Search(source, 'count', item)
        end
    elseif inventorySystem == 'qb' then
        return function(player, item, source)
            local itemAmount = exports[qbInv]:GetItemCount(source, item)
            return itemAmount or 0
        end
    elseif inventorySystem == 'qs-pro' then
        return function(player, item, source)
            return exports[qsProInv]:GetItemTotalAmount(source, item)
        end
    elseif inventorySystem == 'qs' then
        return function(player, item, source)
            local itemAmount = exports[qsInv]:GetItemTotalAmount(source, item)
            if not itemAmount then return 0 end
            return itemAmount or 0
        end
    elseif inventorySystem == 'origen' then
        return function(player, item, source)
            return exports[origenInv]:getItemCount(source, item, false, false) or 0
        end
    else
        if Framework == 'esx' then
            return function(player, item)
                local itemData = player.getInventoryItem(item)
                if itemData then return itemData.count or itemData.amount else return 0 end
            end
        elseif Framework == 'qb' then
            return function(player, item)
                local itemData = player.Functions.GetItemByName(item)
                if itemData then return itemData.amount or itemData.count else return 0 end
            end
        else
            return function()
                error("Unsupported framework or inventory state for HasItem.")
            end
        end
    end
end

local CheckInventory = HasItem()

--- Dynamically selects the appropriate function to check if a player can carry an item.
--- @return function The function to check if a player can carry an item.
local CanCarryItem = function()
    if inventorySystem == 'codem' then
        return function(player, item, count, metadata, source)
            return true
        end
    elseif inventorySystem == 'ox' then
        return function(player, item, count, metadata, source)
            return exports[oxInv]:CanCarryItem(source, item, count, metadata)
        end
    elseif inventorySystem == 'qb' then
        return function(player, item, count, slot, source)
            return exports[qbInv]:CanAddItem(source, item, count)
        end
    elseif inventorySystem == 'qs-pro' then
        return function(player, item, count, metadata, source)
            return exports[qsProInv]:CanCarryItem(source, item, count)
        end
    elseif inventorySystem == 'qs' then
        return function(player, item, count, slot, source)
            return exports[qsInv]:CanCarryItem(source, item, count)
        end
    elseif inventorySystem == 'origen' then
        return function(player, item, count, metadata, source)
            return exports[origenInv]:CanCarryItem(source, item, count)
        end
    else
        if Framework == 'esx' then
            return function(player, item, count)
                local currentItem = player.getInventoryItem(item)
                if currentItem then
                    local newWeight = player.getWeight() + (currentItem.weight * count)
                    return newWeight <= player.getMaxWeight()
                end
                return false
            end
        elseif Framework == 'qb' then
            return function(player, item, count)
                local totalWeight = QBCore.Player.GetTotalWeight(player.PlayerData.items)
                if not totalWeight then return false end
                local itemInfo = QBCore.Shared.Items[item:lower()]
                if not itemInfo then return false end
                return (totalWeight + (itemInfo.weight * count)) <= 120000
            end
        else
            return function()
                error("Unsupported framework for CanCarryItem.")
            end
        end
    end
end

local CanCarry = CanCarryItem()

--- Dynamically selects the appropriate function to add an item to a player's inventory.
--- @return function The function to add an item.
local AddItem = function()
    if inventorySystem == 'codem' then
        return function(player, item, count, metadata, slot, source)
            return exports[codemInv]:AddItem(source, item, count, slot or false, metadata or false)
        end
    elseif inventorySystem == 'ox' then
        return function(player, item, count, metadata, slot, source)
            return exports[oxInv]:AddItem(source, item, count, metadata or false, slot or false)
        end
    elseif inventorySystem == 'qb' then
        return function(player, item, count, metadata, slot, source)
            exports[qbInv]:AddItem(source, item, count, slot or false, metadata or false, 'sd-inventory:AddItem')
            TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add', count)
        end
    elseif inventorySystem == 'qs-pro' then
        return function(player, item, count, metadata, slot, source)
            return exports[qsProInv]:AddItem(source, item, count, slot or false, metadata or false)
        end
    elseif inventorySystem == 'qs' then
        return function(player, item, count, metadata, slot, source)
            return exports[qsInv]:AddItem(source, item, count, slot or false, metadata or false)
        end
    elseif inventorySystem == 'origen' then
        return function(player, item, count, metadata, slot, source)
            return exports[origenInv]:addItem(source, item, count, metadata, slot)
        end
    else
        if Framework == 'esx' then
            return function(player, item, count, metadata, slot)
                player.addInventoryItem(item, count, metadata, slot)
            end
        elseif Framework == 'qb' then
            return function(player, item, count, metadata, slot, source)
                player.Functions.AddItem(item, count, slot, metadata)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add', count)
            end
        else
            return function()
                error("Unsupported framework or inventory state for AddItem.")
            end
        end
    end
end

local AddItemToInventory = AddItem()

--- Dynamically selects the appropriate function to remove an item from a player's inventory.
--- @return function The function to remove an item.
local RemoveItem = function()
    if inventorySystem == 'codem' then
        return function(player, item, count, metadata, slot, source)
            return exports[codemInv]:RemoveItem(source, item, count, slot or false)
        end
    elseif inventorySystem == 'ox' then
        return function(player, item, count, metadata, slot, source)
            return exports[oxInv]:RemoveItem(source, item, count, metadata or false, slot or false)
        end
    elseif inventorySystem == 'qb' then
        return function(player, item, count, metadata, slot, source)
            exports[qbInv]:RemoveItem(source, item, count, slot or false, 'sd-inventory:RemoveItem')
            TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", count)
        end
    elseif inventorySystem == 'qs-pro' then
        return function(player, item, count, metadata, slot, source)
            return exports[qsProInv]:RemoveItem(source, item, count, slot or false, metadata or false)
        end
    elseif inventorySystem == 'qs' then
        return function(player, item, count, metadata, slot, source)
            return exports[qsInv]:RemoveItem(source, item, count, slot or false, metadata or false)
        end
    elseif inventorySystem == 'origen' then
        return function(player, item, count, metadata, slot, source)
            return exports[origenInv]:removeItem(source, item, count, metadata, slot)
        end
    else
        if Framework == 'esx' then
            return function(player, item, count, metadata, slot)
                player.removeInventoryItem(item, count, metadata or false, slot or false)
            end
        elseif Framework == 'qb' then
            return function(player, item, count, slot, metadata, source)
                player.Functions.RemoveItem(item, count, slot, metadata or false)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", count)
            end
        else
            return function()
                error("RemoveItem function is not supported in the current framework.")
            end
        end
    end
end

local RemoveItemFromInventory = RemoveItem()

--- Dynamically selects the appropriate function to register a usable item.
--- @return function The function to register a usable item.
local RegisterUsableItem = function()
    if inventorySystem == 'ox' then
        return function(item, cb)
            local exportName = 'use' .. item:gsub("^%l", string.upper)
            exports(exportName, function(event, item, inventory, slot, data)
                if event == 'usingItem' then
                    cb(inventory.id, item, inventory, slot, data)
                end
            end)
        end
    elseif inventorySystem == 'qs-pro' then
        return function(item, cb)
            return exports[qsProInv]:CreateUsableItem(item, cb)
        end
    elseif inventorySystem == 'origen' then
        return function(item, cb)
            return exports[origenInv]:CreateUseableItem(item, cb)
        end
    else
        if Framework == 'esx' then
            return function(item, cb)
                ESX.RegisterUsableItem(item, cb)
            end
        elseif Framework == 'qb' then
            return function(item, cb)
                QBCore.Functions.CreateUseableItem(item, cb)
            end
        else
            return function(item, cb)
                error("RegisterUsableItem function is not supported in the current framework.")
            end
        end
    end
end

local RegisterUsableItemInInventory = RegisterUsableItem()

--- Registers a function to be called when a player uses an item.
--- @param item string The item's name.
--- @param cb function The callback function to execute when the item is used.
Inventory.RegisterUsableItem = function(item, cb)
    RegisterUsableItemInInventory(item, cb)
end

--- Returns the amount of a specific item a player has.
--- @param source number The player's server ID.
--- @param item string The item's name.
--- @return number The amount of the specified item the player has.
Inventory.HasItem = function(source, item)
    local player = GetPlayer(source)
    if player == nil then return 0 end
    return CheckInventory(player, item, source)
end

--- Checks if a player can carry an item.
--- @param source number The player's server ID.
--- @param item string The item's name.
--- @param count number The amount of the item to check.
--- @param slot number|nil The inventory slot, if applicable.
--- @return boolean True if the player can carry the item, false otherwise.
Inventory.CanCarry = function(source, item, count, slot)
    local player = GetPlayer(source)
    if player then
        return CanCarry(player, item, count, slot, source)
    end
    return false
end

--- Adds an item to a player's inventory.
--- @param source number The player's server ID.
--- @param item string The item's name.
--- @param count number The amount of the item to add.
--- @param metadata table|nil Additional metadata for the item, if applicable.
--- @param slot number|nil The inventory slot to add the item to, if applicable.
Inventory.AddItem = function(source, item, count, metadata, slot)
    local player = GetPlayer(source)
    if player then
        AddItemToInventory(player, item, count, metadata, slot, source)
    end
end

--- Removes an item from a player's inventory.
--- @param source number The player's server ID.
--- @param item string The item's name.
--- @param count number The amount of the item to remove.
--- @param slot number|nil The inventory slot to remove the item from, if applicable.
--- @param metadata table|nil Additional metadata for the item, if applicable.
Inventory.RemoveItem = function(source, item, count, metadata, slot)
    local player = GetPlayer(source)
    if player then
        RemoveItemFromInventory(player, item, count, metadata, slot, source)
    end
end

Money = {}

--- Converts money type to framework-specific variant
---@param moneyType string The original money type
---@return string The converted money type
local ConvertMoneyType = function(moneyType)
    if moneyType == 'money' and (Framework == 'qb' or Framework == 'qbx') then
        return 'cash'
    elseif moneyType == 'cash' and Framework == 'esx' then
        return 'money'
    else
        return moneyType
    end
end

--- Creates framework-specific function for adding money
---@return function Function to add money to player
local CreateAddMoneyFunction = function()
    if Framework == 'esx' then
        return function(player, moneyType, amount)
            player.addAccountMoney(ConvertMoneyType(moneyType), amount)
        end
    elseif Framework == 'qb' or Framework == 'qbx' then
        return function(player, moneyType, amount)
            player.Functions.AddMoney(ConvertMoneyType(moneyType), amount)
        end
    else
        return function()
            error("Unsupported framework for AddMoney.")
        end
    end
end

--- Creates framework-specific function for removing money
---@return function Function to remove money from player
local CreateRemoveMoneyFunction = function()
    if Framework == 'esx' then
        return function(player, moneyType, amount)
            player.removeAccountMoney(ConvertMoneyType(moneyType), amount)
        end
    elseif Framework == 'qb' or Framework == 'qbx' then
        return function(player, moneyType, amount)
            player.Functions.RemoveMoney(ConvertMoneyType(moneyType), amount)
        end
    else
        return function()
            error("Unsupported framework for RemoveMoney.")
        end
    end
end

--- Creates framework-specific function for getting player funds
---@return function Function to get player's account funds
local CreateGetFundsFunction = function()
    if Framework == 'esx' then
        return function(player, moneyType)
            local account = player.getAccount(ConvertMoneyType(moneyType))
            return account and account.money or 0
        end
    elseif Framework == 'qb' or Framework == 'qbx' then
        return function(player, moneyType)
            return player.PlayerData.money[ConvertMoneyType(moneyType)] or 0
        end
    else
        return function()
            error("Unsupported framework for GetPlayerFunds.")
        end
    end
end

-- Initialize money management functions
local AddMoneyToPlayer = CreateAddMoneyFunction()
local RemoveMoneyFromPlayer = CreateRemoveMoneyFunction()
local GetPlayerAccountFunds = CreateGetFundsFunction()

--- Adds money to a player's account
---@param source number The player's server ID
---@param moneyType string The type of money to add
---@param amount number The amount of money to add
Money.AddMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    if player then 
        AddMoneyToPlayer(player, moneyType, amount) 
    end
end

--- Removes money from a player's account
---@param source number The player's server ID
---@param moneyType string The type of money to remove
---@param amount number The amount of money to remove
Money.RemoveMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    if player then 
        RemoveMoneyFromPlayer(player, moneyType, amount) 
    end
end

--- Gets the amount of money in a player's account
---@param source number The player's server ID
---@param moneyType string The type of money to check
---@return number The amount of money
Money.GetPlayerAccountFunds = function(source, moneyType)
    local player = GetPlayer(source)
    return player and GetPlayerAccountFunds(player, moneyType) or 0
end