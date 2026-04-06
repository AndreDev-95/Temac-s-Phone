--[[
    SERVER FRAMEWORK
    Integração com frameworks no servidor
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
        if GetResourceState('es_extended') == 'started' then
            fw = exports['es_extended']:getSharedObject()
            fwType = 'esx'
            print('[PHONE] Server Framework: ESX')
        elseif GetResourceState('qb-core') == 'started' then
            fw = exports['qb-core']:GetCoreObject()
            fwType = 'qbcore'
            print('[PHONE] Server Framework: QBCore')
        elseif GetResourceState('vrp') == 'started' then
            Proxy = module("vrp", "lib/Proxy")
            fw = Proxy.getInterface("vRP")
            fwType = 'vrp'
            print('[PHONE] Server Framework: vRP')
        else
            fwType = 'standalone'
            print('[PHONE] Server Framework: Standalone')
        end
    else
        fwType = Config.Framework
    end
end)

-- ============================================
-- GET PLAYER IDENTIFIER
-- ============================================
function Framework.GetIdentifier(source)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        return xPlayer and xPlayer.identifier or nil
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        return Player and Player.PlayerData.citizenid or nil
    elseif fwType == 'vrp' then
        return fw.getUserId(source)
    else
        for _, v in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, 5) == 'steam' then return v end
        end
        return tostring(source)
    end
end

-- ============================================
-- GET PLAYER PHONE NUMBER
-- ============================================
function Framework.GetPhone(source)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        return xPlayer and xPlayer.get('phone_number') or nil
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        return Player and Player.PlayerData.charinfo.phone or nil
    end
    return nil
end

-- ============================================
-- GET PLAYER BY PHONE
-- ============================================
function Framework.GetPlayerByPhone(phoneNumber)
    if fwType == 'esx' then
        local xPlayers = fw.GetPlayers()
        for _, playerId in ipairs(xPlayers) do
            local xPlayer = fw.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.get('phone_number') == phoneNumber then
                return playerId
            end
        end
    elseif fwType == 'qbcore' then
        local players = fw.Functions.GetPlayers()
        for _, playerId in ipairs(players) do
            local Player = fw.Functions.GetPlayer(playerId)
            if Player and Player.PlayerData.charinfo.phone == phoneNumber then
                return playerId
            end
        end
    end
    return nil
end

-- ============================================
-- MONEY FUNCTIONS
-- ============================================
function Framework.GetMoney(source)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        return xPlayer and xPlayer.getMoney() or 0
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        return Player and Player.PlayerData.money.cash or 0
    end
    return 0
end

function Framework.GetBank(source)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        return xPlayer and xPlayer.getAccount('bank').money or 0
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        return Player and Player.PlayerData.money.bank or 0
    end
    return 0
end

function Framework.AddMoney(source, amount)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        if xPlayer then xPlayer.addMoney(amount) end
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        if Player then Player.Functions.AddMoney('cash', amount) end
    end
end

function Framework.RemoveMoney(source, amount)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        if xPlayer then xPlayer.removeMoney(amount) end
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        if Player then Player.Functions.RemoveMoney('cash', amount) end
    end
end

function Framework.AddBank(source, amount)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        if xPlayer then xPlayer.addAccountMoney('bank', amount) end
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        if Player then Player.Functions.AddMoney('bank', amount) end
    end
end

function Framework.RemoveBank(source, amount)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        if xPlayer then xPlayer.removeAccountMoney('bank', amount) end
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        if Player then Player.Functions.RemoveMoney('bank', amount) end
    end
end

-- ============================================
-- JOB FUNCTIONS
-- ============================================
function Framework.GetJob(source)
    if fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(source)
        return xPlayer and xPlayer.job.name or 'unemployed'
    elseif fwType == 'qbcore' then
        local Player = fw.Functions.GetPlayer(source)
        return Player and Player.PlayerData.job.name or 'unemployed'
    end
    return 'unemployed'
end

function Framework.GetPlayersByJob(jobName)
    local players = {}
    if fwType == 'esx' then
        local xPlayers = fw.GetPlayers()
        for _, playerId in ipairs(xPlayers) do
            local xPlayer = fw.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.job.name == jobName then
                table.insert(players, playerId)
            end
        end
    elseif fwType == 'qbcore' then
        local allPlayers = fw.Functions.GetPlayers()
        for _, playerId in ipairs(allPlayers) do
            local Player = fw.Functions.GetPlayer(playerId)
            if Player and Player.PlayerData.job.name == jobName then
                table.insert(players, playerId)
            end
        end
    end
    return players
end

-- ============================================
-- GETTERS
-- ============================================
function Framework.GetType()
    return fwType
end

function Framework.GetObject()
    return fw
end

-- Export
_G.Framework = Framework
