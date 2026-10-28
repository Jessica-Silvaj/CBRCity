-- ============================================================
-- NAIL STUDIO RESOURCE - CLIENT SCRIPT 2 (DEOBFUSCATED)
-- ============================================================
-- Handles:
--   * Nail bone offset/rotation data tables per nail length type
--   * Global state (Camera, TableIndex, StudioIndex, InNailShop)
--   * Creating / destroying nail prop objects on player peds
--   * Net events: invitations, session entry, design create/delete/preview
--   * Background thread: range-based nail LOD management
--   * Export: isInNailShop()
-- ============================================================

-- ============================================================
-- SECTION 1: NAIL BONE POSITION DATA
-- Each sub-table is keyed by GTA bone ID.
-- Each entry has:
--   offset   {x,y,z}  - local position offset from the bone
--   rotation {x,y,z}  - local rotation when attaching the prop
-- ============================================================

local NailBoneData = {}

-- ------------------------------------------------------------
-- LONG NAILS bone attachment data
-- ------------------------------------------------------------
local longNailBones = {}

longNailBones[45] = {
    offset   = { x = 0.0419,  y = 0.002,   z = -0.0019 },
    rotation = { x = 121.99,  y = 35.34,   z = -94.47  },
}
longNailBones[50] = {
    offset   = { x = 0.0408,  y = 0.0035,  z = 0.0012  },
    rotation = { x = 106.29,  y = 17.15,   z = -90.12  },
}
longNailBones[54] = {
    offset   = { x = 0.0364,  y = 0.0099,  z = -0.0013 },
    rotation = { x = 117.36,  y = 29.23,   z = -85.64  },
}
longNailBones[57] = {
    offset   = { x = 0.0371,  y = 0.0067,  z = -0.0021 },
    rotation = { x = 91.33,   y = 2.65,    z = -89.87  },
}
longNailBones[60] = {
    offset   = { x = 0.043,   y = 0.0045,  z = 0.0016  },
    rotation = { x = 12.49,   y = -79.76,  z = -100.52 },
}
longNailBones[74] = {
    offset   = { x = 0.041565931517198,  y = 7.1277291862876e-4,   z = 0.0011340769009809 },
    rotation = { x = 72.377156133484,    y = -21.208994747002,     z = -98.397179745525   },
}
longNailBones[79] = {
    offset   = { x = 0.0378,  y = -0.0025, z = 0.0026  },
    rotation = { x = -90.5,   y = -0.56,   z = 93.65   },
}
longNailBones[83] = {
    offset   = { x = 0.042803197994772,  y = -0.0065858136686972,  z = -0.0024384926914058 },
    rotation = { x = -79.995496116834,   y = -7.9000681336061,     z = 95.002422139562     },
}
longNailBones[86] = {
    offset   = { x = 0.038597267490218,  y = -0.008014213614799,   z = -0.0011251820642822 },
    rotation = { x = -89.989517319625,   y = 2.8665671401102,      z = 90.209610059591     },
}
longNailBones[89] = {
    offset   = { x = 0.0421,  y = -0.0063, z = 0.0016  },
    rotation = { x = -85.78,  y = -3.63,   z = 89.68   },
}

NailBoneData.long_nails = longNailBones

-- ------------------------------------------------------------
-- MEDIUM NAILS bone attachment data
-- (identical values to long_nails in this build)
-- ------------------------------------------------------------
local medNailBones = {}

medNailBones[45] = {
    offset   = { x = 0.0419,  y = 0.002,   z = -0.0019 },
    rotation = { x = 121.99,  y = 35.34,   z = -94.47  },
}
medNailBones[50] = {
    offset   = { x = 0.0408,  y = 0.0035,  z = 0.0012  },
    rotation = { x = 106.29,  y = 17.15,   z = -90.12  },
}
medNailBones[54] = {
    offset   = { x = 0.0364,  y = 0.0099,  z = -0.0013 },
    rotation = { x = 117.36,  y = 29.23,   z = -85.64  },
}
medNailBones[57] = {
    offset   = { x = 0.0371,  y = 0.0067,  z = -0.0021 },
    rotation = { x = 91.33,   y = 2.65,    z = -89.87  },
}
medNailBones[60] = {
    offset   = { x = 0.043,   y = 0.0045,  z = 0.0016  },
    rotation = { x = 12.49,   y = -79.76,  z = -100.52 },
}
medNailBones[74] = {
    offset   = { x = 0.041565931517198,  y = 7.1277291862876e-4,   z = 0.0011340769009809 },
    rotation = { x = 72.377156133484,    y = -21.208994747002,     z = -98.397179745525   },
}
medNailBones[79] = {
    offset   = { x = 0.0378,  y = -0.0025, z = 0.0026  },
    rotation = { x = -90.5,   y = -0.56,   z = 93.65   },
}
medNailBones[83] = {
    offset   = { x = 0.042803197994772,  y = -0.0065858136686972,  z = -0.0024384926914058 },
    rotation = { x = -79.995496116834,   y = -7.9000681336061,     z = 95.002422139562     },
}
medNailBones[86] = {
    offset   = { x = 0.038597267490218,  y = -0.008014213614799,   z = -0.0011251820642822 },
    rotation = { x = -89.989517319625,   y = 2.8665671401102,      z = 90.209610059591     },
}
medNailBones[89] = {
    offset   = { x = 0.0421,  y = -0.0063, z = 0.0016  },
    rotation = { x = -85.78,  y = -3.63,   z = 89.68   },
}

NailBoneData.med_nails = medNailBones

-- ------------------------------------------------------------
-- SMALL NAILS bone attachment data
-- ------------------------------------------------------------
local smallNailBones = {}

