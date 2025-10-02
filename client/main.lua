local Config = require('config')
local isUIOpen = false
local canSpin = true
local currentCaseType = nil

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

    local uiItems = {}
    for _, item in ipairs(case.items) do
        local weight = item.weight or 1
        local percentage = (weight / totalWeight) * 100

        local uiItem = {
            id = item.id,
            name = item.name,
            value = item.value,
            amount = item.reward and item.reward.amount or 1,
            weight = weight,
            percentage = percentage,
            icon = item.icon
        }

        -- Check if it's a money reward or an item reward
        if item.reward and item.reward.type == 'money' then
            -- Use money.png for money rewards
            local moneyImage = GetItemImage('money')
            if moneyImage then
                uiItem.image = moneyImage
            end
        elseif item.item then
            -- Use item-specific image
            local imagePath = GetItemImage(item.item)
            if imagePath then
                uiItem.image = imagePath
            end
        end

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
        caseCount = caseCount
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

            -- Wait for animation to complete (8 seconds spin + 0.8 seconds centering)
            SetTimeout(8800, function()
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