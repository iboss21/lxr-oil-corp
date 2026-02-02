--[[
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                    
    🐺 LXR Oil Corporation System - Configuration
    
    This configuration file controls all aspects of the oil business system.
    Players can establish oil wells, produce crude oil barrels, manage businesses,
    hire workers, complete missions, and build an oil empire.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 1.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, OilBusiness, Economy, RPG, Production
    
    Framework Support:
    - LXRCore (Primary)
    - RSG Core (Primary)
    - VORP Core
    - RedEM:RP
    - QBR Core
    - QR Core
    - Standalone
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Inspired by: Historical oil industry operations and modern business simulation
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-oil-corp"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        
        Expected: %s
        Got: %s
        
        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    
    -- Contact & Links
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    
    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',
    
    -- Tags
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'OilBusiness', 'Economy', 'Production', 'RPG'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Framework = 'auto' -- Options: 'auto', 'lxrcore', 'rsg-core', 'qbr-core', 'qr-core', 'vorp', 'redemrp', 'standalone'

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
    ['rsg-core'] = {
        enabled = true,
        resource = 'rsg-core',
        exportName = 'rsg-core',
        getSharedObject = 'rsg-core:getSharedObject',
        playerLoaded = 'RSGCore:Client:OnPlayerLoaded',
        playerUnloaded = 'RSGCore:Client:OnPlayerUnload',
        notification = 'rsg',
    },
    ['qbr-core'] = {
        enabled = true,
        resource = 'qbr-core',
        exportName = 'qbr-core',
        getSharedObject = 'qbr-core:getSharedObject',
        playerLoaded = 'QBCore:Client:OnPlayerLoaded',
        playerUnloaded = 'QBCore:Client:OnPlayerUnload',
        notification = 'qb',
    },
    vorp = {
        enabled = true,
        resource = 'vorp_core',
        exportName = 'vorp_core',
        getSharedObject = 'vorp:getSharedObject',
        playerLoaded = 'vorp:SelectedCharacter',
        playerUnloaded = 'vorp:PlayerLogout',
        notification = 'vorp',
    },
    redemrp = {
        enabled = true,
        resource = 'redem_roleplay',
        exportName = 'redem_roleplay',
        getSharedObject = 'redem:getSharedObject',
        playerLoaded = 'RedEM:PlayerLoaded',
        playerUnloaded = 'RedEM:PlayerUnload',
        notification = 'redemrp',
    },
    standalone = {
        enabled = true,
        resource = nil,
        exportName = nil,
        notification = 'native',
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'English' -- Options: 'English', 'Georgian', 'Spanish', 'French', 'German'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL OIL CORP SETTINGS █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.EnableDebug = false -- Enable debug messages in console/chat
Config.EnableBlips = true -- Show oil wells on the map
Config.EnablePrompts = true -- Show prompts when near oil wells

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ OIL WELL SETTINGS █████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.OilWells = {
    -- Maximum oil wells per player
    MaxOilWellsPerPlayer = 3,
    
    -- Oil well placement settings
    PlacementItem = 'oilwell', -- Item required to place oil well
    PlacementTime = 10000, -- 10 seconds (milliseconds)
    PlacementAnimation = {
        dict = 'amb_work@world_human_crouch_inspect@male_a@base',
        anim = 'base',
        flag = 1
    },
    
    -- Oil well props
    OilWellProp = 'p_oilderrick01x', -- Main oil well prop
    OilWellScale = 1.0,
    
    -- Interaction distance
    InteractionDistance = 2.0,
    
    -- Quality degradation
    QualityDegradationRate = 1, -- Percentage lost per cron job cycle
    MinQualityForProduction = 1, -- Minimum quality to produce barrels
    
    -- Coal settings
    MaxCoal = 100, -- Maximum coal storage
    CoalPerAddition = 5, -- Coal added per interaction
    CoalItem = 'coal', -- Coal item name
    CoalRequiredForProduction = 1, -- Coal consumed per production cycle
    
    -- Repair settings
    RepairCost = 1.0, -- Cost per 1% damage (multiplier)
    RepairTime = 5000, -- 5 seconds (milliseconds)
    RepairAnimation = {
        dict = 'amb_work@world_human_hammer@male_a@base',
        anim = 'base',
        flag = 1
    },
    RepairItems = {
        {item = 'ironbar', amount = 1},
        {item = 'wood', amount = 5}
    },
    
    -- Blip settings
    Blip = {
        sprite = 'blip_proc_oil',
        color = 'BLIP_MODIFIER_MP_COLOR_32',
        scale = 0.2,
        text = 'Oil Well'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ BARREL PRODUCTION SETTINGS ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Barrels = {
    -- Production settings
    MaxBarrelsPerWell = 10, -- Maximum barrels per oil well
    ProductionChance = 0.5, -- 50% chance to produce barrel per cron cycle
    
    -- Barrel prop
    BarrelProp = 'p_barrel02ax', -- Crude oil barrel prop
    BarrelScale = 1.0,
    
    -- Barrel spawn offsets around oil well
    SpawnOffsets = {
        vector3(2.0, 0.0, 0.0),
        vector3(-2.0, 0.0, 0.0),
        vector3(0.0, 2.0, 0.0),
        vector3(0.0, -2.0, 0.0),
        vector3(1.5, 1.5, 0.0),
        vector3(-1.5, 1.5, 0.0),
        vector3(1.5, -1.5, 0.0),
        vector3(-1.5, -1.5, 0.0),
        vector3(2.5, 0.0, 0.0),
        vector3(-2.5, 0.0, 0.0)
    },
    
    -- Barrel pickup/drop settings
    PickupDistance = 3.0,
    PickupAnimation = {
        dict = 'amb_work@world_human_box_pickup@male_a@base',
        anim = 'base',
        flag = 50
    },
    DropAnimation = {
        dict = 'amb_work@world_human_box_pickup@male_a@exit',
        anim = 'exit',
        flag = 1
    },
    
    -- Barrel selling
    SellPrice = 50, -- Price per barrel
    MaxSellPerTransaction = 3, -- Maximum barrels to sell at once
    
    -- Barrel carrying
    CarryProp = 'p_barrel02ax',
    CarryBone = 'SKEL_Spine2',
    CarryOffset = vector3(0.0, 0.35, 0.0),
    CarryRotation = vector3(0.0, 0.0, 0.0)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CRON JOB SETTINGS █████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.CronJob = {
    Enabled = true,
    Interval = 600000, -- 10 minutes (milliseconds)
    
    -- What happens during each cron cycle:
    -- 1. Degrade oil well quality by Config.OilWells.QualityDegradationRate
    -- 2. Consume coal if quality > 0 and coal > 0
    -- 3. Attempt to produce barrels based on Config.Barrels.ProductionChance
    -- 4. Remove oil wells with quality <= 0
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ BUSINESS MANAGEMENT SETTINGS ██████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Business = {
    Enabled = true,
    
    -- Business types
    Types = {
        personal = {
            name = 'Personal Operation',
            maxOilWells = 3,
            maxWorkers = 0,
            upgradeCost = 0,
            benefits = {
                productionBonus = 0, -- No bonus
                qualityBonus = 0,
                sellPriceBonus = 0
            }
        },
        smallBusiness = {
            name = 'Small Business',
            maxOilWells = 5,
            maxWorkers = 2,
            upgradeCost = 5000,
            benefits = {
                productionBonus = 0.10, -- 10% more production chance
                qualityBonus = 0, -- No quality bonus
                sellPriceBonus = 0.05 -- 5% better sell price
            }
        },
        company = {
            name = 'Oil Company',
            maxOilWells = 10,
            maxWorkers = 5,
            upgradeCost = 15000,
            benefits = {
                productionBonus = 0.25, -- 25% more production chance
                qualityBonus = 0.10, -- 10% slower degradation
                sellPriceBonus = 0.15 -- 15% better sell price
            }
        },
        corporation = {
            name = 'Oil Corporation',
            maxOilWells = 20,
            maxWorkers = 10,
            upgradeCost = 50000,
            benefits = {
                productionBonus = 0.50, -- 50% more production chance
                qualityBonus = 0.25, -- 25% slower degradation
                sellPriceBonus = 0.30 -- 30% better sell price
            }
        }
    },
    
    -- Business purchase/rent locations
    BusinessOffices = {
        {
            name = 'Valentine Oil Office',
            coords = vector3(-181.91, 627.84, 114.09),
            heading = 90.0,
            blip = {
                sprite = 'blip_shop_store',
                color = 'BLIP_MODIFIER_MP_COLOR_32',
                scale = 0.2
            }
        },
        {
            name = 'Blackwater Oil Office',
            coords = vector3(-813.12, -1324.71, 43.63),
            heading = 180.0,
            blip = {
                sprite = 'blip_shop_store',
                color = 'BLIP_MODIFIER_MP_COLOR_32',
                scale = 0.2
            }
        },
        {
            name = 'Saint Denis Oil Office',
            coords = vector3(2717.59, -1455.29, 46.37),
            heading = 270.0,
            blip = {
                sprite = 'blip_shop_store',
                color = 'BLIP_MODIFIER_MP_COLOR_32',
                scale = 0.2
            }
        }
    },
    
    -- Rent system
    RentSystem = {
        Enabled = true,
        RentCost = 100, -- Per payment period
        RentPeriod = 86400000, -- 24 hours (milliseconds)
        GracePeriod = 172800000, -- 48 hours before eviction
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WORKER MANAGEMENT SETTINGS ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Workers = {
    Enabled = true,
    
    -- Worker hire costs
    HireCost = 500,
    FireCost = 0, -- No cost to fire workers
    
    -- Worker salary (paid automatically per payment period)
    SalaryAmount = 50,
    SalaryPeriod = 86400000, -- 24 hours (milliseconds)
    
    -- Worker benefits
    Benefits = {
        -- Each worker adds these bonuses
        productionBonus = 0.05, -- 5% per worker
        qualityBonus = 0.02, -- 2% per worker (slower degradation)
        
        -- Workers can automatically add coal
        autoCoalEnabled = true,
        autoCoalThreshold = 20, -- Add coal when below this amount
        autoCoalAmount = 10 -- Amount to add
    },
    
    -- Worker types
    Types = {
        {
            name = 'Laborer',
            salary = 50,
            productionBonus = 0.05,
            qualityBonus = 0.02
        },
        {
            name = 'Experienced Worker',
            salary = 100,
            productionBonus = 0.10,
            qualityBonus = 0.05
        },
        {
            name = 'Expert Engineer',
            salary = 200,
            productionBonus = 0.20,
            qualityBonus = 0.10
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ MISSION & QUEST SETTINGS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Missions = {
    Enabled = true,
    
    -- Mission givers (NPCs)
    MissionGivers = {
        {
            name = 'Oil Baron Thompson',
            ped = 'CS_WarVeteran',
            coords = vector3(-181.91, 627.84, 114.09),
            heading = 180.0,
            blip = {
                sprite = 'blip_ambient_ped',
                color = 'BLIP_MODIFIER_MP_COLOR_32',
                scale = 0.2
            }
        }
    },
    
    -- Mission types
    Types = {
        delivery = {
            name = 'Barrel Delivery',
            description = 'Deliver crude oil barrels to a location',
            reward = {min = 100, max = 300},
            xp = 50,
            requiredWagon = true, -- Requires wagon for transport
            minBarrels = 3,
            maxBarrels = 10,
            timeLimit = 1800000, -- 30 minutes
            destinations = {
                {name = 'Valentine Train Station', coords = vector3(-180.37, 621.76, 114.03)},
                {name = 'Blackwater Docks', coords = vector3(-847.89, -1321.56, 43.54)},
                {name = 'Saint Denis Docks', coords = vector3(2810.52, -1331.84, 42.50)}
            }
        },
        exploration = {
            name = 'Survey Land',
            description = 'Survey potential oil drilling sites',
            reward = {min = 75, max = 150},
            xp = 30,
            requiredWagon = false,
            timeLimit = 1200000 -- 20 minutes
        },
        maintenance = {
            name = 'Emergency Repair',
            description = 'Repair damaged oil wells in the area',
            reward = {min = 50, max = 100},
            xp = 25,
            requiredWagon = false,
            timeLimit = 900000 -- 15 minutes
        },
        protection = {
            name = 'Defend Oil Well',
            description = 'Protect oil wells from bandits',
            reward = {min = 200, max = 500},
            xp = 100,
            requiredWagon = false,
            timeLimit = 1800000 -- 30 minutes
        }
    },
    
    -- Cooldowns
    Cooldowns = {
        GlobalCooldown = 900000, -- 15 minutes between missions
        TypeCooldown = 1800000 -- 30 minutes between same mission type
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WAGON REQUIREMENTS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Wagons = {
    -- Required wagon for barrel transport
    RequiredForLargeDeliveries = true, -- Require wagon for 5+ barrels
    
    -- Allowed wagon models
    AllowedWagons = {
        'chuckwagon000x',
        'chuckwagon002x',
        'logwagon',
        'wagon02x',
        'wagon03x',
        'wagon04x',
        'wagon05x',
        'wagon06x'
    },
    
    -- Wagon capacity
    BarrelCapacity = {
        default = 10, -- Default capacity
        chuckwagon000x = 8,
        chuckwagon002x = 8,
        logwagon = 12,
        wagon02x = 6,
        wagon03x = 10,
        wagon04x = 8,
        wagon05x = 12,
        wagon06x = 15
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ INCOME TRACKING SETTINGS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.IncomeTracking = {
    Enabled = true,
    
    -- Track these income sources
    TrackSales = true, -- Track barrel sales
    TrackMissions = true, -- Track mission rewards
    TrackExpenses = true, -- Track repairs, worker salaries, rent
    
    -- Statistics available to view
    ShowDailyIncome = true,
    ShowWeeklyIncome = true,
    ShowMonthlyIncome = true,
    ShowAllTimeIncome = true,
    
    -- Reset periods
    DailyReset = '00:00', -- Reset at midnight
    WeeklyReset = 'Monday', -- Reset on Monday
    MonthlyReset = 1 -- Reset on 1st of month
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ BARREL SELLING LOCATIONS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.SellingLocations = {
    {
        name = 'Valentine Oil Buyer',
        coords = vector3(-180.37, 621.76, 114.03),
        heading = 180.0,
        ped = 'U_M_M_BHT_MINER',
        blip = {
            sprite = 'blip_shop_coal',
            color = 'BLIP_MODIFIER_MP_COLOR_32',
            scale = 0.2
        }
    },
    {
        name = 'Blackwater Oil Buyer',
        coords = vector3(-847.89, -1321.56, 43.54),
        heading = 90.0,
        ped = 'U_M_M_BHT_MINER',
        blip = {
            sprite = 'blip_shop_coal',
            color = 'BLIP_MODIFIER_MP_COLOR_32',
            scale = 0.2
        }
    },
    {
        name = 'Saint Denis Oil Refinery',
        coords = vector3(2810.52, -1331.84, 42.50),
        heading = 270.0,
        ped = 'U_M_M_BHT_MINER',
        blip = {
            sprite = 'blip_shop_coal',
            color = 'BLIP_MODIFIER_MP_COLOR_32',
            scale = 0.2
        }
    },
    {
        name = 'Annesburg Oil Depot',
        coords = vector3(2904.13, 1311.11, 44.94),
        heading = 0.0,
        ped = 'U_M_M_BHT_MINER',
        blip = {
            sprite = 'blip_shop_coal',
            color = 'BLIP_MODIFIER_MP_COLOR_32',
            scale = 0.2
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NOTIFICATION SETTINGS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Notifications = {
    Type = 'ox_lib', -- Options: 'ox_lib', 'rsg', 'vorp', 'native'
    
    -- Notification duration (milliseconds)
    Duration = 5000,
    
    -- Notification positions
    Position = 'top-right' -- ox_lib only
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TARGET SYSTEM SETTINGS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Target = {
    System = 'auto', -- Options: 'auto', 'rsg-target', 'ox_target', 'vorp_target', 'qb-target'
    
    -- Target distance
    Distance = 3.0,
    
    -- Debug zones
    DebugZones = false
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ XP & PROGRESSION SETTINGS █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.XPSystem = {
    Enabled = true,
    
    -- XP rewards
    BarrelProduction = 5, -- XP per barrel produced
    BarrelSold = 10, -- XP per barrel sold
    OilWellPlaced = 50, -- XP for placing oil well
    OilWellRepaired = 25, -- XP for repairing oil well
    MissionCompleted = {
        delivery = 50,
        exploration = 30,
        maintenance = 25,
        protection = 100
    },
    
    -- Level thresholds for unlocking content
    LevelRequired = {
        PlaceOilWell = 0, -- No level requirement
        SmallBusiness = 5, -- Requires level 5
        Company = 10, -- Requires level 10
        Corporation = 20, -- Requires level 20
        HireWorkers = 5, -- Requires level 5
        AcceptMissions = 3 -- Requires level 3
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ANIMATION DICTIONARIES ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Animations = {
    -- Animation dictionaries to preload
    Dictionaries = {
        'amb_work@world_human_crouch_inspect@male_a@base',
        'amb_work@world_human_hammer@male_a@base',
        'amb_work@world_human_box_pickup@male_a@base',
        'amb_work@world_human_box_pickup@male_a@exit'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG & TESTING SETTINGS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = {
    EnableDebugMode = false,
    ShowCoordinates = false,
    ShowZones = false,
    LogDatabase = false,
    LogEvents = false
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

print([[
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                               ║
    ║                     🐺 LXR OIL CORPORATION SYSTEM 🐺                         ║
    ║                                                                               ║
    ║                           Configuration Loaded                                ║
    ║                                                                               ║
    ║                        The Land of Wolves 🐺                                 ║
    ║                      https://www.wolves.land                                  ║
    ║                                                                               ║
    ║                   © 2026 iBoss21 / The Lux Empire                            ║
    ║                                                                               ║
    ╚═══════════════════════════════════════════════════════════════════════════════╝
]])
