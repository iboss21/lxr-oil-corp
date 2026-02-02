# 🐺 LXR Oil Corporation - Security Best Practices

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📖 Documentation - Security Best Practices

**The Land of Wolves 🐺** | Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!

---

## 🛡️ Security Architecture

LXR Oil Corporation implements multiple layers of security to prevent exploits and ensure fair gameplay.

### Core Security Principles

1. **Server Authority** - All critical operations validated server-side
2. **Never Trust Client** - Client data is always verified
3. **Ownership Validation** - Players can only modify their own assets
4. **Distance Checks** - Prevent teleportation exploits
5. **Rate Limiting** - Anti-spam and cooldown enforcement
6. **Input Validation** - All inputs sanitized and validated

---

## 🔒 Built-In Security Features

### 1. Server-Side Validation

**All economy-related actions are validated server-side:**

```lua
-- ❌ BAD: Trusting client data
RegisterServerEvent('sellBarrel')
AddEventHandler('sellBarrel', function(price)
    -- Client could send any price!
    Framework.AddMoney(source, price, 'cash')
end)

-- ✅ GOOD: Server calculates price
RegisterServerEvent('lxr-oil-corp:server:sellBarrel')
AddEventHandler('lxr-oil-corp:server:sellBarrel', function(barrelId, buyerIndex)
    local price = CalculateBarrelPrice(source, buyerIndex) -- Server calculates
    Framework.AddMoney(source, price, 'cash')
end)
```

### 2. Ownership Verification

**Players can only interact with their own oil wells:**

```lua
local function ValidateOwnership(source, wellId)
    local identifier = Framework.GetPlayerIdentifier(source)
    local well = OilWells[wellId]
    
    if not well then
        return false, 'Oil well not found'
    end
    
    if well.owner ~= identifier then
        LogSuspiciousActivity(source, 'Attempted to access oil well they do not own')
        return false, 'You do not own this oil well'
    end
    
    return true
end
```

### 3. Distance Checks

**Prevent teleportation exploits:**

```lua
local function ValidateDistance(source, coords, maxDistance)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local distance = #(playerCoords - coords)
    
    if distance > maxDistance then
        LogSuspiciousActivity(source, 'Distance check failed: ' .. distance .. 'm')
        return false
    end
    
    return true
end

-- Usage
if not ValidateDistance(source, wellCoords, Config.Security.MaxInteractionDistance) then
    Framework.Notify(source, 'You are too far away!', 'error')
    return
end
```

### 4. Cooldown System

**Prevent spam and abuse:**

```lua
local Cooldowns = {}

local function CheckCooldown(source, action, duration)
    local identifier = Framework.GetPlayerIdentifier(source)
    local key = identifier .. ':' .. action
    local currentTime = os.time()
    
    if Cooldowns[key] and Cooldowns[key] > currentTime then
        local remaining = Cooldowns[key] - currentTime
        return false, remaining
    end
    
    Cooldowns[key] = currentTime + duration
    return true
end

-- Usage
local canPerform, remaining = CheckCooldown(source, 'place_well', 60)
if not canPerform then
    Framework.Notify(source, 'Cooldown: ' .. remaining .. 's remaining', 'error')
    return
end
```

### 5. Rate Limiting

**Prevent rapid-fire actions:**

```lua
local ActionTracker = {}

local function RateLimitCheck(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    local currentTime = os.time()
    
    if not ActionTracker[identifier] then
        ActionTracker[identifier] = {count = 0, window = currentTime + 60}
    end
    
    local tracker = ActionTracker[identifier]
    
    -- Reset if window expired
    if currentTime > tracker.window then
        tracker.count = 0
        tracker.window = currentTime + 60
    end
    
    tracker.count = tracker.count + 1
    
    -- Max 30 actions per minute
    if tracker.count > Config.Security.AntiSpam.maxActionsPerMinute then
        LogSuspiciousActivity(source, 'Rate limit exceeded')
        return false
    end
    
    return true
end
```

### 6. Input Validation

**Sanitize all inputs:**

