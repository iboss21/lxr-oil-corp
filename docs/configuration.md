# 🐺 LXR Oil Corporation - Configuration Reference

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📖 Documentation - Configuration Reference

**The Land of Wolves 🐺** | Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!

---

## 📋 Complete Configuration Guide

This document provides a comprehensive reference for all configuration options in `config.lua`.

---

## 🏢 Server Information

```lua
Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer = 'iBoss21 / The Lux Empire',
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'OilBusiness', 'Economy', 'Production', 'RPG'}
}
```

**Purpose**: Server branding information displayed in logs and documentation.

---

## 🔧 Framework Configuration

### Framework Detection

```lua
Config.Framework = 'auto'
```

**Options**:
- `'auto'` - Automatically detect installed framework (recommended)
- `'lxrcore'` - Force LXR-Core
- `'rsg-core'` - Force RSG-Core
- `'qbr-core'` - Force QBR Core
- `'qr-core'` - Force QR Core
- `'vorp'` - Force VORP Core
- `'redemrp'` - Force RedEM:RP
- `'standalone'` - Run without framework

### Framework Settings

Each framework has specific configuration:

```lua
Config.FrameworkSettings = {
    lxrcore = {
        enabled = true,
        resource = 'lxr-core',
        exportName = 'lxr-core',
        getSharedObject = 'lxr-core:getSharedObject',
        playerLoaded = 'LXR:Client:OnPlayerLoaded',
        playerUnloaded = 'LXR:Client:OnPlayerUnload',
        notification = 'lxr',
    },
    -- ... other frameworks
}
```

---

## 🌍 Language Configuration

```lua
Config.Lang = 'English'
```

**Options**:
- `'English'` - English language
- `'Georgian'` - Georgian (ქართული)
- `'Spanish'` - Spanish (coming soon)
- `'French'` - French (coming soon)
- `'German'` - German (coming soon)

---

## 🛢️ Oil Well Configuration

### General Settings

```lua
Config.OilWells = {
    MaxOilWellsPerPlayer = 3,  -- Base limit without business
    PlacementItem = 'oilwell',  -- Item required to place well
    PlacementTime = 10000,      -- Time in milliseconds (10 seconds)
    OilWellProp = 'p_oilderrick01x',  -- Prop model
    OilWellScale = 1.0,         -- Prop scale
    InteractionDistance = 2.0,  -- Distance to interact
}
```

### Quality System

```lua
QualityDegradationRate = 1,  -- % lost per cron cycle
MinQualityForProduction = 1,  -- Minimum quality to produce
```

**How it works**:
- Oil wells start at 100% quality
- Degrades by 1% per production cycle
- Must repair when quality drops too low
- Affects production efficiency

### Coal System

```lua
MaxCoal = 100,               -- Maximum coal storage
CoalPerAddition = 5,         -- Coal added per interaction
CoalItem = 'coal',           -- Item name
CoalRequiredForProduction = 1, -- Coal per production cycle
```

### Repair System

```lua
RepairCost = 1.0,  -- Cost per 1% damage multiplier
RepairTime = 5000,  -- 5 seconds
RepairItems = {
    {item = 'ironbar', amount = 1},
    {item = 'wood', amount = 5}
},
```

### Blip Settings

```lua
Blip = {
    sprite = 'blip_proc_oil',
    color = 'BLIP_MODIFIER_MP_COLOR_32',
    scale = 0.2,
    text = 'Oil Well'
}
```

---

## 🛢️ Barrel Configuration

```lua
Config.Barrels = {
    MaxBarrelsPerWell = 10,     -- Maximum barrels per well
    ProductionChance = 0.5,      -- 50% chance per cycle
    ProductionInterval = 300,    -- 5 minutes (seconds)
    BarrelProp = 'p_barrel01x',  -- Barrel prop model
    BarrelScale = 1.0,           -- Prop scale
    PickupTime = 3000,           -- 3 seconds
    DropTime = 2000,             -- 2 seconds
    CarryAnimation = {
        dict = 'amb_work@world_human_box_pickup@male_a@base',
        anim = 'base',
        flag = 49
    }
}
```

**Production Mechanics**:
- Barrels spawn automatically via cron job
- Requires coal in oil well
- Quality affects production chance
- Workers increase production multiplier

---

## 💰 Economy Configuration

### Barrel Pricing

```lua
Config.BarrelSelling = {
    BasePrice = 50.0,  -- Base price per barrel
    PriceRange = {
        min = 45.0,     -- Minimum sell price
        max = 55.0      -- Maximum sell price
    },
    BusinessMultiplier = {
        personal = 1.0,      -- No bonus
        small = 1.1,         -- +10%
        company = 1.25,      -- +25%
        corporation = 1.5    -- +50%
    }
}
```

### Buyer Locations

```lua
Config.Buyers = {
    {
        name = 'Valentine Oil Depot',
        coords = vector3(123.45, -678.90, 42.10),
        blip = {
            sprite = 'blip_shop_store',
            color = 'BLIP_MODIFIER_MP_COLOR_8',
            scale = 0.2
        }
    },
    -- Add more buyers...
}
```

---

## 🏢 Business Configuration

### Business Tiers

