--[[
    CLIENT APP: GALLERY
    Galeria de fotos
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('deletePhoto', function(data, cb)
    TriggerServerEvent('phone:gallery:delete', data.id)
    cb('ok')
end)
