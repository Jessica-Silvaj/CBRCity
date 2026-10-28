Config = {}

-- ============================
-- Debug System
-- ============================
Config.Debug = {
    Enabled = false,                          -- Enable/disable debug mode
    LogSceneStart = true,                      -- Log when scenes start
    LogSceneStop = true,                       -- Log when scenes stop
    LogAnimationPlay = true,                   -- Log when animations play
    LogErrors = true,                          -- Log errors to console
    LogNetwork = false,                        -- Log network events
    LogPedSystem = true,                       -- Log ped save/load operations (DB reads, writes, confirmations)
    ShowScreenMessages = true,                 -- Show debug messages on screen
    ConsolePrefix = "^3[SPECTREM_DEBUG]^7 ",  -- Console message prefix
}


-- Source-based per-participant transforms and a common local animation clock
-- for extracted cutscene sequences. Set false to compare with legacy playback.
Config.AuthoredScenePlayback = true

-- ============================
-- General
-- ============================
Config.OpenKey = ''                          -- Key to open/close the director menu
Config.Command = 'director'          -- Fallback chat command to open the menu
Config.TutorialCommand = 'tutorial'  -- Guided, non-destructive tour of every Director workspace

-- ============================
-- Access Control
-- ============================
-- When AdminOnly is true, the full menu requires one of these ACE permissions
-- or a SceneAdmin license with AdminsHaveToolAccess. Public /camera is separate.
--
-- Recommended server.cfg:
-- add_ace group.admin spectrem_director.use allow
Config.Access = {
    AdminOnly = true,
    AcePermissions = {
        'spectrem_director.use',
        -- Grant spectrem_director.use explicitly; generic 'command' is not a Director role.
    },
    DeniedMessage = 'Você não tem permissão para usar o Spectrem Director.',
    LogDenied = true,
}

-- ============================
-- Scene Admin / Feature Policies
-- ============================
-- /sceneadmin is available only to these Rockstar license identifiers. The
-- license belongs to a player (license/license2), not to sv_licenseKey.
-- Keep the value server-owned when possible; this resource needs config.lua as
-- a shared file for FiveM, so identifiers are treated as allowlist data only.
Config.SceneAdmin = {
    Command = 'diretoradmin',
    CameraCommand = 'camera', -- Opens only Camera Controls; public users cannot open F5 /director /tutorial.
    Licenses = {},
    AcePermission = 'spectrem_director.manage', -- Optional extra admin route, e.g. 'spectrem_director.manage'
    AdminsHaveToolAccess = true,
    AuditLimit = 60,
    -- A feature listed here can be used by any player when its mode is
    -- 'enabled'. 'admin' and 'disabled' remain restricted by the panel.
    PublicAccess = {},
    -- Initial mode per feature. Omitted entries default to 'admin' when the
    -- Director menu is admin-only; explicitly use 'enabled' for public tools.
    Defaults = {
        camera = 'admin',
        developer = 'admin',
    },
}

-- ============================
-- UI Language
-- Supported: 'en' (default), 'es', 'de', 'tr', 'fr', 'ar', 'vi', 'pl', 'pt-br'
-- This value is read once when the resource/NUI starts. Changing it requires a
-- resource restart; opening F5 does not reload or translate the interface.
-- ============================
Config.Language = 'pt-br'

-- ============================
-- UI Theme
-- Override the menu's brand colors with your server's palette.
-- Any key can be removed/nil to keep the default. Hex format '#rrggbb'.
-- ============================
Config.UITheme = {
    accent      = '#2E8B57', -- primary brand color (buttons, highlights)
    accentLight = '#65C891', -- lighter accent (badges, secondary text)
    -- violet   = '#a78bfa',
    -- purple   = '#c084fc',
    -- info     = '#38bdf8',
    -- danger   = '#ef4444',
    -- success  = '#2ecc71',
    -- warning  = '#fbbf24',
}

-- ============================
-- UI Scale
-- Base scale multiplier for the whole menu (1.0 = auto by resolution).
-- Players use Interface size (monitor icon) in Director or Timeline.
-- Their saved device preference takes precedence; Restore recommended uses this default.
-- ============================
Config.UIScale = 1.0

-- ============================

-- Default Ped Models
-- Used when no custom ped is selected for scene actors
-- ============================
Config.RandomPeds = {
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
    `mp_m_freemode_01`,
}

-- ============================
-- Placement Camera
-- ============================
Config.Placement = {
    MoveSpeed = 0.06,         -- Base movement speed (WASD/QE)
    CamSensitivity = 4.0,     -- Mouse look sensitivity
}

-- Timeline inspection flight (units per nominal 60 Hz frame).
-- Normal: 6 m/s. Hold Shift for 24 m/s, or Alt for precise 1.2 m/s movement.
Config.TimelineFreecam = {
    normalMoveMultiplier = 0.1,
    fastMoveMultiplier = 0.4,
    slowMoveMultiplier = 0.02,
}

-- ============================
-- Scene Preview
-- The Effects library also uses this viewer and its camera defaults/limits.
-- Effect access is controlled by the 'effects' policy in Scene Admin.
-- Lightweight scene inspection camera. This runtime owns its own local camera
-- and local-only preview entities; it does not open or borrow Camera Director.
-- ============================
Config.ScenePreview = {
    Enabled = true,
    DefaultPed = "mp_m_freemode_01",
    Distance = 6.0,           -- Orbit radius in meters
    Height = 1.5,             -- Camera height above the actor origin
    Speed = 12.0,             -- Orbit speed in degrees per second
    Angle = 0.0,              -- Starting angle; 0 faces the actor from +X
    Fov = 50.0,
    Smoothing = 6.0,          -- Response for actor following and UI changes
    TargetOffsetZ = 0.85,     -- Aim at the actor's upper body instead of feet
    TransitionMs = 650,
    HideHud = true,
    HidePlayer = true,
    TargetLostGraceMs = 500,
    TargetSnapDistance = 12.0, -- Snap after scene/sequence teleports instead of trailing slowly
    Limits = {
        Distance = { Min = 2.0, Max = 18.0 },
        Height = { Min = -1.0, Max = 6.0 },
        Speed = { Min = 0.0, Max = 45.0 },
        Angle = { Min = 0.0, Max = 360.0 },
        Fov = { Min = 20.0, Max = 90.0 },
        Smoothing = { Min = 1.0, Max = 15.0 },
    },
}

-- ============================
-- Object Motion
-- Independent prop animation runtime used by Object Spooner, Custom Scenes
-- and Timeline. It does not share clocks or movement code with Camera Director.
-- ============================
Config.ObjectMotion = {
    DefaultDurationSeconds = 5.0,
    MaxDurationSeconds = 600.0,
    MaxKeyframes = 128,
    MaxConcurrent = 32,
    ModelLoadTimeoutMs = 5000,
    DefaultCollision = false,
    DefaultLevitateAmplitude = 0.5,
    DefaultLevitateFrequency = 0.35,
    DefaultRotationSpeed = 35.0,
    DefaultOrbitRadius = 1.5,
    DefaultOrbitSpeed = 30.0,
    DefaultSwayFrequency = 0.25,
    -- Advanced Physical levitation is opt-in per Object Motion entry. Zone,
    -- return strength, damping and speed are saved with the scene/project.
    -- It uses the same MaxConcurrent budget and object_motion permission.
    -- Camera Sequence. This is an Object Motion authoring camera with its
    -- own state and lifecycle; it does not open or depend on Camera Director.
    CameraRecorder = {
        DefaultPropDistance = 3.0,
        DefaultPropHeight = 0.0,
        DefaultSpeed = 0.10,
        MinSpeed = 0.004,
        MaxSpeed = 1.0,
        Sensitivity = 90.0,
        MovementSmoothing = 30.0,
        RotationSmoothing = 25.0,
        MouseSmoothing = 0.0,
        ZoomSpeed = 100.0,
        RollSpeed = 45.0,
        DefaultFov = 50.0,
        MinFov = 5.0,
        MaxFov = 120.0,
        DefaultPlaybackSpeed = 1.0,
        DefaultFreeLook = false,
        HideHud = true,
        HideNotifications = true,
        PanelVisible = true,
        DroneMode = false,
        WalkMode = false,
        WorldCollision = false,
        WalkHeight = 1.7,
        CollisionRadius = 0.5,
        TurboMultiplier = 4.0,
        PrecisionMultiplier = 0.2,
        DroneDrag = 3.0,
        DroneAcceleration = 15.0,
        DroneBanking = 15.0,
        DroneRotationSmoothing = 8.0,
        LensPresets = {
            { label = '14mm', fov = 81.0 },
            { label = '24mm', fov = 53.0 },
            { label = '35mm', fov = 38.0 },
            { label = '50mm', fov = 27.0 },
            { label = '85mm', fov = 16.0 },
            { label = '135mm', fov = 10.0 },
        },
        SampleIntervalMs = 80,
        AdaptivePositionMeters = 0.025,
        AdaptiveRotationDegrees = 0.75,
        SimplifyPositionMeters = 0.012,
        SimplifyRotationDegrees = 0.4,
        MaxRawSamples = 6000,
        MaxDurationSeconds = 120.0,
        RecordCountdownSeconds = 3,
        TransitionMs = 350,
    },
}

