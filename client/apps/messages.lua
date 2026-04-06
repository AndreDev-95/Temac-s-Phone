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


RegisterNUICallback('openConversation', function(data, cb)
    if PhoneSession then PhoneSession:SetValue('messages.currentConversation', data.number) end
    if PhoneLifecycle then PhoneLifecycle:Open('messages') end
    TriggerServerEvent('phone:messages:conversation', data.number)
    cb('ok')
end)

RegisterNUICallback('messagesTyping', function(data, cb)
    TriggerServerEvent('phone:messages:typing', data.number, data.state == true)
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

RegisterNetEvent('phone:messages:conversationData')
AddEventHandler('phone:messages:conversationData', function(number, messages)
    SendNUIMessage({ type = 'messagesConversationData', number = number, messages = messages })
end)

RegisterNetEvent('phone:messages:typing')
AddEventHandler('phone:messages:typing', function(number, state)
    SendNUIMessage({ type = 'messagesTyping', number = number, state = state })
end)
