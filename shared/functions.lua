--[[
    SHARED FUNCTIONS
    Funções utilitárias compartilhadas
]]

SharedFunctions = {}

-- Generate random phone number
function SharedFunctions.GeneratePhoneNumber()
    return string.format("%03d-%04d", math.random(100, 999), math.random(1000, 9999))
end

-- Format money
function SharedFunctions.FormatMoney(amount)
    local formatted = tostring(math.floor(amount))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then break end
    end
    return "$" .. formatted .. ",00"
end

-- Format time ago
function SharedFunctions.TimeAgo(timestamp)
    if not timestamp then return '' end
    
    local now = os.time()
    local diff = now - timestamp
    
    if diff < 60 then return 'Agora' end
    if diff < 3600 then return math.floor(diff / 60) .. 'm' end
    if diff < 86400 then return math.floor(diff / 3600) .. 'h' end
    if diff < 604800 then return math.floor(diff / 86400) .. 'd' end
    
    return os.date('%d/%m', timestamp)
end

-- Format duration (seconds to mm:ss)
function SharedFunctions.FormatDuration(seconds)
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format('%02d:%02d', mins, secs)
end

-- Check if table contains value
function SharedFunctions.TableContains(table, value)
    for _, v in pairs(table) do
        if v == value then return true end
    end
    return false
end

-- Deep copy table
function SharedFunctions.DeepCopy(original)
    local copy
    if type(original) == 'table' then
        copy = {}
        for k, v in next, original, nil do
            copy[SharedFunctions.DeepCopy(k)] = SharedFunctions.DeepCopy(v)
        end
        setmetatable(copy, SharedFunctions.DeepCopy(getmetatable(original)))
    else
        copy = original
    end
    return copy
end

-- Sanitize string for SQL
function SharedFunctions.Sanitize(str)
    if not str then return '' end
    return str:gsub("'", "''"):gsub('"', '""')
end

-- Truncate string
function SharedFunctions.Truncate(str, maxLen)
    if not str then return '' end
    if #str <= maxLen then return str end
    return str:sub(1, maxLen - 3) .. '...'
end

-- Export
_G.SharedFunctions = SharedFunctions
