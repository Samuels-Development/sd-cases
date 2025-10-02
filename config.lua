return {
    -- Spin animation settings
    SpinDuration = 8000, -- 8 seconds
    SpinCooldown = 3000, -- 3 seconds cooldown between spins

    -- Case definitions - item names map to case types
    Cases = {
        fleeca_case = {
            name = 'Fleeca Bank Case',
            title = 'FLEECA CASE',
            titleColor = '#10B981',
            items = {
                {
                    id = 1,
                    name = 'Marked Bills',
                    weight = 60,
                    amount = 5,
                    reward = {
                        type = 'money',
                        amount = 250,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 2,
                    name = 'Bank Cards',
                    item = 'security_card_01',
                    weight = 40,
                    amount = 3,
                    reward = {
                        type = 'item',
                        item = 'security_card_01',
                        amount = 1
                    }
                },
                {
                    id = 3,
                    name = 'Gold Coins',
                    item = 'goldcoin',
                    weight = 25,
                    amount = 2,
                    reward = {
                        type = 'item',
                        item = 'goldcoin',
                        amount = 5
                    }
                },
                {
                    id = 4,
                    name = 'Safety Deposit Key',
                    item = 'safecracker',
                    weight = 10,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'safecracker',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Diamond',
                    item = 'diamond',
                    weight = 5,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'diamond',
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
                    amount = 3,
                    reward = {
                        type = 'money',
                        amount = 150,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 2,
                    name = 'Jewelry',
                    item = 'gold_ring',
                    weight = 35,
                    amount = 2,
                    reward = {
                        type = 'item',
                        item = 'gold_ring',
                        amount = 3
                    }
                },
                {
                    id = 3,
                    name = 'Electronics',
                    item = 'laptop',
                    weight = 30,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'laptop',
                        amount = 1
                    }
                },
                {
                    id = 4,
                    name = 'Rolex Watch',
                    item = 'rolex',
                    weight = 15,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'rolex',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Art Painting',
                    item = 'paintingg',
                    weight = 8,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'paintingg',
                        amount = 1
                    }
                },
                {
                    id = 6,
                    name = 'Safe Contents',
                    weight = 3,
                    amount = 1,
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
                    amount = 10,
                    reward = {
                        type = 'item',
                        item = 'metalscrap',
                        amount = 15
                    }
                },
                {
                    id = 2,
                    name = 'Car Battery',
                    item = 'car_battery',
                    weight = 40,
                    amount = 2,
                    reward = {
                        type = 'item',
                        item = 'car_battery',
                        amount = 1
                    }
                },
                {
                    id = 3,
                    name = 'Turbo Kit',
                    item = 'turbo',
                    weight = 20,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'turbo',
                        amount = 1
                    }
                },
                {
                    id = 4,
                    name = 'NOS Bottle',
                    item = 'nos',
                    weight = 15,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'nos',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Racing ECU',
                    item = 'racing_ecu',
                    weight = 5,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'racing_ecu',
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
                    amount = 5,
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
                    amount = 2,
                    reward = {
                        type = 'item',
                        item = 'diamond_ring',
                        amount = 1
                    }
                },
                {
                    id = 3,
                    name = 'Rare Diamond',
                    item = 'diamond',
                    weight = 15,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'diamond',
                        amount = 2
                    }
                },
                {
                    id = 4,
                    name = 'Luxury Watch',
                    item = 'rolex',
                    weight = 20,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'rolex',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Pink Diamond',
                    item = 'pink_diamond',
                    weight = 3,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'pink_diamond',
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
                    amount = 3,
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
                    amount = 1,
                    reward = {
                        type = 'money',
                        amount = 2000,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 3,
                    name = 'Bearer Bonds',
                    item = 'bearer_bonds',
                    weight = 20,
                    amount = 5,
                    reward = {
                        type = 'item',
                        item = 'bearer_bonds',
                        amount = 3
                    }
                },
                {
                    id = 4,
                    name = 'Crypto USB',
                    item = 'cryptostick',
                    weight = 10,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'cryptostick',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Panther Statue',
                    item = 'panther',
                    weight = 2,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'panther',
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
                    name = 'Casino Chips',
                    item = 'casino_chips',
                    weight = 60,
                    amount = 100,
                    reward = {
                        type = 'item',
                        item = 'casino_chips',
                        amount = 50
                    }
                },
                {
                    id = 2,
                    name = 'Cash Trolley',
                    weight = 30,
                    amount = 1,
                    reward = {
                        type = 'money',
                        amount = 1500,
                        moneyType = 'cash'
                    }
                },
                {
                    id = 3,
                    name = 'Artwork',
                    item = 'paintingg',
                    weight = 25,
                    amount = 2,
                    reward = {
                        type = 'item',
                        item = 'paintingg',
                        amount = 1
                    }
                },
                {
                    id = 4,
                    name = 'Diamond Necklace',
                    item = 'diamond_necklace',
                    weight = 10,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'diamond_necklace',
                        amount = 1
                    }
                },
                {
                    id = 5,
                    name = 'Pink Diamond',
                    item = 'pink_diamond',
                    weight = 1,
                    amount = 1,
                    reward = {
                        type = 'item',
                        item = 'pink_diamond',
                        amount = 1
                    }
                }
            }
        }
    }
}