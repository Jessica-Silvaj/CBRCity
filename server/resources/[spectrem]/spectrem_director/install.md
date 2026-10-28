# Spectrem Director 2.8.0 — Installation Guide

This guide is for server owners installing the production release of Spectrem Director. It covers the required dependency, resource order, database setup, permissions, optional integrations, verification, updates, and common installation problems.

For the complete user manual, open `OPEN ME WITH A BROWSER.html` in any modern browser.

## 1. Requirements

Before installing Spectrem Director, confirm that the server has:

- A current FiveM server artifact with OneSync enabled.
- A working MySQL or MariaDB database.
- `oxmysql` installed and connected to that database.
- A database account allowed to run `CREATE`, `ALTER`, `SELECT`, `INSERT`, `UPDATE`, and `DELETE` queries during the first startup.
- Enough disk space for saved peds, scenes, timelines, and replay data.

Spectrem Director does not require ESX, QBCore, Qbox, or another roleplay framework. It includes a native ped appearance editor, so a clothing resource is optional.

## 2. Prepare the Resource

1. Stop the server before replacing an existing installation.
2. Extract the production package into the server's `resources` directory.
3. Make sure the final folder is named exactly:

   ```text
   spectrem_director
   ```

4. Do not use `spectrem_director_dev` as the production folder name.
5. Do not move, rename, or reorder files inside the resource.
6. Do not install Node.js or run a frontend build. The production NUI is already compiled in `web/build`.

The resulting structure should begin like this:

```text
resources/
└── spectrem_director/
    ├── shared/
    ├── modules/              # organized runtime domains
    ├── stream/
    ├── web/
    ├── config.lua            # single global configuration
    ├── edit.lua
    ├── fxmanifest.lua
    ├── README.md             # feature and operating reference
    ├── install.md
    ├── TIMELINE_EDITOR.md    # technical Timeline extension reference
    └── OPEN ME WITH A BROWSER.html  # searchable user manual
```

## 3. Configure the Database and Start Order

Set the database connection before starting `oxmysql`, then start Director after it.

Example `server.cfg` order:

```cfg
set mysql_connection_string "mysql://USER:PASSWORD@127.0.0.1/DATABASE?charset=utf8mb4"
set sv_enableNetEventReassembly true

ensure oxmysql
ensure spectrem_director
```

`sv_enableNetEventReassembly` enables FiveM's latent-event reassembly. Keep it enabled because Director uses latent transfers for large Ped Replay payloads without overflowing the normal reliable-event queue. FiveM enables it by default, but declaring it explicitly prevents a server preset or inherited configuration from disabling it. Restart the server after changing this convar.

If an optional appearance or animation-menu resource is enabled in `edit.lua`, start that provider before Director:

```cfg
set sv_enableNetEventReassembly true

ensure oxmysql
ensure illenium-appearance   # Only when selected in edit.lua
ensure WC_EMOTES_V8          # Only when its animation bridge is enabled
ensure spectrem_director
```

Do not import SQL for a normal installation. Spectrem Director automatically creates and upgrades its tables. Keep `CREATE` and `ALTER` permissions available for the first start and after version updates that include database migrations.

The included `spectrem_director.sql` file is an emergency fallback for experienced administrators. Automatic setup is the supported method because runtime support tables may be created or migrated by the resource itself.

### Client plugins (Script Hook)

For client plugins that require Script Hook, the server administrator must add or update this line in the active `server.cfg`:

```cfg
sv_scriptHookAllowed 1
```

Write it exactly as shown, without `=`. The value `1` allows Script Hook; `0` disables it. Check that another loaded configuration does not override the value, restart the complete server, and reconnect the client. Restarting only the Director resource does not reload `server.cfg`.

This applies to Script Hook-based client plugins. Spectrem Director and normal FiveM resources such as appearance or emote providers do not require this setting just because they are installed.

