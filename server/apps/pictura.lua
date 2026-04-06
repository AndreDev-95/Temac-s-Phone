--[[
    SERVER APP: PICTURA
    Rede social Pictura
]]

local prefix = Config.Database.prefix

-- ============================================
-- POST
-- ============================================
RegisterNetEvent('phone:pictura:post')
AddEventHandler('phone:pictura:post', function(image, caption, filters)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    local playerName = GetPlayerName(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'pictura (author, author_name, image, caption) VALUES (?, ?, ?, ?)',
        {identifier, playerName, image, caption or ''})
end)

-- ============================================
-- LIKE
-- ============================================
RegisterNetEvent('phone:pictura:like')
AddEventHandler('phone:pictura:like', function(postId)
    MySQL.query('UPDATE ' .. prefix .. 'pictura SET likes = likes + 1 WHERE id = ?', {postId})
end)

-- ============================================
-- FOLLOW
-- ============================================
RegisterNetEvent('phone:pictura:follow')
AddEventHandler('phone:pictura:follow', function(userId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT IGNORE INTO ' .. prefix .. 'pictura_follows (follower, following) VALUES (?, ?)',
        {identifier, userId})
end)

-- ============================================
-- UNFOLLOW
-- ============================================
RegisterNetEvent('phone:pictura:unfollow')
AddEventHandler('phone:pictura:unfollow', function(userId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'pictura_follows WHERE follower = ? AND following = ?',
        {identifier, userId})
end)

-- ============================================
-- STORY
-- ============================================
RegisterNetEvent('phone:pictura:story')
AddEventHandler('phone:pictura:story', function(image)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'pictura_stories (author, image) VALUES (?, ?)',
        {identifier, image})
end)

-- ============================================
-- DELETE POST
-- ============================================
RegisterNetEvent('phone:pictura:delete')
AddEventHandler('phone:pictura:delete', function(postId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'pictura WHERE id = ? AND author = ?', {postId, identifier})
end)
