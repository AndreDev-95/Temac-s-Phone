--[[
    SERVER APP: EMAIL
    Sistema de emails
]]

local prefix = Config.Database.prefix

-- ============================================
-- SEND EMAIL
-- ============================================
RegisterNetEvent('phone:email:send')
AddEventHandler('phone:email:send', function(to, subject, body)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'emails (sender, receiver, subject, body) VALUES (?, ?, ?, ?)',
        {identifier, to, subject, body})
    
    TriggerClientEvent('phone:notification', source, 'Email', 'Email enviado!', 'email')
end)

-- ============================================
-- DELETE EMAIL
-- ============================================
RegisterNetEvent('phone:email:delete')
AddEventHandler('phone:email:delete', function(id)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'emails WHERE id = ? AND (sender = ? OR receiver = ?)',
        {id, identifier, identifier})
end)

-- ============================================
-- MARK AS READ
-- ============================================
RegisterNetEvent('phone:email:markRead')
AddEventHandler('phone:email:markRead', function(id)
    local source = source
    
    MySQL.query('UPDATE ' .. prefix .. 'emails SET is_read = TRUE WHERE id = ?', {id})
end)

-- ============================================
-- GET EMAILS
-- ============================================
function SendEmails(source, identifier)
    local emails = MySQL.query.await([[
        SELECT * FROM ]] .. prefix .. [[emails 
        WHERE receiver = ? OR sender = ?
        ORDER BY created_at DESC LIMIT 50
    ]], {identifier, identifier})
    
    TriggerClientEvent('phone:receiveData', source, 'emails', emails or {})
end
