-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - MISSIONS SYSTEM (SERVER)
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

if not Config.Missions.Enabled then
    return
end

local ActiveMissions = {}

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISSION FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

lib.callback.register('lxr-oil-corp:server:getAvailableMissions', function(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return {} end
    
    -- Check if player has active mission
    if ActiveMissions[identifier] then
        return {}
    end
    
    -- Return all mission types
    local missions = {}
    for missionType, missionConfig in pairs(Config.Missions.Types) do
        table.insert(missions, {
            type = missionType,
            name = missionConfig.name,
            description = missionConfig.description,
            reward = missionConfig.reward,
            xp = missionConfig.xp,
            requiredWagon = missionConfig.requiredWagon
        })
    end
    
    return missions
end)

RegisterNetEvent('lxr-oil-corp:server:acceptMission', function(missionType)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    -- Check if already has active mission
    if ActiveMissions[identifier] then
        Framework.Notify(src, L('mission_active'), 'error')
        return
    end
    
    local missionConfig = Config.Missions.Types[missionType]
    if not missionConfig then
        Framework.Notify(src, L('error_occurred'), 'error')
        return
    end
    
    -- Generate mission data
    local reward = math.random(missionConfig.reward.min, missionConfig.reward.max)
    local expiresAt = os.time() + (missionConfig.timeLimit / 1000)
    
    -- Insert into database
    local result = MySQL.insert.await([[
        INSERT INTO lxr_oil_missions (player, mission_type, status, reward, xp, expires_at)
        VALUES (?, ?, 'active', ?, ?, FROM_UNIXTIME(?))
    ]], {
        identifier,
        missionType,
        reward,
        missionConfig.xp,
        expiresAt
    })
    
    if result then
        ActiveMissions[identifier] = {
            id = result,
            type = missionType,
            reward = reward,
            xp = missionConfig.xp,
            expiresAt = expiresAt,
            config = missionConfig
        }
        
        TriggerClientEvent('lxr-oil-corp:client:startMission', src, ActiveMissions[identifier])
        Framework.Notify(src, L('mission_accepted', missionConfig.name), 'success')
    end
end)

RegisterNetEvent('lxr-oil-corp:server:completeMission', function(missionId)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local mission = ActiveMissions[identifier]
    if not mission or mission.id ~= missionId then
        Framework.Notify(src, L('error_occurred'), 'error')
        return
    end
    
    -- Check if expired
    if os.time() > mission.expiresAt then
        Framework.Notify(src, L('mission_failed'), 'error')
        MySQL.query.await('UPDATE lxr_oil_missions SET status = ?, completed_at = NOW() WHERE id = ?', {
            'failed',
            missionId
        })
        ActiveMissions[identifier] = nil
        return
    end
    
    -- Give rewards
    Framework.AddMoney(src, mission.reward)
    TriggerEvent('lxr-oil-corp:server:addXP', src, mission.xp)
    
    -- Update database
    MySQL.query.await('UPDATE lxr_oil_missions SET status = ?, progress = 100, completed_at = NOW() WHERE id = ?', {
        'completed',
        missionId
    })
    
    -- Update player stats
    MySQL.query.await('UPDATE lxr_oil_player_data SET total_missions = total_missions + 1, last_mission = NOW() WHERE player = ?', {
        identifier
    })
    
    -- Track income
    TriggerEvent('lxr-oil-corp:server:trackIncome', identifier, 'mission', mission.reward, 'Mission: ' .. mission.config.name)
    
    Framework.Notify(src, L('mission_completed', mission.reward), 'success')
    ActiveMissions[identifier] = nil
    
    TriggerClientEvent('lxr-oil-corp:client:missionCompleted', src)
end)

RegisterNetEvent('lxr-oil-corp:server:failMission', function(missionId)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return end
    
    local mission = ActiveMissions[identifier]
    if not mission or mission.id ~= missionId then
        return
    end
    
    -- Update database
    MySQL.query.await('UPDATE lxr_oil_missions SET status = ?, completed_at = NOW() WHERE id = ?', {
        'failed',
        missionId
    })
    
    Framework.Notify(src, L('mission_failed'), 'error')
    ActiveMissions[identifier] = nil
    
    TriggerClientEvent('lxr-oil-corp:client:missionFailed', src)
end)

lib.callback.register('lxr-oil-corp:server:getActiveMission', function(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return nil end
    
    return ActiveMissions[identifier]
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISSION EXPIRY CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    while true do
        Wait(60000) -- Check every minute
        
        for identifier, mission in pairs(ActiveMissions) do
            if os.time() > mission.expiresAt then
                -- Mission expired
                MySQL.query.await('UPDATE lxr_oil_missions SET status = ?, completed_at = NOW() WHERE id = ?', {
                    'failed',
                    mission.id
                })
                
                ActiveMissions[identifier] = nil
            end
        end
    end
end)
