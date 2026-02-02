# 🐺 LXR Oil Corporation - Events & API Reference

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📖 Documentation - Events & API Reference

**The Land of Wolves 🐺** | Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!

---

## 📡 Event System

LXR Oil Corporation uses a comprehensive event system for client-server communication and resource integration.

---

## 🔵 Client Events

### Oil Well Events

#### `lxr-oil-corp:client:syncOilWells`
Synchronizes oil well data from server to client.

**Parameters:**
- `wells` (table) - Array of oil well data

**Example:**
```lua
RegisterNetEvent('lxr-oil-corp:client:syncOilWells', function(wells)
    print('Received ' .. #wells .. ' oil wells')
end)
```

#### `lxr-oil-corp:client:updateBlips`
Triggers update of map blips for oil wells.

**Parameters:** None

#### `lxr-oil-corp:client:updateTargets`
Updates interaction targets for oil wells.

**Parameters:** None

#### `lxr-oil-corp:client:placeOilWell`
Initiates oil well placement process.

**Parameters:**
- `coords` (vector3) - Placement coordinates
- `heading` (float) - Placement heading

**Example:**
```lua
TriggerEvent('lxr-oil-corp:client:placeOilWell', GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
```

### Barrel Events

#### `lxr-oil-corp:client:syncBarrels`
Synchronizes barrel locations from server.

**Parameters:**
- `barrels` (table) - Array of barrel data

#### `lxr-oil-corp:client:pickupBarrel`
Handles barrel pickup interaction.

**Parameters:**
- `barrelId` (number) - Barrel database ID

#### `lxr-oil-corp:client:dropBarrel`
Drops currently carried barrel.

**Parameters:** None

### Business Events

#### `lxr-oil-corp:client:openBusinessMenu`
Opens business management menu.

**Parameters:** None

**Example:**
```lua
TriggerEvent('lxr-oil-corp:client:openBusinessMenu')
```

#### `lxr-oil-corp:client:updateBusiness`
Updates business data on client.

**Parameters:**
- `business` (table) - Business data

### Mission Events

#### `lxr-oil-corp:client:syncMissions`
Synchronizes active missions.

**Parameters:**
- `missions` (table) - Active mission data

#### `lxr-oil-corp:client:startMission`
Starts a new mission.

**Parameters:**
- `missionData` (table) - Mission details

#### `lxr-oil-corp:client:completeMission`
Triggers mission completion.

**Parameters:**
- `missionId` (number) - Mission database ID

---

## 🟢 Server Events

### Oil Well Events

#### `lxr-oil-corp:server:placeOilWell`
Server-side oil well placement handler.

**Parameters:**
- `coords` (vector3) - Placement coordinates
- `heading` (float) - Placement heading

**Example:**
```lua
-- Client side
TriggerServerEvent('lxr-oil-corp:server:placeOilWell', coords, heading)
```

#### `lxr-oil-corp:server:addCoal`
Adds coal to an oil well.

**Parameters:**
- `wellId` (number) - Oil well database ID

#### `lxr-oil-corp:server:repairOilWell`
Repairs an oil well.

**Parameters:**
- `wellId` (number) - Oil well database ID

#### `lxr-oil-corp:server:destroyOilWell`
Removes an oil well.

**Parameters:**
- `wellId` (number) - Oil well database ID

### Barrel Events

#### `lxr-oil-corp:server:pickupBarrel`
Server-side barrel pickup handler.

**Parameters:**
- `barrelId` (number) - Barrel database ID

#### `lxr-oil-corp:server:sellBarrel`
Sells a barrel to a buyer.

**Parameters:**
- `barrelId` (number) - Barrel database ID
- `buyerIndex` (number) - Buyer location index

**Example:**
```lua
-- Client side
TriggerServerEvent('lxr-oil-corp:server:sellBarrel', barrelId, 1)
```

### Business Events

#### `lxr-oil-corp:server:registerBusiness`
Registers a new business or upgrades existing.

**Parameters:**
- `tier` (string) - Business tier ('small', 'company', 'corporation')

**Example:**
```lua
-- Client side
TriggerServerEvent('lxr-oil-corp:server:registerBusiness', 'small')
```

#### `lxr-oil-corp:server:hireWorker`
Hires a new worker.

**Parameters:**
- `workerType` (string) - Type of worker

#### `lxr-oil-corp:server:fireWorker`
Fires a worker.

**Parameters:**
- `workerId` (number) - Worker database ID

#### `lxr-oil-corp:server:payRent`
Pays business rent.

**Parameters:** None

### Mission Events

#### `lxr-oil-corp:server:acceptMission`
Accepts a new mission.

**Parameters:**
- `missionType` (string) - Mission type

#### `lxr-oil-corp:server:completeMission`
Completes an active mission.

**Parameters:**
- `missionId` (number) - Mission database ID

#### `lxr-oil-corp:server:cancelMission`
Cancels an active mission.

**Parameters:**
- `missionId` (number) - Mission database ID

---

## 🔄 Framework Adapter API

The framework adapter provides unified functions for resource integration.

### Player Functions

#### `Framework.GetPlayer(source)`
Gets player object from framework.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** Framework player object or nil

**Example:**
```lua
local Player = Framework.GetPlayer(source)
if Player then
    print('Player found: ' .. Player.identifier)
end
```

#### `Framework.GetPlayerIdentifier(source)`
Gets unique player identifier.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** (string) Player identifier

