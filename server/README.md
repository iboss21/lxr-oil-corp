# 🐺 LXR Oil Corporation - Server Scripts

```
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
```

## 📂 Server-Side Scripts Directory

**The Land of Wolves 🐺** | Georgian RP 🇬🇪

---

## 📋 Purpose

This directory contains all server-side Lua scripts for the LXR Oil Corporation system. These scripts handle game logic, database operations, economy transactions, and server authority for all critical operations.

---

## 📄 File Structure

### `main.lua`
**Core server-side logic and event handlers**

**Responsibilities:**
- Framework initialization (server-side)
- Oil well placement and management
- Barrel creation and management
- Player interaction validation
- Economy transactions
- Server event handlers

**Key Features:**
- Server authority for all actions
- Distance validation for interactions
- Ownership verification
- Cooldown enforcement
- Anti-cheat measures

**Key Functions:**
```lua
LoadOilWells()             -- Load oil wells from database
PlaceOilWell(source, ...)  -- Handle well placement
AddCoal(source, wellId)    -- Add coal to well
RepairWell(source, wellId) -- Repair damaged well
SellBarrel(source, ...)    -- Process barrel sale
```

---

### `database.lua`
**Database initialization and management**

**Responsibilities:**
- Creating database tables on first run
- Table structure verification
- Database schema updates
- Initial data setup

**Tables Created:**
- `lxr_oil_wells` - Oil well data
- `lxr_oil_barrels` - Barrel spawns
- `lxr_oil_businesses` - Business data
- `lxr_oil_workers` - Hired workers
- `lxr_oil_missions` - Active missions

**Key Functions:**
```lua
InitializeDatabase()       -- Create tables if not exist
VerifyTables()            -- Check table integrity
UpdateSchema()            -- Handle version migrations
```

---

### `business.lua`
**Business management system**

**Responsibilities:**
- Business registration and upgrades
- Worker hiring and management
- Rent collection system
- Business tier progression
- Business statistics

**Features:**
- Tier-based progression (Personal → Corporation)
- Worker production bonuses
- Automatic rent collection
- Business status tracking
- Upgrade validation

**Key Functions:**
```lua
RegisterBusiness(source, tier)  -- Register/upgrade business
HireWorker(source, workerType)  -- Hire worker
FireWorker(source, workerId)    -- Fire worker
CollectRent(business)           -- Process rent payment
GetBusinessStats(identifier)    -- Get business statistics
```

---

### `missions.lua`
**Mission generation and validation**

**Responsibilities:**
- Generating random missions
- Mission acceptance and tracking
- Mission objective validation
- Reward distribution
- Mission timeout handling

**Mission Types:**
- **Delivery**: Transport barrels to specific locations
- **Exploration**: Discover oil-rich areas
- **Maintenance**: Repair multiple oil wells
- **Protection**: Defend oil shipments

**Key Functions:**
```lua
GenerateMission(type)           -- Create new mission
AcceptMission(source, type)     -- Player accepts mission
CompleteMission(source, id)     -- Validate and reward
CancelMission(source, id)       -- Cancel active mission
CheckMissionTimeout()           -- Handle expired missions
```

---

### `cron.lua`
**Scheduled tasks and automation**

**Responsibilities:**
- Barrel production cycles
- Oil well quality degradation
- Rent collection scheduling
- Mission timeout checks
- Database cleanup
- Cache management

**Cron Jobs:**
- **Production**: Every 5 minutes (configurable)
- **Quality Loss**: Every production cycle
- **Rent Collection**: Weekly (configurable)
- **Cleanup**: Daily

**Key Functions:**
```lua
ProductionCycle()              -- Process all well production
DegradeQuality()               -- Apply quality loss
CollectAllRent()               -- Process rent for all businesses
CleanupOldData()               -- Remove stale database entries
```

---

### `versioncheck.lua`
**Version monitoring and update notifications**

**Responsibilities:**
- Checking GitHub for updates
- Notifying admins of new versions
- Version comparison logic
- Update availability alerts

**Features:**
- Automatic version checking on startup
- GitHub API integration
- Admin notifications
- Non-intrusive alerts

**Key Functions:**
```lua
CheckVersion()                 -- Check for updates
CompareVersions(current, latest) -- Compare version strings
NotifyAdmins(message)          -- Alert admins
```

---

