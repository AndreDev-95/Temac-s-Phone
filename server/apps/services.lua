--[[
    SERVER APP: SERVICES
    Serviços (Táxi, Mecânico, Polícia, Ambulância)
]]

-- ============================================
-- TAXI
-- ============================================
RegisterNetEvent('phone:service:taxi')
AddEventHandler('phone:service:taxi', function(coords)
    local source = source
    local playerName = GetPlayerName(source)
    
    local drivers = Framework.GetPlayersByJob(Config.Services.taxi.jobName)
    for _, driverId in ipairs(drivers) do
        TriggerClientEvent('phone:notification', driverId, 'Táxi', playerName .. ' precisa de táxi!', 'taxi')
        TriggerClientEvent('phone:service:request', driverId, 'taxi', {
            caller = playerName,
            callerId = source,
            coords = coords
        })
    end
    
    if #drivers > 0 then
        TriggerClientEvent('phone:notification', source, 'Táxi', 'Táxi chamado! Aguarde...', 'taxi')
    else
        TriggerClientEvent('phone:notification', source, 'Táxi', 'Nenhum táxi disponível!', 'taxi')
    end
end)

-- ============================================
-- MECHANIC
-- ============================================
RegisterNetEvent('phone:service:mechanic')
AddEventHandler('phone:service:mechanic', function(coords)
    local source = source
    local playerName = GetPlayerName(source)
    
    local mechanics = Framework.GetPlayersByJob(Config.Services.mechanic.jobName)
    for _, mechanicId in ipairs(mechanics) do
        TriggerClientEvent('phone:notification', mechanicId, 'Mecânico', playerName .. ' precisa de mecânico!', 'mechanic')
        TriggerClientEvent('phone:service:request', mechanicId, 'mechanic', {
            caller = playerName,
            callerId = source,
            coords = coords
        })
    end
    
    if #mechanics > 0 then
        TriggerClientEvent('phone:notification', source, 'Mecânico', 'Mecânico chamado!', 'mechanic')
    else
        TriggerClientEvent('phone:notification', source, 'Mecânico', 'Nenhum mecânico disponível!', 'mechanic')
    end
end)

-- ============================================
-- POLICE (911)
-- ============================================
RegisterNetEvent('phone:service:police')
AddEventHandler('phone:service:police', function(message, coords)
    local source = source
    local playerName = GetPlayerName(source)
    
    local officers = Framework.GetPlayersByJob(Config.Services.police.jobName)
    for _, officerId in ipairs(officers) do
        TriggerClientEvent('phone:notification', officerId, '🚨 911', message or 'Chamada de emergência!', 'police')
        TriggerClientEvent('phone:service:request', officerId, 'police', {
            caller = playerName,
            callerId = source,
            coords = coords,
            message = message
        })
    end
    
    TriggerClientEvent('phone:notification', source, '911', 'Polícia notificada!', 'police')
end)

-- ============================================
-- AMBULANCE (EMS)
-- ============================================
RegisterNetEvent('phone:service:ambulance')
AddEventHandler('phone:service:ambulance', function(coords)
    local source = source
    local playerName = GetPlayerName(source)
    
    local medics = Framework.GetPlayersByJob(Config.Services.ambulance.jobName)
    for _, medicId in ipairs(medics) do
        TriggerClientEvent('phone:notification', medicId, '🚑 EMS', playerName .. ' precisa de ajuda médica!', 'ambulance')
        TriggerClientEvent('phone:service:request', medicId, 'ambulance', {
            caller = playerName,
            callerId = source,
            coords = coords
        })
    end
    
    if #medics > 0 then
        TriggerClientEvent('phone:notification', source, 'EMS', 'Ambulância notificada!', 'ambulance')
    else
        TriggerClientEvent('phone:notification', source, 'EMS', 'Nenhum médico disponível!', 'ambulance')
    end
end)
