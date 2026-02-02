# 🐺 LXR Oil Corporation - System Overview

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📖 Documentation - System Overview

**The Land of Wolves 🐺** | Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!

---

## 🎯 What is LXR Oil Corporation?

LXR Oil Corporation is a comprehensive oil business management system for RedM that allows players to:

- **Establish Oil Wells** - Place and manage oil extraction sites across the map
- **Produce Crude Oil** - Generate barrels of oil using coal-based production
- **Build Business Empire** - Upgrade from personal operations to full corporations
- **Hire Workers** - Employ workers for production bonuses
- **Complete Missions** - Take on delivery, exploration, maintenance, and protection missions
- **Trade & Sell** - Transport and sell oil barrels at various locations

## 🏗️ System Architecture

### Core Components

```
lxr-oil-corp/
├── config.lua              # Central configuration with all settings
├── fxmanifest.lua         # Resource manifest with dependencies
│
├── shared/                 # Shared between client & server
│   ├── framework.lua      # Multi-framework adapter layer
│   └── locale.lua         # Localization system
│
├── client/                # Client-side scripts
│   ├── main.lua          # Core client logic
│   ├── blips.lua         # Map blip management
│   ├── targets.lua       # Interaction target system
│   ├── barrels.lua       # Barrel pickup/carry system
│   ├── business.lua      # Business menu UI
│   └── missions.lua      # Mission system client
│
├── server/                # Server-side scripts
│   ├── main.lua          # Core server logic
│   ├── database.lua      # Database initialization
│   ├── business.lua      # Business management
│   ├── missions.lua      # Mission generation & validation
│   ├── cron.lua          # Scheduled production tasks
│   └── versioncheck.lua  # Version monitoring
│
└── docs/                  # Documentation
    └── assets/            # Documentation assets
        └── screenshots/   # System screenshots
```

## 🔄 Data Flow

### Oil Well Lifecycle

1. **Placement** - Player uses oil well item → server validates → creates database entry
2. **Production** - Cron job checks wells → consumes coal → generates barrels
3. **Maintenance** - Player adds coal / repairs → server updates quality/coal
4. **Removal** - Player destroys well → server removes from database

### Business Operations

1. **Registration** - Player purchases business tier → unlocks wells/workers
2. **Worker Management** - Hire/fire workers → affects production multiplier
3. **Rent Payment** - Scheduled rent collection → business status updated
4. **Upgrades** - Purchase higher tier → unlock more capacity

### Barrel Trading

1. **Production** - Barrel spawned at well → stored in database
2. **Pickup** - Player picks up barrel → client carries prop
3. **Transport** - Player moves to buyer location
4. **Sale** - Server validates distance → pays player → removes barrel

## 🎮 Gameplay Loop

```
Place Oil Well → Add Coal → Automatic Production → Pickup Barrels → 
Transport to Buyer → Sell for Profit → Upgrade Business → Expand Empire
```

## 🛡️ Security Model

### Server Authority
- All economy actions validated server-side
- Distance checks for interactions
- Cooldown tracking per player
- Ownership verification
- Anti-duplication measures

### Rate Limiting
- Production cycles are server-controlled
- Transaction cooldowns prevent spam
- Worker hire/fire limits
- Mission acceptance limits

## 📊 Economy System

### Revenue Sources
- Barrel sales (base price + business multiplier)
- Mission completion rewards
- XP progression bonuses

### Expenses
- Oil well placement costs (item required)
- Repair materials (iron bars + wood)
- Business rent (tier-dependent)
- Business upgrades (tier progression)
- Worker salaries (optional feature)

## 🔧 Technical Features

### Performance Optimization
- Lazy loading of oil wells (range-based sync)
- Efficient database queries with caching
- Minimal thread usage
- Event-driven architecture

### Framework Integration
- Auto-detection of installed framework
- Unified adapter layer for compatibility
- Framework-specific event handling
- Graceful fallback to standalone mode

### Multi-Framework Support
- **LXR-Core** (Primary)
- **RSG-Core** (Primary)
- **VORP Core** (Supported)
- **RedEM:RP** (Supported)
- **QBR Core** (Supported)
- **QR Core** (Supported)
- **Standalone** (Fallback)

## 🌍 Localization

Supports multiple languages with easy expansion:
- English (default)
- Georgian (ქართული)
- Expandable for more languages

## 📈 Progression System

### XP Rewards
- Barrel production: 5 XP
- Barrel sold: 10 XP
- Oil well placed: 50 XP
- Oil well repaired: 25 XP
- Mission completed: 25-100 XP (tier-dependent)

### Level Gates
- Level 0: Place oil wells
- Level 3: Accept missions
- Level 5: Small business & hire workers
- Level 10: Oil company
- Level 20: Oil corporation

---

## 📚 Related Documentation

- [Installation Guide](installation.md)
- [Configuration Reference](configuration.md)
- [Framework Support](frameworks.md)
- [Events & API](events.md)
- [Security Best Practices](security.md)
- [Performance Tuning](performance.md)
- [Screenshots](screenshots.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land) | [Discord](https://discord.gg/CrKcWdfd3A)
