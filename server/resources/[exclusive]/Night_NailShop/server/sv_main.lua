-- ============================================================
-- NAIL STUDIO RESOURCE - SERVER MAIN SCRIPT (DEOBFUSCATED)
-- ============================================================
-- Responsibilities:
--   * Global server-side state tables (PlayerNails, PreviewNails, TableBusy)
--   * Tunnel callback: isTableBusy
--   * Net events: player load/unload, table busy state, invitations,
--     session management, nail design CRUD, ped change handling
--   * Resource lifecycle: onResourceStart / onResourceStop
-- ============================================================

-- Load the main config (studio definitions, FingerBones map, etc.)
local Config = LoadNailConfig()

-- ============================================================
-- GLOBAL SERVER STATE TABLES
-- ============================================================

-- Confirmed nail designs per player.
-- PlayerNails[tostring(serverId)][tostring(boneId)] = nailData
PlayerNails  = {}

-- Live preview (unsaved) nail designs per player.
-- PreviewNails[tostring(serverId)][tostring(boneId)] = nailData
PreviewNails = {}

-- Tracks which studio tables are currently occupied.
-- TableBusy[studioIndex][tableIndex] = occupyingServerId (or nil if free)
TableBusy    = {}

-- ============================================================
-- TUNNEL CALLBACK: isTableBusy
-- Called by clients to check whether a specific studio table
-- is already occupied before attempting to sit down or invite.
-- @param source     number  - The calling player's server ID
-- @param studioIdx  number  - Studio index to check
-- @param tableIdx   number  - Table index within the studio
-- @return           boolean - true if occupied by someone else
-- ============================================================
local function GetClosestPlayer(coords,radius,ignoreSource)
    local selected = nil
    local selectedDistance = radius or 2.0

    for _,playerId in pairs(GetPlayers()) do
        local serverId = tonumber(playerId)
        if serverId and serverId ~= ignoreSource then
            local ped = GetPlayerPed(serverId)
            if ped and ped ~= 0 then
                local pedCoords = GetEntityCoords(ped)
                local distance = #(pedCoords - coords)
                if distance <= selectedDistance then
                    selected = serverId
                    selectedDistance = distance
                end
            end
        end
    end

    return selected
end

function IsTableBusy(source, studioIdx, tableIdx)
    -- Invalid caller
    if not source then
        return false
    end

    -- Studio must exist in config
    local studioData = Config.NailStudios[studioIdx]
    if not studioData then
        return false
    end

    -- Table must exist and have a customer position
    local tableData = studioData.tables[tableIdx]
    if not tableData or not tableData.customer or not tableData.customer.coords then
        return false
    end

    -- Check whether a player is physically sitting in the customer chair
    local customerCoords = vector3(
        tableData.customer.coords.x,
        tableData.customer.coords.y,
        tableData.customer.coords.z
    )

    local nearbyPlayer = GetClosestPlayer(customerCoords, 1.0)

    -- Nobody is sitting there at all → not busy
    if not nearbyPlayer then
        return false
    end

    -- Check the TableBusy registry
    local studioBusyMap = TableBusy[studioIdx]
    local occupyingPlayer = studioBusyMap and studioBusyMap[tableIdx]

    -- Table is busy AND the occupant is someone other than the caller
    if occupyingPlayer and nearbyPlayer ~= source then
        return true
    end

    return false
end

-- ============================================================
-- NET EVENT: OnPlayerLoaded
-- Fired by the framework when a player's character has loaded.
-- Loads (or creates) nail data from the database, stores it
-- server-side, then broadcasts it to all clients so nearby
-- players can see the correct nail props.
-- @param serverId  number  - The newly loaded player's server ID
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:OnPlayerLoaded")
AddEventHandler(Scriptname .. ":server:OnPlayerLoaded", function(serverId)
    if not serverId then return end

    -- Brief delay to allow the framework player object to be fully ready
    Wait(2000)

    Debug("info", "Player %d loaded, loading nail data", serverId)

    -- Ensure the framework player object exists
    local playerObj = Framework.GetPlayer(serverId)
    if not playerObj then
        Debug("warning", "Player object not found for player %d", serverId)
        return
    end

    -- Load from DB (or create a new empty record)
    local nailData = LoadOrCreatePlayerNailData(serverId)
    SetPlayerNails(serverId, nailData)

    -- Broadcast this player's nail design to ALL clients (if non-empty)
    if nailData and next(nailData) then
        TriggerClientEvent(Scriptname .. ":client:createNailDesign", -1, serverId, nailData)
    end

    -- For each OTHER player who already has nail data, send their design
    -- to the newly loaded player so they can render it
    for otherKey, otherNailData in pairs(PlayerNails) do
        local otherServerId = tonumber(otherKey)

        -- Skip the player who just loaded
        if otherServerId ~= serverId then
            local otherPlayerObj = Framework.GetPlayer(otherServerId)

            if otherPlayerObj and otherNailData and next(otherNailData) then
                -- Send this other player's nail design to the newly loaded player only
                TriggerClientEvent(
                    Scriptname .. ":client:createNailDesign",
                    serverId,       -- target: the newly loaded player
                    otherServerId,  -- whose nails to render
                    otherNailData
                )
            end
        end
    end

    Debug("success", "Nail data loaded for player %d", serverId)
end)

