# sd-cases

`sd-cases` adds an engaging loot box/case opening system to your FiveM server. Players can obtain various types of cases from different activities (heists, robberies, etc.) and open them through an exciting spinning wheel interface to receive randomized rewards based on weighted probabilities.

## Preview
![image1](https://i.ibb.co/S4YGvH6n/Five-M-GTAProcess-Bd-DRsx-GQg-C.png)

## 🔔 Contact

Author: Samuel#0008  
Discord: [Join the Discord](https://discord.gg/FzPehMQaBQ)  
Store: [Click Here](https://fivem.samueldev.shop)


## ✨ Features

- **Interactive Spinning Wheel UI** - Visually appealing case opening animation
- **Multiple Case Types** - 6 pre-configured case types with unique reward pools
- **Weighted Reward System** - Configurable probability weights for different rewards
- **Flexible Reward Types** - Support for both items and money rewards
- **Customizable** - Easy to add new cases or modify existing ones
- **Smooth Animations** - 8-second spin duration with 3-second cooldown

## 💾 Installation

1. Download the latest release from the [GitHub repository](https://github.com/Samuels-Development/sd-cases/releases). (NOT SOURCE)
2. Extract the downloaded file and rename the folder to `sd-cases`.
3. Place the `sd-cases` folder into your server's `resources` directory.
4. Add `ensure sd-cases` to your `server.cfg` to ensure the resource starts with your server.

For ox_inventory users, there are pre-written items for you below you can use if you want to use the default cases I made!

## 🛠️ Building the UI

If you need to modify the UI or build from source, follow these instructions:

### Requirements
- **Node.js** (v16.0.0 or higher) - [Download here](https://nodejs.org/)
- **npm** (comes with Node.js)

### Build Instructions

1. Navigate to the `web` directory:
```bash
cd web
```

2. Install dependencies:
```bash
npm install
```

3. Build the UI for production:
```bash
npm run build
```

4. The built files will be generated in the `web/build` directory

### Development Mode

For development with hot-reload:
```bash
npm start
```
This will start the development server on `http://localhost:3000`

**Note:** The pre-built UI files are already included in releases, so you only need to build if you're modifying the UI code.

## 📖 Dependencies

- **ox_lib**

## 🎮 Usage

Players can use any case item from their inventory to trigger the spinning wheel interface. The wheel will spin for 8 seconds before landing on a reward based on the configured weights.

## ⚙️ Configuration

Edit `config.lua` to customize:
- Spin duration and cooldown times
- Case types and their rewards
- Item weights (probability)
- Reward amounts
- UI colors and titles

### Weight System
Higher weight values = higher chance of receiving that item
- Common items: 40-60 weight
- Uncommon items: 20-40 weight
- Rare items: 5-20 weight
- Ultra rare items: 1-5 weight

## 📦 Ox Inventory Items

Add these to your ox_inventory `items.lua`, if you want to use my default cases:

```lua
["fleeca_case"] = {
    label = "Fleeca Bank Case",
    weight = 2000,
    stack = true,
    close = true,
    description = "A mysterious case from a Fleeca Bank heist. Contains random loot.",
    consume = 0,
    client = {
        image = "case_1.png",
    },
    server = {
        export = 'sd-cases.useFleeca_case',
    }
},

["house_case"] = {
    label = "House Robbery Case",
    weight = 2000,
    stack = true,
    close = true,
    description = "A case filled with items from house burglaries. Contents unknown.",
    consume = 0,
    client = {
        image = "case_2.png",
    },
    server = {
        export = 'sd-cases.useHouse_case',
    }
},

["chopshop_case"] = {
    label = "Chop Shop Case",
    weight = 2500,
    stack = true,
    close = true,
    description = "A case containing random car parts from the chop shop.",
    consume = 0,
    client = {
        image = "case_3.png",
    },
    server = {
        export = 'sd-cases.useChopshop_case',
    }
},

["jewelry_case"] = {
    label = "Jewelry Store Case",
    weight = 1500,
    stack = true,
    close = true,
    description = "A luxury case from Vangelico's. May contain valuable jewelry.",
    consume = 0,
    client = {
        image = "case_4.png",
    },
    server = {
        export = 'sd-cases.useJewelry_case',
    }
},

["pacific_case"] = {
    label = "Pacific Bank Case",
    weight = 3000,
    stack = true,
    close = true,
    description = "A high-security case from the Pacific Standard vault. Extremely valuable.",
    consume = 0,
    client = {
        image = "case_5.png",
    },
    server = {
        export = 'sd-cases.usePacific_case',
    }
},

["casino_case"] = {
    label = "Casino Heist Case",
    weight = 2500,
    stack = true,
    close = true,
    description = "A case stolen from the Diamond Casino vault. Contains premium loot.",
    consume = 0,
    client = {
        image = "case_6.png",
    },
    server = {
        export = 'sd-cases.useCasino_case',
    }
},
```

## 🎨 Images

Place the corresponding case images in your inventory image folder:
- `case_1.png`
- `case_2.png`
- `case_3.png`
- `case_4.png`
- `case_5.png`
- `case_6.png`

## 📝 Adding Custom Cases

To add a new case type:

1. Add the case definition to `config.lua`:
```lua
my_custom_case = {
    name = 'Custom Case',
    title = 'MY CUSTOM CASE',
    titleColor = '#HEX_COLOR',
    items = {
        {
            id = 1,
            name = 'Item Display Name',
            item = 'item_spawn_name', -- Optional for item rewards
            weight = 50, -- Higher = more common
            amount = 1, -- Display amount
            reward = {
                type = 'item', -- or 'money'
                item = 'item_spawn_name', -- For item type
                amount = 1, -- Actual reward amount
                moneyType = 'cash' -- For money type (cash/bank)
            }
        },
        -- Add more items...
    }
}
```

2. Add the corresponding item to ox_inventory
3. Add the case image to your inventory images
