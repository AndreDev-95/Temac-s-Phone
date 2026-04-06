--[[
    CLIENT APP: SERVICES
    Serviços (Táxi, Mecânico, Polícia, Ambulância)
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('callTaxi', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('phone:service:taxi', {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
    cb('ok')
end)

RegisterNUICallback('callMechanic', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('phone:service:mechanic', {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
    cb('ok')
end)

RegisterNUICallback('callPolice', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('phone:service:police', data.message, {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
    cb('ok')
end)

RegisterNUICallback('callAmbulance', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('phone:service:ambulance', {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
    cb('ok')
end)

-- ============================================
-- GPS / MAPS
-- ============================================
RegisterNUICallback('setWaypoint', function(data, cb)
    SetNewWaypoint(data.x, data.y)
    Framework.Notify('Waypoint definido!', 'success')
    cb('ok')
end)

-- Preset locations
local presetLocations = {
    hospital = { x = 340.0, y = -1396.0 },
    police = { x = 425.0, y = -980.0 },
    garage = { x = -285.0, y = -886.0 },
    bank = { x = 150.0, y = -1040.0 }
}

RegisterNUICallback('setPresetWaypoint', function(data, cb)
    local loc = presetLocations[data.type]
    if loc then
        SetNewWaypoint(loc.x, loc.y)
        Framework.Notify('Waypoint definido!', 'success')
    end
    cb('ok')
end)

-- ============================================
-- SERVER EVENTS
-- ============================================
RegisterNetEvent('phone:service:request')
AddEventHandler('phone:service:request', function(service, callerData)
    SendNUIMessage({
        type = 'serviceRequest',
        service = service,
        caller = callerData
    })
    
    -- Set waypoint to caller
    SetNewWaypoint(callerData.coords.x, callerData.coords.y)
end)
