--[[
    CLIENT APP: SETTINGS
    Configurações do celular
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('setWallpaper', function(data, cb)
    SetResourceKvp('phone_wallpaper', data.wallpaper)
    PhoneData.settings.wallpaper = data.wallpaper
    cb('ok')
end)

RegisterNUICallback('setRingtone', function(data, cb)
    SetResourceKvp('phone_ringtone', data.ringtone)
    PhoneData.settings.ringtone = data.ringtone
    cb('ok')
end)

RegisterNUICallback('setBrightness', function(data, cb)
    SetResourceKvpInt('phone_brightness', data.brightness)
    PhoneData.settings.brightness = data.brightness
    cb('ok')
end)

RegisterNUICallback('toggleDarkMode', function(data, cb)
    SetResourceKvp('phone_darkMode', tostring(data.enabled))
    PhoneData.settings.darkMode = data.enabled
    cb('ok')
end)

RegisterNUICallback('toggleNotifications', function(data, cb)
    SetResourceKvp('phone_notifications', tostring(data.enabled))
    PhoneData.settings.notifications = data.enabled
    cb('ok')
end)

RegisterNUICallback('toggleAirplane', function(data, cb)
    SetResourceKvp('phone_airplane', tostring(data.enabled))
    PhoneData.settings.airplane = data.enabled
    cb('ok')
end)

RegisterNUICallback('toggleWifi', function(data, cb)
    SetResourceKvp('phone_wifi', tostring(data.enabled))
    PhoneData.settings.wifi = data.enabled
    cb('ok')
end)

RegisterNUICallback('toggleBluetooth', function(data, cb)
    SetResourceKvp('phone_bluetooth', tostring(data.enabled))
    PhoneData.settings.bluetooth = data.enabled
    cb('ok')
end)

RegisterNUICallback('resetSettings', function(data, cb)
    SetResourceKvp('phone_wallpaper', Config.DefaultWallpaper)
    SetResourceKvp('phone_ringtone', 'default')
    SetResourceKvpInt('phone_brightness', 100)
    SetResourceKvp('phone_darkMode', 'false')
    SetResourceKvp('phone_notifications', 'true')
    SetResourceKvp('phone_airplane', 'false')
    SetResourceKvp('phone_wifi', 'true')
    SetResourceKvp('phone_bluetooth', 'false')
    
    PhoneData.settings = GetPhoneSettings()
    cb(PhoneData.settings)
end)
