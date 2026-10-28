-- ============================================================
-- NAIL STUDIO RESOURCE - SERVER NAIL DATA LIBRARY (DEOBFUSCATED)
-- ============================================================
-- Provides all CRUD helpers for two server-side nail data stores:
--
--   PlayerNails    - the CONFIRMED / saved nail design per player
--                    (persisted to the database)
--
--   PreviewNails   - the LIVE PREVIEW nail design per player
--                    (in-memory only, discarded when session ends)
--
-- Both stores are sparse tables keyed by tostring(serverId),
-- with each sub-table keyed by tostring(boneId).
--
-- All functions are exposed as globals so other server scripts
-- can call them without requiring this file.
-- ============================================================

-- Load config (needed for Config.FingerBones bone-ID lookup)
local Config = LoadNailConfig()

-- ============================================================
-- SECTION 1: CONFIRMED NAIL DATA  (PlayerNails store)
-- ============================================================

-- ------------------------------------------------------------
-- FUNCTION: GetPlayerNailData  (global)
-- Returns the confirmed nail design table for a player.
-- @param  serverId  number   - The player's server ID
-- @return           table    - Design table, or {} if none exists
-- ------------------------------------------------------------
function GetPlayerNailData(serverId)
    if not serverId then
        Debug("warning", "GetPlayerNailData called with nil playerId")
        return {}
    end

    local key  = tostring(serverId)
    local data = PlayerNails[key]

    if data then
        return PlayerNails[key]
    end

    return {}
end

-- ------------------------------------------------------------
-- FUNCTION: UpdatePlayerNails  (global)
-- Merges new nail data into a player's existing confirmed design.
-- Logs a warning and returns early if the incoming data is empty.
-- @param serverId   number  - The player's server ID
-- @param newData    table   - Nail entries to merge in
-- ------------------------------------------------------------
function UpdatePlayerNails(serverId, newData)
    if not serverId then
        Debug("warning", "UpdatePlayerNails called with nil playerId")
        return {}
    end

    -- Retrieve (or initialise) the player's existing nail data
    local existingData = GetPlayerNailData(serverId)
    if not existingData then
        existingData = {}
    end

    -- Reject empty updates
    if not next(newData) then
        Debug("warning", "Empty data provided for player %d", serverId)
        return
    end

    -- Count how many finger entries are being updated (for logging)
    local fingerCount = 0
    if newData then
        for _ in pairs(newData) do
            fingerCount = fingerCount + 1
        end
    end

    Debug("info", "Updating nails for player %d (%d fingers)", serverId, fingerCount)

    -- Overwrite the player's confirmed nail data with the new table
    PlayerNails[tostring(serverId)] = newData

    Debug("success", "Updated nail data for player %d in StateBag", serverId)
end

-- ------------------------------------------------------------
-- FUNCTION: SetPlayerNails  (global)
-- Directly sets (replaces) a player's confirmed nail data.
-- If nailData is nil, stores an empty table instead.
-- @param serverId   number       - The player's server ID
-- @param nailData   table|nil    - Full nail design table, or nil to clear
-- ------------------------------------------------------------
function SetPlayerNails(serverId, nailData)
    if not serverId then
        Debug("warning", "SetPlayerNails called with nil playerId")
        return
    end

    -- Count the number of nail entries for logging
    local nailCount = 0
    if nailData then
        for _ in pairs(nailData) do
            nailCount = nailCount + 1
        end
    end

    -- Store the data; fall back to an empty table when nil is passed
    PlayerNails[tostring(serverId)] = nailData or {}

    Debug("info", "Set nail data for player %d (%d nails)", serverId, nailCount)
end

-- ------------------------------------------------------------
-- FUNCTION: ClearPlayerNails  (global)
-- Removes a player's confirmed nail data entirely from the store.
-- @param serverId  number  - The player's server ID
-- ------------------------------------------------------------
function ClearPlayerNails(serverId)
    if not serverId then
        Debug("warning", "ClearPlayerNails called with nil playerId")
        return
    end

    PlayerNails[tostring(serverId)] = nil

    Debug("info", "Cleared nail data for player %d", serverId)
end

-- ============================================================
-- SECTION 2: DATABASE PERSISTENCE
-- ============================================================