smallNailBones[45] = {
    offset   = { x = 0.043832962665192,  y = 0.0029797500351826,  z = -3.3803222250721e-4 },
    rotation = { x = 93.327700047382,    y = 4.5513897140006,     z = -92.073333844121    },
}
smallNailBones[50] = {
    offset   = { x = 0.0408,  y = 0.0035,  z = 0.0012  },
    rotation = { x = 106.29,  y = 17.15,   z = -90.12  },
}
smallNailBones[54] = {
    offset   = { x = 0.041261098206178,  y = 0.012563422702716,   z = -0.0021400435474164 },
    rotation = { x = 89.329402098598,    y = 0.29923426156363,    z = -75.064373982602    },
}
smallNailBones[57] = {
    offset   = { x = 0.038739422760841,  y = 0.011933350128668,   z = -0.001096652965762 },
    rotation = { x = 87.330525039615,    y = -0.44533176215693,   z = -73.815570337228   },
}
smallNailBones[60] = {
    offset   = { x = 0.043356235191595,  y = 0.0092550063587082,  z = 0.0018834934295478 },
    rotation = { x = 141.48852872323,    y = 50.366481669962,     z = -69.331143717485   },
}
smallNailBones[74] = {
    offset   = { x = 0.042738685543554,  y = 0.0030700770559755,  z = -3.4902156625734e-4 },
    rotation = { x = 31.514193239882,    y = -58.303121807096,    z = -89.828172891646    },
}
smallNailBones[79] = {
    offset   = { x = 0.0378,  y = -0.0025, z = 0.0026  },
    rotation = { x = -90.5,   y = -0.56,   z = 93.65   },
}
smallNailBones[83] = {
    offset   = { x = 0.041710441419809,  y = -0.013572127407457,  z = -0.0023077441527759 },
    rotation = { x = -99.778487052056,   y = 13.210119099762,     z = 72.911899224925     },
}
smallNailBones[86] = {
    offset   = { x = 0.037790016374402,  y = -0.010792258281458,  z = -3.4876135956913e-4 },
    rotation = { x = -77.016895694409,   y = -12.489314860287,    z = 75.54664978107      },
}
smallNailBones[89] = {
    offset   = { x = 0.0421,  y = -0.0063, z = 0.0016  },
    rotation = { x = -85.78,  y = -3.63,   z = 89.68   },
}

NailBoneData.small_nails = smallNailBones

-- ------------------------------------------------------------
-- SMALL FRENCH / CUT FRENCH nail bone attachment data
-- (used for the nude/uncoloured french-tip props)
-- ------------------------------------------------------------
local smallFrenchBones = {}

smallFrenchBones[45] = {
    offset   = { x = 0.043832962665192,  y = 0.0029797500351826,  z = -3.3803222250721e-4 },
    rotation = { x = 93.327700047382,    y = 4.5513897140006,     z = -92.073333844121    },
}
smallFrenchBones[50] = {
    offset   = { x = 0.0408,  y = 0.0035,  z = 0.0012  },
    rotation = { x = 106.29,  y = 17.15,   z = -90.12  },
}
smallFrenchBones[54] = {
    offset   = { x = 0.041261098206178,  y = 0.012563422702716,   z = -0.0021400435474164 },
    rotation = { x = 89.329402098598,    y = 0.29923426156363,    z = -75.064373982602    },
}
smallFrenchBones[57] = {
    offset   = { x = 0.038739422760841,  y = 0.011933350128668,   z = -0.001096652965762 },
    rotation = { x = 87.330525039615,    y = -0.44533176215693,   z = -73.815570337228   },
}
smallFrenchBones[60] = {
    offset   = { x = 0.043356235191595,  y = 0.0092550063587082,  z = 0.0018834934295478 },
    rotation = { x = 141.48852872323,    y = 50.366481669962,     z = -69.331143717485   },
}
smallFrenchBones[74] = {
    offset   = { x = 0.042738685543554,  y = 0.0030700770559755,  z = -3.4902156625734e-4 },
    rotation = { x = 31.514193239882,    y = -58.303121807096,    z = -89.828172891646    },
}
smallFrenchBones[79] = {
    offset   = { x = 0.041386097604004,  y = -0.006432092518953,  z = 0.001721046848636 },
    rotation = { x = -89.94976422893,    y = -0.33389391140474,   z = 81.443730130724    },
}
smallFrenchBones[83] = {
    offset   = { x = 0.038471431929224,  y = -0.014331578206207,  z = -0.0030691225979601 },
    rotation = { x = -92.262948164908,   y = 7.936557461017,      z = 74.029281593183     },
}
smallFrenchBones[86] = {
    offset   = { x = 0.039656889983576,  y = -0.011041566071641,  z = -8.363354259384e-4 },
    rotation = { x = -91.188877598269,   y = 5.0726620725947,     z = 76.791211755058     },
}
smallFrenchBones[89] = {
    offset   = { x = 0.0421,  y = -0.0063, z = 0.0016  },
    rotation = { x = -85.78,  y = -3.63,   z = 89.68   },
}

NailBoneData.small_french = smallFrenchBones

-- ============================================================
-- SECTION 2: MODULE DEPENDENCIES & GLOBAL STATE
-- ============================================================

-- Load the main config (studios, blip settings, finger bone map, etc.)
local Config = LoadNailConfig()

-- Global camera handle used by the nail-shop scripted camera
Camera     = nil

-- Currently active table/studio indices (set when entering a session)
TableIndex  = nil
StudioIndex = nil

-- Flag: true while the local player is seated in the nail shop
InNailShop = false

-- Sparse table: PlayerNails[tostring(serverId)][tostring(boneId)] = entityHandle
-- Stores all spawned nail prop entities, keyed by player server ID then bone ID.
PlayerNails    = {}

