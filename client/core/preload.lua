-- Preload System
PhonePreload = PhonePreload or {}

function PhonePreload:Load(app)
    print('[TEMAC PHONE] Preloading app: ' .. tostring(app))
end

function PhonePreload:Init(apps)
    for _, app in pairs(apps or {}) do self:Load(app) end
end