```lua
Config.Business = {
    Tiers = {
        personal = {
            name = 'Personal Operation',
            cost = 0,
            maxOilWells = 3,
            maxWorkers = 0,
            priceMultiplier = 1.0,
            rentAmount = 0,
            rentInterval = 0
        },
        small = {
            name = 'Small Oil Business',
            cost = 5000,
            maxOilWells = 5,
            maxWorkers = 2,
            priceMultiplier = 1.1,
            rentAmount = 100,
            rentInterval = 604800  -- 7 days in seconds
        },
        company = {
            name = 'Oil Company',
            cost = 15000,
            maxOilWells = 10,
            maxWorkers = 5,
            priceMultiplier = 1.25,
            rentAmount = 500,
            rentInterval = 604800
        },
        corporation = {
            name = 'Oil Corporation',
            cost = 50000,
            maxOilWells = 20,
            maxWorkers = 10,
            priceMultiplier = 1.5,
            rentAmount = 1000,
            rentInterval = 604800
        }
    }
}
```

**Tier Benefits**:
- More oil wells allowed
- More workers for production bonus
- Higher sell prices for barrels
- Unlocks advanced features

### Worker System

```lua
Config.Workers = {
    Enabled = true,
    HireCost = 500,              -- Cost to hire worker
    FirePenalty = 250,           -- Cost to fire worker
    SalaryAmount = 100,          -- Salary per interval
    SalaryInterval = 86400,      -- 24 hours
    ProductionBonus = 0.1,       -- +10% per worker
    MaxProductionBonus = 0.5     -- Max 50% bonus
}
```

---

## 🎯 Mission Configuration

```lua
Config.Missions = {
    Enabled = true,
    MaxActiveMissions = 3,
    CooldownBetweenMissions = 300,  -- 5 minutes
    
    Types = {
        delivery = {
            reward = {min = 100, max = 200},
            xp = 50,
            timeLimit = 600  -- 10 minutes
        },
        exploration = {
            reward = {min = 50, max = 100},
            xp = 30,
            timeLimit = 900
        },
        maintenance = {
            reward = {min = 75, max = 150},
            xp = 25,
            timeLimit = 300
        },
        protection = {
            reward = {min = 200, max = 400},
            xp = 100,
            timeLimit = 1200
        }
    }
}
```

---

## 🔔 Notification System

```lua
Config.Notifications = {
    Type = 'ox_lib',      -- 'ox_lib', 'rsg', 'vorp', 'native'
    Duration = 5000,      -- 5 seconds
    Position = 'top-right'  -- ox_lib only
}
```

---

## 🎯 Target System

```lua
Config.Target = {
    System = 'auto',  -- 'auto', 'rsg-target', 'ox_target', 'vorp_target'
    Distance = 3.0,
    DebugZones = false
}
```

---

## 📊 XP System

```lua
Config.XPSystem = {
    Enabled = true,
    
    -- XP rewards
    BarrelProduction = 5,
    BarrelSold = 10,
    OilWellPlaced = 50,
    OilWellRepaired = 25,
    MissionCompleted = {
        delivery = 50,
        exploration = 30,
        maintenance = 25,
        protection = 100
    },
    
    -- Level requirements
    LevelRequired = {
        PlaceOilWell = 0,
        SmallBusiness = 5,
        Company = 10,
        Corporation = 20,
        HireWorkers = 5,
        AcceptMissions = 3
    }
}
```

---

## 🛡️ Security Configuration

```lua
Config.Security = {
    EnableDistanceCheck = true,
    MaxInteractionDistance = 5.0,
    EnableCooldowns = true,
    AntiSpam = {
        actionCooldown = 1000,  -- 1 second between actions
        maxActionsPerMinute = 30
    },
    ValidateOwnership = true,
    LogSuspiciousActivity = true
}
```

---

## ⚡ Performance Configuration

```lua
Config.Performance = {
    CachePlayerData = true,
    CacheDuration = 300,         -- 5 minutes
    UpdateInterval = 1000,       -- 1 second
    MaxSyncDistance = 100.0,     -- Sync range for oil wells
    OptimizeBlips = true,
    LazyLoadWells = true
}
```

---

## 🐛 Debug Configuration

```lua
Config.Debug = {
    EnableDebugMode = false,
    ShowCoordinates = false,
    ShowZones = false,
    LogDatabase = false,
    LogEvents = false
}
```

**Debug Options**:
- `EnableDebugMode` - Print all debug messages
- `ShowCoordinates` - Display coords on screen
- `ShowZones` - Draw interaction zones
- `LogDatabase` - Log all DB queries
- `LogEvents` - Log all triggered events

---

## 💡 Configuration Tips

### Performance Tuning
1. Reduce `MaxSyncDistance` on crowded servers
2. Increase `UpdateInterval` to reduce load
3. Enable `LazyLoadWells` for better performance
4. Disable blips if not needed

### Economy Balancing
1. Adjust `BasePrice` based on server economy
2. Modify tier costs to match server wealth
3. Balance worker bonuses with production time
4. Set appropriate mission rewards

### Difficulty Settings
1. Lower `ProductionChance` for harder gameplay
2. Increase `QualityDegradationRate` for more maintenance
3. Adjust repair costs for resource scarcity
4. Modify business rent for economic pressure

---

## 📚 Related Documentation

- [Installation Guide](installation.md)
- [Framework Support](frameworks.md)
- [Events & API](events.md)
- [Security Best Practices](security.md)
- [Performance Tuning](performance.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
