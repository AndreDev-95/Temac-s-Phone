--[[
    CLIENT APP: FLAMER
    App de relacionamentos
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('swipeFlamer', function(data, cb)
    TriggerServerEvent('phone:flamer:swipe', data.profileId, data.direction)
    cb('ok')
end)

RegisterNUICallback('superLike', function(data, cb)
    TriggerServerEvent('phone:flamer:superlike', data.profileId)
    cb('ok')
end)

RegisterNUICallback('updateFlamerProfile', function(data, cb)
    TriggerServerEvent('phone:flamer:updateProfile', data)
    cb('ok')
end)

RegisterNUICallback('sendFlamerMessage', function(data, cb)
    TriggerServerEvent('phone:flamer:message', data.matchId, data.message)
    cb('ok')
end)

RegisterNUICallback('unmatch', function(data, cb)
    TriggerServerEvent('phone:flamer:unmatch', data.matchId)
    cb('ok')
end)

-- ============================================
-- SERVER EVENTS
-- ============================================
RegisterNetEvent('phone:flamer:match')
AddEventHandler('phone:flamer:match', function(matchData)
    SendNUIMessage({
        type = 'flamerMatch',
        match = matchData
    })
    
    Framework.Notify(_U('its_a_match'), 'success')
end)

RegisterNetEvent('phone:flamer:newMessage')
AddEventHandler('phone:flamer:newMessage', function(messageData)
    SendNUIMessage({
        type = 'flamerMessage',
        message = messageData
    })
end)
