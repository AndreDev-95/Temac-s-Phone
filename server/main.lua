--[[
    SERVER MAIN
    Controle principal do servidor
]]

-- Player data cache
PlayerCache = {}

-- ============================================
-- PLAYER LOADED
-- ============================================
RegisterNetEvent('phone:playerLoaded')
AddEventHandler('phone:playerLoaded', function(data)
    local source = source
    PlayerCache[source] = data
end)

-- ============================================
-- REQUEST ALL DATA
-- ============================================
RegisterNetEvent('phone:requestAllData')
AddEventHandler('phone:requestAllData', function()
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    if not identifier then return end
    
    -- Send all data
    SendContacts(source, identifier)
    SendMessages(source, identifier)
    SendChirper(source, identifier)
    SendPictura(source, identifier)
    SendFlamer(source, identifier)
    SendGallery(source, identifier)
    SendNotes(source, identifier)
    SendCalls(source, identifier)
    SendEmails(source, identifier)
    SendBank(source)
    SendInstalledApps(source, identifier)
end)

-- ============================================
-- HELPER FUNCTIONS
-- ============================================
function SendContacts(source, identifier)
    local contacts = MySQL.query.await('SELECT * FROM phone_contacts WHERE owner = ? ORDER BY name', {identifier})
    TriggerClientEvent('phone:receiveData', source, 'contacts', contacts or {})
end

function SendMessages(source, identifier)
    local prefix = Config.Database.prefix
    local phoneNumber = Framework.GetPhone(source)

    if not phoneNumber then
        TriggerClientEvent('phone:receiveData', source, 'messages', {})
        return
    end

    local messages = MySQL.query.await(([[
        SELECT m.*, COALESCE(c.name, m.sender) as sender_name
        FROM %smessages m
        LEFT JOIN %scontacts c ON c.owner = ? AND c.number = m.sender
        WHERE m.sender = ? OR m.receiver = ?
        ORDER BY m.created_at DESC LIMIT 200
    ]]):format(prefix, prefix), {identifier, phoneNumber, phoneNumber}) or {}

    TriggerClientEvent('phone:receiveData', source, 'messages', messages)
end

function SendChirper(source, identifier)
    local prefix = Config.Database.prefix
    local chirps = MySQL.query.await(([[
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
    ]]):format(prefix, prefix, prefix, prefix, prefix, prefix), {identifier, identifier, Config.Chirper.maxTweets})

    TriggerClientEvent('phone:receiveData', source, 'chirper', chirps or {})
end

function SendPictura(source, identifier)
    local posts = MySQL.query.await('SELECT * FROM phone_pictura ORDER BY created_at DESC LIMIT ?', {Config.Pictura.maxPosts})
    local stories = MySQL.query.await('SELECT * FROM phone_pictura_stories WHERE created_at > DATE_SUB(NOW(), INTERVAL ? HOUR)', {Config.Pictura.storyDuration})
    TriggerClientEvent('phone:receiveData', source, 'instagram', {posts = posts or {}, stories = stories or {}})
end

function SendFlamer(source, identifier)
    local profile = MySQL.query.await('SELECT * FROM phone_flamer_profiles WHERE user_id = ?', {identifier})
    local profiles = MySQL.query.await([[
        SELECT p.* FROM phone_flamer_profiles p
        WHERE p.user_id != ? AND p.active = TRUE
        AND p.user_id NOT IN (SELECT swiped FROM phone_flamer_swipes WHERE swiper = ?)
        LIMIT ?
    ]], {identifier, identifier, Config.Flamer.maxProfiles})
    local matches = MySQL.query.await([[
        SELECT m.*, p.name, p.photos, p.bio FROM phone_flamer_matches m
        JOIN phone_flamer_profiles p ON ((m.user1 = ? AND p.user_id = m.user2) OR (m.user2 = ? AND p.user_id = m.user1))
        ORDER BY m.created_at DESC
    ]], {identifier, identifier})
    
    TriggerClientEvent('phone:receiveData', source, 'tinder', {
        profile = profile and profile[1] or nil,
        profiles = profiles or {},
        matches = matches or {}
    })
end

function SendGallery(source, identifier)
    local photos = MySQL.query.await('SELECT * FROM phone_gallery WHERE owner = ? ORDER BY created_at DESC', {identifier})
    TriggerClientEvent('phone:receiveData', source, 'gallery', photos or {})
end

function SendNotes(source, identifier)
    local notes = MySQL.query.await('SELECT * FROM phone_notes WHERE owner = ? ORDER BY updated_at DESC', {identifier})
    TriggerClientEvent('phone:receiveData', source, 'notes', notes or {})
end

function SendCalls(source, identifier)
    local calls = MySQL.query.await([[
        SELECT c.*, COALESCE(cont.name, c.caller) as caller_name FROM phone_calls c
        LEFT JOIN phone_contacts cont ON cont.owner = ? AND cont.number = c.caller
        WHERE c.caller = ? OR c.receiver = ? ORDER BY c.created_at DESC LIMIT 50
    ]], {identifier, identifier, identifier})
    TriggerClientEvent('phone:receiveData', source, 'calls', calls or {})
end

function SendBank(source)
    local cash = Framework.GetMoney(source)
    local bank = Framework.GetBank(source)
    TriggerClientEvent('phone:receiveData', source, 'bank', {cash = cash, bank = bank})
end

-- ============================================
-- CLEANUP
-- ============================================
AddEventHandler('playerDropped', function()
    local source = source
    PlayerCache[source] = nil
end)
