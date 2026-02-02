-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - VERSION CHECK
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

local CURRENT_VERSION = '1.0.0'
local GITHUB_REPO = 'iboss21/lxr-oil-corp'

CreateThread(function()
    Wait(5000) -- Wait for server to start
    
    print([[
        ^3
        ╔═══════════════════════════════════════════════════════════════════════════════╗
        ║                                                                               ║
        ║                     🐺 LXR OIL CORPORATION SYSTEM 🐺                         ║
        ║                                                                               ║
        ║                            Version Check                                      ║
        ║                                                                               ║
        ║                       Current Version: ]] .. CURRENT_VERSION .. [[                                    ║
        ║                                                                               ║
        ║                        The Land of Wolves 🐺                                 ║
        ║                      https://www.wolves.land                                  ║
        ║                                                                               ║
        ╚═══════════════════════════════════════════════════════════════════════════════╝
        ^7
    ]])
    
    -- Check for updates (optional)
    PerformHttpRequest('https://api.github.com/repos/' .. GITHUB_REPO .. '/releases/latest', function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data and data.tag_name then
                local latestVersion = data.tag_name:gsub('v', '')
                
                if latestVersion ~= CURRENT_VERSION then
                    print([[
                        ^3
                        ╔═══════════════════════════════════════════════════════════════════════════════╗
                        ║                                                                               ║
                        ║                          🔄 UPDATE AVAILABLE 🔄                              ║
                        ║                                                                               ║
                        ║                       Current: ]] .. CURRENT_VERSION .. [[                                             ║
                        ║                       Latest:  ]] .. latestVersion .. [[                                             ║
                        ║                                                                               ║
                        ║                 Download: https://github.com/]] .. GITHUB_REPO .. [[                  ║
                        ║                                                                               ║
                        ╚═══════════════════════════════════════════════════════════════════════════════╝
                        ^7
                    ]])
                else
                    print('^2[LXR Oil Corp]^7 You are running the latest version!')
                end
            end
        end
    end, 'GET', '', {['Content-Type'] = 'application/json'})
end)
