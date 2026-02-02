-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - BUSINESS (CLIENT)
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

if not Config.Business.Enabled then
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUSINESS MENU
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:client:openBusinessMenu', function()
    lib.callback('lxr-oil-corp:server:getBusinessInfo', false, function(info)
        if not info then
            Framework.Notify(nil, L('error_occurred'), 'error')
            return
        end
        
        local options = {
            {
                title = 'Business Information',
                description = string.format('Type: %s | Workers: %d/%d', 
                    info.config.name,
                    #info.workers,
                    info.config.maxWorkers
                ),
                icon = 'fa-solid fa-info-circle',
                disabled = true
            },
            {
                title = L('upgrade_business'),
                description = 'Upgrade your business to unlock more features',
                icon = 'fa-solid fa-arrow-up',
                onSelect = function()
                    OpenUpgradeMenu(info)
                end
            },
            {
                title = L('manage_workers'),
                description = string.format('Workers: %d/%d', #info.workers, info.config.maxWorkers),
                icon = 'fa-solid fa-users',
                onSelect = function()
                    OpenWorkersMenu(info)
                end
            },
            {
                title = L('view_income'),
                description = 'View your income statistics',
                icon = 'fa-solid fa-chart-line',
                onSelect = function()
                    OpenIncomeMenu()
                end
            }
        }
        
        if Config.Business.RentSystem.Enabled and info.business.business_type ~= 'personal' then
            table.insert(options, {
                title = L('pay_rent'),
                description = string.format('Cost: $%d', Config.Business.RentSystem.RentCost),
                icon = 'fa-solid fa-money-bill',
                onSelect = function()
                    TriggerServerEvent('lxr-oil-corp:server:payRent')
                end
            })
        end
        
        lib.registerContext({
            id = 'business_menu',
            title = L('open_business_menu'),
            options = options
        })
        
        lib.showContext('business_menu')
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- UPGRADE MENU
-- ═══════════════════════════════════════════════════════════════════════════════

function OpenUpgradeMenu(info)
    local options = {}
    
    for businessType, config in pairs(Config.Business.Types) do
        if businessType ~= info.business.business_type then
            table.insert(options, {
                title = config.name,
                description = string.format('Cost: $%d | Max Oil Wells: %d | Max Workers: %d',
                    config.upgradeCost,
                    config.maxOilWells,
                    config.maxWorkers
                ),
                icon = 'fa-solid fa-building',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Upgrade Business',
                        content = string.format('Upgrade to %s for $%d?', config.name, config.upgradeCost),
                        centered = true,
                        cancel = true
                    })
                    
                    if alert == 'confirm' then
                        TriggerServerEvent('lxr-oil-corp:server:upgradeBusiness', businessType)
                    end
                end
            })
        end
    end
    
    lib.registerContext({
        id = 'upgrade_menu',
        title = L('upgrade_business'),
        menu = 'business_menu',
        options = options
    })
    
    lib.showContext('upgrade_menu')
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- WORKERS MENU
-- ═══════════════════════════════════════════════════════════════════════════════

function OpenWorkersMenu(info)
    local options = {}
    
    -- Add hire option
    if #info.workers < info.config.maxWorkers then
        table.insert(options, {
            title = L('hire_worker'),
            description = string.format('Cost: $%d', Config.Workers.HireCost),
            icon = 'fa-solid fa-user-plus',
            onSelect = function()
                OpenHireMenu()
            end
        })
    end
    
    -- List current workers
    for _, worker in pairs(info.workers) do
        table.insert(options, {
            title = worker.worker_name,
            description = string.format('Type: %s | Salary: $%d', worker.worker_type, worker.salary),
            icon = 'fa-solid fa-user',
            onSelect = function()
                local alert = lib.alertDialog({
                    header = L('confirm_fire'),
                    content = string.format('Fire %s?', worker.worker_name),
                    centered = true,
                    cancel = true
                })
                
                if alert == 'confirm' then
                    TriggerServerEvent('lxr-oil-corp:server:fireWorker', worker.id)
                end
            end
        })
    end
    
    lib.registerContext({
        id = 'workers_menu',
        title = L('manage_workers'),
        menu = 'business_menu',
        options = options
    })
    
    lib.showContext('workers_menu')
end

function OpenHireMenu()
    local options = {}
    
    for _, workerType in pairs(Config.Workers.Types) do
        table.insert(options, {
            title = workerType.name,
            description = string.format('Salary: $%d | Production: +%d%% | Quality: +%d%%',
                workerType.salary,
                workerType.productionBonus * 100,
                workerType.qualityBonus * 100
            ),
            icon = 'fa-solid fa-user',
            onSelect = function()
                TriggerServerEvent('lxr-oil-corp:server:hireWorker', workerType.name)
            end
        })
    end
    
    lib.registerContext({
        id = 'hire_menu',
        title = L('hire_worker'),
        menu = 'workers_menu',
        options = options
    })
    
    lib.showContext('hire_menu')
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INCOME MENU
-- ═══════════════════════════════════════════════════════════════════════════════

function OpenIncomeMenu()
    lib.callback('lxr-oil-corp:server:getIncome', false, function(income)
        local options = {
            {
                title = 'Daily Income',
                description = 'View your income for the past 24 hours',
                icon = 'fa-solid fa-calendar-day',
                disabled = true
            },
            {
                title = 'Weekly Income',
                description = 'View your income for the past week',
                icon = 'fa-solid fa-calendar-week',
                disabled = true
            },
            {
                title = 'Monthly Income',
                description = 'View your income for the past month',
                icon = 'fa-solid fa-calendar',
                disabled = true
            }
        }
        
        lib.registerContext({
            id = 'income_menu',
            title = L('view_income'),
            menu = 'business_menu',
            options = options
        })
        
        lib.showContext('income_menu')
    end)
end
