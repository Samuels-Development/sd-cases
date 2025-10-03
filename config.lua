return {
    -- Spin animation settings
    SpinDuration = 10000, -- 10 seconds
    SpinCooldown = 3000, -- 3 seconds cooldown between spins

    -- Case definitions - item names map to case types
    -- WEIGHT SYSTEM EXPLANATION:
    -- The "weight" value determines the probability of getting each item when opening a case.
    -- Higher weight = higher chance of receiving that item
    -- The probability is calculated as: item_weight / total_weight_of_all_items
    --
    -- Example for fleeca_case:
    -- Total weight = 60 + 40 + 25 + 10 + 5 = 140
    -- Marked Bills (weight 60): 60/140 = 42.86% chance
    -- Bank Cards (weight 40): 40/140 = 28.57% chance
    -- Band of Notes (weight 25): 25/140 = 17.86% chance
    -- Advanced Lockpick (weight 10): 10/140 = 7.14% chance
    -- Diamond Ring (weight 5): 5/140 = 3.57% chance
    --
    -- Tips for configuring weights:
    -- - Common items (Gray): weight 50-100+ (40%+ drop chance - very likely to drop)
    -- - Uncommon items (Green): weight 30-50 (25-40% drop chance - fairly common)
    -- - Rare items (Blue): weight 15-30 (15-25% drop chance - moderate chance)
    -- - Epic items (Purple): weight 5-15 (5-15% drop chance - low chance)
    -- - Legendary items (Gold): weight 1-5 (1-5% drop chance - very low chance)
    -- - Mythic items (Red): weight <1 (<1% drop chance - extremely rare)
    Cases = {
        fleeca_case = { -- Item Name
            name = 'Fleeca Bank Case',
            title = 'FLEECA CASE',
            titleColor = '#10B981',
            items = {
                {
                    id = 1,
                    name = 'Marked Bills', -- Common (Gray)
                    weight = 80,
                    reward = {
                        type = 'money',
                        amount = 250,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 2,
                    name = 'Bank Cards', -- Uncommon (Green)
                    item = 'security_card_01',
                    weight = 45,
                    reward = {
                        type = 'item',
                        item = 'security_card_01',
                        amount = 1
                    }
                },
                {
                    id = 3,
                    name = 'Band of Notes', -- Rare (Blue)
                    item = 'bands',
                    weight = 20,
                    reward = {
                        type = 'item',
                        item = 'bands',
                        amount = 5
                    }
                },
                {
                    id = 4,
                    name = 'Advanced Lockpick', -- Epic (Purple)
                    item = 'advancedlockpick',
                    weight = 8,
                    reward = {
                        type = 'item',
                        item = 'advancedlockpick',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Diamond Ring', -- Legendary (Gold)
                    item = 'diamond_ring',
                    weight = 3,
                    reward = {
                        type = 'item',
                        item = 'diamond_ring',
                        amount = 1
                    }
                },
                {
                    id = 6,
                    name = 'Gold Bar', -- Mythic (Red)
                    item = 'goldbar',
                    weight = 0.5,
                    reward = {
                        type = 'item',
                        item = 'goldbar',
                        amount = 1
                    }
                }
            }
        },
        house_case = {
            name = 'House Robbery Case',
            title = 'HOUSE BURGLARY CASE',
            titleColor = '#F59E0B',
            items = {
                {
                    id = 1,
                    name = 'Cash Stash',
                    weight = 50,
                    reward = {
                        type = 'money',
                        amount = 150,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 2,
                    name = 'Gold Chain',
                    item = 'goldchain',
                    weight = 35,
                    reward = {
                        type = 'item',
                        item = 'goldchain',
                        amount = 3
                    }
                },
                {
                    id = 3,
                    name = 'Small TV',
                    item = 'small_tv',
                    weight = 30,
                    reward = {
                        type = 'item',
                        item = 'small_tv',
                        amount = 1
                    }
                },
                {
                    id = 4,
                    name = 'Rolex Watch',
                    item = 'rolex',
                    weight = 15,
                    reward = {
                        type = 'item',
                        item = 'rolex',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Toaster',
                    item = 'toaster',
                    weight = 8,
                    reward = {
                        type = 'item',
                        item = 'toaster',
                        amount = 1
                    }
                },
                {
                    id = 6,
                    name = 'Safe Contents',
                    weight = 3,
                    reward = {
                        type = 'money',
                        amount = 1000,
                        moneyType = 'cash'
                    }
                }
            }
        },
        chopshop_case = {
            name = 'Chop Shop Case',
            title = 'CHOP SHOP CASE',
            titleColor = '#EF4444',
            items = {
                {
                    id = 1,
                    name = 'Scrap Metal',
                    item = 'metalscrap',
                    weight = 60,
                    reward = {
                        type = 'item',
                        item = 'metalscrap',
                        amount = 15
                    }
                },
                {
                    id = 2,
                    name = 'Steel Parts',
                    item = 'steel',
                    weight = 40,
                    reward = {
                        type = 'item',
                        item = 'steel',
                        amount = 5
                    }
                },
                {
                    id = 3,
                    name = 'Nitrous',
                    item = 'nitrous',
                    weight = 15,
                    reward = {
                        type = 'item',
                        item = 'nitrous',
                        amount = 1
                    }
                },
                {
                    id = 4,
                    name = 'Electronic Kit',
                    item = 'electronickit',
                    weight = 5,
                    reward = {
                        type = 'item',
                        item = 'electronickit',
                        amount = 1
                    }
                }
            }
        },
        jewelry_case = {
            name = 'Jewelry Store Case',
            title = 'VANGELICO CASE',
            titleColor = '#A855F7',
            items = {
                {
                    id = 1,
                    name = 'Gold Chains',
                    item = 'goldchain',
                    weight = 50,
                    reward = {
                        type = 'item',
                        item = 'goldchain',
                        amount = 3
                    }
                },
                {
                    id = 2,
                    name = 'Diamond Ring',
                    item = 'diamond_ring',
                    weight = 30,
                    reward = {
                        type = 'item',
                        item = 'diamond_ring',
                        amount = 1
                    }
                },
                {
                    id = 3,
                    name = 'Gold Bar',
                    item = 'goldbar',
                    weight = 15,
                    reward = {
                        type = 'item',
                        item = 'goldbar',
                        amount = 2
                    }
                },
                {
                    id = 4,
                    name = 'Luxury Watch',
                    item = 'rolex',
                    weight = 20,
                    reward = {
                        type = 'item',
                        item = 'rolex',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Roll of Notes',
                    item = 'rolls',
                    weight = 3,
                    reward = {
                        type = 'item',
                        item = 'rolls',
                        amount = 1
                    }
                }
            }
        },
        pacific_case = {
            name = 'Pacific Bank Case',
            title = 'PACIFIC STANDARD CASE',
            titleColor = '#FFD700',
            items = {
                {
                    id = 1,
                    name = 'Gold Bars',
                    item = 'goldbar',
                    weight = 35,
                    reward = {
                        type = 'item',
                        item = 'goldbar',
                        amount = 2
                    }
                },
                {
                    id = 2,
                    name = 'Mega Cash Bundle',
                    weight = 40,
                    reward = {
                        type = 'money',
                        amount = 2000,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 3,
                    name = 'Band of Notes',
                    item = 'bands',
                    weight = 20,
                    reward = {
                        type = 'item',
                        item = 'bands',
                        amount = 3
                    }
                },
                {
                    id = 4,
                    name = 'Crypto USB',
                    item = 'cryptostick',
                    weight = 10,
                    reward = {
                        type = 'item',
                        item = 'cryptostick',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Secured Safe',
                    item = 'secured_safe',
                    weight = 2,
                    reward = {
                        type = 'item',
                        item = 'secured_safe',
                        amount = 1
                    }
                }
            }
        },
        casino_case = {
            name = 'Casino Heist Case',
            title = 'DIAMOND CASINO CASE',
            titleColor = '#DC2626',
            items = {
                {
                    id = 1,
                    name = 'Roll of Notes',
                    item = 'rolls',
                    weight = 60,
                    reward = {
                        type = 'item',
                        item = 'rolls',
                        amount = 10
                    }
                },
                {
                    id = 2,
                    name = 'Cash Trolley',
                    weight = 30,
                    reward = {
                        type = 'money',
                        amount = 1500,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 3,
                    name = 'Expensive Champagne',
                    item = 'expensive_champagne',
                    weight = 25,
                    reward = {
                        type = 'item',
                        item = 'expensive_champagne',
                        amount = 1
                    }
                },
                {
                    id = 4,
                    name = 'Diamond Necklace',
                    item = 'md_diamondnecklace',
                    weight = 10,
                    reward = {
                        type = 'item',
                        item = 'md_diamondnecklace',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Presidential Watch',
                    item = 'md_presidentialwatch',
                    weight = 1,
                    reward = {
                        type = 'item',
                        item = 'md_presidentialwatch',
                        amount = 1
                    }
                }
            }
        }
    }
}
