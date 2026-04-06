--[[
    CLIENT MAIN
    Controle principal do celular no client
]]

-- State
PhoneData = {
    isOpen = false,
    playerData = {},
    settings = {}
}

-- Phone prop reference
local phoneProp = nil

-- ============================================
-- COMMANDS & KEYBINDS
-- ============================================
RegisterCommand('phone', function()
    SafeExecute(function()
        SafeTogglePhone(function()
            TogglePhone()
        end)
    end)
end, false)

RegisterKeyMapping('phone', 'Abrir Celular', 'keyboard', Config.OpenKey)

-- ============================================
-- TOGGLE PHONE
-- ============================================
function TogglePhone()
    if PhoneData.isOpen then
        ClosePhone()
    else
        if PhoneActions then
            PhoneActions:Execute(function()
                OpenPhone()
            end)
        else
            OpenPhone()
        end
    end
end

-- ============================================
-- OPEN PHONE
-- ============================================
function OpenPhone()
    if PhoneCore and not PhoneCore:CanOpen() then return end
    if PhoneLoading then PhoneLoading:Start() end
    -- Check if player has phone item
    if Config.RequireItem and not Framework.HasItem(Config.PhoneItem) then
        Framework.Notify(_U('no_phone'), 'error')
        return
    end
    
    PhoneData.isOpen = true
    SetNuiFocus(true, true)
    
    -- Play animation
    PlayPhoneAnimation(true)
    
    -- Attach phone prop
    AttachPhoneProp()
    
    -- Send to NUI
    SendNUIMessage({
        type = 'openPhone',
        playerData = PhoneData.playerData,
        time = GetGameTime(),
        settings = PhoneData.settings
    })
    
    -- Request data from server
    TriggerServerEvent('phone:requestAllData')
    if PhoneLifecycle then PhoneLifecycle:Open('home') end
    if PhonePreload then PhonePreload:Init({'messages', 'chirper', 'bank'}) end
    SetTimeout(250, function()
        if PhoneLoading then PhoneLoading:Stop() end
    end)
end

-- ============================================
-- CLOSE PHONE
-- ============================================
function ClosePhone()
    if PhoneLifecycle then PhoneLifecycle:Close(PhoneCore and PhoneCore:GetCurrentApp() or 'home') end
    PhoneData.isOpen = false
    SetNuiFocus(false, false)
    
    -- Stop animation
    PlayPhoneAnimation(false)
    
    -- Remove phone prop
    RemovePhoneProp()
    
    -- Send to NUI
    SendNUIMessage({
        type = 'closePhone'
    })
end

-- ============================================
-- PHONE ANIMATION
-- ============================================
function PlayPhoneAnimation(open)
    local ped = PlayerPedId()
    
    if open then
        RequestAnimDict('cellphone@')
        while not HasAnimDictLoaded('cellphone@') do
            Wait(10)
        end
        TaskPlayAnim(ped, 'cellphone@', 'cellphone_text_in', 8.0, -8.0, -1, 50, 0, false, false, false)
    else
        StopAnimTask(ped, 'cellphone@', 'cellphone_text_in', 1.0)
    end
end

-- ============================================
-- PHONE PROP
-- ============================================
function AttachPhoneProp()
    local ped = PlayerPedId()
    local phoneModel = GetHashKey('prop_npc_phone_02')
    
    RequestModel(phoneModel)
    while not HasModelLoaded(phoneModel) do
        Wait(10)
    end
    
    local bone = GetPedBoneIndex(ped, 28422)
    phoneProp = CreateObject(phoneModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(phoneProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 2, true)
end

function RemovePhoneProp()
    if phoneProp then
        DeleteObject(phoneProp)
        phoneProp = nil
    end
end

-- ============================================
-- HELPERS
-- ============================================
function GetGameTime()
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    return string.format('%02d:%02d', hour, minute)
end

-- ============================================
-- EXPORTS
-- ============================================
exports('OpenPhone', OpenPhone)
exports('ClosePhone', ClosePhone)
exports('IsPhoneOpen', function() return PhoneData.isOpen end)
exports('GetPlayerData', function() return PhoneData.playerData end)

-- ============================================
-- CLEANUP
-- ============================================
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if PhoneData.isOpen then
            ClosePhone()
        end
        RemovePhoneProp()
    end
end)