**Rockstar false positives:** enabling Script Hook is not a guarantee against false-positive detections by Rockstar or Cfx.re. The [official FiveM reference](https://docs.fivem.net/docs/server-manual/server-commands/#sv_scripthookallowed-truefalse) documents permission to use Script Hook, not protection from detections. Follow the plugin author's FiveM compatibility and installation instructions.

> **Third-party mods disclaimer:** Spectrem Scripts is not responsible for account bans or suspensions resulting from the use of third-party mods or plugins. Use these mods only in local environments and make sure you follow the platform rules. Local use does not guarantee protection against sanctions.

## 4. Configure Access

The current default is administrator-only access:

```lua
Config.Access = {
    AdminOnly = true,
    AcePermissions = {
        'spectrem_director.use'
    }
}
```

Add the dedicated ACE permission to the appropriate server group:

```cfg
add_ace group.admin spectrem_director.use allow
```

Use your server's normal principal or framework setup to place trusted users in that group. A separate Director group can also be used:

```cfg
add_ace group.spectrem_director spectrem_director.use allow
add_principal identifier.license:REPLACE_WITH_LICENSE group.spectrem_director
```

Keep the dedicated `spectrem_director.use` permission explicit; the default permission list no longer includes the broad `command` ACE. Set `AdminOnly = false` only when every connected player should be allowed to open Director.

Feature-level access is configured in the same `config.lua` with `Config.SceneAdmin`. Add each trusted manager's `license:` or `license2:` identifier to `Licenses`, then use `/sceneadmin` in game. `enabled` uses normal Director access with exceptions from `PublicAccess`; `admin` requires a SceneAdmin manager; `disabled` blocks the feature globally. The defaults allow public players to open only Cinematic Camera with `/camera`. F5, `/director`, and `/tutorial` remain restricted, and closing `/camera` returns to the game.

The main Director, Guided Tutorial, and Cutscene Player entry points validate access. `/tutorial` uses the same general authorization as F5 and `/director`. Tool commands and NUI actions also check their feature policies; server handlers validate authorization for their own operations.

Add this section to the existing `config.lua` only if upgrading from a version without it; otherwise edit its values:

```lua
Config.SceneAdmin = {
    Command = 'sceneadmin',
    CameraCommand = 'camera',
    Licenses = {
        -- 'license:0123456789abcdef0123456789abcdef01234567',
        -- Replace with the real player identifier.
    },
    AcePermission = '', -- Optional: 'spectrem_director.manage'
    AdminsHaveToolAccess = true,
    AuditLimit = 60,
    PublicAccess = { camera = true },
    Defaults = { camera = 'enabled', developer = 'admin' },
}
```

#### Policy modes and AdminOnly

| Feature mode | `AdminOnly = true` | `AdminOnly = false` |
|---|---|---|
| `enabled` | Requires normal Director access; `PublicAccess.camera = true` permits public `/camera`. | Available to all players. |
| `admin` | Requires a SceneAdmin manager and normal Director access. | Requires a SceneAdmin manager. |
| `disabled` | Blocked for everyone, including managers. | Blocked for everyone, including managers. |

Changing `AdminOnly` to `false` opens the main menu to everyone; it does **not** disable feature policies or authorize everyone to manage them. Keep it `true` for the public-camera-only setup. The legacy `Config.Access.Enabled = true` also enables the general access restriction if that field is present.

A SceneAdmin manager is a player listed in `Config.SceneAdmin.Licenses` or granted the optional `Config.SceneAdmin.AcePermission`. Having `spectrem_director.use` alone grants general Director access, not management of policies or use of features in `admin` mode. `AdminsHaveToolAccess = true` gives managers general access automatically; if set to `false`, they also need general access to use restricted tools, but can still manage policies.

#### Set up and use Scene Admin

1. Edit the commented **Scene Admin / Feature Policies** section in the existing `config.lua`; there is no separate `config_admin.lua`.
2. Add full player identifiers, including `license:` or `license2:` and their 40-character hexadecimal hash, to `Licenses`. These are player identifiers, not the server's `sv_licenseKey`. Documentation examples are placeholders.
3. Optionally set `AcePermission = 'spectrem_director.manage'` and grant that exact ACE to the intended group. An empty string disables this alternative; license authorization continues to work.
4. Keep `PublicAccess.camera = true` and set the camera policy to `enabled` for public `/camera`. Setting it to `admin` or `disabled` removes public access. `PublicAccess.camera = false` makes `enabled` camera use require normal Director access.
5. Restart the running resource after editing configuration. For development, use `restart spectrem_director_dev`; for an installation named `spectrem_director`, use `restart spectrem_director`.
6. Run `/sceneadmin`, search or filter by category, change individual modes or apply one mode to the filtered results, then select **Save changes**. **Discard changes** cancels the current draft; **Refresh** reloads the current saved policy. Closing a draft with unsaved changes asks before discarding it. **Ctrl+S** saves and **Esc** closes the panel.

`Command` and `CameraCommand` are stored without a slash and default to `sceneadmin` and `camera`. Managers can also open Scene Admin using the shield button in Director. The panel provides English and Spanish text, counts per mode, pending-change indicators, and a history of who changed each feature, when, and its previous/new mode. `AuditLimit` defaults to 60 and is bounded to 10–100 entries.

#### Features covered

The panel has 33 feature controls:

| Category | Policy IDs |
|---|---|
| Scenes and editing | `scenes`, `scene_preview`, `custom_scenes`, `timeline`, `scene_tools`, `developer` |
| Cinema and cameras | `camera`, `capture`, `cutscenes`, `stage_lighting`, `cinematic_text` |
| Actors and animations | `peds`, `appearance`, `ped_control`, `animations`, `custom_animations`, `animation_bridge`, `actor_sequencer`, `ped_replay` |
| Objects | `spooner`, `prop_placement`, `object_motion`, `door_director` |
| Vehicles | `vehicles`, `mechanic`, `vehicle_replay` |
| World and environment | `traffic_replay`, `police_chase`, `weather`, `density`, `environment`, `effects`, `clubs` |

Combat NPC actions are covered by `peds`; Ghost Replay uses `vehicle_replay`. Camera movement recording belongs to the camera workflow; capture/export has its separate policy. Public camera access does not grant the animation workspace, Timeline, Custom Scenes, or capture/export.

#### Persistence, live changes and recovery

Saved panel choices survive restarts in this resource's KVP storage. They are not written back into `config.lua`. Existing saved modes take precedence over `Defaults`, so changing `AdminOnly` or editing `Defaults` does not reset saved feature choices. On first use, omitted defaults become `admin` when general access is restricted, otherwise `enabled`. Use **Restore configuration defaults** in the panel to deliberately reapply the current defaults globally.

Saving applies policies to connected players. Revoked tools run their cleanup, and active composed previews/recordings may be stopped; saved projects remain. Existing availability limits supported by `config.lua` and `edit.lua` still apply: the panel cannot override a feature disabled there. The UI marks these configuration locks.

Concurrent edits use a revision check. If another manager saves first, your draft is retained but cannot overwrite the newer revision: refresh and reapply the changes. A failed save leaves the active policy unchanged. Invalid saved policy data locks features; an authorized manager can restore defaults from `/sceneadmin`.

#### Fixes and verification

The administration integration validates permissions in server handlers as well as client callbacks and commands. Nested camera, Timeline and Custom Scene actions check their required features. Server identity comes from identifiers/ACE, not a role submitted by the UI. The default access list uses the explicit `spectrem_director.use` ACE instead of the broad `command` fallback.

The public `/camera` flow opens Camera Controls directly and returns to gameplay on close, including for managers who entered through the command. F5, `/director` and `/tutorial` remain separate entry points. The camera's animation shortcut is hidden for public users. Denied or malformed scene-list responses are normalized to an empty array, fixing the Vue render error **Cannot read properties of undefined (reading 'length')** seen when access was rejected.

Test with both a manager and a regular player: verify public camera open/close, denied main-menu access with `AdminOnly = true`, each policy mode, saved settings after restart, and continued restrictions with `AdminOnly = false`. Automated permission, camera lifecycle, NUI and TypeScript checks passed for this implementation; a live FiveM session is still needed to verify native behavior on your server.

## 5. Review the global configuration

All supported user settings are kept together in the root `config.lua`.
Review this file before the first public use. Important options include:

- `Config.OpenKey` — default Director key: `F5`.
- `Config.Command` — default command: `/director`.
- `Config.TutorialCommand` — guided tutorial command without the slash; default: `tutorial` (`/tutorial` in chat).
- `Config.Language` — `en` (default), `es`, `de`, `tr`, `fr`, `ar`, `vi`, `pl`, or `pt-br` (Brazilian Portuguese). Arabic automatically enables right-to-left interface direction.
- `Config.Access` — administrator mode and accepted ACE permissions.
- `Config.UITheme` — interface colors.
- `Config.UIScale` — multiplier for the automatic, resolution-based NUI size (`1.0` by default). Players can override it using the monitor icon in Director or Timeline. The 75-200% slider adjusts in 5% steps, with a maximum that keeps controls on screen. Preferences save on the current device; **Restore recommended size** returns to automatic sizing using this server default.
- `Config.RandomPeds` — models offered by the quick ped tools.
- `Config.Placement` — placement movement and camera sensitivity.
- `Config.ScenePreview` — scene inspection orbit, smoothing, target and FOV limits.
- `Config.ObjectMotion` — procedural prop motion and the independent camera-style path recorder.
- `Config.CinematicCamera` — camera keys, speed, smoothing, recording, visual aids, and limits.
- `Config.ActorSequencer` — persistent editor camera, route authoring speeds and action defaults.
- `Config.DoorDirector` — map/MLO door detection, registered addon models, signed opening ratio and keyframe limits.
- `Config.SceneTools` — collection, entry and attachment limits.
- `Config.Density` — traffic and population controls.
- `Config.PoliceChase` — Chase availability, classic defaults, unit limits, vehicle/helicopter catalogues, driving presets, protection, local deployment distances, on-foot response, opt-in Advanced Fleet casting, and Chase Replay limits.
- `Config.Cutscenes` — Cutscene Player key, command, fades, and timeouts.
- `Config.TimeSpeed` — time-speed presets.
- `Config.PedReplay` and `Config.GhostReplay` — replay capture and playback limits.
- `Config.CombatPeds` and `Config.CustomWeapons` — combat actor behavior and weapon additions.
- `Config.PropEmotes` — prop-animation placement behavior.
- `Config.StageLighting` — physical Stage Light fixtures, authoring Freecam, and Rockstar Editor recording behavior.
- `Config.CinematicText` — text limits, DUI resolution/update rate, draw distance, defaults, and persistent authoring Freecam controls.
- `Config.CustomScenes` — server-defined synchronized scenes.
- `Config.CustomAnimations` — additional solo animations.

Default entry-point settings:

```lua
Config.OpenKey = 'F5'
Config.Command = 'director'
Config.TutorialCommand = 'tutorial'
Config.Language = 'en'
```

### Language startup behavior

`Config.Language` defines the initial, global language for the complete interface. Supported codes are `en` (default), `es`, `de`, `tr`, `fr`, `ar`, `vi`, `pl`, and `pt-br` (Brazilian Portuguese). The value is loaded and cached once when the resource and NUI start, avoiding a full translation pass whenever F5 is opened. Restart `spectrem_director` after changing it so clients load the new language.

### Chase configuration checks

Chase uses local cinematic entities and should keep
`Config.PoliceChase.Networked = false`. Before allowing staff to use it:

1. Keep `DefaultUnits` between `MinUnits` and `MaxUnits`.
2. Confirm `DefaultVehicle` exists in `Vehicles`, or enable
   `AllowCustomVehicleModels` for valid streamed/add-on spawn names.
3. Confirm `DefaultHelicopterModel` exists in `Helicopters`.
4. Start any resource that streams an add-on vehicle before users open Chase.
5. Review `Protection`, `OnFootResponse`, deployment distance, and retask/respawn
   distances for the type of cinematic shot you expect. The target is always the
   local player; `OnFootResponse` affects only NPCs created by Chase. Nearby
   officers brake, leave their patrol cars and engage the player after the
   player exits a stopped vehicle. They return to their units when vehicle
   pursuit resumes, and the feature can be disabled to keep them inside.
6. Review `AdvancedFleet.Enabled`, `MaxOccupantsPerUnit`, and `Weapons`. Classic
   Chase remains the user-facing default until the operator explicitly enables
   **Advanced Fleet** in the panel; the config switch only makes the advanced
   controls available.
7. Review `ChaseReplay.SampleIntervalMs`, `MaxDurationSeconds`, `MaxVehicles`,
   and `MaxTotalFrames` against the expected pursuit length and server hardware.
   `MaxTotalFrames` is shared by all recorded tracks and prevents a large fleet
   from exceeding the existing replay upload and client-memory limits.

When Advanced Fleet is enabled by the operator, **Same setup for all** applies one
vehicle/crew template to all ground units, while **Configure each unit** allows every
unit to be cast separately. A unit can use the default Chase vehicle, a valid
streamed/add-on model, or a tuned **My Vehicles** preset. Saved paint, mods,
extras, lights, liveries and decals are retained. Chase reads the selected
vehicle's exact seat capacity: seat `-1` is always the required driver and seats
`0+` are passengers. Each seat can use the default Chase ped, a saved ped, or a
valid custom model. The selected unit weapon is used only if on-foot response
is enabled and its normal exit conditions are met.

The normal F5 close leaves an active pursuit running so the director can drive
and record it. **End Chase**, a forced Director close, or resource stop performs
cleanup.

For a repeatable multi-vehicle take, open the separate **Chase Replay** tab while
a Chase is active. Select **Record**, perform the pursuit, select **Stop**, name
the take, and select **Save**. The Chase Replay library provides independent
**Play**, **Stop**, and **Delete** actions. One synchronized clock captures the
target, all active ground units, and the helicopter when present. NPC vehicle
exit and combat are intentionally locked during both recording and playback;
this feature reproduces vehicle trajectories, not the live on-foot encounter.

Chase Replay uses the existing Vehicle Replay persistence table and bounded
chunk transfer internally, while presenting its recordings in a separate
library. Existing installations do **not** need to reinstall SQL or run a
database migration.

To disable the tool without removing its configuration, set this in `edit.lua`:

```lua
EDIT.DisablePoliceChase = true
```

### Stage Lighting and Rockstar Editor

The production package includes `stream/[Stage Lighting]/scenedirector.ytyp`
and the 15 physical fixture models from `prop_sd_spot_01` through
`prop_sd_spot_15`. Do not remove or rename this directory. The manifest mounts
the YTYP automatically, and Stage Lighting intentionally uses only these
physical fixtures so the light can persist in a Rockstar Editor recording.

Open Stage Lighting from Custom Scenes or Timeline. Its Freecam remains active
for the complete editing session: hold **RMB** and use **WASD**, **Q/E**,
**Shift**, and **Ctrl** to inspect the scene; release RMB to use the interface.
Under **Place**, click **Edit fixture with gizmo** to translate or rotate the
physical light directly. Finish placement to resume its procedural animation.
Gizmo placement applies to fixed world lights; a following light uses its
subject and local offset instead.

The **Color** step exposes 15 verified presets: three white levels and soft or
bright red, magenta, green, yellow, blue, and cyan variants. Selecting a swatch
loads the corresponding fixture model and its exact embedded RGB value. Color,
intensity, 20 m falloff, and beam cone are compiled into each asset; position,
rotation, timing, follow, aim, movement, sweep, and binary on/off flicker remain
editable. Fixture models are preloaded before the shared scene clock so the
first recorded frames are not lost.

The included fixture build has all 24 hourly light flags enabled. Test a short
day clip and night clip after changing the GTA/FiveM artifact used by the
server. If a model cannot load, Director blocks saving and reports the exact
failure instead of silently displaying a non-recordable substitute.

Relevant settings are grouped under `Config.StageLighting.FixtureBackend`:

- `Enabled` enables or disables physical Stage Lighting fixtures.
- `Networked` controls whether the fixture is a local or OneSync entity. Keep
  the default unless an in-editor A/B test on your server proves otherwise.
- `AllHours` and `SourceTimeFlags` describe the compiled asset and should not be
  changed unless the fixtures themselves are rebuilt.
- `AllowUnlistedModels` exposes the advanced model override. Leave it disabled
  unless the server streams another verified object with an embedded `CLight`.

Keep a backup of your edited `config.lua` outside the resource before
updating.

### Cinematic Text

Cinematic Text is included in the resource and needs no external font, image,
or database migration. Open it directly from Director or from a Custom Scene or
Timeline. Its guided studio lets the user write Unicode/multiline content,
start from Title, Subtitle, Neon, or Warning, refine local font and effects,
choose Fixed or Face camera orientation, select an entrance/exit animation, and
set the exact duration.

The font selector previews **40 offline choices** (5 base families plus 35
bundled local families), including condensed title, elegant serif, modern sans,
techno/display, handwritten, and monospaced styles. The library requires no
Internet connection. Latin and Latin Extended are available throughout it,
while many families also include Vietnamese glyphs. Arabic, emoji, and glyphs
not included by a selected family fall back to compatible system fonts, so
exact coverage can vary by font and client installation.

The authoring Freecam remains active for the full session. Hold **RMB** and use
**WASD**, **Q/E**, **Shift**, and **Ctrl** to inspect the scene; release RMB to
work with the UI. Use the placement button to move and rotate the invisible text
anchor with the native gizmo. Preview changes are temporary until the entry is
saved into its Custom Scene or Timeline.

The result is a FiveM DUI surface. It is available in live previews and direct
**EXPORT** MP4 output, but it cannot be embedded into a Rockstar Editor clip.
For that reason **ACTION!** fails closed when a production contains Cinematic
Text instead of recording a take with missing titles. Use Stage Lighting when
the required element must persist natively in Rockstar Editor.

Relevant settings are grouped under `Config.CinematicText`:

- `MaxConcurrent`, `MaxCharacters`, and `MaxLines` bound runtime/editor use.
- `MaxRenderDistance`, `DefaultDurationSeconds`, `MaxDurationSeconds`,
  `DefaultScale`, and `DefaultFacing` control safe defaults.
- `DuiWidth`, `DuiHeight`, and `UpdateFps` control the local render surface.
- `AuthoringCamera` controls normal, fast, precise and mouse movement.
- `Debug` enables focused diagnostics only while troubleshooting.

## 6. Review `edit.lua`

`edit.lua` is the supported bridge file for server-specific integrations. Keep custom integration code there whenever possible.

### Appearance system

The default is:

```lua
EDIT.ClothingSystem = "native"
```

The native option requires no external resource. Optional modes can connect `illenium-appearance`, a ped-only provider, or a fully custom appearance resource. When using an external provider:

1. Start it before Director.
2. Select the matching mode in `edit.lua`.
3. Implement or verify the provided model, appearance, save, and customization hooks.
4. Test both a freemode ped and a non-freemode ped.

### External animation menu

The included bridge is configured for `WC_EMOTES_V8`. If that resource is not installed, disable the bridge:

```lua
EDIT.AnimationBridge.Enabled = false
```

To support another animation menu, update only the bridge functions in `edit.lua`: availability, open, prepare selection, finish selection, cancel, and current-emote lookup. The lookup must return normalized animation dictionary and clip data, or scenario data.

### Weather integration

Director can apply local native weather and time effects. For a server-wide custom weather resource, enable and implement `EDIT.WeatherBridge`.

Keep framework bootstraps and external imports in a separate companion resource. Do not add another resource's `@.../init.lua` directly to the Director manifest. Validate the implicit FiveM event `source` in every server event used by the bridge.

## 7. Optional Resources

These integrations are optional:

- `illenium-appearance` — external appearance editing when selected in `edit.lua`.
- `WC_EMOTES_V8` — the default external animation-menu bridge; disable the bridge if absent.
- `Renewed-Weathersync` — optional server weather synchronization.
- `screenshot-basic` — enables the Camera panel's Photo button. Without it, users can use their normal screenshot key.
- **Spectrem Export** — separate Windows application used only for direct MP4 export.

An unavailable optional integration should never be left enabled in `edit.lua`.

### Spectrem Export (optional direct MP4 exporter)

Spectrem Director does not require Spectrem Export. **ACTION** records the take for Rockstar Editor and remains available without the desktop application. **EXPORT** sends the same take to Spectrem Export and produces an MP4 directly.

- **Downloads:** [GitHub Releases](https://github.com/Spectrematozoide/SpectremExport/releases)
- **Official project:** [github.com/Spectrematozoide/SpectremExport](https://github.com/Spectrematozoide/SpectremExport)

To install it on the Windows computer that runs FiveM/GTA:

1. Open the Releases page and expand **Assets** for the version you want.
2. Download `SpectremExport-<version>-portable.zip`. Do not use GitHub's automatic **Source code** archives unless you intend to compile the project.
3. Extract the entire ZIP to a permanent folder. Do not run the executable from inside the ZIP.
4. Run `SpectremExport.exe` and keep it open while exporting from Camera, Custom Scenes, or Timeline.
5. In Director, select **EXPORT**, review the preflight results, and start the take only when the exporter reports that it is ready.

The exporter requires Windows 10/11 x64 and .NET Framework 4.8. On first launch it creates its local configuration and output folders, then downloads and verifies its managed copy of FFmpeg over HTTPS when necessary. The default output is `%USERPROFILE%\Videos\Spectrem Export`; if Windows rejects that location, the application falls back to `%LOCALAPPDATA%\Spectrem Export\captures`.

The packaged defaults communicate immediately. For regular use, replace `sharedToken` in `%LOCALAPPDATA%\Spectrem Export\config.json` with a long random value and set the same value in `Config.SpectremRecorder.Token` inside Director's `config.lua`, then restart both sides.

The current exporter captures the visible FiveM/GTA window in real time as H.264 MP4 without audio. Because the prototype is not digitally signed, Windows SmartScreen may display a warning on first launch; download it only from the official repository above.

### Optional content catalogs

The optional `modules/cutscenes/data/newcutscene.lua` file enables the dedicated **New** tab in the Cutscene Player. The tab is hidden when that catalog is unavailable or empty. Preserve its exact filename and path, and restart Director after adding or removing it.

**Data Update is included as a normal client script** at `modules/scenes/data/scenes_update.lua`. Keep this file in the complete resource installation. Its loading no longer depends on optional-file detection: FiveM's script loader handles it, including escrow encryption, before Director builds the Scenes menu. Its entries are appended under **Data Update** while existing scene IDs remain unchanged.

If **Data Update** is missing, inspect the affected client's **F8** console after resource startup for `[Spectrem Director][Catalog]`. The Data Update line reports `source=client_script`, its path, and entry count. `missing_or_invalid` means the script did not initialize its catalog; check the preceding FiveM script-loading error and download the complete current release. This is a client startup log, not a database or server-console check.

The optional `newcutscene.lua` catalog still uses a text loader and must retain its packaged `escrow_ignore` rule before uploading to Portal. Editing an already encrypted download cannot decrypt this optional file; the publisher must re-upload the corrected package. Its startup line reports `loaded`, `unavailable`, `compile_failed`, or `runtime_failed`, with byte and entry counts. Save optional text catalogs as UTF-8; a UTF-8 BOM is accepted.

## 8. First Startup

1. Start the server and watch the server console.
2. Confirm that `oxmysql` starts before Director.
3. Confirm the Director resource starts without a missing dependency or manifest error.
4. Look for database-ready messages similar to:

   ```text
   [Spectrem Director] DB replay work unit: 256 KB
   [Spectrem Director] Database table ready
   [Spectrem Director] Custom scenes, Ghost Replays, and Ped Replays tables ready
   ```

5. Join with an authorized account.
6. Press `F5` or run `/director`.
7. Press `F6` or run `/cutscenes` to verify Cutscene Player access.
8. Run `/tutorial`, verify its spotlight, language selector, and automatic Camera, Custom Scene, and Timeline demonstrations, then finish the 70-step tour. Director should remain open and no demo data should be saved.
9. Save and reload one ped.
10. Save and reopen one Custom Scene.
11. Save and reopen one Timeline project.
12. Open Object Motion, preview one two-keyframe prop path, then cancel and confirm the original prop transform is restored.
13. Draw a two-point Actor Sequence route, preview it in the persistent Freecam, and save or cancel it cleanly.
14. Select a supported world door in Door Director, apply a preset, preview both opening sides, then use Back to restore its original state.
15. Add one physical Stage Light, place it with the gizmo, and record a short day/night Rockstar Editor test after an artifact update.
16. Add Cinematic Text, verify a visual preset, Fixed and Face camera placement, animation and exact timing, save/reopen it, and confirm that **ACTION!** reports the Rockstar Editor limitation.
17. If Spectrem Export is installed, keep it open, choose **EXPORT** in Camera, Custom Scenes, or Timeline, confirm that preflight is ready, and complete one short MP4 test that includes Cinematic Text.
18. Test optional appearance, weather, animation-menu, and screenshot integrations only when they are enabled.

The permanent user-data tables created by the resource include:

```text
spectrem_director_peds
spectrem_director_ped_folders
spectrem_director_custom_scenes
spectrem_director_ghost_replays
spectrem_director_ped_replays
spectrem_director_vehicle_sessions
spectrem_director_saved_vehicles
spectrem_director_club_presets
spectrem_director_timeline_projects
```

Additional staging tables may be created for safe large-payload updates. Do not delete tables whose names begin with `spectrem_director_` while the resource is running.

## 9. Basic User Verification

After installation, confirm these basic workflows:

- Open Director with `F5` or `/director`.
- Run `/tutorial` and verify the 70 steps, nine chapter jumps, the 12-step Camera explanation, automatic protected Camera/Custom Scene/Timeline demonstrations, `EN`/`ES`/`DE`/`TR`/`FR`/`AR`/`VI`/`PL`/`PT-BR` selector, Arabic RTL layout, and keyboard navigation (`Left`/`Right`, `Enter`, `Page Up`/`Page Down`, `Home`/`End`, `Tab`, and `Esc`). The tour must not start Freecam, play content, save demo data, or modify the world.
- In Advanced Authoring, verify the new Vehicle Replay, Traffic Replay, Actor Sequence and Cinematic Text explanations highlight the correct entry buttons. They explain what to do after the tour; they must not open a recorder or spawn an actor/vehicle. Exit from a demo and confirm the original draft is restored.
- Outside the tour, place a test scene, raise it with Q, then use G in movement, free-camera and aim modes. Confirm ground height, retained heading/offsets, manual fine-tuning and correct saved height. Do not confuse this with Camera's G look lock; Traffic placement is already ground-locked.
- Stage a small Traffic Replay fleet, replace one car, ground-place another and draw a rounded route with a short delay. Nothing should drive before Record traffic. Save the resulting short take and reopen it from both Custom Scenes and Timeline.
- Compare a new smoothed Actor Sequence with a legacy route. Check walk/run and style changes, a transit corner and an event/wait point; save/reopen, scrub and run Preview. Unreachable arrival events must not fire.
- Test driver/passenger seat assignments and keep replay weapon fire off for an unarmed car. Append a short take to a referenced folder and wait for server confirmation before starting the next recording.
- Spawn and place a ped, take control of it, and return with `F7`.
- Apply clothing and an animation, then leave and return to confirm the state is retained.
- Open Object Spooner and place, clone, transform, and delete a test prop.
- Open Camera Controls, capture at least two keyframes with `L`, preview with `F7`, and stop with `F8`.
- Confirm `H`, `N`, `RMB`, `WASD`, `Q/E`, `Z/C`, arrow-key roll, `Shift` and `Ctrl` behave as described by the Camera HUD.
- Create a small Custom Scene and test it before saving.
- Add clips to Timeline, scrub the playhead, save with `Ctrl+S`, run preview with `Space`, and stop with `Backspace`.
- Add one Cinematic Text clip, place it with the persistent Freecam/gizmo, edit it after saving, and verify Unicode, multiline text, presets, Fixed/Face camera modes, animation, and Timeline scrubbing.
- Verify undo/redo, split/trim, Delete and Shift+Delete, markers, In/Out range playback, and a nested authoring clip before public use.
- Record and play a short Ghost, Ped, or Vehicle take.
- Tune a vehicle, save it from **My Vehicles**, then spawn it again and confirm
  that its paint, mods, extras and liveries were restored.

Delete test records after verification if they are no longer needed.

## 10. Updating an Existing Installation

1. Stop the server.
2. Back up the database and your current resource folder.
3. Preserve copies of your customized `config.lua` and `edit.lua`.
4. Extract the new production release into a new folder.
5. Reapply custom settings manually after comparing the new `config.lua`. Do not blindly overwrite it with an old version because new options may be required.
6. Keep the production folder name `spectrem_director`.
7. Start the server and allow automatic database migrations to finish.
8. Repeat the first-start verification checklist.

Never overwrite a downloaded escrow resource folder that contains `.fxap` with development files or a locally generated production build.

## 11. Troubleshooting

### The resource does not start

- Confirm the folder is named `spectrem_director`.
- Confirm `ensure oxmysql` appears before `ensure spectrem_director`.
- Confirm the production package contains `web/build/ui.html`, the compiled JavaScript bundle, and `stream`.
- Read the first Director error in the server console; later errors may be consequences of the first one.

### The menu does not open

- Test `/director` in case another resource uses `F5`.
- Confirm `Config.Access.AdminOnly` and the ACE permissions.
- Add `spectrem_director.use` to the correct group.
- Check F8 for NUI errors.
- Confirm no other full-screen NUI currently owns keyboard focus.

### The Guided Tutorial does not start

- Confirm `Config.TutorialCommand = 'tutorial'`; the config value does not include `/`.
- Verify the account passes the same `Config.Access` ACE and integrity checks as Director.
- Finish any active editor, entity placement, authoring camera, Object Spooner session, or preview, and close the `F6` Cutscene Player before retrying.
- If Director is already open, select the header `?` button to restart the tutorial from step 1.
- Completing or exiting the tutorial leaves Director open by design; use `F5` or `Esc` afterward if the menu should also close.

### Access is denied unexpectedly

- Distinguish general Director access from the SceneAdmin manager role and check the saved mode of the affected feature. `AdminOnly = false` does not clear saved feature restrictions.
- For public camera-only access, use `/camera`; for `/sceneadmin`, configure a full player license or its optional management ACE.
- Run the server's principal inspection tools and verify the player's identifier belongs to the intended group.
- Keep the dedicated `spectrem_director.use` ACE spelling exact.
- Restart the resource after changing `server.cfg` permissions.

### Database tables are missing or saves fail

- Confirm the connection string and database name.
- Confirm the account can run `CREATE`, `ALTER`, `SELECT`, `INSERT`, `UPDATE`, and `DELETE`.
- Look for an `oxmysql` error before the Director database-ready messages.
- Do not manually truncate staging tables while an upload or save is in progress.
- Large saves are transferred in controlled chunks; do not restart the resource while a save indicator is active.

### The NUI is blank or reports a fetch error

- Confirm the complete `web/build` directory was shipped.
- Clear the FiveM client cache and reconnect.
- Inspect F8 for the first `NUI Error` line.
- Confirm the package was built from a current compiled bundle.
- Do not edit the compiled JavaScript by hand.

### Ped Replay disconnects with a reliable network event size overflow

- Add `set sv_enableNetEventReassembly true` to `server.cfg` and restart the complete server.
- Reconnect the FiveM client after the restart so it receives the current client scripts.
- If the reported event is still `spectrem:server:savePedReplayChunk`, the server or client is running an older copy of Director; the current transport uses `savePedReplayLatent` instead.
- Do not compensate by raising general event-rate limits. Director's latent transport is designed to carry the recording without flooding the normal reliable-event queue.

### Peds have no clothing editor

- Use the built-in `native` clothing mode, or verify the selected external appearance resource starts first.
- Confirm its bridge functions in `edit.lua` match the installed provider version.

### The external animation menu does not open

- Start `WC_EMOTES_V8` before Director, or disable the bridge when it is not installed.
- For a custom menu, verify the bridge returns the current animation dictionary and clip.

### Camera Photo is unavailable

- Install and start `screenshot-basic`, or use the normal FiveM screenshot key.

### Performance or server hitch warnings

- Use the current production version; replay and database payloads are streamed and saved in bounded work units.
- Avoid several administrators saving very large takes at the same instant.
- Keep the database on low-latency storage and monitor slow queries.
- Do not increase storage or transfer limits without profiling the server.
- Review density, Chase, camera, and replay limits before raising them.

## 12. Support Information

When requesting support, provide:

- Spectrem Director version (`2.8.0` for this guide).
- FiveM artifact version.
- `oxmysql` version.
- Database server type and version.
- The first relevant server-console error.
- The first relevant client F8 error.
- Exact steps that reproduce the problem.
- Whether the problem still occurs with optional bridges disabled.

Support: <https://discord.gg/yNfaBPqkuH>

Spectrem Director © 2024–2026 Spectrem Scripts. All rights reserved.