-- ============================
-- Stage Lighting
-- Independent fixture authoring for Custom Scenes and Timeline. Every saved
-- light is a streamed object with an embedded CLight so it can survive into a
-- Rockstar Editor recording. The older per-frame native renderer is not an
-- authored output in this version.
-- ============================
Config.StageLighting = {
    MaxConcurrent = 32,
    -- Lights farther than this distance plus their authored range are skipped.
    -- Set to 0 to disable culling. This only affects rendering performance; it
    -- never changes the saved Stage Light definition.
    MaxRenderDistance = 500.0,
    DefaultDurationSeconds = 8.0,
    MaxDurationSeconds = 600.0,
    DefaultRange = 35.0,
    DefaultIntensity = 8.0,
    DefaultCone = 28.0,
    DefaultFalloff = 1.0,
    ShowEditorGuide = true,
    DefaultOutputMode = "editor",
    -- Temporary lifecycle diagnostics. Keep false in production.
    Debug = false,

    FixtureBackend = {
        Enabled = true,
        ModelLoadTimeoutMs = 5000,
        -- If the selected drawable is unavailable or times out, try the nearest
        -- verified preset colors. The light fails closed when no physical
        -- fixture can be prepared; requests are deduplicated per playback session.
        RetryUnavailablePresets = true,
        MaxCandidateRetries = 3,
        -- Local mission entities are stable for the recording client and do not
        -- create needless OneSync traffic. This exposes a real entity to the
        -- recorder, but Rockstar Editor persistence still requires an in-editor
        -- A/B test after every GTA/FiveM artifact update.
        Networked = false,
        DisableCollision = true,
        FreezePosition = true,
        LodDistance = 2000,
        -- The source CLight points down the model's local -Y axis. This is the
        -- rotation correction used by the original Scene Director StageLight.
        RotationOffset = { x = 180.0, y = 0.0, z = 0.0 },
        -- These streamed copies were patched and validated with all 24 hourly
        -- bits enabled; keep this metadata aligned with the compiled drawables.
        AllHours = true,
        SourceTimeFlags = "0x00FFFFFF",
        AllowUnlistedModels = false,
        Presets = {
            white_bright   = { label = "Branco · Intenso",   model = "prop_sd_spot_01", color = { r = 255, g = 255, b = 255 }, order = 1 },
            white_soft     = { label = "Branco · Suave",     model = "prop_sd_spot_02", color = { r = 192, g = 192, b = 192 }, order = 2 },
            white_dim      = { label = "Branco · Fraco",      model = "prop_sd_spot_03", color = { r = 128, g = 128, b = 128 }, order = 3 },
            red_soft       = { label = "Vermelho · Suave",       model = "prop_sd_spot_04", color = { r = 128, g = 0, b = 0 }, order = 4 },
            red_bright     = { label = "Vermelho · Intenso",     model = "prop_sd_spot_05", color = { r = 255, g = 0, b = 0 }, order = 5 },
            magenta_soft   = { label = "Magenta · Suave",   model = "prop_sd_spot_06", color = { r = 128, g = 0, b = 128 }, order = 6 },
            magenta_bright = { label = "Magenta · Intenso", model = "prop_sd_spot_07", color = { r = 255, g = 0, b = 255 }, order = 7 },
            green_soft     = { label = "Verde · Suave",     model = "prop_sd_spot_08", color = { r = 0, g = 128, b = 0 }, order = 8 },
            green_bright   = { label = "Verde · Intenso",   model = "prop_sd_spot_09", color = { r = 0, g = 255, b = 0 }, order = 9 },
            yellow_soft    = { label = "Amarelo · Suave",    model = "prop_sd_spot_10", color = { r = 128, g = 128, b = 0 }, order = 10 },
            yellow_bright  = { label = "Amarelo · Intenso",  model = "prop_sd_spot_11", color = { r = 255, g = 255, b = 0 }, order = 11 },
            blue_soft      = { label = "Azul · Suave",      model = "prop_sd_spot_12", color = { r = 0, g = 0, b = 128 }, order = 12 },
            blue_bright    = { label = "Azul · Intenso",    model = "prop_sd_spot_13", color = { r = 0, g = 0, b = 255 }, order = 13 },
            cyan_soft      = { label = "Ciano · Suave",      model = "prop_sd_spot_14", color = { r = 0, g = 128, b = 128 }, order = 14 },
            cyan_bright    = { label = "Ciano · Intenso",    model = "prop_sd_spot_15", color = { r = 0, g = 255, b = 255 }, order = 15 },
        },
    },
    -- Persistent work camera used for the complete Stage Lighting session.
    -- Hold RMB to look and move; releasing RMB returns the cursor to the UI or
    -- fixture gizmo without leaving the authoring camera.
    AuthoringCamera = {
        MoveSpeed = 10.0,
        FastMoveSpeed = 30.0,
        PreciseMoveSpeed = 3.0,
        MouseSensitivity = 5.0,
        FieldOfView = 55.0,
        TransitionMs = 250,
    },
}

-- ============================

-- Cinematic Text
-- DUI-backed world text for live preview, Timeline, Custom Scenes and the
-- external MP4 recorder. It is intentionally not advertised as Rockstar
-- Editor-safe: a DUI texture is not embedded in an ACTION clip.
Config.CinematicText = {
    MaxConcurrent = 16,
    MaxCharacters = 280,
    MaxLines = 6,
    MaxRenderDistance = 500.0,
    DefaultDurationSeconds = 5.0,
    MaxDurationSeconds = 600.0,
    DuiWidth = 1280,
    DuiHeight = 512,
    UpdateFps = 30,
    DefaultScale = 1.0,
    DefaultFacing = "billboard", -- billboard | fixed
    Debug = false,
    AuthoringCamera = {
        MoveSpeed = 10.0,
        FastMoveSpeed = 30.0,
        PreciseMoveSpeed = 3.0,
        MouseSensitivity = 5.0,
        FieldOfView = 55.0,
        TransitionMs = 250,
    },
}

-- ============================

-- Spectrem Export
-- Default provider for generic/manual capture surfaces such as Camera Director.
-- Custom Scenes and Timeline expose two explicit controls: ACTION always uses
-- Rockstar Editor, while EXPORT always uses the local desktop application without
-- cross-provider fallback. The recorder endpoint is fixed internally at
-- 127.0.0.1:55875 so the script and desktop application cannot drift apart.
-- The bridge resolves the active resource at runtime, so this same config works
-- as spectrem_director_dev, spectrem_director_early_access, spectrem_director,
-- or another custom folder name.
-- ============================
Config.SpectremRecorder = {
    Enabled = true,
    Provider = "external",       -- external | rockstar | auto
    Token = "spectrem-prototype-change-me",
    RequestTimeoutMs = 3000,     -- Allows the app to probe its encoder candidates
    StartLeadMs = 4000,          -- Health probe + start acknowledgement before playback
    FinalizeTimeoutMs = 20000,   -- FFmpeg may need time to flush and close the file
    FallbackToRockstar = true,
    CaptureFps = 60,
}

-- ============================

