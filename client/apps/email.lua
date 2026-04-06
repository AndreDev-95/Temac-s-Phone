--[[
    CLIENT APP: EMAIL
    Sistema de emails
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('sendEmail', function(data, cb)
    TriggerServerEvent('phone:email:send', data.to, data.subject, data.body)
    cb('ok')
end)

RegisterNUICallback('deleteEmail', function(data, cb)
    TriggerServerEvent('phone:email:delete', data.id)
    cb('ok')
end)

RegisterNUICallback('markEmailRead', function(data, cb)
    TriggerServerEvent('phone:email:markRead', data.id)
    cb('ok')
end)