-- Sparse table: PlayerNailDatas[tostring(serverId)] = nailDataTable
-- Caches the last received nail design data per player so nails can be
-- re-attached if the ped model is replaced (e.g. after respawn).
PlayerNailDatas = {}

-- Maximum distance (in units) within which nail props are rendered for other players.
local NAIL_RENDER_DISTANCE = 200.0

-- Whether the local player is fully loaded (set by resource/player load events).
local isPlayerLoaded = false

-- ============================================================
-- SECTION 3: NAIL CLEANUP HELPER
-- ============================================================

-- ------------------------------------------------------------
-- FUNCTION: CleanupNailsForPlayer
-- Deletes all spawned nail prop objects for the given server ID
-- and removes them from the PlayerNails tracking table.
-- @param serverId  number  - The player's server-side ID
-- ------------------------------------------------------------
local function CleanupNailsForPlayer(serverId)
    local key = tostring(serverId)

    if PlayerNails[key] then
        -- Iterate all bone-keyed nail entities and delete each one
        for boneKey, nailEntity in pairs(PlayerNails[key]) do
            if DoesEntityExist(nailEntity) then
                DeleteObject(nailEntity)
            end
        end

        -- Remove the entry from the tracking table
        PlayerNails[key] = nil

        Debug("info", "Cleaned up nails for player %d", serverId)
    end
end

-- ============================================================
-- SECTION 4: CORE NAIL CREATION
-- ============================================================

-- ------------------------------------------------------------
-- FUNCTION: CreateNailsForPlayer  (global, exposed below)
-- Spawns and attaches all nail prop objects onto a target ped.
-- Skips players who are too far away (> 50 units) unless the
-- target is the local player themselves (distance == 0).
--
-- @param serverId    number  - Server ID of the customer player
-- @param targetPed   number  - Entity handle of the customer's ped
-- @param nailDesign  table   - Design data: { [boneId] = { lengthNail, patternNail, colorNail, ... } }
-- ------------------------------------------------------------
local function CreateNailsForPlayer(serverId, targetPed, nailDesign)
    local localPed = PlayerPedId()

    -- Resolve the ped from the server ID (for distance checks)
    local remotePlayer = GetPlayerFromServerId(serverId)
    local remotePed    = GetPlayerPed(remotePlayer)

    -- Guard: ped must exist in the world
    if not DoesEntityExist(remotePed) then
        Debug("warning", "Ped does not exist for preview, customer ID: %d", serverId)
        return
    end

    -- Distance check: skip if the target ped is more than 50 units away,
    -- UNLESS the distance is exactly 0 (same ped) or the target is the local player.
    local localPos  = GetEntityCoords(localPed)
    local remotePos = GetEntityCoords(remotePed)
    local distance  = #(localPos - remotePos)

    if distance > 50.0 then
        Debug("warning", "Target too far away for preview, customer ID: %d", serverId)
        return
    end

    Debug("info", "Creating nails for player %d", serverId)

    -- Ensure there is a tracking sub-table for this player
    local key = tostring(serverId)
    if not PlayerNails[key] then
        PlayerNails[key] = {}
    end
    local playerNailObjects = PlayerNails[key]

    -- --------------------------------------------------------
    -- Group design entries by (lengthNail + "_" + patternNail)
    -- so we only load each model hash once per group.
    -- --------------------------------------------------------
    local nailGroups = {}   -- key: "length_pattern", value: { objectHash, nails = { {boneId, data} } }

    for boneId, nailData in pairs(nailDesign) do
        local objectHash = nil
        local lengthNail = nailData.lengthNail

        if lengthNail == "small_french" or lengthNail == "cut_french" then
            -- French/cut nails use a shared nude (no-tint) model
            local sizeTag = (lengthNail == "small_french") and "small" or "cut"
            objectHash = GetHashKey("qua_nail_nude_notint_" .. sizeTag)
        else
            -- Standard nails: model name is built from length + pattern
            objectHash = GetHashKey("qua_nail_" .. lengthNail .. "_" .. nailData.patternNail)
        end

        local groupKey = lengthNail .. "_" .. nailData.patternNail

        if not nailGroups[groupKey] then
            nailGroups[groupKey] = {
                objectHash = objectHash,
                nails      = {},
            }
        end

        table.insert(nailGroups[groupKey].nails, {
            boneId = boneId,
            data   = nailData,
        })
    end

    -- Get the remote ped's current world position to spawn objects nearby
    local spawnOrigin = GetEntityCoords(remotePed)

    -- --------------------------------------------------------
    -- For each model group: load the model, then create and
    -- attach one prop per finger bone in that group.
    -- --------------------------------------------------------
    for groupKey, groupData in pairs(nailGroups) do
        -- Stream the model in if it isn't already loaded
        if not HasModelLoaded(groupData.objectHash) then
            RequestModel(groupData.objectHash)
            local ModelTimeout = GetGameTimer() + 5000
            while not HasModelLoaded(groupData.objectHash) and GetGameTimer() < ModelTimeout do
                Wait(10)
            end
        end

        for _, nailEntry in ipairs(groupData.nails) do
            local boneId   = nailEntry.boneId
            local nailData = nailEntry.data

            -- If a nail prop already exists on this bone, remove it first
            if playerNailObjects[boneId] then
                if DoesEntityExist(playerNailObjects[boneId]) then
                    DeleteObject(playerNailObjects[boneId])
                end
                playerNailObjects[boneId] = nil
            end

            -- Convert boneId to a number for native calls
            local boneIdNum = tonumber(boneId)
            if not boneIdNum then
                Debug("warning", "Invalid bone ID %s", tostring(boneId))
            else
                -- Look up the attachment offset/rotation for this bone
                local boneAttachment = nil
                local lengthNail     = nailData.lengthNail

                if lengthNail == "small_french" or lengthNail == "cut_french" then
                    boneAttachment = NailBoneData.small_french[boneIdNum]
                else
                    -- e.g. "long_nails", "med_nails", "small_nails"
                    local dataKey = lengthNail .. "_nails"
                    boneAttachment = NailBoneData[dataKey][boneIdNum]
                end

                if not boneAttachment then
                    Debug("warning",
                        "No position data for bone %d with length %s",
                        boneIdNum, nailData.lengthNail)
                else
                    -- Spawn the nail prop at the ped's current position
                    local nailObject = CreateObject(
                        groupData.objectHash,
                        spawnOrigin.x,
                        spawnOrigin.y,
                        spawnOrigin.z,
                        false,  -- isNetwork
                        true,   -- bScriptHostObj
                        false   -- dynamic
                    )

                    if not DoesEntityExist(nailObject) then
                        Debug("warning",
                            "Failed to create object for bone %d with length %s",
                            boneIdNum, nailData.lengthNail)
                    else
                        -- Attach the nail prop to the correct finger bone on the ped
                        AttachEntityToEntity(
                            nailObject,              -- object to attach
                            remotePed,               -- entity to attach to
                            boneIdNum,               -- bone index
                            boneAttachment.offset.x, -- offset X
                            boneAttachment.offset.y, -- offset Y
                            boneAttachment.offset.z, -- offset Z
                            boneAttachment.rotation.x, -- rot X
                            boneAttachment.rotation.y, -- rot Y
                            boneAttachment.rotation.z, -- rot Z
                            true,   -- useSoftPinning
                            true,   -- collision
                            false,  -- isPed
                            true,   -- vertexIndex (bone)
                            1,      -- fixedRot
                            true    -- p9
                        )

                        -- Apply colour variation for non-french nails
                        if lengthNail ~= "small_french" and lengthNail ~= "cut_french" then
                            SetObjectTextureVariation(nailObject, nailData.colorNail)
                        end

                        Debug("info",
                            "Created nail object for bone %s (object: %d)",
                            boneId, nailObject)

                        -- Store the entity handle in the tracking table
                        playerNailObjects[tostring(boneId)] = nailObject
                    end
                end
            end
        end

        -- Release the model from memory now that all props are spawned
        SetModelAsNoLongerNeeded(groupData.objectHash)
    end

    Debug("success", "Successfully created all nails for player %d", serverId)