-- ============================================================
-- EVENT: onResourceStart
-- When this resource starts, reload nail data for every player
-- who is already online (handles hot-restarts / crashes).
-- ============================================================
AddEventHandler("onResourceStart", function(startingResourceName)
    if startingResourceName ~= GetCurrentResourceName() then return end

    Debug("info",
        "Resource %s started, loading nail data for online players",
        startingResourceName)

    -- Small delay so the framework has time to settle
    Wait(1500)

    local loadedCount = 0

    for _, playerIdStr in pairs(Framework.GetPlayers()) do
        local serverId = tonumber(playerIdStr)

        if serverId and serverId ~= 0 then
            local nailData, found = LoadPlayerNailDataFromDB(serverId)

            if found and nailData then
                SetPlayerNails(serverId, nailData)
                loadedCount = loadedCount + 1

                if nailData and next(nailData) then
                    -- Broadcast this player's nails to all clients
                    TriggerClientEvent(
                        Scriptname .. ":client:createNailDesign",
                        -1, serverId, nailData
                    )
                else
                    Debug("info", "No nail data to load for player %d", serverId)
                end
            end
        end
    end

    Debug("success", "Loaded nail data for %d player(s)", loadedCount)
end)

-- ============================================================
-- EVENT: onResourceStop
-- Clears the nailData state bag entry for every online player
-- so clients don't hold stale data when the resource restarts.
-- ============================================================
AddEventHandler("onResourceStop", function(stoppingResourceName)
    if stoppingResourceName ~= GetCurrentResourceName() then return end

    for _, playerIdStr in pairs(GetPlayers()) do
        local serverId = tonumber(playerIdStr)

        if serverId and serverId ~= 0 then
            local pedEntity = GetPlayerPed(serverId)
            -- Clear the nailData state bag on the ped entity
            Entity(pedEntity).state:set("nailData", {}, true)
        end
    end
end)

RegisterNetEvent(Scriptname .. ":server:OnPlayerUnload")
AddEventHandler(Scriptname .. ":server:OnPlayerUnload", function(serverId)
    serverId = tonumber(serverId or source)
    if not serverId then return end

    PlayerNails[tostring(serverId)] = nil
    PreviewNails[tostring(serverId)] = nil

    for studioIdx,studioBusyMap in pairs(TableBusy) do
        for tableIdx,occupyingServerId in pairs(studioBusyMap) do
            if occupyingServerId == serverId then
                TableBusy[studioIdx][tableIdx] = nil
            end
        end
    end

    TriggerClientEvent(Scriptname .. ":client:deleteNailDesign",-1,serverId)
end)

-- ============================================================
-- NET EVENT: setBusyTable
-- Called by a client (customer or employee) to mark a studio
-- table as occupied or free.
-- @param studioIdx  number   - Studio index
-- @param tableIdx   number   - Table index within the studio
-- @param isBusy     boolean  - true = occupied, false = free
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:setBusyTable")
AddEventHandler(Scriptname .. ":server:setBusyTable", function(studioIdx, tableIdx, isBusy)
    local callerServerId = source
    if not callerServerId then return end

    Debug("info",
        "Player %d setting busy state for studio %d table %d to %s",
        callerServerId, studioIdx, tableIdx, tostring(isBusy))

    -- Ensure the studio sub-table exists in the registry
    if not TableBusy[studioIdx] then
        TableBusy[studioIdx] = {}
    end

    -- When isBusy is true, store the occupying player's server ID.
    -- When isBusy is false (or callerServerId is nil), store nil to free the slot.
    if isBusy and callerServerId then
        TableBusy[studioIdx][tableIdx] = callerServerId
    else
        TableBusy[studioIdx][tableIdx] = nil
    end
end)

