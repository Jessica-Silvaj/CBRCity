-- OutfitManager: handles saving/restoring civilian outfits and applying job outfits
OutfitManager = {
    savedOutfit         = nil,   -- snapshot of the outfit worn before job outfit was applied
    currentJobOutfitKey = nil,   -- key of the currently active job outfit (nil = civilian)
    interactions        = {},    -- list of active interaction zones
}

-- CanPlayerWearJobOutfit: returns true if the current ped model has outfits configured
function CanPlayerWearJobOutfit()
    return OutfitManager:GetOutfitsForCurrentPed() ~= nil
end

-- IsPlayerWearingJobOutfit: returns true if a job outfit is currently active
function IsPlayerWearingJobOutfit()
    return OutfitManager.currentJobOutfitKey ~= nil
end

-- Return the outfit table for the current ped model, or nil if none configured
function OutfitManager.GetOutfitsForCurrentPed(self)
    local pedModel   = GetEntityModel(PlayerPedId())
    local outfitsCfg = Config.headquarters.outfits
    if not outfitsCfg then return nil end

    for modelName, outfits in pairs(outfitsCfg) do
        if GetHashKey(modelName) == pedModel then
            return outfits
        end
    end
    return nil
end

-- Snapshot the player's current clothing so it can be restored later
function OutfitManager.SaveCurrentOutfit(self)
    local ped  = PlayerPedId()
    local snap = { components = {}, props = {} }
    self.savedOutfit = snap

    -- Save all 12 clothing components (0-11)
    for i = 0, 11 do
        snap.components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture  = GetPedTextureVariation(ped, i),
        }
    end

    -- Save the five prop slots (hat, glasses, ear, watch, bracelet)
    for _, slotId in ipairs({ 0, 1, 2, 6, 7 }) do
        snap.props[slotId] = {
            drawable = GetPedPropIndex(ped, slotId),
            texture  = GetPedPropTextureIndex(ped, slotId),
        }
    end
end

-- Apply an outfit snapshot (components + props) to the local player ped
function OutfitManager.ApplyOutfit(self, outfit)
    local ped = PlayerPedId()

    if outfit.components then
        for slotId, comp in pairs(outfit.components) do
            SetPedComponentVariation(ped, slotId, comp.drawable, comp.texture, 0)
        end
    end

    if outfit.props and next(outfit.props) then
        for slotId, prop in pairs(outfit.props) do
            Debug("Applying prop " .. slotId .. " drawable=" .. prop.drawable .. " texture=" .. prop.texture)
            if prop.drawable == -1 then
                ClearPedProp(ped, slotId)
            else
                SetPedPropIndex(ped, slotId, prop.drawable, prop.texture, true)
            end
        end
    end
end

-- Play a "getting dressed" animation, call midCallback at the midpoint, then finish
function OutfitManager.PlayChangeAnimation(self, midCallback)
    local ped      = PlayerPedId()
    local animDict = "mp_safehouseshower@male@"
    local animName = "male_shower_towel_dry_to_get_dressed"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    TaskPlayAnim(ped, animDict, animName, 8.0, -1.0, -1, 1, 0, false, false, false)
    Wait(1500)

    if midCallback then midCallback() end

    Wait(1500)
    StopAnimTask(ped, animDict, animName, -1.0)
    RemoveAnimDict(animDict)
end

-- Restore the player's saved civilian outfit (plays change animation)
function OutfitManager.RestoreRegularOutfit(self)
    if not self.savedOutfit then return end

    self:PlayChangeAnimation(function()
        self:ApplyOutfit(self.savedOutfit)
        self.currentJobOutfitKey = nil
        self.savedOutfit         = nil
    end)
end

-- Apply a job outfit by key (saves civilian outfit first if needed)
function OutfitManager.ApplyJobOutfit(self, outfitKey, outfitData)
    if not IsPlayerWearingJobOutfit() then
        self:SaveCurrentOutfit()
    end

    self:PlayChangeAnimation(function()
        self:ApplyOutfit(outfitData)
        self.currentJobOutfitKey = outfitKey
    end)
