# 🐺 LXR Oil Corporation

[![Land of Wolves](https://img.shields.io/badge/Land%20of%20Wolves-🐺-blue)](https://www.wolves.land)
[![Discord](https://img.shields.io/badge/Discord-Join-7289da)](https://discord.gg/CrKcWdfd3A)
[![GitHub](https://img.shields.io/badge/GitHub-iBoss21-181717)](https://github.com/iBoss21)

> **Complete Oil Business System for RedM**
> 
> Build your oil empire! Place oil wells, produce crude oil barrels, manage workers, complete missions, and dominate the oil industry in the Wild West.

---

## 📖 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Framework Support](#-framework-support)
- [Dependencies](#-dependencies)
- [Credits](#-credits)
- [Support](#-support)

---

## ✨ Features

### 🛢️ Oil Well Management
- **Place Oil Wells**: Use an oil well item to establish production sites
- **Quality System**: Oil wells degrade over time and need maintenance
- **Coal-Based Production**: Add coal to fuel barrel production
- **Repair & Maintenance**: Keep wells operational with repairs
- **Interactive Menus**: Check status, add coal, repair, or destroy wells

### 🎯 Barrel Production & Trading
- **Automatic Production**: Wells produce barrels based on coal and quality
- **Carry System**: Pick up and transport barrels
- **Multiple Selling Locations**: Sell at various buyers across the map
- **Dynamic Pricing**: Business upgrades increase sell prices

### 💼 Business Management
- **Four Business Tiers**:
  - Personal Operation (Free, 3 wells)
  - Small Business ($5,000, 5 wells, 2 workers)
  - Oil Company ($15,000, 10 wells, 5 workers)
  - Oil Corporation ($50,000, 20 wells, 10 workers)
- **Worker System**: Hire workers for production bonuses
- **Rent System**: Pay rent to maintain business operations
- **Upgrades**: Unlock more oil wells and workers

### 🎮 Mission System
- **Four Mission Types**:
  - **Delivery**: Transport barrels to locations (requires wagon)
  - **Exploration**: Survey land for oil sites
  - **Maintenance**: Perform emergency repairs
  - **Protection**: Defend wells from threats
- **Rewards**: Earn money and XP for completing missions
- **Time Limits**: Complete missions before they expire

### 📊 Progression & Economy
- **XP System**: Level up by producing, selling, and completing missions
- **Income Tracking**: View daily, weekly, and monthly earnings
- **Statistics**: Track total barrels sold, missions completed, and income
- **Unlockables**: Level requirements for features

### 🎨 Visual Features
- **Map Blips**: Oil wells, business offices, and selling locations
- **Interactive Targets**: rsg-target, ox_target support
- **Animations**: Realistic placement, repair, and carrying animations
- **Props**: High-quality oil derricks and barrel props

---

## 📦 Installation

1. **Download** the resource and place it in your `resources` folder

2. **Rename** the folder to `lxr-oil-corp` (important!)

3. **Import** the SQL file:
   ```sql
   -- Import lxr_oil_corp.sql into your database
   ```

4. **Add** to your `server.cfg`:
   ```cfg
   ensure lxr-oil-corp
   ```

5. **Configure** the script in `config.lua`

6. **Add Items** to your framework's items file:
   ```lua
   -- Oil Well Item
   ['oilwell'] = {
       label = 'Oil Well Kit',
       weight = 5000,
       stack = true,
       close = true,
       description = 'A complete kit to setup an oil well',
       client = {
           useable = true,
           export = 'lxr-oil-corp.UseOilWell'
       }
   },
   
   -- Coal Item (if not already in your items)
   ['coal'] = {
       label = 'Coal',
       weight = 100,
       stack = true,
       close = true,
       description = 'Fuel for oil production'
   }
   ```

7. **Restart** your server

---

## ⚙️ Configuration

The script is highly configurable through `config.lua`:

### General Settings
```lua
Config.EnableDebug = false
Config.EnableBlips = true
Config.Framework = 'auto' -- Auto-detect or specify
Config.Lang = 'English'
```

### Oil Well Settings
```lua
Config.OilWells = {
    MaxOilWellsPerPlayer = 3,
    PlacementItem = 'oilwell',
    PlacementTime = 10000,
    QualityDegradationRate = 1,
    MaxCoal = 100,
    -- ... more options
}
```

### Business Settings
```lua
Config.Business = {
    Enabled = true,
    Types = {
        personal = { ... },
        smallBusiness = { ... },
        company = { ... },
        corporation = { ... }
    }
}
```

### Production Settings
```lua
Config.CronJob = {
    Enabled = true,
    Interval = 600000, -- 10 minutes
}

Config.Barrels = {
    MaxBarrelsPerWell = 10,
    ProductionChance = 0.5,
    SellPrice = 50,
    -- ... more options
}
```

---

## 🎯 Usage

### For Players

#### Placing an Oil Well
1. Obtain an `oilwell` item
2. Go to desired location
3. Use the item to place the well
4. Wait for the placement animation

#### Managing Oil Wells
1. Approach your oil well
2. Interact using rsg-target/ox_target
3. Options:
   - Check Status
   - Add Coal (requires 5 coal)
   - Repair (requires iron bar, wood, and cash)
   - Destroy (removes well, returns item)

#### Collecting & Selling Barrels
1. Approach a barrel near your well
2. Interact to pick it up
3. Travel to a selling location (marked on map)
4. Sell barrels for cash

#### Upgrading Your Business
1. Visit a business office (marked on map)
2. Open business menu
3. Choose upgrade tier
4. Pay upgrade cost

#### Hiring Workers
1. Open business menu
2. Select "Manage Workers"
3. Choose "Hire Worker"
4. Select worker type
5. Pay hiring cost

#### Accepting Missions
1. Find a mission giver (marked on map)
2. Browse available missions
3. Accept a mission
4. Complete objectives within time limit
5. Collect rewards

---

## 🔧 Framework Support

### Supported Frameworks
- ✅ **LXRCore** (Primary)
- ✅ **RSG-Core** (Primary)
- ✅ **QBR-Core**
- ✅ **QR-Core**
- ✅ **VORP Core**
- ✅ **RedEM:RP**
- ✅ **Standalone**

### Target Systems
- ✅ **rsg-target** (Recommended)
- ✅ **ox_target**
- ✅ **qb-target**

### Notification Systems
- ✅ **ox_lib** (Recommended)
- ✅ **RSG Core**
- ✅ **VORP**
- ✅ **Native**

---

## 📋 Dependencies

### Required
- [oxmysql](https://github.com/overextended/oxmysql) - Database queries
- [ox_lib](https://github.com/overextended/ox_lib) - UI and utilities

### Optional (Auto-detected)
- Your chosen framework (RSG-Core, VORP, etc.)
- Your chosen target system (rsg-target, ox_target, etc.)

---

## 🎨 Credits

**Script Author**: iBoss21 / The Lux Empire

**Developed For**: The Land of Wolves 🐺

**Inspired By**: Historical oil industry operations and modern business simulation systems

---

## 🐺 Server Information

**Server**: The Land of Wolves 🐺  
**Tagline**: Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!  
**Description**: ისტორია ცოცხლდება აქ! (History Lives Here!)  
**Type**: Serious Hardcore Roleplay  
**Access**: Discord & Whitelisted

### Links
- 🌐 **Website**: [wolves.land](https://www.wolves.land)
- 💬 **Discord**: [Join Server](https://discord.gg/CrKcWdfd3A)
- 🛒 **Store**: [Tebex Shop](https://theluxempire.tebex.io)
- 📋 **Server Listing**: [RedM Servers](https://servers.redm.net/servers/detail/8gj7eb)
- 💻 **GitHub**: [iBoss21](https://github.com/iBoss21)

---

## 💬 Support

### Getting Help
1. **Read this README** thoroughly
2. **Check Configuration** - Most issues are configuration-related
3. **Join our Discord** for support
4. **Check GitHub Issues** for known problems

### Reporting Bugs
When reporting bugs, please include:
- Server artifact version
- Framework and version
- Complete error message
- Steps to reproduce
- Your configuration (sensitive info removed)

### Feature Requests
We welcome feature requests! Please:
- Be specific about the feature
- Explain the use case
- Provide examples if possible

---

## 📜 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

This resource is branded for The Land of Wolves and includes resource name protection.

---

## 🎯 Version History

### Version 1.0.0 (Current)
- Initial release
- Complete oil well system
- Business management
- Worker system
- Mission system
- Income tracking
- Multi-framework support
- Comprehensive configuration options

---

## 🔮 Future Updates

Planned features for future versions:
- Oil refinery system
- Trading between players
- Company shares/partnerships
- Advanced worker AI
- More mission types
- Seasonal events
- Mobile oil camps
- Oil wagon transport

---

## 🙏 Acknowledgments

Special thanks to:
- The Land of Wolves community
- RSG-Core team
- RedM development community
- All contributors and testers

---

**Made with ❤️ by iBoss21 for The Land of Wolves 🐺**

[![wolves.land](https://img.shields.io/badge/wolves.land-Visit-success)](https://www.wolves.land)
