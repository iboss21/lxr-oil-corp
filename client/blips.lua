-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - BLIPS (CLIENT)
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

if not Config.EnableBlips then
    return
end

local OilWellBlips = {}
local BusinessBlips = {}
local SellingBlips = {}

-- ═══════════════════════════════════════════════════════════════════════════════
-- OIL WELL BLIPS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-oil-corp:client:updateBlips', function()
    -- Remove old blips
    for _, blip in pairs(OilWellBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    OilWellBlips = {}
    
    -- Get oil wells from main script
    local wells = exports['lxr-oil-corp']:GetOilWellsClient()
    if not wells then return end
    
    -- Create new blips
    for wellId, well in pairs(wells) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, well.coords.x, well.coords.y, well.coords.z)
        SetBlipSprite(blip, GetHashKey(Config.OilWells.Blip.sprite), true)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.OilWells.Blip.text)
        
        OilWellBlips[wellId] = blip
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUSINESS OFFICE BLIPS
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Business.Enabled then
    CreateThread(function()
        for _, office in pairs(Config.Business.BusinessOffices) do
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, office.coords.x, office.coords.y, office.coords.z)
            SetBlipSprite(blip, GetHashKey(office.blip.sprite), true)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, office.name)
            
            table.insert(BusinessBlips, blip)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SELLING LOCATION BLIPS
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    for _, location in pairs(Config.SellingLocations) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, GetHashKey(location.blip.sprite), true)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, location.name)
        
        table.insert(SellingBlips, blip)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

exports('GetOilWellsClient', function()
    return OilWells
end)

-- Store OilWells locally when synced
RegisterNetEvent('lxr-oil-corp:client:syncOilWells', function(wells)
    OilWells = wells
end)