end

-- Expose as a global so other scripts can call it
CreateNailsForPlayer = CreateNailsForPlayer

-- ============================================================
-- SECTION 5: PED CHANGE HANDLER
-- When the local player's ped entity changes (respawn, model
-- change, etc.) re-attach their saved nail design to the new ped.
-- ============================================================
CreateThread(function()
    local oldPed = PlayerPedId()

    while true do
        Wait(1000)

        local newPed = PlayerPedId()
        if newPed and newPed ~= 0 and newPed ~= oldPed then
            local localServerId = GetPlayerServerId(PlayerId())

            Debug("info","Ped changed for player %d (old: %d, new: %d)",localServerId,oldPed or 0,newPed)
            TriggerServerEvent(Scriptname .. ":server:onPedChanged")

            Wait(1000)

            local savedData = PlayerNailDatas[tostring(localServerId)]
            if DoesEntityExist(newPed) and savedData and next(savedData) then
                CleanupNailsForPlayer(localServerId)
                CreateNailsForPlayer(localServerId,newPed,savedData)
            end

            oldPed = newPed
        end
    end
end)

-- ============================================================
-- SECTION 6: RESOURCE LIFECYCLE EVENTS
-- ============================================================

-- ------------------------------------------------------------
-- onResourceStart: run initialisation when this resource starts
-- ------------------------------------------------------------
AddEventHandler("onResourceStart", function(startingResourceName)
    if startingResourceName == GetCurrentResourceName() then
        isPlayerLoaded = true

        Debug("info", "Resource %s started", startingResourceName)

        -- Wait for NUI then push locale strings
        FetchNui()
        -- Create blips and target zones
        InitLocations()
    end
end)

-- ------------------------------------------------------------
-- NET EVENT: OnPlayerLoaded
-- Fired by the framework when the player character has loaded in.
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:OnPlayerLoaded")
AddEventHandler(Scriptname .. ":client:OnPlayerLoaded", function()
    isPlayerLoaded = true

    Debug("success", "Player loaded")

    FetchNui()
    InitLocations()
end)

-- ------------------------------------------------------------
-- NET EVENT: OnPlayerUnload
-- Fired by the framework when the player character is unloading
-- (e.g. before a character switch). Cleans up all nail props.
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:OnPlayerUnload")
AddEventHandler(Scriptname .. ":client:OnPlayerUnload", function()
    isPlayerLoaded = false

    local localServerId = GetPlayerServerId(PlayerId())

    Debug("info", "Player unloading, cleaning up nails")
    CleanupNailsForPlayer(localServerId)
end)

-- ------------------------------------------------------------
-- onResourceStop: destroy all nail props when the resource stops
-- ------------------------------------------------------------
AddEventHandler("onResourceStop", function(stoppingResourceName)
    if stoppingResourceName ~= GetCurrentResourceName() then
        return
    end

    Debug("info", "Resource stopping, cleaning up all nails")

    for playerKey, nailObjects in pairs(PlayerNails) do
        if PlayerNails[playerKey] then
            for boneKey, nailEntity in pairs(PlayerNails[playerKey]) do
                if DoesEntityExist(nailEntity) then
                    DeleteObject(nailEntity)
                end
            end
            PlayerNails[playerKey] = nil
            Debug("info", "Cleaned up nails for player %d", playerKey)
        end
    end

    -- Reset the tracking table
    PlayerNails = {}
end)