**Example:**
```lua
local identifier = Framework.GetPlayerIdentifier(source)
print('Player ID: ' .. identifier)
```

#### `Framework.GetPlayerJob(source)`
Gets player's current job.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** (table) Job data {name, grade, label}

#### `Framework.GetPlayerMoney(source, type)`
Gets player's money amount.

**Parameters:**
- `source` (number) - Player server ID
- `type` (string) - Money type ('cash', 'bank', 'gold')

**Returns:** (number) Money amount

**Example:**
```lua
local cash = Framework.GetPlayerMoney(source, 'cash')
if cash >= 1000 then
    print('Player has enough cash')
end
```

### Inventory Functions

#### `Framework.AddItem(source, item, amount, metadata)`
Adds item to player inventory.

**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Item quantity
- `metadata` (table, optional) - Item metadata

**Returns:** (boolean) Success status

**Example:**
```lua
local success = Framework.AddItem(source, 'crude_oil', 1)
if success then
    Framework.Notify(source, 'Received crude oil!', 'success')
end
```

#### `Framework.RemoveItem(source, item, amount)`
Removes item from player inventory.

**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Item quantity

**Returns:** (boolean) Success status

#### `Framework.HasItem(source, item, amount)`
Checks if player has item.

**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Required quantity

**Returns:** (boolean) Has item status

**Example:**
```lua
if Framework.HasItem(source, 'coal', 5) then
    print('Player has 5 coal')
end
```

#### `Framework.GetItem(source, item)`
Gets item data from player inventory.

**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name

**Returns:** (table) Item data or nil

### Economy Functions

#### `Framework.AddMoney(source, amount, type)`
Adds money to player.

**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - Money amount
- `type` (string) - Money type ('cash', 'bank', 'gold')

**Returns:** (boolean) Success status

**Example:**
```lua
Framework.AddMoney(source, 500, 'cash')
Framework.Notify(source, 'Received $500!', 'success')
```

#### `Framework.RemoveMoney(source, amount, type)`
Removes money from player.

**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - Money amount
- `type` (string) - Money type ('cash', 'bank', 'gold')

**Returns:** (boolean) Success status

### Notification Functions

#### `Framework.Notify(source, message, type, duration)`
Sends notification to player.

**Parameters:**
- `source` (number) - Player server ID
- `message` (string) - Notification message
- `type` (string) - Notification type ('info', 'success', 'error', 'warning')
- `duration` (number, optional) - Duration in milliseconds

**Example:**
```lua
Framework.Notify(source, 'Oil well placed successfully!', 'success', 5000)
```

### XP Functions (Framework Dependent)

#### `Framework.AddXP(source, amount)`
Adds XP to player (if supported by framework).

**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - XP amount

**Returns:** (boolean) Success status

#### `Framework.GetLevel(source)`
Gets player level (if supported by framework).

**Parameters:**
- `source` (number) - Player server ID

**Returns:** (number) Player level

---

## 🔗 Export Functions

### Server Exports

#### `GetOilWells(identifier)`
Gets all oil wells owned by player.

**Parameters:**
- `identifier` (string) - Player identifier

**Returns:** (table) Array of oil well data

**Example:**
```lua
local wells = exports['lxr-oil-corp']:GetOilWells(identifier)
print('Player owns ' .. #wells .. ' oil wells')
```

#### `GetPlayerBusiness(identifier)`
Gets player's business data.

**Parameters:**
- `identifier` (string) - Player identifier

**Returns:** (table) Business data or nil

#### `AddOilWell(identifier, coords, heading)`
Programmatically adds oil well for player.

**Parameters:**
- `identifier` (string) - Player identifier
- `coords` (vector3) - Well coordinates
- `heading` (float) - Well heading

**Returns:** (boolean) Success status

### Client Exports

#### `IsCarryingBarrel()`
Checks if player is carrying a barrel.

**Returns:** (boolean) Carrying status

**Example:**
```lua
local carrying = exports['lxr-oil-corp']:IsCarryingBarrel()
if carrying then
    print('Player is carrying a barrel')
end
```

#### `GetNearestOilWell()`
Gets nearest oil well to player.

**Returns:** (table) Oil well data or nil

---

## 📝 Integration Examples

### Custom Shop Integration

```lua
-- Add oil well to custom shop
RegisterServerEvent('myshop:buyOilWell')
AddEventHandler('myshop:buyOilWell', function()
    local source = source
    local identifier = Framework.GetPlayerIdentifier(source)
    local money = Framework.GetPlayerMoney(source, 'cash')
    
    if money >= 1000 then
        if Framework.RemoveMoney(source, 1000, 'cash') then
            Framework.AddItem(source, 'oilwell', 1)
            Framework.Notify(source, 'Purchased oil well kit!', 'success')
        end
    else
        Framework.Notify(source, 'Not enough money!', 'error')
    end
end)
```

### Custom Mission System Integration

```lua
-- Reward player with oil well item for completing quest
RegisterServerEvent('myquest:rewardOilWell')
AddEventHandler('myquest:rewardOilWell', function()
    local source = source
    Framework.AddItem(source, 'oilwell', 1)
    Framework.Notify(source, 'Quest reward: Oil Well Kit!', 'success')
end)
```

---

## 📚 Related Documentation

- [Installation Guide](installation.md)
- [Configuration Reference](configuration.md)
- [Framework Support](frameworks.md)
- [Security Best Practices](security.md)
- [Performance Tuning](performance.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
