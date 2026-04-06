--[[
    SERVER APP: CHIRPER
    Upgrade com likes, comentários, rechirps e perfil básico
]]

local prefix = Config.Database.prefix

local function getCachedCharValue(cached, key)
    if not cached then return nil end
    if cached[key] ~= nil then return cached[key] end
    if type(cached.charinfo) == 'table' then
        return cached.charinfo[key]
    end
    return nil
end

local function getChirperIdentity(source)
    local cached = PlayerCache[source] or {}
    local first = getCachedCharValue(cached, 'firstname') or getCachedCharValue(cached, 'firstName')
    local last = getCachedCharValue(cached, 'lastname') or getCachedCharValue(cached, 'lastName')
    local fullName = cached.name or cached.playerName

    if (not fullName or fullName == '') and first then
        fullName = tostring(first) .. ((last and last ~= '') and (' ' .. tostring(last)) or '')
    end

    if not fullName or fullName == '' then
        fullName = ('User %s'):format(source)
    end

    return {
        source = source,
        citizenid = Framework.GetIdentifier(source),
        phone = Framework.GetPhone(source),
        name = fullName,
        avatar = cached.avatar or cached.picture or nil,
        verified = cached.verified == true and 1 or 0
    }
end

local function fetchChirperFeed(viewerCitizenId)
    return MySQL.query.await(([[]
        SELECT
            c.*,
            COALESCE(l.like_count, 0) AS likes,
            COALESCE(r.rechirp_count, 0) AS rechirps,
            COALESCE(cm.comment_count, 0) AS comments,
            CASE WHEN ul.id IS NOT NULL THEN 1 ELSE 0 END AS user_liked,
            CASE WHEN ur.id IS NOT NULL THEN 1 ELSE 0 END AS user_rechirped,
            rp.author AS original_author,
            rp.author_name AS original_author_name,
            rp.content AS original_content
        FROM %schirper c
        LEFT JOIN (
            SELECT chirp_id, COUNT(*) AS like_count
            FROM %schirper_likes
            GROUP BY chirp_id
        ) l ON l.chirp_id = c.id
        LEFT JOIN (
            SELECT chirp_id, COUNT(*) AS rechirp_count
            FROM %schirper_rechirps
            GROUP BY chirp_id
        ) r ON r.chirp_id = c.id
        LEFT JOIN (
            SELECT chirp_id, COUNT(*) AS comment_count
            FROM %schirper_comments
            GROUP BY chirp_id
        ) cm ON cm.chirp_id = c.id
        LEFT JOIN %schirper_likes ul ON ul.chirp_id = c.id AND ul.user_id = ?
        LEFT JOIN %schirper_rechirps ur ON ur.chirp_id = c.id AND ur.user_id = ?
        LEFT JOIN %schirper rp ON rp.id = c.reply_to
        ORDER BY c.created_at DESC
        LIMIT ?
    ]]):format(prefix, prefix, prefix, prefix, prefix, prefix), {
        viewerCitizenId,
        viewerCitizenId,
        Config.Chirper.maxTweets
    }) or {}
end

local function fetchChirperProfile(citizenid)
    local stats = MySQL.single.await(([[]
        SELECT
            COUNT(*) AS total_chirps,
            COALESCE(SUM(like_totals.likes), 0) AS total_likes,
            COALESCE(SUM(comment_totals.comments), 0) AS total_comments,
            COALESCE(SUM(rechirp_totals.rechirps), 0) AS total_rechirps
        FROM %schirper c
        LEFT JOIN (
            SELECT chirp_id, COUNT(*) AS likes FROM %schirper_likes GROUP BY chirp_id
        ) like_totals ON like_totals.chirp_id = c.id
        LEFT JOIN (
            SELECT chirp_id, COUNT(*) AS comments FROM %schirper_comments GROUP BY chirp_id
        ) comment_totals ON comment_totals.chirp_id = c.id
        LEFT JOIN (
            SELECT chirp_id, COUNT(*) AS rechirps FROM %schirper_rechirps GROUP BY chirp_id
        ) rechirp_totals ON rechirp_totals.chirp_id = c.id
        WHERE c.author = ?
    ]]):format(prefix, prefix, prefix, prefix), {citizenid}) or {}

    return {
        total_chirps = stats.total_chirps or 0,
        total_likes = stats.total_likes or 0,
        total_comments = stats.total_comments or 0,
        total_rechirps = stats.total_rechirps or 0
    }
end

local function fetchComments(chirpId)
    return MySQL.query.await(([[]
        SELECT id, chirp_id, author, author_name, author_avatar, content, created_at
        FROM %schirper_comments
        WHERE chirp_id = ?
        ORDER BY created_at ASC
        LIMIT 50
    ]]):format(prefix), {chirpId}) or {}
end

local function pushChirperToPlayer(target)
    local identity = getChirperIdentity(target)
    if not identity.citizenid then return end

    TriggerClientEvent('phone:receiveData', target, 'chirper', fetchChirperFeed(identity.citizenid))
    TriggerClientEvent('phone:chirper:profileData', target, fetchChirperProfile(identity.citizenid))
end

local function refreshChirperForAll()
    for _, playerId in ipairs(GetPlayers()) do
        pushChirperToPlayer(tonumber(playerId))
    end
