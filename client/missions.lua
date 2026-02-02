-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - MISSIONS (CLIENT)
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

if not Config.Missions.Enabled then
    return
end

local ActiveMission = nil

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISSION MENU
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:client:openMissionMenu', function()
    -- Check if already has active mission
    lib.callback('lxr-oil-corp:server:getActiveMission', false, function(mission)
        if mission then
            Framework.Notify(nil, L('mission_active'), 'error')
            return
        end
        
        -- Get available missions
        lib.callback('lxr-oil-corp:server:getAvailableMissions', false, function(missions)
            if not missions or #missions == 0 then
                Framework.Notify(nil, 'No missions available', 'error')
                return
            end
            
            local options = {}
            
            for _, mission in pairs(missions) do
                table.insert(options, {
                    title = mission.name,
                    description = string.format('%s\nReward: $%d-%d | XP: %d%s',
                        mission.description,
                        mission.reward.min,
                        mission.reward.max,
                        mission.xp,
                        mission.requiredWagon and ' | Requires Wagon' or ''
                    ),
                    icon = 'fa-solid fa-clipboard-check',
                    onSelect = function()
                        local alert = lib.alertDialog({
                            header = L('accept_mission'),
                            content = mission.description,
                            centered = true,
                            cancel = true
                        })
                        
                        if alert == 'confirm' then
                            TriggerServerEvent('lxr-oil-corp:server:acceptMission', mission.type)
                        end
                    end
                })
            end
            
            lib.registerContext({
                id = 'mission_menu',
                title = 'Oil Corporation Missions',
                options = options
            })
            
            lib.showContext('mission_menu')
        end)
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISSION HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:client:startMission', function(mission)
    ActiveMission = mission
    
    if mission.type == 'delivery' then
        StartDeliveryMission(mission)
    elseif mission.type == 'exploration' then
        StartExplorationMission(mission)
    elseif mission.type == 'maintenance' then
        StartMaintenanceMission(mission)
    elseif mission.type == 'protection' then
        StartProtectionMission(mission)
    end
end)

RegisterNetEvent('lxr-oil-corp:client:missionCompleted', function()
    ActiveMission = nil
    -- Clean up any mission markers, blips, etc.
end)

RegisterNetEvent('lxr-oil-corp:client:missionFailed', function()
    ActiveMission = nil
    -- Clean up any mission markers, blips, etc.
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISSION TYPES
-- ═══════════════════════════════════════════════════════════════════════════════

function StartDeliveryMission(mission)
    -- Get destination from config
    local destinations = mission.config.destinations
    local destination = destinations[math.random(#destinations)]
    
    -- Check if player has wagon
    if mission.config.requiredWagon then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle == 0 then
            Framework.Notify(nil, 'You need a wagon to start this mission!', 'error')
            TriggerServerEvent('lxr-oil-corp:server:failMission', mission.id)
            return
        end
        
        local vehicleModel = GetEntityModel(vehicle)
        local isWagon = false
        
        for _, wagonModel in pairs(Config.Wagons.AllowedWagons) do
            if vehicleModel == GetHashKey(wagonModel) then
                isWagon = true
                break
            end
        end
        
        if not isWagon then
            Framework.Notify(nil, 'You need a proper wagon for this mission!', 'error')
            TriggerServerEvent('lxr-oil-corp:server:failMission', mission.id)
            return
        end
    end
    
    -- Create delivery blip
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, destination.coords.x, destination.coords.y, destination.coords.z)
    SetBlipSprite(blip, GetHashKey('blip_ambient_quartermaster'), true)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Delivery Location')
    
    Framework.Notify(nil, string.format('Deliver barrels to %s', destination.name), 'info')
    
    -- Mission completion check thread
    CreateThread(function()
        while ActiveMission and ActiveMission.id == mission.id do
            Wait(1000)
            
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - destination.coords)
            
            if distance < 5.0 then
                -- Player reached destination
                RemoveBlip(blip)
                TriggerServerEvent('lxr-oil-corp:server:completeMission', mission.id)
                break
            end
            
            -- Check time limit
            if os.time() > mission.expiresAt then
                RemoveBlip(blip)
                break
            end
        end
    end)
end

function StartExplorationMission(mission)
    Framework.Notify(nil, 'Survey the area for potential oil sites', 'info')
    
    -- Generate random survey points
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    local surveyPoints = {}
    for i = 1, 3 do
        local randomOffset = vector3(
            math.random(-200, 200),
            math.random(-200, 200),
            0
        )
        table.insert(surveyPoints, vector3(
            playerCoords.x + randomOffset.x,
            playerCoords.y + randomOffset.y,
            playerCoords.z
        ))
    end
    
    local currentPoint = 1
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, surveyPoints[currentPoint].x, surveyPoints[currentPoint].y, surveyPoints[currentPoint].z)
    SetBlipSprite(blip, GetHashKey('blip_ambient_herd'), true)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Survey Point')
    
    -- Mission thread
    CreateThread(function()
        while ActiveMission and ActiveMission.id == mission.id and currentPoint <= #surveyPoints do
            Wait(1000)
            
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - surveyPoints[currentPoint])
            
            if distance < 3.0 then
                Framework.Notify(nil, string.format('Survey point %d/%d completed', currentPoint, #surveyPoints), 'success')
                currentPoint = currentPoint + 1
                
                if currentPoint <= #surveyPoints then
                    RemoveBlip(blip)
                    blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, surveyPoints[currentPoint].x, surveyPoints[currentPoint].y, surveyPoints[currentPoint].z)
                    SetBlipSprite(blip, GetHashKey('blip_ambient_herd'), true)
                    Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Survey Point')
                else
                    RemoveBlip(blip)
                    TriggerServerEvent('lxr-oil-corp:server:completeMission', mission.id)
                    break
                end
            end
            
            -- Check time limit
            if os.time() > mission.expiresAt then
                RemoveBlip(blip)
                break
            end
        end
    end)
end

function StartMaintenanceMission(mission)
    Framework.Notify(nil, 'Perform maintenance on oil wells', 'info')
    
    -- Simple completion for now
    Wait(10000)
    
    if ActiveMission and ActiveMission.id == mission.id then
        TriggerServerEvent('lxr-oil-corp:server:completeMission', mission.id)
    end
end

function StartProtectionMission(mission)
    Framework.Notify(nil, 'Defend your oil wells from threats', 'info')
    
    -- Simple completion for now
    Wait(15000)
    
    if ActiveMission and ActiveMission.id == mission.id then
        TriggerServerEvent('lxr-oil-corp:server:completeMission', mission.id)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMANDS (DEBUG)
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.EnableDebug then
    RegisterCommand('completemission', function()
        if ActiveMission then
            TriggerServerEvent('lxr-oil-corp:server:completeMission', ActiveMission.id)
        end
    end)
end
