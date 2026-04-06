--[[
    CLIENT APP: CAMERA
    Câmera e galeria de fotos
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('takePhoto', function(data, cb)
    ClosePhone()
    Wait(500)
    
    -- Hide HUD
    DisplayHud(false)
    DisplayRadar(false)
    
    -- Take screenshot (requires screenshot-basic)
    if GetResourceState('screenshot-basic') == 'started' then
        exports['screenshot-basic']:requestScreenshotUpload(
            'https://api.imgur.com/3/image',
            'file',
            {
                headers = {
                    ['Authorization'] = 'Client-ID YOUR_IMGUR_CLIENT_ID'
                }
            },
            function(result)
                local resp = json.decode(result)
                if resp and resp.data and resp.data.link then
                    TriggerServerEvent('phone:gallery:add', resp.data.link)
                    cb({ success = true, url = resp.data.link })
                else
                    cb({ success = false, error = 'Upload failed' })
                end
                
                Wait(500)
                DisplayHud(true)
                DisplayRadar(true)
                OpenPhone()
            end
        )
    else
        -- Fallback without screenshot-basic
        Framework.Notify('screenshot-basic não instalado', 'error')
        cb({ success = false, error = 'screenshot-basic not installed' })
        
        DisplayHud(true)
        DisplayRadar(true)
        OpenPhone()
    end
end)

RegisterNUICallback('deletePhoto', function(data, cb)
    TriggerServerEvent('phone:gallery:delete', data.id)
    cb('ok')
end)
