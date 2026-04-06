--[[
    SERVER APP: FLAMER
    App de relacionamentos
]]

local prefix = Config.Database.prefix

-- ============================================
-- UPDATE PROFILE
-- ============================================
RegisterNetEvent('phone:flamer:updateProfile')
AddEventHandler('phone:flamer:updateProfile', function(data)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.query([[
        INSERT INTO ]] .. prefix .. [[flamer_profiles (user_id, name, age, bio, photos, looking_for)
        VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
        name = VALUES(name), age = VALUES(age), bio = VALUES(bio),
        photos = VALUES(photos), looking_for = VALUES(looking_for)
    ]], {identifier, data.name, data.age, data.bio, json.encode(data.photos or {}), data.lookingFor or 'everyone'})
end)

-- ============================================
-- SWIPE
-- ============================================
RegisterNetEvent('phone:flamer:swipe')
AddEventHandler('phone:flamer:swipe', function(profileId, direction)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'flamer_swipes (swiper, swiped, direction) VALUES (?, ?, ?)',
        {identifier, profileId, direction})
    
    -- Check for match
    if direction == 'right' then
        local otherSwipe = MySQL.query.await(
            'SELECT * FROM ' .. prefix .. 'flamer_swipes WHERE swiper = ? AND swiped = ? AND direction = ?',
            {profileId, identifier, 'right'}
        )
        
        if otherSwipe and #otherSwipe > 0 then
            -- It's a match!
            MySQL.insert('INSERT INTO ' .. prefix .. 'flamer_matches (user1, user2) VALUES (?, ?)',
                {identifier, profileId})
            
            local matchProfile = MySQL.query.await('SELECT * FROM ' .. prefix .. 'flamer_profiles WHERE user_id = ?', {profileId})
            local myProfile = MySQL.query.await('SELECT * FROM ' .. prefix .. 'flamer_profiles WHERE user_id = ?', {identifier})
            
            TriggerClientEvent('phone:flamer:match', source, matchProfile and matchProfile[1] or {})
            
            -- Notify other player
            for _, playerId in ipairs(GetPlayers()) do
                if Framework.GetIdentifier(playerId) == profileId then
                    TriggerClientEvent('phone:flamer:match', playerId, myProfile and myProfile[1] or {})
                    break
                end
            end
        end
    end
end)

-- ============================================
-- SUPER LIKE
-- ============================================
RegisterNetEvent('phone:flamer:superlike')
AddEventHandler('phone:flamer:superlike', function(profileId)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'flamer_swipes (swiper, swiped, direction, super_like) VALUES (?, ?, ?, ?)',
        {identifier, profileId, 'right', true})
end)

-- ============================================
-- SEND MESSAGE
-- ============================================
RegisterNetEvent('phone:flamer:message')
AddEventHandler('phone:flamer:message', function(matchId, message)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    MySQL.insert('INSERT INTO ' .. prefix .. 'flamer_messages (match_id, sender, message) VALUES (?, ?, ?)',
        {matchId, identifier, message})
end)

-- ============================================
-- UNMATCH
-- ============================================
RegisterNetEvent('phone:flamer:unmatch')
AddEventHandler('phone:flamer:unmatch', function(matchId)
    local source = source
    
    MySQL.query('DELETE FROM ' .. prefix .. 'flamer_matches WHERE id = ?', {matchId})
    MySQL.query('DELETE FROM ' .. prefix .. 'flamer_messages WHERE match_id = ?', {matchId})
end)
