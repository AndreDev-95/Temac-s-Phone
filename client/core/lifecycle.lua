-- App Lifecycle Manager
PhoneLifecycle = PhoneLifecycle or {}

function PhoneLifecycle:Open(app)
    if PhoneLoading then PhoneLoading:Start() end
    if PhoneCore then PhoneCore:SetCurrentApp(app) end
    if PhoneEvents then PhoneEvents:Emit('app_open', app) end
    SetTimeout(150, function() if PhoneLoading then PhoneLoading:Stop() end end)
end

function PhoneLifecycle:Close(app)
    if PhoneEvents then PhoneEvents:Emit('app_close', app) end
    if PhoneCore and PhoneCore:GetCurrentApp() == app then PhoneCore:SetCurrentApp(nil) end
    if PhoneLoading then PhoneLoading:Stop() end
end
