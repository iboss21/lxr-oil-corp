-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - SERVER MAIN
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local OilWells = {}
local Barrels = {}
local PlayerData = {}

-- ═══════════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function LoadOilWells()
    local result = MySQL.query.await('SELECT * FROM lxr_oil_wells', {})
    if result then
        for _, well in pairs(result) do
            local coords = json.decode(well.coords)
            OilWells[well.id] = {
                id = well.id,
                owner = well.owner,
                coords = vector3(coords.x, coords.y, coords.z),
                heading = well.heading,
                quality = well.quality,
                coal = well.coal,
                created_at = well.created_at,
                last_production = well.last_production
            }
        end
        print('^2[LXR Oil Corp]^7 Loaded ' .. #result .. ' oil wells')
    end
end

local function LoadBarrels()
    local result = MySQL.query.await('SELECT * FROM lxr_oil_barrels', {})
    if result then
        for _, barrel in pairs(result) do
            local coords = json.decode(barrel.coords)
            Barrels[barrel.id] = {
                id = barrel.id,
                oil_well_id = barrel.oil_well_id,
                owner = barrel.owner,
                coords = vector3(coords.x, coords.y, coords.z),
                created_at = barrel.created_at
            }
        end
        print('^2[LXR Oil Corp]^7 Loaded ' .. #result .. ' barrels')
    end
end

local function GetPlayerOilWellCount(identifier)
    local count = 0
    for _, well in pairs(OilWells) do
        if well.owner == identifier then
            count = count + 1
        end
    end
    return count
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- EVENTS - OIL WELL MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:server:placeOilWell', function(coords, heading)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    -- Check if player has the item
    local hasItem = Framework.GetItem(src, Config.OilWells.PlacementItem)
    if not hasItem or hasItem.amount < 1 then
        Framework.Notify(src, L('insufficient_items'), 'error')
        return
    end
    
    -- Check max oil wells
    local currentCount = GetPlayerOilWellCount(identifier)
    if currentCount >= Config.OilWells.MaxOilWellsPerPlayer then
        Framework.Notify(src, L('max_oil_wells'), 'error')
        return
    end
    
    -- Remove item
    Framework.RemoveItem(src, Config.OilWells.PlacementItem, 1)
    
    -- Insert into database
    local result = MySQL.insert.await('INSERT INTO lxr_oil_wells (owner, coords, heading, quality, coal) VALUES (?, ?, ?, ?, ?)', {
        identifier,
        json.encode({x = coords.x, y = coords.y, z = coords.z}),
        heading,
        100,
        0
    })
    
    if result then
        OilWells[result] = {
            id = result,
            owner = identifier,
            coords = coords,
            heading = heading,
            quality = 100,
            coal = 0,
            created_at = os.time(),
            last_production = nil
        }
        
        -- Sync to all clients
        TriggerClientEvent('lxr-oil-corp:client:syncOilWells', -1, OilWells)
        Framework.Notify(src, L('oil_well_placed'), 'success')
        
        -- Add XP
        TriggerEvent('lxr-oil-corp:server:addXP', src, Config.XPSystem.OilWellPlaced)
    end
end)

RegisterNetEvent('lxr-oil-corp:server:destroyOilWell', function(wellId)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local well = OilWells[wellId]
    if not well or well.owner ~= identifier then
        Framework.Notify(src, L('not_authorized'), 'error')
        return
    end
    
    -- Delete from database (cascades to barrels)
    MySQL.query.await('DELETE FROM lxr_oil_wells WHERE id = ?', {wellId})
    
    -- Remove from memory
    OilWells[wellId] = nil
    
    -- Remove all barrels for this well
    for barrelId, barrel in pairs(Barrels) do
        if barrel.oil_well_id == wellId then
            Barrels[barrelId] = nil
        end
    end
    
    -- Return item to player
    Framework.AddItem(src, Config.OilWells.PlacementItem, 1)
    
    -- Sync to all clients
    TriggerClientEvent('lxr-oil-corp:client:syncOilWells', -1, OilWells)
    TriggerClientEvent('lxr-oil-corp:client:syncBarrels', -1, Barrels)
    Framework.Notify(src, L('oil_well_removed'), 'success')
end)

RegisterNetEvent('lxr-oil-corp:server:addCoal', function(wellId)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local well = OilWells[wellId]
    if not well or well.owner ~= identifier then
        Framework.Notify(src, L('not_authorized'), 'error')
        return
    end
    
    -- Check if has coal
    local hasCoal = Framework.GetItem(src, Config.OilWells.CoalItem)
    if not hasCoal or hasCoal.amount < Config.OilWells.CoalPerAddition then
        Framework.Notify(src, L('no_coal'), 'error')
        return
    end
    
    -- Check if coal storage is full
    if well.coal >= Config.OilWells.MaxCoal then
        Framework.Notify(src, L('coal_full'), 'error')
        return
    end
    
    -- Remove coal from player
    Framework.RemoveItem(src, Config.OilWells.CoalItem, Config.OilWells.CoalPerAddition)
    
    -- Add coal to well
    well.coal = math.min(well.coal + Config.OilWells.CoalPerAddition, Config.OilWells.MaxCoal)
    
    -- Update database
    MySQL.query.await('UPDATE lxr_oil_wells SET coal = ? WHERE id = ?', {well.coal, wellId})
    
    -- Sync to all clients
    TriggerClientEvent('lxr-oil-corp:client:syncOilWells', -1, OilWells)
    Framework.Notify(src, L('coal_added', Config.OilWells.CoalPerAddition), 'success')
end)

RegisterNetEvent('lxr-oil-corp:server:repairOilWell', function(wellId)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local well = OilWells[wellId]
    if not well or well.owner ~= identifier then
        Framework.Notify(src, L('not_authorized'), 'error')
        return
    end
    
    -- Calculate repair cost
    local damage = 100 - well.quality
    local cost = math.ceil(damage * Config.OilWells.RepairCost)
    
    -- Check if player can afford
    local playerMoney = Framework.GetPlayerMoney(src)
    if playerMoney < cost then
        Framework.Notify(src, L('cannot_afford_repair'), 'error')
        return
    end
    
    -- Check if has required items
    for _, item in pairs(Config.OilWells.RepairItems) do
        local hasItem = Framework.GetItem(src, item.item)
        if not hasItem or hasItem.amount < item.amount then
            Framework.Notify(src, L('insufficient_items'), 'error')
            return
        end
    end
    
    -- Remove money and items
    Framework.RemoveMoney(src, cost)
    for _, item in pairs(Config.OilWells.RepairItems) do
        Framework.RemoveItem(src, item.item, item.amount)
    end
    
    -- Repair well
    well.quality = 100
    
    -- Update database
    MySQL.query.await('UPDATE lxr_oil_wells SET quality = ? WHERE id = ?', {well.quality, wellId})
    
    -- Sync to all clients
    TriggerClientEvent('lxr-oil-corp:client:syncOilWells', -1, OilWells)
    Framework.Notify(src, L('repair_complete'), 'success')
    
    -- Track expense
    TriggerEvent('lxr-oil-corp:server:trackIncome', identifier, 'repair', -cost, 'Oil well repair')
    
    -- Add XP
    TriggerEvent('lxr-oil-corp:server:addXP', src, Config.XPSystem.OilWellRepaired)
end)

RegisterNetEvent('lxr-oil-corp:server:getOilWellStatus', function(wellId, cb)
    local well = OilWells[wellId]
    if well then
        TriggerClientEvent('lxr-oil-corp:client:showStatus', source, well)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- EVENTS - BARREL MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:server:pickupBarrel', function(barrelId)
    local src = source
    local barrel = Barrels[barrelId]
    
    if barrel then
        -- Remove barrel from world
        Barrels[barrelId] = nil
        
        -- Sync to all clients
        TriggerClientEvent('lxr-oil-corp:client:syncBarrels', -1, Barrels)
        TriggerClientEvent('lxr-oil-corp:client:attachBarrel', src, barrelId)
        Framework.Notify(src, L('barrel_picked_up'), 'success')
    end
end)

RegisterNetEvent('lxr-oil-corp:server:dropBarrel', function(barrelId, coords)
    local src = source
    
    -- Re-add barrel to world
    Barrels[barrelId] = Barrels[barrelId] or {}
    Barrels[barrelId].coords = coords
    
    -- Update database
    MySQL.query.await('UPDATE lxr_oil_barrels SET coords = ? WHERE id = ?', {
        json.encode({x = coords.x, y = coords.y, z = coords.z}),
        barrelId
    })
    
    -- Sync to all clients
    TriggerClientEvent('lxr-oil-corp:client:syncBarrels', -1, Barrels)
    Framework.Notify(src, L('barrel_dropped'), 'success')
end)

RegisterNetEvent('lxr-oil-corp:server:sellBarrels', function(barrelIds)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local count = 0
    local totalPrice = 0
    
    for _, barrelId in pairs(barrelIds) do
        local barrel = Barrels[barrelId]
        if barrel and barrel.owner == identifier then
            -- Delete from database
            MySQL.query.await('DELETE FROM lxr_oil_barrels WHERE id = ?', {barrelId})
            
            -- Remove from memory
            Barrels[barrelId] = nil
            
            count = count + 1
            totalPrice = totalPrice + Config.Barrels.SellPrice
        end
    end
    
    if count > 0 then
        -- Add money to player
        Framework.AddMoney(src, totalPrice)
        
        -- Sync to all clients
        TriggerClientEvent('lxr-oil-corp:client:syncBarrels', -1, Barrels)
        Framework.Notify(src, L('barrels_sold', count, totalPrice), 'success')
        
        -- Track income
        TriggerEvent('lxr-oil-corp:server:trackIncome', identifier, 'barrel_sale', totalPrice, count .. ' barrels sold')
        
        -- Add XP
        TriggerEvent('lxr-oil-corp:server:addXP', src, Config.XPSystem.BarrelSold * count)
        
        -- Update player stats
        MySQL.query.await('UPDATE lxr_oil_player_data SET total_barrels_sold = total_barrels_sold + ?, total_income = total_income + ? WHERE player = ?', {
            count,
            totalPrice,
            identifier
        })
    else
        Framework.Notify(src, L('no_barrels_to_sell'), 'error')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- CALLBACKS
-- ═══════════════════════════════════════════════════════════════════════════════

lib.callback.register('lxr-oil-corp:server:getOilWells', function(source)
    return OilWells
end)

lib.callback.register('lxr-oil-corp:server:getBarrels', function(source)
    return Barrels
end)

lib.callback.register('lxr-oil-corp:server:getPlayerBarrels', function(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return {} end
    
    local playerBarrels = {}
    for barrelId, barrel in pairs(Barrels) do
        if barrel.owner == identifier then
            playerBarrels[barrelId] = barrel
        end
    end
    
    return playerBarrels
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- XP & INCOME TRACKING
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:server:addXP', function(source, amount)
    if not Config.XPSystem.Enabled then return end
    
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return end
    
    -- Update XP in database
    MySQL.query.await([[
        INSERT INTO lxr_oil_player_data (player, xp, level) 
        VALUES (?, ?, 0) 
        ON DUPLICATE KEY UPDATE xp = xp + ?
    ]], {identifier, amount, amount})
    
    -- Check for level up (simple: 100 XP per level)
    local result = MySQL.query.await('SELECT xp, level FROM lxr_oil_player_data WHERE player = ?', {identifier})
    if result and result[1] then
        local newLevel = math.floor(result[1].xp / 100)
        if newLevel > result[1].level then
            MySQL.query.await('UPDATE lxr_oil_player_data SET level = ? WHERE player = ?', {newLevel, identifier})
            TriggerClientEvent('lxr-oil-corp:client:levelUp', source, newLevel)
        end
    end
end)

RegisterNetEvent('lxr-oil-corp:server:trackIncome', function(identifier, type, amount, description)
    if not Config.IncomeTracking.Enabled then return end
    
    MySQL.insert.await('INSERT INTO lxr_oil_income (owner, transaction_type, amount, description) VALUES (?, ?, ?, ?)', {
        identifier,
        type,
        amount,
        description
    })
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    LoadOilWells()
    LoadBarrels()
    
    print([[
        ^2
        ╔═══════════════════════════════════════════════════════════════════════════════╗
        ║                                                                               ║
        ║                     🐺 LXR OIL CORPORATION SYSTEM 🐺                         ║
        ║                                                                               ║
        ║                          Server-Side Initialized                              ║
        ║                                                                               ║
        ╚═══════════════════════════════════════════════════════════════════════════════╝
        ^7
    ]])
end)

-- Sync data to player on join
AddEventHandler('playerJoined', function()
    local src = source
    TriggerClientEvent('lxr-oil-corp:client:syncOilWells', src, OilWells)
    TriggerClientEvent('lxr-oil-corp:client:syncBarrels', src, Barrels)
end)

-- Export functions
exports('GetOilWells', function() return OilWells end)
exports('GetBarrels', function() return Barrels end)
