-- Variable to track if menu is open
local isMenuOpen = false

-- Handle weather and time change from NUI
RegisterNUICallback("applyWeatherAndTime", function(data, callback)
  local gtagWeather = nil
  if data.weather then
    gtagWeather = Config.WeatherTypes[data.weather] or data.weather
  end
  
  if gtagWeather or (data.hour and data.minute) then
    TriggerServerEvent("weather:applyWeatherAndTime", gtagWeather, data.hour, data.minute)
  end
  
  if callback then callback("ok") end
end)

-- Legacy setWeather fallback from NUI
RegisterNUICallback("setWeather", function(weatherType, callback)
  local gtagWeather = Config.WeatherTypes[weatherType]
  
  if gtagWeather then
    TriggerServerEvent("weather:applyWeatherAndTime", gtagWeather)
  end
  
  if callback then callback("ok") end
end)

-- Remove clouds/fog effect
RegisterNUICallback("removeClouds", function(data, callback)
  SetExtraTimecycleModifier("INT_NO_fogALPHA")
  if callback then callback("ok") end
end)

-- Reset weather to default (sync with server)
RegisterNUICallback("resetWeather", function(data, callback)
  ClearExtraTimecycleModifier()
  if callback then callback("ok") end
end)

-- Close weather menu
RegisterNUICallback("weatherClose", function(data, callback)
  isMenuOpen = false
  toggleNuiFrame(false)
  if callback then callback("ok") end
end)

-- Hide frame action from frontend
RegisterNUICallback("hideFrame", function(data, callback)
  isMenuOpen = false
  toggleNuiFrame(false)
  if callback then callback("ok") end
end)

-- Network event to open weather menu
RegisterNetEvent("open:weather", function(visible)
  isMenuOpen = visible
  toggleNuiFrame(visible)
end)