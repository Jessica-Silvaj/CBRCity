-- Perlin noise implementation
-- Exposes: Perlin.noise(x, y, seed), Perlin.octaveNoise(x, y, octaves, persistence, seed)

Perlin = {}

-- ============================================================
-- Permutation table (Ken Perlin's reference values, doubled to 512)
-- ============================================================

local permBase = {
    151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,
    140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,
    247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
     57,177, 33, 88,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
     74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
     60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
     65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
    200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
     52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
    207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
    119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
    129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
    218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
     81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
    184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
    222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180,
}

-- Double the table to avoid index wrapping
local perm = {}
for i = 0, 511 do
    perm[i] = permBase[(i % 256) + 1]
end

-- ============================================================
-- Internal math helpers
-- ============================================================

-- Fade / ease curve: 6t^5 - 15t^4 + 10t^3  (Ken Perlin's improved version)
local function fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

-- Linear interpolation
local function lerp(t, a, b)
    return a + t * (b - a)
end

-- Gradient function: maps hash to one of 4 gradient directions in 2D
-- Vectors: h=0 -> (+1,+1), h=1 -> (-1,+1), h=2 -> (-1,-1), h=3 -> (+1,-1)
local function grad(hash, x, y)
    local h = hash % 4
    if h == 0 then return  x + y end
    if h == 1 then return -x + y end
    if h == 2 then return -x - y end
    return x - y  -- h == 3
end

-- ============================================================
-- Perlin.noise: 2D Perlin noise, returns a value in [0, 1]
-- x, y  : input coordinates
-- seed  : optional random seed (calls math.randomseed if provided)
-- ============================================================
function Perlin.noise(x, y, seed)
    if seed then math.randomseed(seed) end

    -- Integer cell coordinates (mod 255 to stay within perm table)
    local xi = math.floor(x) % 255
    local yi = math.floor(y) % 255

    -- Fractional part of coordinates
    local xf = x - math.floor(x)
    local yf = y - math.floor(y)

    -- Fade curves for smooth interpolation
    local u = fade(xf)
    local v = fade(yf)

    -- Hash the four corners of the unit square
    local aa = perm[perm[xi]     + yi    ]
    local ab = perm[perm[xi]     + yi + 1]
    local ba = perm[perm[xi + 1] + yi    ]
    local bb = perm[perm[xi + 1] + yi + 1]

    -- Interpolate gradient contributions from all four corners
    local x1 = lerp(u,
        grad(aa,  xf,      yf    ),
        grad(ba,  xf - 1,  yf    )
    )
    local x2 = lerp(u,
        grad(ab,  xf,      yf - 1),
        grad(bb,  xf - 1,  yf - 1)
    )

    -- Map result from [-1, 1] to [0, 1]
    return (lerp(v, x1, x2) + 1) / 2
end

-- ============================================================
-- Perlin.octaveNoise: layered Perlin noise (fractal Brownian motion)
-- x, y        : input coordinates
-- octaves     : number of noise layers to stack
-- persistence : amplitude multiplier per octave (e.g. 0.5)
-- seed        : optional random seed passed to the first noise call
-- ============================================================
function Perlin.octaveNoise(x, y, octaves, persistence, seed)
    local total     = 0
    local frequency = 1
    local amplitude = 1
    local maxValue  = 0  -- used to normalise result

    for _ = 1, octaves do
        total    = total + Perlin.noise(x * frequency, y * frequency, seed) * amplitude
        maxValue = maxValue + amplitude
        amplitude = amplitude * persistence
        frequency = frequency * 2
    end

    return total / maxValue
end