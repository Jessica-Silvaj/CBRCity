-- ============================================================
-- NAIL STUDIO RESOURCE - NUI CALLBACKS (DEOBFUSCATED)
-- ============================================================
-- Registers all NUI (HTML front-end → Lua client) callbacks.
-- Each callback receives:
--   data (A0_2) - payload sent from the NUI JavaScript
--   cb   (A1_2) - callback function that must be called with
--                 "ok" to acknowledge the message to the NUI
-- ============================================================

-- Load the main config (used to look up studio/table coords)
local Config = LoadNailConfig()

-- ============================================================
-- HAND CAMERA OFFSET VECTORS
-- Used (by other scripts) to position the scripted camera
-- relative to each hand when previewing nail designs.
-- ============================================================
local HandCameraOffsets = {}

-- Left hand camera offset (slightly left and forward of center)
HandCameraOffsets.left_hand  = vec3(-0.33, -0.05, 0.1)

-- Right hand camera offset (slightly right and forward of center)
HandCameraOffsets.right_hand = vec3(0.2,  -0.05, 0.1)

-- ============================================================
-- NUI CALLBACK: "nui/checked"
-- Fired by the NUI once the HTML/JS has fully initialised.
-- Sets the global NuiLoaded flag so other scripts stop waiting.
-- ============================================================
RegisterNUICallback("nui/checked", function(data, cb)
    -- Signal to the client that the NUI is ready to receive messages
    NuiLoaded = true

    cb("ok")
end)

-- ============================================================
-- NUI CALLBACK: "nui/save-naildesign"
-- Fired when the player (employee) clicks "Save" in the nail
-- design UI. Tells the server to persist the current design for
-- the customer sitting at the active studio table.
-- ============================================================
RegisterNUICallback("nui/save-naildesign", function(data, cb)
    -- Look up the customer's world coordinates for this table
    -- so the server can identify which player to save the design for.
    local customerCoords = Config.NailStudios[StudioIndex].tables[TableIndex].customer.coords

    TriggerServerEvent(Scriptname .. ":server:saveNailDesign", customerCoords)

    cb("ok")
end)

-- ============================================================
-- NUI CALLBACK: "nui/restore-naildesign"
-- Fired when the player clicks "Restore" to revert to the
-- customer's previously saved nail design (undo unsaved changes).
-- ============================================================
RegisterNUICallback("nui/restore-naildesign", function(data, cb)
    -- Pass the customer's coords so the server knows whose design to restore
    local customerCoords = Config.NailStudios[StudioIndex].tables[TableIndex].customer.coords

    TriggerServerEvent(Scriptname .. ":server:restoreNailDesign", customerCoords)

    cb("ok")
end)

-- ============================================================
-- NUI CALLBACK: "nui/close"
-- Fired when the player closes the nail design UI.
-- Performs the full session teardown:
--   1. Clears the InNailShop flag
--   2. Releases NUI cursor focus
--   3. Transitions the scripted camera back to the game camera
--   4. Destroys the scripted camera
--   5. Clears any looping animation on the local ped
--   6. Marks the studio table as free on the server
--   7. Tells the server to clear other players' ped tasks
-- ============================================================
RegisterNUICallback("nui/close", function(data, cb)
    -- Mark the player as no longer in the nail shop
    InNailShop = false

    -- Release mouse/keyboard focus from the NUI overlay
    SetNuiFocus(false, false)

    -- Deactivate and destroy the scripted camera if one is active
    if Camera then
        RenderScriptCams(false, true, 2000, true, true)
        DestroyCam(Camera, false)
        Camera = nil
    end

    -- Stop any looping sit/nail animation playing on the local ped
    ClearPedTasks(PlayerPedId())

    -- Get the customer's world coordinates for this table
    local customerCoords = Config.NailStudios[StudioIndex].tables[TableIndex].customer.coords

    -- Free the table so other players can use it
    TriggerServerEvent(
        Scriptname .. ":server:setBusyTable",
        StudioIndex,
        TableIndex,
        false   -- busy = false (table is now available)
    )

    -- Tell the server to broadcast clearPedTask to the other
    -- participant (e.g. clear the customer's animation too)
    TriggerServerEvent(
        Scriptname .. ":server:clearPedTask",
        customerCoords
    )

    cb("ok")
end)

-- ============================================================
-- NUI CALLBACK: "nui/apply-naildesign"
-- Fired when the employee selects a nail design option in the UI.
-- Sends the selected design data to the server so it can
-- broadcast a live preview update to nearby clients.
-- @param data  table  - The selected nail design payload from the UI
-- ============================================================
RegisterNUICallback("nui/apply-naildesign", function(data, cb)
    -- Look up the customer's coords to identify the target player on the server
    local customerCoords = Config.NailStudios[StudioIndex].tables[TableIndex].customer.coords

    -- Forward the design payload to the server for preview distribution
    TriggerServerEvent(
        Scriptname .. ":server:previewNailDesign",
        customerCoords,
        data    -- contains lengthNail, patternNail, colorNail, boneIds, etc.
    )

    cb("ok")
end)

-- ============================================================
-- NUI CALLBACK: "nui/set-hand"
-- Fired when the employee switches between the left and right
-- hand view in the UI. Currently acknowledged only - the actual
-- camera repositioning is handled client-side by other logic
-- that reads HandCameraOffsets.
-- @param data  table  - Expected to contain a "hand" field ("left"/"right")
-- ============================================================
RegisterNUICallback("nui/set-hand", function(data, cb)
    -- Acknowledgement only; camera offset switching is handled elsewhere.
    cb("ok")
end)

-- ============================================================
-- NUI CALLBACK: "nui/clear-finger-design"
-- Fired when the employee clicks to remove the nail design
-- from a specific finger. Tells the server which finger on
-- which hand to clear for the current customer.
-- @param data.fingerId  number  - Index of the finger (e.g. 1-5)
-- @param data.hand      string  - "left" or "right"
-- ============================================================
RegisterNUICallback("nui/clear-finger-design", function(data, cb)
    -- Look up the customer's coords to identify the target player
    local customerCoords = Config.NailStudios[StudioIndex].tables[TableIndex].customer.coords

    TriggerServerEvent(
        Scriptname .. ":server:clearFingerDesign",
        customerCoords,
        data.fingerId,
        data.hand
    )

    cb("ok")
end)