-- ============================================================
-- NET EVENT: inviteCustomerById
-- An employee asks the server to invite a specific player
-- (identified by server ID) to sit at a table.
-- Validates: studio exists, table exists, table is not occupied,
-- employee is close enough to the target player.
-- @param targetServerId  number  - Server ID of the player to invite
-- @param studioIdx       number  - Studio index
-- @param tableIdx        number  - Table index within the studio
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:inviteCustomerById")
AddEventHandler(Scriptname .. ":server:inviteCustomerById", function(targetServerId, studioIdx, tableIdx)
    local employeeServerId = source

    -- Validate studio
    local studioData = Config.NailStudios[studioIdx]
    if not studioData then
        Debug("error", "Studio index %d not found for invitation", studioIdx)
        Notify.SendNotify(employeeServerId, _T("notify.studio_not_found"), "error", 5000)
        return
    end

    -- Validate table and customer position
    local tableData = studioData.tables[tableIdx]
    if not tableData or not tableData.customer or not tableData.customer.coords then
        Debug("error",
            "Table index %d not found in studio %d for invitation",
            tableIdx, studioIdx)
        Notify.SendNotify(employeeServerId, _T("notify.table_not_found"), "error", 5000)
        return
    end

    -- Check whether a player is physically present in the customer chair
    local customerChairCoords = vector3(
        tableData.customer.coords.x,
        tableData.customer.coords.y,
        tableData.customer.coords.z
    )

    local playerAtChair = GetClosestPlayer(customerChairCoords, 1.0)

    if playerAtChair and playerAtChair ~= employeeServerId then
        -- Someone else is already sitting there
        Debug("warning",
            "Player %d attempted to invite to occupied table %d in studio %d",
            employeeServerId, tableIdx, studioIdx)
        Notify.SendNotify(employeeServerId, _T("notify.table_occupied"), "error", 5000)
        return
    end

    -- Check the TableBusy registry as a secondary guard
    local studioBusyMap   = TableBusy[studioIdx]
    local occupyingPlayer = studioBusyMap and studioBusyMap[tableIdx]

    if occupyingPlayer and playerAtChair ~= employeeServerId then
        Notify.SendNotify(employeeServerId, _T("notify.table_occupied"), "error", 5000)
        Debug("warning",
            "Player %d attempted to invite to busy table %d in studio %d",
            employeeServerId, tableIdx, studioIdx)
        return
    end

    -- Validate that both peds exist
    local targetPed   = GetPlayerPed(targetServerId)
    local employeePed = GetPlayerPed(employeeServerId)

    if not targetPed or not employeePed then
        Debug("error",
            "Invalid ped for source %d or target %d during invitation",
            employeeServerId, targetServerId)
        Notify.SendNotify(employeeServerId, _T("notify.invitation_failed"), "error", 5000)
        return
    end

    -- Distance check: employee must be within 3 units of the target player
    local employeePos = GetEntityCoords(employeePed)
    local targetPos   = GetEntityCoords(targetPed)
    local distance    = #(employeePos - targetPos)

    if distance > 3.0 then
        Debug("warning",
            "Player %d is too far from target %d to send invitation (distance: %.2f)",
            employeeServerId, targetServerId, distance)
        Notify.SendNotify(employeeServerId, _T("notify.too_far_for_invitation"), "error", 5000)
        return
    end

    -- Send the invitation to the target player's client
    TriggerClientEvent(
        Scriptname .. ":client:receiveInvitation",
        targetServerId,     -- deliver to the invited player
        studioIdx,
        tableIdx,
        employeeServerId    -- pass the employee's ID as the session host
    )

    Debug("success",
        "Invitation sent to player %d for studio %d table %d by player %d",
        targetServerId, studioIdx, tableIdx, employeeServerId)
end)

-- ============================================================
-- NET EVENT: declineInvitation
-- Fired by the customer's client when they reject an invitation.
-- Notifies the employee (session host) that the invite was declined.
-- @param studioIdx        number  - Studio index
-- @param tableIdx         number  - Table index
-- @param employeeServerId number  - The employee who sent the invite
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:declineInvitation")
AddEventHandler(Scriptname .. ":server:declineInvitation", function(studioIdx, tableIdx, employeeServerId)
    local customerServerId = source
    if not customerServerId then return end

    Debug("info",
        "Player %d declined invitation to studio %d table %d",
        customerServerId, studioIdx, tableIdx)

    -- Notify the employee that the invitation was declined
    Notify.SendNotify(employeeServerId, _T("notify.invitation_declined"), "info", 5000)
end)

