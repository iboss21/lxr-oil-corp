-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - DATABASE UTILITIES
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- DATABASE CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    local tables = {
        'lxr_oil_wells',
        'lxr_oil_barrels',
        'lxr_oil_businesses',
        'lxr_oil_workers',
        'lxr_oil_income',
        'lxr_oil_missions',
        'lxr_oil_player_data'
    }
    
    print('^3[LXR Oil Corp]^7 Checking database tables...')
    
    for _, tableName in pairs(tables) do
        local result = MySQL.scalar.await('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?', {tableName})
        
        if result and result > 0 then
            print('^2[LXR Oil Corp]^7 Table ^3' .. tableName .. '^7 exists')
        else
            print('^1[LXR Oil Corp]^7 Table ^3' .. tableName .. '^1 does NOT exist! Please run lxr_oil_corp.sql^7')
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYER DATA FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function CreatePlayerData(identifier)
    MySQL.insert.await([[
        INSERT INTO lxr_oil_player_data (player, xp, level)
        VALUES (?, 0, 0)
        ON DUPLICATE KEY UPDATE player = player
    ]], {identifier})
end

function GetPlayerData(identifier)
    local result = MySQL.query.await('SELECT * FROM lxr_oil_player_data WHERE player = ?', {identifier})
    if result and result[1] then
        return result[1]
    end
    
    -- Create if doesn't exist
    CreatePlayerData(identifier)
    return {
        player = identifier,
        xp = 0,
        level = 0,
        total_barrels_sold = 0,
        total_income = 0,
        total_missions = 0
    }
end

function GetPlayerBusiness(identifier)
    local result = MySQL.query.await('SELECT * FROM lxr_oil_businesses WHERE owner = ?', {identifier})
    if result and result[1] then
        return result[1]
    end
    return nil
end

function CreatePlayerBusiness(identifier, businessType)
    local result = MySQL.insert.await([[
        INSERT INTO lxr_oil_businesses (owner, business_type, business_name)
        VALUES (?, ?, ?)
    ]], {
        identifier,
        businessType or 'personal',
        'Oil Business'
    })
    
    return result
end

function GetBusinessWorkers(businessId)
    local result = MySQL.query.await('SELECT * FROM lxr_oil_workers WHERE business_id = ?', {businessId})
    return result or {}
end

function GetPlayerIncome(identifier, period)
    local query = 'SELECT * FROM lxr_oil_income WHERE owner = ?'
    local params = {identifier}
    
    if period == 'daily' then
        query = query .. ' AND created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)'
    elseif period == 'weekly' then
        query = query .. ' AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)'
    elseif period == 'monthly' then
        query = query .. ' AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)'
    end
    
    query = query .. ' ORDER BY created_at DESC'
    
    local result = MySQL.query.await(query, params)
    return result or {}
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

exports('GetPlayerData', GetPlayerData)
exports('GetPlayerBusiness', GetPlayerBusiness)
exports('CreatePlayerBusiness', CreatePlayerBusiness)
exports('GetBusinessWorkers', GetBusinessWorkers)
exports('GetPlayerIncome', GetPlayerIncome)
