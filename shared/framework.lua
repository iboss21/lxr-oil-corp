-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - FRAMEWORK BRIDGE
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

Framework = {}
Framework.Core = nil
Framework.Type = nil

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.Detect()
    if Config.Framework ~= 'auto' then
        Framework.Type = Config.Framework
        return
    end
    
    -- Try to detect framework
    if GetResourceState('lxr-core') == 'started' then
        Framework.Type = 'lxrcore'
    elseif GetResourceState('rsg-core') == 'started' then
        Framework.Type = 'rsg-core'
    elseif GetResourceState('qbr-core') == 'started' then
        Framework.Type = 'qbr-core'
    elseif GetResourceState('qr-core') == 'started' then
        Framework.Type = 'qr-core'
    elseif GetResourceState('vorp_core') == 'started' then
        Framework.Type = 'vorp'
    elseif GetResourceState('redem_roleplay') == 'started' then
        Framework.Type = 'redemrp'
    else
        Framework.Type = 'standalone'
    end
    
    print('^3[LXR Oil Corp]^7 Detected Framework: ^2' .. Framework.Type .. '^7')
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.Init()
    Framework.Detect()
    
    if Framework.Type == 'lxrcore' then
        Framework.Core = exports['lxr-core']:GetCoreObject()
    elseif Framework.Type == 'rsg-core' then
        Framework.Core = exports['rsg-core']:GetCoreObject()
    elseif Framework.Type == 'qbr-core' then
        Framework.Core = exports['qbr-core']:GetCoreObject()
    elseif Framework.Type == 'qr-core' then
        Framework.Core = exports['qr-core']:GetCoreObject()
    elseif Framework.Type == 'vorp' then
        Framework.Core = exports['vorp_core']:GetCore()
    elseif Framework.Type == 'redemrp' then
        TriggerEvent('redem:getSharedObject', function(obj) Framework.Core = obj end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.GetPlayer(source)
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        return Framework.Core.Functions.GetPlayer(source)
    elseif Framework.Type == 'vorp' then
        return Framework.Core.getUser(source)
    elseif Framework.Type == 'redemrp' then
        return Framework.Core.GetPlayer(source)
    end
    return nil
end

function Framework.GetPlayerIdentifier(source)
    if Framework.Type == 'standalone' then
        return tostring(GetPlayerIdentifiers(source)[1])
    end
    
    local player = Framework.GetPlayer(source)
    if not player then return nil end
    
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        return player.PlayerData.citizenid
    elseif Framework.Type == 'vorp' then
        return player.getIdentifier()
    elseif Framework.Type == 'redemrp' then
        return player.getIdentifier()
    end
end

function Framework.GetPlayerMoney(source)
    if Framework.Type == 'standalone' then
        return 0
    end
    
    local player = Framework.GetPlayer(source)
    if not player then return 0 end
    
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        return player.PlayerData.money['cash'] or 0
    elseif Framework.Type == 'vorp' then
        return player.getMoney() or 0
    elseif Framework.Type == 'redemrp' then
        return player.getMoney() or 0
    end
    
    return 0
end

function Framework.AddMoney(source, amount)
    if Framework.Type == 'standalone' then
        return true
    end
    
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        player.Functions.AddMoney('cash', amount)
        return true
    elseif Framework.Type == 'vorp' then
        player.addCurrency(0, amount)
        return true
    elseif Framework.Type == 'redemrp' then
        player.addMoney(amount)
        return true
    end
    
    return false
end

function Framework.RemoveMoney(source, amount)
    if Framework.Type == 'standalone' then
        return true
    end
    
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        player.Functions.RemoveMoney('cash', amount)
        return true
    elseif Framework.Type == 'vorp' then
        player.removeCurrency(0, amount)
        return true
    elseif Framework.Type == 'redemrp' then
        player.removeMoney(amount)
        return true
    end
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INVENTORY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.GetItem(source, item)
    if Framework.Type == 'standalone' then
        return nil
    end
    
    local player = Framework.GetPlayer(source)
    if not player then return nil end
    
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        return player.Functions.GetItemByName(item)
    elseif Framework.Type == 'vorp' then
        return player.getItem(item)
    elseif Framework.Type == 'redemrp' then
        return player.getInventoryItem(item)
    end
    
    return nil
end

function Framework.AddItem(source, item, amount)
    if Framework.Type == 'standalone' then
        return true
    end
    
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        player.Functions.AddItem(item, amount)
        return true
    elseif Framework.Type == 'vorp' then
        player.addItem(item, amount)
        return true
    elseif Framework.Type == 'redemrp' then
        player.addItem(item, amount)
        return true
    end
    
    return false
end

function Framework.RemoveItem(source, item, amount)
    if Framework.Type == 'standalone' then
        return true
    end
    
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.Type == 'lxrcore' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr-core' or Framework.Type == 'qr-core' then
        player.Functions.RemoveItem(item, amount)
        return true
    elseif Framework.Type == 'vorp' then
        player.removeItem(item, amount)
        return true
    elseif Framework.Type == 'redemrp' then
        player.removeItem(item, amount)
        return true
    end
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION FUNCTION
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.Notify(source, message, type, duration)
    if IsDuplicityVersion() then
        -- Server-side
        TriggerClientEvent('lxr-oil-corp:client:notify', source, message, type, duration)
    else
        -- Client-side
        duration = duration or Config.Notifications.Duration
        
        if Config.Notifications.Type == 'ox_lib' then
            lib.notify({
                title = 'Oil Corporation',
                description = message,
                type = type or 'info',
                position = Config.Notifications.Position or 'top-right',
                duration = duration
            })
        elseif Config.Notifications.Type == 'rsg' then
            if Framework.Core then
                Framework.Core.Functions.Notify(message, type or 'primary', duration)
            end
        elseif Config.Notifications.Type == 'vorp' then
            if Framework.Core then
                Framework.Core.NotifyRightTip(message, duration)
            end
        else
            -- Native notification
            local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", message, Citizen.ResultAsLong())
            Citizen.InvokeNative(0xFA233F8FE190514C, str)
            Citizen.InvokeNative(0xDD1232B332CBB9E7, 3, 1, 0)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZE FRAMEWORK ON LOAD
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Framework.Init()
end)