-- ============================================================
-- NET EVENT: joinStudioSession
-- Fired by the customer's client after they accept an invitation
-- and finish seating themselves. Tells the employee's client to
-- enter the session view (open the design NUI).
-- @param studioIdx        number  - Studio index
-- @param tableIdx         number  - Table index
-- @param employeeServerId number  - The employee who will open the NUI
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:joinStudioSession")
AddEventHandler(Scriptname .. ":server:joinStudioSession", function(studioIdx, tableIdx, employeeServerId)
    local customerServerId = source
    if not customerServerId then return end

    Debug("info",
        "Player %d joining studio %d table %d session",
        customerServerId, studioIdx, tableIdx)

    -- Validate studio
    local studioData = Config.NailStudios[studioIdx]
    if not studioData then
        Debug("error",
            "Studio index %d not found for player %d joining session",
            studioIdx, customerServerId)
        Notify.SendNotify(customerServerId, _T("notify.studio_not_found"), "error", 5000)
        return
    end

    -- Validate table
    local tableData = studioData.tables[tableIdx]
    if not tableData or not tableData.customer or not tableData.customer.coords then
        Debug("error",
            "Table index %d not found in studio %d for player %d joining session",
            tableIdx, studioIdx, customerServerId)
        Notify.SendNotify(customerServerId, _T("notify.table_not_found"), "error", 5000)
        return
    end

    -- Fire enterStudioSession on the EMPLOYEE's client so they
    -- sit down and open the nail design UI
    TriggerClientEvent(
        Scriptname .. ":client:enterStudioSession",
        employeeServerId,   -- deliver to the employee only
        studioIdx,
        tableIdx
    )

    Debug("success",
        "Player %d entered studio %d table %d session",
        customerServerId, studioIdx, tableIdx)
end)

-- ============================================================
-- NET EVENT: requestPlayerNailData
-- Fired by the employee's client (or the customer themselves)
-- to load the current confirmed nail design for whoever is
-- sitting in the customer chair nearest to the given coords.
-- Populates the preview store and broadcasts a previewNailDesign
-- event so clients render the current design immediately.
-- @param customerChairCoords  vector3  - World coords of the customer chair
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:requestPlayerNailData")
AddEventHandler(Scriptname .. ":server:requestPlayerNailData", function(customerChairCoords)
    local requestingServerId = source
    if not requestingServerId then return end

    Debug("info", "Player %d requested their nail data", requestingServerId)

    -- Find the customer sitting nearest to the chair coordinates
    local customerServerId = GetClosestPlayer(
        vector3(customerChairCoords.x, customerChairCoords.y, customerChairCoords.z),
        1.5,
        source -- ignora quem está fazendo (manicure)
    )

    if not customerServerId then
        Debug("warning",
            "No customer found near coords for player %d", requestingServerId)
        return
    end

    -- Retrieve the customer's confirmed nail data
    local nailData = GetPlayerNailData(customerServerId) or {}

    if not next(nailData) then
        Debug("info", "No nail data found for player %d", customerServerId)
        return
    end

    -- Copy the confirmed data into the preview store so the employee
    -- can make changes against the known baseline
    UpdatePlayerPreviewNails(customerServerId, nailData)

    -- Broadcast the preview to all clients (so nearby players see it)
    TriggerClientEvent(
        Scriptname .. ":client:previewNailDesign",
        -1,                 -- all clients
        customerServerId,
        nailData
    )

    Debug("success",
        "Nail design applied and previewed for customer %d", customerServerId)
end)

