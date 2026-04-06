-- Notification Manager

PhoneNotify = {}

function PhoneNotify:Send(title, message)
    SendNUIMessage({
        type = 'notification',
        title = title,
        message = message
    })
end
