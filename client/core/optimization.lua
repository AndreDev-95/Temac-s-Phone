-- Core Optimization
local isOpening = false

function SafeTogglePhone(toggleFn)
    if isOpening then return false end
    isOpening = true
    toggleFn()
    SetTimeout(500, function() isOpening = false end)
    return true
end