-- ============================================================
-- SECTION 7: NET EVENTS - SESSION & DESIGN MANAGEMENT
-- ============================================================

-- ------------------------------------------------------------
-- NET EVENT: receiveInvitation
-- The server sends this to a customer player when an employee
-- has invited them to sit in a specific studio table.
-- @param studioIdx  number  - Index of the nail studio
-- @param tableIdx   number  - Index of the table within the studio
-- @param sessionId  any     - Session identifier for joining
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:receiveInvitation")
AddEventHandler(Scriptname .. ":client:receiveInvitation", function(studioIdx, tableIdx, sessionId)
    Debug("info", "Received invitation to studio %d, table %d", studioIdx, tableIdx)

    PendingNailInvitation = {
        studioIdx = studioIdx,
        tableIdx = tableIdx,
        sessionId = sessionId
    }

    Notify.SendNotify("Convite recebido. Use /nailaccept para aceitar ou /naildecline para recusar.","info",10000)
end)

RegisterCommand("naildecline",function()
    if not PendingNailInvitation then return end

    TriggerServerEvent(
        Scriptname .. ":server:declineInvitation",
        PendingNailInvitation.studioIdx,
        PendingNailInvitation.tableIdx,
        PendingNailInvitation.sessionId
    )

    PendingNailInvitation = nil
end)

RegisterCommand("nailaccept",function()
    if not PendingNailInvitation then return end

    local studioIdx = PendingNailInvitation.studioIdx
    local tableIdx = PendingNailInvitation.tableIdx
    local sessionId = PendingNailInvitation.sessionId
    PendingNailInvitation = nil

    Debug("info", "Player accepted the nail studio invitation")

    -- Store the active studio/table context
    StudioIndex = studioIdx
    TableIndex  = tableIdx

    -- Look up the table data from config
    local tableData = Config.NailStudios[studioIdx].tables[tableIdx]

    -- Find the customer chair prop near the configured coords
    local customerChair = GetClosestObjectAtCoords(
        vector3(
            tableData.customer.coords.x,
            tableData.customer.coords.y,
            tableData.customer.coords.z
        ),
        1.5
    )

    if not customerChair then
        Debug("error",
            "No chair found for customer at studio %d, table %d",
            studioIdx, tableIdx)
        return
    end

    -- --------------------------------------------------------
    -- Position the local ped in the customer chair
    -- --------------------------------------------------------
    local seatWorldPos = GetOffsetFromEntityInWorldCoords(
        customerChair,
        tableData.customer.chairOffset.x,
        tableData.customer.chairOffset.y,
        tableData.customer.chairOffset.z
    )

    local seatHeading = GetEntityHeading(customerChair) - 180

    local seatVector = vector4(
        seatWorldPos.x,
        seatWorldPos.y,
        seatWorldPos.z,
        seatHeading
    )

    local ped = PlayerPedId()

    SetEntityHeading(ped, seatVector.w or 0.0)
    SetEntityCoords(
        ped,
        seatVector.x, seatVector.y, seatVector.z,
        false, false, false, true
    )

    -- Play the nail-sit animation
    local animDict = "adezanim@anim"
    local animClip = "adezanim_clip"

    if LoadAnimDict(animDict) then
        TaskPlayAnim(ped, animDict, animClip,
            8.0, 8.0, -1, 1, 0, false, false, false)
        RemoveAnimDict(animDict)
    end

    -- Mark the table as occupied on the server
    TriggerServerEvent(
        Scriptname .. ":server:setBusyTable",
        studioIdx, tableIdx, true
    )

    -- --------------------------------------------------------
    -- Create and configure the scripted overhead camera
    -- --------------------------------------------------------
    local scriptedCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    Camera = scriptedCamera

    local camOffset = tableData.customer.cameraOffset
    if not camOffset then
        camOffset = vec3(0.0, 0.0, 1.5)
    end

    local camWorldPos = GetOffsetFromEntityInWorldCoords(
        customerChair,
        camOffset.x, camOffset.y, camOffset.z
    )

    SetCamCoord(scriptedCamera, camWorldPos.x, camWorldPos.y, camWorldPos.z)
    SetCamRot(scriptedCamera, 270.0, 0.0, GetEntityHeading(customerChair), 2)
    SetCamFov(scriptedCamera, 70.0)
    SetCamActive(scriptedCamera, true)
    RenderScriptCams(true, true, 2000, true, true)

    InNailShop = true

    -- Wait for camera transition before showing UI
    Wait(1000)

    -- Notify the server we have accepted and joined the session
    TriggerServerEvent(
        Scriptname .. ":server:joinStudioSession",
        studioIdx, tableIdx, sessionId
    )
end)

