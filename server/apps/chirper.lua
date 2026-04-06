--[[
    SERVER APP: CHIRPER
    Rede social Chirper
]]

local prefix = Config.Database.prefix

-- ============================================
-- POST TWEET
-- ============================================
RegisterNetEvent('phone:chirper:post')
AddEventHandler('phone:chirper:post', function(content, image)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    local playerName = GetPlayerName(source)
    
    local chirpId = MySQL.insert.await('INSERT INTO ' .. prefix .. 'chirper (author, author_name, content, image) VALUES (?, ?, ?, ?)',
        {identifier, playerName, content, image or ''})
    
    -- Broadcast to all players
    local chirp = {
        id = chirpId,
        author = identifier,
        author_name = playerName,
        content = content,
        image = image,
        likes = 0,
        rechirps = 0,
        created_at = os.date('%Y-%m-%d %H:%M:%S')
    }
    
    TriggerClientEvent('phone:chirper:newChirp', -1, chirp)
end)

-- ============================================
-- LIKE TWEET
-- ============================================
RegisterNetEvent('phone:chirper:like')
AddEventHandler('phone:chirper:like', function(chirpId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    local existing = MySQL.query.await('SELECT id FROM ' .. prefix .. 'chirper_likes WHERE chirp_id = ? AND user_id = ?',
        {chirpId, identifier})
    
    if existing and #existing > 0 then
        -- Unlike
        MySQL.query('DELETE FROM ' .. prefix .. 'chirper_likes WHERE chirp_id = ? AND user_id = ?',
            {chirpId, identifier})
        MySQL.query('UPDATE ' .. prefix .. 'chirper SET likes = likes - 1 WHERE id = ?', {chirpId})
    else
        -- Like
        MySQL.insert('INSERT INTO ' .. prefix .. 'chirper_likes (chirp_id, user_id) VALUES (?, ?)',
            {chirpId, identifier})
        MySQL.query('UPDATE ' .. prefix .. 'chirper SET likes = likes + 1 WHERE id = ?', {chirpId})
    end
end)

-- ============================================
-- RETWEET
-- ============================================
RegisterNetEvent('phone:chirper:rechirp')
AddEventHandler('phone:chirper:rechirp', function(chirpId)
    MySQL.query('UPDATE ' .. prefix .. 'chirper SET rechirps = rechirps + 1 WHERE id = ?', {chirpId})
end)

-- ============================================
-- DELETE TWEET
-- ============================================
RegisterNetEvent('phone:chirper:delete')
AddEventHandler('phone:chirper:delete', function(chirpId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query('DELETE FROM ' .. prefix .. 'chirper WHERE id = ? AND author = ?', {chirpId, identifier})
    MySQL.query('DELETE FROM ' .. prefix .. 'chirper_likes WHERE chirp_id = ?', {chirpId})
end)
