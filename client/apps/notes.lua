--[[
    CLIENT APP: NOTES
    Notas do celular
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('saveNote', function(data, cb)
    TriggerServerEvent('phone:notes:save', data.id, data.title, data.content)
    cb('ok')
end)

RegisterNUICallback('deleteNote', function(data, cb)
    TriggerServerEvent('phone:notes:delete', data.id)
    cb('ok')
end)