-- Cinematic Camera (Camera Director)
-- Tunables for the SimpleCamera-based cinematic camera. Defaults mirror the
-- original mod's values; edit here instead of modules/camera/client/director.lua.
-- ============================
Config.CinematicCamera = {
    -- Native GTA motion blur for Camera Director, Timeline and Custom Scene
    -- camera clips. Requested range: 0..10 (0 off, 1 baseline). Values above
    -- 1 are experimental: GTA may clamp them internally. Post FX and the
    -- player's motion blur setting still affect the visible result.
    -- F8: sdcammotionblur 0..10 / reset (temporary local override).
    MotionBlurStrength = 1.0,
    WalkHeight = 1.7,          -- Walk mode: eye height above the ground (meters)
    CollisionRadius = 0.5,     -- World collision: capsule radius around the lens (meters)
    AttachScanRadius = 80.0,   -- Attach: how far around the camera to list nearby vehicles/peds (meters)
    RememberPosition = true,   -- Reopen Camera Control at the pose it was closed at
    -- Click-to-attach: with the panel hidden, left-click locks onto whatever is
    -- framed (click the same target again to release).
    ClickToAttach = true,
    LookInputMode = "click",    -- RMB: "click" locks/releases; "hold" releases on mouse-up; "free" rotates
    LookSpeed = 50.0,           -- Live look turning/tracking speed: 1-100%; lower = slower, higher = faster (RMB, B/V, G)
    ZoomSpeed = 100.0,          -- Live Z/C zoom speed: 1-200%; 100% = 25 FOV degrees/second; lower = slower
    TargetScope = "scene_first", -- "scene_first", "scene_only", or "all" nearby entities
    -- Alt + RMB always allows manual rotation. B/V select next/previous gaze
    -- targets without changing the positional attachment. Panel buttons also work.
    ClickAttachDistance = 150.0, -- Probe length in meters
    ClickAttachCone = 6.0,       -- Degrees around the aim direction accepted when
                                 -- the straight probe misses (higher = more forgiving)
    -- Starting state of the aim reticle and the highlight over the target that
    -- would be picked. Toggleable live from the panel ("Target pointer"), so
    -- it can be switched off for a clean frame while still clicking to attach.
    ShowTargetPointer = true,
    -- How softly the camera rides a non-rigid attachment, 0-100. 0 keeps it
    -- locked 1:1 to the target's movement (the tightest, and what a mounted
    -- shot wants); higher values let it trail and settle, which reads as an
    -- operator following the subject rather than being bolted to it. Rigid
    -- mounts ignore this â€” the engine positions those and lag is the one
    -- thing they exist to avoid. Also on a panel slider.
    AttachSmoothing = 0.0,

    Drone = {
        Drag = 3.0,            -- Velocity damping (higher = the camera stops sooner)
        Acceleration = 15.0,   -- Thrust (higher = reaches full speed faster)
        Banking = 15.0,        -- Initial maximum auto-roll, 0-45 degrees; adjustable live in Camera > Drone mode
                              -- 0 levels the horizon. Reaches the limit at 60 degrees/second of yaw.
        RotationSmoothing = 8.0, -- Yaw-rate smoothing used for banking (higher = snappier)
    },

    -- Camera Replay: record the live camera movement as sequence keyframes.
    Record = {
        IntervalMs = 200,      -- Sample spacing (lower = more faithful, more keyframes)
        MaxSeconds = 300,      -- Standalone recording auto-stop (linked takes stop at the clip window)
        CountdownSeconds = 3,  -- Pre-roll before recording starts (0 = start immediately)
        Adaptive = true,       -- Add extra samples while the camera turns quickly
        AdaptiveAngleStep = 8.0, -- Degrees of rotation change that force an extra sample
        SimplifyTolerance = 0.06, -- Curve reduction on stop, in meters (0 = keep every sample)
        -- Simplification is time-aware and checks every visible camera channel.
        -- These limits prevent a stationary pan, rack focus or zoom from being
        -- discarded merely because the camera did not change world position.
        SimplifyRotationTolerance = 1.0, -- Maximum angular error, in degrees
        SimplifyFovTolerance = 0.25,     -- Maximum FOV error, in degrees
        SimplifyDofTolerance = 0.25,     -- Maximum focus-distance error, in meters
        SimplifyScalarTolerance = 0.02,  -- Filter/DOF/shake strength error (0.0 - 1.0)
    },

    -- Flight limits and modifier keys. Applies to the live camera and to the
    -- values the panel is allowed to send.
    Limits = {
        FovMin = 5.0,
        FovMax = 120.0,
        SpeedMin = 0.004,   -- Low enough for slow creeping dolly moves
        SpeedMax = 1.0,
        TurboMultiplier = 4.0,     -- Shift
        PrecisionMultiplier = 0.2, -- Alt / Ctrl
        RollSpeed = 45.0,          -- Degrees per second on the roll keys
    },

    -- Keyframe authoring defaults and loop-closure tolerances.
    Keyframes = {
        DefaultEase = 'linear',      -- linear | ease_in_out | ease_in | ease_out | hold
        DefaultPath = 'spline',      -- spline | linear
        AppendInterval = 2.0,        -- Seconds added when capturing past the last keyframe
        -- Re-solve a look-at keyframe's aim from the interpolated position
        -- instead of blending the two endpoint rotations. Keeps the subject
        -- framed through the whole move; set false for the old behaviour.
        LookAtReaim = true,
        -- Starting speed profile (also switchable live from the panel):
        --   natural    the curve's own pacing from keyframe times. Eases into
        --              tight bends, flows through open ones
        --   segment    constant speed between consecutive keyframes; their
        --              times are still hit exactly
        --   continuous even speed across the WHOLE path â€” the most metered
        --              look, but intermediate keyframe times become guides
        SpeedProfile = 'natural',
        LoopPositionTolerance = 1.0, -- Meters
        LoopRotationTolerance = 5.0, -- Degrees per axis (shortest arc)
        LoopFovTolerance = 2.0,      -- Degrees
    },

    -- In-world authoring guides (keyframe props + path line) and the on-screen
    -- framing overlays (thirds / center cross / safe area / info readout).
    Guides = {
        PropModel = 'prop_v_cam_01',
        PathColor = { r = 99, g = 102, b = 241, a = 180 },
        PathSamples = 80,     -- Segments used to draw the spline preview
        MaxGuideProps = 48,   -- Past this keyframe count only the path line is drawn
        -- Starting strength of the framing overlays (0.0 - 1.0). The panel's
        -- "Guide intensity" slider adjusts it live per session.
        OverlayIntensity = 0.6,
        CompositionColor = { r = 255, g = 255, b = 255 }, -- Thirds + center cross
        SafeAreaColor = { r = 255, g = 210, b = 80 },
    },

    -- Depth of field response. Near/far spreads are interpolated by the panel's
    -- intensity slider (min = strongest blur, max = widest in-focus range).
    DepthOfField = {
        NearSpreadMin = 0.2,
        NearSpreadMax = 3.0,
        FarSpreadMin = 2.0,
        FarSpreadMax = 30.0,
        AutofocusIntervalMs = 125,   -- Autofocus refresh rate
        AutofocusMaxDistance = 500.0, -- Probe length / fallback focus distance
    },

    -- Smart follow, used while "Allow player movement" is on: the camera keeps
    -- the framing you set and glides after the player like a Steadicam
    -- operator instead of staying nailed in place.
    SmartFollow = {
        Deadzone = 0.8,     -- Meters the player can move before the camera reacts
        Damping = 2.5,      -- Catch-up rate (higher = tighter, lower = more lag)
        MaxDistance = 25.0, -- Past this gap the catch-up accelerates so a sprinting
                            -- or driving player is never lost
        -- Controls handed back to the player while the option is on. The right
        -- set is picked automatically depending on whether the player is on
        -- foot or in a vehicle, so you can walk AND drive while filming.
        -- Control IDs: https://docs.fivem.net/docs/game-references/controls/
        OnFootControls = {
            30, 31,             -- Move left/right, forward/back
            32, 33, 34, 35,     -- Directional move (keyboard)
            21,                 -- Sprint
            22,                 -- Jump
            36,                 -- Duck
        },
        InVehicleControls = {
            59, 60,             -- Steer / pitch
            61, 62, 63, 64,     -- Directional vehicle move (aircraft, bikes)
            71, 72,             -- Accelerate / brake
            75,                 -- Exit vehicle
            76,                 -- Handbrake
            86,                 -- Horn
        },
    },

    -- Automatic orbit around the attached entity (Attach to entity + Orbit).
    -- These are only the starting values: enabling the orbit adopts the
    -- distance and height already framed, and all three can be flown live
    -- (W/S dolly, Q/E crane, A/D rotation speed) or set from the panel.
    Orbit = {
        Distance = 6.0,   -- Meters from the target
        Height = 1.5,     -- Meters above the target's origin
        Speed = 20.0,     -- Degrees per second (negative reverses the direction)
        -- How quickly the rig eases toward a new distance/height/speed. Higher
        -- is snappier, lower glides; the orbit path itself stays exact either
        -- way, only the parameter changes are smoothed.
        Smoothing = 3.5,
    },

    -- Timecycle looks cycled from the panel. `modifier` must be a valid
    -- timecycle name; an empty string means "no modifier".
    Filters = {
        { label = 'Nenhum',      modifier = '' },
        { label = 'Cinematográfico', modifier = 'cinema' },
        { label = 'Fílmico',    modifier = 'NG_filmic01' },
        { label = 'Quente',      modifier = 'MP_corona_heist' },
        { label = 'Frio',      modifier = 'scanline_cam_cheap' },
        { label = 'Preto e branco',      modifier = 'blackNwhite' },
    },

    -- Focal-length presets (full-frame equivalents) cycled from the panel.
    -- `fov` is the vertical FOV GTA expects; edit freely.
    LensPresets = {
        { label = '14mm', fov = 81.0 },
        { label = '24mm', fov = 53.0 },
        { label = '35mm', fov = 38.0 },
        { label = '50mm', fov = 27.0 },
        { label = '85mm', fov = 16.0 },
        { label = '135mm', fov = 10.0 },
    },

    -- Letterbox ratios. Bar height is computed from the real screen aspect, so
    -- the framing is correct on 16:9 and ultrawide alike.
    BarPresets = {
        { label = '2.39:1', ratio = 2.39 },
        { label = '2.35:1', ratio = 2.35 },
        { label = '2.00:1', ratio = 2.00 },
        { label = '1.85:1', ratio = 1.85 },
        { label = 'Clássico', height = 0.07 }, -- Fixed height instead of a ratio
    },

    -- Quick framing presets (offsets relative to the player ped).
    PresetOffsets = {
        front = { x = 0.0,  y = 3.0,  z = 1.0 },
        rear  = { x = 0.0,  y = -3.0, z = 1.0 },
        right = { x = 3.0,  y = 0.0,  z = 1.0 },
        left  = { x = -3.0, y = 0.0,  z = 1.0 },
        above = { x = 0.0,  y = 0.25, z = 5.0 },
    },

    -- Camera Control keybinds, as FiveM control IDs (see the control reference
    -- at https://docs.fivem.net/docs/game-references/controls/).
    Keys = {
        NextTarget = 29,    -- B: next gaze target (panel hidden)
        PreviousTarget = 0, -- V: previous gaze target (panel hidden)
        Capture = 182,      -- L  â€” capture keyframe
        PlayPause = 168,    -- F7 â€” play / pause (stops a Camera Replay take)
        Stop = 169,         -- F8 â€” stop and rewind
        NextKeyframe = 56,  -- F9 â€” jump to the next keyframe
        TogglePanel = 74,   -- H  â€” hide / show the panel and guides
        ResetPose = 45,     -- R  â€” reset the camera pose
        Close = 200,        -- ESC â€” close Camera Control
    },

    -- Shake presets cycled from the camera panel. Two kinds are accepted:
    --
    --   PROCEDURAL (has `amplitude`) â€” a pure function of the take's time, so
    --   the same sequence shakes identically on every playback, freezes when
    --   the playhead is paused, and previews exactly as it records.
    --     amplitude  degrees of rotation (5 cm of translation per degree)
    --     frequency  hertz. 0.20 is a slow handheld wander, 4.0 is a rattle
    --     variation  swell and settle over time. 0 = flat intensity
    --     swayMix    share going to the slow layer (default 0.7)
    --     seed       reroll the pattern without changing its character
    --     motionAmp / motionFreq  couple to camera speed. ~1.0 / 0.5 is the
    --                single biggest step towards reading as an operator
    --     axis       per-axis weights { posX, posY, posZ, pitch, roll, yaw }
    --
    --   NATIVE (has `native`) â€” an engine CAM::SHAKE_CAM type. Cheaper, but it
    --   re-rolls itself every playback and cannot be frozen by pausing.
    ShakePresets = {
        { label = 'Câmera na mão',   amplitude = 2.2, frequency = 0.20, variation = 0.7 },
        { label = 'Suave',     amplitude = 0.9, frequency = 0.16, variation = 0.5 },
        { label = 'Operador',   amplitude = 2.0, frequency = 0.22, variation = 0.8,
                                motionAmp = 1.0, motionFreq = 0.5 },
        { label = 'Veículo',    amplitude = 1.4, frequency = 2.2,  variation = 0.3, swayMix = 0.35 },
        { label = 'Motor',     amplitude = 0.5, frequency = 6.0,  variation = 0.2, swayMix = 0.15 },
        { label = 'Terremoto', amplitude = 5.0, frequency = 3.0,  variation = 0.6, swayMix = 0.5 },
        { label = 'Embriagado',      native = 'DRUNK_SHAKE',          scale = 1.0 },
        { label = 'Queda livre',    native = 'SKY_DIVING_SHAKE',     scale = 1.0 },
    },
}

