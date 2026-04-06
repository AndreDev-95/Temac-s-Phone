--[[
    CLIENT APP: PICTURA
    Rede social Pictura
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('postPictura', function(data, cb)
    TriggerServerEvent('phone:pictura:post', data.image, data.caption, data.filters)
    cb('ok')
end)

RegisterNUICallback('likePictura', function(data, cb)
    TriggerServerEvent('phone:pictura:like', data.postId)
    cb('ok')
end)

RegisterNUICallback('commentPictura', function(data, cb)
    TriggerServerEvent('phone:pictura:comment', data.postId, data.comment)
    cb('ok')
end)

RegisterNUICallback('followPictura', function(data, cb)
    TriggerServerEvent('phone:pictura:follow', data.userId)
    cb('ok')
end)

RegisterNUICallback('unfollowPictura', function(data, cb)
    TriggerServerEvent('phone:pictura:unfollow', data.userId)
    cb('ok')
end)

RegisterNUICallback('postStory', function(data, cb)
    TriggerServerEvent('phone:pictura:story', data.image)
    cb('ok')
end)

RegisterNUICallback('deletePost', function(data, cb)
    TriggerServerEvent('phone:pictura:delete', data.postId)
    cb('ok')
end)