## 🛡️ Security Architecture

### Server Authority Principles

All critical operations are validated server-side:

1. **Distance Checks**
   - Player must be near oil well to interact
   - Prevents teleportation exploits
   - Configurable max distance

2. **Ownership Validation**
   - Players can only modify their own assets
   - Cross-reference database ownership
   - Log suspicious activity

3. **Cooldown System**
   - Rate limiting per player
   - Action-specific cooldowns
   - Prevents spam exploits

4. **Economy Validation**
   - Server calculates all prices
   - Inventory checks before giving items
   - Money checks before purchases
   - Anti-duplication measures

5. **Input Validation**
   - Sanitize all client inputs
   - Type checking
   - Range validation
   - SQL injection prevention

---

## 💾 Database Operations

### Query Optimization

- **Prepared Statements**: All queries use parameters
- **Batch Operations**: Multiple updates batched together
- **Connection Pooling**: Efficient connection usage
- **Indexes**: Proper indexing on all lookup columns

### Data Integrity

- **Transactions**: Critical operations use transactions
- **Foreign Keys**: Maintain referential integrity
- **Constraints**: Prevent invalid data
- **Backups**: Regular automated backups recommended

---

## 🔄 Event Flow

### Oil Well Placement
1. Client triggers `lxr-oil-corp:server:placeOilWell`
2. Server validates:
   - Player has item
   - Player hasn't exceeded well limit
   - Coordinates are valid
   - Distance from player is reasonable
3. Remove item from inventory
4. Insert into database
5. Add to server-side OilWells table
6. Sync to all nearby clients

### Barrel Production (Cron)
1. Cron job triggers every 5 minutes
2. Load all active oil wells
3. For each well:
   - Check quality > minimum
   - Check coal > 0
   - Roll production chance
   - Create barrel if successful
   - Consume coal
   - Degrade quality
4. Sync new barrels to clients

### Business Transaction
1. Client triggers purchase event
2. Server validates:
   - Player level requirement
   - Player has money
   - Not already at that tier
3. Remove money
4. Update database
5. Unlock new limits
6. Notify player
7. Sync business data

---

## 🔧 Configuration Impact

Server scripts respond to various config settings:

- `Config.OilWells.*` - Well behavior and limits
- `Config.Barrels.*` - Production settings
- `Config.Business.*` - Business tiers and costs
- `Config.Missions.*` - Mission generation
- `Config.Security.*` - Security settings
- `Config.Performance.*` - Optimization settings

---

## 📊 Performance Considerations

### Optimization Strategies

1. **Caching**
   - Cache player business data
   - Cache oil well data
   - Clear expired cache regularly

2. **Batch Processing**
   - Process production in batches
   - Batch database writes when possible
   - Stagger heavy operations

3. **Lazy Loading**
   - Only sync nearby oil wells to players
   - Load mission data on demand
   - Unload disconnected player data

4. **Efficient Queries**
   - Use indexes on lookup columns
   - Limit query results
   - Avoid SELECT *
   - Use WHERE clauses efficiently

---

## 🛠️ Development Notes

### Adding New Server Features

1. Create function in appropriate file
2. Add server event if needed
3. Implement validation logic
4. Add database operations if required
5. Update client sync if necessary
6. Test security thoroughly

### Server-Side Best Practices

- **Always validate client input** - Never trust clients
- **Log security violations** - Track suspicious activity
- **Use framework adapter** - Cross-framework compatibility
- **Handle errors gracefully** - Don't crash the server
- **Comment complex logic** - Help future maintainers

---

## 🔒 Security Checklist

- [ ] All client inputs validated
- [ ] Distance checks implemented
- [ ] Ownership verification active
- [ ] Cooldowns enforced
- [ ] Economy calculations server-side
- [ ] SQL injection prevented (parameterized queries)
- [ ] Rate limiting enabled
- [ ] Suspicious activity logged
- [ ] Error handling implemented
- [ ] Admin commands protected

---

## 📚 Related Documentation

- [Client Scripts](../client/README.md)
- [Shared Scripts](../shared/README.md)
- [Security Best Practices](../docs/security.md)
- [Performance Tuning](../docs/performance.md)
- [Events & API](../docs/events.md)

---

**© 2026 iBoss21 / The Lux Empire**  
**🐺 The Land of Wolves** | [wolves.land](https://www.wolves.land)