-- ============================

-- Population Density (defaults when enabled)
-- Values from 0.0 (none) to 1.0 (vanilla GTA)
-- ============================
Config.Density = {
    Peds = 0.8,
    Vehicle = 0.8,
    Parked = 0.8,
    RandomVehicles = 0.8,
    Scenario = 0.8,
}

-- ============================
-- Police Chase
-- ============================
Config.PoliceChase = {
    Enabled = true,

    -- Ground units. These values are also sent to the NUI, so the panel and
    -- runtime always validate against the same limits and model catalogue.
    MinUnits = 1,
    MaxUnits = 8,
    DefaultUnits = 2,
    DefaultVehicle = 'police',
    AllowCustomVehicleModels = true, -- Allow a valid streamed/add-on spawn name.
    Vehicles = {
        { label = 'Viatura policial',     value = 'police' },
        { label = 'Viatura policial 2',   value = 'police2' },
        { label = 'Viatura policial 3',   value = 'police3' },
        { label = 'Buffalo policial',     value = 'police4' },
        { label = 'Transporte policial', value = 'policet' },
        { label = 'Sedã do FIB',          value = 'fbi' },
        { label = 'SUV do FIB',            value = 'fbi2' },
        { label = 'Viatura do xerife',    value = 'sheriff' },
        { label = 'SUV do xerife',        value = 'sheriff2' },
    },

    -- Driving presets are selected by their numeric id. Speeds use GTA units
    -- per second (35.0 is roughly 126 km/h).
    DefaultAggressiveness = 2,
    DrivingPresets = {
        [1] = {
            label = 'Normal',
            drivingStyle = 786468,
            maxSpeed = 35.0,
            driverAbility = 0.85,
            driverAggressiveness = 0.35,
            idealPursuitDistance = 16.0,
            brakeDistance = 8.0,
            allowRamming = false,
        },
        [2] = {
            label = 'Agressivo',
            drivingStyle = 262716,
            maxSpeed = 45.0,
            driverAbility = 1.0,
            driverAggressiveness = 0.75,
            idealPursuitDistance = 12.0,
            brakeDistance = 7.0,
            allowRamming = false,
        },
        [3] = {
            label = 'Colisão',
            drivingStyle = 786469,
            maxSpeed = 55.0,
            driverAbility = 1.0,
            driverAggressiveness = 1.0,
            idealPursuitDistance = 4.0,
            brakeDistance = 2.0,
            allowRamming = true,
        },
    },

    DefaultSirens = true,
    DefaultHelicopter = false,
    DefaultHelicopterModel = 'polmav',
    Helicopters = {
        { label = 'Maverick policial', value = 'polmav' },
        { label = 'Buzzard',         value = 'buzzard' },
        { label = 'Annihilator',     value = 'annihilator' },
        { label = 'Frogger',         value = 'frogger' },
        { label = 'Valkyrie',        value = 'valkyrie' },
        { label = 'Savage',          value = 'savage' },
    },

    CopPedModel = 's_m_y_cop_01',
    PilotPedModel = 's_m_y_pilot_01',

    -- Chase actors are intentionally local cinematic entities. Turning this
    -- on is unsupported because ownership migration makes AI pursuit timing
    -- non-deterministic across clients.
    Networked = false,

    -- Default protection can be changed live from the Chase panel. Disable a
    -- field when physical damage is part of the shot.
    -- Drivers protects the ground crew only during vehicle pursuit. Officers
    -- lose this protection when the on-foot response begins and regain it
    -- after boarding and resuming pursuit; repairs do not heal/revive them.
    Protection = {
        Vehicles = true,
        Drivers = true,
        Helicopter = true,
        Pilot = true,
    },

    -- The target is always the local player. When that player leaves a vehicle,
    -- only NPCs created by Chase can stop nearby, exit and continue on foot.
    -- Set Enabled=false to keep every Chase officer in the vehicle.
    OnFootResponse = {
        Enabled = true,
        Distance = 20.0,
        ExitVehicle = true,
        Weapon = 'WEAPON_PISTOL',
        Ammo = 60,
        Accuracy = 35,
        GraceMs = 3000,
        ForceAfterMs = 6500,
        VehicleStopSpeed = 3.0,
    },

    -- Optional per-unit casting. The standard police vehicle, police driver
    -- and pistol remain the defaults until the operator opens Advanced Fleet.
    -- Saved vehicles keep their tuning/liveries and saved peds keep their full
    -- appearance. Seat -1 is always the driver; 0+ are passenger seats.
    AdvancedFleet = {
        Enabled = true,
        MaxOccupantsPerUnit = 8,
        Weapons = {
            { label = 'Pistola',          value = 'WEAPON_PISTOL' },
            { label = 'Pistola de combate',   value = 'WEAPON_COMBATPISTOL' },
            { label = 'Pistola pesada',    value = 'WEAPON_HEAVYPISTOL' },
            { label = 'Arma de choque',        value = 'WEAPON_STUNGUN' },
            { label = 'Micro SMG',       value = 'WEAPON_MICROSMG' },
            { label = 'SMG',             value = 'WEAPON_SMG' },
            { label = 'Escopeta',    value = 'WEAPON_PUMPSHOTGUN' },
            { label = 'Carabina',   value = 'WEAPON_CARBINERIFLE' },
        },
    },

    -- Chase Replay records the target plus every active ground/air Chase
    -- vehicle on one synchronized clock. On-foot exit/combat is intentionally
    -- locked while recording and playback are active.
    ChaseReplay = {
        Enabled = true,
        SampleIntervalMs = 20,
        MaxDurationSeconds = 300,
        MaxVehicles = 24,
        -- Shared ceiling across every captured vehicle. This bounds memory and
        -- keeps the compact JSON recording below the existing 32 MB upload cap.
        MaxTotalFrames = 180000,
    },

    -- Deployment and keep-alive distances, in meters.
    DefaultDeploymentDistance = 28.0,
    MinDeploymentDistance = 18.0,
    MaxDeploymentDistance = 120.0,
    SpawnLateralSpacing = 5.0,
    MinFollowDistance = 8.0,
    RespawnDistance = 250.0,
    RetaskDistance = 50.0,
    HeliSpawnDistance = 80.0,
    HeliSpawnHeight = 60.0,
    HeliRespawnDistance = 400.0,
    HeliRetaskDistance = 80.0,
    SpawnStaggerDelay = 300,

    -- Runtime timing (milliseconds).
    KeepAliveInterval = 3000,
}

