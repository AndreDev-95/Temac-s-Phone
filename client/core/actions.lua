-- Action Guard System

PhoneActions = {}

function PhoneActions:Execute(action)
    if PhoneCore and not PhoneCore:CanOpen() then
        return false
    end

    if PhoneLoading and PhoneLoading:IsActive() then
        return false
    end

    if action then
        action()
        return true
    end

    return false
end
