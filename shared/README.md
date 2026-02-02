# 🐺 LXR Oil Corporation - Shared Scripts

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📂 Shared Scripts Directory

**The Land of Wolves 🐺** | Georgian RP 🇬🇪

---

## 📋 Purpose

This directory contains scripts that are shared between both client and server sides. These scripts provide unified functionality, framework abstraction, and localization services that work consistently across both environments.

---

## 📄 File Structure

### `framework.lua`
**Multi-framework adapter and abstraction layer**

**Purpose:**  
Provides a unified API for interacting with different RedM frameworks, allowing the resource to support multiple frameworks with a single codebase.

---

#### 🔧 Core Functions

##### Framework Detection & Initialization

```lua
Framework.Detect()
```
**Description:** Automatically detects which framework is installed and active  
**Returns:** Sets `Framework.Type` to detected framework  
**Supports:** LXR-Core, RSG-Core, VORP, RedEM:RP, QBR-Core, QR-Core, Standalone

```lua
Framework.Init()
```
**Description:** Initializes the framework and loads core object  
**Called:** Automatically on resource start  
**Effect:** Populates `Framework.Core` with framework object

---

##### Player Functions

```lua
Framework.GetPlayer(source)
```
**Parameters:** `source` (number) - Player server ID  
**Returns:** Framework player object or nil  
**Usage:** Get player data from any framework

```lua
Framework.GetPlayerIdentifier(source)
```
**Parameters:** `source` (number) - Player server ID  
**Returns:** (string) Unique player identifier  
**Cross-Framework:** Works with all supported frameworks

```lua
Framework.GetPlayerJob(source)
```
**Parameters:** `source` (number) - Player server ID  
**Returns:** (table) {name, grade, label} or nil  
**Note:** Job system varies by framework

```lua
Framework.GetPlayerMoney(source, type)
```
**Parameters:**  
- `source` (number) - Player server ID
- `type` (string) - 'cash', 'bank', 'gold'

**Returns:** (number) Money amount  
**Cross-Framework:** Handles different money systems

---

##### Inventory Functions

```lua
Framework.AddItem(source, item, amount, metadata)
```
**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Quantity
- `metadata` (table, optional) - Item metadata

**Returns:** (boolean) Success status  
**Cross-Framework:** Works with all inventory systems

```lua
Framework.RemoveItem(source, item, amount)
```
**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Quantity

**Returns:** (boolean) Success status

```lua
Framework.HasItem(source, item, amount)
```
**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Required quantity

**Returns:** (boolean) Has item status

```lua
Framework.GetItem(source, item)
```
**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name

**Returns:** (table) Item data or nil

---

##### Economy Functions

```lua
Framework.AddMoney(source, amount, type)
```
**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - Money amount
- `type` (string) - 'cash', 'bank', 'gold'

**Returns:** (boolean) Success status

```lua
Framework.RemoveMoney(source, amount, type)
```
**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - Money amount
- `type` (string) - 'cash', 'bank', 'gold'

**Returns:** (boolean) Success status

---

##### Notification Functions

```lua
Framework.Notify(source, message, type, duration)
```
**Parameters:**
- `source` (number) - Player server ID
- `message` (string) - Notification text
- `type` (string) - 'info', 'success', 'error', 'warning'
- `duration` (number, optional) - Duration in milliseconds

**Cross-Framework:** Adapts to framework's notification system

---

##### XP/Level Functions (Framework Dependent)

```lua
Framework.AddXP(source, amount)
```
**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - XP amount

**Returns:** (boolean) Success status  
**Note:** Only works with frameworks that support XP

```lua
Framework.GetLevel(source)
```
**Parameters:** `source` (number) - Player server ID  
**Returns:** (number) Player level  
**Note:** Returns 0 if framework doesn't support levels

---

#### 🔄 Framework-Specific Implementation

The adapter handles differences between frameworks:

| Feature | LXR-Core | RSG-Core | VORP | Standalone |
|---------|----------|----------|------|------------|
| Player Object | `Functions.GetPlayer()` | `Functions.GetPlayer()` | `getUser()` | Custom |
| Money | `AddMoney()` | `AddMoney()` | `addCurrency()` | Custom |
| Items | `AddItem()` | `AddItem()` | `addInventoryItem()` | Custom |
| Notifications | LXR system | RSGCore:Notify | VORP notify | Native |
| XP/Levels | Supported | Supported | Custom | Limited |

---

### `locale.lua`
**Localization system**

**Purpose:**  
Manages multi-language support for all in-game text, allowing easy translation and language switching.

---

#### 🌍 Core Functions

```lua
Locale.Load(language)
```
**Parameters:** `language` (string) - Language code ('English', 'Georgian', etc.)  
**Effect:** Loads specified language strings  
**Default:** English

```lua
Locale.Get(key, ...)
```
**Parameters:**
- `key` (string) - Translation key
- `...` (optional) - Format parameters

