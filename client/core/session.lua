-- Session Memory
PhoneSession = PhoneSession or {}
PhoneSession.values = {}

function PhoneSession:SetValue(key, value) self.values[key] = value end
function PhoneSession:GetValue(key) return self.values[key] end
function PhoneSession:DeleteValue(key) self.values[key] = nil end
function PhoneSession:ClearAll() self.values = {} end
