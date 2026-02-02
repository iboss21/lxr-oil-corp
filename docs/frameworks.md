# 🐺 LXR Oil Corporation - Framework Support

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📖 Documentation - Framework Support

**The Land of Wolves 🐺** | Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!

---

## 🔧 Multi-Framework Architecture

LXR Oil Corporation uses a **unified adapter layer** to support multiple frameworks seamlessly. The system automatically detects your framework and adapts accordingly.

### Framework Priority (Auto-Detection Order)

1. **LXR-Core** (Primary) - `lxr-core`
2. **RSG-Core** (Primary) - `rsg-core`
3. **QBR Core** (Supported) - `qbr-core`
4. **QR Core** (Supported) - `qr-core`
5. **VORP Core** (Supported) - `vorp_core`
6. **RedEM:RP** (Supported) - `redem_roleplay`
7. **Standalone** (Fallback) - No framework required

---

## 🎯 Supported Frameworks

### ✅ LXR-Core (Primary)

**Status**: Fully Supported - Best Experience  
**Resource**: `lxr-core`

#### Features
- Full integration with LXR-Core events
- Inventory system integration
- Job/business system integration
- XP/leveling system integration
- Native notification support

#### Configuration
```lua
Config.FrameworkSettings.lxrcore = {
    enabled = true,
    resource = 'lxr-core',
    exportName = 'lxr-core',
    getSharedObject = 'lxr-core:getSharedObject',
    playerLoaded = 'LXR:Client:OnPlayerLoaded',
    playerUnloaded = 'LXR:Client:OnPlayerUnload',
    notification = 'lxr',
}
```

#### Event Names
- Player loaded: `LXR:Client:OnPlayerLoaded`
- Player unloaded: `LXR:Client:OnPlayerUnload`
- Notifications: Uses LXR notification system

---

### ✅ RSG-Core (Primary)

**Status**: Fully Supported - Best Experience  
**Resource**: `rsg-core`

#### Features
- Complete RSGCore integration
- Inventory compatibility
- Job system integration
- Metadata support
- RSG notification system

#### Configuration
```lua
Config.FrameworkSettings['rsg-core'] = {
    enabled = true,
    resource = 'rsg-core',
    exportName = 'rsg-core',
    getSharedObject = 'rsg-core:getSharedObject',
    playerLoaded = 'RSGCore:Client:OnPlayerLoaded',
    playerUnloaded = 'RSGCore:Client:OnPlayerUnload',
    notification = 'rsg',
}
```

#### Event Names
- Player loaded: `RSGCore:Client:OnPlayerLoaded`
- Player unloaded: `RSGCore:Client:OnPlayerUnload`
- Notifications: `RSGCore:Notify`

---

### ✅ VORP Core (Supported)

**Status**: Fully Supported  
**Resource**: `vorp_core`

#### Features
- VORP inventory integration
- Character system support
- Money system integration
- VORP notification system

#### Configuration
```lua
Config.FrameworkSettings.vorp = {
    enabled = true,
    resource = 'vorp_core',
    exportName = 'vorp_core',
    getSharedObject = 'vorp:getSharedObject',
    playerLoaded = 'vorp:SelectedCharacter',
    playerUnloaded = 'vorp:PlayerLogout',
    notification = 'vorp',
}
```

#### Event Names
- Player loaded: `vorp:SelectedCharacter`
- Player unloaded: `vorp:PlayerLogout`
- Notifications: Uses VORP notification system

---

### ✅ RedEM:RP (Supported)

**Status**: Supported  
**Resource**: `redem_roleplay`

#### Features
- RedEM inventory integration
- Character system support
- Economy integration

#### Configuration
```lua
Config.FrameworkSettings.redemrp = {
    enabled = true,
    resource = 'redem_roleplay',
    exportName = 'redem_roleplay',
    getSharedObject = 'redem:getSharedObject',
    playerLoaded = 'RedEM:PlayerLoaded',
    playerUnloaded = 'RedEM:PlayerUnload',
    notification = 'redemrp',
}
```

---

### ✅ QBR Core / QR Core (Supported)

**Status**: Supported  
**Resource**: `qbr-core` / `qr-core`

#### Features
- QB-style inventory integration
- Job system support
- Economy integration

---

### ✅ Standalone Mode (Fallback)

**Status**: Basic Functionality  
**Resource**: None required

