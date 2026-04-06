--[[
    CLIENT APP: CHIRPER
    Rede social Chirper
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('postChirp', function(data, cb)
    TriggerServerEvent('phone:chirper:post', data.content, data.image)
    cb('ok')
end)

RegisterNUICallback('likeChirp', function(data, cb)
    TriggerServerEvent('phone:chirper:like', data.chirpId)
    cb('ok')
end)

RegisterNUICallback('unlikeChirp', function(data, cb)
    TriggerServerEvent('phone:chirper:unlike', data.chirpId)
    cb('ok')
end)

RegisterNUICallback('rechirp', function(data, cb)
    TriggerServerEvent('phone:chirper:rechirp', data.chirpId)
    cb('ok')
end)

RegisterNUICallback('deleteChirp', function(data, cb)
    TriggerServerEvent('phone:chirper:delete', data.chirpId)
    cb('ok')
end)

RegisterNUICallback('followChirper', function(data, cb)
    TriggerServerEvent('phone:chirper:follow', data.userId)
    cb('ok')
end)

RegisterNUICallback('unfollowChirper', function(data, cb)
    TriggerServerEvent('phone:chirper:unfollow', data.userId)
    cb('ok')
end)


RegisterNUICallback('getChirperProfile', function(data, cb)
    TriggerServerEvent('phone:chirper:profile', data.userId)
    cb('ok')
end)

RegisterNUICallback('searchChirperTag', function(data, cb)
    TriggerServerEvent('phone:chirper:tag', data.tag)
    cb('ok')
end)

-- ============================================
-- SERVER EVENTS
-- ============================================
RegisterNetEvent('phone:chirper:newChirp')
AddEventHandler('phone:chirper:newChirp', function(chirpData)
    SendNUIMessage({
        type = 'newChirp',
        chirp = chirpData
    })
end)

RegisterNetEvent('phone:chirper:profileData')
AddEventHandler('phone:chirper:profileData', function(profile)
    SendNUIMessage({ type = 'chirperProfileData', profile = profile })
end)

RegisterNetEvent('phone:chirper:tagData')
AddEventHandler('phone:chirper:tagData', function(tag, chirps)
    SendNUIMessage({ type = 'chirperTagData', tag = tag, chirps = chirps })
end)
