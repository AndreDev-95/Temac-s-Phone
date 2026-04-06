--[[
    SERVER APP: NOTES
    Notas do celular
]]

local prefix = Config.Database.prefix

-- ============================================
-- SAVE NOTE
-- ============================================
RegisterNetEvent('phone:notes:save')
AddEventHandler('phone:notes:save', function(id, title, content)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    if id then
        MySQL.query('UPDATE ' .. prefix .. 'notes SET title = ?, content = ? WHERE id = ? AND owner = ?',
            {title, content, id, identifier})
    else
        MySQL.insert('INSERT INTO ' .. prefix .. 'notes (owner, title, content) VALUES (?, ?, ?)',
            {identifier, title, content})
    end
    
    SendNotes(source, identifier)
end)

-- ============================================
-- DELETE NOTE
-- ============================================
RegisterNetEvent('phone:notes:delete')
AddEventHandler('phone:notes:delete', function(id)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'notes WHERE id = ? AND owner = ?', {id, identifier})
    SendNotes(source, identifier)
end)
