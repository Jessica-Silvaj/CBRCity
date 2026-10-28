-- Validate that Config.jobName is set (nil/"false"/"" are treated as unset)
if not Config.jobName or Config.jobName == "false" or Config.jobName == "" then
    Config.jobName = nil
end

-- Spray / distance settings
Config.minCleanDistance        = 0.4    -- minimum distance from surface to clean
Config.maxCleanDistance        = 6.5    -- maximum distance from surface to clean
Config.minCleanRadiusMeters    = 0.07   -- smallest clean-spot radius (metres)
Config.maxCleanRadiusMeters    = 0.47   -- largest clean-spot radius (metres)
Config.distanceFalloffPower    = 2.2    -- power curve for distance falloff
Config.planeDetectionTolerance = 0.6    -- tolerance for surface plane detection

-- Dirt opacity levels indexed 0-3 (0 = clean, 3 = very dirty)
Config.dirtOpacity = { [0] = 0, [1] = 95, [2] = 135, [3] = 160 }

-- Dirt blob visual parameters
Config.dirtBlobFrequency   = 0.04  -- how often blobs appear across the surface
Config.dirtBlobMinOpacity  = 0.6   -- minimum blob opacity
Config.dirtBlobMaxOpacity  = 1.3   -- maximum blob opacity

-- Small-detail dirt noise
Config.smallBlobFrequency  = 0.2   -- frequency of small dirt details
Config.smallBlobIntensity  = 0.3   -- intensity of small dirt details
Config.smallBlobThreshold  = 0.15  -- threshold below which small blobs are suppressed

-- Edge / border irregularity
Config.edgeIrregularityStrength = 1.2   -- strength of irregular dirty edges
Config.edgeBlobStrength         = 0.7   -- extra blob density near edges
Config.blendDistortionStrength  = 0.35  -- distortion applied during clean/dirt blend

-- Noise and transition settings
Config.transitionNoiseStrength  = 0.2   -- noise applied to clean/dirty transition line
Config.dirtyBorderNoiseStrength = 0.15  -- noise strength on dirty borders
Config.dirtyBorderExtraOpacity  = 0.35  -- extra opacity boost on dirty borders
Config.microNoiseStrength       = 0.08  -- micro-level surface noise strength

-- Network / sync settings
Config.syncInterval      = 2000   -- server → clients sync interval (ms)
Config.latentEventBps    = 75000  -- bandwidth cap for latent events (bytes/sec)
Config.localSyncInterval = 80     -- local (intra-client) sync interval (ms)

-- Client rendering settings
Config.clientTargetPixelSize = 0.022  -- target pixel size for dirt texture
Config.clientMaxTextureSize  = 512    -- maximum generated texture resolution