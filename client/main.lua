-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - CLIENT MAIN
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerLoaded = false
local OilWells = {}
local Barrels = {}
local CarryingBarrel = false
local CarriedBarrelId = nil
local CarriedBarrelProp = nil

-- ═══════════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
    end
end

local function LoadModel(model)
    local hash = GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(10)
        end
    end
    return hash
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:client:syncOilWells', function(wells)
    OilWells = wells
    TriggerEvent('lxr-oil-corp:client:updateBlips')
    TriggerEvent('lxr-oil-corp:client:updateTargets')
end)

RegisterNetEvent('lxr-oil-corp:client:syncBarrels', function(barrels)
    Barrels = barrels
    TriggerEvent('lxr-oil-corp:client:updateBarrelTargets')
end)

RegisterNetEvent('lxr-oil-corp:client:notify', function(message, type, duration)
    Framework.Notify(nil, message, type, duration)
end)

RegisterNetEvent('lxr-oil-corp:client:showStatus', function(well)
    local statusText = string.format(
        '%s\n%s\n%s: %d%%\n%s: %d / %d',
        L('oil_well_info', well.id),
        L('owner', well.owner),
        L('quality'),
        well.quality,
        L('coal_amount'),
        well.coal,
        Config.OilWells.MaxCoal
    )
    
    lib.notify({
        title = L('check_status'),
        description = statusText,
        type = 'info',
        duration = 7000
    })
end)

RegisterNetEvent('lxr-oil-corp:client:levelUp', function(newLevel)
    lib.notify({
        title = 'Level Up!',
        description = 'You reached level ' .. newLevel .. '!',
        type = 'success',
        duration = 5000
    })
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- OIL WELL PLACEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

function PlaceOilWell()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Play animation
    LoadAnimDict(Config.OilWells.PlacementAnimation.dict)
    TaskPlayAnim(playerPed, Config.OilWells.PlacementAnimation.dict, Config.OilWells.PlacementAnimation.anim, 8.0, -8.0, -1, Config.OilWells.PlacementAnimation.flag, 0, false, false, false)
    
    -- Progress bar
    if lib.progressBar({
        duration = Config.OilWells.PlacementTime,
        label = L('placing_oil_well'),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    }) then
        ClearPedTasks(playerPed)
        TriggerServerEvent('lxr-oil-corp:server:placeOilWell', coords, heading)
    else
        ClearPedTasks(playerPed)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- OIL WELL INTERACTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function OpenOilWellMenu(wellId)
    local well = OilWells[wellId]
    if not well then return end
    
    local options = {
        {
            title = L('check_status'),
            description = string.format('%s: %d%% | %s: %d', L('quality'), well.quality, L('coal_amount'), well.coal),
            icon = 'fa-solid fa-info-circle',
            onSelect = function()
                TriggerServerEvent('lxr-oil-corp:server:getOilWellStatus', wellId)
            end
        },
        {
            title = L('add_coal'),
            description = 'Add ' .. Config.OilWells.CoalPerAddition .. ' coal',
            icon = 'fa-solid fa-fire',
            onSelect = function()
                TriggerServerEvent('lxr-oil-corp:server:addCoal', wellId)
            end
        },
        {
            title = L('repair_oil_well'),
            description = string.format('Repair to 100%% (Cost: $%d)', math.ceil((100 - well.quality) * Config.OilWells.RepairCost)),
            icon = 'fa-solid fa-wrench',
            disabled = well.quality >= 100,
            onSelect = function()
                RepairOilWell(wellId)
            end
        },
        {
            title = L('destroy_oil_well'),
            description = 'Remove this oil well',
            icon = 'fa-solid fa-trash',
            onSelect = function()
                local alert = lib.alertDialog({
                    header = L('confirm_destroy'),
                    content = 'This action cannot be undone!',
                    centered = true,
                    cancel = true
                })
                
                if alert == 'confirm' then
                    DestroyOilWell(wellId)
                end
            end
        }
    }
    
    lib.registerContext({
        id = 'oil_well_menu',
        title = L('interact_oil_well'),
        options = options
    })
    
    lib.showContext('oil_well_menu')
end

function RepairOilWell(wellId)
    local playerPed = PlayerPedId()
    local well = OilWells[wellId]
    if not well then return end
    
    -- Play animation
    LoadAnimDict(Config.OilWells.RepairAnimation.dict)
    TaskPlayAnim(playerPed, Config.OilWells.RepairAnimation.dict, Config.OilWells.RepairAnimation.anim, 8.0, -8.0, -1, Config.OilWells.RepairAnimation.flag, 0, false, false, false)
    
    -- Progress bar
    if lib.progressBar({
        duration = Config.OilWells.RepairTime,
        label = L('repairing'),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    }) then
        ClearPedTasks(playerPed)
        TriggerServerEvent('lxr-oil-corp:server:repairOilWell', wellId)
    else
        ClearPedTasks(playerPed)
    end
end

function DestroyOilWell(wellId)
    local playerPed = PlayerPedId()
    
    -- Progress bar
    if lib.progressBar({
        duration = 5000,
        label = 'Destroying oil well...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    }) then
        TriggerServerEvent('lxr-oil-corp:server:destroyOilWell', wellId)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ITEMS
-- ═══════════════════════════════════════════════════════════════════════════════

exports('UseOilWell', function()
    PlaceOilWell()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMANDS (DEBUG)
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.EnableDebug then
    RegisterCommand('placeoil', function()
        PlaceOilWell()
    end)
    
    RegisterCommand('debugoil', function()
        print('Oil Wells:', json.encode(OilWells, {indent = true}))
        print('Barrels:', json.encode(Barrels, {indent = true}))
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    -- Load animation dictionaries
    for _, dict in pairs(Config.Animations.Dictionaries) do
        LoadAnimDict(dict)
    end
    
    -- Request data from server
    Wait(2000)
    TriggerServerEvent('playerJoined')
    
    PlayerLoaded = true
    
    print('^2[LXR Oil Corp]^7 Client initialized')
end)

-- Framework player loaded events
if Config.Framework ~= 'standalone' then
    local frameworkSettings = Config.FrameworkSettings[Framework.Type]
    if frameworkSettings then
        RegisterNetEvent(frameworkSettings.playerLoaded, function()
            PlayerLoaded = true
        end)
        
        RegisterNetEvent(frameworkSettings.playerUnloaded, function()
            PlayerLoaded = false
        end)
    end
end
