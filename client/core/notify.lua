-- Notification Manager
PhoneNotify = PhoneNotify or {}

function PhoneNotify:Send(title, message, icon)
    SendNUIMessage({ type = 'notification', title = title, message = message, icon = icon or 'phone' })
end
