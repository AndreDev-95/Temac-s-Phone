-- Sync System

PhoneSync = {}

function PhoneSync:Request(event)
    TriggerServerEvent('phone:syncRequest', event)
end

function PhoneSync:Receive(event, data)
    if PhoneEvents then
        PhoneEvents:Emit(event, data)
    end
end