-- ------------------------------------------------------------
-- NET EVENT: enterStudioSession
-- Fires on the EMPLOYEE's client when a session is confirmed.
-- Seats the employee at the employee chair and opens the NUI.
-- @param studioIdx  number  - Studio index
-- @param tableIdx   number  - Table index
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:enterStudioSession")
AddEventHandler(Scriptname .. ":client:enterStudioSession", function(studioIdx, tableIdx)
    Debug("info", "Entering studio session at studio %d, table %d", studioIdx, tableIdx)

    StudioIndex = studioIdx
    TableIndex  = tableIdx

    local tableData = Config.NailStudios[studioIdx].tables[tableIdx]

    -- Find the employee chair prop
    local employeeChair = GetClosestObjectAtCoords(
        vector3(
            tableData.employee.coords.x,
            tableData.employee.coords.y,
            tableData.employee.coords.z
        ),
        1.5
    )

    if not employeeChair then
        Debug("error",
            "No chair found for employee at studio %d, table %d",
            studioIdx, tableIdx)
        return
    end

    -- Also find the customer chair (used for camera focus point)
    local customerChair = GetClosestObjectAtCoords(
        vector3(
            tableData.customer.coords.x,
            tableData.customer.coords.y,
            tableData.customer.coords.z
        ),
        1.5
    )

    if not customerChair then
        Debug("error",
            "No chair found for customer at studio %d, table %d",
            studioIdx, tableIdx)
        return
    end

    -- --------------------------------------------------------
    -- Seat the employee at the employee chair
    -- --------------------------------------------------------
    local seatWorldPos = GetOffsetFromEntityInWorldCoords(
        employeeChair,
        tableData.employee.chairOffset.x,
        tableData.employee.chairOffset.y,
        tableData.employee.chairOffset.z
    )

    local seatHeading = GetEntityHeading(employeeChair) - 180
    local seatVector  = vector4(seatWorldPos.x, seatWorldPos.y, seatWorldPos.z, seatHeading)

    local ped = PlayerPedId()

    SetEntityHeading(ped, seatVector.w or 0.0)
    SetEntityCoords(
        ped,
        seatVector.x, seatVector.y, seatVector.z,
        false, false, false, true
    )

    -- Play an idle couch/seated animation for the employee
    local animDict = "timetable@ron@ig_3_couch"
    local animClip = "base"

    if LoadAnimDict(animDict) then
        TaskPlayAnim(ped, animDict, animClip,
            2.0, 2.0, -1, 1, 0, false, false, false)
    end

    -- --------------------------------------------------------
    -- Create and configure the scripted overhead camera,
    -- aimed at the CUSTOMER chair position
    -- --------------------------------------------------------
    local scriptedCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    Camera = scriptedCamera

    local camOffset = tableData.customer.cameraOffset
    if not camOffset then
        camOffset = vec3(0.0, 0.0, 1.5)
    end

    local camWorldPos = GetOffsetFromEntityInWorldCoords(
        customerChair,
        camOffset.x, camOffset.y, camOffset.z
    )

    SetCamCoord(scriptedCamera, camWorldPos.x, camWorldPos.y, camWorldPos.z)
    SetCamRot(scriptedCamera, 270.0, 0.0, GetEntityHeading(customerChair), 2)
    SetCamFov(scriptedCamera, 70.0)
    SetCamActive(scriptedCamera, true)
    RenderScriptCams(true, true, 2000, true, true)

    InNailShop = true

    -- Wait for the camera to settle before opening the design UI
    Wait(2000)

    -- Show the nail design NUI and give it cursor focus
    NuiMessage("nui/toggle", { show = true })
    SetNuiFocus(true, true)

    -- Request the customer's current nail data so the UI reflects
    -- what nails they already have applied
    TriggerServerEvent(
        Scriptname .. ":server:requestPlayerNailData",
        vector3(
            tableData.customer.coords.x,
            tableData.customer.coords.y,
            tableData.customer.coords.z
        )
    )
end)

-- ------------------------------------------------------------
-- NET EVENT: createNailDesign
-- Server fires this on nearby clients to instantiate a full
-- nail design on a specific customer ped.
-- @param customerServerId  number  - Customer's server ID
-- @param nailDesign        table   - Full design data table
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:createNailDesign")
AddEventHandler(Scriptname .. ":client:createNailDesign", function(customerServerId, nailDesign)
    -- Resolve the customer's ped
    local customerPed = GetPlayerPed(GetPlayerFromServerId(customerServerId))

    if not DoesEntityExist(customerPed) then
        Debug("warning",
            "Ped does not exist for create, customer ID: %d", customerServerId)
        return
    end

    Debug("info", "Creating nail design for customer %d", customerServerId)

    -- Remove any existing nail props on this player
    CleanupNailsForPlayer(customerServerId)

    -- Spawn new nail props for the full design
    CreateNailsForPlayer(customerServerId, customerPed, nailDesign)

    -- Cache the design data so it can be re-applied after a ped change
    PlayerNailDatas[tostring(customerServerId)] = nailDesign

    Debug("success", "Nail design created for customer %d", customerServerId)
end)

-- ------------------------------------------------------------
-- NET EVENT: deleteNailDesign
-- Removes all nail props and clears cached design data for a
-- specific customer.
-- @param customerServerId  number  - Customer's server ID
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:deleteNailDesign")
AddEventHandler(Scriptname .. ":client:deleteNailDesign", function(customerServerId)
    Debug("info", "Deleting nail design for customer %d", customerServerId)

    CleanupNailsForPlayer(customerServerId)

    -- Clear cached nail data
    PlayerNailDatas[tostring(customerServerId)] = nil

    Debug("success", "Nail design deleted for customer %d", customerServerId)
end)