-- ------------------------------------------------------------
-- FUNCTION: LoadPlayerNailDataFromDB  (global)
-- Queries the database for a player's saved nail design.
-- Uses vRP prepares for a synchronous read.
-- @param  serverId  number   - The player's server ID
-- @return           table|nil, boolean
--                   (data, true)  on success
--                   (nil,  false) when no row is found
-- ------------------------------------------------------------
function LoadPlayerNailDataFromDB(serverId)
    local Passport = tonumber(Framework.GetPlayerIdentifier(serverId))

    if not Passport then
        Debug("warning", "Failed to get Passport for player %d", serverId)
        return nil, false
    end

    local row = vRP.SingleQuery("night_nailshop/Get",{ Passport = Passport })

    if row then
        -- Decode the stored JSON, falling back to an empty table on failure
        local decodedData = {}
        if row.nail_data then
            local decoded = json.decode(row.nail_data)
            if decoded then
                decodedData = decoded
            end
        end

        Debug("info", "Loaded nail data from database for player %d", serverId)
        return decodedData, true
    end

    -- No row found for this identifier
    Debug("info", "No nail data found in database for player %d", serverId)
    return nil, false
end

-- ------------------------------------------------------------
-- FUNCTION: LoadOrCreatePlayerNailData  (global)
-- Attempts to load a player's nail data from the database.
-- If no record exists, inserts a new empty row and returns {}.
-- @param  serverId  number  - The player's server ID
-- @return           table   - Loaded nail data or {} for a new player
-- ------------------------------------------------------------
function LoadOrCreatePlayerNailData(serverId)
    local loadedData, found = LoadPlayerNailDataFromDB(serverId)

    -- Return existing data if it was found and is a table
    if found and type(loadedData) == "table" then
        return loadedData
    end

    -- No existing record: create one
    Debug("info", "Creating new nail data entry for player %d", serverId)

    local Passport = tonumber(Framework.GetPlayerIdentifier(serverId))

    if Passport then
        local emptyJson = json.encode({})
        vRP.Query("night_nailshop/Set",{ Passport = Passport, nail_data = emptyJson })
        Debug("success", "Created new nail data entry for player %d", serverId)
    else
        Debug("error",
            "Failed to get identifier for player %d, cannot create entry", serverId)
    end

    return {}
end

-- ============================================================
-- SECTION 3: PREVIEW NAIL DATA  (PreviewNails store)
-- ============================================================

-- ------------------------------------------------------------
-- FUNCTION: GetPlayerPreviewNailData  (global)
-- Returns the live-preview nail design for a player.
-- @param  serverId  number  - The player's server ID
-- @return           table   - Preview table, or {} if none exists
-- ------------------------------------------------------------
function GetPlayerPreviewNailData(serverId)
    if not serverId then
        Debug("warning", "GetPlayerPreviewNailData called with nil playerId")
        return {}
    end

    local key  = tostring(serverId)
    local data = PreviewNails[key]

    if data then
        return PreviewNails[key]
    end

    return {}
end

-- ------------------------------------------------------------
-- FUNCTION: UpdatePlayerPreviewNails  (global)
-- Merges new preview entries into a player's existing preview store.
-- Handles two input formats:
--   FORMAT A: array of objects each containing a "boneId" field
--             → keyed into the store by tostring(entry.boneId)
--   FORMAT B: plain key→value table
--             → keyed by tostring(key)
-- @param serverId    number  - The player's server ID
-- @param previewData table   - Preview nail entries to merge in
-- ------------------------------------------------------------
function UpdatePlayerPreviewNails(serverId, previewData)
    if not serverId then
        Debug("warning", "UpdatePlayerPreviewNails called with nil playerId")
        return
    end

    -- Get or initialise the player's current preview data
    local currentPreview = GetPlayerPreviewNailData(serverId)
    if not currentPreview then
        currentPreview = {}
    end

    -- Reject empty updates
    if not next(previewData) then
        Debug("warning",
            "Empty data provided for preview nails for player %d", serverId)
        return
    end

    local updatedCount = 0
    local lastBoneKey  = nil
    local isBoneFormat = false  -- true when FORMAT A (objects with boneId field)

    -- Detect which format the incoming data uses
    for _, entry in pairs(previewData) do
        if type(entry) == "table" and entry.boneId then
            isBoneFormat = true
            break
        end
    end

    if isBoneFormat then
        -- FORMAT A: each entry is a table with a .boneId field
        for _, entry in pairs(previewData) do
            if entry.boneId then
                local boneKey         = tostring(entry.boneId)
                lastBoneKey           = boneKey
                currentPreview[boneKey] = entry
                updatedCount          = updatedCount + 1
            end
        end
    else
        -- FORMAT B: incoming table is already keyed by bone ID
        for key, entry in pairs(previewData) do
            local boneKey             = tostring(key)
            lastBoneKey               = boneKey
            currentPreview[boneKey]   = entry
            updatedCount              = updatedCount + 1
        end
    end

    Debug("info",
        "Updating preview nails for player %d (%d new/updated fingers)",
        serverId, updatedCount)

    -- Write the merged table back to the preview store
    PreviewNails[tostring(serverId)] = currentPreview

    -- Count the total number of bones now stored (for logging)
    local totalBones = 0
    for _ in pairs(currentPreview) do
        totalBones = totalBones + 1
    end

    Debug("success",
        "Updated preview nail data for player %d (total bones: %d)",
        serverId, totalBones)
