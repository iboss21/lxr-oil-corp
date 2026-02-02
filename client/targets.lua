-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - TARGETS (CLIENT)
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

local OilWellTargets = {}
local OilWellProps = {}

-- ═══════════════════════════════════════════════════════════════════════════════
-- DETECT TARGET SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local function GetTargetSystem()
    if Config.Target.System ~= 'auto' then
        return Config.Target.System
    end
    
    if GetResourceState('rsg-target') == 'started' then
        return 'rsg-target'
    elseif GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        return 'qb-target'
    end
    
    return 'none'
end

local TargetSystem = GetTargetSystem()

-- ═══════════════════════════════════════════════════════════════════════════════
-- OIL WELL TARGETS
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateOilWellProp(well)
    local propHash = GetHashKey(Config.OilWells.OilWellProp)
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Wait(10)
    end
    
    local prop = CreateObject(propHash, well.coords.x, well.coords.y, well.coords.z, false, false, false)
    SetEntityHeading(prop, well.heading)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop, true, true)
    
    return prop
end

RegisterNetEvent('lxr-oil-corp:client:updateTargets', function()
    -- Remove old targets and props
    for wellId, _ in pairs(OilWellTargets) do
        if TargetSystem == 'rsg-target' then
            exports['rsg-target']:RemoveZone('oilwell_' .. wellId)
        elseif TargetSystem == 'ox_target' then
            exports.ox_target:removeZone('oilwell_' .. wellId)
        end
        
        if OilWellProps[wellId] and DoesEntityExist(OilWellProps[wellId]) then
            DeleteObject(OilWellProps[wellId])
        end
    end
    OilWellTargets = {}
    OilWellProps = {}
    
    -- Get oil wells
    local wells = exports['lxr-oil-corp']:GetOilWellsClient()
    if not wells then return end
    
    -- Create new targets and props
    for wellId, well in pairs(wells) do
        -- Create prop
        local prop = CreateOilWellProp(well)
        OilWellProps[wellId] = prop
        
        -- Create target
        if TargetSystem == 'rsg-target' then
            exports['rsg-target']:AddCircleZone('oilwell_' .. wellId, well.coords, 2.0, {
                name = 'oilwell_' .. wellId,
                debugPoly = Config.Target.DebugZones
            }, {
                options = {
                    {
                        label = L('interact_oil_well'),
                        icon = 'fa-solid fa-oil-well',
                        action = function()
                            OpenOilWellMenu(wellId)
                        end
                    }
                },
                distance = Config.Target.Distance
            })
        elseif TargetSystem == 'ox_target' then
            exports.ox_target:addSphereZone({
                coords = well.coords,
                radius = 2.0,
                debug = Config.Target.DebugZones,
                options = {
                    {
                        name = 'oilwell_' .. wellId,
                        label = L('interact_oil_well'),
                        icon = 'fa-solid fa-oil-well',
                        onSelect = function()
                            OpenOilWellMenu(wellId)
                        end,
                        distance = Config.Target.Distance
                    }
                }
            })
        end
        
        OilWellTargets[wellId] = true
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUSINESS OFFICE TARGETS
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Business.Enabled then
    CreateThread(function()
        Wait(2000)
        
        for idx, office in pairs(Config.Business.BusinessOffices) do
            -- Spawn NPC (optional)
            -- You can add NPC spawning here if needed
            
            if TargetSystem == 'rsg-target' then
                exports['rsg-target']:AddCircleZone('business_office_' .. idx, office.coords, 2.0, {
                    name = 'business_office_' .. idx,
                    debugPoly = Config.Target.DebugZones
                }, {
                    options = {
                        {
                            label = L('open_business_menu'),
                            icon = 'fa-solid fa-briefcase',
                            action = function()
                                TriggerEvent('lxr-oil-corp:client:openBusinessMenu')
                            end
                        }
                    },
                    distance = Config.Target.Distance
                })
            elseif TargetSystem == 'ox_target' then
                exports.ox_target:addSphereZone({
                    coords = office.coords,
                    radius = 2.0,
                    debug = Config.Target.DebugZones,
                    options = {
                        {
                            name = 'business_office_' .. idx,
                            label = L('open_business_menu'),
                            icon = 'fa-solid fa-briefcase',
                            onSelect = function()
                                TriggerEvent('lxr-oil-corp:client:openBusinessMenu')
                            end,
                            distance = Config.Target.Distance
                        }
                    }
                })
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SELLING LOCATION TARGETS
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(2000)
    
    for idx, location in pairs(Config.SellingLocations) do
        -- Spawn NPC
        local pedHash = GetHashKey(location.ped)
        RequestModel(pedHash)
        while not HasModelLoaded(pedHash) do
            Wait(10)
        end
        
        local ped = CreatePed(pedHash, location.coords.x, location.coords.y, location.coords.z, location.heading, false, false, false, false)
        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        if TargetSystem == 'rsg-target' then
            exports['rsg-target']:AddTargetEntity(ped, {
                options = {
                    {
                        label = L('sell_barrels'),
                        icon = 'fa-solid fa-dollar-sign',
                        action = function()
                            TriggerEvent('lxr-oil-corp:client:openSellMenu')
                        end
                    }
                },
                distance = Config.Target.Distance
            })
        elseif TargetSystem == 'ox_target' then
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'sell_barrels_' .. idx,
                    label = L('sell_barrels'),
                    icon = 'fa-solid fa-dollar-sign',
                    onSelect = function()
                        TriggerEvent('lxr-oil-corp:client:openSellMenu')
                    end,
                    distance = Config.Target.Distance
                }
            })
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISSION GIVER TARGETS
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Missions.Enabled then
    CreateThread(function()
        Wait(2000)
        
        for idx, giver in pairs(Config.Missions.MissionGivers) do
            -- Spawn NPC
            local pedHash = GetHashKey(giver.ped)
            RequestModel(pedHash)
            while not HasModelLoaded(pedHash) do
                Wait(10)
            end
            
            local ped = CreatePed(pedHash, giver.coords.x, giver.coords.y, giver.coords.z, giver.heading, false, false, false, false)
            SetEntityAsMissionEntity(ped, true, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            
            if TargetSystem == 'rsg-target' then
                exports['rsg-target']:AddTargetEntity(ped, {
                    options = {
                        {
                            label = L('accept_mission'),
                            icon = 'fa-solid fa-clipboard',
                            action = function()
                                TriggerEvent('lxr-oil-corp:client:openMissionMenu')
                            end
                        }
                    },
                    distance = Config.Target.Distance
                })
            elseif TargetSystem == 'ox_target' then
                exports.ox_target:addLocalEntity(ped, {
                    {
                        name = 'mission_giver_' .. idx,
                        label = L('accept_mission'),
                        icon = 'fa-solid fa-clipboard',
                        onSelect = function()
                            TriggerEvent('lxr-oil-corp:client:openMissionMenu')
                        end,
                        distance = Config.Target.Distance
                    }
                })
            end
        end
    end)
end
