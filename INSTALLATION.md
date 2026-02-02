# LXR Oil Corporation - Installation Guide

## Prerequisites

Before installing LXR Oil Corporation, ensure you have:

1. ✅ A RedM server (artifact 1436 or higher recommended)
2. ✅ A MySQL/MariaDB database
3. ✅ oxmysql resource installed
4. ✅ ox_lib resource installed
5. ✅ A supported framework (RSG-Core, LXRCore, VORP, etc.) OR standalone mode

## Step-by-Step Installation

### 1. Download and Extract

Download the resource and place it in your server's `resources` folder:

```
resources/
└── lxr-oil-corp/
```

⚠️ **IMPORTANT**: The folder MUST be named `lxr-oil-corp` (Resource name protection is enforced)

### 2. Database Setup

Import the SQL file into your database:

**Option A: Using phpMyAdmin**
1. Open phpMyAdmin
2. Select your database
3. Go to "Import" tab
4. Choose `lxr_oil_corp.sql`
5. Click "Go"

**Option B: Using MySQL command line**
```bash
mysql -u username -p database_name < lxr_oil_corp.sql
```

**Tables Created:**
- `lxr_oil_wells` - Stores oil well data
- `lxr_oil_barrels` - Stores barrel data
- `lxr_oil_businesses` - Stores business data
- `lxr_oil_workers` - Stores worker data
- `lxr_oil_income` - Stores income tracking
- `lxr_oil_missions` - Stores mission data
- `lxr_oil_player_data` - Stores player XP and stats

### 3. Add Items to Framework

#### For RSG-Core / LXRCore

Add to `rsg-core/shared/items.lua` or `lxr-core/shared/items.lua`:

```lua
-- Oil Well Kit
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

-- Coal (if not already present)
['coal'] = {
    label = 'Coal',
    weight = 100,
    stack = true,
    close = true,
    description = 'Fuel for oil production'
},

-- Iron Bar (if not already present)
['ironbar'] = {
    label = 'Iron Bar',
    weight = 500,
    stack = true,
    close = true,
    description = 'A solid iron bar'
},

-- Wood (if not already present)
['wood'] = {
    label = 'Wood',
    weight = 100,
    stack = true,
    close = true,
    description = 'Wooden planks'
}
```

#### For VORP Core

Add to `vorp_inventory/shared/items.lua`:

```lua
['oilwell'] = {
    label = 'Oil Well Kit',
    weight = 5000,
    limit = 5,
    can_remove = true,
    type = 'item_standard',
    usable = true
},

['coal'] = {
    label = 'Coal',
    weight = 100,
    limit = 100,
    can_remove = true,
    type = 'item_standard',
    usable = false
},
```

### 4. Configure the Script

Open `config.lua` and customize:

```lua
-- Framework Selection
Config.Framework = 'auto' -- Will auto-detect, or specify: 'rsg-core', 'vorp', etc.

-- Language
Config.Lang = 'English'

-- Enable/Disable Features
Config.Business.Enabled = true
Config.Missions.Enabled = true
Config.CronJob.Enabled = true

-- Production Settings
Config.CronJob.Interval = 600000 -- 10 minutes in milliseconds

-- Adjust locations if needed
Config.Business.BusinessOffices = {
    -- Add or modify office locations
}

Config.SellingLocations = {
    -- Add or modify selling locations
}
```

### 5. Add to server.cfg

Add this line to your `server.cfg`:

```cfg
ensure lxr-oil-corp
```

Make sure it's loaded AFTER:
```cfg
ensure oxmysql
ensure ox_lib
ensure rsg-core  # or your framework
ensure rsg-target  # or your target system
```

Example order:
```cfg
ensure oxmysql
ensure ox_lib
ensure rsg-core
ensure rsg-target
ensure lxr-oil-corp
```

### 6. Restart Server

Restart your server completely:

```bash
# Stop server
# Start server
```

Or use the console command:
```
refresh
ensure lxr-oil-corp
```

## Verification

After installation, verify everything is working:

1. **Check Console**
   - Look for: `🐺 LXR OIL CORPORATION SYSTEM 🐺`
   - Should show "Server-Side Initialized"
   - Should show "Client initialized"

2. **Check Database Tables**
   - Console will report if tables exist
   - All 7 tables should be present

3. **In-Game Test**
   - Give yourself an oil well item: `/giveitem [id] oilwell 1`
   - Use the item to place a well
   - Check if blips appear on the map

## Troubleshooting

### "Resource name mismatch" Error
- **Solution**: Rename folder to exactly `lxr-oil-corp`

### Tables Not Found
- **Solution**: Import `lxr_oil_corp.sql` into your database

### Item Not Usable
- **Solution**: Check item export is correct in items file
- **Format**: `export = 'lxr-oil-corp.UseOilWell'`

### No Blips Appearing
- **Solution**: Set `Config.EnableBlips = true` in config.lua

### Target Not Working
- **Solution**: Ensure target system is installed and configured
- Check `Config.Target.System` setting

### Framework Not Detected
- **Solution**: Set `Config.Framework` to your specific framework
- Example: `Config.Framework = 'rsg-core'`

### Cron Job Not Running
- **Solution**: Check `Config.CronJob.Enabled = true`
- Check server console for cron messages

## Optional: Give Starter Items

You can give players starter items:

```lua
-- Via command
/giveitem [playerid] oilwell 1
/giveitem [playerid] coal 50

-- Or create a starter pack in your framework
```

## Configuration Tips

### Adjust Production Rate
```lua
Config.CronJob.Interval = 300000 -- 5 minutes (faster)
Config.Barrels.ProductionChance = 0.8 -- 80% chance (more barrels)
```

### Adjust Economy
```lua
Config.Barrels.SellPrice = 100 -- Higher prices
Config.Business.Types.smallBusiness.upgradeCost = 2500 -- Cheaper upgrades
```

### Adjust Difficulty
```lua
Config.OilWells.QualityDegradationRate = 2 -- Faster degradation
Config.OilWells.MaxCoal = 50 -- Less coal storage
```

## Support

If you need help:

1. 📖 Read this guide thoroughly
2. 🔧 Check your configuration
3. 💬 Join Discord: https://discord.gg/CrKcWdfd3A
4. 🐛 Report issues: GitHub Issues

## Update Instructions

To update to a new version:

1. **Backup** your `config.lua`
2. **Backup** your database
3. **Download** new version
4. **Replace** all files except `config.lua`
5. **Merge** new config options from sample
6. **Run** any new SQL updates
7. **Restart** server

---

**Successfully Installed?** 🎉

You're ready to build your oil empire! Place your first oil well and start producing barrels.

**Made with ❤️ by iBoss21 for The Land of Wolves 🐺**
