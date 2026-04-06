--[[
    CLIENT APP: BANK
    App bancário Maze Bank
]]

-- ============================================
-- NUI CALLBACKS
RegisterNUICallback('requestBankOverview', function(data, cb)
    TriggerServerEvent('phone:bank:overview')
    cb('ok')
end)

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

RegisterNetEvent('phone:bank:historyData')
AddEventHandler('phone:bank:historyData', function(history)
    SendNUIMessage({ type = 'bankHistoryData', history = history })
end)
