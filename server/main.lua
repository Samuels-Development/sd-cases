local Config = require('config')
local playerCooldowns = {}
local playerPendingRewards = {}

-- Register all case items as usable
CreateThread(function()
    for caseItem, _ in pairs(Config.Cases) do
        Inventory.RegisterUsableItem(caseItem, function(source, _)
            TriggerClientEvent('lootbox:openCase', source, caseItem)
        end)
    end
end)

--- Gets a weighted random item from the case
--- @param caseType string The case type
--- @return table The selected item
local GetWeightedRandomItem = function(caseType)
    local case = Config.Cases[caseType]
    if not case then return nil end

    local totalWeight = 0
    local itemWeights = {}

    for _, item in ipairs(case.items) do
        local weight = tonumber(item.weight) or 1
        totalWeight = totalWeight + weight
        table.insert(itemWeights, { item = item, weight = weight })
    end

    if #itemWeights == 0 then
        error("No items in case: " .. caseType)
        return nil
    end

    if type(totalWeight) ~= 'number' or totalWeight <= 0 then
        error(string.format("Invalid totalWeight in case %s: %s", caseType, tostring(totalWeight)))
        return nil
    end

    local random = math.random() * totalWeight
    local currentWeight = 0

    for _, data in ipairs(itemWeights) do
        currentWeight = currentWeight + data.weight
        if random <= currentWeight then
            return data.item
        end
    end

    return itemWeights[1].item
end

--- Gives reward to player based on reward configuration
--- @param source number Player server ID
--- @param reward table Reward configuration
--- @param itemData table The item data containing amount multiplier
local GiveReward = function(source, reward, itemData)
    if not reward then return end
    
    local finalAmount = reward.amount * (itemData.amount or 1)
    
    if reward.type == 'money' then
        Money.AddMoney(source, reward.moneyType or 'cash', finalAmount)
        ShowNotification(source, string.format('You received $%d!', finalAmount), 'success')
    elseif reward.type == 'item' then
        if Inventory.CanCarry(source, reward.item, finalAmount) then
            Inventory.AddItem(source, reward.item, finalAmount)
            ShowNotification(source, string.format('You received %dx %s!', finalAmount, itemData.name), 'success')
        else
            ShowNotification(source, 'You cannot carry this item!', 'error')
            return false
        end
    end
    
    print(string.format('[Lootbox] Player %s received: %s x%d', source, itemData.name, finalAmount))
    return true
end

--- Checks if player has the case item
--- @param source number Player server ID
--- @param caseType string The case type
--- @return boolean Whether player has the case
local PlayerHasCase = function(source, caseType)
    return Inventory.HasItem(source, caseType) >= 1
end

--- Consumes the case item
--- @param source number Player server ID
--- @param caseType string The case type
local ConsumeCase = function(source, caseType)
    Inventory.RemoveItem(source, caseType, 1)
    print(string.format('[Lootbox] Player %s opened %s case', source, caseType))
end

--- Callback to get the count of a specific case type
--- @param source number Player server ID
--- @param caseType string The case type
--- @return number The count of cases
lib.callback.register('lootbox:getCaseCount', function(source, caseType)
    return Inventory.HasItem(source, caseType)
end)

--- Callback to request spin and get the reward
--- @param source number Player server ID
--- @param caseType string The case type
--- @return table|nil The winning item or nil if cannot spin
lib.callback.register('lootbox:requestSpin', function(source, caseType)
    if playerCooldowns[source] and playerCooldowns[source] > GetGameTimer() then
        ShowNotification(source, 'Please wait before spinning again', 'error')
        return nil
    end

    local case = Config.Cases[caseType]
    if not case then
        ShowNotification(source, 'Invalid case type', 'error')
        return nil
    end

    if not PlayerHasCase(source, caseType) then
        ShowNotification(source, 'You don\'t have this case!', 'error')
        return nil
    end

    ConsumeCase(source, caseType)
    playerCooldowns[source] = GetGameTimer() + Config.SpinCooldown
    
    local item = GetWeightedRandomItem(caseType)
    if not item then
        ShowNotification(source, 'Error selecting item', 'error')
        return nil
    end
    
    playerPendingRewards[source] = {
        item = item,
        timestamp = GetGameTimer()
    }
    
    return item
end)

--- Callback to claim the reward after animation
--- @param source number Player server ID
--- @param caseType string The case type that was opened
--- @return table Result with success status and whether player has more cases
lib.callback.register('lootbox:claimReward', function(source, caseType)
    local pending = playerPendingRewards[source]
    if not pending then
        return { success = false, hasMoreCases = false }
    end

    if GetGameTimer() - pending.timestamp > 30000 then
        playerPendingRewards[source] = nil
        return { success = false, hasMoreCases = false }
    end

    local success = false
    if pending.item.reward then
        local rewardGiven = GiveReward(source, pending.item.reward, pending.item)
        if rewardGiven then
            success = true
            playerPendingRewards[source] = nil
        end
    end

    -- Check if player has more cases of the same type
    local hasMoreCases = PlayerHasCase(source, caseType)

    return { success = success, hasMoreCases = hasMoreCases }
end)


--- Cleanup on player disconnect
AddEventHandler('playerDropped', function()
    local source = source
    playerCooldowns[source] = nil
    playerPendingRewards[source] = nil
end)