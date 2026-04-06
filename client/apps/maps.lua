--[[
    CLIENT APP: MAPS
    GPS e Mapas
]]

-- Preset locations for quick waypoints
local PresetLocations = {
    hospital = { x = 340.0, y = -1396.0, z = 32.5, name = 'Hospital Central' },
    police = { x = 425.0, y = -980.0, z = 30.7, name = 'Delegacia LSPD' },
    garage = { x = -285.0, y = -886.0, z = 31.0, name = 'Garagem LS' },
    bank = { x = 150.0, y = -1040.0, z = 29.4, name = 'Maze Bank' },
    airport = { x = -1037.0, y = -2737.0, z = 20.2, name = 'Aeroporto LSX' },
    beach = { x = -1616.0, y = -1036.0, z = 13.0, name = 'Del Perro Beach' },
    casino = { x = 924.0, y = 46.0, z = 81.0, name = 'Diamond Casino' },
    pier = { x = -1850.0, y = -1231.0, z = 13.0, name = 'Del Perro Pier' }
}

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('setWaypoint', function(data, cb)
    SetNewWaypoint(data.x, data.y)
    Framework.Notify('Waypoint definido!')
    cb('ok')
end)

RegisterNUICallback('setPresetWaypoint', function(data, cb)
    local loc = PresetLocations[data.type]
    if loc then
        SetNewWaypoint(loc.x, loc.y)
        Framework.Notify('GPS: ' .. loc.name)
    end
    cb('ok')
end)

RegisterNUICallback('getPlayerLocation', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetNameStr = GetStreetNameFromHashKey(streetName)
    
    cb({
        x = coords.x,
        y = coords.y,
        z = coords.z,
        street = streetNameStr
    })
end)

RegisterNUICallback('getPresetLocations', function(data, cb)
    cb(PresetLocations)
end)
