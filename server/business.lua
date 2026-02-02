-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - BUSINESS MANAGEMENT (SERVER)
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

if not Config.Business.Enabled then
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUSINESS MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

lib.callback.register('lxr-oil-corp:server:getBusinessInfo', function(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return nil end
    
    local business = exports['lxr-oil-corp']:GetPlayerBusiness(identifier)
    if not business then
        -- Create default personal business
        local businessId = exports['lxr-oil-corp']:CreatePlayerBusiness(identifier, 'personal')
        business = exports['lxr-oil-corp']:GetPlayerBusiness(identifier)
    end
    
    -- Get workers
    local workers = exports['lxr-oil-corp']:GetBusinessWorkers(business.id)
    
    return {
        business = business,
        workers = workers,
        config = Config.Business.Types[business.business_type]
    }
end)

RegisterNetEvent('lxr-oil-corp:server:upgradeBusiness', function(businessType)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local business = exports['lxr-oil-corp']:GetPlayerBusiness(identifier)
    if not business then
        Framework.Notify(src, L('error_occurred'), 'error')
        return
    end
    
    local targetType = Config.Business.Types[businessType]
    if not targetType then
        Framework.Notify(src, L('error_occurred'), 'error')
        return
    end
    
    -- Check if player can afford
    local playerMoney = Framework.GetPlayerMoney(src)
    if playerMoney < targetType.upgradeCost then
        Framework.Notify(src, L('cannot_afford_repair'), 'error')
        return
    end
    
    -- Remove money
    Framework.RemoveMoney(src, targetType.upgradeCost)
    
    -- Upgrade business
    MySQL.query.await('UPDATE lxr_oil_businesses SET business_type = ? WHERE id = ?', {
        businessType,
        business.id
    })
    
    Framework.Notify(src, L('business_upgraded', targetType.name), 'success')
    
    -- Track expense
    TriggerEvent('lxr-oil-corp:server:trackIncome', identifier, 'business_upgrade', -targetType.upgradeCost, 'Upgraded to ' .. targetType.name)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- WORKER MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:server:hireWorker', function(workerType)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local business = exports['lxr-oil-corp']:GetPlayerBusiness(identifier)
    if not business then
        Framework.Notify(src, L('error_occurred'), 'error')
        return
    end
    
    local businessConfig = Config.Business.Types[business.business_type]
    local workers = exports['lxr-oil-corp']:GetBusinessWorkers(business.id)
    
    -- Check max workers
    if #workers >= businessConfig.maxWorkers then
        Framework.Notify(src, L('max_workers'), 'error')
        return
    end
    
    -- Check if can afford
    local playerMoney = Framework.GetPlayerMoney(src)
    if playerMoney < Config.Workers.HireCost then
        Framework.Notify(src, L('cannot_afford_repair'), 'error')
        return
    end
    
    -- Remove money
    Framework.RemoveMoney(src, Config.Workers.HireCost)
    
    -- Find worker type config
    local workerConfig = nil
    for _, wType in pairs(Config.Workers.Types) do
        if wType.name == workerType then
            workerConfig = wType
            break
        end
    end
    
    if not workerConfig then
        workerConfig = Config.Workers.Types[1] -- Default to first type
    end
    
    -- Hire worker
    MySQL.insert.await([[
        INSERT INTO lxr_oil_workers (business_id, worker_name, worker_type, salary)
        VALUES (?, ?, ?, ?)
    ]], {
        business.id,
        'Worker #' .. (#workers + 1),
        workerConfig.name,
        workerConfig.salary
    })
    
    Framework.Notify(src, L('worker_hired', workerConfig.name), 'success')
    
    -- Track expense
    TriggerEvent('lxr-oil-corp:server:trackIncome', identifier, 'worker_hire', -Config.Workers.HireCost, 'Hired ' .. workerConfig.name)
end)

RegisterNetEvent('lxr-oil-corp:server:fireWorker', function(workerId)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local business = exports['lxr-oil-corp']:GetPlayerBusiness(identifier)
    if not business then
        Framework.Notify(src, L('error_occurred'), 'error')
        return
    end
    
    -- Fire worker
    MySQL.query.await('DELETE FROM lxr_oil_workers WHERE id = ? AND business_id = ?', {
        workerId,
        business.id
    })
    
    Framework.Notify(src, L('worker_fired', 'Worker'), 'success')
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- RENT SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Business.RentSystem.Enabled then
    RegisterNetEvent('lxr-oil-corp:server:payRent', function()
        local src = source
        local identifier = Framework.GetPlayerIdentifier(src)
        if not identifier then return end
        
        local business = exports['lxr-oil-corp']:GetPlayerBusiness(identifier)
        if not business or business.business_type == 'personal' then
            Framework.Notify(src, L('error_occurred'), 'error')
            return
        end
        
        -- Check if can afford
        local playerMoney = Framework.GetPlayerMoney(src)
        if playerMoney < Config.Business.RentSystem.RentCost then
            Framework.Notify(src, L('cannot_afford_repair'), 'error')
            return
        end
        
        -- Remove money
        Framework.RemoveMoney(src, Config.Business.RentSystem.RentCost)
        
        -- Calculate new rent_paid_until
        local currentTime = os.time()
        local rentPaidUntil = business.rent_paid_until and os.time(business.rent_paid_until) or currentTime
        local newRentPaidUntil = math.max(currentTime, rentPaidUntil) + (Config.Business.RentSystem.RentPeriod / 1000)
        
        -- Update database
        MySQL.query.await('UPDATE lxr_oil_businesses SET rent_paid_until = FROM_UNIXTIME(?) WHERE id = ?', {
            newRentPaidUntil,
            business.id
        })
        
        Framework.Notify(src, L('rent_paid', os.date('%Y-%m-%d %H:%M', newRentPaidUntil)), 'success')
        
        -- Track expense
        TriggerEvent('lxr-oil-corp:server:trackIncome', identifier, 'rent', -Config.Business.RentSystem.RentCost, 'Rent payment')
    end)
end