-- ============================

-- Cutscene Player (F6 panel)
-- ============================
Config.Cutscenes = {
    OpenKey = '',                        -- Key to open/close the cutscene player
    Command = 'cenas',                 -- Chat command to open the cutscene player

    -- Default UI toggle values
    MuteAudio     = false,                 -- Mute cutscene audio by default
    HideHud       = true,                  -- Hide HUD during playback
    
    -- Screen transitions (ms)
    FadeOutDuration = 200,                 -- Screen fade out before teleport
    FadeInDuration  = 500,                 -- Screen fade in after arriving

    -- Loading timeouts (ms)
    CutsceneLoadTimeout  = 15000,          -- Max wait for cutscene to load
    ModelLoadTimeout     = 10000,          -- Max wait for ped model to load
    CollisionTimeout     = 8000,           -- Max wait for collision streaming

    -- Default ped model for cutscene actors
    DefaultPedModel = 'mp_m_freemode_01',
}


-- ============================

-- Time Speed
-- ============================
Config.TimeSpeed = {
    BaseRate = 0.5,     -- Default GTA rate: 0.5 game-minutes per real second (2s per game minute)
    Presets = { 0.25, 0.5, 1, 2, 5, 10, 30, 60 },  -- Available speed multipliers
}

-- ============================

-- Ped Replay
-- ============================
-- Shared stop action for Vehicle Replay and Ped Replay. This is a physical
-- keyboard binding, not GTA control 38 (which also fires on controller L1/LB).
Config.ReplayRecordingControls = {
    StopKey = "E", -- Initial default; players can rebind it in Settings > Key Bindings > FiveM.
    ControllerComboEnabled = false, -- Opt in to the held combo below; L1/R1 alone never stop a take.
    ControllerCombo = { 230, 231 }, -- INPUT_SCRIPT_LS + INPUT_SCRIPT_RS (L3 + R3).
    ControllerLabel = "L3 + R3", -- HUD label; update this when changing the combo.
    ControllerHoldMs = 1200, -- Both buttons held together; release before starting another take.
}

Config.PedReplay = {
    -- Adaptive playback lets native actions finish and replans movement around
    -- the recorded route. "legacy" restores the previous transform corrections.
    PlaybackMode = "adaptive",
    AdaptiveLookahead = 0.65,      -- seconds ahead on the recorded route
    AdaptiveRetaskMs = 450,        -- minimum route refresh interval
    AdaptivePositionTolerance = 0.65, -- metres of acceptable positional variation
    AdaptiveEmergencyDistance = 12.0, -- last-resort recovery, outside protected actions
    AdaptiveRecoveryDelayMs = 2500, -- drift must persist before emergency recovery
    -- The next three correction settings apply only to PlaybackMode = "legacy".
    SoftSnapDistance = 1.15,       -- Correct small drift during walking/running playback
    HardSnapDistance = 5.0,        -- Teleport back if the AI drifts too far from the recording
    RetaskInterval = 80,           -- ms between locomotion retasks
    SampleIntervalMs = 20,         -- ms between recorded frames (20 = 50fps, lower = smoother but bigger files)
    MaxDurationMs = 180000,        -- Auto-stop after 3 minutes
    MaxFramesPerTrack = 9000,      -- Hard memory guard for the player and vehicles used by the player
    MaxVehicleTracks = 12,         -- Vehicles entered by the player during one recording
    CombatAimDistance = 120.0,     -- Max raycast distance used to record where the player aimed
    CombatAimRetaskInterval = 200, -- ms between cinematic aim/look retasks during playback
    CombatShotInterval = 0.09,     -- Minimum seconds between replayed bullets for automatic weapons
    CombatPreAimTime = 0.28,       -- seconds to raise/aim the weapon before the first recorded shot
    CombatAimSmoothing = 0.70,     -- 0.05-1.0 smoothing for recorded aim target jitter
    CombatShootTaskDuration = 800,  -- ms for each ped shooting/aim task segment
    CombatShootTaskInterval = 700,  -- ms between combat task refreshes during long bursts
    CombatShootGraceMs = 240,      -- ms to keep the shooting segment alive between native shot pulses
    CombatShootCoordUpdateInterval = 40,  -- ms between fire-coordinate updates without retasking the whole ped
    CombatHoldAimAfterShotMs = 200, -- ms to keep weapon posture after a burst before relaxing
    CombatAccuracy = 100,          -- Native ped accuracy while replaying combat frames
    CombatBulletDamage = 25,       -- Cosmetic/scripted replay bullet damage
    CombatUseScriptedBullets = false, -- true = also force script bullets; false = prefer native ped shooting animation
}

-- ============================
-- Vehicle Replay
-- ============================
-- Controlled, local traffic. Recordings use the normal Vehicle Replay folders.
Config.TrafficReplay = {
    Enabled = true,
    MaxZones = 4,
    MaxVehicles = 16, -- shared across zones, not per zone
    MaxDurationSeconds = 120,
    MaxTotalFrames = 24000,
    SampleIntervalMs = 75,
    MaxZoneDistance = 450.0, -- keep road nodes/models within streaming range
    PreviewLifetimeSeconds = 180,
    LaneWidth = 3.25, -- default lane spacing; road median width comes from GTA's road graph
    Models = { "asea", "blista", "premier", "primo", "stanier", "sultan", "oracle", "fugitive" },
    DriverModel = "a_m_y_business_01",
}

Config.GhostReplay = {
    RecordRadius = 80.0,
    SampleIntervalMs = 75,
    DiscoveryIntervalMs = 350,
    RecordNearbyVehicles = false,
    MaxDurationMs = 180000,
    MaxFramesPerTrack = 2400,
    MaxVehicleTracks = 16,
    -- Emergency vehicles (police, ambulance, fire...) replay their siren exactly
    -- as it was recorded, including turning it on or off mid-chase. Frames only
    -- store the siren while it is lit, so this costs nothing on civilian cars.
    RecordSirens = true,
    -- Capture shots made by the active player with native vehicle weapons. Each
    -- event stores the selected weapon, seat, ammo and a vehicle-local aim vector,
    -- so it remains aligned when the Timeline replaces the recorded model.
    RecordVehicleWeapons = true,
    ReplayVehicleWeapons = false, -- Opt in per replay; shared attack controls can trigger gestures in unarmed cars
    -- "auto" (recommended) uses GTA's native armed-vehicle system whenever an
    -- occupant/model supports it and falls back to the captured projectile when
    -- that path fails or cannot be verified. "native" forces the GTA path;
    -- "ballistic" always uses the captured projectile. Script-defined weapons
    -- use EDIT.VehicleWeaponBridge.
    VehicleWeaponReplayMode = "auto",
    VehicleWeaponRange = 750.0,
    VehicleWeaponFallbackIntervalMs = 100,
    -- Water cannons and similar stream weapons are stored as a held-input
    -- segment: start, aim samples and release. Playback then keeps the native
    -- stream active every rendered frame instead of replaying many fake shots.
    VehicleWeaponContinuousIntervalMs = 75,
    -- Ground turrets use a vehicle AIM task to follow the captured reticle.
    -- The stream itself is still maintained every rendered frame; this
    -- only controls how often GTA receives a new turret orientation target.
    VehicleWeaponTurretAimRefreshMs = 125,
    -- Official FiveM control IDs mapped to RMB in the relevant vehicle contexts:
    -- INPUT_AIM, INPUT_VEH_AIM, INPUT_VEH_ATTACK2, INPUT_VEH_PASSENGER_AIM.
    ContinuousVehicleControls = { 25, 68, 70, 91 },
    ContinuousVehicleWeapons = {
        "VEHICLE_WEAPON_WATER_CANNON",
        "VEHICLE_WEAPON_FIRETRUCK",
        "WEAPON_WATER_CANNON",
    },
    ContinuousVehicleModels = {
        "firetruk",
        "riot2",
        -- Add addon vehicle spawn names here when they use a custom water/stream
        -- weapon hash that GTA does not expose through the regular native.
    },
    VehicleWeaponDamage = 100,
    VehicleWeaponSpeed = 1200.0,
    VehicleWeaponDebug = false,
    -- Siren lights always replay; set this to false to keep them silent, which
    -- is usually what you want when the scene has its own audio track.
    SirenAudio = true,
    -- Vehicles without a selected visible driver get a local invisible driver
    -- only when their recorded/forced siren needs one.
    SirenAutoDriver = true,

    -- Playback collision:
    --   "world" = collide with world/traffic, ignore the local player/vehicle
    --   "ghost" = no collision at all
    --   "full"  = normal collision with everything
    ReplayCollision = "world",
    -- Helicopters and planes are flown by the recording, not by physics, so
    -- world collision only gives their rotor blades something to strike. One
    -- hard hit snaps them off in a single frame and no health restore brings
    -- them back, which is why a replayed heli ended up flying with no rotors.
    -- Set to false only if an aircraft replay must physically hit the world.
    ReplayAircraftNoCollision = true,
    -- Playback motion:
    --   "auto"       = dynamic nearby, kinematic when far away or badly desynced
    --   "dynamic"    = recorded velocity plus positional correction
    --   "kinematic"  = exact recorded transform every frame
    ReplayMotion = "auto",
    -- Keep GTA's internal vehicle playback update active. Turning this off can
    -- intentionally freeze secondary vehicle systems on special addon models.
    ReplayActive = true,
    ReplayEngine = true,
    ReplayInvincible = true,
    ReplayVisibleDamage = false,
    -- false keeps the vehicle update alive while exact coordinates are applied
    -- every frame (recommended for sirens, rotators and animated addon parts).
    -- true hard-freezes kinematic/long-distance playback for maximum rigidity.
    ReplayFreezeKinematic = false,
    ReplayFreezeOnFinish = true,
    -- Advanced "auto"/dynamic motion tuning. These preserve the previous
    -- hardcoded behavior and can also be overridden per Vehicle Replay entry.
    ReplayCorrection = 15.0,
    ReplaySnapDistance = 20.0,
    ReplayKinematicDistance = 150.0,
}

