fx_version "cerulean"
games { "gta5" }

author "Spectrem Scripts"
description "Spectrem Director Beta"
version "2.9.0.7"
lua54 "yes"

discord "https://discord.gg/yNfaBPqkuH"

ui_page "web/build/ui.html"
files {
    "web/build/ui.html",
    "web/build/spectrem-director.js",
    "web/build/style.css",
    "web/build/vendor/vue.min.js",
    "web/build/vendor/fontawesome.min.css",
    "web/build/vendor/outfit.css",
    "web/build/vendor/webfonts/*.woff2",
    "web/build/vendor/fonts/*.woff2",
    "web/fonts/cinematic/*.css",
    "web/fonts/cinematic/*.woff2",
    "web/cinematic_text.html",
    "web/locales/*.js",
    "web/peds/*.webp",
    "web/props/*.webp",
    "modules/scenes/data/*.lua",
    "modules/actor_sequencer/style_catalog.json",
    "modules/cutscenes/data/*.lua",
}

shared_scripts {
    "ini.lua",
    "config.lua",
    "edit.lua",
    "shared/module_registry.lua",
    "shared/curve_engine.lua",
    "modules/core/shared.lua",
    "modules/administration/shared.lua",
    "modules/administration/contracts.lua",
    "modules/capture/shared.lua",
    "modules/scene_registry/shared.lua",
    "modules/scene_tools/shared.lua",
    "modules/actor_sequencer/route_geometry.lua",
    "modules/actor_sequencer/shared.lua",
    "modules/door_director/shared.lua",
    "modules/persistence/shared.lua",
    "modules/peds/shared.lua",
    "modules/animations/shared.lua",
    "modules/camera/shared.lua",
    "modules/spooner/shared.lua",
    "modules/object_motion/shared.lua",
    "modules/stage_lighting/shared.lua",
    "modules/cinematic_text/shared.lua",
    "modules/vehicles/shared.lua",
    "modules/replays/shared.lua",
    "modules/scenes/shared.lua",
    "modules/environment/shared.lua",
    "modules/timeline/shared.lua",
    "modules/clubs/shared.lua",
    "modules/cutscenes/shared.lua",
}

