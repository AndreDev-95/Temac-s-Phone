--[[
    SERVER APP: CONTACTS
    Gerenciamento de contatos
]]

local prefix = Config.Database.prefix

-- ============================================
-- ADD CONTACT
-- ============================================
RegisterNetEvent('phone:contacts:add')
AddEventHandler('phone:contacts:add', function(name, number, avatar)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'contacts (owner, name, number, avatar) VALUES (?, ?, ?, ?)',
        {identifier, name, number, avatar or ''})
    
    TriggerClientEvent('phone:notification', source, 'Contatos', 'Contato adicionado: ' .. name, 'contacts')
    SendContacts(source, identifier)
end)

-- ============================================
-- EDIT CONTACT
-- ============================================
RegisterNetEvent('phone:contacts:edit')
AddEventHandler('phone:contacts:edit', function(id, name, number, avatar)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('UPDATE ' .. prefix .. 'contacts SET name = ?, number = ?, avatar = ? WHERE id = ? AND owner = ?',
        {name, number, avatar or '', id, identifier})
    
    SendContacts(source, identifier)
end)

-- ============================================
-- DELETE CONTACT
-- ============================================
RegisterNetEvent('phone:contacts:delete')
AddEventHandler('phone:contacts:delete', function(id)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'contacts WHERE id = ? AND owner = ?', {id, identifier})
    SendContacts(source, identifier)
end)

-- ============================================
-- FAVORITE CONTACT
-- ============================================
RegisterNetEvent('phone:contacts:favorite')
AddEventHandler('phone:contacts:favorite', function(id, favorite)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('UPDATE ' .. prefix .. 'contacts SET favorite = ? WHERE id = ? AND owner = ?',
        {favorite, id, identifier})
    
    SendContacts(source, identifier)
end)
