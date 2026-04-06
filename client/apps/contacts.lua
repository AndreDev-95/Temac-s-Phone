--[[
    CLIENT APP: CONTACTS
    Gerenciamento de contatos
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('addContact', function(data, cb)
    TriggerServerEvent('phone:contacts:add', data.name, data.number, data.avatar)
    cb('ok')
end)

RegisterNUICallback('editContact', function(data, cb)
    TriggerServerEvent('phone:contacts:edit', data.id, data.name, data.number, data.avatar)
    cb('ok')
end)

RegisterNUICallback('deleteContact', function(data, cb)
    TriggerServerEvent('phone:contacts:delete', data.id)
    cb('ok')
end)

RegisterNUICallback('favoriteContact', function(data, cb)
    TriggerServerEvent('phone:contacts:favorite', data.id, data.favorite)
    cb('ok')
end)
