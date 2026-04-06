--[[
    CLIENT APP: PHONE (Calls)
    Sistema de chamadas telefônicas
]]

local currentCall = nil

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('makeCall', function(data, cb)
    TriggerServerEvent('phone:call:make', data.number)
    cb('ok')
end)

RegisterNUICallback('answerCall', function(data, cb)
    TriggerServerEvent('phone:call:answer', currentCall.callId)
    cb('ok')
end)

RegisterNUICallback('declineCall', function(data, cb)
    TriggerServerEvent('phone:call:decline', currentCall.callId)
    currentCall = nil
    cb('ok')
end)

RegisterNUICallback('endCall', function(data, cb)
    TriggerServerEvent('phone:call:end', currentCall.callId)
    currentCall = nil
    cb('ok')
end)

-- ============================================
-- SERVER EVENTS
-- ============================================
RegisterNetEvent('phone:call:incoming')
AddEventHandler('phone:call:incoming', function(callerData)
    currentCall = callerData
    
    if not PhoneData.isOpen then
        OpenPhone()
    end
    
    SendNUIMessage({
        type = 'incomingCall',
        caller = callerData
    })
    
    PlaySound(-1, 'Phone_Ring', 'Phone_SoundSet_Michael', 0, 0, 1)
end)

RegisterNetEvent('phone:call:connected')
AddEventHandler('phone:call:connected', function(callId)
    SendNUIMessage({
        type = 'callConnected',
        callId = callId
    })
end)

RegisterNetEvent('phone:call:ended')
AddEventHandler('phone:call:ended', function(callId)
    currentCall = nil
    SendNUIMessage({
        type = 'callEnded',
        callId = callId
    })
end)
