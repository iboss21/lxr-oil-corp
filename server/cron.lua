-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - CRON JOB SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

if not Config.CronJob.Enabled then
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- CRON JOB FUNCTION
-- ═══════════════════════════════════════════════════════════════════════════════

local function ProcessOilWells()
    local OilWells = exports['lxr-oil-corp']:GetOilWells()
    local Barrels = exports['lxr-oil-corp']:GetBarrels()
    
    print('^3[LXR Oil Corp]^7 Running cron job...')
    
    local wellsRemoved = 0
    local barrelsProduced = 0
    local wellsToRemove = {}
    
    for wellId, well in pairs(OilWells) do
        -- Degrade quality
        well.quality = math.max(0, well.quality - Config.OilWells.QualityDegradationRate)
        
        -- If quality is 0, mark for removal
        if well.quality <= 0 then
            table.insert(wellsToRemove, wellId)
            wellsRemoved = wellsRemoved + 1
        else
            -- If has coal and quality > 0, attempt production
            if well.coal > 0 and well.quality >= Config.OilWells.MinQualityForProduction then
                -- Consume coal
                well.coal = math.max(0, well.coal - Config.OilWells.CoalRequiredForProduction)
                
                -- Check production chance
                if math.random() <= Config.Barrels.ProductionChance then
                    -- Count existing barrels for this well
                    local barrelCount = 0
                    for _, barrel in pairs(Barrels) do
                        if barrel.oil_well_id == wellId then
                            barrelCount = barrelCount + 1
                        end
                    end
                    
                    -- Only produce if below max
                    if barrelCount < Config.Barrels.MaxBarrelsPerWell then
                        -- Random spawn offset
                        local offset = Config.Barrels.SpawnOffsets[math.random(#Config.Barrels.SpawnOffsets)]
                        local barrelCoords = vector3(
                            well.coords.x + offset.x,
                            well.coords.y + offset.y,
                            well.coords.z + offset.z
                        )
                        
                        -- Insert barrel into database
                        local result = MySQL.insert.await('INSERT INTO lxr_oil_barrels (oil_well_id, owner, coords) VALUES (?, ?, ?)', {
                            wellId,
                            well.owner,
                            json.encode({x = barrelCoords.x, y = barrelCoords.y, z = barrelCoords.z})
                        })
                        
                        if result then
                            barrelsProduced = barrelsProduced + 1
                            
                            -- Add XP to owner if online
                            TriggerEvent('lxr-oil-corp:server:addXPToPlayer', well.owner, Config.XPSystem.BarrelProduction)
                        end
                    end
                end
                
                -- Update well in database
                MySQL.query.await('UPDATE lxr_oil_wells SET quality = ?, coal = ?, last_production = NOW() WHERE id = ?', {
                    well.quality,
                    well.coal,
                    wellId
                })
            else
                -- Just update quality
                MySQL.query.await('UPDATE lxr_oil_wells SET quality = ? WHERE id = ?', {
                    well.quality,
                    wellId
                })
            end
        end
    end
    
    -- Remove wells with 0 quality
    for _, wellId in pairs(wellsToRemove) do
        MySQL.query.await('DELETE FROM lxr_oil_wells WHERE id = ?', {wellId})
    end
    
    print(string.format('^2[LXR Oil Corp]^7 Cron complete: %s barrels produced, %s wells removed', barrelsProduced, wellsRemoved))
    
    -- Reload data and sync to all clients
    Wait(1000)
    ExecuteCommand('lxr-oil-corp:reload')
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- CRON JOB THREAD
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(5000) -- Wait for server to fully start
    
    print('^2[LXR Oil Corp]^7 Cron job system started (Interval: ' .. (Config.CronJob.Interval / 60000) .. ' minutes)')
    
    while true do
        Wait(Config.CronJob.Interval)
        ProcessOilWells()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MANUAL CRON TRIGGER (for testing)
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterCommand('oilcorp:runcron', function(source, args)
    if source == 0 then -- Console only
        ProcessOilWells()
    end
end, true)
