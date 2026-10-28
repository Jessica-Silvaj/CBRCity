-- Apply network quality presets — overrides default sync/resolution settings
-- based on Config.networkQuality set in config.lua

if Config.networkQuality == "very_low" then
    Config.networkPixelSize    = 0.3
    Config.networkMaxResolution = 2048
    Config.syncInterval        = 4500
elseif Config.networkQuality == "low" then
    Config.networkPixelSize    = 0.2
    Config.networkMaxResolution = 2248
    Config.syncInterval        = 3400
elseif Config.networkQuality == "medium" then
    Config.networkPixelSize    = 0.16
    Config.networkMaxResolution = 2760
    Config.syncInterval        = 2450
elseif Config.networkQuality == "high" then
    Config.networkPixelSize    = 0.15
    Config.networkMaxResolution = 3072
    Config.syncInterval        = 1950
elseif Config.networkQuality == "ultra" then
    Config.networkPixelSize    = 0.15
    Config.networkMaxResolution = 4096
    Config.syncInterval        = 1300
end

-- Apply client quality presets — overrides texture resolution and pixel size
-- based on Config.clientQuality set in config.lua

if Config.clientQuality == "very_low" then
    Config.clientTargetPixelSize = 0.055
    Config.clientMaxTextureSize  = 256
elseif Config.clientQuality == "low" then
    Config.clientTargetPixelSize = 0.04
    Config.clientMaxTextureSize  = 256
elseif Config.clientQuality == "medium" then
    Config.clientTargetPixelSize = 0.03
    Config.clientMaxTextureSize  = 384
elseif Config.clientQuality == "high" then
    Config.clientTargetPixelSize = 0.022
    Config.clientMaxTextureSize  = 512
elseif Config.clientQuality == "ultra" then
    Config.clientTargetPixelSize = 0.02
    Config.clientMaxTextureSize  = 640
end