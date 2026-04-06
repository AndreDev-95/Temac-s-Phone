-- Preload System

PhonePreload = {}

function PhonePreload:Load(app)
    print('[PHONE] Preloading app: ' .. app)
end

function PhonePreload:Init(apps)
    for _, app in pairs(apps) do
        self:Load(app)
    end
end
