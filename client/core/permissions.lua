-- Permissions System
PhonePermissions = PhonePermissions or {}
PhonePermissions.apps = {}

function PhonePermissions:Set(app, allowed) self.apps[app] = allowed end
function PhonePermissions:CanUse(app) return self.apps[app] ~= false end