-- ------------------------------------------------------------
-- NET EVENT: previewNailDesign
-- Applies a partial (preview) nail design on a customer ped.
-- Unlike createNailDesign, this only re-spawns the specific
-- bones provided in nailPreviewData, so the employee can show
-- individual nail changes in real time.
-- @param customerServerId  number  - Customer's server ID
-- @param nailPreviewData   table   - Array of { boneId, lengthNail, patternNail, colorNail }
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:previewNailDesign")
AddEventHandler(Scriptname .. ":client:previewNailDesign", function(customerServerId, nailPreviewData)
    local localPed = PlayerPedId()

    -- Resolve the customer's ped
    local customerPed = GetPlayerPed(GetPlayerFromServerId(customerServerId))

    if not DoesEntityExist(customerPed) then
        Debug("warning",
            "Ped does not exist for preview, customer ID: %d", customerServerId)
        return
    end

    -- Distance check: don't preview nails for players who are too far away
    local distanceToCustomer = #(GetEntityCoords(localPed) - GetEntityCoords(customerPed))

    if distanceToCustomer > 50.0 then
        Debug("warning",
            "Target too far away for preview, customer ID: %d", customerServerId)
        return
    end

    Debug("info", "Previewing nail design for customer %d", customerServerId)

    -- Ensure a tracking sub-table exists for this player
    local key = tostring(customerServerId)
    if not PlayerNails[key] then
        PlayerNails[key] = {}
    end
    local playerNailObjects = PlayerNails[key]

    -- --------------------------------------------------------
    -- Step 1: Delete existing nail props for the affected bones
    -- --------------------------------------------------------
    for _, previewEntry in pairs(nailPreviewData) do
        local boneKey = tostring(previewEntry.boneId)

        if playerNailObjects[boneKey] then
            if DoesEntityExist(playerNailObjects[boneKey]) then
                DeleteObject(playerNailObjects[boneKey])
            end
            playerNailObjects[boneKey] = nil
        end
    end

    -- --------------------------------------------------------
    -- Step 2: Spawn and attach preview props for each bone
    -- --------------------------------------------------------
    for _, previewEntry in pairs(nailPreviewData) do
        local objectHash = nil
        local lengthNail = previewEntry.lengthNail

        -- Determine the correct model hash
        if lengthNail == "small_french" or lengthNail == "cut_french" then
            local sizeTag = (lengthNail == "small_french") and "small" or "cut"
            objectHash = GetHashKey("qua_nail_nude_notint_" .. sizeTag)
        else
            objectHash = GetHashKey(
                "qua_nail_" .. lengthNail .. "_" .. previewEntry.patternNail
            )
        end

        if not objectHash then
            Debug("warning",
                "No object hash found for preview, customer ID: %d", customerServerId)
            return
        end

        -- Stream model in if needed
        if not HasModelLoaded(objectHash) then
            RequestModel(objectHash)
            local ModelTimeout = GetGameTimer() + 5000
            while not HasModelLoaded(objectHash) and GetGameTimer() < ModelTimeout do
                Wait(10)
            end
        end

        -- Look up the bone attachment data
        local boneAttachment = nil

        if lengthNail == "small_french" or lengthNail == "cut_french" then
            boneAttachment = NailBoneData.small_french[previewEntry.boneId]
        else
            local dataKey  = lengthNail .. "_nails"
            boneAttachment = NailBoneData[dataKey][previewEntry.boneId]
        end

        -- Spawn the nail prop at world origin (it will be attached immediately)
        local nailObject = CreateObject(objectHash, 0.0, 0.0, 0.0, false, true, false)

        -- Attach to the customer ped's finger bone
        AttachEntityToEntity(
            nailObject,
            customerPed,
            tonumber(previewEntry.boneId),
            boneAttachment.offset.x,
            boneAttachment.offset.y,
            boneAttachment.offset.z,
            boneAttachment.rotation.x,
            boneAttachment.rotation.y,
            boneAttachment.rotation.z,
            true, true, false, true, 1, true
        )

        -- Apply colour variation for non-french nails
        -- (condition: NOT (small_french OR cut_french))
        if not (lengthNail == "small_french" or lengthNail == "cut_french") then
            SetObjectTextureVariation(nailObject, previewEntry.colorNail)
        end

        -- Track the spawned entity
        playerNailObjects[tostring(previewEntry.boneId)] = nailObject

        -- Release model reference
        SetModelAsNoLongerNeeded(objectHash)
    end

    Debug("success", "Preview nail design applied for customer %d", customerServerId)
end)

-- ------------------------------------------------------------
-- NET EVENT: clearFingerDesign
-- Removes the nail prop from a single specific finger bone on a
-- customer ped.
-- @param customerServerId  number  - Customer's server ID
-- @param fingerId          number  - Finger index within the hand
-- @param hand              string  - "left" or "right"
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:clearFingerDesign")
AddEventHandler(Scriptname .. ":client:clearFingerDesign", function(customerServerId, fingerId, hand)
    -- Resolve the customer's ped
    local customerPed = GetPlayerPed(GetPlayerFromServerId(customerServerId))

    if not DoesEntityExist(customerPed) then
        Debug("warning",
            "Ped does not exist for clear finger design, customer ID: %d", customerServerId)
        return
    end

    -- Validate parameters
    if not fingerId or not hand then
        Debug("warning",
            "Invalid fingerId or hand for clear finger design, customer ID: %d", customerServerId)
        return
    end

    Debug("info",
        "Clearing finger design for customer %d (fingerId: %s, hand: %s)",
        customerServerId, tostring(fingerId), hand)

    -- Look up the GTA bone ID from the FingerBones config map
    -- Key format: "left_1", "right_3", etc.
    local handKey = hand
    if hand == "left" then
        handKey = "left_hand"
    elseif hand == "right" then
        handKey = "right_hand"
    end

    local fingerBoneKey = handKey .. "_" .. fingerId
    local boneId        = Config.FingerBones[fingerBoneKey]

    if not boneId then
        Debug("warning",
            "Invalid finger bone for hand %s, id %s",
            hand, tostring(fingerId))
        return
    end

    -- Get the tracking table for this player
    local key               = tostring(customerServerId)
    local playerNailObjects = PlayerNails[key]

    if not playerNailObjects then
        Debug("info", "No nail objects found for customer %d", customerServerId)
        return
    end

    local boneKey   = tostring(boneId)
    local nailEntity = playerNailObjects[boneKey]

    if nailEntity then
        -- Delete the prop if it still exists
        if DoesEntityExist(nailEntity) then
            DeleteObject(nailEntity)
            Debug("info",
                "Deleted nail object for bone %d (fingerId: %s, hand: %s) for customer %d",
                boneId, tostring(fingerId), hand, customerServerId)
        end

        playerNailObjects[boneKey] = nil

        -- If no nail props remain for this player, remove the empty sub-table
        if not next(playerNailObjects) then
            PlayerNails[key] = nil
            Debug("info", "All nail objects cleared for customer %d", customerServerId)
        end
    else
        Debug("info",
            "No nail object found for bone %d (fingerId: %s, hand: %s) for customer %d",
            boneId, tostring(fingerId), hand, customerServerId)
    end

    Debug("success", "Finger design cleared for customer %d", customerServerId)
end)