**Returns:** (string) Translated text  
**Example:**
```lua
local text = Locale.Get('oil_well_placed')
local text = Locale.Get('barrel_sold_for', price)
```

---

#### 📝 Language Structure

Languages are stored as tables:

```lua
Locales['English'] = {
    -- Oil Wells
    oil_well_placed = 'Oil well placed successfully!',
    oil_well_destroyed = 'Oil well destroyed',
    coal_added = 'Added %s coal to oil well',
    well_repaired = 'Oil well repaired',
    
    -- Barrels
    barrel_picked_up = 'Picked up crude oil barrel',
    barrel_dropped = 'Dropped barrel',
    barrel_sold_for = 'Sold barrel for $%s',
    
    -- Business
    business_registered = 'Business registered: %s',
    business_upgraded = 'Business upgraded to %s',
    worker_hired = 'Worker hired',
    worker_fired = 'Worker fired',
    
    -- Missions
    mission_accepted = 'Mission accepted: %s',
    mission_completed = 'Mission completed! Reward: $%s',
    mission_failed = 'Mission failed',
    
    -- Errors
    not_enough_money = 'Not enough money',
    no_space_inventory = 'Not enough inventory space',
    too_far_away = 'You are too far away',
    not_owner = 'You do not own this oil well',
    
    -- etc...
}
```

---

#### 🌐 Supported Languages

- **English** - Full support (default)
- **Georgian** (ქართული) - Full support
- **Spanish** - Planned
- **French** - Planned
- **German** - Planned

---

#### ➕ Adding New Languages

1. Create new language table in `locale.lua`:
```lua
Locales['Spanish'] = {
    oil_well_placed = 'Pozo de petróleo colocado con éxito!',
    -- ... etc
}
```

2. Update `Config.Lang` in `config.lua`:
```lua
Config.Lang = 'Spanish'
```

3. Ensure all keys match English version (use as template)

---

## 🔗 Integration Examples

### Using Framework Adapter

**Server-side:**
```lua
RegisterNetEvent('lxr-oil-corp:server:buyItem', function()
    local source = source
    local money = Framework.GetPlayerMoney(source, 'cash')
    
    if money >= 100 then
        Framework.RemoveMoney(source, 100, 'cash')
        Framework.AddItem(source, 'oilwell', 1)
        Framework.Notify(source, 'Purchased oil well kit!', 'success')
    else
        Framework.Notify(source, Locale.Get('not_enough_money'), 'error')
    end
end)
```

**Client-side:**
```lua
RegisterNetEvent('lxr-oil-corp:client:placeWell', function()
    -- Framework adapter works on client too
    Framework.Notify(nil, Locale.Get('oil_well_placed'), 'success')
end)
```

---

### Using Localization

```lua
-- Simple translation
local message = Locale.Get('oil_well_placed')

-- With parameters
local message = Locale.Get('barrel_sold_for', 250)
-- Output: "Sold barrel for $250"

-- In notifications
Framework.Notify(source, Locale.Get('coal_added', 5), 'info')
-- Output: "Added 5 coal to oil well"
```

---

## 🛠️ Development Guidelines

### Extending Framework Adapter

When adding new functionality:

1. **Define the interface** - Create function signature
2. **Implement for each framework** - Handle framework differences
3. **Test thoroughly** - Verify on multiple frameworks
4. **Document usage** - Update this README

Example:
```lua
function Framework.GetPlayerGang(source)
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' then
        local Player = Framework.GetPlayer(source)
        return Player.PlayerData.gang
    elseif Framework.Type == 'vorp' then
        -- VORP might not have gangs
        return nil
    else
        return nil
    end
end
```

---

### Adding Localization Keys

1. Add key to all language tables
2. Use descriptive key names
3. Include format placeholders if needed
4. Test with all supported languages

```lua
-- Add to all Locales tables
Locales['English'].new_key = 'English text here'
Locales['Georgian'].new_key = 'Georgian text here'
```

---

## 📊 Framework Compatibility Matrix

| Feature | LXR | RSG | VORP | RedEM | QBR | QR | Standalone |
|---------|-----|-----|------|-------|-----|-----|------------|
| Player Data | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Inventory | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Money | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Jobs | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| XP/Levels | ✅ | ✅ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | ❌ |
| Notifications | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

Legend:
- ✅ Full Support
- ⚠️ Partial Support
- ❌ Not Supported

---

## 🔒 Security Notes

- Framework adapter validates framework availability before operations
- Handles errors gracefully to prevent crashes
- Never exposes sensitive framework internals
- All operations go through secure framework APIs

---

## 📚 Related Documentation

- [Client Scripts](../client/README.md)
- [Server Scripts](../server/README.md)
- [Framework Support](../docs/frameworks.md)
- [Configuration Guide](../docs/configuration.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