client_scripts {
    "modules/administration/client/runtime.lua",
    "modules/core/client/debug.lua",
    "modules/scenes/data/scenes.lua",
    "modules/scenes/data/scenes_update.lua",
    "modules/scenes/data/offsets.lua",
    "modules/animations/data/animations.lua",
    "modules/animations/data/pre_select.lua",
    "modules/cutscenes/data/cutscenes.lua",
    "modules/core/client/optional_catalogs.lua",
    "modules/scenes/data/scene_root_profiles.lua",
    "modules/scenes/client/authored_root_motion.lua",
    "modules/animations/data/custom.lua",
    "modules/peds/data/appearance_tattoos.lua",
    "modules/peds/client/appearance_native.lua",
    "modules/core/client/main.lua",
    "modules/scenes/client/vehicle_replacement_animation.lua",
    "modules/capture/client/recorder.lua",
    "modules/scene_registry/client/runtime.lua",
    "modules/animations/client/prop_emotes.lua",
    "modules/animations/client/prop_emote_placement.lua",
    "modules/animations/client/ground_transition.lua",
    "modules/animations/client/animation_preview.lua",
    "modules/animations/client/cutscene_catalog.lua",
    "modules/scenes/client/scene_calibrator.lua",
    "modules/camera/client/freecam.lua",
    "modules/camera/client/targets.lua",
    "modules/camera/client/motion.lua",
    "modules/camera/client/director.lua",
    "modules/spooner/client/native_gizmo.lua",
    "modules/scenes/client/placement.lua",
    "modules/scenes/client/scene_preview.lua",
    "modules/scenes/client/object_replacement_editor.lua",
    "modules/scenes/client/scene_dev_authoring.lua",
    "modules/spooner/client/menyoo_menu.lua",
    "modules/spooner/client/objectspooner.lua",
    "modules/spooner/client/project.lua",
    "modules/spooner/client/propplace.lua",
    "modules/object_motion/client/runtime.lua",
    "modules/object_motion/client/camera_recorder.lua",
    "modules/stage_lighting/client/runtime.lua",
    "modules/stage_lighting/client/authoring.lua",
    "modules/cinematic_text/client/attachment.lua",
    "modules/cinematic_text/client/runtime.lua",
    "modules/cinematic_text/client/authoring.lua",
    "modules/door_director/client/runtime.lua",
    "modules/vehicles/client/customization.lua",
    "modules/vehicles/client/placement.lua",
    "modules/replays/client/vehicle_events.lua",
    "modules/replays/client/recording_controls.lua",
    "modules/replays/client/occupant_animations.lua",
    "modules/replays/client/vehicle_replay.lua",
    "modules/replays/client/ped_replay_adaptive.lua",
    "modules/replays/client/advanced_record.lua",
    "modules/replays/client/ped_replay.lua",
    "modules/scenes/client/custom_scenes.lua",
    "modules/scene_tools/client/runtime.lua",
    "modules/actor_sequencer/client/editor_camera.lua",
    "modules/actor_sequencer/client/route_authoring.lua",
    "modules/actor_sequencer/client/styles.lua",
    "modules/actor_sequencer/client/runtime.lua",
    "modules/timeline/client/action_actor.lua",
    "modules/timeline/client/preview.lua",
    "modules/timeline/client/scrub.lua",
    "modules/peds/client/combat.lua",
    "modules/environment/client/police_chase.lua",
    "modules/replays/client/chase_replay.lua",
    "modules/replays/client/chase_scene_bridge.lua",
    "modules/environment/client/traffic_routes.lua",
    "modules/environment/client/traffic_replay.lua",
    "modules/environment/client/density.lua",
    "modules/environment/client/weather.lua",
    "modules/timeline/client/controls.lua",
    "modules/peds/client/models.lua",
    "modules/environment/client/environment.lua",
    "modules/vehicles/data/mechanic.lua",
    "modules/vehicles/client/mechanic.lua",
    "modules/clubs/client/club.lua",
    "modules/cutscenes/client/cutscenes.lua",
    "modules/core/client/ui.lua",
    "modules/peds/client/control.lua",
    "modules/core/client/lifecycle.lua",
}



data_file "DLC_ITYP_REQUEST" "stream/[Props]/rpemotesreborn/rpemotesreborn_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/Brummiee/brummie_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/BzzziProps/bzzz_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/BzzziProps/bzzz_camp_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/CandyApple/apple_1.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/KayKayMods/kaykaymods_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/KnjghPizzaSlices/knjgh_pizzas.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/NattyLollipops/natty_props_lollipops.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/UltraRingCase/ultra_ringcase.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/PataMods/pata_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/vedere/vedere_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/PNWParksFan/pnwsigns.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/EP/pprp_icefishing.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/Scully/scully_props.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/BzzziProps/samnick_prop_lighter01.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/BzzziProps/bzzz_murderpack.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Props]/protestsigns_fh/prop_protestsign_fh.ytyp"

data_file "DLC_ITYP_REQUEST" "stream/[Stage Lighting]/scenedirector.ytyp"

escrow_ignore {
    'config.lua',
    'edit.lua',
    'modules/environment/client/weather.lua',
    'modules/environment/client/density.lua',
    'modules/environment/client/police_chase.lua',
    'modules/animations/client/prop_emotes.lua',
    'modules/animations/client/prop_emote_placement.lua',
    'modules/animations/data/custom.lua',
    'modules/animations/data/pre_select.lua',
    'modules/scenes/data/offsets.lua',
    -- Loaded as text by optional_catalogs.lua; must remain readable after escrow.
    'modules/cutscenes/data/newcutscene.lua',
    
}

server_scripts {
    "modules/administration/server/runtime.lua",
    "@oxmysql/lib/MySQL.lua",
    "modules/persistence/server/main.lua",
    "modules/clubs/server/club.lua",
    "modules/scenes/server/scene_calibrator.lua",
    "modules/timeline/server/projects.lua",
    "modules/core/server/lifecycle.lua",
}

dependencies {
    "oxmysql",
}

optional_dependencies {
    "illenium-appearance",
    "Renewed-Weathersync",
}

dependency '/assetpacks'