```lua
local function ValidateCoords(coords)
    if type(coords) ~= 'vector3' then
        return false, 'Invalid coordinates type'
    end
    
    -- Check for NaN or infinite values
    if coords.x ~= coords.x or coords.y ~= coords.y or coords.z ~= coords.z then
        return false, 'Invalid coordinate values'
    end
    
    -- Check reasonable bounds (adjust for your map)
    if math.abs(coords.x) > 10000 or math.abs(coords.y) > 10000 then
        return false, 'Coordinates out of bounds'
    end
    
    return true
end
```

---

## 🚨 Exploit Prevention

### Duplication Exploits

**Prevention measures:**

```lua
-- Database transactions for item operations
local function SellBarrel(source, barrelId)
    local barrel = Barrels[barrelId]
    if not barrel then return false end
    
    -- Remove from database FIRST
    local deleted = MySQL.query.await('DELETE FROM lxr_oil_barrels WHERE id = ? AND owner = ?', {
        barrelId,
        Framework.GetPlayerIdentifier(source)
    })
    
    -- Only give money if delete succeeded
    if deleted.affectedRows > 0 then
        Framework.AddMoney(source, price, 'cash')
        Barrels[barrelId] = nil
        return true
    end
    
    return false
end
```

### Item Injection

**Validation before adding items:**

```lua
local VALID_ITEMS = {
    'oilwell',
    'coal',
    'crude_oil',
    'ironbar',
    'wood'
}

local function ValidateItem(itemName)
    for _, validItem in ipairs(VALID_ITEMS) do
        if itemName == validItem then
            return true
        end
    end
    return false
end

-- Before adding item
if not ValidateItem(itemName) then
    LogSuspiciousActivity(source, 'Attempted to add invalid item: ' .. itemName)
    return false
end
```

### Teleportation Exploits

**Distance validation for all interactions:**

```lua
RegisterServerEvent('lxr-oil-corp:server:repairOilWell')
AddEventHandler('lxr-oil-corp:server:repairOilWell', function(wellId)
    local source = source
    local well = OilWells[wellId]
    
    -- Validate ownership
    if not ValidateOwnership(source, wellId) then
        return
    end
    
    -- Validate distance
    if not ValidateDistance(source, well.coords, 5.0) then
        Framework.Notify(source, 'You must be near the oil well!', 'error')
        BanCheck(source) -- Optional: track repeated violations
        return
    end
    
    -- Proceed with repair
    -- ...
end)
```

### SQL Injection

**Using parameterized queries:**

```lua
-- ❌ NEVER DO THIS
MySQL.query('SELECT * FROM lxr_oil_wells WHERE owner = "' .. identifier .. '"', {}, function(result)
    -- Vulnerable to SQL injection!
end)

-- ✅ ALWAYS USE PARAMETERIZED QUERIES
local result = MySQL.query.await('SELECT * FROM lxr_oil_wells WHERE owner = ?', {identifier})
```

---

## 📊 Suspicious Activity Logging

### Logging System

```lua
local function LogSuspiciousActivity(source, reason)
    if not Config.Security.LogSuspiciousActivity then
        return
    end
    
    local identifier = Framework.GetPlayerIdentifier(source)
    local playerName = GetPlayerName(source)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    
    -- Log to database
    MySQL.insert.await('INSERT INTO lxr_oil_security_logs (identifier, name, reason, timestamp) VALUES (?, ?, ?, ?)', {
        identifier,
        playerName,
        reason,
        timestamp
    })
    
    -- Log to console
    print(string.format('^3[LXR Oil Corp Security]^7 %s (%s): %s', playerName, identifier, reason))
    
    -- Optional: Send to Discord webhook
    if Config.DiscordWebhook then
        SendToDiscord('Security Alert', playerName .. ' - ' .. reason, 'red')
    end
end
```

### Creating Security Logs Table