-- ------------------------------------------------------------
-- NET EVENT: clearPedTask
-- Fired by the server to end the nail shop session for this
-- client: stops any animations, deactivates the scripted camera,
-- and resets the InNailShop flag.
-- ------------------------------------------------------------
RegisterNetEvent(Scriptname .. ":client:clearPedTask")
AddEventHandler(Scriptname .. ":client:clearPedTask", function()
    -- Clear any looping animation on the player ped
    ClearPedTasks(PlayerPedId())

    -- Deactivate and destroy the scripted camera if one was created
    if Camera then
        SetCamActive(Camera, false)
        RenderScriptCams(false, true, 2000, true, true)
        DestroyCam(Camera, false)
        Camera = nil
    end

    InNailShop = false
end)

-- ============================================================
-- SECTION 8: BACKGROUND THREAD - RANGE-BASED NAIL LOD
-- Runs continuously once at least one player has nail data.
-- Every 500 ms it checks the distance from the local ped to
-- every other player who has an active nail design:
--   - Within NAIL_RENDER_DISTANCE  →  ensure nail props exist
--   - Beyond NAIL_RENDER_DISTANCE  →  delete props to save resources
-- Also cleans up props for players who have gone inactive.
-- ============================================================
CreateThread(function()
    -- Phase 1: idle until the player is loaded AND at least one
    -- entry exists in PlayerNailDatas.
    while true do
        if isPlayerLoaded then
            if next(PlayerNailDatas) ~= nil then
                break
            end
        end
        Wait(1000)
    end

    -- Phase 2: active LOD management loop
    while true do
        Wait(500)

        local localPed = PlayerPedId()

        -- Ensure the local ped is valid before doing any distance checks
        if not DoesEntityExist(localPed) then
            Wait(1000)
        else
            local localServerId = GetPlayerServerId(PlayerId())

            for playerKey, playerNailDesign in pairs(PlayerNailDatas) do
                -- Skip our own entry (local player manages their own nails separately)
                if tonumber(playerKey) == tonumber(localServerId) then
                    goto continueLoop
                end

                if playerNailDesign then
                    -- Skip players with empty design tables
                    if not next(playerNailDesign) then
                        goto continueLoop
                    end

                    -- Resolve the player handle and check if they are active
                    local remotePlayerHandle = GetPlayerFromServerId(tonumber(playerKey))
                    local isActive = (remotePlayerHandle ~= -1) and
                                     NetworkIsPlayerActive(remotePlayerHandle)

                    if not isActive then
                        -- Player has left / gone inactive: clean up their nail props
                        Debug("info", "Skipping inactive player %d", playerKey)

                        if PlayerNails[playerKey] then
                            for _, nailEntity in pairs(PlayerNails[playerKey]) do
                                if DoesEntityExist(nailEntity) then
                                    DeleteObject(nailEntity)
                                end
                            end
                        end
                        PlayerNails[playerKey] = nil

                        goto continueLoop
                    end

                    -- Resolve the player's current ped
                    local remotePed = GetPlayerPed(remotePlayerHandle)

                    if not DoesEntityExist(remotePed) or remotePed == 0 then
                        -- Ped doesn't exist (streaming out, dead, etc.): remove props
                        Debug("info", "Skipping non-existent ped for player %d", playerKey)

                        if PlayerNails[playerKey] then
                            for _, nailEntity in pairs(PlayerNails[playerKey]) do
                                if DoesEntityExist(nailEntity) then
                                    DeleteObject(nailEntity)
                                end
                            end
                        end
                        PlayerNails[playerKey] = nil

                    else
                        -- Calculate distance from our ped to this remote ped
                        local myPos     = GetEntityCoords(PlayerPedId())
                        local remotePos = GetEntityCoords(remotePed)
                        local dist      = #(myPos - remotePos)

                        if dist <= NAIL_RENDER_DISTANCE then
                            -- In range: create nail props if they don't already exist
                            if not PlayerNails[playerKey] then
                                Debug("info",
                                    "Player %d is in range (%.1f), creating nails",
                                    playerKey, dist)
                                CreateNailsForPlayer(
                                    tonumber(playerKey),
                                    remotePed,
                                    playerNailDesign
                                )
                            end
                        else
                            -- Out of range: delete nail props to save draw calls
                            if PlayerNails[playerKey] then
                                for _, nailEntity in pairs(PlayerNails[playerKey]) do
                                    if DoesEntityExist(nailEntity) then
                                        DeleteObject(nailEntity)
                                    end
                                end
                                PlayerNails[playerKey] = nil
                            end
                        end
                    end
                end

                ::continueLoop::
            end
        end
    end
end)

-- ============================================================
-- SECTION 9: EXPORT
-- ============================================================

-- Export: allows other resources to check if the local player
-- is currently seated in a nail shop session.
exports("isInNailShop", function()
    return InNailShop
end)