-- ============================
-- Vehicle Replay authored events
-- Manual secondary actions use the existing Vehicle Replay clock; this module
-- never records or replaces transforms. Values can be edited in Timeline.
-- ============================
Config.VehicleEvents = {
    Enabled = true,
    MaxEventsPerClip = 256,
    MaxTimelineSeconds = 600.0,
    -- Explosions are disabled by default because a local cinematic clone can
    -- still cause unwanted game effects. Damage-only events remain available.
    AllowExplosion = false,
}

-- ============================
-- Actor Sequencer and scene organization
-- All authoring modules read these root options; there are no hidden per-module
-- config files to keep synchronized.
-- ============================
Config.ActorSequencer = {
    Enabled = true,
    -- Temporary, low-volume movement diagnostics for Preview. These prints
    -- identify actor resolution, Start events, issued movement tasks, stalls,
    -- navmesh fallback, arrivals and the final stop reason. Disable once the
    -- route issue has been verified on the FiveM client.
    DebugMovement = true,
    ResolveTimeoutMs = 3000,
    MaxResolveTimeoutMs = 600000,
    AnimLoadTimeoutMs = 5000,
    StatusIntervalMs = 100,
    -- How long a spawned actor waits for collision under its first route
    -- point before it starts moving. Without ground and navmesh the ped
    -- accepts no movement task at all.
    CollisionTimeoutMs = 1500,
    -- If the actor has not left its starting spot after this long, the
    -- move is reported and re-issued without navmesh.
    MoveStallTimeoutMs = 1500,
    -- Grace period given to direct GTA locomotion before Actor Sequencer uses
    -- Ped Replay's deterministic root correction as the final local fallback.
    StraightFallbackGraceMs = 650,
    -- Route points represent the visible floor, not the centre of the ped.
    -- Give GTA a few frames to place the actor capsule on that floor before
    -- issuing the first movement task.
    StartPlacementSettleMs = 250,
    -- Persistent work camera used while the Actor Sequencer UI owns input.
    -- Movement is intentionally gated behind RMB so typing in NUI fields can
    -- never move either the camera or a player-controlled actor.
    EditorCamera = {
        Enabled = true,
        MoveSpeed = 10.0,
        FastMoveSpeed = 30.0,
        PreciseMoveSpeed = 3.0,
        MouseSensitivity = 4.0,
        FieldOfView = 55.0,
        MinFieldOfView = 15.0,
        MaxFieldOfView = 100.0,
        TransitionMs = 250,
        -- Timeline scrub cameras may be created from a short deferred worker.
        -- Starting this work rig afterwards guarantees deterministic ownership.
        PrepareDelayMs = 100,
        DefaultSpeedLevel = 3,
        SpeedMultipliers = { 0.25, 0.5, 1.0, 2.0, 4.0 },
    },
    RouteAuthoring = {
        WalkSpeed = 1.0,
        RunSpeed = 3.0,
        MoveSpeed = 10.0,
        FastMoveSpeed = 30.0,
        PreciseMoveSpeed = 3.0,
        MouseSensitivity = 6.0,
        FieldOfView = 55.0,
        RayDistance = 500.0,
        GroundSnapRange = 4.0,
        MinimumPointDistance = 0.35,
        MaxPoints = 256,
    },
    ActionDurations = {
        wait = 1.0,
        walkTo = 10.0,
        follow = 5.0,
        turnTo = 1.0,
        aim = 2.0,
        shoot = 0.25,
        scenario = 3.0,
        animation = 3.0,
        enterVehicle = 10.0,
        driveTo = 20.0,
        leaveVehicle = 5.0,
    },
}

Config.SceneTools = {
    Enabled = true,
    MaxEntries = 2048,
    MaxCollections = 128,
    MaxAttachments = 256,
    MaxLabelLength = 96,
    RequireControlForPreview = true,
}

