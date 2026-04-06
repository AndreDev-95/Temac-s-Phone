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


-- ============================================
-- CONVERSATION DATA
-- ============================================
RegisterNetEvent('phone:messages:conversation')
AddEventHandler('phone:messages:conversation', function(number)
    local source = source
    local identifier = Framework.GetPhone(source) or Framework.GetIdentifier(source)
    local rows = MySQL.query.await('SELECT * FROM ' .. prefix .. 'messages WHERE (sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?) ORDER BY id ASC',
        {identifier, number, number, identifier}) or {}
    TriggerClientEvent('phone:messages:conversationData', source, number, rows)
end)

-- ============================================
-- TYPING STATE
-- ============================================
RegisterNetEvent('phone:messages:typing')
AddEventHandler('phone:messages:typing', function(number, state)
    local source = source
    local receiverSource = Framework.GetPlayerByPhone(number)
    if receiverSource then
        TriggerClientEvent('phone:messages:typing', receiverSource, Framework.GetPhone(source) or Framework.GetIdentifier(source), state == true)
    end
end)