end

-- Create interaction zones for the outfit-change area and each individual outfit
function OutfitManager.SetupInteractions(self)
    local zoneCfg    = Config.headquarters.outfitZone
    local outfitsCfg = Config.headquarters.outfits
    if not zoneCfg or not outfitsCfg then return end

    -- "Switch back to regular" zone
    local restoreZone = exports.kq_link:AddInteractionZone(
        zoneCfg.coords,
        vec3(0.0, 0.0, 0.0),
        zoneCfg.scale,
        "[E] " .. L("outfit.switch_regular"),
        L("outfit.switch_regular"),
        38,
        function() self:RestoreRegularOutfit() end,
        function()
            if IsPlayerUnreachable() then return false end
            return IsPlayerWearingJobOutfit() and CanPlayerWearJobOutfit()
        end,
        {},
        zoneCfg.interactDist,
        "fas fa-shirt"
    )
    table.insert(self.interactions, restoreZone)

    -- One interaction zone per configured outfit, per ped model
    for modelName, outfits in pairs(outfitsCfg) do
        for outfitKey, outfitData in pairs(outfits) do
            Citizen.Wait(100) -- slight stagger to avoid native spam

            local label = outfitData.label or outfitKey

            local zone = exports.kq_link:AddInteractionZone(
                zoneCfg.coords,
                vec3(0.0, 0.0, 0.0),
                zoneCfg.scale,
                "[E] " .. L("outfit.apply", { name = label }),
                L("outfit.apply", { name = label }),
                38,
                function()
                    -- Check level unlock requirement
                    if outfitData.unlockRequired then
                        local upgradeCfg = Config.levelUpgrades and Config.levelUpgrades[outfitData.unlockRequired]
                        if upgradeCfg then
                            local stats        = exports.kq_jobcontracts:GetPlayerJobStats("powerwashing")
                            local playerLevel  = (stats and stats.level) or 1
                            if upgradeCfg.level > playerLevel then
                                exports.kq_link:Notify(L("outfit.not_unlocked"), "error")
                                return false
                            end
                        end
                    end
                    self:ApplyJobOutfit(outfitKey, outfitData)
                end,
                function()
                    if IsPlayerUnreachable() then return false end
                    if not DoesPlayerHavePowerwashingJob() then return false end

                    -- Only show for matching ped model
                    local pedModel = GetEntityModel(PlayerPedId())
                    if GetHashKey(modelName) ~= pedModel then return false end

                    -- Hide if this outfit is already active
                    if self.currentJobOutfitKey == outfitKey then return false end

                    -- Optionally hide locked outfits
                    if Config.hideLockedOutfits and outfitData.unlockRequired then
                        local upgradeCfg = Config.levelUpgrades and Config.levelUpgrades[outfitData.unlockRequired]
                        if not upgradeCfg then return true end

                        local stats       = exports.kq_jobcontracts:GetPlayerJobStats("powerwashing")
                        local playerLevel = (stats and stats.level) or 1
                        if upgradeCfg.level > playerLevel then return false end
                    end

                    return true
                end,
                {},
                zoneCfg.interactDist,
                "fas fa-vest"
            )
            table.insert(self.interactions, zone)
        end
    end
end

-- Delete all interaction zones and reset outfit state
function OutfitManager.Destroy(self)
    for _, zone in ipairs(self.interactions) do
        if zone and zone.Delete then zone.Delete() end
    end
    self.interactions        = {}
    self.savedOutfit         = nil
    self.currentJobOutfitKey = nil
end

-- Set up interactions after resource loads
CreateThread(function()
    Wait(1500)
    OutfitManager:SetupInteractions()
end)

-- Clean up when resource stops
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    OutfitManager:Destroy()
end)