-- Permissions System

PhonePermissions = {}
PhonePermissions.apps = {}

function PhonePermissions:Set(app, allowed)
    self.apps[app] = allowed
end

function PhonePermissions:CanUse(app)
    return self.apps[app] ~= false
end
