-- Afinador de rotação/posição/centro da pipa em tempo real.
-- /pipa_tune liga e desliga.

local tuning = false

local KEY = {
    pitchUp   = 111, -- NUMPAD 8
    pitchDown = 112, -- NUMPAD 5
    yawLeft   = 108, -- NUMPAD 4
    yawRight  = 109, -- NUMPAD 6
    rollLeft  = 117, -- NUMPAD 7
    rollRight = 118, -- NUMPAD 9
    metersUp  = 314, -- NUMPAD +
    metersDn  = 315, -- NUMPAD -
    elevUp    = 10,  -- PAGE UP
    elevDown  = 11,  -- PAGE DOWN
    bigStep   = 21,  -- LEFT SHIFT
    centerMode = 19, -- LEFT ALT = ajusta centro da linha em vez da rotacao
}

local function held(control)
    return IsControlPressed(0, control) or IsDisabledControlPressed(0, control)
end

local function just(control)
    return IsControlJustPressed(0, control) or IsDisabledControlJustPressed(0, control)
end

local function round(v)
    return math.floor((tonumber(v) or 0.0) * 100.0 + 0.5) / 100.0
end

local function offset()
    Config.KiteBaseOffset = Config.KiteBaseOffset or { pitch = 0.0, roll = 90.0, yaw = 180.0 }
    return Config.KiteBaseOffset
end

local function center()
    Config.KiteCenterOffset = Config.KiteCenterOffset or { x = 0.0, y = 0.0, z = 0.0 }
    return Config.KiteCenterOffset
end

