--[[
    SERVER APP: BANK
    App bancário Maze Bank
]]

-- ============================================
-- DEPOSIT
-- ============================================
RegisterNetEvent('phone:bank:deposit')
AddEventHandler('phone:bank:deposit', function(amount)
    local source = source
    amount = tonumber(amount)
    
    if not amount or amount <= 0 then return end
    
    local cash = Framework.GetMoney(source)
    if cash >= amount then
        Framework.RemoveMoney(source, amount)
        Framework.AddBank(source, amount)
        
        TriggerClientEvent('phone:updateBalance', source, Framework.GetMoney(source), Framework.GetBank(source))
        TriggerClientEvent('phone:notification', source, 'Banco', 'Depósito de $' .. amount .. ' realizado!', 'bank')
    else
        TriggerClientEvent('phone:notification', source, 'Banco', 'Dinheiro insuficiente!', 'bank')
    end
end)

-- ============================================
-- WITHDRAW
-- ============================================
RegisterNetEvent('phone:bank:withdraw')
AddEventHandler('phone:bank:withdraw', function(amount)
    local source = source
    amount = tonumber(amount)
    
    if not amount or amount <= 0 then return end
    
    local bank = Framework.GetBank(source)
    if bank >= amount then
        Framework.RemoveBank(source, amount)
        Framework.AddMoney(source, amount)
        
        TriggerClientEvent('phone:updateBalance', source, Framework.GetMoney(source), Framework.GetBank(source))
        TriggerClientEvent('phone:notification', source, 'Banco', 'Saque de $' .. amount .. ' realizado!', 'bank')
    else
        TriggerClientEvent('phone:notification', source, 'Banco', 'Saldo insuficiente!', 'bank')
    end
end)

-- ============================================
-- TRANSFER
-- ============================================
RegisterNetEvent('phone:bank:transfer')
AddEventHandler('phone:bank:transfer', function(toAccount, amount, note)
    local source = source
    amount = tonumber(amount)
    
    if not amount or amount <= 0 then return end
    if amount > Config.Bank.maxTransferAmount then
        TriggerClientEvent('phone:notification', source, 'Banco', 'Valor máximo excedido!', 'bank')
        return
    end
    
    local bank = Framework.GetBank(source)
    if bank < amount then
        TriggerClientEvent('phone:notification', source, 'Banco', 'Saldo insuficiente!', 'bank')
        return
    end
    
    -- Find receiver
    local receiverSource = Framework.GetPlayerByPhone(toAccount)
    
    if receiverSource then
        Framework.RemoveBank(source, amount)
        Framework.AddBank(receiverSource, amount)
        
        TriggerClientEvent('phone:updateBalance', source, Framework.GetMoney(source), Framework.GetBank(source))
        TriggerClientEvent('phone:updateBalance', receiverSource, Framework.GetMoney(receiverSource), Framework.GetBank(receiverSource))
        
        TriggerClientEvent('phone:notification', source, 'Banco', 'Transferência de $' .. amount .. ' realizada!', 'bank')
        TriggerClientEvent('phone:notification', receiverSource, 'Banco', 'Você recebeu $' .. amount, 'bank')
    else
        TriggerClientEvent('phone:notification', source, 'Banco', 'Conta não encontrada!', 'bank')
    end
end)


-- ============================================
-- OVERVIEW / HISTORY
-- ============================================
RegisterNetEvent('phone:bank:overview')
AddEventHandler('phone:bank:overview', function()
    local source = source
    local history = {
        { title = 'Saldo disponível', amount = Framework.GetBank(source), type = 'info' },
        { title = 'Dinheiro em mão', amount = Framework.GetMoney(source), type = 'info' }
    }
    TriggerClientEvent('phone:bank:historyData', source, history)
    TriggerClientEvent('phone:updateBalance', source, Framework.GetMoney(source), Framework.GetBank(source))
end)