```sql
CREATE TABLE IF NOT EXISTS `lxr_oil_security_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `reason` VARCHAR(255) NOT NULL,
    `timestamp` DATETIME NOT NULL,
    INDEX(`identifier`),
    INDEX(`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## ⚙️ Configuration Settings

### Security Configuration

```lua
Config.Security = {
    -- Enable distance validation
    EnableDistanceCheck = true,
    MaxInteractionDistance = 5.0,
    
    -- Enable cooldown system
    EnableCooldowns = true,
    
    -- Anti-spam settings
    AntiSpam = {
        actionCooldown = 1000,      -- 1 second between actions
        maxActionsPerMinute = 30     -- Max 30 actions per minute
    },
    
    -- Validation settings
    ValidateOwnership = true,
    ValidateCoordinates = true,
    
    -- Logging
    LogSuspiciousActivity = true,
    LogToDatabase = true,
    LogToConsole = true,
    
    -- Ban system integration (optional)
    EnableAutoBan = false,           -- Auto-ban on repeated violations
    ViolationsBeforeBan = 5,         -- Number of violations before ban
    BanDuration = 86400              -- Ban duration in seconds (24h)
}
```

---

## 🔐 Admin Commands

### Monitoring Tools

```lua
-- Check player's oil wells
RegisterCommand('checkoilwells', function(source, args)
    if not IsPlayerAdmin(source) then return end
    
    local targetId = tonumber(args[1])
    if not targetId then return end
    
    local identifier = Framework.GetPlayerIdentifier(targetId)
    local wells = GetPlayerOilWells(identifier)
    
    print(string.format('Player %s owns %d oil wells', GetPlayerName(targetId), #wells))
end, true)

-- View security logs
RegisterCommand('securitylogs', function(source, args)
    if not IsPlayerAdmin(source) then return end
    
    local logs = MySQL.query.await('SELECT * FROM lxr_oil_security_logs ORDER BY timestamp DESC LIMIT 50', {})
    
    for _, log in ipairs(logs) do
        print(string.format('[%s] %s: %s', log.timestamp, log.name, log.reason))
    end
end, true)

-- Clear player data (admin cleanup)
RegisterCommand('clearoildata', function(source, args)
    if not IsPlayerAdmin(source) then return end
    
    local targetId = tonumber(args[1])
    if not targetId then return end
    
    local identifier = Framework.GetPlayerIdentifier(targetId)
    
    MySQL.query.await('DELETE FROM lxr_oil_wells WHERE owner = ?', {identifier})
    MySQL.query.await('DELETE FROM lxr_oil_businesses WHERE owner = ?', {identifier})
    
    print('Cleared oil data for player: ' .. GetPlayerName(targetId))
end, true)
```

---

## 📋 Security Checklist

### Pre-Production Checklist

- [ ] All economy actions validated server-side
- [ ] Distance checks enabled and configured
- [ ] Cooldown system active
- [ ] Rate limiting configured
- [ ] Input validation implemented
- [ ] SQL injection prevention (parameterized queries)
- [ ] Suspicious activity logging enabled
- [ ] Admin monitoring commands tested
- [ ] Security logs database table created
- [ ] Discord webhook configured (optional)

### Regular Maintenance

- [ ] Review security logs weekly
- [ ] Monitor for repeated violations
- [ ] Update security thresholds as needed
- [ ] Test new exploits as they're discovered
- [ ] Keep framework updated
- [ ] Backup database regularly

---

## 🚨 Incident Response

### If Exploit Detected

1. **Immediate Action**
   - Restart the resource to clear exploiter's state
   - Kick/ban the player
   - Review security logs

2. **Investigation**
   - Check database for anomalies
   - Review recent transactions
   - Identify exploit method

3. **Remediation**
   - Patch the vulnerability
   - Roll back fraudulent transactions
   - Update security measures

4. **Prevention**
   - Share exploit details with community (after patch)
   - Update documentation
   - Enhance monitoring

---

## 📚 Related Documentation

- [Installation Guide](installation.md)
- [Configuration Reference](configuration.md)
- [Framework Support](frameworks.md)
- [Events & API](events.md)
- [Performance Tuning](performance.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