-- ============================================================
-- NET EVENT: previewNailDesign
-- Fired by the employee's client when they select a new design
-- option in the NUI. Updates the preview store and broadcasts
-- the change to all clients.
-- @param customerChairCoords  vector3  - World coords of the customer chair
-- @param previewData          table    - The new partial design to preview
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:previewNailDesign")
AddEventHandler(Scriptname .. ":server:previewNailDesign", function(customerChairCoords, previewData)
    local employeeServerId = source
    if not employeeServerId then return end

    Debug("info", "Player %d applying nail design", employeeServerId)

    -- Identify the customer sitting at the chair
    local customerServerId = GetClosestPlayer(
        vector3(customerChairCoords.x, customerChairCoords.y, customerChairCoords.z),
        1.5,
        source -- ignora quem está fazendo (manicure)
    )

    if not customerServerId then
        Debug("warning",
            "No customer found near coords for player %d", employeeServerId)
        return
    end

    -- Merge the preview data into the customer's live preview store
    UpdatePlayerPreviewNails(customerServerId, previewData)

    -- Broadcast the updated preview to all clients
    TriggerClientEvent(
        Scriptname .. ":client:previewNailDesign",
        -1,                 -- all clients
        customerServerId,
        previewData
    )

    Debug("success",
        "Nail design applied and previewed for customer %d", customerServerId)
end)

-- ============================================================
-- NET EVENT: clearFingerDesign
-- Fired by the employee's client when they remove the nail
-- design from a single finger. Clears the finger from the
-- preview store and broadcasts the removal to all clients.
-- @param customerChairCoords  vector3  - World coords of the customer chair
-- @param fingerId             number   - Finger index (1-5)
-- @param hand                 string   - "left" or "right"
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:clearFingerDesign")
AddEventHandler(Scriptname .. ":server:clearFingerDesign", function(customerChairCoords, fingerId, hand)
    local employeeServerId = source
    if not employeeServerId then return end

    Debug("info", "Player %d clearing finger design", employeeServerId)

    -- Identify the customer
    local customerServerId = GetClosestPlayer(
        vector3(customerChairCoords.x, customerChairCoords.y, customerChairCoords.z),
        1.5,
        source -- ignora quem está fazendo (manicure)
    )

    if not customerServerId then
        Debug("warning",
            "No customer found near coords for player %d", employeeServerId)
        return
    end

    -- Remove this finger's entry from the customer's preview store
    ClearPlayerPreviewFingerDesign(customerServerId, fingerId, hand)

    -- Broadcast the single-finger clear to all clients
    TriggerClientEvent(
        Scriptname .. ":client:clearFingerDesign",
        -1,                 -- all clients
        customerServerId,
        fingerId,
        hand
    )

    Debug("success", "Finger design cleared for customer %d", customerServerId)
end)

-- ============================================================
-- NET EVENT: clearPedTask
-- Fired by a client (typically the employee) when the session
-- ends and the customer's animation/camera should be reset.
-- Finds the customer seated at the given coords and fires the
-- clearPedTask client event on them.
-- @param customerChairCoords  vector3  - World coords of the customer chair
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:clearPedTask")
AddEventHandler(Scriptname .. ":server:clearPedTask", function(customerChairCoords)
    local callerServerId = source
    if not callerServerId then return end

    local customerServerId = GetClosestPlayer(
        vector3(customerChairCoords.x, customerChairCoords.y, customerChairCoords.z),
        1.5,
        source -- ignora quem está fazendo (manicure)
    )

    if not customerServerId then
        Debug("warning",
            "No customer found to clear ped task for player %d", callerServerId)
        return
    end

    Debug("info", "Clearing ped task for customer %d", customerServerId)

    -- Tell the customer's client to stop the animation and destroy the camera
    TriggerClientEvent(
        Scriptname .. ":client:clearPedTask",
        customerServerId
    )
end)

-- ============================================================
-- NET EVENT: clearNailDesign
-- Fired by a client to wipe their own confirmed nail data.
-- Removes the entry from PlayerNails (does NOT touch the DB).
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:clearNailDesign")
AddEventHandler(Scriptname .. ":server:clearNailDesign", function()
    local callerServerId = source
    if not callerServerId then return end

    Debug("info", "Clearing nail design for player %d", callerServerId)

    ClearPlayerNails(callerServerId)

    Debug("success", "Nail design cleared for player %d", callerServerId)
end)

