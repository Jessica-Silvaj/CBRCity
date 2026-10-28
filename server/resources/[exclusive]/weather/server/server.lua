local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- Função para obter clima atual da base
local function GetCurrentWeather()
    return GlobalState.Weather or "EXTRASUNNY"
end

-- Função para definir clima global na base
local function SetGlobalWeather(weather)
    if not weather then return end
    GlobalState.Weather = weather
end

-- Função para definir horário global na base
local function SetGlobalTime(hours, minutes)
    if hours then GlobalState.Hours = hours end
    if minutes then GlobalState.Minutes = minutes end
end

-- Evento para receber dados do NUI e sincronizar clima e tempo
RegisterNetEvent("weather:applyWeatherAndTime")
AddEventHandler("weather:applyWeatherAndTime", function(weather, hours, minutes)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasGroup(Passport, "Admin") then
        if weather then
            SetGlobalWeather(weather)
        end
        if hours and minutes then
            SetGlobalTime(hours, minutes)
        end
    end
end)

-- Sistema de mudança automática de clima
CreateThread(function()
    while true do
        Wait(Config.WeatherChangeInterval * 60000)
        
        if Config.AutoWeatherEnabled then
            local randomWeather = Config.AutoWeatherList[math.random(#Config.AutoWeatherList)]
            SetGlobalWeather(randomWeather)
        end
    end
end)

-- Comando para abrir menu de clima (Apenas Admin)
RegisterCommand("clima", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasGroup(Passport, "Admin") then
        TriggerClientEvent("open:weather", source, true)
    end
end, false)

-- Export para outros resources
exports("GetCurrentWeather", GetCurrentWeather)
exports("SetGlobalWeather", SetGlobalWeather)
exports("SetGlobalTime", SetGlobalTime)

-- Funções exportadas para uso em outros resources
function GetWeather()
    return GetCurrentWeather()
end

function SetWeather(weather)
    SetGlobalWeather(weather)
end