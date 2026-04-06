--[[
    CLIENT APP: MESSAGES
    Sistema de mensagens SMS
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('phone:messages:send', data.to, data.message)
    cb('ok')
end)

RegisterNUICallback('deleteMessage', function(data, cb)
    TriggerServerEvent('phone:messages:delete', data.id)
    cb('ok')
end)

RegisterNUICallback('deleteConversation', function(data, cb)
    TriggerServerEvent('phone:messages:deleteConversation', data.number)
    cb('ok')
end)

RegisterNUICallback('markAsRead', function(data, cb)
    TriggerServerEvent('phone:messages:markRead', data.number)
    cb('ok')
end)

-- ============================================
-- SERVER EVENTS
-- ============================================
RegisterNetEvent('phone:messages:new')
AddEventHandler('phone:messages:new', function(messageData)
    SendNUIMessage({
        type = 'newMessage',
        message = messageData
    })
    
    Framework.Notify(_U('new_message') .. ': ' .. messageData.senderName, 'info')
end)
