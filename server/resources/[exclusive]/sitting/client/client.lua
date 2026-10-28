-- Global state variables (used by other files)
local isSitting = false
local isGettingUp = false
local sittingEntity = nil

function CanSitAgain()
    return not isSitting and not isGettingUp
end

function RaycastFromCoords(flags, startPos, direction, distance)
    local endPos = startPos + (direction * distance)
    local rayHandle = StartShapeTestLosProbe(
        startPos.x, startPos.y, startPos.z,
        endPos.x, endPos.y, endPos.z,
        flags, ignoreEntity, 4
    )
    
    local endCoords = endPos
    while true do
        Wait(0)
        local retval, hit, coords, surfaceNormal, materialHash = GetShapeTestResultIncludingMaterial(rayHandle)
        if retval ~= 1 then
            return hit, materialHash, coords, surfaceNormal, endCoords
        end
    end
end

function DrawText2D(text, showHelp)
    SetTextFont(4)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.5, 0.92)
end

function DetectStairPattern(heightArray)
    local tolerance = 0.1
    local consistencyThreshold = 0.5
    local minGap = 0.1
    
    -- Filter out zero values
    local validHeights = {}
    for _, height in ipairs(heightArray) do
        if height ~= 0.0 then
            table.insert(validHeights, height)
        end
    end
    
    if #validHeights == 0 then
        return false
    end
    
    table.sort(validHeights)
    
    -- Calculate height differences between consecutive points
    local heightDifferences = {}
    for i = 1, #validHeights - 1 do
        local diff = validHeights[i + 1] - validHeights[i]
        table.insert(heightDifferences, diff)
    end
    
    -- Filter significant differences (potential steps)
    local significantDiffs = {}
    for _, diff in ipairs(heightDifferences) do
        if diff > minGap then
            table.insert(significantDiffs, diff)
        end
    end
    
    if #significantDiffs == 0 then
        return false
    end
    
    table.sort(significantDiffs)
    
    -- Find median step height
    local medianStepHeight
    if #significantDiffs % 2 == 0 then
        local mid1 = significantDiffs[#significantDiffs // 2]
        local mid2 = significantDiffs[#significantDiffs // 2 + 1]
        medianStepHeight = (mid1 + mid2) / 2
    else
        medianStepHeight = significantDiffs[math.ceil(#significantDiffs / 2)]
    end
    
    -- Count consistent step heights
    local consistentSteps = 0
    for _, diff in ipairs(heightDifferences) do
        if math.abs(diff - medianStepHeight) < (medianStepHeight * tolerance) then
            consistentSteps = consistentSteps + 1
        end
    end
    
    local consistencyRatio = consistentSteps / #heightDifferences
    return consistencyRatio >= consistencyThreshold
end

function FindClosestPed(position)
    local playerPed = PlayerPedId()
    local allPeds = GetGamePool('CPed')
    local closestDistance = math.huge
    local closestPed = nil
    
    for i = 0, #allPeds do
        local pedCoords = GetEntityCoords(allPeds[i])
        local distance = #(pedCoords - position)
        
        if distance <= Config.DistanceCheckPed and distance < closestDistance then
            closestDistance = distance
            closestPed = allPeds[i]
        end
    end
    
    -- Don't return player's own ped
    if closestPed == playerPed then
        closestPed = nil
    end
    
    return closestPed
end

function IsPlayerTryingToGetUp()
    if Config.UseMoveKeyToGetUp then
        local moveKeys = {32, 33, 34, 35} -- W, A, S, D
        for _, key in pairs(moveKeys) do
            if IsControlPressed(0, key) then
                return true
            end
        end
    else
        if IsDisabledControlPressed(0, Config.GetUpFromSitKey) then
            return true
        end
    end
    return false
end

function StartSittingScenario(coords, heading, scenario, animateIn, scenarioType, entity)
    if not Config.EnabledList[scenarioType] then
        return
    end
    
    if Config.Debug then
        print(string.format("%s %s", 
            Locale[Config.Language].DebugDetectionAndScenario,
            Locale[Config.Language].DebugName), scenarioType, scenario)
        print(string.format("%s %s", 
            Locale[Config.Language].DebugCoordsAndHeading,
            Locale[Config.Language].DebugName), coords.x, coords.y, coords.z, heading)
    end
    
    -- Skip if coordinates are zero
    if coords == vector3(0.0, 0.0, 0.0) then
        return
    end
    
    local playerPed = PlayerPedId()
    local playerHealth = GetEntityHealth(playerPed)
    local heightAdjustment = HeightAdjustment(playerPed)
    local adjustedCoords = vector3(coords.x, coords.y, coords.z + heightAdjustment)
    
    -- Check for nearby peds
    local nearbyPed = FindClosestPed(adjustedCoords)
    if nearbyPed then
        SittingNotification(Locale[Config.Language].TooCloseFromAnotherPed, 2)
        return
    end
    
    sittingEntity = entity
    TaskStartScenarioAtPosition(playerPed, scenario, adjustedCoords, heading, -1, animateIn, 1)
    isSitting = true
    
    -- Handle camera collision for sitting entity
    CreateThread(function()
        while sittingEntity and DoesEntityExist(sittingEntity) do
            DisableCamCollisionForEntity(sittingEntity)
            Wait(0)
        end
    end)
    
    -- Main sitting loop
    while true do
        Wait(0)
        
        -- Show get up instruction
        if not Config.UseMoveKeyToGetUp then
            DisableControlAction(0, Config.GetUpFromSitKey, true)
            SittingNotification(string.format(
                Locale[Config.Language].GetUpFromKey,
                Config.GetUpFromSitKeyName
            ), 0)
        end
        
        local shouldGetUp = IsPlayerTryingToGetUp()
        
        -- Check various get up conditions
        if not shouldGetUp then
            if Config.GetUpChecks.Health then
                if GetEntityHealth(playerPed) < playerHealth then
                    shouldGetUp = true
                end
            end
            
            if Config.GetUpChecks.Ragdoll then
                if IsPedRagdoll(playerPed) then
                    shouldGetUp = true
                end
            end
            
            if not IsPedUsingScenario(playerPed, scenario) then
                shouldGetUp = true
            end
        end
        
        if shouldGetUp then
            isGettingUp = true
            
            -- Determine reason for getting up
            local healthDamage = Config.GetUpChecks.Health and GetEntityHealth(playerPed) < playerHealth
            local ragdollState = Config.GetUpChecks.Ragdoll and IsPedRagdoll(playerPed)
            local stillInScenario = IsPedUsingScenario(playerPed, scenario)
            
            if healthDamage then
                if Config.Debug then
                    print(string.format("%s %s", 
                        Locale[Config.Language].StandUpDamage,
                        Locale[Config.Language].DebugName))
                end
                ClearPedTasksImmediately(playerPed)
            elseif ragdollState then
                if Config.Debug then
                    print(string.format("%s %s", 
                        Locale[Config.Language].StandUpRagdoll,
                        Locale[Config.Language].DebugName))
                end
                ClearPedTasks(playerPed)
            elseif not stillInScenario then
                if Config.Debug then
                    print(string.format("%s %s", 
                        Locale[Config.Language].StandUpUnkownReason,
                        Locale[Config.Language].DebugName))
                end
            else
                if Config.Debug then
                    print(string.format("%s %s", 
                        Locale[Config.Language].StandUpGetUpKey,
                        Locale[Config.Language].DebugName))
                end
                ClearPedTasks(playerPed)
            end
            
            isSitting = false
            Wait(100)
            
            -- Reset getting up state after delay
            CreateThread(function()
                local startTime = GetGameTimer()
                local resetDelay = 1000
                
                while GetGameTimer() - startTime < resetDelay do
                    Wait(100)
                end
                
                isGettingUp = false
                
                if Config.Debug then
                    print(string.format("%s %s", 
                        Locale[Config.Language].DebugName,
                        "Player can sit again"))
                end
                
                Wait(500)
                sittingEntity = nil
            end)
            
            break
        end
    end
end

function IsChairObject(objectName)
    local chairKeywords = {"chair", "chr"}
    for _, keyword in ipairs(chairKeywords) do
        if string.find(objectName, keyword) then
            return true
        end
    end
    return false
end

-- Register key mapping if enabled
if Config.CommandUseKey then
    RegisterKeyMapping("+" .. Config.CommandName, Config.CommandTitle, 
                      Config.CommandInputMapper, Config.CommandInputParameter)
    
    RegisterCommand("+" .. Config.CommandName, function(source, args)
        TriggerEvent("sitting:sitAnywhere", args, "pressed")
    end)
    
    RegisterCommand("-" .. Config.CommandName, function(source, args)
        -- Key release handler (empty)
    end)
end

-- Register chat command
RegisterCommand(Config.CommandName, function(source, args)
    if CanSitAgain() then
        TriggerEvent("sitting:sitAnywhere", args, "command")
    else
        if isGettingUp then
            SittingNotification(Locale[Config.Language].WaitForStandUp, 2)
        end
    end
end)

-- Main sitting event handler
AddEventHandler("sitting:sitAnywhere", function(args, inputType)
    local playerPed = PlayerPedId()
    
    -- Skip if using key binding and input type is "pressed"
    if not Config.CommandUseKey and inputType == "pressed" then
        return
    end
    
    -- Validate player state
    if not IsPedOnFoot(playerPed) or not CanSitAgain() then
        return
    end
    
    if not CanSit(playerPed) then
        return
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)
    
    -- Determine raycast flags based on config
    local raycastFlags = 0
    if Config.DetectWorld then raycastFlags = raycastFlags | 1 end
    if Config.DetectProps then raycastFlags = raycastFlags | 16 end
    if Config.DetectVehicles then raycastFlags = raycastFlags | 2 end
    
    -- Get command argument or default
    local commandArg = args[1] or "nil"
    
    -- Set up raycast positions
    local lowerPos = vector3(playerCoords.x, playerCoords.y, playerCoords.z - 0.8)
    local midPos = vector3(playerCoords.x, playerCoords.y, playerCoords.z - 0.4)
    
    local hitCoords = nil
    local hitEntity = nil
    local foundSurface = false
    local retryCount = 0
    local detectedEntity = nil
    
    -- Initial forward raycast
    local hit1, mat1, coords1 = RaycastFromCoords(raycastFlags, 
        vector3(lowerPos.x, lowerPos.y, playerCoords.z + Config.MaxHeight),
        forwardVector, Config.Distance)
    
    local hit2, mat2, coords2 = RaycastFromCoords(raycastFlags, lowerPos, forwardVector, Config.Distance)
    
    -- Stair detection raycasts
    local stairDistance = Config.StairsDistance
    local stairPos = midPos + (forwardVector * stairDistance)
    local _, _, stairCoords1 = RaycastFromCoords(raycastFlags, stairPos, vector3(0.0, 0.0, -1.0), 0.5)
    local _, _, stairCoords2 = RaycastFromCoords(raycastFlags, midPos + (forwardVector * (stairDistance + 0.2)), vector3(0.0, 0.0, -1.0), 0.5)
    local _, _, stairCoords3 = RaycastFromCoords(raycastFlags, midPos + (forwardVector * (stairDistance - 0.2)), vector3(0.0, 0.0, -1.0), 0.5)
    local _, _, stairCoords4 = RaycastFromCoords(raycastFlags, midPos + (forwardVector * (stairDistance - 0.4)), vector3(0.0, 0.0, -1.0), 0.5)
    local _, _, stairCoords5 = RaycastFromCoords(raycastFlags, midPos + (forwardVector * (stairDistance - 0.6)), vector3(0.0, 0.0, -1.0), 0.5)
    
    if hit1 ~= 0 then
        foundSurface = true
        hitCoords = coords1
    end
    
    -- Vertical surface detection loop
    local currentPos = lowerPos
    while currentPos.z < (playerCoords.z + Config.MaxHeight) and not foundSurface and retryCount < Config.MaxRetryBeforeSeated do
        local hit, entity, coords = RaycastFromCoords(raycastFlags, currentPos, forwardVector, Config.Distance)
        
        if entity ~= 0 then
            detectedEntity = entity
        end
        
        if hit ~= 0 then
            hitCoords = coords
        end
        
        if hit == 0 and hitCoords == nil then
            retryCount = retryCount + 1
        elseif coords ~= vector3(0, 0, 0) then
            break
        end
        
        currentPos = vector3(currentPos.x, currentPos.y, currentPos.z + Config.Precision)
    end
    
    -- Ground detection
    local groundDistance = Config.GroundDistance
    local groundDistanceFound = 0
    local maxGroundDistance = Config.GroundDistance
    local groundHit = RaycastFromCoords(raycastFlags,
        vector3(lowerPos.x, lowerPos.y, playerCoords.z + Config.MaxHeight),
        forwardVector, Config.GroundDistance)
    
    local groundCoords = nil
    local _, groundEntity, tempGroundCoords = RaycastFromCoords(raycastFlags,
        vector3(playerCoords.x, playerCoords.y, playerCoords.z - 0.8) + (forwardVector * groundDistance),
        vector3(0.0, 0.0, -1.0), 0.4)
    
    -- Ground detection loop
    while groundHit == 0 and groundDistance >= 0 and hitCoords == nil and groundCoords == nil do
        local _, entity, coords = RaycastFromCoords(raycastFlags,
            vector3(playerCoords.x, playerCoords.y, playerCoords.z - 0.8) + (forwardVector * groundDistance),
            vector3(0.0, 0.0, -1.0), 0.4)
        
        if entity ~= 0 then
            groundCoords = coords
            if groundDistanceFound == 0 then
                groundDistanceFound = groundDistance
            end
        end
        
        if groundDistanceFound == maxGroundDistance then
            break
        end
        
        groundDistance = groundDistance - Config.Precision
    end
    
    -- Check for stair pattern
    local stairHeights = {stairCoords1.z, stairCoords2.z, stairCoords3.z, stairCoords4.z, stairCoords5.z}
    local isStairPattern = DetectStairPattern(stairHeights)
    
    -- Determine sitting scenario based on detection results
    if isStairPattern then
        StartSittingScenario(stairCoords3, GetEntityHeading(playerPed) - 180, 
                           "WORLD_HUMAN_SEAT_STEPS", false, "Stairs", nil)
    elseif hitCoords ~= nil then
        if hitCoords.z < (playerCoords.z + Config.MaxHeight - Config.Precision) then
            if retryCount > 2 then
                -- Handle chair/prop sitting
                local entityCoords = GetEntityCoords(detectedEntity)
                if detectedEntity and #entityCoords > 0 then
                    local entityName = GetEntityArchetypeName(detectedEntity)
                    local isChair = IsChairObject(entityName)
                    local sitCoords, sitHeading, scenario
                    
                    if isChair then
                        sitCoords = vector3(entityCoords.x, entityCoords.y, hitCoords.z + 0.06)
                    else
                        sitCoords = vector3(hitCoords.x, hitCoords.y, hitCoords.z + 0.06) + (forwardVector * 0.4)
                    end
                    
                    if isChair then
                        sitHeading = GetEntityHeading(detectedEntity) - 180
                    else
                        sitHeading = GetEntityHeading(playerPed) - 180
                    end
                    
                    scenario = "PROP_HUMAN_SEAT_CHAIR"
                    StartSittingScenario(sitCoords, sitHeading, scenario, false, "Chair", detectedEntity)
                else
                    StartSittingScenario(
                        vector3(hitCoords.x, hitCoords.y, hitCoords.z + 0.06) + (forwardVector * 0.4),
                        GetEntityHeading(playerPed) - 180,
                        "PROP_HUMAN_SEAT_CHAIR", false, "Sit", nil)
                end
            else
                -- Handle wall/object sitting
                local entityCoords = GetEntityCoords(detectedEntity)
                if detectedEntity and #entityCoords > 0 then
                    local entityName = GetEntityArchetypeName(detectedEntity)
                    local isChair = IsChairObject(entityName)
                    local sitCoords, sitHeading, scenario
                    
                    if isChair then
                        sitCoords = vector3(entityCoords.x, entityCoords.y, hitCoords.z)
                    else
                        sitCoords = vector3(hitCoords.x, hitCoords.y, hitCoords.z) + (forwardVector * 0.26)
                    end
                    
                    if isChair then
                        sitHeading = GetEntityHeading(detectedEntity) - 180
                    else
                        sitHeading = GetEntityHeading(playerPed) - 180
                    end
                    
                    scenario = isChair and "PROP_HUMAN_SEAT_CHAIR" or "WORLD_HUMAN_SEAT_WALL"
                    StartSittingScenario(sitCoords, sitHeading, scenario, false, "Seat (chair)", detectedEntity)
                else
                    local offset = (commandArg == "f") and 0.04 or 0.26
                    local headingOffset = (commandArg == "f") and 0 or 180
                    
                    StartSittingScenario(
                        vector3(hitCoords.x, hitCoords.y, hitCoords.z) + (forwardVector * offset),
                        GetEntityHeading(playerPed) - headingOffset,
                        "WORLD_HUMAN_SEAT_WALL", false, "Seat", nil)
                end
            end
        else
            -- High surface - leaning
            StartSittingScenario(
                vector3(hitCoords.x, hitCoords.y, playerCoords.z) - (forwardVector * 0.32),
                GetEntityHeading(playerPed) - 180,
                "WORLD_HUMAN_LEANING", false, "Wall", nil)
        end
    elseif groundCoords ~= nil and groundDistanceFound ~= maxGroundDistance then
        -- Ledge sitting
        StartSittingScenario(
            vector3(groundCoords.x, groundCoords.y, groundCoords.z) - (forwardVector * 0.2),
            GetEntityHeading(playerPed),
            "WORLD_HUMAN_SEAT_LEDGE", false, "Ledge", nil)
    else
        -- Ground sitting
        StartSittingScenario(playerCoords, GetEntityHeading(playerPed), 
                           "WORLD_HUMAN_PICNIC", true, "Ground", nil)
    end
end)

-- Export for other scripts
exports("IsSitting", function()
    return isSitting
end)