#### Features
- No framework dependencies
- Basic inventory tracking
- Native notifications
- Limited economy features

#### Use Cases
- Testing environments
- Custom framework servers
- Lightweight implementations

---

## 🔄 Framework Adapter Layer

The adapter layer (`shared/framework.lua`) provides unified functions that work across all frameworks:

### Unified Functions

#### Player Functions
```lua
Framework.GetPlayer(source)              -- Get player object
Framework.GetPlayerIdentifier(source)    -- Get unique identifier
Framework.GetPlayerJob(source)           -- Get player job
Framework.GetPlayerMoney(source, type)   -- Get player money
```

#### Inventory Functions
```lua
Framework.AddItem(source, item, amount)     -- Add item to inventory
Framework.RemoveItem(source, item, amount)  -- Remove item from inventory
Framework.GetItem(source, item)             -- Get item data
Framework.HasItem(source, item, amount)     -- Check if has item
```

#### Economy Functions
```lua
Framework.AddMoney(source, amount, type)    -- Add money
Framework.RemoveMoney(source, amount, type) -- Remove money
```

#### Notification Functions
```lua
Framework.Notify(source, message, type, duration) -- Send notification
```

#### XP/Level Functions (if supported)
```lua
Framework.AddXP(source, amount)             -- Add XP
Framework.GetLevel(source)                  -- Get player level
```

---

## 📝 Framework-Specific Implementation

### How Detection Works

```lua
function Framework.Detect()
    if Config.Framework ~= 'auto' then
        Framework.Type = Config.Framework
        return
    end
    
    -- Auto-detect based on resource state
    if GetResourceState('lxr-core') == 'started' then
        Framework.Type = 'lxrcore'
    elseif GetResourceState('rsg-core') == 'started' then
        Framework.Type = 'rsg-core'
    -- ... other frameworks
    else
        Framework.Type = 'standalone'
    end
end
```

### Initialization

```lua
function Framework.Init()
    Framework.Detect()
    
    -- Load framework core object
    if Framework.Type == 'lxrcore' then
        Framework.Core = exports['lxr-core']:GetCoreObject()
    elseif Framework.Type == 'rsg-core' then
        Framework.Core = exports['rsg-core']:GetCoreObject()
    -- ... other frameworks
    end
end
```

---

## 🔌 Integration Examples

### Adding Items (Cross-Framework)

```lua
-- Server-side
local success = Framework.AddItem(source, 'crude_oil', 1)
if success then
    Framework.Notify(source, 'Received crude oil barrel!', 'success')
end
```

Works on **all frameworks** - the adapter handles the differences.

### Checking Player Money

```lua
-- Server-side
local money = Framework.GetPlayerMoney(source, 'cash')
if money >= 5000 then
    Framework.RemoveMoney(source, 5000, 'cash')
    -- Upgrade business
end
```

### Getting Player Data

```lua
-- Server-side
local Player = Framework.GetPlayer(source)
local identifier = Framework.GetPlayerIdentifier(source)
local job = Framework.GetPlayerJob(source)
```

---

## 🎯 Target System Compatibility

Supports multiple target systems:

- **rsg-target** (RSG-Core primary)
- **ox_target** (LXR-Core primary)
- **vorp_target** (VORP)
- **qb-target** (QBR/QR)
- **Fallback prompts** (if no target system)

### Auto-Detection

```lua
Config.Target.System = 'auto'  -- Automatically detects target system
```

---

## 💡 Framework-Specific Notes

### LXR-Core
- Recommended to use `ox_target` for interactions
- Supports full XP system integration
- Best performance with ox_lib notifications

### RSG-Core
- Works best with `rsg-target`
- Full metadata support for items
- Integrated with RSG job system

### VORP Core
- Use `vorp_target` for best experience
- Character-based inventory system
- Gold/cash dual currency support

### Standalone
- Uses native RedM functions
- Basic inventory simulation
- Limited progression features

---

## 🔧 Custom Framework Support

To add support for a custom framework:

1. Add framework configuration to `Config.FrameworkSettings`
2. Implement adapter functions in `shared/framework.lua`
3. Test all core functions (inventory, money, notifications)
4. Submit PR or contact for integration support

---

## 📚 Related Documentation

- [Installation Guide](installation.md)
- [Configuration Reference](configuration.md)
- [Events & API](events.md)
- [Security Best Practices](security.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
