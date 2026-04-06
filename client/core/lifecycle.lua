-- App Lifecycle Manager

PhoneLifecycle = {}

function PhoneLifecycle:Open(app)
    if PhoneLoading then PhoneLoading:Start() end
    if PhoneEvents then PhoneEvents:Emit('app_open', app) end
end

function PhoneLifecycle:Close(app)
    if PhoneEvents then PhoneEvents:Emit('app_close', app) end
    if PhoneLoading then PhoneLoading:Stop() end
end
