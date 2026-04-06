-- Sync System
PhoneSync = PhoneSync or {}

function PhoneSync:Request(event, payload)
    TriggerServerEvent('phone:syncRequest', event, payload)
end

function PhoneSync:Receive(event, data)
    if PhoneEvents then PhoneEvents:Emit(event, data) end
end
