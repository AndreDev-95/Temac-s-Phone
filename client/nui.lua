--[[
    CLIENT NUI
    Comunicação com a interface NUI
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================

-- Close Phone
RegisterNUICallback('closePhone', function(data, cb)
    ClosePhone()
    cb('ok')
end)

-- Update Settings
RegisterNUICallback('updateSettings', function(data, cb)
    for key, value in pairs(data) do
        if type(value) == 'boolean' then
            SetResourceKvp('phone_' .. key, tostring(value))
        elseif type(value) == 'number' then
            SetResourceKvpInt('phone_' .. key, value)
        else
            SetResourceKvp('phone_' .. key, value)
        end
    end
    PhoneData.settings = GetPhoneSettings()
    cb('ok')
end)

-- Get Settings
RegisterNUICallback('getSettings', function(data, cb)
    cb(GetPhoneSettings())
end)

-- ============================================
-- SETTINGS HELPER
-- ============================================
function GetPhoneSettings()
    return {
        wallpaper = GetResourceKvpString('phone_wallpaper') or Config.DefaultWallpaper,
        ringtone = GetResourceKvpString('phone_ringtone') or 'default',
        brightness = GetResourceKvpInt('phone_brightness') or 100,
        darkMode = GetResourceKvpString('phone_darkMode') == 'true',
        notifications = GetResourceKvpString('phone_notifications') ~= 'false',
        airplane = GetResourceKvpString('phone_airplane') == 'true',
        wifi = GetResourceKvpString('phone_wifi') ~= 'false',
        bluetooth = GetResourceKvpString('phone_bluetooth') == 'true'
    }
end

-- Load settings on start
Citizen.CreateThread(function()
    Wait(1000)
    PhoneData.settings = GetPhoneSettings()
end)

-- ============================================
-- SERVER EVENTS -> NUI
-- ============================================
RegisterNetEvent('phone:receiveData')
AddEventHandler('phone:receiveData', function(dataType, data)
    SendNUIMessage({
        type = 'receiveData',
        dataType = dataType,
        data = data
    })
end)

RegisterNetEvent('phone:notification')
AddEventHandler('phone:notification', function(title, message, icon)
    SendNUIMessage({
        type = 'notification',
        title = title,
        message = message,
        icon = icon
    })
    
    if Config.Notifications.sound then
        PlaySound(-1, 'Text_Arrive_Tone', 'Phone_SoundSet_Default', 0, 0, 1)
    end
end)

RegisterNetEvent('phone:updateBalance')
AddEventHandler('phone:updateBalance', function(cash, bank)
    PhoneData.playerData.money = cash
    PhoneData.playerData.bank = bank
    SendNUIMessage({
        type = 'updateBalance',
        cash = cash,
        bank = bank
    })
end)
