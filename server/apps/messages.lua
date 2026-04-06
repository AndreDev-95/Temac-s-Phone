--[[
    SERVER APP: MESSAGES
    Sistema de mensagens SMS
]]

local prefix = Config.Database.prefix

-- ============================================
-- SEND MESSAGE
-- ============================================
RegisterNetEvent('phone:messages:send')
AddEventHandler('phone:messages:send', function(to, message)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    local senderPhone = Framework.GetPhone(source) or identifier
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'messages (sender, receiver, message) VALUES (?, ?, ?)',
        {senderPhone, to, message})
    
    -- Find receiver and notify
    local receiverSource = Framework.GetPlayerByPhone(to)
    if receiverSource then
        TriggerClientEvent('phone:messages:new', receiverSource, {
            sender = senderPhone,
            senderName = GetPlayerName(source),
            message = message,
            time = os.date('%H:%M')
        })
    end
end)

-- ============================================
-- DELETE MESSAGE
-- ============================================
RegisterNetEvent('phone:messages:delete')
AddEventHandler('phone:messages:delete', function(id)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'messages WHERE id = ? AND (sender = ? OR receiver = ?)',
        {id, identifier, identifier})
end)

-- ============================================
-- DELETE CONVERSATION
-- ============================================
RegisterNetEvent('phone:messages:deleteConversation')
AddEventHandler('phone:messages:deleteConversation', function(number)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'messages WHERE (sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
        {identifier, number, number, identifier})
end)

-- ============================================
-- MARK AS READ
-- ============================================
RegisterNetEvent('phone:messages:markRead')
AddEventHandler('phone:messages:markRead', function(number)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('UPDATE ' .. prefix .. 'messages SET is_read = TRUE WHERE sender = ? AND receiver = ?',
        {number, identifier})
end)
