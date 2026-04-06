--[[
    SERVER APP: MESSAGES
    Sistema de mensagens SMS
]]

local prefix = Config.Database.prefix

local function getPlayerIdentity(source)
    return {
        citizenid = Framework.GetIdentifier(source),
        phone = Framework.GetPhone(source)
    }
end

local function normalizeMessageRow(row, viewerPhone)
    if not row then return nil end
    row.message = row.message or row.content or ''
    row.sender_name = row.sender_name or row.senderName or row.sender
    row.self = viewerPhone and row.sender == viewerPhone or false
    return row
end

local function fetchConversationMessages(viewerCitizenId, viewerPhone, otherPhone)
    local rows = MySQL.query.await(([[
        SELECT m.*, COALESCE(c.name, m.sender) AS sender_name
        FROM %smessages m
        LEFT JOIN %scontacts c ON c.owner = ? AND c.number = m.sender
        WHERE (m.sender = ? AND m.receiver = ?) OR (m.sender = ? AND m.receiver = ?)
        ORDER BY m.id ASC
    ]]):format(prefix, prefix), {viewerCitizenId, viewerPhone, otherPhone, otherPhone, viewerPhone}) or {}

    for i = 1, #rows do
        normalizeMessageRow(rows[i], viewerPhone)
    end

    return rows
end

local function pushConversationToClient(targetSource, otherPhone)
    local identity = getPlayerIdentity(targetSource)
    if not identity.citizenid or not identity.phone or not otherPhone then return end

    local rows = fetchConversationMessages(identity.citizenid, identity.phone, otherPhone)
    TriggerClientEvent('phone:messages:conversationData', targetSource, otherPhone, rows)
end

-- ============================================
-- SEND MESSAGE
-- ============================================
RegisterNetEvent('phone:messages:send')
AddEventHandler('phone:messages:send', function(to, message)
    local source = source
    local identity = getPlayerIdentity(source)
    local senderPhone = identity.phone

    if not identity.citizenid or not senderPhone then return end

    to = tostring(to or '')
    message = tostring(message or '')

    if to == '' or message == '' then return end

    local insertId = MySQL.insert.await('INSERT INTO ' .. prefix .. 'messages (sender, receiver, message) VALUES (?, ?, ?)', {
        senderPhone,
        to,
        message
    })

    if not insertId then return end

    local senderRow = MySQL.single.await(([[
        SELECT m.*, COALESCE(c.name, m.sender) AS sender_name
        FROM %smessages m
        LEFT JOIN %scontacts c ON c.owner = ? AND c.number = m.sender
        WHERE m.id = ?
        LIMIT 1
    ]]):format(prefix, prefix), {identity.citizenid, insertId})

    if not senderRow then return end

    normalizeMessageRow(senderRow, senderPhone)

    TriggerClientEvent('phone:messages:new', source, senderRow)
    pushConversationToClient(source, to)

    local receiverSource = Framework.GetPlayerByPhone(to)
    if receiverSource then
        local receiverIdentity = getPlayerIdentity(receiverSource)
        local receiverRow = MySQL.single.await(([[
            SELECT m.*, COALESCE(c.name, m.sender) AS sender_name
            FROM %smessages m
            LEFT JOIN %scontacts c ON c.owner = ? AND c.number = m.sender
            WHERE m.id = ?
            LIMIT 1
        ]]):format(prefix, prefix), {receiverIdentity.citizenid, insertId}) or senderRow

        normalizeMessageRow(receiverRow, receiverIdentity.phone)
        TriggerClientEvent('phone:messages:new', receiverSource, receiverRow)
        pushConversationToClient(receiverSource, senderPhone)
    end
end)

-- ============================================
-- DELETE MESSAGE
-- ============================================
RegisterNetEvent('phone:messages:delete')
AddEventHandler('phone:messages:delete', function(id)
    local source = source
    local identity = getPlayerIdentity(source)

    if not identity.phone then return end

    MySQL.query('DELETE FROM ' .. prefix .. 'messages WHERE id = ? AND (sender = ? OR receiver = ?)', {
        id,
        identity.phone,
        identity.phone
    })
end)

-- ============================================
-- DELETE CONVERSATION
-- ============================================
RegisterNetEvent('phone:messages:deleteConversation')
AddEventHandler('phone:messages:deleteConversation', function(number)
    local source = source
    local identity = getPlayerIdentity(source)

    if not identity.phone then return end

    MySQL.query('DELETE FROM ' .. prefix .. 'messages WHERE (sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)', {
        identity.phone,
        number,
        number,
        identity.phone
    })
end)

-- ============================================
-- MARK AS READ
-- ============================================
RegisterNetEvent('phone:messages:markRead')
AddEventHandler('phone:messages:markRead', function(number)
    local source = source
    local identity = getPlayerIdentity(source)

    if not identity.phone then return end

    MySQL.query('UPDATE ' .. prefix .. 'messages SET is_read = TRUE WHERE sender = ? AND receiver = ?', {
        number,
        identity.phone
    })

    pushConversationToClient(source, number)
end)

-- ============================================
-- CONVERSATION DATA
-- ============================================
RegisterNetEvent('phone:messages:conversation')
AddEventHandler('phone:messages:conversation', function(number)
    local source = source
    pushConversationToClient(source, tostring(number or ''))
end)

-- ============================================
-- TYPING STATE
-- ============================================
RegisterNetEvent('phone:messages:typing')
AddEventHandler('phone:messages:typing', function(number, state)
    local source = source
    local senderPhone = Framework.GetPhone(source) or Framework.GetIdentifier(source)
    local receiverSource = Framework.GetPlayerByPhone(number)

    if receiverSource then
        TriggerClientEvent('phone:messages:typing', receiverSource, senderPhone, state == true)
    end
end)
