# 🐺 LXR Oil Corporation - Client Scripts

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📂 Client-Side Scripts Directory

**The Land of Wolves 🐺** | Georgian RP 🇬🇪

---

## 📋 Purpose

This directory contains all client-side Lua scripts for the LXR Oil Corporation system. These scripts handle player interactions, UI rendering, visual effects, and client-side game logic.

---

## 📄 File Structure

### `main.lua`
**Core client-side logic and initialization**

**Responsibilities:**
- Framework initialization (client-side)
- Player loaded/unloaded event handling
- Oil well and barrel data synchronization
- Item usage registration
- Core client functions

**Key Functions:**
- Player state management
- Data sync from server
- Event registration
- Framework integration

---

### `blips.lua`
**Map blip management system**

**Responsibilities:**
- Creating map blips for oil wells
- Updating blip information
- Removing blips for destroyed wells
- Optimized blip rendering

**Features:**
- Dynamic blip creation/deletion
- Blip customization per well
- Performance-optimized updates
- Distance-based visibility (optional)

**Key Functions:**
```lua
CreateOilWellBlip(well)    -- Creates blip for oil well
UpdateBlips()              -- Updates all blips
RemoveBlip(wellId)         -- Removes specific blip
```

---

### `targets.lua`
**Interaction target zone management**

**Responsibilities:**
- Creating interaction zones for oil wells
- Creating interaction zones for barrels
- Handling target system integration
- Fallback to prompt system if no target resource

**Supported Target Systems:**
- rsg-target
- ox_target
- vorp_target
- qb-target
- Native prompts (fallback)

**Key Functions:**
```lua
CreateWellTarget(well)     -- Creates interaction target for well
CreateBarrelTarget(barrel) -- Creates interaction target for barrel
RemoveTarget(id)           -- Removes interaction target
```

---

### `barrels.lua`
**Barrel pickup, carry, and drop system**

**Responsibilities:**
- Barrel pickup interactions
- Carrying barrel (prop attachment)
- Drop barrel functionality
- Barrel selling at buyer locations
- Animation handling

**Features:**
- Realistic carrying animations
- Proper prop attachment to player
- Movement restriction while carrying
- Buyer location detection
- Visual feedback

**Key Functions:**
```lua
PickupBarrel(barrelId)     -- Pick up barrel
DropBarrel()               -- Drop carried barrel
SellBarrel(buyerIndex)     -- Sell barrel to buyer
IsCarryingBarrel()         -- Check if carrying
```

---

### `business.lua`
**Business management UI and client logic**

**Responsibilities:**
- Business menu UI rendering
- Business registration interface
- Worker management UI
- Business statistics display
- Upgrade interface

**Features:**
- Interactive menu system
- Real-time business data updates
- Worker hire/fire interface
- Tier upgrade options
- Rent payment system

**Key Functions:**
```lua
OpenBusinessMenu()         -- Open main business menu
ShowUpgradeMenu()          -- Show tier upgrade options
ShowWorkerMenu()           -- Show worker management
UpdateBusinessDisplay()    -- Refresh business data
```

---

### `missions.lua`
**Mission system client-side logic**

**Responsibilities:**
- Mission UI and menu
- Mission acceptance
- Mission objective tracking
- Mission waypoint rendering
- Mission completion handling

**Features:**
- Available missions list
- Active mission tracker
- Objective waypoints
- Timer display
- Completion notifications

**Key Functions:**
```lua
OpenMissionMenu()          -- Open mission selection menu
AcceptMission(missionType) -- Accept a mission
UpdateMissionTracker()     -- Update active mission display
CompleteMission()          -- Submit mission completion
```

---

## 🔄 Event Flow

### Player Join
1. Framework detects player loaded
2. Request oil well data from server
3. Initialize blips for nearby wells
4. Create target zones for nearby wells
5. Sync barrel locations

### Oil Well Interaction
1. Player enters target zone
2. Target system shows interaction options
3. Player selects action (Add Coal, Repair, etc.)
4. Client triggers server event
5. Server validates and processes
6. Client receives update and refreshes UI

### Barrel Lifecycle
1. Server creates barrel → Client receives sync
2. Client creates barrel prop and target
3. Player picks up barrel → Server validates
4. Client attaches prop to player
5. Player moves to buyer → Client detects proximity
6. Player sells → Server validates and pays
7. Client removes prop

---

## 🎮 Client-Side Features

### Visual Elements
- **Oil Well Props**: Rendered at coordinates from server
- **Barrel Props**: Spawned and managed dynamically
- **Map Blips**: Oil wells shown on map
- **UI Menus**: Business and mission interfaces
- **Animations**: Placement, repair, pickup, carry

### Performance Optimizations
- **Lazy Loading**: Only render nearby wells
- **Blip Optimization**: Update at intervals, not every frame
- **Target Zones**: Create/destroy based on proximity
- **Animation Preloading**: All dicts loaded at start
- **Event Throttling**: Rate-limited updates

---

## 🔧 Configuration Impact

Client scripts respond to various config settings:

- `Config.EnableBlips` - Show/hide map blips
- `Config.EnablePrompts` - Use prompts if no target system
- `Config.OilWells.InteractionDistance` - Target zone range
- `Config.Target.System` - Target system selection
- `Config.Notifications.Type` - Notification style

---

## 🛠️ Development Notes

### Adding New Client Features

1. Create new file in `client/` directory
2. Add to `fxmanifest.lua` client_scripts
3. Follow existing code structure
4. Use framework adapter functions
5. Test with all supported frameworks

### Client-Side Best Practices

- **Never trust client data** - Always validate on server
- **Use framework adapter** - For cross-framework compatibility
- **Optimize loops** - Use appropriate Wait() values
- **Preload assets** - Load models/anims at startup
- **Clean up** - Remove blips/targets on resource stop

---

## 📚 Related Documentation

- [Server Scripts](../server/README.md)
- [Shared Scripts](../shared/README.md)
- [Configuration Guide](../docs/configuration.md)
- [Events & API](../docs/events.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