end

-- ------------------------------------------------------------
-- FUNCTION: SetPlayerPreviewNails  (global)
-- Directly sets (replaces) a player's entire preview nail data.
-- If previewData is nil, stores an empty table instead.
-- @param serverId     number       - The player's server ID
-- @param previewData  table|nil    - Full preview table, or nil to clear
-- ------------------------------------------------------------
function SetPlayerPreviewNails(serverId, previewData)
    if not serverId then
        Debug("warning", "SetPlayerPreviewNails called with nil playerId")
        return
    end

    -- Count for logging
    local nailCount = 0
    if previewData then
        for _ in pairs(previewData) do
            nailCount = nailCount + 1
        end
    end

    -- Store the data; fall back to an empty table when nil is passed
    PreviewNails[tostring(serverId)] = previewData or {}

    Debug("info",
        "Set preview nail data for player %d (%d nails)", serverId, nailCount)
end

-- ------------------------------------------------------------
-- FUNCTION: ClearPreviewNailDesign  (global)
-- Removes a player's entire preview nail design from the store.
-- @param serverId  number  - The player's server ID
-- ------------------------------------------------------------
function ClearPreviewNailDesign(serverId)
    if not serverId then
        Debug("warning", "ClearPreviewNailDesign called with nil playerId")
        return
    end

    PreviewNails[tostring(serverId)] = nil

    Debug("info", "Cleared preview nail data for player %d", serverId)
end

-- ------------------------------------------------------------
-- FUNCTION: ClearPlayerPreviewFingerDesign  (global)
-- Removes the preview nail for a single specific finger.
-- Looks up the GTA bone ID via Config.FingerBones using the
-- key format  "<hand>_<fingerId>"  (e.g. "left_3", "right_1").
-- If removing this finger empties the entire preview table the
-- player's entry in PreviewNails is removed altogether.
--
-- @param serverId   number  - The player's server ID
-- @param fingerId   number  - Finger index (1-5)
-- @param hand       string  - "left" or "right"
-- ------------------------------------------------------------
function ClearPlayerPreviewFingerDesign(serverId, fingerId, hand)
    -- Validate arguments
    if not serverId then
        Debug("warning",
            "ClearPlayerPreviewFingerDesign called with nil playerId")
        return
    end

    if not fingerId or not hand then
        Debug("warning",
            "ClearPlayerPreviewFingerDesign called with nil fingerId or hand for player %d",
            serverId)
        return
    end

    -- Fetch the player's current preview data
    local previewData = GetPlayerPreviewNailData(serverId)

    -- Bail out early if there is nothing to clear
    if not previewData or not next(previewData) then
        Debug("info",
            "No preview nail data to clear for player %d", serverId)
        return
    end

    -- Resolve the GTA bone ID from the FingerBones config map.
    -- Config.FingerBones is keyed like "left_1", "right_3", etc.
    local handKey = hand
    if hand == "left" then
        handKey = "left_hand"
    elseif hand == "right" then
        handKey = "right_hand"
    end

    local fingerBoneKey = handKey .. "_" .. tostring(fingerId)
    local boneId        = Config.FingerBones[fingerBoneKey]

    if not boneId then
        Debug("warning",
            "Invalid finger bone for hand %s, id %s", hand, tostring(fingerId))
        return
    end

    local boneKey    = tostring(boneId)
    local nailEntry  = previewData[boneKey]

    if nailEntry then
        -- Remove this finger's entry from the preview table
        previewData[boneKey] = nil

        Debug("info",
            "Cleared preview nail design for finger %s (hand: %s, bone: %d) for player %d",
            tostring(fingerId), hand, boneId, serverId)

        -- Check whether the preview table is now completely empty
        if not next(previewData) then
            -- Nothing left: remove the whole entry to avoid an empty table leak
            PreviewNails[tostring(serverId)] = nil
            Debug("info",
                "Preview nail data is now empty for player %d, cleared entire table",
                serverId)
        else
            -- Still some entries: write the trimmed table back
            PreviewNails[tostring(serverId)] = previewData
        end
    else
        Debug("info",
            "No preview nail design found for finger %s (hand: %s, bone: %d) for player %d",
            tostring(fingerId), hand, boneId, serverId)
    end
end
