-- Core Optimization
-- Prevent double open spam

local isOpening = false

function SafeTogglePhone(toggleFn)
    if isOpening then return end
    isOpening = true

    toggleFn()

    SetTimeout(500, function()
        isOpening = false
    end)
end
