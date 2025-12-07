local Config = require('config')
local isUIOpen = false
local canSpin = true
local currentCaseType = nil

--- Generates a weighted display list where items appear based on their weight
--- @param items table The original items with weights
--- @param targetCount number The desired number of items to display
--- @return table Weighted list of items for display
local GenerateWeightedDisplayList = function(items, targetCount)
    local weightedList = {}
    local totalWeight = 0

    -- Calculate total weight
    for _, item in ipairs(items) do
        totalWeight = totalWeight + (item.weight or 1)
    end

    -- Calculate how many times each item should appear
    for _, item in ipairs(items) do
        local weight = item.weight or 1
        local percentage = weight / totalWeight
        local appearances = math.max(1, math.floor(percentage * targetCount))

        -- Add the item multiple times based on its weight
        for i = 1, appearances do
            table.insert(weightedList, item)
        end
    end

    -- Fill remaining slots with weighted random selection
    while #weightedList < targetCount do
        local rand = math.random() * totalWeight
        local current = 0

        for _, item in ipairs(items) do
            current = current + (item.weight or 1)
            if rand <= current then
                table.insert(weightedList, item)
                break
            end
        end
    end

    -- Shuffle the list to avoid predictable patterns
    for i = #weightedList, 2, -1 do
        local j = math.random(i)
        weightedList[i], weightedList[j] = weightedList[j], weightedList[i]
    end

    -- Additional shuffle to ensure different starting positions each time
    for i = #weightedList, 2, -1 do
        local j = math.random(i)
        weightedList[i], weightedList[j] = weightedList[j], weightedList[i]
    end

    return weightedList
end

--- Prepares items for UI display with images
--- @param caseType string The case type
--- @return table Prepared items for UI
local PrepareItemsForUI = function(caseType)
    local case = Config.Cases[caseType]
    if not case then return {} end

    -- Calculate total weight for percentage calculation
    local totalWeight = 0
    for _, item in ipairs(case.items) do
        totalWeight = totalWeight + (item.weight or 1)
    end

    -- First, prepare the base items with all their properties
    local baseItems = {}
    for _, item in ipairs(case.items) do
        local weight = item.weight or 1
        local percentage = (weight / totalWeight) * 100

        local baseItem = {
            id = item.id,
            name = item.name,
            value = item.value,
            amount = item.reward and item.reward.amount or 1,
            weight = weight,
            percentage = percentage,
            rarity = item.rarity,
            icon = item.icon,
            reward = item.reward
        }

        -- Check if it's a money reward or an item reward
        if item.reward and item.reward.type == 'money' then
            -- Use money.png for money rewards
            local moneyImage = GetItemImage('money')
            if moneyImage then
                baseItem.image = moneyImage
            end
        elseif item.item then
            -- Use item-specific image
            local imagePath = GetItemImage(item.item)
            if imagePath then
                baseItem.image = imagePath
            end
        end

        table.insert(baseItems, baseItem)
    end

    -- Generate weighted display list (approximately 50 items for smooth scrolling)
    local weightedItems = GenerateWeightedDisplayList(baseItems, 50)

    -- Create UI items from the weighted list
    local uiItems = {}
    for _, item in ipairs(weightedItems) do
        local uiItem = {
            id = item.id,
            name = item.name,
            value = item.value,
            amount = item.amount,
            weight = item.weight,
            percentage = item.percentage,
            rarity = item.rarity,
            icon = item.icon,
            image = item.image
        }
        table.insert(uiItems, uiItem)
    end

    return uiItems
end

--- Opens the lootbox UI for a specific case type
--- @param caseType string The case type to open
local OpenLootboxUI = function(caseType)
    if isUIOpen then return end

    local case = Config.Cases[caseType]
    if not case then
        ShowNotification('Invalid case type', 'error')
        return
    end

    currentCaseType = caseType
    isUIOpen = true

    local preparedItems = PrepareItemsForUI(caseType)

    -- Get the count of this case type in inventory
    local caseCount = lib.callback.await('lootbox:getCaseCount', false, caseType)

    SendNUIMessage({
        action = 'open',
        items = preparedItems,
        caseName = case.name,
        caseTitle = case.title or case.name,
        caseTitleColor = case.titleColor or '#FBBF24',
        caseCount = caseCount,
        spinDuration = Config.SpinDuration
    })

    SetNuiFocus(true, true)
end

--- Closes the lootbox UI
local CloseLootboxUI = function()
    if not isUIOpen then return end
    
    isUIOpen = false
    currentCaseType = nil
    
    SendNUIMessage({
        action = 'close'
    })
    
    SetNuiFocus(false, false)
end

--- NUI Callback for closing the UI
RegisterNUICallback('close', function(data, cb)
    CloseLootboxUI()
    cb('ok')
end)

--- NUI Callback for spinning the lootbox
RegisterNUICallback('spin', function(data, cb)
    if not canSpin or not currentCaseType then
        cb({ success = false, message = 'Cannot spin right now' })
        return
    end
    
    canSpin = false
    
    lib.callback('lootbox:requestSpin', false, function(item)
        if item then
            -- Update case count in UI after consuming one
            local newCaseCount = lib.callback.await('lootbox:getCaseCount', false, currentCaseType)

            SendNUIMessage({
                action = 'spinResult',
                itemId = item.id,
                caseCount = newCaseCount
            })

            -- Wait for animation to complete (spin duration + 0.8 seconds centering)
            SetTimeout(Config.SpinDuration + 800, function()
                lib.callback('lootbox:claimReward', false, function(result)
                    if not result.success then
                        ShowNotification('Failed to claim reward', 'error')
                    end

                    -- If player has no more cases, close UI after 1 second
                    if not result.hasMoreCases then
                        SetTimeout(1000, function()
                            CloseLootboxUI()
                        end)
                    end
                    -- If they have more cases, keep UI open for another spin
                end, currentCaseType)
            end)

            cb({ success = true })
        else
            cb({ success = false })
        end

        SetTimeout(Config.SpinCooldown, function()
            canSpin = true
        end)
    end, currentCaseType)
end)

--- Register event to handle case item usage
RegisterNetEvent('lootbox:openCase', function(caseType)
    if not Config.Cases[caseType] then
        ShowNotification('Invalid case type', 'error')
        return
    end
    OpenLootboxUI(caseType)
end)

--- Resource cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CloseLootboxUI()
    end
end)