-- ============================
-- Door Director
-- Animates a captured map/MLO door through a private Door System binding.
-- All values live here so the module has no hidden configuration file.
-- ============================
Config.DoorDirector = {
    Enabled = true,
    -- Temporary diagnostics for door selection and preset playback. Runtime
    -- traces print when a door is registered, restored or its requested ratio
    -- changes (throttled during playback); they never print on every held
    -- frame. Disable after the selector and server doors have been validated.
    DebugSelection = true,
    DefaultDurationSeconds = 1.5,
    MaxDurationSeconds = 600.0,
    MaxCaptureDistance = 30.0,
    DefaultSearchRadius = 1.25,
    -- Static map/MLO doors may be registered in GTA Door System without a
    -- selectable CObject. This base-game catalog is consulted only after the
    -- shared Object Spooner detector returns entity 0. Add unexposed addon door
    -- archetypes here; entity-backed addon doors need no entry.
    RegisteredDoorProbeRadius = 6.0,
    -- DoorSystemFindExistingDoor only checks a very small radius. When a map
    -- door has no entity handle, scan the clicked panel from its nearest point
    -- outwards so a click away from the model origin can still resolve it.
    RegisteredDoorSurfaceProbeRange = 1.6,
    RegisteredDoorSurfaceProbeStep = 0.4,
    RegisteredDoorModels = {
        "v_ilev_247door",
        "v_ilev_247door_r",
        "v_ilev_abbmaindoor",
        "v_ilev_abbmaindoor2",
        "v_ilev_arm_secdoor",
        "v_ilev_bank4door01",
        "v_ilev_bank4door02",
        "v_ilev_bank4doorcls01",
        "v_ilev_bank4doorcls02",
        "v_ilev_bk_door",
        "v_ilev_bk_door2",
        "v_ilev_bk_gate",
        "v_ilev_bk_gate2",
        "v_ilev_bk_gatedam",
        "v_ilev_bk_safegate",
        "v_ilev_bk_vaultdoor",
        "v_ilev_bl_door_l",
        "v_ilev_bl_door_r",
        "v_ilev_bl_doorel_l",
        "v_ilev_bl_doorel_r",
        "v_ilev_bl_doorpool",
        "v_ilev_bl_doorsl_l",
        "v_ilev_bl_doorsl_r",
        "v_ilev_bl_shutter1",
        "v_ilev_bl_shutter2",
        "v_ilev_bs_door",
        "v_ilev_carmod3door",
        "v_ilev_cbankcountdoor01",
        "v_ilev_cbankvauldoor01",
        "v_ilev_cbankvaulgate01",
        "v_ilev_cbankvaulgate02",
        "v_ilev_cd_door",
        "v_ilev_cd_door2",
        "v_ilev_cd_door3",
        "v_ilev_cd_entrydoor",
        "v_ilev_cd_secdoor",
        "v_ilev_cd_secdoor2",
        "v_ilev_cf_officedoor",
        "v_ilev_ch_glassdoor",
        "v_ilev_clothmiddoor",
        "v_ilev_cm_door1",
        "v_ilev_cor_darkdoor",
        "v_ilev_cor_doorglassa",
        "v_ilev_cor_doorglassb",
        "v_ilev_cor_doorlift01",
        "v_ilev_cor_doorlift02",
        "v_ilev_cor_firedoor",
        "v_ilev_cor_firedoorwide",
        "v_ilev_cor_offdoora",
        "v_ilev_cs_door",
        "v_ilev_cs_door01",
        "v_ilev_cs_door01_r",
        "v_ilev_csr_door_l",
        "v_ilev_csr_door_r",
        "v_ilev_csr_garagedoor",
        "v_ilev_ct_door01",
        "v_ilev_ct_door02",
        "v_ilev_ct_door03",
        "v_ilev_ct_doorl",
        "v_ilev_ct_doorr",
        "v_ilev_depboxdoor01",
        "v_ilev_dev_door",
        "v_ilev_dev_windowdoor",
        "v_ilev_deviantfrontdoor",
        "v_ilev_door_orange",
        "v_ilev_door_orangesolid",
        "v_ilev_epsstoredoor",
        "v_ilev_fa_backdoor",
        "v_ilev_fa_dinedoor",
        "v_ilev_fa_frontdoor",
        "v_ilev_fa_roomdoor",
        "v_ilev_fa_slidedoor",
        "v_ilev_fa_warddoorl",
        "v_ilev_fa_warddoorr",
        "v_ilev_fb_door01",
        "v_ilev_fb_door02",
        "v_ilev_fb_doorshortl",
        "v_ilev_fb_doorshortr",
        "v_ilev_fb_sl_door01",
        "v_ilev_fbisecgate",
        "v_ilev_fh_door01",
        "v_ilev_fh_door02",
        "v_ilev_fh_door03",
        "v_ilev_fh_door4",
        "v_ilev_fh_door5",
        "v_ilev_fh_frntdoor",
        "v_ilev_fh_frontdoor",
        "v_ilev_fh_slidingdoor",
        "v_ilev_fib_door_ld",
        "v_ilev_fib_door_maint",
        "v_ilev_fib_door1",
        "v_ilev_fib_door1_s",
        "v_ilev_fib_door2",
        "v_ilev_fib_door3",
        "v_ilev_fib_doorbrn",
        "v_ilev_fib_doore_l",
        "v_ilev_fib_doore_r",
        "v_ilev_fibl_door01",
        "v_ilev_fibl_door02",
        "v_ilev_fin_vaultdoor",
        "v_ilev_finelevdoor01",
        "v_ilev_fingate",
        "v_ilev_gangsafedoor",
        "v_ilev_garageliftdoor",
        "v_ilev_gasdoor",
        "v_ilev_gasdoor_r",
        "v_ilev_gc_door01",
        "v_ilev_gc_door02",
        "v_ilev_gc_door03",
        "v_ilev_gc_door04",
        "v_ilev_genbankdoor1",
        "v_ilev_genbankdoor2",
        "v_ilev_gendoor01",
        "v_ilev_gendoor02",
        "v_ilev_gtdoor",
        "v_ilev_gtdoor02",
        "v_ilev_hd_door_l",
        "v_ilev_hd_door_r",
        "v_ilev_housedoor1",
        "v_ilev_j2_door",
        "v_ilev_janitor_frontdoor",
        "v_ilev_lester_doorfront",
        "v_ilev_lester_doorveranda",
        "v_ilev_lostdoor",
        "v_ilev_losttoiletdoor",
        "v_ilev_methdoorbust",
        "v_ilev_methdoorscuff",
        "v_ilev_methtraildoor",
        "v_ilev_ml_door1",
        "v_ilev_mldoor02",
        "v_ilev_mm_door",
        "v_ilev_mm_doordaughter",
        "v_ilev_mm_doorm_l",
        "v_ilev_mm_doorm_r",
        "v_ilev_mm_doorson",
        "v_ilev_mm_doorw",
        "v_ilev_moteldoorcso",
        "v_ilev_mp_high_frontdoor",
        "v_ilev_mp_low_frontdoor",
        "v_ilev_mp_mid_frontdoor",
        "v_ilev_ph_cellgate",
        "v_ilev_ph_cellgate02",
        "v_ilev_ph_door002",
        "v_ilev_ph_door01",
        "v_ilev_ph_gendoor",
        "v_ilev_ph_gendoor002",
        "v_ilev_ph_gendoor003",
        "v_ilev_ph_gendoor004",
        "v_ilev_ph_gendoor005",
        "v_ilev_ph_gendoor006",
        "v_ilev_po_door",
        "v_ilev_ra_door1_l",
        "v_ilev_ra_door1_r",
        "v_ilev_ra_door2",
        "v_ilev_ra_door3",
        "v_ilev_ra_door4l",
        "v_ilev_ra_door4r",
        "v_ilev_ra_doorsafe",
        "v_ilev_rc_door1",
        "v_ilev_rc_door1_st",
        "v_ilev_rc_door2",
        "v_ilev_rc_door3_l",
        "v_ilev_rc_door3_r",
        "v_ilev_rc_doorel_l",
        "v_ilev_rc_doorel_r",
        "v_ilev_roc_door1_l",
        "v_ilev_roc_door1_r",
        "v_ilev_roc_door2",
        "v_ilev_roc_door3",
        "v_ilev_roc_door4",
        "v_ilev_roc_door5",
        "v_ilev_serv_door01",
        "v_ilev_shrf2door",
        "v_ilev_shrfdoor",
        "v_ilev_sol_off_door01",
        "v_ilev_spraydoor",
        "v_ilev_ss_door01",
        "v_ilev_ss_door02",
        "v_ilev_ss_door03",
        "v_ilev_ss_door04",
        "v_ilev_ss_door5_l",
        "v_ilev_ss_door5_r",
        "v_ilev_ss_doorext",
        "v_ilev_stad_fdoor",
        "v_ilev_staffdoor",
        "v_ilev_store_door",
        "v_ilev_ta_door",
        "v_ilev_ta_door2",
        "v_ilev_tort_door",
        "v_ilev_tow_doorlifta",
        "v_ilev_tow_doorliftb",
        "v_ilev_trev_door",
        "v_ilev_trev_doorbath",
        "v_ilev_trev_doorfront",
        "v_ilev_trev_patiodoor",
        "v_ilev_vag_door",
        "v_ilev_vagostoiletdoor",
    },
    MaxConcurrent = 16,
    MaxKeyframes = 96,
    -- Signed ratios allow the same door to swing in either hinge direction.
    MinOpenRatio = -1.0,
    MaxOpenRatio = 1.0,
    LockThreshold = 0.5,
    LockedState = 1,
    UnlockedState = 0,
    LocalOnly = true,
    -- Entity-backed doors use an exact kinematic transform while authoring and
    -- playback. This avoids Door System spring/inertia accumulating between
    -- preset changes. Doors with no streamed CObject keep the native fallback.
    DeterministicEntityMotion = true,
    EntityResolveRadius = 0.75,
    DoorSwingDegrees = 90.0,
    MaxCoordinateAbsolute = 100000.0,
}

-- Combat NPCs
-- ============================
Config.CombatPeds = {
    Networked = false,             -- local cinematic entities by default; avoids ownership migration
    MaxActive = 64,                -- hard budget across all combat entries in one playback
    ThinkIntervalMs = 350,         -- one shared AI update instead of one thread per NPC
    EngageRadius = 90.0,
    GuardRadius = 35.0,
    TargetMemoryMs = 4500,         -- pursue the last visible position for this long
    TargetSwitchCooldownMs = 1800,
    CoverRetaskMs = 3500,
    ReloadCheckMs = 500,
    RetreatHealthPercent = 18,     -- flee under this health when morale is broken
    MoraleLossPerAllyDeath = 22,
    MoraleRecoveryPerSecond = 2,
    CorpseLifetimeMs = 30000,      -- 0 keeps corpses until playback stops
    DefaultAmmo = 240,
    Debug = false,
}

-- ============================
-- Custom Weapons
-- ============================
-- Add addon/custom weapon names here so they appear in the UI weapon dropdown
-- and can be resolved consistently by scene peds, custom scenes, placement,
-- calibration, and ped replay playback.
--
-- Examples:
-- Config.CustomWeapons = {
--     { label = "Glock 17", name = "WEAPON_GLOCK17", ammo = 999 },
--     { label = "AK personalizada", name = "WEAPON_AK47", components = { "COMPONENT_AT_AR_FLSH" } },
--     "WEAPON_CUSTOMDEAGLE",
-- }
Config.CustomWeapons = Config.CustomWeapons or {}

-- ============================

-- Prop Emotes
-- ============================
Config.PropEmotes = Config.PropEmotes or {}

-- Enable/disable spawning of props for animations (e.g. chairs, phones, suitcases)
Config.PropEmotes.DisablePropsVisually = false

-- Enable/disable the "PropEmotes" tab in the animations menu
Config.PropEmotes.DisableMenuTab = false

