-- Queue System
PhoneQueue = PhoneQueue or {}
PhoneQueue.queue = {}
PhoneQueue.running = false

function PhoneQueue:Add(action)
    table.insert(self.queue, action)
    self:Run()
end

function PhoneQueue:Run()
    if self.running then return end
    self.running = true
    CreateThread(function()
        while #PhoneQueue.queue > 0 do
            local action = table.remove(PhoneQueue.queue, 1)
            SafeExecute(function() if action then action() end end)
            Wait(75)
        end
        PhoneQueue.running = false
    end)
end
