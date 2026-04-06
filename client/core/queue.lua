-- Queue System

PhoneQueue = {}
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
            if action then action() end
            Wait(100)
        end
        PhoneQueue.running = false
    end)
end