-- ============================================================
-- NET EVENT: saveNailDesign
-- Fired by the employee's client when they click "Save" in the
-- NUI. Promotes the customer's live preview to the confirmed
-- store and writes it to the database with an upsert.
-- Broadcasts createNailDesign (or deleteNailDesign when empty)
-- to all clients so props update everywhere.
-- @param customerChairCoords  vector3  - World coords of the customer chair
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:saveNailDesign")
AddEventHandler(Scriptname .. ":server:saveNailDesign", function(customerChairCoords)
    local employeeServerId = source
    if not employeeServerId then return end

    Debug("info", "Player %d saving nail design", employeeServerId)

    -- Identify the customer seated at the chair
    local customerServerId = GetClosestPlayer(
        vector3(customerChairCoords.x, customerChairCoords.y, customerChairCoords.z),
        1.5,
        source -- ignora quem está fazendo (manicure)
    )

    if not customerServerId then
        Debug("warning",
            "No customer found to save nail design for player %d", employeeServerId)
        return
    end

    local Passport = tonumber(Framework.GetPlayerIdentifier(customerServerId))
    if not Passport then
        Debug("error", "Failed to get Passport for customer %d", customerServerId)
        return
    end

    -- Snapshot the current preview data, then clear the preview store
    local previewData = GetPlayerPreviewNailData(customerServerId)
    ClearPreviewNailDesign(customerServerId)

    -- Promote the preview to the confirmed store
    if previewData and next(previewData) then
        UpdatePlayerNails(customerServerId, previewData)
    else
        SetPlayerNails(customerServerId, {})
    end

    -- Upsert the design into the database
    vRP.Query("night_nailshop/Set",{ Passport = Passport, nail_data = json.encode(previewData or {}) })

    -- Broadcast the result to all clients
    if previewData and next(previewData) then
        -- Design is non-empty: tell clients to render the nail props
        TriggerClientEvent(
            Scriptname .. ":client:createNailDesign",
            -1,             -- all clients
            customerServerId,
            previewData
        )
    else
        -- Design is empty: tell clients to remove any existing nail props
        TriggerClientEvent(
            Scriptname .. ":client:deleteNailDesign",
            -1,             -- all clients
            customerServerId
        )
        return
    end

    Debug("success",
        "Nail design saved to database for customer %d", customerServerId)
end)

-- ============================================================
-- NET EVENT: restoreNailDesign
-- Fired by the employee's client when they click "Restore" to
-- revert the customer's nails to their last saved (DB) state.
-- Clears the preview, reloads from DB, and broadcasts accordingly.
-- @param customerChairCoords  vector3  - World coords of the customer chair
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:restoreNailDesign")
AddEventHandler(Scriptname .. ":server:restoreNailDesign", function(customerChairCoords)
    local employeeServerId = source
    if not employeeServerId then return end

    Debug("info", "Player %d restoring nail design", employeeServerId)

    -- Identify the customer
    local customerServerId = GetClosestPlayer(
        vector3(customerChairCoords.x, customerChairCoords.y, customerChairCoords.z),
        1.5,
        source -- ignora quem está fazendo (manicure)
    )

    if not customerServerId then
        Debug("warning",
            "No customer found to restore nail design for player %d", employeeServerId)
        return
    end

    -- Reload the saved design from the database
    local savedNailData = LoadOrCreatePlayerNailData(customerServerId)

    -- Overwrite the confirmed store and discard any unsaved preview
    SetPlayerNails(customerServerId, savedNailData)
    ClearPreviewNailDesign(customerServerId)

    -- Broadcast the restored design to all clients
    if savedNailData and next(savedNailData) then
        TriggerClientEvent(
            Scriptname .. ":client:createNailDesign",
            -1,             -- all clients
            customerServerId,
            savedNailData
        )
    else
        -- No saved design exists: remove all nail props
        TriggerClientEvent(
            Scriptname .. ":client:deleteNailDesign",
            -1,             -- all clients
            customerServerId
        )
        return
    end

    Debug("success", "Nail design restored for customer %d", customerServerId)
end)

-- ============================================================
-- NET EVENT: onPedChanged
-- Fired by a client when their ped entity is replaced (respawn,
-- model change, etc.). Reloads the player's nail data from the
-- database and refreshes the server-side confirmed store.
-- The client-side ped cache handler then re-attaches the props.
-- ============================================================
RegisterNetEvent(Scriptname .. ":server:onPedChanged")
AddEventHandler(Scriptname .. ":server:onPedChanged", function()
    local callerServerId = source
    if not callerServerId then return end

    Debug("info", "Ped changed for player %d, reloading nail data", callerServerId)

    -- Reload from the database to ensure we have the latest saved state
    local nailData = LoadOrCreatePlayerNailData(callerServerId)

    -- Update the server-side confirmed store
    SetPlayerNails(callerServerId, nailData)

    Debug("success", "Nail data reloaded for player %d", callerServerId)
end)