-- Frames to wait after TaskPlayAnim before attaching props.
-- Bone-0/root props (chairs/seats) need a few frames for the ped pose basis to settle.
Config.PropEmotes.PropPoseWaitFrames = Config.PropEmotes.PropPoseWaitFrames or 1
Config.PropEmotes.RootPropPoseWaitFrames = Config.PropEmotes.RootPropPoseWaitFrames or 8
Config.PropEmotes.PropAnimStartTimeoutMs = Config.PropEmotes.PropAnimStartTimeoutMs or 500
Config.PropEmotes.RootPropReattachFrames = Config.PropEmotes.RootPropReattachFrames or 1
-- Delay (ms) before the one-time steady-state refine that slides root props
-- (chairs) under the skeleton root for clips with baked root motion.
Config.PropEmotes.RootPropRefineDelayMs = Config.PropEmotes.RootPropRefineDelayMs or 600
Config.PropEmotes.PlacementGroundOffset = Config.PropEmotes.PlacementGroundOffset or 1.0
-- The ped entity must sit AT the marker height (ground + PlacementGroundOffset,
-- i.e. standing capsule height). Subtracting an offset here buries the ped 1m
-- when the placement drag teleports it (CreatePed auto-grounds on spawn and
-- masks the mismatch). Keep 0.0 unless an anim pack needs a global correction.
Config.PropEmotes.PlacementPedZOffset = Config.PropEmotes.PlacementPedZOffset or 0.0

-- Optional model-specific rotation offsets for prop emotes. Values are added
-- to AnimationOptions.PropPlacement / SecondPropPlacement when a prop needs
-- a manual correction for your animation pack.
Config.PropEmotes.PropRotationOffsets = Config.PropEmotes.PropRotationOffsets or {
}

-- ============================
-- Custom Animation Category Remap
-- Maps vendor-specific category names from modules/animations/data/custom.lua to the
-- category that should appear in the UI tab bar.
-- Use "Custom" to group them under a single generic tab,
-- or set to false/nil to exclude them entirely.
-- ============================
Config.AnimCategoryRemap = {}

-- ============================

-- Custom Synched Scenes (2+ actors, uses placement + preview system)
-- These get added to the scenes list alongside the built-in ones.
-- Format per entry:
--   name      = Display name in the menu
--   category  = Category for grouping (e.g. 'Custom', 'Melee', etc.)
--   deltaZ    = Height offset for the scene (-1 = standing, 0 = ground level)
--   actorsAligned = true/false - whether actors face the same direction
--   actors    = { { animDict = '...', anim = '...' }, ... } - one per actor
--     Per-actor props (optional): props = { { model, bone, offset, rot }, ... }
--       bone IDs: 57005 = right hand, 18905 = left hand, 24818 = right foot, etc.
--     IMPORTANT: For synced scene animations (paired attack/victim, interactions, etc.)
--       do NOT add offsetX/offsetY/offsetHeading - the animation data handles positioning.
--       Only use manualPositioning = true + per-actor offsets for standalone (non-synced) animations.
--   objects   = { { model = '...', animDict = '...', anim = '...' }, ... } - optional scene props
-- ============================


Config.CustomScenes = {
    -- Dual knife finishers (attacker + victim paired)
    --
    -- How positioning works (mirrors rpemotes SyncOffsetFront / SyncOffsetHeading):
    --   The attacker (actor 1) is placed at the scene origin with the player's heading.
    --   The victim (actor 2) uses offsetY + offsetHeading to be placed independently:
    --     offsetY         = distance forward from the scene origin along the attacker's
    --                       forward axis (equivalent to rpemotes SyncOffsetFront).
    --                       Tune this until both peds align with the animation.
    --     offsetHeading   = rotation delta applied ON TOP of the scene heading.
    --                       180 = victim faces the attacker (equivalent to rpemotes
    --                       SyncOffsetHeading = 180, which is the default for interactions).
    --     offsetX         = lateral shift (right+), 0.0 = directly in front.
    --
    -- Because the victim has per-actor offsets, StartSyncScene automatically switches
    -- to manualPos mode (TaskPlayAnimAdvanced per actor) instead of NetworkSynchronisedScene.
    -- This is the correct path for animations that do NOT have relative positioning baked
    -- into the YCD root motion.
    {
        name = 'Dual Knife Finisher 1',
        category = 'Custom',
        actorsAligned = false,
        deltaZ = -1,
        actors = {
            {
                animDict = 'dual_knife', anim = 'atc_rv_finisher_1',
                offsetX = 0.3237,
                offsetY = -0.4774,
                offsetZ = 0.0,
                offsetHeading = -17.3848,
                props = {
                    { model = 'w_me_knife_01', bone = 57005, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(110.0000, 0.0000, 0.0000) },
                    { model = 'w_me_knife_01', bone = 18905, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(29.0000, 0.0000, 0.0000) },
                },
            },
            {
                animDict = 'dual_knife', anim = 'vic_rv_finisher_1',
                offsetX = 0.9404,
                offsetY = 0.6989,
                offsetZ = 0.0,
                offsetHeading = 168.2447,
            },
        },
        objects = {},
    },
    {
        name = 'Dual Knife Finisher 2',
        category = 'Custom',
        actorsAligned = false,
        deltaZ = -1,
        actors = {
            {
                animDict = 'dual_knife', anim = 'atc_rv_finisher_2',
                props = {
                    { model = 'w_me_knife_01', bone = 57005, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(110.0000, 0.0000, 0.0000) },
                    { model = 'w_me_knife_01', bone = 18905, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(29.0000, 0.0000, 0.0000) },
                },
            },
            { animDict = 'dual_knife', anim = 'vic_rv_finisher_2', offsetY = 0.8, offsetHeading = 180 },
        },
        objects = {},
    },
    {
        name = 'Dual Knife Finisher 3',
        category = 'Custom',
        actorsAligned = false,
        deltaZ = -1,
        actors = {
            {
                animDict = 'dual_knife', anim = 'atc_rv_finisher_3',
                props = {
                    { model = 'w_me_knife_01', bone = 57005, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(110.0000, 0.0000, 0.0000) },
                    { model = 'w_me_knife_01', bone = 18905, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(29.0000, 0.0000, 0.0000) },
                },
            },
            { animDict = 'dual_knife', anim = 'vic_rv_finisher_3', offsetY = 0.8, offsetHeading = 180 },
        },
        objects = {},
    },
    {
        name = 'Dual Knife Finisher 4',
        category = 'Custom',
        actorsAligned = false,
        deltaZ = -1,
        actors = {
            {
                animDict = 'dual_knife', anim = 'atc_rv_finisher_4',
                props = {
                    { model = 'w_me_knife_01', bone = 57005, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(110.0000, 0.0000, 0.0000) },
                    { model = 'w_me_knife_01', bone = 18905, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(29.0000, 0.0000, 0.0000) },
                },
            },
            { animDict = 'dual_knife', anim = 'vic_rv_finisher_4', offsetY = 0.8, offsetHeading = 180 },
        },
        objects = {},
    },
    {
        name = 'Dual Knife Finisher 5',
        category = 'Custom',
        actorsAligned = false,
        deltaZ = -1,
        actors = {
            {
                animDict = 'dual_knife', anim = 'atc_rv_finisher_5',
                props = {
                    { model = 'w_me_knife_01', bone = 57005, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(110.0000, 0.0000, 0.0000) },
                    { model = 'w_me_knife_01', bone = 18905, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(29.0000, 0.0000, 0.0000) },
                },
            },
            { animDict = 'dual_knife', anim = 'vic_rv_finisher_5', offsetY = 0.8, offsetHeading = 180 },
        },
        objects = {},
    },
    {
        name = 'Dual Knife Finisher 6',
        category = 'Custom',
        actorsAligned = false,
        deltaZ = -1,
        actors = {
            {
                animDict = 'dual_knife', anim = 'atc_rv_finisher_6',
                props = {
                    { model = 'w_me_knife_01', bone = 57005, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(110.0000, 0.0000, 0.0000) },
                    { model = 'w_me_knife_01', bone = 18905, offset = vec3(0.1200, 0.0200, -0.0200), rot = vec3(29.0000, 0.0000, 0.0000) },
                },
            },
            { animDict = 'dual_knife', anim = 'vic_rv_finisher_6', offsetY = 0.8, offsetHeading = 180 },
        },
        objects = {},
    },
}

-- ============================
-- Custom Solo Animations (1 actor, uses solo animation + placement system)
-- These get added to the animations list alongside the built-in ones.
-- Format: { dict = 'animDict', anim = 'animName' }
-- ============================
Config.CustomAnimations = {
    -- Example: individual knife anims played solo
    -- { dict = 'dual_knife', anim = 'atc_rv_finisher_1' },
}

-- Advanced Record captures loaded vehicles and peds around the moving player.
-- Entity limits keep recording the current cast and warn when additional
-- entities cannot be included. The total sample/duration limits finish the take.
Config.AdvancedRecord = {
    Radius = 80.0,
    MaxVehicles = 48,
    MaxPeds = 96,
    MaxTotalSamples = 40000,
}
