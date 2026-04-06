-- Event Bus
PhoneEvents = PhoneEvents or {}
PhoneEvents.listeners = {}

function PhoneEvents:On(event, callback)
    if not self.listeners[event] then self.listeners[event] = {} end
    table.insert(self.listeners[event], callback)
end

function PhoneEvents:Emit(event, data)
    if not self.listeners[event] then return end
    for _, cb in pairs(self.listeners[event]) do
        SafeExecute(function() cb(data) end)
    end
end
