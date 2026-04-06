--[[
    CLIENT APP: BANK
    App bancário Maze Bank
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('bankDeposit', function(data, cb)
    TriggerServerEvent('phone:bank:deposit', data.amount)
    cb('ok')
end)

RegisterNUICallback('bankWithdraw', function(data, cb)
    TriggerServerEvent('phone:bank:withdraw', data.amount)
    cb('ok')
end)

RegisterNUICallback('bankTransfer', function(data, cb)
    TriggerServerEvent('phone:bank:transfer', data.to, data.amount, data.note)
    cb('ok')
end)

RegisterNUICallback('getTransactionHistory', function(data, cb)
    TriggerServerEvent('phone:bank:history')
    cb('ok')
end)
