--[[
    SERVER APP: GALLERY
    Galeria de fotos
]]

local prefix = Config.Database.prefix

-- ============================================
-- ADD PHOTO
-- ============================================
RegisterNetEvent('phone:gallery:add')
AddEventHandler('phone:gallery:add', function(url)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'gallery (owner, url) VALUES (?, ?)', {identifier, url})
    TriggerClientEvent('phone:notification', source, 'Galeria', 'Foto salva!', 'gallery')
    SendGallery(source, identifier)
end)

-- ============================================
-- DELETE PHOTO
-- ============================================
RegisterNetEvent('phone:gallery:delete')
AddEventHandler('phone:gallery:delete', function(id)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'gallery WHERE id = ? AND owner = ?', {id, identifier})
    SendGallery(source, identifier)
end)
