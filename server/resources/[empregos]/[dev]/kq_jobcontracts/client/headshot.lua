-- Manages the local player's headshot texture for use in the NUI
HeadshotManager = {
    handle = nil,
    txd    = nil,
}

-- Return the cached headshot TXD string if still valid, otherwise regenerate
function HeadshotManager.Get(self)
    if self.txd and self.handle and IsPedheadshotValid(self.handle) then
        return self.txd
    end
    return self:Generate()
end

-- Unregister all active ped headshots (cleanup helper)
local function UnregisterAllHeadshots()
    for i = 1, 32 do
        if IsPedheadshotValid(i) then
            UnregisterPedheadshot(i)
        end
    end
end

-- Generate a new headshot for the local player ped
-- Waits up to 2500ms for the headshot to be ready
-- Returns the TXD string on success, nil on timeout or invalid ped
function HeadshotManager.Generate(self)
    UnregisterAllHeadshots()
    Citizen.Wait(10)

    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return nil end

    local handle  = RegisterPedheadshotTransparent(ped)
    local timeout = GetGameTimer() + 2500

    while true do
        if IsPedheadshotReady(handle) and IsPedheadshotValid(handle) then
            break
        end
        Wait(50)
        if GetGameTimer() >= timeout then
            return nil  -- timed out waiting for headshot
        end
    end

    Citizen.Wait(10)
    return GetPedheadshotTxdString(handle)
end

-- Return the headshot as a NUI-compatible image URL, or nil if unavailable
function HeadshotManager.GetNuiUrl(self)
    local txd = self:Get()
    if not txd or txd == "" then return nil end
    return string.format("https://nui-img/%s/%s", txd, txd)
end