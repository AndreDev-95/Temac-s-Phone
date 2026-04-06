--[[
    CLIENT APP: WEATHER
    Clima (integração com clima do jogo)
]]

-- ============================================
-- NUI CALLBACKS
-- ============================================
RegisterNUICallback('getWeather', function(data, cb)
    local weather = GetPrevWeatherTypeHashName()
    local hour = GetClockHours()
    
    cb({
        weather = weather,
        hour = hour,
        temperature = GetRandomTemperature(weather, hour)
    })
end)

function GetRandomTemperature(weather, hour)
    local base = 25
    
    -- Adjust by weather
    if weather == 'RAIN' or weather == 'THUNDER' then
        base = base - 8
    elseif weather == 'CLEAR' or weather == 'EXTRASUNNY' then
        base = base + 5
    elseif weather == 'CLOUDS' or weather == 'OVERCAST' then
        base = base - 3
    end
    
    -- Adjust by hour
    if hour >= 6 and hour <= 10 then
        base = base - 5
    elseif hour >= 11 and hour <= 16 then
        base = base + 3
    elseif hour >= 17 and hour <= 20 then
        base = base - 2
    else
        base = base - 8
    end
    
    return base + math.random(-2, 2)
end
