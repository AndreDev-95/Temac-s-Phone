-- Error Handler
PhoneError = PhoneError or {}

function PhoneError:Handle(err)
    print('[TEMAC PHONE ERROR] ' .. tostring(err))
end

function SafeExecute(fn)
    local success, err = pcall(fn)
    if not success then PhoneError:Handle(err) end
end
