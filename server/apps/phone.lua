--[[
    SERVER APP: PHONE (Calls)
    Sistema de chamadas telefônicas
]]

local activeCalls = {}

-- ============================================
-- MAKE CALL
-- ============================================
RegisterNetEvent('phone:call:make')
AddEventHandler('phone:call:make', function(number)
    local source = source
    local callerPhone = Framework.GetPhone(source) or Framework.GetIdentifier(source)
    local receiverSource = Framework.GetPlayerByPhone(number)
    
    if receiverSource then
        local callId = #activeCalls + 1
        activeCalls[callId] = {
            id = callId,
            caller = source,
            receiver = receiverSource,
            callerPhone = callerPhone,
            receiverPhone = number,
            startTime = os.time(),
            status = 'ringing'
        }
        
        TriggerClientEvent('phone:call:incoming', receiverSource, {
            callId = callId,
            callerNumber = callerPhone,
            callerName = GetPlayerName(source)
        })
        
        TriggerClientEvent('phone:notification', source, 'Chamando...', number, 'phone')
    else
        TriggerClientEvent('phone:notification', source, 'Erro', 'Número offline', 'phone')
        
        MySQL.insert('INSERT INTO phone_calls (caller, receiver, status) VALUES (?, ?, ?)',
            {callerPhone, number, 'failed'})
    end
end)

-- ============================================
-- ANSWER CALL
-- ============================================
RegisterNetEvent('phone:call:answer')
AddEventHandler('phone:call:answer', function(callId)
    local call = activeCalls[callId]
    if call then
        call.status = 'active'
        call.answerTime = os.time()
        
        TriggerClientEvent('phone:call:connected', call.caller, callId)
        TriggerClientEvent('phone:call:connected', call.receiver, callId)
    end
end)

-- ============================================
-- DECLINE CALL
-- ============================================
RegisterNetEvent('phone:call:decline')
AddEventHandler('phone:call:decline', function(callId)
    local call = activeCalls[callId]
    if call then
        MySQL.insert('INSERT INTO phone_calls (caller, receiver, status) VALUES (?, ?, ?)',
            {call.callerPhone, call.receiverPhone, 'declined'})
        
        TriggerClientEvent('phone:call:ended', call.caller, callId)
        activeCalls[callId] = nil
    end
end)

-- ============================================
-- END CALL
-- ============================================
RegisterNetEvent('phone:call:end')
AddEventHandler('phone:call:end', function(callId)
    local call = activeCalls[callId]
    if call then
        local duration = call.answerTime and (os.time() - call.answerTime) or 0
        local status = call.answerTime and 'completed' or 'missed'
        
        MySQL.insert('INSERT INTO phone_calls (caller, receiver, duration, status) VALUES (?, ?, ?, ?)',
            {call.callerPhone, call.receiverPhone, duration, status})
        
        TriggerClientEvent('phone:call:ended', call.caller, callId)
        TriggerClientEvent('phone:call:ended', call.receiver, callId)
        
        activeCalls[callId] = nil
    end
end)