local function dumpAll()
    local o = offset()
    local c = center()
    local lines = {
        ('Config.KiteBaseOffset = { pitch = %.1f, roll = %.1f, yaw = %.1f }')
            :format(o.pitch or 0.0, o.roll or 0.0, o.yaw or 0.0),
        ('Config.KiteCenterOffset = { x = %.2f, y = %.2f, z = %.2f }')
            :format(c.x or 0.0, c.y or 0.0, c.z or 0.0),
    }
    local f = Pipa.DebugGetFlight and Pipa.DebugGetFlight()
    if f then
        lines[#lines + 1] = ('Config.InitialElev = %.1f   Config.StartLine = %.1f')
            :format(f.elev or 0.0, f.meters or 0.0)
    end
    for _, line in ipairs(lines) do
        -- print('[night_pipa] ' .. line)
    end
    return table.concat(lines, ' | ')
end

local function drawText(text, y, scale)
    SetTextFont(4)
    SetTextScale(0.0, scale or 0.34)
    SetTextColour(255, 255, 255, 230)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentSubstringPlayerName(text)
    DrawText(0.015, y)
end

RegisterCommand('pipa_tune', function()
    tuning = not tuning
    if Pipa.DebugFreeze then Pipa.DebugFreeze(tuning) end
    Pipa.Notify(tuning and 'Modo ajuste LIGADO' or 'Modo ajuste desligado')
    if not tuning then dumpAll() end
end, false)

RegisterCommand('pipa_rot', function(_, args)
    local o = offset()
    if args[1] then o.pitch = tonumber(args[1]) or o.pitch end
    if args[2] then o.roll = tonumber(args[2]) or o.roll end
    if args[3] then o.yaw = tonumber(args[3]) or o.yaw end
    Pipa.Notify(dumpAll())
end, false)

RegisterCommand('pipa_centro', function(_, args)
    local c = center()
    if args[1] then c.x = tonumber(args[1]) or c.x end
    if args[2] then c.y = tonumber(args[2]) or c.y end
    if args[3] then c.z = tonumber(args[3]) or c.z end
    Pipa.Notify(dumpAll())
end, false)

RegisterCommand('pipa_pos', function(_, args)
    if not Pipa.DebugSetFlight then return end
    if not Pipa.DebugSetFlight(tonumber(args[1]), tonumber(args[2]), nil) then
        Pipa.Notify('Ergue a pipa primeiro')
        return
    end
    Pipa.Notify(dumpAll())
end, false)

RegisterCommand('pipa_dump', function()
    Pipa.Notify(dumpAll())
end, false)

-- presets: peixinho de lado (igual referência) e variações de flip
RegisterCommand('pipa_preset', function(_, args)
    local name = tostring(args[1] or 'peixinho')
    local o = offset()
    if name == 'peixinho' or name == '1' then
        -- pose original + flip (padrão atual do config)
        o.pitch, o.roll, o.yaw = 0.0, 180.0, 0.0
        Config.DirectionRot[2] = { pitch = 60.0, roll = 180.0, yaw = 190.0 }
    elseif name == 'flip_pitch' or name == '2' then
        o.pitch, o.roll, o.yaw = 180.0, 0.0, 0.0
    elseif name == 'sem_flip' or name == '3' then
        o.pitch, o.roll, o.yaw = 0.0, 0.0, 0.0
    elseif name == 'face' or name == '4' then
        o.pitch, o.roll, o.yaw = 0.0, 180.0, 180.0
    else
        Pipa.Notify('Use: /pipa_preset peixinho|flip_pitch|sem_flip|face')
        return
    end
    Pipa.Notify(('Preset %s | %s'):format(name, dumpAll()))
end, false)

CreateThread(function()
    while true do
        if not tuning then
            Wait(300)
        else
            local o = offset()
            local c = center()
            local f = Pipa.DebugGetFlight and Pipa.DebugGetFlight()
            local step = held(KEY.bigStep) and 10.0 or 1.0
            local centerMode = held(KEY.centerMode)
            local cStep = held(KEY.bigStep) and 0.10 or 0.02

            if centerMode then
                -- ALT + numpad = move o ponto da linha no modelo
                if held(KEY.yawLeft) then c.x = round((c.x or 0.0) - cStep) end
                if held(KEY.yawRight) then c.x = round((c.x or 0.0) + cStep) end
                if held(KEY.pitchUp) then c.y = round((c.y or 0.0) + cStep) end
                if held(KEY.pitchDown) then c.y = round((c.y or 0.0) - cStep) end
                if held(KEY.rollLeft) then c.z = round((c.z or 0.0) - cStep) end
                if held(KEY.rollRight) then c.z = round((c.z or 0.0) + cStep) end
            else
                if held(KEY.pitchUp) then o.pitch = round((o.pitch or 0.0) + step) end
                if held(KEY.pitchDown) then o.pitch = round((o.pitch or 0.0) - step) end
                if held(KEY.yawLeft) then o.yaw = round((o.yaw or 0.0) - step) end
                if held(KEY.yawRight) then o.yaw = round((o.yaw or 0.0) + step) end
                if held(KEY.rollLeft) then o.roll = round((o.roll or 0.0) - step) end
                if held(KEY.rollRight) then o.roll = round((o.roll or 0.0) + step) end
            end

            if f and Pipa.DebugSetFlight then
                local elev, meters = f.elev, f.meters
                if held(KEY.metersUp) then meters = meters + step * 0.5 end
                if held(KEY.metersDn) then meters = meters - step * 0.5 end
                if held(KEY.elevUp) then elev = elev + step * 0.5 end
                if held(KEY.elevDown) then elev = elev - step * 0.5 end
                if elev ~= f.elev or meters ~= f.meters then
                    Pipa.DebugSetFlight(elev, meters, nil)
                end
            end

            drawText('~y~AJUSTE DA PIPA~s~   /pipa_tune sair   /pipa_preset vertical', 0.26, 0.36)
            drawText(('rot  pitch ~b~%.1f~s~  roll ~b~%.1f~s~  yaw ~b~%.1f~s~')
                :format(o.pitch or 0.0, o.roll or 0.0, o.yaw or 0.0), 0.30)
            drawText(('centro  x ~g~%.2f~s~  y ~g~%.2f~s~  z ~g~%.2f~s~%s')
                :format(c.x or 0.0, c.y or 0.0, c.z or 0.0, centerMode and '  ~y~[ALT]' or ''), 0.33)
            if f then
                drawText(('elev ~o~%.1f~s~  metros ~o~%.1f~s~'):format(f.elev or 0.0, f.meters or 0.0), 0.36)
            end
            drawText('NUMPAD 8/5 pitch  4/6 yaw  7/9 roll', 0.40)
            drawText('ALT+NUMPAD = centro da linha   +/- metros   PGUP/PGDN elev', 0.43)
            drawText('/pipa_preset 1..4 testa vertical    /pipa_dump copia F8', 0.46)

            Wait(0)
        end
    end
end)
