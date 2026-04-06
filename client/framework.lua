--[[
    CLIENT FRAMEWORK
    Detecção e integração com frameworks
]]

Framework = {}

local fw = nil
local fwType = nil

-- ============================================
-- FRAMEWORK DETECTION
-- ============================================
Citizen.CreateThread(function()
    Wait(1000)
    
    if Config.Framework == 'auto' then
        -- ESX
        if GetResourceState('es_extended') == 'started' then
            fw = exports['es_extended']:getSharedObject()
            fwType = 'esx'
            print('[PHONE] Framework: ESX')
            
        -- QBCore
        elseif GetResourceState('qb-core') == 'started' then
            fw = exports['qb-core']:GetCoreObject()
            fwType = 'qbcore'
            print('[PHONE] Framework: QBCore')
            
        -- vRP
        elseif GetResourceState('vrp') == 'started' then
            Proxy = module("vrp", "lib/Proxy")
            fw = Proxy.getInterface("vRP")
            fwType = 'vrp'
            print('[PHONE] Framework: vRP')
            
        -- Standalone
        else
            fwType = 'standalone'
            print('[PHONE] Framework: Standalone')
        end
    else
        fwType = Config.Framework
    end
    
    -- Load player data
    Wait(2000)
    Framework.LoadPlayerData()
end)

-- ============================================
-- LOAD PLAYER DATA
-- ============================================
function Framework.LoadPlayerData()
    local data = {
        identifier = nil,
        name = GetPlayerName(PlayerId()),
        phone = SharedFunctions.GeneratePhoneNumber(),
        job = 'unemployed',
        money = 0,
        bank = 0
    }
    
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerData()
        data.identifier = xPlayer.identifier
        data.name = xPlayer.firstName and (xPlayer.firstName .. ' ' .. xPlayer.lastName) or data.name
        data.phone = xPlayer.phone_number or data.phone
        data.job = xPlayer.job and xPlayer.job.name or 'unemployed'
        data.money = xPlayer.money or 0
        data.bank = Framework.GetAccountMoney(xPlayer.accounts, 'bank')
        
    elseif fwType == 'qbcore' then
        local PlayerData = fw.Functions.GetPlayerData()
        data.identifier = PlayerData.citizenid
        data.name = PlayerData.charinfo and (PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname) or data.name
        data.phone = PlayerData.charinfo and PlayerData.charinfo.phone or data.phone
        data.job = PlayerData.job and PlayerData.job.name or 'unemployed'
        data.money = PlayerData.money and PlayerData.money.cash or 0
        data.bank = PlayerData.money and PlayerData.money.bank or 0
        
    elseif fwType == 'vrp' then
        local user_id = fw.getUserId()
        data.identifier = tostring(user_id)
        
    else
        data.identifier = tostring(GetPlayerServerId(PlayerId()))
    end
    
    PhoneData.playerData = data
    TriggerServerEvent('phone:playerLoaded', data)
end

-- ============================================
-- HELPERS
-- ============================================
function Framework.GetAccountMoney(accounts, accountName)
    if not accounts then return 0 end
    for _, account in ipairs(accounts) do
        if account.name == accountName then
            return account.money
        end
    end
    return 0
end

function Framework.HasItem(itemName)
    if fwType == 'esx' then
        local hasItem = false
        fw.TriggerServerCallback('esx_basicneeds:hasItem', function(has)
            hasItem = has
        end, itemName)
        Wait(100)
        return hasItem
    elseif fwType == 'qbcore' then
        return fw.Functions.HasItem(itemName)
    end
    return true
end

function Framework.Notify(message, type)
    if fwType == 'esx' then
        fw.ShowNotification(message)
    elseif fwType == 'qbcore' then
        fw.Functions.Notify(message, type)
    else
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, true)
    end
end

function Framework.GetJob()
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerData()
        return xPlayer.job and xPlayer.job.name or 'unemployed'
    elseif fwType == 'qbcore' then
        local PlayerData = fw.Functions.GetPlayerData()
        return PlayerData.job and PlayerData.job.name or 'unemployed'
    end
    return 'unemployed'
end

-- ============================================
-- FRAMEWORK TYPE GETTER
-- ============================================
function Framework.GetType()
    return fwType
end

function Framework.GetObject()
    return fw
end

-- Export
_G.Framework = Framework