end

local function postChirpInternal(source, payload)
    local identity = getChirperIdentity(source)
    if not identity.citizenid then return end

    local content = tostring(payload.content or ''):sub(1, 280)
    local image = payload.image and tostring(payload.image) or nil
    local replyTo = tonumber(payload.replyTo) or nil

    if content == '' then return end

    local insertId = MySQL.insert.await('INSERT INTO ' .. prefix .. 'chirper (author, author_name, author_avatar, content, image, verified, reply_to) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        identity.citizenid,
        identity.name,
        identity.avatar,
        content,
        image,
        identity.verified,
        replyTo
    })

    if not insertId then return end

    refreshChirperForAll()

    local created = MySQL.single.await(([[]
        SELECT c.*, 0 AS likes, 0 AS comments, 0 AS rechirps, 0 AS user_liked, 0 AS user_rechirped
        FROM %schirper c WHERE c.id = ? LIMIT 1
    ]]):format(prefix), {insertId})

    if created then
        TriggerClientEvent('phone:newChirp', -1, created)
    end
end

local function toggleLikeInternal(source, chirpId)
    local identity = getChirperIdentity(source)
    if not identity.citizenid or not chirpId then return end

    local exists = MySQL.single.await('SELECT id FROM ' .. prefix .. 'chirper_likes WHERE chirp_id = ? AND user_id = ? LIMIT 1', {
        chirpId,
        identity.citizenid
    })

    if exists then
        MySQL.query.await('DELETE FROM ' .. prefix .. 'chirper_likes WHERE id = ?', {exists.id})
    else
        MySQL.insert.await('INSERT INTO ' .. prefix .. 'chirper_likes (chirp_id, user_id) VALUES (?, ?)', {
            chirpId,
            identity.citizenid
        })
    end

    refreshChirperForAll()
end

local function toggleRechirpInternal(source, chirpId)
    local identity = getChirperIdentity(source)
    if not identity.citizenid or not chirpId then return end

    local exists = MySQL.single.await('SELECT id FROM ' .. prefix .. 'chirper_rechirps WHERE chirp_id = ? AND user_id = ? LIMIT 1', {
        chirpId,
        identity.citizenid
    })

    if exists then
        MySQL.query.await('DELETE FROM ' .. prefix .. 'chirper_rechirps WHERE id = ?', {exists.id})
    else
        MySQL.insert.await('INSERT INTO ' .. prefix .. 'chirper_rechirps (chirp_id, user_id) VALUES (?, ?)', {
            chirpId,
            identity.citizenid
        })
    end

    refreshChirperForAll()
end

local function commentInternal(source, chirpId, content)
    local identity = getChirperIdentity(source)
    if not identity.citizenid or not chirpId then return end

    content = tostring(content or ''):sub(1, 220)
    if content == '' then return end

    MySQL.insert.await('INSERT INTO ' .. prefix .. 'chirper_comments (chirp_id, author, author_name, author_avatar, content) VALUES (?, ?, ?, ?, ?)', {
        chirpId,
        identity.citizenid,
        identity.name,
        identity.avatar,
        content
    })

    refreshChirperForAll()
    TriggerClientEvent('phone:chirper:commentsData', source, chirpId, fetchComments(chirpId))
end

local function openCommentsInternal(source, chirpId)
    if not chirpId then return end
    TriggerClientEvent('phone:chirper:commentsData', source, chirpId, fetchComments(chirpId))
end

local function openProfileInternal(source)
    local identity = getChirperIdentity(source)
    if not identity.citizenid then return end

    TriggerClientEvent('phone:chirper:profileData', source, fetchChirperProfile(identity.citizenid))
end

RegisterNetEvent('phone:chirper:post', function(payload)
    postChirpInternal(source, payload or {})
end)
RegisterNetEvent('phone:postChirp', function(payload)
    postChirpInternal(source, payload or {})
end)

RegisterNetEvent('phone:chirper:like', function(chirpId)
    toggleLikeInternal(source, tonumber(chirpId))
end)
RegisterNetEvent('phone:likeChirp', function(payload)
    toggleLikeInternal(source, tonumber(type(payload) == 'table' and payload.chirpId or payload))
end)

RegisterNetEvent('phone:chirper:rechirp', function(chirpId)
    toggleRechirpInternal(source, tonumber(chirpId))
end)
RegisterNetEvent('phone:rechirp', function(payload)
    toggleRechirpInternal(source, tonumber(type(payload) == 'table' and payload.chirpId or payload))
end)

RegisterNetEvent('phone:chirper:comment', function(payload)
    commentInternal(source, tonumber(payload and payload.chirpId), payload and payload.content)
end)
RegisterNetEvent('phone:commentChirp', function(payload)
    commentInternal(source, tonumber(payload and payload.chirpId), payload and payload.content)
end)

RegisterNetEvent('phone:chirper:comments', function(chirpId)
    openCommentsInternal(source, tonumber(chirpId))
end)
RegisterNetEvent('phone:getChirpComments', function(payload)
    openCommentsInternal(source, tonumber(type(payload) == 'table' and payload.chirpId or payload))
end)

RegisterNetEvent('phone:chirper:profile', function()
    openProfileInternal(source)
end)
