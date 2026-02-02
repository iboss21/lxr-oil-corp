# 🐺 LXR Oil Corporation - Installation Guide

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📖 Documentation - Installation Guide

**The Land of Wolves 🐺** | Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!

---

## 📋 Prerequisites

Before installing LXR Oil Corporation, ensure you have:

### Required Resources
- ✅ **RedM Server** - Latest recommended version
- ✅ **oxmysql** - Database connector ([Download](https://github.com/overextended/oxmysql))
- ✅ **ox_lib** - Utility library ([Download](https://github.com/overextended/ox_lib))

### Framework (Choose One)
- **LXR-Core** (Primary - Recommended)
- **RSG-Core** (Primary - Recommended)
- **VORP Core** (Supported)
- **RedEM:RP** (Supported)
- **QBR Core** (Supported)
- **QR Core** (Supported)
- Or run in **Standalone** mode

### Target System (Optional but Recommended)
- **rsg-target** (for RSG-Core)
- **ox_target** (for LXR-Core)
- **vorp_target** (for VORP)
- Or fallback to built-in prompts

---

## 🚀 Installation Steps

### Step 1: Download the Resource

1. Download the latest release from GitHub
2. Extract the archive
3. **IMPORTANT**: Ensure the folder is named `lxr-oil-corp` (exact name required)

```bash
# Correct folder name
resources/lxr-oil-corp/

# ❌ Wrong - will not work
resources/lxr-oil-corporation/
resources/oil-corp/
resources/lxr-oil-corp-main/
```

### Step 2: Place in Resources Folder

Move the `lxr-oil-corp` folder to your server's resources directory:

```
server-data/
└── resources/
    └── [standalone]/          # or [lxr] or [rsg] folder
        └── lxr-oil-corp/
```

### Step 3: Database Setup

1. Open **HeidiSQL**, **phpMyAdmin**, or your preferred MySQL tool
2. Connect to your server's database
3. Import the SQL file:

```bash
# File location
lxr-oil-corp/lxr_oil_corp.sql
```

This will create the following tables:
- `lxr_oil_wells` - Stores oil well data
- `lxr_oil_barrels` - Stores barrel data
- `lxr_oil_businesses` - Stores player business data
- `lxr_oil_workers` - Stores hired workers
- `lxr_oil_missions` - Stores active missions

### Step 4: Configure Items in Framework

Add the required items to your framework's item configuration:

#### For LXR-Core / RSG-Core / QBR-Core

Edit `shared/items.lua` in your core resource:

```lua
-- Oil well placement item
['oilwell'] = {
    ['name'] = 'oilwell',
    ['label'] = 'Oil Well Kit',
    ['weight'] = 5000,
    ['type'] = 'item',
    ['image'] = 'oilwell.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A complete oil well drilling kit. Use to establish an oil extraction site.'
},

-- Coal for production
['coal'] = {
    ['name'] = 'coal',
    ['label'] = 'Coal',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'coal.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Fuel for oil well production.'
},

-- Crude oil barrel
['crude_oil'] = {
    ['name'] = 'crude_oil',
    ['label'] = 'Crude Oil Barrel',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'crude_oil.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A barrel of crude oil. Sell to buyers for profit.'
},

-- Repair materials
['ironbar'] = {
    ['name'] = 'ironbar',
    ['label'] = 'Iron Bar',
    ['weight'] = 500,
    ['type'] = 'item',
    ['image'] = 'ironbar.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Used for repairing oil wells.'
},

['wood'] = {
    ['name'] = 'wood',
    ['label'] = 'Wood',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'wood.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Basic building material.'
},
```

#### For VORP Core

Add items to `shared/items.lua`:

```lua
Config.Items = {
    ['oilwell'] = { label = 'Oil Well Kit', weight = 5000, limit = 1, can_remove = true },
    ['coal'] = { label = 'Coal', weight = 100, limit = 100, can_remove = true },
    ['crude_oil'] = { label = 'Crude Oil Barrel', weight = 1000, limit = 10, can_remove = true },
    ['ironbar'] = { label = 'Iron Bar', weight = 500, limit = 50, can_remove = true },
    ['wood'] = { label = 'Wood', weight = 100, limit = 100, can_remove = true },
}
```

### Step 5: Add to server.cfg

Add the resource to your `server.cfg`:

```cfg
# Dependencies (if not already ensured)
ensure oxmysql
ensure ox_lib

# Framework (one of these)
ensure lxr-core      # or
ensure rsg-core      # or
ensure vorp_core     # etc.

# Target system (optional)
ensure rsg-target    # or ox_target or vorp_target

# LXR Oil Corporation
ensure lxr-oil-corp
```

**IMPORTANT**: Place `lxr-oil-corp` **AFTER** your framework and dependencies.

### Step 6: Configure the Resource

Edit `config.lua` to customize settings:

```lua
-- Framework detection (usually leave as 'auto')
Config.Framework = 'auto'

-- Language
Config.Lang = 'English'  -- or 'Georgian'

-- Economy settings
Config.Business.Tiers = {
    -- Adjust prices, limits, etc.
}

-- Oil well settings
Config.OilWells.MaxOilWellsPerPlayer = 3

-- And more...
```

See [Configuration Reference](configuration.md) for detailed options.

### Step 7: Restart Server

Restart your RedM server:

```bash
# In server console
restart lxr-oil-corp

# Or full server restart
quit
# Then restart the server
```

---

## ✅ Verification

After installation, verify everything works:

### 1. Console Output

Check for successful startup messages:

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║                     🐺 LXR OIL CORPORATION SYSTEM 🐺                         ║
║                           Configuration Loaded                                ║
║                        The Land of Wolves 🐺                                 ║
╚═══════════════════════════════════════════════════════════════════════════════╝

[LXR Oil Corp] Detected Framework: rsg-core
[LXR Oil Corp] Loaded 0 oil wells
[LXR Oil Corp] Database tables verified
[LXR Oil Corp] System initialized successfully
```

### 2. In-Game Test

1. Join the server
2. Get the `oilwell` item (admin command or shop)
3. Use the item to place an oil well
4. Interact with the well to verify menu opens
5. Add coal and check production

### 3. Database Verification

Check that tables exist:

```sql
SHOW TABLES LIKE 'lxr_oil_%';
```

Should return:
- lxr_oil_wells
- lxr_oil_barrels
- lxr_oil_businesses
- lxr_oil_workers
- lxr_oil_missions

---

## 🔧 Troubleshooting

### Resource Not Starting

**Problem**: Resource shows as "failed" or "stopped"

**Solution**:
1. Verify folder name is exactly `lxr-oil-corp`
2. Check dependencies are started first
3. Review console for error messages
4. Ensure Lua 5.4 is enabled

### Database Errors

**Problem**: SQL errors in console

**Solution**:
1. Verify oxmysql is configured correctly
2. Import `lxr_oil_corp.sql` again
3. Check database connection in your framework config

### Framework Not Detected

**Problem**: System runs in standalone mode unexpectedly

**Solution**:
1. Ensure framework resource is started before lxr-oil-corp
2. Check framework resource name matches Config.FrameworkSettings
3. Manually set `Config.Framework = 'lxrcore'` (or your framework)

### Items Not Working

**Problem**: Cannot use oil well item

**Solution**:
1. Verify items are added to framework items configuration
2. Check item names match exactly (case-sensitive)
3. Ensure useable = true for the oilwell item
4. Restart framework resource after adding items

### Target System Issues

**Problem**: Cannot interact with oil wells

**Solution**:
1. Set `Config.Target.System = 'auto'` to auto-detect
2. Or manually specify your target system
3. Ensure target resource is started
4. Fallback: system will use prompts if target unavailable

---

## 🔄 Updating

To update LXR Oil Corporation:

1. **Backup** your current `config.lua` and database
2. Download the new version
3. Replace all files **except** `config.lua`
4. Compare your old config with the new default config
5. Merge any new settings into your config
6. Run any update SQL scripts if provided
7. Restart the resource

---

## 📚 Next Steps

- Read the [Configuration Guide](configuration.md) to customize settings
- Review [Framework Support](frameworks.md) for framework-specific features
- Check [Events & API](events.md) to integrate with other resources
- Implement [Security Best Practices](security.md)
- Optimize using [Performance Tuning](performance.md)

---

## 💬 Support

Need help? Contact us:

- **Discord**: [discord.gg/CrKcWdfd3A](https://discord.gg/CrKcWdfd3A)
- **Website**: [wolves.land](https://www.wolves.land)
- **GitHub**: [github.com/iBoss21](https://github.com/iBoss21)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
