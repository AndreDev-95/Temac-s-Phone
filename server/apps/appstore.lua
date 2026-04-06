--[[
    SERVER APP: APPSTORE
    Loja de aplicativos - Persistência
]]

local prefix = Config.Database.prefix

-- ============================================
-- DATABASE INIT
-- ============================================
Citizen.CreateThread(function()
    Wait(3000)
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[installed_apps (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(50) NOT NULL,
            app_id VARCHAR(50) NOT NULL,
            installed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_app (owner, app_id),
            INDEX idx_owner (owner)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
end)

-- ============================================
-- GET INSTALLED APPS
-- ============================================
function GetInstalledApps(identifier)
    local result = MySQL.query.await(
        'SELECT app_id FROM ' .. prefix .. 'installed_apps WHERE owner = ?',
        {identifier}
    )
    
    local apps = {}
    if result then
        for _, row in ipairs(result) do
            table.insert(apps, row.app_id)
        end
    end
    return apps
end

-- ============================================
-- SEND INSTALLED APPS
-- ============================================
function SendInstalledApps(source, identifier)
    local apps = GetInstalledApps(identifier)
    TriggerClientEvent('phone:appstore:sync', source, apps)
end

-- ============================================
-- EVENTS
-- ============================================
RegisterNetEvent('phone:appstore:install')
AddEventHandler('phone:appstore:install', function(appId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    if not identifier then return end
    
    MySQL.insert('INSERT IGNORE INTO ' .. prefix .. 'installed_apps (owner, app_id) VALUES (?, ?)',
        {identifier, appId})
    
    TriggerClientEvent('phone:notification', source, 'App Store', 'App instalado com sucesso!', 'appstore')
end)

RegisterNetEvent('phone:appstore:uninstall')
AddEventHandler('phone:appstore:uninstall', function(appId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    if not identifier then return end
    
    MySQL.query('DELETE FROM ' .. prefix .. 'installed_apps WHERE owner = ? AND app_id = ?',
        {identifier, appId})
    
    TriggerClientEvent('phone:notification', source, 'App Store', 'App removido!', 'appstore')
end)

-- ============================================
-- ON PLAYER LOAD
-- ============================================
RegisterNetEvent('phone:requestAllData')
AddEventHandler('phone:requestAllData', function()
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    if identifier then
        SendInstalledApps(source, identifier)
    end
end)
