--[[
    ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
    ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
    ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
    ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
    ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
    
    🐺 LXR Oil Corporation - Complete Oil Business System
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    
    Version: 1.0.0
    © 2026 iBoss21 / The Lux Empire | All Rights Reserved
]]

fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'

name 'lxr-oil-corp'
author 'iBoss21 / The Lux Empire'
description 'Complete Oil Corporation business system with production, trading, and management features'
version '1.0.0'

-- ═══════════════════════════════════════════════════════════════════════════════
-- SHARED SCRIPTS
-- ═══════════════════════════════════════════════════════════════════════════════

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'shared/framework.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT SCRIPTS
-- ═══════════════════════════════════════════════════════════════════════════════

client_scripts {
    'client/main.lua',
    'client/blips.lua',
    'client/targets.lua',
    'client/barrels.lua',
    'client/business.lua',
    'client/missions.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER SCRIPTS
-- ═══════════════════════════════════════════════════════════════════════════════

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/versioncheck.lua',
    'server/database.lua',
    'server/main.lua',
    'server/business.lua',
    'server/missions.lua',
    'server/cron.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEPENDENCIES
-- ═══════════════════════════════════════════════════════════════════════════════

dependencies {
    'oxmysql',
    'ox_lib'
}

-- Optional dependencies (auto-detected)
-- rsg-core, lxr-core, vorp_core, redemrp_core, qbr-core
-- rsg-target, ox_target, vorp_target

-- ═══════════════════════════════════════════════════════════════════════════════
-- FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Localization handled in shared/locale.lua
-- files {
--     'locales/*.lua'
-- }
