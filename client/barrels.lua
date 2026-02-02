-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - BARRELS (CLIENT)
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

local BarrelProps = {}
local CarryingBarrel = false
local CarriedBarrelId = nil
local CarriedBarrelProp = nil

-- ═══════════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateBarrelProp(barrel)
    local propHash = GetHashKey(Config.Barrels.BarrelProp)
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Wait(10)
    end
    
    local prop = CreateObject(propHash, barrel.coords.x, barrel.coords.y, barrel.coords.z, false, false, false)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop, true, true)
    
    return prop
end

local function AttachBarrelToPlayer(barrelId)
    local playerPed = PlayerPedId()
    local propHash = GetHashKey(Config.Barrels.CarryProp)
    
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Wait(10)
    end
    
    CarriedBarrelProp = CreateObject(propHash, 0, 0, 0, true, true, false)
    
    local boneIndex = GetEntityBoneIndexByName(playerPed, Config.Barrels.CarryBone)
    AttachEntityToEntity(
        CarriedBarrelProp,
        playerPed,
        boneIndex,
        Config.Barrels.CarryOffset.x,
        Config.Barrels.CarryOffset.y,
        Config.Barrels.CarryOffset.z,
        Config.Barrels.CarryRotation.x,
        Config.Barrels.CarryRotation.y,
        Config.Barrels.CarryRotation.z,
        true, true, false, true, 1, true
    )
    
    CarryingBarrel = true
    CarriedBarrelId = barrelId
end

local function DetachBarrelFromPlayer()
    if CarriedBarrelProp and DoesEntityExist(CarriedBarrelProp) then
        DeleteObject(CarriedBarrelProp)
    end
    
    CarriedBarrelProp = nil
    CarryingBarrel = false
    CarriedBarrelId = nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- BARREL SYNC
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:client:updateBarrelTargets', function()
    -- Remove old props and targets
    for barrelId, prop in pairs(BarrelProps) do
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end
    BarrelProps = {}
    
    -- Get barrels from sync
    local barrels = exports['lxr-oil-corp']:GetBarrelsClient()
    if not barrels then return end
    
    -- Create new props and targets
    local TargetSystem = GetTargetSystem()
    
    for barrelId, barrel in pairs(barrels) do
        local prop = CreateBarrelProp(barrel)
        BarrelProps[barrelId] = prop
        
        -- Add target to prop
        if TargetSystem == 'rsg-target' then
            exports['rsg-target']:AddTargetEntity(prop, {
                options = {
                    {
                        label = L('carry_barrel'),
                        icon = 'fa-solid fa-hand-holding',
                        action = function()
                            PickupBarrel(barrelId)
                        end
                    }
                },
                distance = Config.Barrels.PickupDistance
            })
        elseif TargetSystem == 'ox_target' then
            exports.ox_target:addLocalEntity(prop, {
                {
                    name = 'barrel_' .. barrelId,
                    label = L('carry_barrel'),
                    icon = 'fa-solid fa-hand-holding',
                    onSelect = function()
                        PickupBarrel(barrelId)
                    end,
                    distance = Config.Barrels.PickupDistance
                }
            })
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- BARREL ACTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function PickupBarrel(barrelId)
    if CarryingBarrel then
        Framework.Notify(nil, 'You are already carrying a barrel!', 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    
    -- Play animation
    LoadAnimDict(Config.Barrels.PickupAnimation.dict)
    TaskPlayAnim(playerPed, Config.Barrels.PickupAnimation.dict, Config.Barrels.PickupAnimation.anim, 8.0, -8.0, -1, Config.Barrels.PickupAnimation.flag, 0, false, false, false)
    
    Wait(1000)
    ClearPedTasks(playerPed)
    
    -- Attach barrel to player
    AttachBarrelToPlayer(barrelId)
    
    -- Notify server
    TriggerServerEvent('lxr-oil-corp:server:pickupBarrel', barrelId)
end

function DropBarrel()
    if not CarryingBarrel then
        Framework.Notify(nil, 'You are not carrying a barrel!', 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    local dropCoords = vector3(coords.x + forward.x * 1.5, coords.y + forward.y * 1.5, coords.z)
    
    -- Play animation
    LoadAnimDict(Config.Barrels.DropAnimation.dict)
    TaskPlayAnim(playerPed, Config.Barrels.DropAnimation.dict, Config.Barrels.DropAnimation.anim, 8.0, -8.0, -1, Config.Barrels.DropAnimation.flag, 0, false, false, false)
    
    Wait(1000)
    ClearPedTasks(playerPed)
    
    -- Detach barrel
    DetachBarrelFromPlayer()
    
    -- Notify server
    TriggerServerEvent('lxr-oil-corp:server:dropBarrel', CarriedBarrelId, dropCoords)
end

RegisterNetEvent('lxr-oil-corp:client:attachBarrel', function(barrelId)
    AttachBarrelToPlayer(barrelId)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- SELL MENU
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:client:openSellMenu', function()
    lib.callback('lxr-oil-corp:server:getPlayerBarrels', false, function(playerBarrels)
        if not playerBarrels or not next(playerBarrels) then
            Framework.Notify(nil, L('no_barrels_to_sell'), 'error')
            return
        end
        
        local barrelIds = {}
        for barrelId, _ in pairs(playerBarrels) do
            table.insert(barrelIds, barrelId)
        end
        
        local count = math.min(#barrelIds, Config.Barrels.MaxSellPerTransaction)
        local totalPrice = count * Config.Barrels.SellPrice
        
        local alert = lib.alertDialog({
            header = L('sell_barrels'),
            content = string.format('Sell %d barrels for $%d?', count, totalPrice),
            centered = true,
            cancel = true
        })
        
        if alert == 'confirm' then
            -- Select barrels to sell
            local barrelToSell = {}
            for i = 1, count do
                table.insert(barrelToSell, barrelIds[i])
            end
            
            TriggerServerEvent('lxr-oil-corp:server:sellBarrels', barrelToSell)
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMANDS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterCommand('dropbarrel', function()
    if CarryingBarrel then
        DropBarrel()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEYBINDS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterKeyMapping('dropbarrel', 'Drop Barrel', 'keyboard', 'G')

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

exports('GetBarrelsClient', function()
    return Barrels
end)

exports('IsCarryingBarrel', function()
    return CarryingBarrel
end)

-- Store Barrels locally when synced
local Barrels = {}
RegisterNetEvent('lxr-oil-corp:client:syncBarrels', function(barrels)
    Barrels = barrels
end)

function GetTargetSystem()
    if Config.Target.System ~= 'auto' then
        return Config.Target.System
    end
    
    if GetResourceState('rsg-target') == 'started' then
        return 'rsg-target'
    elseif GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    end
    
    return 'none'
end

function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
    end
end
