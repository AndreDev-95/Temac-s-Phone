--[[
    CLIENT APP: APPSTORE
    Loja de aplicativos
]]

-- Installed apps cache
local InstalledApps = {}

-- ============================================
-- INITIALIZATION
-- ============================================
Citizen.CreateThread(function()
    Wait(2000)
    LoadInstalledApps()
end)

function LoadInstalledApps()
    -- Load from KVP
    local saved = GetResourceKvpString('phone_installed_apps')
    if saved and saved ~= '' then
        InstalledApps = json.decode(saved) or {}
    else
        InstalledApps = {}
    end
    
    -- Notify NUI
    SendNUIMessage({
        type = 'updateInstalledApps',
        apps = InstalledApps
    })
end

function SaveInstalledApps()
    SetResourceKvp('phone_installed_apps', json.encode(InstalledApps))
end

function IsAppInstalled(appId)
    for _, id in ipairs(InstalledApps) do
        if id == appId then return true end
    end
    return false
end

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('getInstalledApps', function(data, cb)
    cb(InstalledApps)
end)

RegisterNUICallback('getStoreApps', function(data, cb)
    local storeApps = {}
    for id, app in pairs(Config.StoreApps) do
        local appData = {
            id = id,
            name = app.name,
            icon = app.icon,
            color = app.color,
            category = app.category,
            description = app.description,
            rating = app.rating,
            downloads = app.downloads,
            size = app.size,
            developer = app.developer,
            price = app.price,
            installed = IsAppInstalled(id)
        }
        table.insert(storeApps, appData)
    end
    cb(storeApps)
end)

RegisterNUICallback('getAppCategories', function(data, cb)
    cb(Config.AppCategories)
end)

RegisterNUICallback('installApp', function(data, cb)
    local appId = data.appId
    
    if not Config.StoreApps[appId] then
        cb({ success = false, error = 'App não encontrado' })
        return
    end
    
    if IsAppInstalled(appId) then
        cb({ success = false, error = 'App já instalado' })
        return
    end
    
    -- Install app
    table.insert(InstalledApps, appId)
    SaveInstalledApps()
    
    -- Save to server for persistence
    TriggerServerEvent('phone:appstore:install', appId)
    
    -- Notify NUI
    SendNUIMessage({
        type = 'updateInstalledApps',
        apps = InstalledApps
    })
    
    cb({ success = true })
end)

RegisterNUICallback('uninstallApp', function(data, cb)
    local appId = data.appId
    
    -- Remove from list
    for i, id in ipairs(InstalledApps) do
        if id == appId then
            table.remove(InstalledApps, i)
            break
        end
    end
    
    SaveInstalledApps()
    
    -- Save to server
    TriggerServerEvent('phone:appstore:uninstall', appId)
    
    -- Notify NUI
    SendNUIMessage({
        type = 'updateInstalledApps',
        apps = InstalledApps
    })
    
    cb({ success = true })
end)

RegisterNUICallback('getSystemApps', function(data, cb)
    local systemApps = {}
    for id, app in pairs(Config.SystemApps) do
        table.insert(systemApps, {
            id = id,
            name = app.name,
            icon = app.icon,
            color = app.color
        })
    end
    cb(systemApps)
end)

-- ============================================
-- SERVER SYNC
-- ============================================
RegisterNetEvent('phone:appstore:sync')
AddEventHandler('phone:appstore:sync', function(apps)
    InstalledApps = apps or {}
    SaveInstalledApps()
    
    SendNUIMessage({
        type = 'updateInstalledApps',
        apps = InstalledApps
    })
end)

-- Export
exports('IsAppInstalled', IsAppInstalled)
exports('GetInstalledApps', function() return InstalledApps end)
