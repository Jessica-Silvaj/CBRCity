(function registerSpectremTutorialCatalog() {
  "use strict";

  const packs = window.SD_LANG_PACKS || (window.SD_LANG_PACKS = {});
  const localeOverrides = window.SD_LOCALE_STRING_OVERRIDES
    || (window.SD_LOCALE_STRING_OVERRIDES = {});

  const catalogs = {
    en: {
      "tutorial.title": "Interactive Director tutorial",
      "tutorial.progress": "Step {{current}} of {{total}}",
      "tutorial.previous": "Previous",
      "tutorial.next": "Next",
      "tutorial.finish": "Finish tutorial",
      "tutorial.exit": "Exit tutorial",
      "tutorial.restart": "Restart",
      "tutorial.chapters": "Chapters",
      "tutorial.keyboardHint": "Use Left/Right to change steps and Esc to exit.",
      "tutorial.safeMode": "Guided view: workspaces and demos open automatically, but highlighted controls are never activated.",
      "tutorial.targetUnavailable": "This control is not visible in the current layout. You can continue safely.",
      "tutorial.finishWorkspace": "Finish or close the active editor before starting the tutorial.",
      "tutorial.helpTitle": "Open the guided tutorial",
      "tutorial.languageLabel": "Tutorial language",

      "tutorial.chapter.orientation": "Getting oriented",
      "tutorial.chapter.library": "Your content libraries",
      "tutorial.chapter.liveTools": "Live direction tools",
      "tutorial.chapter.camera": "Cinematic camera",
      "tutorial.chapter.customScenes": "Custom Scene workflow",
      "tutorial.chapter.timeline": "Timeline editing",
      "tutorial.chapter.authoring": "Advanced authoring layers",
      "tutorial.chapter.workflow": "Safe workflow and controls",
      "tutorial.chapter.finish": "Ready to direct",

      "tutorial.step.welcome.title": "Welcome to Spectrem Director",
      "tutorial.step.welcome.body": "This guided tour explains the complete creator workflow. It can open visual demonstrations automatically, but it will not play, spawn, record, delete, save, or change anything in your world.",
      "tutorial.step.header.title": "Your Director workspace",
      "tutorial.step.header.body": "The header keeps the Director identity, language, catalog status, and main session information in one stable place. The panel stays available while you move between tools.",
      "tutorial.step.language.title": "Choose the interface language",
      "tutorial.step.language.body": "Use this selector to change the current interface immediately. Config.Language defines the language loaded when the resource starts; English remains the safe default.",
      "tutorial.step.navigation.title": "One map for every tool",
      "tutorial.step.navigation.body": "The navigation grid groups libraries, live world controls, and production editors. The highlighted tab shows where you are; returning here never erases saved work.",

      "tutorial.step.scenes.title": "Browse synchronized scenes",
      "tutorial.step.scenes.body": "Scenes contains the synchronized scene catalog. Search or open a category, choose a scene, assign its actors, place it in the world, preview it, and then reuse it in a Custom Scene.",
      "tutorial.step.favorites.title": "Keep frequent scenes close",
      "tutorial.step.favorites.body": "Star any scene to place it in Scenes Fav. Favorites are a fast personal library and do not duplicate or modify the original scene definition.",
      "tutorial.step.peds.title": "Build a reusable cast",
      "tutorial.step.peds.body": "My Peds stores appearances in folders. Create, edit, clone, rename, spawn, or become a saved ped, then reuse that cast in scenes, animations, environments, replays, and chases.",
      "tutorial.step.vehicles.title": "Save production-ready vehicles",
      "tutorial.step.vehicles.body": "My Vehicles captures a streamed vehicle and its tuning, colors, extras, lights, damage, and other visual state. Saved presets can be spawned or used to replace vehicles in replay and Chase workflows.",
      "tutorial.step.animations.title": "Find and place animations",
      "tutorial.step.animations.body": "Animations provides search, favorites, playback type, loop, and Ground/Fly placement filters. Choose the actor, verify the preview, and place or play the animation at the corrected world height.",
      "tutorial.step.customAnimations.title": "Use server-specific animations",
      "tutorial.step.customAnimations.body": "Custom Anims lists dictionaries and clips supplied by your configuration or animation-menu bridge. They use the same actor selection, placement, loop, and scene-integration workflow as the main catalog.",

      "tutorial.step.chase.title": "Direct a cinematic chase",
      "tutorial.step.chase.body": "Chase starts with safe police defaults, then lets you customize units, vehicles, drivers, passengers, sirens, air support, behavior, protection, and on-foot weapons. Chase Replay records synchronized vehicle trajectories without the exit-and-shoot behavior.",
      "tutorial.step.density.title": "Control background traffic",
      "tutorial.step.density.body": "Density adjusts local pedestrians, moving vehicles, parked vehicles, random traffic, and scenarios. Lower values clear a controlled set; higher values create a busier background without editing your saved scenes.",
      "tutorial.step.weather.title": "Shape weather and time",
      "tutorial.step.weather.body": "Weather & Time controls weather, clock, time speed, freeze, blackout, rain, wind, and city lights. Choose local overrides for a private setup or the configured server bridge when the whole server should follow.",
      "tutorial.step.environment.title": "Stage background NPCs",
      "tutorial.step.environment.body": "Environment creates reusable NPC groups with formations, source models or saved-ped folders, quantity, spacing, extent, gender, animation, and facing direction. Save multiple environments and add the exact snapshot to a scene or Timeline.",
      "tutorial.step.effects.title": "Place and animate effects",
      "tutorial.step.effects.body": "Effects searches particle assets and previews scale, alpha, color, and loop state live. Keep an effect at a world position or attach it to a compatible actor, then schedule it precisely in Custom Scenes or Timeline.",
      "tutorial.step.clubs.title": "Manage interiors and club presets",
      "tutorial.step.clubs.body": "Clubs stores cinematic interior presets, coordinates, and IPL/interior state. Use teleport to inspect a setup, then save, update, or delete the preset when its world configuration is correct.",
      "tutorial.step.spooner.title": "Spawn and arrange world entities",
      "tutorial.step.spooner.body": "Object Spooner searches peds, props, and vehicles and places them through Freecam and the native gizmo. Select one or many entities to transform, clone, attach, organize, or send them into another Director workflow.",
      "tutorial.step.camera.title": "Meet the cinematic Camera workspace",
      "tutorial.step.camera.body": "The tutorial opens this protected visual workspace without starting Freecam or changing the world. In normal use, Camera can open from its main tab, a Camera entry inside Custom Scene, or a Camera clip in Timeline. H hides or restores the panel while the camera controls remain available; exiting returns to the tool that opened it.",
      "tutorial.step.cameraCapture.title": "Capture and revise exact camera poses",
      "tutorial.step.cameraCapture.body": "Name the sequence at the top. Capture (L) adds position, rotation, FOV, and image settings as a new keyframe; at the end of a standalone sequence it uses the configured Append interval, while a linked clip follows its playhead. Save frame overwrites only the selected keyframe after you move the camera. Duplicate inserts a copy between it and the next keyframe, or after the configured interval at the end; the trash button deletes the selected keyframe.",
      "tutorial.step.cameraRecording.title": "Record a live camera move",
      "tutorial.step.cameraRecording.body": "Record starts a countdown and converts the camera movement you perform live into keyframes. REC: Replace clears the previous take; REC: Append preserves it and records a new pass after its last keyframe. With CLIP SYNC, linked clips play while you film. Outside recording, F7 plays or pauses; during the countdown or live recording, F7 stops that operation. F8 stops and rewinds the sequence to its start.",
      "tutorial.step.cameraKeyframes.title": "Scrub and edit individual keyframes",
      "tutorial.step.cameraKeyframes.body": "Drag the scrubber to inspect an exact time and click a diamond, the keyframe selector, or its arrows to choose a frame. TIME changes its timestamp. EASING controls how speed enters or leaves the frame; PATH chooses a curved Spline or a direct Linear segment; FOV stores a lens angle per keyframe. Move the camera, then use Save frame to commit the new pose.",
      "tutorial.step.cameraTiming.title": "Control timing, pacing, and the full path",
      "tutorial.step.cameraTiming.body": "SPEED scales preview playback and is locked when a Timeline clip supplies CLIP SYNC. PACING Natural follows authored keyframe times, Per segment keeps constant speed inside each segment, and Continuous meters speed across the whole route. Loop repeats playback; Close loop snaps a nearby final frame to the first or appends an exact copy when needed; Distribute spaces middle keyframes evenly; Path shows or hides the route in the world.",
      "tutorial.step.cameraAttachments.title": "Choose what the camera follows",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) keeps the lens aimed at the player. After H hides the panel, Free look (N) rotates with the mouse without holding RMB. Attach to entity lists replay vehicles, scene actors, and nearby entities; Refresh rescans them. For peds choose the entity root, a body bone, or a held weapon; for vehicles choose a vehicle bone. Attach and Detach apply or remove the link. With the panel hidden, Target pointer shows the aimed entity and LMB can attach it even when the pointer is disabled.",
      "tutorial.step.cameraAttachmentMotion.title": "Choose how an attachment moves",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount rotates with the subject like a hood camera. Lock framing preserves the exact relative position and rotation through turns and banking. With Rigid off, Follow softness adds operator-like trailing instead of a bolted connection. Auto orbit starts from the framing already composed: W/S changes distance, Q/E changes height, and A/D changes orbit speed. The three sliders set those values precisely; a negative speed reverses direction.",
      "tutorial.step.cameraMovement.title": "Tune movement and operator response",
      "tutorial.step.cameraMovement.body": "Sensitivity controls look input and Zoom response controls lens input. Rotation smoothing eases the camera toward the angle already requested; Mouse smoothing filters raw mouse flicks; Movement smoothing eases translation in and out. Base speed sets normal flight speed—hold Shift for fast movement or Ctrl/Alt for precision. Lens cycles focal presets and FOV; RMB rotates, Z/C zooms, Left/Right controls roll, and the wheel changes Base speed.",
      "tutorial.step.cameraFlight.title": "Select the right flight behavior",
      "tutorial.step.cameraFlight.body": "Drone mode turns input into momentum, so the camera glides and banks instead of stopping immediately. Walk mode holds the lens near eye height over the ground for operator-style walking shots. World collision prevents the camera from crossing walls and solid geometry. In normal flight, WASD moves or strafes and Q/E changes height; while orbiting those same controls become dolly, spin, and crane controls.",
      "tutorial.step.cameraImage.title": "Set filters, focus, and camera shake",
      "tutorial.step.cameraImage.body": "Effects cycles the visual filter and Intensity blends its strength. Depth of field must be enabled before its controls affect the image. Autofocus continuously focuses what the lens sees; Follow focus keeps an attached subject sharp; manual Distance is available when Autofocus is off, and DOF Intensity controls blur strength. Camera shake enables a selectable shake preset, while Shake strength sets its amplitude.",
      "tutorial.step.cameraScene.title": "Prepare a clean, composed scene",
      "tutorial.step.cameraScene.body": "Allow player movement returns WASD to the ped or vehicle while smart follow preserves the framing; turn it off when you need to fly or rotate the camera again. Look at camera turns the player's head toward the lens. Cinematic bars adds a selectable aspect ratio; Hide game HUD and Hide notifications clean the frame. Rule of thirds, Center cross, Safe area, and Info overlay are authoring guides with adjustable intensity: they stay visible when H hides the panel and disappear during playback.",
      "tutorial.step.cameraOutput.title": "Preview, capture, reset, and return",
      "tutorial.step.cameraOutput.body": "Video starts or stops a Rockstar Editor recording. Play/Pause previews the sequence and Stop returns it to the beginning. The footer shows live speed and FOV: G toggles gaze anchoring, Level removes roll without changing pitch or heading, R resets the camera, H hides the panel, and ESC exits. A camera opened from Custom Scene or Timeline returns there—save that parent scene or project; standalone sequences are temporary.",

      "tutorial.step.customScenes.title": "Start a Custom Scene",
      "tutorial.step.customScenes.body": "Custom Scenes opens automatically for this demonstration. In normal use, choose New Custom Scene, name the composition, and open its editor. A Custom Scene combines independent entries without modifying the original libraries.",
      "tutorial.step.customSceneEditor.title": "Understand the scene editor",
      "tutorial.step.customSceneEditor.body": "The header names the composition and provides Scene Tools, Save, and Close. Scene Tools organizes layers, collections, visibility, and attachments; Save stores the composition after its entries and timing are ready.",
      "tutorial.step.customSceneEntries.title": "Read and time every entry",
      "tutorial.step.customSceneEntries.body": "Each card identifies its type, source, and world placement. Use its edit, actor, prop, or attachment actions when available. Delay decides when the entry starts; presets are quick choices and Custom accepts an exact value.",
      "tutorial.step.customSceneAdd.title": "Add the building blocks",
      "tutorial.step.customSceneAdd.body": "Add Camera, Animation, synchronized Scene, Vehicle or Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment, or Combat Ped. Each button opens the matching picker or specialized editor, then returns the configured entry here.",
      "tutorial.step.sceneTools.title": "Organize complex scenes",
      "tutorial.step.sceneTools.body": "Scene Tools is the outliner for Custom Scenes. Use stable entries, layers, collections, visibility, selection, attachments, transforms, and validation to keep a large composition understandable and editable.",
      "tutorial.step.customScenePlayback.title": "Test before recording",
      "tutorial.step.customScenePlayback.body": "TEST previews the complete composition without making a take. ACTION runs the countdown and records to Rockstar Editor; Attach records while riding a chosen scene entity and Nearby shares compatible playback. Stop the preview, correct entries, then Save.",
      "tutorial.step.timeline.title": "Open the Timeline workspace",
      "tutorial.step.timeline.body": "Timeline opens automatically without loading or changing a project. In normal use, create or load a project, give it a name, and save its structure. Timeline combines many timed clips across automatic tracks.",
      "tutorial.step.timelineLibrary.title": "Choose what to place",
      "tutorial.step.timelineLibrary.body": "The library groups cameras, favorites, scenes, animations, effects, replays, and specialized entries. Search first, then double-click an option to add it at the playhead or drag it to the exact time; the required track is created automatically.",
      "tutorial.step.timelineTracks.title": "Arrange clips on automatic tracks",
      "tutorial.step.timelineTracks.body": "Tracks appear when clips are added. Move or resize clips to set start and duration, use the playhead and zoom for precision, and open track settings to rename, reorder, resize, solo, mute, or lock a track.",
      "tutorial.step.timelineInspector.title": "Edit the selected clip",
      "tutorial.step.timelineInspector.body": "Selecting a clip opens its inspector in the stage area. Set exact IN, OUT, duration, source offset, looping, and transitions, then use Place, Props, actor settings, keyframes, or its nested editor when the clip type supports them.",
      "tutorial.step.timelinePlayback.title": "Preview and record the edit",
      "tutorial.step.timelinePlayback.body": "Play from starts at the current playhead; TEST previews the complete Timeline from the beginning. START plays from the beginning with the UI hidden, without a countdown or recording; Backspace stops playback and returns to Timeline. ACTION runs the countdown and records the synchronized result. Nearby synchronizes compatible clips with nearby players. Resolve diagnostics and save before the final take.",
      "tutorial.step.replays.title": "Reuse recorded performances",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle, and Chase Replay capture different kinds of movement and action. Record a clean take, stop and let it finish processing, save it, then reference that source from Custom Scenes or Timeline.",
      "tutorial.step.advancedLayers.title": "Open specialized authoring layers",
      "tutorial.step.advancedLayers.body": "Advanced entries include Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment, and attachments. Each editor keeps its own preview and returns the result to the scene or Timeline that opened it.",

      "tutorial.step.catalog.title": "Search before you build",
      "tutorial.step.catalog.body": "Catalog panels use search, categories, filters, folders, favorites, and result counts. Narrow the list first, inspect the selected card, and only then open placement or playback so the world stays clean.",
      "tutorial.step.safeWorkflow.title": "Preview, verify, then save",
      "tutorial.step.safeWorkflow.body": "Most authoring changes are temporary until you confirm or save. Use Preview or TEST, finish any Freecam/gizmo session, check timing and targets, then save; Esc or Backspace returns safely from the active layer.",
      "tutorial.step.recording.title": "Understand the REC indicator",
      "tutorial.step.recording.body": "The footer shows Rockstar recording state and the global close hint. ACTION workflows prepare referenced assets, run their countdown, and record the synchronized result; do not close the resource while a take is being finalized.",
      "tutorial.step.cutscenes.title": "Cutscene Player is a separate workspace",
      "tutorial.step.cutscenes.body": "Press F6 or use /cutscenes to browse GTA cutscenes, favorites, new optional catalogs, actor overrides, audio, HUD, fades, and spectator options. It stays separate from the main Director panel to protect the active setup.",
      "tutorial.step.shortcuts.title": "Master the shared controls",
      "tutorial.step.shortcuts.body": "F5 opens Director. In authoring Freecam hold RMB and use WASD with Q/E, Shift, Ctrl, and the wheel. In the gizmo use W/R, Tab, Alt, G, Enter, and Backspace; each specialized editor also shows its own live HUD.",

      "tutorial.step.finish.title": "You are ready to direct",
      "tutorial.step.finish.body": "Start with one actor or scene, preview every layer, and grow the production only after each part works. Run /tutorial whenever you want this guided tour again; finishing leaves Director open so you can practice immediately."
    },

    es: {
      "tutorial.title": "Tutorial interactivo de Director",
      "tutorial.progress": "Paso {{current}} de {{total}}",
      "tutorial.previous": "Anterior",
      "tutorial.next": "Siguiente",
      "tutorial.finish": "Finalizar tutorial",
      "tutorial.exit": "Salir del tutorial",
      "tutorial.restart": "Reiniciar",
      "tutorial.chapters": "Capítulos",
      "tutorial.keyboardHint": "Usa Izquierda/Derecha para cambiar de paso y Esc para salir.",
      "tutorial.safeMode": "Vista guiada: los espacios y demostraciones se abren automáticamente, pero los controles señalados nunca se activan.",
      "tutorial.targetUnavailable": "Este control no está visible en la disposición actual. Puedes continuar de forma segura.",
      "tutorial.finishWorkspace": "Finaliza o cierra el editor activo antes de iniciar el tutorial.",
      "tutorial.helpTitle": "Abrir el tutorial guiado",
      "tutorial.languageLabel": "Idioma del tutorial",

      "tutorial.chapter.orientation": "Orientación inicial",
      "tutorial.chapter.library": "Tus bibliotecas de contenido",
      "tutorial.chapter.liveTools": "Herramientas de dirección en vivo",
      "tutorial.chapter.camera": "Cámara cinematográfica",
      "tutorial.chapter.customScenes": "Flujo de Custom Scenes",
      "tutorial.chapter.timeline": "Edición en Timeline",
      "tutorial.chapter.authoring": "Capas avanzadas de autoría",
      "tutorial.chapter.workflow": "Flujo seguro y controles",
      "tutorial.chapter.finish": "Listo para dirigir",

      "tutorial.step.welcome.title": "Bienvenido a Spectrem Director",
      "tutorial.step.welcome.body": "Este recorrido guiado explica el flujo completo de creación. Puede abrir demostraciones visuales automáticamente, pero no reproducirá, generará, grabará, eliminará, guardará ni cambiará nada en tu mundo.",
      "tutorial.step.header.title": "Tu espacio de Director",
      "tutorial.step.header.body": "El encabezado reúne la identidad de Director, el idioma, el estado del catálogo y la información principal de la sesión. El panel se mantiene estable mientras cambias de herramienta.",
      "tutorial.step.language.title": "Elige el idioma de la interfaz",
      "tutorial.step.language.body": "Usa este selector para cambiar la interfaz actual de inmediato. Config.Language define el idioma cargado al iniciar el recurso; el inglés sigue siendo el valor predeterminado seguro.",
      "tutorial.step.navigation.title": "Un mapa para todas las herramientas",
      "tutorial.step.navigation.body": "La cuadrícula de navegación agrupa bibliotecas, controles del mundo y editores de producción. La pestaña resaltada indica dónde estás; volver aquí nunca borra el trabajo guardado.",

      "tutorial.step.scenes.title": "Explora escenas sincronizadas",
      "tutorial.step.scenes.body": "Scenes contiene el catálogo de escenas sincronizadas. Busca o abre una categoría, elige una escena, asigna sus actores, colócala en el mundo, previsualízala y luego reutilízala en una Custom Scene.",
      "tutorial.step.favorites.title": "Mantén cerca tus escenas frecuentes",
      "tutorial.step.favorites.body": "Marca una escena con la estrella para llevarla a Scenes Fav. Los favoritos son una biblioteca personal rápida y no duplican ni modifican la definición original.",
      "tutorial.step.peds.title": "Crea un reparto reutilizable",
      "tutorial.step.peds.body": "My Peds guarda apariencias en carpetas. Crea, edita, clona, renombra, genera o conviértete en un ped guardado y reutiliza ese reparto en escenas, animaciones, entornos, replays y persecuciones.",
      "tutorial.step.vehicles.title": "Guarda vehículos listos para producción",
      "tutorial.step.vehicles.body": "My Vehicles captura un vehículo cargado con su tuning, colores, extras, luces, daños y estado visual. Los presets se pueden generar o usar para reemplazar vehículos en replays y persecuciones.",
      "tutorial.step.animations.title": "Encuentra y coloca animaciones",
      "tutorial.step.animations.body": "Animations ofrece búsqueda, favoritos, tipo de reproducción, loop y filtros Ground/Fly. Elige al actor, verifica la vista previa y coloca o reproduce la animación con la altura mundial corregida.",
      "tutorial.step.customAnimations.title": "Usa animaciones propias del servidor",
      "tutorial.step.customAnimations.body": "Custom Anims muestra diccionarios y clips aportados por la configuración o el puente de animaciones. Usa el mismo flujo de actor, colocación, loop e integración en escenas que el catálogo principal.",

      "tutorial.step.chase.title": "Dirige una persecución cinematográfica",
      "tutorial.step.chase.body": "Chase parte con valores policiales seguros y permite personalizar unidades, vehículos, conductores, pasajeros, sirenas, apoyo aéreo, conducta, protección y armas al bajar. Chase Replay graba trayectorias sincronizadas sin la respuesta de bajar y disparar.",
      "tutorial.step.density.title": "Controla el tráfico de fondo",
      "tutorial.step.density.body": "Density ajusta peatones, vehículos en movimiento, estacionados, tráfico aleatorio y escenarios locales. Los valores bajos limpian el set y los altos crean un fondo más activo sin editar tus escenas guardadas.",
      "tutorial.step.weather.title": "Define el clima y la hora",
      "tutorial.step.weather.body": "Weather & Time controla clima, reloj, velocidad del tiempo, congelación, apagón, lluvia, viento y luces urbanas. Usa overrides locales para un set privado o el puente configurado cuando deba aplicarse a todo el servidor.",
      "tutorial.step.environment.title": "Organiza NPCs de ambiente",
      "tutorial.step.environment.body": "Environment crea grupos reutilizables con formaciones, modelos o carpetas de peds, cantidad, separación, extensión, género, animación y dirección de mirada. Guarda varios entornos y añade su snapshot exacto a una escena o Timeline.",
      "tutorial.step.effects.title": "Coloca y anima efectos",
      "tutorial.step.effects.body": "Effects busca partículas y previsualiza escala, alfa, color y loop en vivo. Deja el efecto en una posición mundial o adjúntalo a un actor compatible y prográmalo con precisión en Custom Scenes o Timeline.",
      "tutorial.step.clubs.title": "Gestiona interiores y presets de club",
      "tutorial.step.clubs.body": "Clubs guarda presets de interiores cinematográficos, coordenadas y estado IPL/interior. Teletranspórtate para revisar el set y guarda, actualiza o elimina el preset cuando la configuración sea correcta.",
      "tutorial.step.spooner.title": "Genera y ordena entidades del mundo",
      "tutorial.step.spooner.body": "Object Spooner busca peds, props y vehículos y los coloca con Freecam y gizmo nativo. Selecciona una o varias entidades para transformar, clonar, adjuntar, organizar o enviarlas a otro flujo de Director.",
      "tutorial.step.camera.title": "Conoce el espacio de Camera cinematográfica",
      "tutorial.step.camera.body": "El tutorial abre este espacio visual protegido sin iniciar Freecam ni modificar el mundo. En el uso normal, Camera puede abrirse desde su pestaña principal, una entrada Camera de Custom Scene o un clip Camera de Timeline. H oculta o restaura el panel sin desactivar los controles de cámara; al salir vuelves a la herramienta que la abrió.",
      "tutorial.step.cameraCapture.title": "Captura y corrige poses exactas de cámara",
      "tutorial.step.cameraCapture.body": "Asigna un nombre a la secuencia arriba. Capture (L) añade posición, rotación, FOV y ajustes de imagen como un keyframe nuevo; al final de una secuencia independiente usa el intervalo Append configurado y en un clip vinculado respeta su playhead. Save frame sobrescribe únicamente el keyframe seleccionado después de mover la cámara. Duplicate coloca una copia entre este y el siguiente, o después del intervalo configurado si es el último; la papelera elimina el keyframe seleccionado.",
      "tutorial.step.cameraRecording.title": "Graba un movimiento de cámara en vivo",
      "tutorial.step.cameraRecording.body": "Record inicia una cuenta regresiva y convierte el movimiento que hagas en vivo en keyframes. REC: Replace borra la toma anterior; REC: Append la conserva y graba una pasada nueva después de su último keyframe. Con CLIP SYNC, los clips vinculados se reproducen mientras filmas. Fuera de la grabación, F7 reproduce o pausa; durante la cuenta o la grabación en vivo, F7 detiene esa operación. F8 detiene y rebobina la secuencia al inicio.",
      "tutorial.step.cameraKeyframes.title": "Recorre y edita cada keyframe",
      "tutorial.step.cameraKeyframes.body": "Arrastra el scrubber para inspeccionar un instante exacto y pulsa un diamante, el selector de keyframes o sus flechas para elegir un cuadro. TIME cambia su marca temporal. EASING define cómo entra o sale la velocidad; PATH elige un tramo curvo Spline o directo Linear; FOV guarda un ángulo de lente por keyframe. Mueve la cámara y después usa Save frame para confirmar la pose.",
      "tutorial.step.cameraTiming.title": "Controla tiempo, ritmo y trayectoria completa",
      "tutorial.step.cameraTiming.body": "SPEED escala la reproducción de la vista previa y queda bloqueado cuando un clip de Timeline aporta CLIP SYNC. PACING Natural respeta los tiempos de cada keyframe, Per segment mantiene velocidad constante en cada tramo y Continuous mide una velocidad uniforme en toda la ruta. Loop repite; Close loop ajusta al primero un último cuadro que ya esté cerca o añade una copia exacta cuando hace falta; Distribute separa uniformemente los keyframes intermedios; Path muestra u oculta la ruta en el mundo.",
      "tutorial.step.cameraAttachments.title": "Elige qué debe seguir la cámara",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) mantiene la lente apuntando al jugador. Después de ocultar el panel con H, Free look (N) permite girar con el mouse sin sostener RMB. Attach to entity lista vehículos de replay, actores de escena y entidades cercanas; Refresh vuelve a detectarlos. Para un ped elige raíz, hueso corporal o arma sostenida; para un vehículo elige un hueso del vehículo. Attach y Detach aplican o quitan el vínculo. Con el panel oculto, Target pointer marca la entidad apuntada y LMB puede adjuntarla incluso con el puntero desactivado.",
      "tutorial.step.cameraAttachmentMotion.title": "Define cómo se mueve un adjunto",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount gira con el sujeto como una cámara de capó. Lock framing conserva exactamente la posición y rotación relativas durante giros e inclinaciones. Con Rigid desactivado, Follow softness añade un retraso de operador en vez de una unión rígida. Auto orbit parte del encuadre ya compuesto: W/S cambia distancia, Q/E cambia altura y A/D cambia velocidad orbital. Los tres deslizadores permiten valores exactos; una velocidad negativa invierte la dirección.",
      "tutorial.step.cameraMovement.title": "Ajusta el movimiento y la respuesta del operador",
      "tutorial.step.cameraMovement.body": "Sensitivity controla la mirada y Zoom response la entrada de lente. Rotation smoothing acerca suavemente la cámara al ángulo solicitado; Mouse smoothing filtra los movimientos bruscos del mouse; Movement smoothing suaviza la traslación al arrancar y detenerse. Base speed fija la velocidad normal: mantén Shift para ir rápido o Ctrl/Alt para precisión. Lens recorre presets focales y FOV; RMB rota, Z/C hacen zoom, Izquierda/Derecha controlan el roll y la rueda cambia Base speed.",
      "tutorial.step.cameraFlight.title": "Selecciona el comportamiento de vuelo correcto",
      "tutorial.step.cameraFlight.body": "Drone mode convierte la entrada en impulso para que la cámara se deslice e incline en lugar de detenerse de inmediato. Walk mode mantiene la lente a altura de los ojos sobre el suelo para tomas de operador. World collision evita atravesar paredes y geometría sólida. En vuelo normal, WASD mueve o desplaza lateralmente y Q/E cambia la altura; durante una órbita esos controles pasan a dolly, giro y grúa.",
      "tutorial.step.cameraImage.title": "Configura filtros, foco y vibración",
      "tutorial.step.cameraImage.body": "Effects recorre los filtros visuales e Intensity mezcla su fuerza. Depth of field debe activarse para afectar la imagen. Autofocus enfoca continuamente lo que ve la lente; Follow focus mantiene nítido un sujeto adjunto; Distance manual está disponible con Autofocus apagado y la intensidad de DOF controla el desenfoque. Camera shake habilita un preset de vibración seleccionable y Shake strength define su amplitud.",
      "tutorial.step.cameraScene.title": "Prepara una escena limpia y bien encuadrada",
      "tutorial.step.cameraScene.body": "Allow player movement devuelve WASD al ped o vehículo mientras el seguimiento inteligente conserva el encuadre; desactívalo cuando necesites volver a volar o girar la cámara. Look at camera orienta la cabeza del jugador hacia la lente. Cinematic bars añade una relación de aspecto seleccionable; Hide game HUD y Hide notifications limpian el cuadro. Rule of thirds, Center cross, Safe area e Info overlay son guías con intensidad ajustable: permanecen con H y desaparecen durante la reproducción.",
      "tutorial.step.cameraOutput.title": "Previsualiza, captura, reinicia y vuelve",
      "tutorial.step.cameraOutput.body": "Video inicia o detiene una grabación para Rockstar Editor. Play/Pause previsualiza la secuencia y Stop vuelve al inicio. El pie muestra velocidad y FOV en vivo: G alterna el anclaje de mirada, Level elimina el roll sin cambiar pitch ni heading, R reinicia la cámara, H oculta el panel y ESC sale. Si Camera se abrió desde Custom Scene o Timeline vuelve allí: guarda esa escena o proyecto padre; las secuencias independientes son temporales.",

      "tutorial.step.customScenes.title": "Comienza una Custom Scene",
      "tutorial.step.customScenes.body": "Custom Scenes se abre automáticamente para esta demostración. En el uso normal, elige New Custom Scene, nombra la composición y abre su editor. Una Custom Scene combina entradas independientes sin modificar las bibliotecas originales.",
      "tutorial.step.customSceneEditor.title": "Comprende el editor de escena",
      "tutorial.step.customSceneEditor.body": "El encabezado muestra el nombre y ofrece Scene Tools, Save y Close. Scene Tools organiza capas, colecciones, visibilidad y adjuntos; Save almacena la composición cuando sus entradas y tiempos están listos.",
      "tutorial.step.customSceneEntries.title": "Lee y programa cada entrada",
      "tutorial.step.customSceneEntries.body": "Cada tarjeta identifica tipo, fuente y posición mundial. Usa sus acciones de edición, actor, prop o adjunto cuando estén disponibles. Delay decide cuándo comienza; los presets son opciones rápidas y Custom acepta un valor exacto.",
      "tutorial.step.customSceneAdd.title": "Agrega los componentes",
      "tutorial.step.customSceneAdd.body": "Agrega Camera, Animation, Scene sincronizada, Vehicle o Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment o Combat Ped. Cada botón abre el selector o editor correspondiente y devuelve aquí la entrada configurada.",
      "tutorial.step.sceneTools.title": "Organiza escenas complejas",
      "tutorial.step.sceneTools.body": "Scene Tools es el outliner de Custom Scenes. Usa entradas estables, capas, colecciones, visibilidad, selección, adjuntos, transformaciones y validación para mantener comprensible una composición grande.",
      "tutorial.step.customScenePlayback.title": "Prueba antes de grabar",
      "tutorial.step.customScenePlayback.body": "TEST previsualiza la composición completa sin crear una toma. ACTION ejecuta la cuenta regresiva y graba en Rockstar Editor; Attach graba viajando con una entidad elegida y Nearby comparte playback compatible. Detén el preview, corrige las entradas y luego guarda.",
      "tutorial.step.timeline.title": "Abre el espacio de Timeline",
      "tutorial.step.timeline.body": "Timeline se abre automáticamente sin cargar ni modificar un proyecto. En el uso normal, crea o carga un proyecto, dale un nombre y guarda su estructura. Timeline combina muchos clips temporizados en pistas automáticas.",
      "tutorial.step.timelineLibrary.title": "Elige qué colocar",
      "tutorial.step.timelineLibrary.body": "La biblioteca agrupa cámaras, favoritos, escenas, animaciones, efectos, replays y entradas especializadas. Busca primero; luego haz doble clic para añadir en el playhead o arrastra al tiempo exacto. La pista necesaria se crea automáticamente.",
      "tutorial.step.timelineTracks.title": "Ordena clips en pistas automáticas",
      "tutorial.step.timelineTracks.body": "Las pistas aparecen al agregar clips. Mueve o redimensiona clips para definir inicio y duración, usa el playhead y zoom para precisión y abre ajustes de pista para renombrar, ordenar, cambiar tamaño, dejar solo, silenciar o bloquear.",
      "tutorial.step.timelineInspector.title": "Edita el clip seleccionado",
      "tutorial.step.timelineInspector.body": "Seleccionar un clip abre su inspector en el área central. Define IN, OUT, duración, offset de fuente, loop y transiciones exactos; luego usa Place, Props, ajustes de actor, keyframes o el editor anidado cuando el tipo lo permita.",
      "tutorial.step.timelinePlayback.title": "Previsualiza y graba la edición",
      "tutorial.step.timelinePlayback.body": "Play from comienza en el playhead actual y TEST previsualiza Timeline completo desde el inicio. START reproduce desde el inicio con la interfaz oculta, sin cuenta regresiva ni grabación; Retroceso detiene la reproducción y vuelve al Timeline. ACTION ejecuta la cuenta regresiva y graba el resultado sincronizado. Nearby sincroniza clips compatibles con jugadores cercanos. Resuelve los diagnósticos y guarda antes de la toma final.",
      "tutorial.step.replays.title": "Reutiliza actuaciones grabadas",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle y Chase Replay capturan distintos movimientos y acciones. Graba una toma limpia, detén y espera su procesamiento, guárdala y referencia esa fuente desde Custom Scenes o Timeline.",
      "tutorial.step.advancedLayers.title": "Abre capas de autoría especializadas",
      "tutorial.step.advancedLayers.body": "Las entradas avanzadas incluyen Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment y adjuntos. Cada editor conserva su preview y devuelve el resultado a la escena o Timeline que lo abrió.",

      "tutorial.step.catalog.title": "Busca antes de construir",
      "tutorial.step.catalog.body": "Los catálogos usan búsqueda, categorías, filtros, carpetas, favoritos y conteos. Reduce primero la lista, revisa la tarjeta seleccionada y recién entonces abre colocación o reproducción para mantener limpio el mundo.",
      "tutorial.step.safeWorkflow.title": "Previsualiza, verifica y guarda",
      "tutorial.step.safeWorkflow.body": "La mayoría de los cambios de autoría son temporales hasta confirmar o guardar. Usa Preview o TEST, termina Freecam/gizmo, revisa tiempos y objetivos y guarda; Esc o Backspace vuelve de forma segura desde la capa activa.",
      "tutorial.step.recording.title": "Comprende el indicador REC",
      "tutorial.step.recording.body": "El pie muestra el estado de grabación Rockstar y la ayuda de cierre. ACTION prepara recursos referenciados, ejecuta la cuenta regresiva y graba el resultado sincronizado; no cierres el recurso mientras finaliza una toma.",
      "tutorial.step.cutscenes.title": "Cutscene Player es un espacio separado",
      "tutorial.step.cutscenes.body": "Pulsa F6 o usa /cutscenes para explorar cinemáticas GTA, favoritos, catálogos opcionales nuevos, reemplazos de actores, audio, HUD, fundidos y espectador. Se mantiene separado para proteger la configuración activa.",
      "tutorial.step.shortcuts.title": "Domina los controles compartidos",
      "tutorial.step.shortcuts.body": "F5 abre Director. En Freecam mantén RMB y usa WASD con Q/E, Shift, Ctrl y la rueda. En el gizmo usa W/R, Tab, Alt, G, Enter y Backspace; cada editor especializado muestra además su propio HUD.",

      "tutorial.step.finish.title": "Ya estás listo para dirigir",
      "tutorial.step.finish.body": "Comienza con un actor o una escena, previsualiza cada capa y amplía la producción solo cuando cada parte funcione. Ejecuta /tutorial cuando quieras repetir la guía; al terminar, Director queda abierto para practicar."
    },

    tr: {
      "tutorial.title": "Etkileşimli Director eğitimi",
      "tutorial.progress": "{{total}} adımdan {{current}}.",
      "tutorial.previous": "Önceki",
      "tutorial.next": "Sonraki",
      "tutorial.finish": "Eğitimi bitir",
      "tutorial.exit": "Eğitimden çık",
      "tutorial.restart": "Yeniden başlat",
      "tutorial.chapters": "Bölümler",
      "tutorial.keyboardHint": "Adımlar arasında geçiş yapmak için Sol/Sağ, çıkmak için Esc tuşunu kullanın.",
      "tutorial.safeMode": "Rehberli görünüm: çalışma alanları ve demolar otomatik olarak açılır, ancak vurgulanan kontroller hiçbir zaman etkinleştirilmez.",
      "tutorial.targetUnavailable": "Bu kontrol mevcut düzende görünmüyor. Güvenle devam edebilirsiniz.",
      "tutorial.finishWorkspace": "Eğitime başlamadan önce etkin düzenleyiciyi tamamlayın veya kapatın.",
      "tutorial.helpTitle": "Rehberli eğitimi aç",
      "tutorial.languageLabel": "Eğitim dili",

      "tutorial.chapter.orientation": "Başlangıç yönlendirmesi",
      "tutorial.chapter.library": "İçerik kitaplıklarınız",
      "tutorial.chapter.liveTools": "Canlı yönetim araçları",
      "tutorial.chapter.camera": "Sinematik kamera",
      "tutorial.chapter.customScenes": "Custom Scene iş akışı",
      "tutorial.chapter.timeline": "Timeline düzenleme",
      "tutorial.chapter.authoring": "Eksiksiz sahneler oluşturma",
      "tutorial.chapter.workflow": "Güvenli iş akışı ve kontroller",
      "tutorial.chapter.finish": "Yönetmeye hazırsınız",

      "tutorial.step.welcome.title": "Spectrem Director'a hoş geldiniz",
      "tutorial.step.welcome.body": "Bu rehberli tur, eksiksiz içerik oluşturma iş akışını açıklar. Görsel demoları otomatik olarak açabilir; ancak dünyanızda hiçbir şeyi oynatmaz, oluşturmaz, kaydetmez, silmez veya değiştirmez.",
      "tutorial.step.header.title": "Director çalışma alanınız",
      "tutorial.step.header.body": "Üst bilgi; Director kimliğini, dili, katalog durumunu ve ana oturum bilgilerini tek ve sabit bir yerde toplar. Araçlar arasında geçiş yaparken panel kullanılabilir durumda kalır.",
      "tutorial.step.language.title": "Arayüz dilini seçin",
      "tutorial.step.language.body": "Mevcut arayüz dilini anında değiştirmek için bu seçiciyi kullanın. Config.Language, kaynak başladığında yüklenecek dili belirler; İngilizce güvenli varsayılan dil olarak kalır.",
      "tutorial.step.navigation.title": "Tüm araçlar için tek bir harita",
      "tutorial.step.navigation.body": "Gezinme ızgarası; kitaplıkları, canlı dünya kontrollerini ve yapım düzenleyicilerini gruplandırır. Vurgulanan sekme bulunduğunuz yeri gösterir; buraya dönmek kaydedilmiş çalışmaları asla silmez.",

      "tutorial.step.scenes.title": "Senkronize sahnelere göz atın",
      "tutorial.step.scenes.body": "Scenes, senkronize sahne kataloğunu içerir. Bir kategori arayın veya açın; sahneyi seçin, oyuncularını atayın, dünyaya yerleştirin, önizleyin ve ardından bir Custom Scene içinde yeniden kullanın.",
      "tutorial.step.favorites.title": "Sık kullandığınız sahneleri elinizin altında tutun",
      "tutorial.step.favorites.body": "Herhangi bir sahneyi yıldızlayarak Scenes Fav bölümüne ekleyin. Favoriler hızlı bir kişisel kitaplıktır; özgün sahne tanımını çoğaltmaz veya değiştirmez.",
      "tutorial.step.peds.title": "Yeniden kullanılabilir bir oyuncu kadrosu oluşturun",
      "tutorial.step.peds.body": "My Peds, görünümleri klasörlerde saklar. Kaydedilmiş bir ped oluşturun, düzenleyin, kopyalayın, yeniden adlandırın, dünyaya çıkarın veya ona dönüşün; ardından bu kadroyu sahnelerde, animasyonlarda, ortamlarda, replay'lerde ve takiplerde yeniden kullanın.",
      "tutorial.step.vehicles.title": "Yapıma hazır araçları kaydedin",
      "tutorial.step.vehicles.body": "My Vehicles; yüklenmiş bir aracı modifiyesi, renkleri, ekstraları, ışıkları, hasarı ve diğer görsel durumlarıyla birlikte yakalar. Kaydedilen hazır ayarlar dünyaya çıkarılabilir veya replay ve Chase iş akışlarındaki araçların yerine kullanılabilir.",
      "tutorial.step.animations.title": "Animasyonları bulun ve yerleştirin",
      "tutorial.step.animations.body": "Animations; arama, favoriler, oynatma türü, döngü ve Ground/Fly yerleşim filtreleri sunar. Oyuncuyu seçin, önizlemeyi doğrulayın ve animasyonu düzeltilmiş dünya yüksekliğinde yerleştirin veya oynatın.",
      "tutorial.step.customAnimations.title": "Sunucuya özgü animasyonları kullanın",
      "tutorial.step.customAnimations.body": "Custom Anims, yapılandırmanız veya animasyon menüsü köprünüz tarafından sağlanan sözlükleri ve klipleri listeler. Ana katalogla aynı oyuncu seçimi, yerleşim, döngü ve sahne entegrasyonu iş akışını kullanır.",

      "tutorial.step.chase.title": "Sinematik bir takibi yönetin",
      "tutorial.step.chase.body": "Chase, güvenli polis varsayılanlarıyla başlar; ardından birimleri, araçları, sürücüleri, yolcuları, sirenleri, hava desteğini, davranışı, korumayı ve araçtan inildiğinde kullanılacak silahları özelleştirmenize olanak tanır. Chase Replay, araçtan inip ateş etme davranışı olmadan senkronize araç rotalarını kaydeder.",
      "tutorial.step.density.title": "Arka plan trafiğini yönetin",
      "tutorial.step.density.body": "Density; yerel yayaları, hareket eden araçları, park edilmiş araçları, rastgele trafiği ve senaryoları ayarlar. Düşük değerler kontrollü bir seti temizler, yüksek değerler ise kaydedilmiş sahnelerinizi düzenlemeden daha hareketli bir arka plan oluşturur.",
      "tutorial.step.weather.title": "Hava durumunu ve zamanı şekillendirin",
      "tutorial.step.weather.body": "Weather & Time; hava durumunu, saati, zaman hızını, dondurmayı, elektrik kesintisini, yağmuru, rüzgârı ve şehir ışıklarını yönetir. Özel bir kurulum için yerel geçersiz kılmaları, tüm sunucunun takip etmesi gerektiğinde ise yapılandırılmış sunucu köprüsünü seçin.",
      "tutorial.step.environment.title": "Arka plan NPC'lerini sahneleyin",
      "tutorial.step.environment.body": "Environment; formasyon, kaynak modeller veya kayıtlı ped klasörleri, sayı, aralık, yayılım, cinsiyet, animasyon ve bakış yönü içeren yeniden kullanılabilir NPC grupları oluşturur. Birden fazla ortam kaydedin ve tam anlık görüntüsünü bir sahneye veya Timeline'a ekleyin.",
      "tutorial.step.effects.title": "Efektleri yerleştirin ve canlandırın",
      "tutorial.step.effects.body": "Effects, parçacık varlıklarını arar ve ölçek, alfa, renk ile döngü durumunu canlı olarak önizler. Bir efekti dünya konumunda tutun veya uyumlu bir oyuncuya bağlayın; ardından Custom Scenes ya da Timeline içinde hassas biçimde zamanlayın.",
      "tutorial.step.clubs.title": "İç mekânları ve kulüp hazır ayarlarını yönetin",
      "tutorial.step.clubs.body": "Clubs; sinematik iç mekân hazır ayarlarını, koordinatları ve IPL/iç mekân durumunu saklar. Bir kurulumu incelemek için ışınlanmayı kullanın; dünya yapılandırması doğru olduğunda hazır ayarı kaydedin, güncelleyin veya silin.",
      "tutorial.step.spooner.title": "Dünya varlıklarını oluşturun ve düzenleyin",
      "tutorial.step.spooner.body": "Object Spooner; ped'leri, nesneleri ve araçları arar, ardından Freecam ve yerel gizmo ile yerleştirir. Dönüştürmek, kopyalamak, bağlamak, düzenlemek veya başka bir Director iş akışına göndermek için bir ya da birden çok varlık seçin.",
      "tutorial.step.camera.title": "Sinematik Camera çalışma alanını tanıyın",
      "tutorial.step.camera.body": "Eğitim, Freecam'i başlatmadan veya dünyayı değiştirmeden bu korumalı görsel çalışma alanını açar. Normal kullanımda Camera; ana sekmesinden, Custom Scene içindeki bir Camera girdisinden veya Timeline'daki bir Camera klibinden açılabilir. H paneli gizler ya da geri getirir, ancak kamera kontrolleri çalışmaya devam eder; çıkış sizi Camera'yı açan araca döndürür.",
      "tutorial.step.cameraCapture.title": "Kesin kamera pozlarını yakalayın ve düzeltin",
      "tutorial.step.cameraCapture.body": "Üstte sekansa bir ad verin. Capture (L) konum, dönüş, FOV ve görüntü ayarlarını yeni bir keyframe olarak ekler; bağımsız sekansın sonunda ayarlanmış Append aralığını kullanır, bağlı klipte ise playhead'i izler. Kamerayı taşıdıktan sonra Save frame yalnızca seçili keyframe'in üzerine yazar. Duplicate kopyayı bu keyframe ile sonraki arasına, sonda ise ayarlanmış aralığın sonrasına ekler; çöp kutusu seçili keyframe'i siler.",
      "tutorial.step.cameraRecording.title": "Canlı bir kamera hareketi kaydedin",
      "tutorial.step.cameraRecording.body": "Record geri sayım başlatır ve canlı yaptığınız kamera hareketini keyframe'lere dönüştürür. REC: Replace önceki çekimi temizler; REC: Append onu korur ve son keyframe'den sonra yeni bir geçiş kaydeder. CLIP SYNC ile bağlı klipler siz çekim yaparken oynar. Kayıt dışında F7 oynatır veya duraklatır; geri sayım ya da canlı kayıt sırasında F7 işlemi durdurur. F8 durdurup sekansı başa sarar.",
      "tutorial.step.cameraKeyframes.title": "Keyframe'leri tarayın ve tek tek düzenleyin",
      "tutorial.step.cameraKeyframes.body": "Kesin bir zamanı incelemek için scrubber'ı sürükleyin; bir kare seçmek için elmasa, keyframe seçicisine veya oklarına tıklayın. TIME zaman damgasını değiştirir. EASING kareye giriş ve çıkış hızını; PATH eğrisel Spline ya da doğrudan Linear bölümü; FOV ise keyframe başına lens açısını belirler. Kamerayı taşıyın ve yeni pozu işlemek için Save frame kullanın.",
      "tutorial.step.cameraTiming.title": "Zamanlamayı, ritmi ve tüm yolu yönetin",
      "tutorial.step.cameraTiming.body": "SPEED önizleme hızını ölçekler ve Timeline klibi CLIP SYNC sağladığında kilitlenir. PACING Natural yazılmış keyframe zamanlarını izler, Per segment her bölümde sabit hız tutar, Continuous ise tüm rota boyunca hızı eşitler. Loop oynatmayı tekrarlar; Close loop yakındaki son kareyi ilk kareye hizalar veya gerektiğinde tam kopyasını ekler; Distribute orta keyframe'leri eşit aralıklarla dizer; Path dünya üzerindeki rotayı gösterir veya gizler.",
      "tutorial.step.cameraAttachments.title": "Kameranın neyi izleyeceğini seçin",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) lensi oyuncuya dönük tutar. H ile panel gizlendikten sonra Free look (N), RMB tutmadan fareyle döndürür. Attach to entity replay araçlarını, sahne oyuncularını ve yakındaki varlıkları listeler; Refresh listeyi yeniden tarar. Ped için kök, vücut kemiği veya tutulan silahı; araç için araç kemiğini seçin. Attach ve Detach bağlantıyı uygular veya kaldırır. Panel gizliyken Target pointer hedefteki varlığı işaretler ve işaretçi kapalı olsa bile LMB onu bağlayabilir.",
      "tutorial.step.cameraAttachmentMotion.title": "Bağlantının nasıl hareket edeceğini seçin",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount, kaput kamerası gibi özneyle birlikte döner. Lock framing dönüşlerde ve yatışlarda tam göreli konum ile rotasyonu korur. Rigid kapalıyken Follow softness sabit bağlantı yerine operatör benzeri gecikme ekler. Auto orbit mevcut kadrajdan başlar: W/S mesafeyi, Q/E yüksekliği, A/D yörünge hızını değiştirir. Üç kaydırıcı kesin değerleri ayarlar; negatif hız yönü tersine çevirir.",
      "tutorial.step.cameraMovement.title": "Hareketi ve operatör tepkisini ayarlayın",
      "tutorial.step.cameraMovement.body": "Sensitivity bakış girişini, Zoom response lens girişini yönetir. Rotation smoothing kamerayı istenen açıya yumuşatır; Mouse smoothing ani fare hareketlerini süzer; Movement smoothing ötelemenin başlangıç ve bitişini yumuşatır. Base speed normal uçuş hızıdır: hızlı hareket için Shift, hassasiyet için Ctrl/Alt tutun. Lens odak preset'leri ile FOV arasında geçer; RMB döndürür, Z/C zoom yapar, Left/Right roll'u yönetir ve tekerlek Base speed'i değiştirir.",
      "tutorial.step.cameraFlight.title": "Doğru uçuş davranışını seçin",
      "tutorial.step.cameraFlight.body": "Drone mode girdiyi momentuma çevirir; kamera hemen durmak yerine süzülür ve dönüşlerde yatar. Walk mode operatör tarzı yürüyüş çekimleri için lensi yerden göz hizasında tutar. World collision duvarların ve katı geometrinin içinden geçmeyi önler. Normal uçuşta WASD hareket ve strafe, Q/E yükseklik içindir; yörüngede aynı tuşlar dolly, dönüş ve vinç kontrolüne dönüşür.",
      "tutorial.step.cameraImage.title": "Filtreyi, odağı ve kamera sarsıntısını ayarlayın",
      "tutorial.step.cameraImage.body": "Effects görsel filtreler arasında geçer, Intensity etkisinin gücünü karıştırır. Depth of field kontrollerinin görüntüyü etkilemesi için etkinleştirilmelidir. Autofocus lensin gördüğüne sürekli odaklanır; Follow focus bağlı özneyi net tutar; Autofocus kapalıyken manuel Distance açılır ve DOF Intensity bulanıklığı ayarlar. Camera shake seçilebilir bir sarsıntı preset'ini, Shake strength ise genliğini yönetir.",
      "tutorial.step.cameraScene.title": "Temiz ve dengeli bir sahne hazırlayın",
      "tutorial.step.cameraScene.body": "Allow player movement WASD kontrolünü ped'e veya araca geri verir ve akıllı takip kadrajı korur; kamerayı yeniden uçurmak ya da döndürmek için bunu kapatın. Look at camera oyuncunun başını lense çevirir. Cinematic bars seçilebilir bir en-boy oranı ekler; Hide game HUD ve Hide notifications kadrajı temizler. Rule of thirds, Center cross, Safe area ve Info overlay yoğunluğu ayarlanabilen kılavuzlardır; H ile panel gizlendiğinde kalır, oynatmada kaybolur.",
      "tutorial.step.cameraOutput.title": "Önizleyin, yakalayın, sıfırlayın ve geri dönün",
      "tutorial.step.cameraOutput.body": "Video Rockstar Editor kaydını başlatır veya durdurur. Play/Pause sekansı önizler, Stop başa döndürür. Alt çubuk canlı hız ve FOV'u gösterir: G bakış sabitlemeyi değiştirir, Level pitch ve heading'i bozmadan roll'u sıfırlar, R kamerayı sıfırlar, H paneli gizler, ESC çıkar. Custom Scene veya Timeline'dan açılan Camera oraya döner; üst sahneyi ya da projeyi kaydedin. Bağımsız sekanslar geçicidir.",

      "tutorial.step.customScenes.title": "Bir Custom Scene başlatın",
      "tutorial.step.customScenes.body": "Custom Scenes bu gösterim için otomatik olarak açılır. Normal kullanımda New Custom Scene'i seçin, kompozisyona ad verin ve düzenleyicisini açın. Bir Custom Scene, özgün kitaplıkları değiştirmeden bağımsız girdileri birleştirir.",
      "tutorial.step.customSceneEditor.title": "Sahne düzenleyicisini anlayın",
      "tutorial.step.customSceneEditor.body": "Üst bilgi kompozisyonun adını gösterir ve Scene Tools, Save ile Close seçeneklerini sunar. Scene Tools katmanları, koleksiyonları, görünürlüğü ve bağlantıları düzenler; Save ise girdiler ve zamanlama hazır olduğunda kompozisyonu saklar.",
      "tutorial.step.customSceneEntries.title": "Her girdiyi okuyun ve zamanlayın",
      "tutorial.step.customSceneEntries.body": "Her kart türünü, kaynağını ve dünya yerleşimini belirtir. Kullanılabildiğinde düzenleme, oyuncu, prop veya bağlantı işlemlerini kullanın. Delay girdinin ne zaman başlayacağını belirler; hazır ayarlar hızlı seçimler sunar, Custom ise tam bir değer kabul eder.",
      "tutorial.step.customSceneAdd.title": "Yapı taşlarını ekleyin",
      "tutorial.step.customSceneAdd.body": "Camera, Animation, senkronize Scene, Vehicle veya Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment ya da Combat Ped ekleyin. Her düğme eşleşen seçiciyi veya uzman düzenleyiciyi açar ve yapılandırılmış girdiyi buraya geri getirir.",
      "tutorial.step.sceneTools.title": "Karmaşık sahneleri düzenleyin",
      "tutorial.step.sceneTools.body": "Scene Tools, Custom Scenes için ana hat düzenleyicisidir. Büyük bir kompozisyonu anlaşılır ve düzenlenebilir tutmak için kararlı girdileri, katmanları, koleksiyonları, görünürlüğü, seçimi, bağlantıları, dönüşümleri ve doğrulamayı kullanın.",
      "tutorial.step.customScenePlayback.title": "Kaydetmeden önce test edin",
      "tutorial.step.customScenePlayback.body": "TEST, çekim oluşturmadan kompozisyonun tamamını önizler. ACTION geri sayımı çalıştırır ve Rockstar Editor'a kaydeder; Attach seçilen bir sahne varlığına bağlıyken kaydeder, Nearby ise uyumlu oynatmayı paylaşır. Önizlemeyi durdurun, girdileri düzeltin ve ardından Save kullanın.",
      "tutorial.step.timeline.title": "Timeline çalışma alanını açın",
      "tutorial.step.timeline.body": "Timeline, bir projeyi yüklemeden veya değiştirmeden otomatik olarak açılır. Normal kullanımda bir proje oluşturun ya da yükleyin, ad verin ve yapısını kaydedin. Timeline, otomatik kanallarda zamanlanmış birçok klibi birleştirir.",
      "tutorial.step.timelineLibrary.title": "Neyi yerleştireceğinizi seçin",
      "tutorial.step.timelineLibrary.body": "Kitaplık kameraları, favorileri, sahneleri, animasyonları, efektleri, replay'leri ve uzman girdileri gruplandırır. Önce arama yapın; ardından bir seçeneği oynatma imlecine eklemek için çift tıklayın veya tam zamana sürükleyin. Gerekli kanal otomatik olarak oluşturulur.",
      "tutorial.step.timelineTracks.title": "Klipleri otomatik kanallarda düzenleyin",
      "tutorial.step.timelineTracks.body": "Klipler eklendiğinde kanallar görünür. Başlangıç ve süreyi ayarlamak için klipleri taşıyın veya yeniden boyutlandırın, hassasiyet için oynatma imlecini ve yakınlaştırmayı kullanın; bir kanalı yeniden adlandırmak, sıralamak, boyutlandırmak, solo yapmak, susturmak ya da kilitlemek için kanal ayarlarını açın.",
      "tutorial.step.timelineInspector.title": "Seçili klibi düzenleyin",
      "tutorial.step.timelineInspector.body": "Bir klip seçildiğinde stage alanında denetçisi açılır. Tam IN, OUT, süre, kaynak ofseti, döngü ve geçişleri ayarlayın; ardından klip türü destekliyorsa Place, Props, oyuncu ayarları, keyframe'ler veya iç içe düzenleyicisini kullanın.",
      "tutorial.step.timelinePlayback.title": "Kurguyu önizleyin ve kaydedin",
      "tutorial.step.timelinePlayback.body": "Play from geçerli oynatma imlecinden başlar; TEST tüm Timeline için baştan önizleme yapar. START arayüz gizliyken, geri sayım veya kayıt olmadan baştan oynatır; Backspace oynatmayı durdurup Timeline görünümüne döner. ACTION geri sayımla senkronize sonucu kaydeder. Nearby uyumlu klipleri yakındaki oyuncularla senkronize eder. Son çekimden önce tanılama sorunlarını çözün ve kaydedin.",
      "tutorial.step.replays.title": "Kaydedilmiş performansları yeniden kullanın",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle ve Chase Replay farklı hareket ve eylem türlerini yakalar. Temiz bir çekim kaydedin, durdurup işlemenin tamamlanmasını bekleyin, kaydedin ve ardından bu kaynağa Custom Scenes veya Timeline içinden başvurun.",
      "tutorial.step.advancedLayers.title": "Uzmanlaşmış oluşturma katmanlarını açın",
      "tutorial.step.advancedLayers.body": "Gelişmiş girdiler arasında Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment ve bağlantılar bulunur. Her düzenleyici kendi önizlemesini korur ve sonucu kendisini açan sahneye veya Timeline'a geri gönderir.",

      "tutorial.step.catalog.title": "Oluşturmadan önce arayın",
      "tutorial.step.catalog.body": "Katalog panelleri arama, kategoriler, filtreler, klasörler, favoriler ve sonuç sayılarını kullanır. Önce listeyi daraltın, seçili kartı inceleyin ve dünyayı temiz tutmak için yerleşimi veya oynatmayı ancak bundan sonra açın.",
      "tutorial.step.safeWorkflow.title": "Önizleyin, doğrulayın, sonra kaydedin",
      "tutorial.step.safeWorkflow.body": "Oluşturma değişikliklerinin çoğu onaylanana veya kaydedilene kadar geçicidir. Preview ya da TEST kullanın, etkin Freecam/gizmo oturumunu tamamlayın, zamanlamayı ve hedefleri kontrol edip kaydedin; Esc veya Backspace etkin katmandan güvenle geri döner.",
      "tutorial.step.recording.title": "REC göstergesini anlayın",
      "tutorial.step.recording.body": "Alt bilgi, Rockstar kayıt durumunu ve genel kapatma ipucunu gösterir. ACTION iş akışları başvurulan varlıkları hazırlar, geri sayımı çalıştırır ve senkronize sonucu kaydeder; bir çekim tamamlanırken kaynağı kapatmayın.",
      "tutorial.step.cutscenes.title": "Cutscene Player ayrı bir çalışma alanıdır",
      "tutorial.step.cutscenes.body": "GTA ara sahnelerine, favorilere, yeni isteğe bağlı kataloglara, oyuncu geçersiz kılmalarına, sese, HUD'a, geçişlere ve seyirci seçeneklerine göz atmak için F6 tuşuna basın veya /cutscenes komutunu kullanın. Etkin kurulumu korumak için ana Director panelinden ayrı kalır.",
      "tutorial.step.shortcuts.title": "Ortak kontrollerde ustalaşın",
      "tutorial.step.shortcuts.body": "F5, Director'ı açar. Oluşturma Freecam'inde RMB'yi basılı tutup WASD ile birlikte Q/E, Shift, Ctrl ve tekerleği kullanın. Gizmo'da W/R, Tab, Alt, G, Enter ve Backspace kullanın; her uzman düzenleyici ayrıca kendi canlı HUD'ını gösterir.",

      "tutorial.step.finish.title": "Yönetmeye hazırsınız",
      "tutorial.step.finish.body": "Tek bir oyuncu veya sahneyle başlayın, her katmanı önizleyin ve yapımı yalnızca her parça düzgün çalıştıktan sonra büyütün. Bu rehberli turu yeniden görmek istediğinizde /tutorial komutunu çalıştırın; bitirdiğinizde hemen pratik yapabilmeniz için Director açık kalır."
    },
    fr: {
      "tutorial.title": "Tutoriel interactif de Director",
      "tutorial.progress": "Étape {{current}} sur {{total}}",
      "tutorial.previous": "Précédent",
      "tutorial.next": "Suivant",
      "tutorial.finish": "Terminer le tutoriel",
      "tutorial.exit": "Quitter le tutoriel",
      "tutorial.restart": "Recommencer",
      "tutorial.chapters": "Chapitres",
      "tutorial.keyboardHint": "Utilisez Gauche/Droite pour changer d'étape et Échap pour quitter.",
      "tutorial.safeMode": "Vue guidée : les espaces de travail et les démonstrations s'ouvrent automatiquement, mais les commandes mises en évidence ne sont jamais activées.",
      "tutorial.targetUnavailable": "Cette commande n'est pas visible dans la disposition actuelle. Vous pouvez continuer sans risque.",
      "tutorial.finishWorkspace": "Terminez ou fermez l'éditeur actif avant de lancer le tutoriel.",
      "tutorial.helpTitle": "Ouvrir le tutoriel guidé",
      "tutorial.languageLabel": "Langue du tutoriel",

      "tutorial.chapter.orientation": "Prise en main",
      "tutorial.chapter.library": "Vos bibliothèques de contenu",
      "tutorial.chapter.liveTools": "Outils de réalisation en direct",
      "tutorial.chapter.camera": "Caméra cinématographique",
      "tutorial.chapter.customScenes": "Flux Custom Scene",
      "tutorial.chapter.timeline": "Montage sur la Timeline",
      "tutorial.chapter.authoring": "Création de scènes complètes",
      "tutorial.chapter.workflow": "Flux de travail sûr et commandes",
      "tutorial.chapter.finish": "Prêt à réaliser",

      "tutorial.step.welcome.title": "Bienvenue dans Spectrem Director",
      "tutorial.step.welcome.body": "Cette visite guidée explique l'ensemble du processus de création. Elle peut ouvrir automatiquement des démonstrations visuelles, mais elle ne lancera, ne fera apparaître, n'enregistrera, ne supprimera, ne sauvegardera et ne modifiera rien dans votre monde.",
      "tutorial.step.header.title": "Votre espace de travail Director",
      "tutorial.step.header.body": "L'en-tête réunit l'identité de Director, la langue, l'état du catalogue et les principales informations de session en un emplacement stable. Le panneau reste disponible lorsque vous passez d'un outil à l'autre.",
      "tutorial.step.language.title": "Choisissez la langue de l'interface",
      "tutorial.step.language.body": "Utilisez ce sélecteur pour changer immédiatement la langue de l'interface. Config.Language définit la langue chargée au démarrage de la ressource ; l'anglais reste la valeur par défaut sûre.",
      "tutorial.step.navigation.title": "Un seul plan pour tous les outils",
      "tutorial.step.navigation.body": "La grille de navigation regroupe les bibliothèques, les commandes du monde en direct et les éditeurs de production. L'onglet mis en évidence indique où vous vous trouvez ; revenir ici n'efface jamais le travail enregistré.",

      "tutorial.step.scenes.title": "Parcourez les scènes synchronisées",
      "tutorial.step.scenes.body": "Scenes contient le catalogue des scènes synchronisées. Recherchez ou ouvrez une catégorie, choisissez une scène, attribuez ses acteurs, placez-la dans le monde, prévisualisez-la, puis réutilisez-la dans une Custom Scene.",
      "tutorial.step.favorites.title": "Gardez vos scènes fréquentes à portée de main",
      "tutorial.step.favorites.body": "Ajoutez une étoile à une scène pour la placer dans Scenes Fav. Les favoris constituent une bibliothèque personnelle rapide sans dupliquer ni modifier la définition de la scène d'origine.",
      "tutorial.step.peds.title": "Créez une distribution réutilisable",
      "tutorial.step.peds.body": "My Peds stocke les apparences dans des dossiers. Créez, modifiez, dupliquez, renommez ou faites apparaître un ped enregistré, ou incarnez-le, puis réutilisez cette distribution dans les scènes, animations, environnements, replays et poursuites.",
      "tutorial.step.vehicles.title": "Enregistrez des véhicules prêts pour la production",
      "tutorial.step.vehicles.body": "My Vehicles capture un véhicule chargé avec ses modifications, couleurs, extras, feux, dégâts et autres états visuels. Les préréglages enregistrés peuvent apparaître dans le monde ou remplacer des véhicules dans les flux de replay et de Chase.",
      "tutorial.step.animations.title": "Trouvez et placez des animations",
      "tutorial.step.animations.body": "Animations propose la recherche, les favoris, le type de lecture, la boucle et les filtres de placement Ground/Fly. Choisissez l'acteur, vérifiez l'aperçu, puis placez ou jouez l'animation à la hauteur corrigée dans le monde.",
      "tutorial.step.customAnimations.title": "Utilisez les animations propres au serveur",
      "tutorial.step.customAnimations.body": "Custom Anims répertorie les dictionnaires et clips fournis par votre configuration ou le pont du menu d'animations. Ils utilisent le même flux de sélection d'acteur, de placement, de boucle et d'intégration aux scènes que le catalogue principal.",

      "tutorial.step.chase.title": "Réalisez une poursuite cinématographique",
      "tutorial.step.chase.body": "Chase commence avec des réglages de police sûrs, puis permet de personnaliser les unités, véhicules, conducteurs, passagers, sirènes, le soutien aérien, le comportement, la protection et les armes utilisées à pied. Chase Replay enregistre les trajectoires synchronisées des véhicules sans le comportement de sortie et de tir.",
      "tutorial.step.density.title": "Contrôlez la circulation en arrière-plan",
      "tutorial.step.density.body": "Density règle les piétons locaux, les véhicules en mouvement, les véhicules stationnés, la circulation aléatoire et les scénarios. Les valeurs basses dégagent un plateau contrôlé, tandis que les valeurs élevées créent un arrière-plan plus animé sans modifier vos scènes enregistrées.",
      "tutorial.step.weather.title": "Façonnez la météo et l'heure",
      "tutorial.step.weather.body": "Weather & Time contrôle la météo, l'horloge, la vitesse du temps, le gel, la panne d'électricité, la pluie, le vent et l'éclairage urbain. Choisissez des réglages locaux pour un plateau privé ou le pont serveur configuré lorsque tout le serveur doit les suivre.",
      "tutorial.step.environment.title": "Mettez en scène les PNJ d'arrière-plan",
      "tutorial.step.environment.body": "Environment crée des groupes de PNJ réutilisables avec formations, modèles sources ou dossiers de peds enregistrés, quantité, espacement, étendue, genre, animation et direction du regard. Enregistrez plusieurs environnements et ajoutez leur instantané exact à une scène ou à la Timeline.",
      "tutorial.step.effects.title": "Placez et animez des effets",
      "tutorial.step.effects.body": "Effects recherche des ressources de particules et prévisualise en direct l'échelle, l'opacité, la couleur et l'état de boucle. Conservez un effet à une position dans le monde ou attachez-le à un acteur compatible, puis programmez-le précisément dans Custom Scenes ou la Timeline.",
      "tutorial.step.clubs.title": "Gérez les intérieurs et préréglages de clubs",
      "tutorial.step.clubs.body": "Clubs conserve les préréglages d'intérieurs cinématographiques, les coordonnées et l'état IPL/intérieur. Utilisez la téléportation pour inspecter une installation, puis enregistrez, mettez à jour ou supprimez le préréglage lorsque sa configuration dans le monde est correcte.",
      "tutorial.step.spooner.title": "Faites apparaître et organisez les entités du monde",
      "tutorial.step.spooner.body": "Object Spooner recherche les peds, objets et véhicules, puis les place au moyen de Freecam et du gizmo natif. Sélectionnez une ou plusieurs entités pour les transformer, dupliquer, attacher, organiser ou les envoyer vers un autre flux de Director.",
      "tutorial.step.camera.title": "Découvrez l'espace Camera cinématographique",
      "tutorial.step.camera.body": "Le tutoriel ouvre cet espace visuel protégé sans démarrer Freecam ni modifier le monde. En utilisation normale, Camera peut s'ouvrir depuis son onglet principal, une entrée Camera de Custom Scene ou un clip Camera de Timeline. H masque ou réaffiche le panneau sans désactiver les commandes de caméra ; en quittant, vous revenez à l'outil qui l'a ouverte.",
      "tutorial.step.cameraCapture.title": "Capturez et corrigez des poses précises",
      "tutorial.step.cameraCapture.body": "Nommez la séquence en haut. Capture (L) ajoute position, rotation, FOV et réglages d'image dans une nouvelle keyframe ; en fin de séquence autonome, l'intervalle Append configuré est utilisé, tandis qu'un clip lié suit son playhead. Après avoir déplacé la caméra, Save frame remplace uniquement la keyframe sélectionnée. Duplicate insère une copie entre celle-ci et la suivante, ou après l'intervalle configuré en fin de séquence ; la corbeille supprime la keyframe sélectionnée.",
      "tutorial.step.cameraRecording.title": "Enregistrez un mouvement de caméra en direct",
      "tutorial.step.cameraRecording.body": "Record lance un compte à rebours et transforme le mouvement réalisé en direct en keyframes. REC: Replace efface la prise précédente ; REC: Append la conserve et enregistre un nouveau passage après sa dernière keyframe. Avec CLIP SYNC, les clips liés sont lus pendant le tournage. Hors enregistrement, F7 lance ou met en pause la lecture ; pendant le compte à rebours ou l'enregistrement en direct, F7 arrête l'opération. F8 arrête et rembobine la séquence au début.",
      "tutorial.step.cameraKeyframes.title": "Parcourez et modifiez chaque keyframe",
      "tutorial.step.cameraKeyframes.body": "Faites glisser le curseur pour examiner un instant précis, puis cliquez sur un losange, le sélecteur de keyframes ou ses flèches pour choisir une image. TIME change son horodatage. EASING règle l'entrée et la sortie de vitesse ; PATH choisit un segment courbe Spline ou direct Linear ; FOV mémorise un angle d'objectif par keyframe. Déplacez la caméra, puis validez la nouvelle pose avec Save frame.",
      "tutorial.step.cameraTiming.title": "Maîtrisez le temps, le rythme et le trajet",
      "tutorial.step.cameraTiming.body": "SPEED module la vitesse de l'aperçu et se verrouille lorsqu'un clip Timeline fournit CLIP SYNC. PACING Natural respecte les temps des keyframes, Per segment maintient une vitesse constante dans chaque segment, et Continuous uniformise la vitesse sur tout le trajet. Loop répète la lecture ; Close loop aligne une dernière image déjà proche sur la première ou ajoute une copie exacte si nécessaire ; Distribute espace régulièrement les keyframes intermédiaires ; Path affiche ou masque le trajet dans le monde.",
      "tutorial.step.cameraAttachments.title": "Choisissez ce que la caméra doit suivre",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) garde l'objectif tourné vers le joueur. Une fois le panneau masqué avec H, Free look (N) permet de pivoter à la souris sans maintenir RMB. Attach to entity répertorie véhicules de replay, acteurs de scène et entités proches ; Refresh relance l'analyse. Pour un ped, choisissez la racine, un os ou l'arme tenue ; pour un véhicule, un os du véhicule. Attach et Detach appliquent ou retirent le lien. Panneau masqué, Target pointer marque l'entité visée et LMB peut l'attacher même lorsque le pointeur est désactivé.",
      "tutorial.step.cameraAttachmentMotion.title": "Définissez le mouvement d'un attachement",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount tourne avec le sujet comme une caméra de capot. Lock framing conserve exactement la position et la rotation relatives pendant les virages et l'inclinaison. Si Rigid est désactivé, Follow softness ajoute un retard d'opérateur plutôt qu'une fixation rigide. Auto orbit part du cadrage déjà composé : W/S change la distance, Q/E la hauteur et A/D la vitesse orbitale. Les trois curseurs donnent des valeurs précises ; une vitesse négative inverse le sens.",
      "tutorial.step.cameraMovement.title": "Réglez le mouvement et la réponse de l'opérateur",
      "tutorial.step.cameraMovement.body": "Sensitivity contrôle le regard et Zoom response l'objectif. Rotation smoothing amène progressivement la caméra vers l'angle demandé ; Mouse smoothing filtre les gestes brusques de la souris ; Movement smoothing adoucit les départs et arrêts. Base speed fixe la vitesse normale : maintenez Shift pour accélérer ou Ctrl/Alt pour la précision. Lens parcourt les focales et le FOV ; RMB pivote, Z/C zoome, Left/Right contrôle le roulis et la molette modifie Base speed.",
      "tutorial.step.cameraFlight.title": "Choisissez le bon comportement de vol",
      "tutorial.step.cameraFlight.body": "Drone mode transforme l'entrée en impulsion : la caméra glisse et s'incline au lieu de s'arrêter immédiatement. Walk mode maintient l'objectif à hauteur des yeux au-dessus du sol pour des plans d'opérateur. World collision empêche de traverser murs et géométrie solide. En vol normal, WASD déplace ou décale et Q/E change la hauteur ; en orbite, ces commandes deviennent dolly, rotation et grue.",
      "tutorial.step.cameraImage.title": "Réglez les filtres, la mise au point et les vibrations",
      "tutorial.step.cameraImage.body": "Effects parcourt les filtres visuels et Intensity dose leur force. Depth of field doit être activé pour agir sur l'image. Autofocus règle continuellement la netteté de ce que voit l'objectif ; Follow focus garde un sujet attaché net ; Distance devient manuel quand Autofocus est désactivé, et l'intensité DOF règle le flou. Camera shake active un préréglage de vibration, tandis que Shake strength définit son amplitude.",
      "tutorial.step.cameraScene.title": "Préparez une scène propre et bien cadrée",
      "tutorial.step.cameraScene.body": "Allow player movement rend WASD au ped ou au véhicule tandis que le suivi intelligent conserve le cadrage ; désactivez-le pour recommencer à déplacer ou pivoter la caméra. Look at camera tourne la tête du joueur vers l'objectif. Cinematic bars ajoute un format d'image sélectionnable ; Hide game HUD et Hide notifications nettoient le cadre. Rule of thirds, Center cross, Safe area et Info overlay sont des guides à intensité réglable : ils restent visibles avec H et disparaissent pendant la lecture.",
      "tutorial.step.cameraOutput.title": "Prévisualisez, capturez, réinitialisez et revenez",
      "tutorial.step.cameraOutput.body": "Video démarre ou arrête un enregistrement Rockstar Editor. Play/Pause prévisualise la séquence et Stop revient au début. Le pied affiche vitesse et FOV en direct : G bascule l'ancrage du regard, Level annule le roulis sans modifier pitch ni heading, R réinitialise la caméra, H masque le panneau et ESC quitte. Une Camera ouverte depuis Custom Scene ou Timeline y revient : enregistrez ensuite la scène ou le projet parent ; les séquences autonomes sont temporaires.",

      "tutorial.step.customScenes.title": "Commencez une Custom Scene",
      "tutorial.step.customScenes.body": "Custom Scenes s'ouvre automatiquement pour cette démonstration. En utilisation normale, choisissez New Custom Scene, nommez la composition et ouvrez son éditeur. Une Custom Scene combine des entrées indépendantes sans modifier les bibliothèques d'origine.",
      "tutorial.step.customSceneEditor.title": "Comprenez l'éditeur de scène",
      "tutorial.step.customSceneEditor.body": "L'en-tête nomme la composition et donne accès à Scene Tools, Save et Close. Scene Tools organise les calques, les collections, la visibilité et les attaches ; Save conserve la composition lorsque ses entrées et son minutage sont prêts.",
      "tutorial.step.customSceneEntries.title": "Lisez et minutez chaque entrée",
      "tutorial.step.customSceneEntries.body": "Chaque carte indique son type, sa source et son placement dans le monde. Utilisez ses actions de modification, d'acteur, de prop ou d'attache lorsqu'elles sont disponibles. Delay détermine le début de l'entrée ; les préréglages offrent des choix rapides et Custom accepte une valeur exacte.",
      "tutorial.step.customSceneAdd.title": "Ajoutez les éléments de base",
      "tutorial.step.customSceneAdd.body": "Ajoutez Camera, Animation, une Scene synchronisée, Vehicle ou Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment ou Combat Ped. Chaque bouton ouvre le sélecteur ou l'éditeur spécialisé correspondant, puis ramène ici l'entrée configurée.",
      "tutorial.step.sceneTools.title": "Organisez les scènes complexes",
      "tutorial.step.sceneTools.body": "Scene Tools est l'arborescence de Custom Scenes. Utilisez des entrées stables, des calques, des collections, la visibilité, la sélection, les attaches, les transformations et la validation pour qu'une composition volumineuse reste compréhensible et modifiable.",
      "tutorial.step.customScenePlayback.title": "Testez avant d'enregistrer",
      "tutorial.step.customScenePlayback.body": "TEST prévisualise toute la composition sans créer de prise. ACTION lance le compte à rebours et enregistre dans Rockstar Editor ; Attach enregistre en suivant une entité choisie de la scène et Nearby partage une lecture compatible. Arrêtez l'aperçu, corrigez les entrées, puis utilisez Save.",
      "tutorial.step.timeline.title": "Ouvrez l'espace Timeline",
      "tutorial.step.timeline.body": "Timeline s'ouvre automatiquement sans charger ni modifier de projet. En utilisation normale, créez ou chargez un projet, nommez-le et enregistrez sa structure. Timeline combine de nombreux clips minutés sur des pistes automatiques.",
      "tutorial.step.timelineLibrary.title": "Choisissez ce que vous voulez placer",
      "tutorial.step.timelineLibrary.body": "La bibliothèque regroupe les caméras, favoris, scènes, animations, effets, replays et entrées spécialisées. Commencez par rechercher, puis double-cliquez sur une option pour l'ajouter à la tête de lecture ou faites-la glisser au temps exact ; la piste requise est créée automatiquement.",
      "tutorial.step.timelineTracks.title": "Organisez les clips sur des pistes automatiques",
      "tutorial.step.timelineTracks.body": "Les pistes apparaissent lorsque des clips sont ajoutés. Déplacez ou redimensionnez les clips pour régler leur début et leur durée, utilisez la tête de lecture et le zoom pour plus de précision, puis ouvrez les paramètres de piste pour la renommer, la réordonner, la redimensionner, la mettre en solo, la rendre muette ou la verrouiller.",
      "tutorial.step.timelineInspector.title": "Modifiez le clip sélectionné",
      "tutorial.step.timelineInspector.body": "La sélection d'un clip ouvre son inspecteur dans la zone Stage. Réglez précisément IN, OUT, la durée, le décalage de source, la boucle et les transitions, puis utilisez Place, Props, les réglages d'acteur, les keyframes ou son éditeur imbriqué lorsque le type de clip les prend en charge.",
      "tutorial.step.timelinePlayback.title": "Prévisualisez et enregistrez le montage",
      "tutorial.step.timelinePlayback.body": "Play from démarre à la tête de lecture actuelle ; TEST prévisualise toute la Timeline depuis le début. START lance la lecture depuis le début avec l’interface masquée, sans compte à rebours ni enregistrement ; Retour arrière arrête la lecture et revient à la Timeline. ACTION lance le compte à rebours et enregistre le résultat synchronisé. Nearby synchronise les clips compatibles avec les joueurs proches. Corrigez les diagnostics et enregistrez avant la prise finale.",
      "tutorial.step.replays.title": "Réutilisez les performances enregistrées",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle et Chase Replay capturent différents types de mouvements et d'actions. Enregistrez une prise propre, arrêtez-la et attendez la fin de son traitement, sauvegardez-la, puis référencez cette source depuis Custom Scenes ou la Timeline.",
      "tutorial.step.advancedLayers.title": "Ouvrez les couches de création spécialisées",
      "tutorial.step.advancedLayers.body": "Les entrées avancées comprennent Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment et les attaches. Chaque éditeur conserve son propre aperçu et renvoie le résultat à la scène ou à la Timeline qui l'a ouvert.",

      "tutorial.step.catalog.title": "Recherchez avant de construire",
      "tutorial.step.catalog.body": "Les panneaux de catalogue utilisent la recherche, les catégories, les filtres, les dossiers, les favoris et le nombre de résultats. Réduisez d'abord la liste, inspectez la carte sélectionnée, puis seulement ensuite ouvrez le placement ou la lecture afin de garder le monde propre.",
      "tutorial.step.safeWorkflow.title": "Prévisualisez, vérifiez, puis enregistrez",
      "tutorial.step.safeWorkflow.body": "La plupart des modifications de création restent temporaires jusqu'à leur confirmation ou leur enregistrement. Utilisez Preview ou TEST, terminez toute session Freecam/gizmo, vérifiez le minutage et les cibles, puis enregistrez ; Échap ou Retour arrière permet de quitter proprement la couche active.",
      "tutorial.step.recording.title": "Comprenez l'indicateur REC",
      "tutorial.step.recording.body": "Le pied de page affiche l'état de l'enregistrement Rockstar et le raccourci global de fermeture. Les flux ACTION préparent les ressources référencées, exécutent leur compte à rebours et enregistrent le résultat synchronisé ; ne fermez pas la ressource pendant la finalisation d'une prise.",
      "tutorial.step.cutscenes.title": "Cutscene Player est un espace distinct",
      "tutorial.step.cutscenes.body": "Appuyez sur F6 ou utilisez /cutscenes pour parcourir les cinématiques GTA, les favoris, les nouveaux catalogues facultatifs, les remplacements d'acteurs, l'audio, le HUD, les fondus et les options de spectateur. Cet espace reste séparé du panneau Director principal afin de protéger la configuration active.",
      "tutorial.step.shortcuts.title": "Maîtrisez les commandes partagées",
      "tutorial.step.shortcuts.body": "F5 ouvre Director. Dans la Freecam de création, maintenez RMB et utilisez WASD avec Q/E, Maj, Ctrl et la molette. Dans le gizmo, utilisez W/R, Tab, Alt, G, Entrée et Retour arrière ; chaque éditeur spécialisé affiche également son propre HUD en direct.",

      "tutorial.step.finish.title": "Vous êtes prêt à réaliser",
      "tutorial.step.finish.body": "Commencez avec un seul acteur ou une seule scène, prévisualisez chaque couche et n'agrandissez la production que lorsque chaque élément fonctionne. Exécutez /tutorial chaque fois que vous souhaitez revoir cette visite guidée ; à la fin, Director reste ouvert pour vous permettre de vous exercer immédiatement."
    },
    ar: {
      "tutorial.title": "الدليل التفاعلي لـ Director",
      "tutorial.progress": "الخطوة {{current}} من {{total}}",
      "tutorial.previous": "السابق",
      "tutorial.next": "التالي",
      "tutorial.finish": "إنهاء الدليل",
      "tutorial.exit": "الخروج من الدليل",
      "tutorial.restart": "إعادة البدء",
      "tutorial.chapters": "الفصول",
      "tutorial.keyboardHint": "استخدم السهمين الأيسر/الأيمن للتنقل بين الخطوات وEsc للخروج.",
      "tutorial.safeMode": "عرض إرشادي: تُفتح مساحات العمل والعروض التوضيحية تلقائياً، لكن لا يتم أبداً تفعيل عناصر التحكم المميزة.",
      "tutorial.targetUnavailable": "عنصر التحكم هذا غير ظاهر في التخطيط الحالي. يمكنك المتابعة بأمان.",
      "tutorial.finishWorkspace": "أنهِ عملك في المحرر النشط أو أغلقه قبل بدء الدليل.",
      "tutorial.helpTitle": "فتح الدليل الإرشادي",
      "tutorial.languageLabel": "لغة الدليل",

      "tutorial.chapter.orientation": "التعرّف على الواجهة",
      "tutorial.chapter.library": "مكتبات المحتوى الخاصة بك",
      "tutorial.chapter.liveTools": "أدوات الإخراج المباشر",
      "tutorial.chapter.camera": "الكاميرا السينمائية",
      "tutorial.chapter.customScenes": "سير عمل Custom Scene",
      "tutorial.chapter.timeline": "التحرير على Timeline",
      "tutorial.chapter.authoring": "إنشاء مشاهد متكاملة",
      "tutorial.chapter.workflow": "سير عمل آمن وعناصر التحكم",
      "tutorial.chapter.finish": "جاهز للإخراج",

      "tutorial.step.welcome.title": "مرحباً بك في Spectrem Director",
      "tutorial.step.welcome.body": "تشرح هذه الجولة الإرشادية سير عمل الإنشاء بالكامل. ويمكنها فتح عروض توضيحية مرئية تلقائياً، لكنها لن تشغّل أو تنشئ أو تسجّل أو تحذف أو تحفظ أو تغيّر أي شيء في عالمك.",
      "tutorial.step.header.title": "مساحة عمل Director الخاصة بك",
      "tutorial.step.header.body": "يجمع الشريط العلوي هوية Director واللغة وحالة الكتالوج ومعلومات الجلسة الأساسية في مكان ثابت واحد. وتبقى اللوحة متاحة أثناء تنقلك بين الأدوات.",
      "tutorial.step.language.title": "اختر لغة الواجهة",
      "tutorial.step.language.body": "استخدم هذا المحدد لتغيير لغة الواجهة الحالية فوراً. يحدد Config.Language اللغة التي تُحمّل عند بدء المورد، وتبقى الإنجليزية الخيار الافتراضي الآمن.",
      "tutorial.step.navigation.title": "خريطة واحدة لكل الأدوات",
      "tutorial.step.navigation.body": "تجمع شبكة التنقل مكتبات المحتوى وأدوات التحكم المباشر بالعالم ومحررات الإنتاج. تُظهر علامة التبويب المميزة مكانك الحالي، والعودة إلى هنا لا تمحو العمل المحفوظ أبداً.",

      "tutorial.step.scenes.title": "تصفّح المشاهد المتزامنة",
      "tutorial.step.scenes.body": "يحتوي Scenes على كتالوج المشاهد المتزامنة. ابحث أو افتح فئة، واختر مشهداً، وعيّن ممثليه، وضعه في العالم، وعاينه، ثم أعد استخدامه داخل Custom Scene.",
      "tutorial.step.favorites.title": "أبقِ مشاهدك المتكررة في متناولك",
      "tutorial.step.favorites.body": "ضع نجمة على أي مشهد لإضافته إلى Scenes Fav. المفضلة مكتبة شخصية سريعة ولا تنسخ تعريف المشهد الأصلي ولا تعدّله.",
      "tutorial.step.peds.title": "أنشئ طاقم شخصيات قابلاً لإعادة الاستخدام",
      "tutorial.step.peds.body": "يحفظ My Peds مظاهر الشخصيات داخل مجلدات. يمكنك إنشاء شخصية محفوظة أو تعديلها أو استنساخها أو إعادة تسميتها أو توليدها أو التحول إليها، ثم إعادة استخدام الطاقم في المشاهد والرسوم المتحركة والبيئات وعمليات Replay والمطاردات.",
      "tutorial.step.vehicles.title": "احفظ مركبات جاهزة للإنتاج",
      "tutorial.step.vehicles.body": "يلتقط My Vehicles مركبة محمّلة مع تعديلاتها وألوانها وإضافاتها وأضوائها وأضرارها وحالتها البصرية الأخرى. يمكن توليد الإعدادات المسبقة المحفوظة أو استخدامها لاستبدال المركبات في مسارات Replay وChase.",
      "tutorial.step.animations.title": "اعثر على الرسوم المتحركة وضعها",
      "tutorial.step.animations.body": "يوفر Animations البحث والمفضلة ونوع التشغيل والتكرار ومرشحات الوضع Ground/Fly. اختر الممثل، وتحقق من المعاينة، ثم ضع الرسم المتحرك أو شغّله على ارتفاع العالم المصحح.",
      "tutorial.step.customAnimations.title": "استخدم الرسوم المتحركة الخاصة بالخادم",
      "tutorial.step.customAnimations.body": "يعرض Custom Anims القواميس والمقاطع التي توفرها إعداداتك أو جسر قائمة الرسوم المتحركة. وهي تستخدم سير العمل نفسه لاختيار الممثل والوضع والتكرار والدمج في المشاهد مثل الكتالوج الرئيسي.",

      "tutorial.step.chase.title": "أخرج مطاردة سينمائية",
      "tutorial.step.chase.body": "يبدأ Chase بإعدادات شرطة افتراضية آمنة، ثم يتيح تخصيص الوحدات والمركبات والسائقين والركاب وصفارات الإنذار والدعم الجوي والسلوك والحماية والأسلحة عند الترجل. يسجّل Chase Replay مسارات المركبات المتزامنة من دون سلوك الترجل وإطلاق النار.",
      "tutorial.step.density.title": "تحكّم في حركة الخلفية",
      "tutorial.step.density.body": "يضبط Density المشاة المحليين والمركبات المتحركة والمركبات المتوقفة والحركة العشوائية والسيناريوهات. تنظف القيم المنخفضة موقع التصوير، بينما تصنع القيم الأعلى خلفية أكثر ازدحاماً من دون تعديل مشاهدك المحفوظة.",
      "tutorial.step.weather.title": "شكّل الطقس والوقت",
      "tutorial.step.weather.body": "يتحكم Weather & Time في الطقس والساعة وسرعة الوقت والتجميد والتعتيم والمطر والرياح وأضواء المدينة. اختر التجاوزات المحلية لإعداد خاص، أو الجسر المهيأ عندما يجب أن يتبع الخادم بأكمله الإعداد.",
      "tutorial.step.environment.title": "نظّم شخصيات NPC في الخلفية",
      "tutorial.step.environment.body": "ينشئ Environment مجموعات NPC قابلة لإعادة الاستخدام، مع تشكيلات ونماذج مصدر أو مجلدات شخصيات محفوظة وعدد ومسافات وامتداد ونوع وحركة واتجاه نظر. احفظ عدة بيئات وأضف اللقطة الدقيقة إلى مشهد أو Timeline.",
      "tutorial.step.effects.title": "ضع المؤثرات وحرّكها",
      "tutorial.step.effects.body": "يبحث Effects في أصول الجسيمات ويعاين الحجم والشفافية واللون وحالة التكرار مباشرة. أبقِ المؤثر في موضع عالمي أو اربطه بممثل متوافق، ثم جدوله بدقة في Custom Scenes أو Timeline.",
      "tutorial.step.clubs.title": "أدر المساحات الداخلية وإعدادات النوادي",
      "tutorial.step.clubs.body": "يحفظ Clubs إعدادات داخلية سينمائية وإحداثيات وحالة IPL/المساحة الداخلية. استخدم الانتقال الفوري لمعاينة الإعداد، ثم احفظ الإعداد المسبق أو حدّثه أو احذفه عندما يصبح تكوين العالم صحيحاً.",
      "tutorial.step.spooner.title": "أنشئ كيانات العالم ورتّبها",
      "tutorial.step.spooner.body": "يبحث Object Spooner عن الشخصيات والعناصر والمركبات ويضعها عبر Freecam وأداة gizmo الأصلية. حدّد كياناً واحداً أو عدة كيانات لتحويلها أو استنساخها أو إرفاقها أو تنظيمها أو إرسالها إلى مسار عمل آخر في Director.",
      "tutorial.step.camera.title": "تعرّف إلى مساحة Camera السينمائية",
      "tutorial.step.camera.body": "يفتح الدليل مساحة العرض المحمية هذه من دون تشغيل Freecam أو تغيير العالم. في الاستخدام العادي يمكن فتح Camera من تبويبها الرئيسي، أو من إدخال Camera داخل Custom Scene، أو من مقطع Camera في Timeline. يخفي H اللوحة أو يعيدها مع بقاء أدوات الكاميرا فعّالة؛ وعند الخروج تعود إلى الأداة التي فتحتها.",
      "tutorial.step.cameraCapture.title": "التقط وضعيات الكاميرا الدقيقة وعدّلها",
      "tutorial.step.cameraCapture.body": "سمِّ التسلسل في الأعلى. يضيف Capture (L) الموضع والدوران وFOV وإعدادات الصورة كـ keyframe جديدة؛ وفي نهاية تسلسل مستقل يستخدم فاصل Append المضبوط، أما المقطع المرتبط فيتبع playhead الخاص به. بعد تحريك الكاميرا، يستبدل Save frame الـ keyframe المحددة فقط. يضع Duplicate نسخة بينها وبين التالية، أو بعد الفاصل المضبوط في النهاية؛ ويحذف زر سلة المهملات الـ keyframe المحددة.",
      "tutorial.step.cameraRecording.title": "سجّل حركة كاميرا مباشرة",
      "tutorial.step.cameraRecording.body": "يبدأ Record عداً تنازلياً ويحوّل حركة الكاميرا التي تنفذها مباشرة إلى keyframes. يمسح REC: Replace اللقطة السابقة، بينما يحافظ REC: Append عليها ويسجّل مروراً جديداً بعد آخر keyframe. مع CLIP SYNC تعمل المقاطع المرتبطة أثناء التصوير. خارج التسجيل يشغّل F7 المعاينة أو يوقفها مؤقتاً؛ وأثناء العد التنازلي أو التسجيل المباشر يوقف F7 العملية. يوقف F8 التسلسل ويعيده إلى البداية.",
      "tutorial.step.cameraKeyframes.title": "تنقّل بين keyframes وعدّل كل واحدة",
      "tutorial.step.cameraKeyframes.body": "اسحب شريط التمرير لفحص وقت دقيق، وانقر على ماسة أو محدد keyframes أو أسهمه لاختيار إطار. يغيّر TIME طابعه الزمني. يتحكم EASING في دخول السرعة وخروجها؛ ويختار PATH مقطع Spline منحنياً أو Linear مباشراً؛ ويحفظ FOV زاوية عدسة لكل keyframe. حرّك الكاميرا ثم استخدم Save frame لتثبيت الوضعية الجديدة.",
      "tutorial.step.cameraTiming.title": "تحكّم في التوقيت والإيقاع والمسار الكامل",
      "tutorial.step.cameraTiming.body": "يضبط SPEED سرعة المعاينة ويُقفل عندما يوفّر مقطع Timeline ميزة CLIP SYNC. يتبع PACING Natural أوقات keyframes المكتوبة، ويحافظ Per segment على سرعة ثابتة داخل كل مقطع، ويوحّد Continuous السرعة على طول المسار كله. يكرر Loop التشغيل؛ ويطابق Close loop الإطار الأخير القريب مع الأول أو يضيف نسخة مطابقة عند الحاجة؛ ويوزّع Distribute الإطارات الوسطية بالتساوي؛ ويُظهر Path المسار في العالم أو يخفيه.",
      "tutorial.step.cameraAttachments.title": "اختر ما ستتبعه الكاميرا",
      "tutorial.step.cameraAttachments.body": "يبقي Anchor gaze to ped (G) العدسة موجهة إلى اللاعب. بعد إخفاء اللوحة باستخدام H، يسمح Free look (N) بالدوران بالفأرة من دون إبقاء RMB مضغوطاً. يسرد Attach to entity مركبات replay وممثلي المشهد والكيانات القريبة؛ ويعيد Refresh فحصها. اختر للـ ped جذر الكيان أو عظمة في الجسم أو السلاح المحمول، وللمركبة عظمة مركبة. يطبّق Attach الرابط ويزيله Detach. عند إخفاء اللوحة يوضح Target pointer الكيان المصوَّب إليه، ويمكن لـ LMB إرفاقه حتى مع تعطيل المؤشر.",
      "tutorial.step.cameraAttachmentMotion.title": "حدّد طريقة حركة الارتباط",
      "tutorial.step.cameraAttachmentMotion.body": "يدور Rigid mount مع الهدف مثل كاميرا غطاء المحرك. يحافظ Lock framing على الموضع والدوران النسبيين بدقة أثناء الانعطاف والميل. عند إيقاف Rigid يضيف Follow softness تأخراً يشبه عمل المصوّر بدلاً من اتصال صلب. يبدأ Auto orbit من التأطير الحالي: يغيّر W/S المسافة، وQ/E الارتفاع، وA/D سرعة المدار. تضبط أشرطة التمرير الثلاثة القيم بدقة، وتعكس السرعة السالبة الاتجاه.",
      "tutorial.step.cameraMovement.title": "اضبط الحركة واستجابة المشغّل",
      "tutorial.step.cameraMovement.body": "تتحكم Sensitivity في إدخال النظر وZoom response في إدخال العدسة. يقرّب Rotation smoothing الكاميرا بسلاسة من الزاوية المطلوبة؛ ويرشّح Mouse smoothing حركات الفأرة المفاجئة؛ ويليّن Movement smoothing بدء الانتقال وتوقفه. يحدد Base speed سرعة الطيران العادية: استخدم Shift للسرعة وCtrl/Alt للدقة. يبدّل Lens بين إعدادات البعد البؤري وFOV؛ يدير RMB الكاميرا، وتقرّب Z/C، ويتحكم Left/Right في الميلان، بينما تغيّر العجلة Base speed.",
      "tutorial.step.cameraFlight.title": "اختر سلوك الطيران المناسب",
      "tutorial.step.cameraFlight.body": "يحوّل Drone mode الإدخال إلى زخم، فتنزلق الكاميرا وتميل بدلاً من أن تتوقف فوراً. يثبت Walk mode العدسة قريباً من مستوى العين فوق الأرض للقطات تشبه حركة المصوّر. يمنع World collision اختراق الجدران والهندسة الصلبة. في الطيران العادي تحرك WASD الكاميرا جانبياً أو للأمام، وتغيّر Q/E الارتفاع؛ وفي المدار تصبح الأدوات نفسها dolly ودوراناً ورافعة.",
      "tutorial.step.cameraImage.title": "اضبط المرشحات والتركيز واهتزاز الكاميرا",
      "tutorial.step.cameraImage.body": "يتنقل Effects بين المرشحات البصرية وتمزج Intensity قوتها. يجب تمكين Depth of field لتؤثر أدواته في الصورة. يركّز Autofocus باستمرار على ما تراه العدسة؛ ويحافظ Follow focus على وضوح الهدف المرتبط؛ وتتاح Distance اليدوية عند إيقاف Autofocus، بينما تتحكم شدة DOF في الضبابية. يفعّل Camera shake نمط اهتزاز قابلاً للاختيار، وتحدد Shake strength سعته.",
      "tutorial.step.cameraScene.title": "حضّر مشهداً نظيفاً ومحكم التأطير",
      "tutorial.step.cameraScene.body": "يعيد Allow player movement مفاتيح WASD إلى الـ ped أو المركبة بينما يحافظ التتبع الذكي على التأطير؛ عطّله عندما تريد تحريك الكاميرا أو تدويرها من جديد. يدير Look at camera رأس اللاعب نحو العدسة. يضيف Cinematic bars نسبة أبعاد قابلة للاختيار؛ وينظف Hide game HUD وHide notifications الإطار. تُعد Rule of thirds وCenter cross وSafe area وInfo overlay أدلة تأليف قابلة لضبط الشدة؛ تبقى عند إخفاء اللوحة بـ H وتختفي أثناء التشغيل.",
      "tutorial.step.cameraOutput.title": "عاين والتقط وأعد الضبط ثم ارجع",
      "tutorial.step.cameraOutput.body": "يبدأ Video تسجيل Rockstar Editor أو يوقفه. يعاين Play/Pause التسلسل ويعيده Stop إلى البداية. يعرض الشريط السفلي السرعة وFOV مباشرة: يبدّل G تثبيت النظر، ويزيل Level الميلان من دون تغيير pitch أو heading، ويعيد R ضبط الكاميرا، ويخفي H اللوحة، ويخرج ESC. تعود Camera المفتوحة من Custom Scene أو Timeline إليها؛ احفظ المشهد أو المشروع الأصلي، أما التسلسلات المستقلة فمؤقتة.",

      "tutorial.step.customScenes.title": "ابدأ Custom Scene",
      "tutorial.step.customScenes.body": "تُفتح Custom Scenes تلقائياً لهذا العرض التوضيحي. في الاستخدام العادي، اختر New Custom Scene، وسمِّ التكوين، وافتح محرره. تجمع Custom Scene إدخالات مستقلة من دون تعديل المكتبات الأصلية.",
      "tutorial.step.customSceneEditor.title": "تعرّف إلى محرر المشهد",
      "tutorial.step.customSceneEditor.body": "يعرض الشريط العلوي اسم التكوين ويوفر Scene Tools وSave وClose. ينظم Scene Tools الطبقات والمجموعات والرؤية والمرفقات؛ ويحفظ Save التكوين بعد أن تصبح إدخالاته وتوقيتها جاهزة.",
      "tutorial.step.customSceneEntries.title": "افهم توقيت كل إدخال واضبطه",
      "tutorial.step.customSceneEntries.body": "تحدد كل بطاقة نوع الإدخال ومصدره وموضعه في العالم. استخدم إجراءات التعديل أو الممثل أو prop أو المرفق عند توفرها. يحدد Delay وقت بدء الإدخال؛ وتوفر الإعدادات المسبقة خيارات سريعة، بينما يقبل Custom قيمة دقيقة.",
      "tutorial.step.customSceneAdd.title": "أضف اللبنات الأساسية",
      "tutorial.step.customSceneAdd.body": "أضف Camera أو Animation أو Scene متزامنة أو Vehicle أو Ped Replay أو Effect أو Object Motion أو Stage Light أو Actor Sequence أو Door Director أو Environment أو Combat Ped. يفتح كل زر أداة الاختيار أو المحرر المتخصص المطابق، ثم يعيد الإدخال المهيأ إلى هنا.",
      "tutorial.step.sceneTools.title": "نظّم المشاهد المعقدة",
      "tutorial.step.sceneTools.body": "يمثل Scene Tools مخطط العناصر في Custom Scenes. استخدم الإدخالات الثابتة والطبقات والمجموعات والرؤية والتحديد والمرفقات والتحويلات والتحقق لإبقاء التكوين الكبير واضحاً وقابلاً للتحرير.",
      "tutorial.step.customScenePlayback.title": "اختبر قبل التسجيل",
      "tutorial.step.customScenePlayback.body": "يعاين TEST التكوين كاملاً من دون إنشاء لقطة. يشغّل ACTION العد التنازلي ويسجّل إلى Rockstar Editor؛ ويسجّل Attach أثناء مرافقة كيان مختار من المشهد، بينما يشارك Nearby التشغيل المتوافق. أوقف المعاينة، وصحح الإدخالات، ثم استخدم Save.",
      "tutorial.step.timeline.title": "افتح مساحة عمل Timeline",
      "tutorial.step.timeline.body": "تُفتح Timeline تلقائياً من دون تحميل مشروع أو تغييره. في الاستخدام العادي، أنشئ مشروعاً أو حمّله، وامنحه اسماً، واحفظ بنيته. تجمع Timeline عدة مقاطع مضبوطة زمنياً عبر مسارات تلقائية.",
      "tutorial.step.timelineLibrary.title": "اختر ما تريد وضعه",
      "tutorial.step.timelineLibrary.body": "تجمع المكتبة الكاميرات والمفضلة والمشاهد والرسوم المتحركة والمؤثرات وعمليات replay والإدخالات المتخصصة. ابحث أولاً، ثم انقر نقراً مزدوجاً على خيار لإضافته عند مؤشر التشغيل أو اسحبه إلى الوقت الدقيق؛ ويُنشأ المسار المطلوب تلقائياً.",
      "tutorial.step.timelineTracks.title": "رتّب المقاطع على المسارات التلقائية",
      "tutorial.step.timelineTracks.body": "تظهر المسارات عند إضافة المقاطع. حرّك المقاطع أو غيّر حجمها لضبط البداية والمدة، واستخدم مؤشر التشغيل والتقريب للدقة، وافتح إعدادات المسار لإعادة تسميته أو ترتيبه أو تغيير حجمه أو جعله منفرداً أو كتمه أو قفله.",
      "tutorial.step.timelineInspector.title": "عدّل المقطع المحدد",
      "tutorial.step.timelineInspector.body": "يؤدي تحديد مقطع إلى فتح الفاحص الخاص به في منطقة Stage. اضبط قيم IN وOUT والمدة وإزاحة المصدر والتكرار والانتقالات بدقة، ثم استخدم Place أو Props أو إعدادات الممثل أو keyframes أو محرره المتداخل عندما يدعم نوع المقطع ذلك.",
      "tutorial.step.timelinePlayback.title": "عاين المونتاج وسجّله",
      "tutorial.step.timelinePlayback.body": "يبدأ Play from من مؤشر التشغيل الحالي؛ ويعاين TEST كامل Timeline من البداية. يشغّل START من البداية مع إخفاء الواجهة، دون عد تنازلي أو تسجيل؛ ويوقف Backspace التشغيل ويعيدك إلى Timeline. يشغّل ACTION العد التنازلي ويسجّل النتيجة المتزامنة. يزامن Nearby المقاطع المتوافقة مع اللاعبين القريبين. عالج التنبيهات واحفظ قبل اللقطة النهائية.",
      "tutorial.step.replays.title": "أعد استخدام الأداء المسجّل",
      "tutorial.step.replays.body": "تلتقط Ghost وPed وVehicle وChase Replay أنواعاً مختلفة من الحركة والأداء. سجّل لقطة نظيفة، وأوقفها وانتظر انتهاء المعالجة، ثم احفظها وأشر إلى ذلك المصدر من Custom Scenes أو Timeline.",
      "tutorial.step.advancedLayers.title": "افتح طبقات التأليف المتخصصة",
      "tutorial.step.advancedLayers.body": "تشمل الإدخالات المتقدمة Object Motion وStage Lighting وActor Sequencer وDoor Director وCamera Sequence وEnvironment والمرفقات. يحتفظ كل محرر بمعاينته الخاصة ويعيد النتيجة إلى المشهد أو Timeline الذي فتحه.",

      "tutorial.step.catalog.title": "ابحث قبل أن تبدأ البناء",
      "tutorial.step.catalog.body": "تستخدم لوحات الكتالوج البحث والفئات والمرشحات والمجلدات والمفضلة وعدد النتائج. ضيّق القائمة أولاً، وافحص البطاقة المحددة، وبعد ذلك فقط افتح الوضع أو التشغيل كي يبقى العالم منظماً.",
      "tutorial.step.safeWorkflow.title": "عاين وتحقق ثم احفظ",
      "tutorial.step.safeWorkflow.body": "تظل معظم تغييرات التأليف مؤقتة إلى أن تؤكدها أو تحفظها. استخدم Preview أو TEST، وأنهِ أي جلسة Freecam/gizmo، وتحقق من التوقيت والأهداف، ثم احفظ؛ يعيدك Esc أو Backspace بأمان من الطبقة النشطة.",
      "tutorial.step.recording.title": "افهم مؤشر REC",
      "tutorial.step.recording.body": "يعرض الشريط السفلي حالة تسجيل Rockstar وتلميح الإغلاق العام. تجهز مسارات ACTION الأصول المشار إليها، وتشغّل العد التنازلي، وتسجّل النتيجة المتزامنة؛ لا تغلق المورد أثناء إنهاء اللقطة.",
      "tutorial.step.cutscenes.title": "Cutscene Player مساحة عمل منفصلة",
      "tutorial.step.cutscenes.body": "اضغط F6 أو استخدم /cutscenes لتصفح مشاهد GTA السينمائية والمفضلة والكتالوجات الاختيارية الجديدة وتجاوزات الممثلين والصوت وHUD والتلاشي وخيارات المشاهد. تبقى منفصلة عن لوحة Director الرئيسية لحماية الإعداد النشط.",
      "tutorial.step.shortcuts.title": "أتقن عناصر التحكم المشتركة",
      "tutorial.step.shortcuts.body": "يفتح F5 واجهة Director. في Freecam الخاصة بالتأليف، اضغط مطولاً RMB واستخدم WASD مع Q/E وShift وCtrl وعجلة الفأرة. في gizmo استخدم W/R وTab وAlt وG وEnter وBackspace؛ ويعرض كل محرر متخصص أيضاً HUD مباشراً خاصاً به.",

      "tutorial.step.finish.title": "أنت جاهز للإخراج",
      "tutorial.step.finish.body": "ابدأ بممثل واحد أو مشهد واحد، وعاين كل طبقة، ولا توسّع الإنتاج إلا بعد التأكد من عمل كل جزء. شغّل /tutorial متى أردت إعادة هذه الجولة؛ وعند إنهائها تبقى واجهة Director مفتوحة كي تبدأ التدريب فوراً."
    },
    vi: {
      "tutorial.title": "Hướng dẫn Director tương tác",
      "tutorial.progress": "Bước {{current}} / {{total}}",
      "tutorial.previous": "Trước",
      "tutorial.next": "Tiếp",
      "tutorial.finish": "Hoàn tất hướng dẫn",
      "tutorial.exit": "Thoát hướng dẫn",
      "tutorial.restart": "Bắt đầu lại",
      "tutorial.chapters": "Các chương",
      "tutorial.keyboardHint": "Dùng phím Trái/Phải để đổi bước và Esc để thoát.",
      "tutorial.safeMode": "Chế độ hướng dẫn: không gian làm việc và bản minh họa tự động mở, nhưng các nút được tô sáng sẽ không bao giờ được kích hoạt.",
      "tutorial.targetUnavailable": "Nút điều khiển này không hiển thị trong bố cục hiện tại. Bạn vẫn có thể tiếp tục an toàn.",
      "tutorial.finishWorkspace": "Hãy hoàn tất hoặc đóng trình chỉnh sửa đang mở trước khi bắt đầu hướng dẫn.",
      "tutorial.helpTitle": "Mở hướng dẫn từng bước",
      "tutorial.languageLabel": "Ngôn ngữ hướng dẫn",

      "tutorial.chapter.orientation": "Làm quen giao diện",
      "tutorial.chapter.library": "Thư viện nội dung của bạn",
      "tutorial.chapter.liveTools": "Công cụ đạo diễn trực tiếp",
      "tutorial.chapter.camera": "Máy quay điện ảnh",
      "tutorial.chapter.customScenes": "Quy trình Custom Scene",
      "tutorial.chapter.timeline": "Biên tập Timeline",
      "tutorial.chapter.authoring": "Xây dựng cảnh hoàn chỉnh",
      "tutorial.chapter.workflow": "Quy trình an toàn và điều khiển",
      "tutorial.chapter.finish": "Sẵn sàng đạo diễn",

      "tutorial.step.welcome.title": "Chào mừng đến với Spectrem Director",
      "tutorial.step.welcome.body": "Chuyến tham quan có hướng dẫn này giải thích toàn bộ quy trình sáng tạo. Nó có thể tự động mở các bản minh họa trực quan, nhưng sẽ không phát, tạo, ghi hình, xóa, lưu hay thay đổi bất cứ thứ gì trong thế giới của bạn.",
      "tutorial.step.header.title": "Không gian làm việc Director của bạn",
      "tutorial.step.header.body": "Thanh tiêu đề tập hợp nhận diện Director, ngôn ngữ, trạng thái danh mục và thông tin phiên chính tại một vị trí cố định. Bảng điều khiển vẫn luôn sẵn sàng khi bạn chuyển giữa các công cụ.",
      "tutorial.step.language.title": "Chọn ngôn ngữ giao diện",
      "tutorial.step.language.body": "Dùng bộ chọn này để đổi ngay ngôn ngữ giao diện hiện tại. Config.Language xác định ngôn ngữ được nạp khi tài nguyên khởi động; tiếng Anh vẫn là lựa chọn mặc định an toàn.",
      "tutorial.step.navigation.title": "Một bản đồ cho mọi công cụ",
      "tutorial.step.navigation.body": "Lưới điều hướng nhóm các thư viện, công cụ điều khiển thế giới trực tiếp và trình biên tập sản xuất. Thẻ được tô sáng cho biết bạn đang ở đâu; quay lại đây không bao giờ xóa công việc đã lưu.",

      "tutorial.step.scenes.title": "Duyệt các cảnh đồng bộ",
      "tutorial.step.scenes.body": "Scenes chứa danh mục cảnh đồng bộ. Hãy tìm kiếm hoặc mở một danh mục, chọn cảnh, gán diễn viên, đặt cảnh vào thế giới, xem trước rồi tái sử dụng trong một Custom Scene.",
      "tutorial.step.favorites.title": "Giữ các cảnh thường dùng trong tầm tay",
      "tutorial.step.favorites.body": "Đánh dấu sao cho một cảnh để đưa nó vào Scenes Fav. Mục yêu thích là thư viện cá nhân truy cập nhanh và không sao chép hay sửa đổi định nghĩa cảnh gốc.",
      "tutorial.step.peds.title": "Xây dựng dàn diễn viên tái sử dụng",
      "tutorial.step.peds.body": "My Peds lưu ngoại hình vào các thư mục. Bạn có thể tạo, chỉnh sửa, nhân bản, đổi tên, sinh ra hoặc hóa thân thành một ped đã lưu, rồi tái sử dụng dàn diễn viên đó trong cảnh, hoạt ảnh, môi trường, replay và rượt đuổi.",
      "tutorial.step.vehicles.title": "Lưu phương tiện sẵn sàng cho sản xuất",
      "tutorial.step.vehicles.body": "My Vehicles ghi lại một phương tiện đã được tải cùng tinh chỉnh, màu sắc, phần bổ sung, đèn, hư hỏng và các trạng thái hình ảnh khác. Preset đã lưu có thể được tạo ra hoặc dùng thay phương tiện trong quy trình Replay và Chase.",
      "tutorial.step.animations.title": "Tìm và đặt hoạt ảnh",
      "tutorial.step.animations.body": "Animations cung cấp tìm kiếm, mục yêu thích, kiểu phát, lặp và bộ lọc vị trí Ground/Fly. Chọn diễn viên, kiểm tra bản xem trước rồi đặt hoặc phát hoạt ảnh ở độ cao thế giới đã được hiệu chỉnh.",
      "tutorial.step.customAnimations.title": "Dùng hoạt ảnh riêng của máy chủ",
      "tutorial.step.customAnimations.body": "Custom Anims liệt kê các dictionary và clip do cấu hình hoặc cầu nối menu hoạt ảnh cung cấp. Chúng dùng cùng quy trình chọn diễn viên, đặt vị trí, lặp và tích hợp vào cảnh như danh mục chính.",

      "tutorial.step.chase.title": "Đạo diễn một cuộc rượt đuổi điện ảnh",
      "tutorial.step.chase.body": "Chase bắt đầu bằng các mặc định cảnh sát an toàn, sau đó cho phép tùy chỉnh đơn vị, phương tiện, tài xế, hành khách, còi báo động, hỗ trợ trên không, hành vi, bảo vệ và vũ khí khi xuống xe. Chase Replay ghi các quỹ đạo phương tiện đồng bộ mà không có hành vi xuống xe và nổ súng.",
      "tutorial.step.density.title": "Điều khiển giao thông nền",
      "tutorial.step.density.body": "Density điều chỉnh người đi bộ, phương tiện đang chạy, phương tiện đỗ, giao thông ngẫu nhiên và tình huống cục bộ. Giá trị thấp làm sạch bối cảnh; giá trị cao tạo nền nhộn nhịp hơn mà không sửa các cảnh đã lưu.",
      "tutorial.step.weather.title": "Tạo dựng thời tiết và thời gian",
      "tutorial.step.weather.body": "Weather & Time điều khiển thời tiết, đồng hồ, tốc độ thời gian, đóng băng thời gian, mất điện, mưa, gió và đèn thành phố. Chọn ghi đè cục bộ cho bối cảnh riêng, hoặc cầu nối máy chủ đã cấu hình khi toàn máy chủ cần áp dụng.",
      "tutorial.step.environment.title": "Dàn dựng NPC làm nền",
      "tutorial.step.environment.body": "Environment tạo các nhóm NPC tái sử dụng với đội hình, model nguồn hoặc thư mục ped đã lưu, số lượng, khoảng cách, phạm vi, giới tính, hoạt ảnh và hướng nhìn. Lưu nhiều môi trường và thêm đúng snapshot vào cảnh hoặc Timeline.",
      "tutorial.step.effects.title": "Đặt và tạo chuyển động cho hiệu ứng",
      "tutorial.step.effects.body": "Effects tìm kiếm tài nguyên hạt và xem trước trực tiếp tỷ lệ, độ trong suốt, màu sắc và trạng thái lặp. Giữ hiệu ứng tại một vị trí trong thế giới hoặc gắn nó vào diễn viên tương thích, rồi lên lịch chính xác trong Custom Scenes hoặc Timeline.",
      "tutorial.step.clubs.title": "Quản lý nội thất và preset câu lạc bộ",
      "tutorial.step.clubs.body": "Clubs lưu preset nội thất điện ảnh, tọa độ và trạng thái IPL/nội thất. Dùng dịch chuyển tức thời để kiểm tra bối cảnh, rồi lưu, cập nhật hoặc xóa preset khi cấu hình thế giới đã chính xác.",
      "tutorial.step.spooner.title": "Tạo và sắp xếp thực thể trong thế giới",
      "tutorial.step.spooner.body": "Object Spooner tìm kiếm ped, prop và phương tiện rồi đặt chúng bằng Freecam và gizmo gốc. Chọn một hoặc nhiều thực thể để biến đổi, nhân bản, gắn, sắp xếp hoặc gửi chúng sang quy trình Director khác.",
      "tutorial.step.camera.title": "Làm quen với không gian Camera điện ảnh",
      "tutorial.step.camera.body": "Hướng dẫn mở không gian minh họa được bảo vệ này mà không khởi động Freecam hay thay đổi thế giới. Khi dùng thật, Camera có thể được mở từ thẻ chính, một mục Camera trong Custom Scene hoặc một clip Camera trên Timeline. H ẩn hoặc hiện lại bảng điều khiển nhưng các phím camera vẫn hoạt động; khi thoát, bạn trở về công cụ đã mở Camera.",
      "tutorial.step.cameraCapture.title": "Chụp và sửa chính xác từng tư thế camera",
      "tutorial.step.cameraCapture.body": "Đặt tên cho chuỗi ở phía trên. Capture (L) thêm vị trí, góc xoay, FOV và cài đặt hình ảnh hiện tại thành keyframe mới; ở cuối một chuỗi độc lập, nó chừa khoảng nối đã cấu hình, còn clip liên kết bị giới hạn theo playhead. Save frame chỉ ghi đè keyframe đã chọn sau khi bạn di chuyển camera. Duplicate đặt bản sao giữa keyframe hiện tại và keyframe kế tiếp, hoặc sau khoảng nối đã cấu hình ở cuối; nút thùng rác xóa keyframe đang chọn.",
      "tutorial.step.cameraRecording.title": "Ghi lại một chuyển động camera trực tiếp",
      "tutorial.step.cameraRecording.body": "Record bắt đầu đếm ngược rồi chuyển chuyển động camera trực tiếp thành các keyframe. REC: Replace xóa lượt quay trước; REC: Append giữ lại và ghi một lượt mới sau keyframe cuối. Với CLIP SYNC, các clip liên kết chạy trong lúc quay. Ngoài chế độ ghi, F7 phát hoặc tạm dừng; trong lúc đếm ngược hay ghi, F7 dừng tác vụ. F8 dừng và tua chuỗi về đầu.",
      "tutorial.step.cameraKeyframes.title": "Rà và chỉnh từng keyframe",
      "tutorial.step.cameraKeyframes.body": "Kéo thanh thời gian để xem đúng một thời điểm; nhấp hình thoi, bộ chọn keyframe hoặc các mũi tên để chọn khung. TIME đổi mốc thời gian. EASING điều khiển cách tốc độ đi vào hoặc rời khung; PATH chọn đoạn cong Spline hoặc đoạn thẳng Linear; FOV lưu góc ống kính riêng cho từng keyframe. Di chuyển camera rồi dùng Save frame để xác nhận tư thế mới.",
      "tutorial.step.cameraTiming.title": "Điều khiển thời gian, nhịp độ và toàn bộ đường đi",
      "tutorial.step.cameraTiming.body": "SPEED nhân tốc độ xem trước và bị khóa khi clip Timeline cung cấp CLIP SYNC. PACING Natural dùng thời gian keyframe đã đặt, Per segment giữ tốc độ đều trong từng đoạn, còn Continuous chia đều tốc độ trên toàn tuyến. Loop lặp lại; Close loop sẽ ghép khung cuối nếu nó đã gần khung đầu, nếu không sẽ thêm một bản sao chính xác; Distribute dàn đều các keyframe giữa; Path hiện hoặc ẩn đường camera trong thế giới.",
      "tutorial.step.cameraAttachments.title": "Chọn đối tượng camera sẽ bám theo",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) giữ ống kính hướng vào người chơi. Sau khi H ẩn bảng, Free look (N) cho phép xoay bằng chuột mà không giữ RMB. Attach to entity liệt kê xe replay, diễn viên trong cảnh và thực thể gần đó; Refresh quét lại danh sách. Với ped, chọn gốc thực thể, xương cơ thể hoặc vũ khí đang cầm; với xe, chọn xương xe. Attach và Detach thêm hoặc bỏ liên kết. Khi bảng đã ẩn, Target pointer đánh dấu thực thể đang ngắm và LMB có thể gắn thực thể đó dù con trỏ bị tắt.",
      "tutorial.step.cameraAttachmentMotion.title": "Chọn cách liên kết chuyển động",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount xoay cùng chủ thể như camera gắn trên nắp ca-pô. Lock framing giữ nguyên chính xác vị trí và góc xoay tương đối khi rẽ hoặc nghiêng. Khi tắt Rigid, Follow softness tạo độ trễ như người quay thay vì gắn cứng. Auto orbit bắt đầu từ bố cục hiện có: W/S đổi khoảng cách, Q/E đổi độ cao và A/D đổi tốc độ quỹ đạo. Ba thanh trượt đặt giá trị chính xác; tốc độ âm đảo chiều quay.",
      "tutorial.step.cameraMovement.title": "Tinh chỉnh chuyển động và phản hồi điều khiển",
      "tutorial.step.cameraMovement.body": "Sensitivity điều khiển thao tác nhìn, Zoom response điều khiển ống kính. Rotation smoothing đưa camera dần tới góc yêu cầu; Mouse smoothing lọc cú lia chuột đột ngột; Movement smoothing làm mượt lúc bắt đầu và dừng tịnh tiến. Base speed đặt tốc độ bay thường: giữ Shift để đi nhanh hoặc Ctrl/Alt để tinh chỉnh. Lens chuyển giữa các tiêu cự và FOV; RMB xoay, Z/C thu phóng, Left/Right điều khiển độ lăn, còn con lăn thay đổi Base speed.",
      "tutorial.step.cameraFlight.title": "Chọn hành vi bay phù hợp",
      "tutorial.step.cameraFlight.body": "Drone mode biến thao tác thành quán tính để camera lướt và nghiêng thay vì dừng ngay. Walk mode giữ ống kính gần tầm mắt trên mặt đất cho cú máy kiểu người quay. World collision ngăn camera xuyên qua tường và hình học đặc. Khi bay thường, WASD di chuyển hoặc trượt ngang và Q/E đổi độ cao; khi quay quanh, các phím này trở thành điều khiển dolly, xoay và cần trục.",
      "tutorial.step.cameraImage.title": "Đặt bộ lọc, tiêu điểm và rung máy",
      "tutorial.step.cameraImage.body": "Effects chuyển qua các bộ lọc hình ảnh và Intensity pha cường độ của chúng. Depth of field phải được bật trước khi các tùy chọn ảnh hưởng đến hình. Autofocus liên tục lấy nét vật ống kính nhìn thấy; Follow focus giữ chủ thể đã gắn luôn nét; Distance thủ công chỉ dùng khi tắt Autofocus, còn DOF Intensity chỉnh độ nhòe. Camera shake bật một kiểu rung có thể chọn và Shake strength đặt biên độ rung.",
      "tutorial.step.cameraScene.title": "Chuẩn bị cảnh sạch và có bố cục",
      "tutorial.step.cameraScene.body": "Allow player movement trả WASD cho nhân vật hoặc phương tiện và camera bám thông minh để giữ bố cục; hãy tắt nó khi cần bay hoặc xoay camera để chỉnh lại. Look at camera quay đầu người chơi về phía ống kính. Cinematic bars thêm tỷ lệ khung có thể chọn; Hide game HUD và Hide notifications làm sạch khung. Rule of thirds, Center cross, Safe area và Info overlay là các đường căn có cường độ chỉnh được; chúng vẫn hiện khi ẩn bảng bằng H và biến mất lúc phát.",
      "tutorial.step.cameraOutput.title": "Xem trước, chụp, đặt lại và quay về",
      "tutorial.step.cameraOutput.body": "Video bắt đầu hoặc dừng ghi Rockstar Editor. Play/Pause xem trước và Stop tua về đầu. Thanh dưới hiển thị tốc độ và FOV: G bật tắt khóa nhìn, Level bỏ độ lăn mà không đổi pitch hay heading, R đặt lại camera, H ẩn bảng, ESC thoát. Camera mở từ Custom Scene hoặc Timeline sẽ quay lại đó để bạn lưu cảnh hay dự án cha; chuỗi độc lập chỉ là tạm thời.",

      "tutorial.step.customScenes.title": "Khởi tạo một Custom Scene",
      "tutorial.step.customScenes.body": "Custom Scenes tự động mở cho phần minh họa này. Khi sử dụng bình thường, hãy chọn New Custom Scene, đặt tên cho bố cục rồi mở trình biên tập. Một Custom Scene kết hợp các mục độc lập mà không sửa đổi những thư viện gốc.",
      "tutorial.step.customSceneEditor.title": "Hiểu trình biên tập cảnh",
      "tutorial.step.customSceneEditor.body": "Phần đầu hiển thị tên bố cục và cung cấp Scene Tools, Save và Close. Scene Tools sắp xếp lớp, bộ sưu tập, khả năng hiển thị và đính kèm; Save lưu bố cục sau khi các mục và thời gian đã sẵn sàng.",
      "tutorial.step.customSceneEntries.title": "Đọc và đặt thời gian cho từng mục",
      "tutorial.step.customSceneEntries.body": "Mỗi thẻ cho biết loại, nguồn và vị trí trong thế giới của mục đó. Dùng các thao tác chỉnh sửa, diễn viên, prop hoặc đính kèm khi có. Delay quyết định thời điểm mục bắt đầu; preset cung cấp lựa chọn nhanh, còn Custom nhận một giá trị chính xác.",
      "tutorial.step.customSceneAdd.title": "Thêm các khối cấu thành",
      "tutorial.step.customSceneAdd.body": "Thêm Camera, Animation, Scene đồng bộ, Vehicle hoặc Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment hoặc Combat Ped. Mỗi nút mở bộ chọn hay trình biên tập chuyên dụng tương ứng rồi đưa mục đã cấu hình trở lại đây.",
      "tutorial.step.sceneTools.title": "Sắp xếp các cảnh phức tạp",
      "tutorial.step.sceneTools.body": "Scene Tools là bảng phân cấp của Custom Scenes. Dùng các mục ổn định, lớp, bộ sưu tập, khả năng hiển thị, lựa chọn, đính kèm, biến đổi và xác thực để giữ một bố cục lớn dễ hiểu và dễ chỉnh sửa.",
      "tutorial.step.customScenePlayback.title": "Kiểm tra trước khi ghi",
      "tutorial.step.customScenePlayback.body": "TEST xem trước toàn bộ bố cục mà không tạo một lượt ghi. ACTION chạy đếm ngược và ghi vào Rockstar Editor; Attach ghi trong khi bám theo một thực thể cảnh đã chọn, còn Nearby chia sẻ chế độ phát tương thích. Dừng bản xem trước, sửa các mục rồi dùng Save.",
      "tutorial.step.timeline.title": "Mở không gian Timeline",
      "tutorial.step.timeline.body": "Timeline tự động mở mà không tải hay thay đổi dự án. Khi sử dụng bình thường, hãy tạo hoặc tải một dự án, đặt tên và lưu cấu trúc của nó. Timeline kết hợp nhiều clip được định thời trên các rãnh tự động.",
      "tutorial.step.timelineLibrary.title": "Chọn nội dung cần đặt",
      "tutorial.step.timelineLibrary.body": "Thư viện nhóm máy quay, mục yêu thích, cảnh, hoạt ảnh, hiệu ứng, replay và các mục chuyên dụng. Tìm kiếm trước, sau đó nhấp đúp một lựa chọn để thêm tại đầu phát hoặc kéo nó đến đúng thời điểm; rãnh cần thiết được tạo tự động.",
      "tutorial.step.timelineTracks.title": "Sắp xếp clip trên các rãnh tự động",
      "tutorial.step.timelineTracks.body": "Các rãnh xuất hiện khi clip được thêm. Di chuyển hoặc đổi kích thước clip để đặt thời điểm bắt đầu và thời lượng, dùng đầu phát cùng thu phóng để tinh chỉnh, rồi mở cài đặt rãnh để đổi tên, sắp xếp lại, đổi kích thước, solo, tắt tiếng hoặc khóa rãnh.",
      "tutorial.step.timelineInspector.title": "Chỉnh sửa clip đã chọn",
      "tutorial.step.timelineInspector.body": "Chọn một clip sẽ mở trình kiểm tra của nó trong vùng Stage. Đặt chính xác IN, OUT, thời lượng, độ lệch nguồn, lặp và chuyển cảnh, rồi dùng Place, Props, cài đặt diễn viên, keyframe hoặc trình biên tập lồng nhau khi loại clip hỗ trợ.",
      "tutorial.step.timelinePlayback.title": "Xem trước và ghi bản dựng",
      "tutorial.step.timelinePlayback.body": "Play from bắt đầu tại đầu phát hiện tại; TEST xem trước toàn bộ Timeline từ đầu. START phát từ đầu với giao diện ẩn, không đếm ngược hay ghi hình; Backspace dừng phát và quay lại Timeline. ACTION đếm ngược và ghi kết quả đồng bộ. Nearby đồng bộ các clip tương thích với người chơi ở gần. Khắc phục chẩn đoán và lưu trước lượt ghi cuối.",
      "tutorial.step.replays.title": "Tái sử dụng phần trình diễn đã ghi",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle và Chase Replay ghi lại các kiểu chuyển động và hành động khác nhau. Ghi một lượt sạch, dừng và chờ xử lý xong, lưu lại rồi tham chiếu nguồn đó từ Custom Scenes hoặc Timeline.",
      "tutorial.step.advancedLayers.title": "Mở các lớp biên soạn chuyên dụng",
      "tutorial.step.advancedLayers.body": "Các mục nâng cao gồm Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment và đính kèm. Mỗi trình biên tập giữ bản xem trước riêng và trả kết quả về cảnh hoặc Timeline đã mở nó.",

      "tutorial.step.catalog.title": "Tìm kiếm trước khi xây dựng",
      "tutorial.step.catalog.body": "Các bảng danh mục sử dụng tìm kiếm, danh mục, bộ lọc, thư mục, mục yêu thích và số lượng kết quả. Hãy thu hẹp danh sách trước, kiểm tra thẻ đã chọn rồi mới mở chế độ đặt hoặc phát để giữ thế giới gọn gàng.",
      "tutorial.step.safeWorkflow.title": "Xem trước, kiểm tra rồi lưu",
      "tutorial.step.safeWorkflow.body": "Hầu hết thay đổi biên soạn chỉ là tạm thời cho đến khi bạn xác nhận hoặc lưu. Dùng Preview hoặc TEST, kết thúc mọi phiên Freecam/gizmo, kiểm tra thời gian và mục tiêu rồi lưu; Esc hoặc Backspace sẽ đưa bạn trở về an toàn từ lớp đang hoạt động.",
      "tutorial.step.recording.title": "Hiểu chỉ báo REC",
      "tutorial.step.recording.body": "Chân trang hiển thị trạng thái ghi hình Rockstar và gợi ý đóng chung. Quy trình ACTION chuẩn bị tài nguyên được tham chiếu, chạy đếm ngược và ghi kết quả đồng bộ; đừng đóng tài nguyên khi một lượt quay đang được hoàn tất.",
      "tutorial.step.cutscenes.title": "Cutscene Player là một không gian riêng",
      "tutorial.step.cutscenes.body": "Nhấn F6 hoặc dùng /cutscenes để duyệt cutscene GTA, mục yêu thích, danh mục tùy chọn mới, ghi đè diễn viên, âm thanh, HUD, hiệu ứng mờ dần và tùy chọn khán giả. Nó tách khỏi bảng Director chính để bảo vệ thiết lập đang hoạt động.",
      "tutorial.step.shortcuts.title": "Làm chủ các điều khiển dùng chung",
      "tutorial.step.shortcuts.body": "F5 mở Director. Trong Freecam biên soạn, giữ RMB và dùng WASD cùng Q/E, Shift, Ctrl và con lăn chuột. Trong gizmo, dùng W/R, Tab, Alt, G, Enter và Backspace; mỗi trình biên tập chuyên dụng cũng hiển thị HUD trực tiếp riêng.",

      "tutorial.step.finish.title": "Bạn đã sẵn sàng đạo diễn",
      "tutorial.step.finish.body": "Hãy bắt đầu với một diễn viên hoặc một cảnh, xem trước từng lớp và chỉ mở rộng sản phẩm sau khi mỗi phần hoạt động tốt. Chạy /tutorial bất cứ khi nào muốn xem lại hướng dẫn; khi hoàn tất, Director vẫn mở để bạn thực hành ngay."
    },
    de: {
      "tutorial.title": "Interaktives Director-Tutorial",
      "tutorial.progress": "Schritt {{current}} von {{total}}",
      "tutorial.previous": "Zurück",
      "tutorial.next": "Weiter",
      "tutorial.finish": "Tutorial beenden",
      "tutorial.exit": "Tutorial verlassen",
      "tutorial.restart": "Neu starten",
      "tutorial.chapters": "Kapitel",
      "tutorial.keyboardHint": "Wechsle mit Links/Rechts zwischen den Schritten und beende das Tutorial mit Esc.",
      "tutorial.safeMode": "Geführte Ansicht: Arbeitsbereiche und Demonstrationen werden automatisch geöffnet, die hervorgehobenen Bedienelemente jedoch niemals aktiviert.",
      "tutorial.targetUnavailable": "Dieses Bedienelement ist im aktuellen Layout nicht sichtbar. Du kannst sicher fortfahren.",
      "tutorial.finishWorkspace": "Beende oder schließe den aktiven Editor, bevor du das Tutorial startest.",
      "tutorial.helpTitle": "Geführtes Tutorial öffnen",
      "tutorial.languageLabel": "Sprache des Tutorials",

      "tutorial.chapter.orientation": "Erste Orientierung",
      "tutorial.chapter.library": "Deine Inhaltsbibliotheken",
      "tutorial.chapter.liveTools": "Live-Regiewerkzeuge",
      "tutorial.chapter.camera": "Filmische Kamera",
      "tutorial.chapter.customScenes": "Custom-Scene-Workflow",
      "tutorial.chapter.timeline": "Timeline-Bearbeitung",
      "tutorial.chapter.authoring": "Erweiterte Authoring-Werkzeuge",
      "tutorial.chapter.workflow": "Sicherer Arbeitsablauf und Steuerung",
      "tutorial.chapter.finish": "Bereit für die Regie",

      "tutorial.step.welcome.title": "Willkommen bei Spectrem Director",
      "tutorial.step.welcome.body": "Diese geführte Tour erklärt den vollständigen Creator-Workflow. Sie kann automatisch visuelle Demonstrationen öffnen, spielt jedoch nichts ab, spawnt nichts, zeichnet nichts auf, löscht oder speichert nichts und verändert nichts in deiner Welt.",
      "tutorial.step.header.title": "Dein Director-Arbeitsbereich",
      "tutorial.step.header.body": "Die Kopfzeile bündelt Director-Identität, Sprache, Katalogstatus und die wichtigsten Sitzungsinformationen an einem festen Ort. Das Panel bleibt verfügbar, während du zwischen Werkzeugen wechselst.",
      "tutorial.step.language.title": "Wähle die Sprache der Oberfläche",
      "tutorial.step.language.body": "Mit diesem Auswahlfeld wechselst du sofort die aktuelle Sprache der Oberfläche. Config.Language legt fest, welche Sprache beim Start der Ressource geladen wird; Englisch bleibt die sichere Standardsprache.",
      "tutorial.step.navigation.title": "Eine Übersicht für alle Werkzeuge",
      "tutorial.step.navigation.body": "Das Navigationsraster gruppiert Bibliotheken, Live-Weltsteuerungen und Produktionseditoren. Der hervorgehobene Tab zeigt deinen aktuellen Bereich; eine Rückkehr hierher löscht niemals gespeicherte Arbeit.",

      "tutorial.step.scenes.title": "Durchsuche synchronisierte Szenen",
      "tutorial.step.scenes.body": "Scenes enthält den Katalog synchronisierter Szenen. Suche oder öffne eine Kategorie, wähle eine Szene, weise ihre Actors zu, platziere sie in der Welt, prüfe die Vorschau und verwende sie anschließend in einer Custom Scene erneut.",
      "tutorial.step.favorites.title": "Halte häufig verwendete Szenen griffbereit",
      "tutorial.step.favorites.body": "Markiere eine Szene mit dem Stern, um sie in Scenes Fav abzulegen. Favoriten bilden eine schnelle persönliche Bibliothek und duplizieren oder verändern die ursprüngliche Szenendefinition nicht.",
      "tutorial.step.peds.title": "Stelle eine wiederverwendbare Besetzung zusammen",
      "tutorial.step.peds.body": "My Peds speichert Erscheinungsbilder in Ordnern. Erstelle, bearbeite, klone, benenne oder spawne einen gespeicherten Ped oder übernimm dessen Modell. Verwende diese Besetzung danach in Szenen, Animationen, Environments, Replays und Chases.",
      "tutorial.step.vehicles.title": "Speichere produktionsfertige Fahrzeuge",
      "tutorial.step.vehicles.body": "My Vehicles erfasst ein geladenes Fahrzeug mit Tuning, Farben, Extras, Beleuchtung, Schäden und weiterem visuellen Zustand. Gespeicherte Presets lassen sich spawnen oder zum Ersetzen von Fahrzeugen in Replay- und Chase-Abläufen verwenden.",
      "tutorial.step.animations.title": "Finde und platziere Animationen",
      "tutorial.step.animations.body": "Animations bietet Suche, Favoriten, Wiedergabeart, Loop sowie Ground/Fly-Platzierungsfilter. Wähle den Actor, prüfe die Vorschau und platziere oder spiele die Animation anschließend auf der korrigierten Welthöhe ab.",
      "tutorial.step.customAnimations.title": "Nutze serverspezifische Animationen",
      "tutorial.step.customAnimations.body": "Custom Anims zeigt Dictionaries und Clips aus deiner Konfiguration oder der Animation-Menu-Bridge. Für Actor-Auswahl, Platzierung, Loop und Szenenintegration gilt derselbe Ablauf wie im Hauptkatalog.",

      "tutorial.step.chase.title": "Inszeniere eine filmreife Verfolgungsjagd",
      "tutorial.step.chase.body": "Chase startet mit sicheren Polizeivorgaben und ermöglicht anschließend die Anpassung von Einheiten, Fahrzeugen, Fahrern, Passagieren, Sirenen, Luftunterstützung, Verhalten, Schutz und Waffen nach dem Aussteigen. Chase Replay zeichnet synchronisierte Fahrzeugrouten ohne Aussteigen-und-Schießen-Verhalten auf.",
      "tutorial.step.density.title": "Steuere den Hintergrundverkehr",
      "tutorial.step.density.body": "Density passt lokale Fußgänger, fahrende und geparkte Fahrzeuge, Zufallsverkehr sowie Szenarien an. Niedrige Werte räumen das Set auf, höhere Werte schaffen einen belebteren Hintergrund, ohne deine gespeicherten Szenen zu bearbeiten.",
      "tutorial.step.weather.title": "Gestalte Wetter und Tageszeit",
      "tutorial.step.weather.body": "Weather & Time steuert Wetter, Uhrzeit, Zeitgeschwindigkeit, Einfrieren, Blackout, Regen, Wind und Stadtbeleuchtung. Verwende lokale Overrides für ein privates Set oder die konfigurierte Server-Bridge, wenn die Einstellungen für den gesamten Server gelten sollen.",
      "tutorial.step.environment.title": "Inszeniere NPCs im Hintergrund",
      "tutorial.step.environment.body": "Environment erstellt wiederverwendbare NPC-Gruppen mit Formationen, Quellmodellen oder Ordnern gespeicherter Peds, Anzahl, Abstand, Ausdehnung, Geschlecht, Animation und Blickrichtung. Speichere mehrere Environments und füge den exakten Snapshot einer Szene oder Timeline hinzu.",
      "tutorial.step.effects.title": "Platziere und animiere Effekte",
      "tutorial.step.effects.body": "Effects durchsucht Partikel-Assets und zeigt Skalierung, Alpha, Farbe und Loop-Status live in der Vorschau. Belasse einen Effekt an einer Weltposition oder hänge ihn an einen kompatiblen Actor und plane ihn anschließend präzise in Custom Scenes oder Timeline ein.",
      "tutorial.step.clubs.title": "Verwalte Innenräume und Club-Presets",
      "tutorial.step.clubs.body": "Clubs speichert filmische Innenraum-Presets, Koordinaten sowie IPL- und Interior-Status. Teleportiere dich zur Kontrolle in das Set und speichere, aktualisiere oder lösche das Preset, sobald seine Weltkonfiguration stimmt.",
      "tutorial.step.spooner.title": "Spawne und arrangiere Weltobjekte",
      "tutorial.step.spooner.body": "Object Spooner durchsucht Peds, Props und Fahrzeuge und platziert sie per Freecam und nativem Gizmo. Wähle eine oder mehrere Entitäten aus, um sie zu transformieren, zu klonen, anzuhängen, zu organisieren oder an einen anderen Director-Ablauf zu übergeben.",
      "tutorial.step.camera.title": "Lerne den filmischen Camera-Arbeitsbereich kennen",
      "tutorial.step.camera.body": "Das Tutorial öffnet diesen geschützten visuellen Arbeitsbereich, ohne Freecam zu starten oder die Welt zu verändern. Im normalen Betrieb kann Camera über den Haupt-Tab, einen Camera-Eintrag in Custom Scene oder einen Camera-Clip in Timeline geöffnet werden. H blendet das Panel aus oder wieder ein, während die Kamerasteuerung aktiv bleibt; beim Verlassen kehrst du zum aufrufenden Werkzeug zurück.",
      "tutorial.step.cameraCapture.title": "Erfasse und korrigiere exakte Kameraposen",
      "tutorial.step.cameraCapture.body": "Benenne oben die Sequenz. Capture (L) fügt Position, Rotation, FOV und Bildeinstellungen als neuen Keyframe ein; am Ende einer eigenständigen Sequenz wird der konfigurierte Append-Abstand genutzt, bei einem verknüpften Clip gilt dessen Playhead. Save frame überschreibt nach dem Bewegen nur den gewählten Keyframe. Duplicate setzt eine Kopie zwischen diesen und den nächsten Keyframe oder am Ende hinter den Append-Abstand; der Papierkorb löscht den gewählten Keyframe.",
      "tutorial.step.cameraRecording.title": "Zeichne eine Kamerafahrt live auf",
      "tutorial.step.cameraRecording.body": "Record startet einen Countdown und wandelt die live ausgeführte Kamerabewegung in Keyframes um. REC: Replace löscht den vorigen Take; REC: Append behält ihn und zeichnet einen weiteren Durchlauf nach dem letzten Keyframe auf. Mit CLIP SYNC laufen verknüpfte Clips während der Aufnahme. Außerhalb einer Aufnahme startet oder pausiert F7 die Vorschau; während Countdown oder Aufnahme beendet F7 den Vorgang. F8 stoppt und spult zum Anfang zurück.",
      "tutorial.step.cameraKeyframes.title": "Navigiere und bearbeite einzelne Keyframes",
      "tutorial.step.cameraKeyframes.body": "Ziehe den Scrubber zu einem exakten Zeitpunkt und wähle über Diamant, Keyframe-Auswahl oder Pfeile ein Bild. TIME ändert dessen Zeitstempel. EASING bestimmt den Geschwindigkeitsverlauf hinein und hinaus; PATH wählt einen gebogenen Spline- oder direkten Linear-Abschnitt; FOV speichert je Keyframe einen Bildwinkel. Bewege die Kamera und bestätige die neue Pose anschließend mit Save frame.",
      "tutorial.step.cameraTiming.title": "Steuere Timing, Tempo und den gesamten Pfad",
      "tutorial.step.cameraTiming.body": "SPEED skaliert die Vorschau und ist gesperrt, wenn ein Timeline-Clip CLIP SYNC liefert. PACING Natural folgt den gesetzten Keyframe-Zeiten, Per segment hält das Tempo je Abschnitt konstant und Continuous verteilt es gleichmäßig über die ganze Route. Loop wiederholt; Close loop rastet einen bereits nahen letzten Frame am ersten ein oder hängt sonst dessen exakte Kopie an; Distribute verteilt mittlere Keyframes gleichmäßig; Path zeigt oder verbirgt die Route in der Welt.",
      "tutorial.step.cameraAttachments.title": "Wähle, welchem Objekt die Kamera folgt",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) hält das Objektiv auf den Spieler gerichtet. Nachdem H das Panel ausblendet, dreht Free look (N) per Maus ohne gehaltene RMB. Attach to entity listet Replay-Fahrzeuge, Szenendarsteller und nahe Entities; Refresh scannt neu. Wähle bei Peds Entity-Wurzel, Körperknochen oder gehaltene Waffe, bei Fahrzeugen einen Fahrzeugknochen. Attach und Detach setzen oder lösen die Verbindung. Bei verborgenem Panel markiert Target pointer das anvisierte Objekt, und LMB kann es auch bei ausgeschaltetem Zeiger anhängen.",
      "tutorial.step.cameraAttachmentMotion.title": "Bestimme das Bewegungsverhalten eines Attachments",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount dreht wie eine Motorhaubenkamera mit dem Motiv. Lock framing bewahrt in Kurven und Schräglagen exakt die relative Position und Rotation. Bei ausgeschaltetem Rigid erzeugt Follow softness einen natürlichen Operator-Nachlauf statt einer starren Verbindung. Auto orbit beginnt mit dem vorhandenen Bildausschnitt: W/S ändert Abstand, Q/E Höhe und A/D Umlaufgeschwindigkeit. Die drei Regler setzen genaue Werte; eine negative Geschwindigkeit kehrt die Richtung um.",
      "tutorial.step.cameraMovement.title": "Stimme Bewegung und Bedienreaktion ab",
      "tutorial.step.cameraMovement.body": "Sensitivity steuert die Blick-, Zoom response die Objektiveingabe. Rotation smoothing führt weich zum angeforderten Winkel; Mouse smoothing filtert ruckartige Mausbewegungen; Movement smoothing glättet Start und Ende der Verschiebung. Base speed setzt das normale Flugtempo: Shift beschleunigt, Ctrl/Alt ermöglicht Präzision. Lens wechselt Brennweiten und FOV; RMB dreht, Z/C zoomt, Left/Right rollt und das Mausrad verändert Base speed.",
      "tutorial.step.cameraFlight.title": "Wähle das passende Flugverhalten",
      "tutorial.step.cameraFlight.body": "Drone mode macht Eingaben zu Impuls, sodass die Kamera gleitet und sich in Kurven neigt, statt sofort zu stoppen. Walk mode hält das Objektiv für Operator-Aufnahmen nahe der Augenhöhe über dem Boden. World collision verhindert das Durchqueren von Wänden und fester Geometrie. Im normalen Flug bewegen oder strafen WASD und Q/E ändert die Höhe; im Orbit werden dieselben Tasten zu Dolly-, Dreh- und Kransteuerung.",
      "tutorial.step.cameraImage.title": "Stelle Filter, Fokus und Kamerawackeln ein",
      "tutorial.step.cameraImage.body": "Effects wechselt den Bildfilter, Intensity mischt dessen Stärke. Depth of field muss aktiviert sein, bevor die Regler das Bild beeinflussen. Autofocus fokussiert laufend das Sichtziel; Follow focus hält ein angehängtes Motiv scharf; bei ausgeschaltetem Autofocus steht Distance manuell bereit, und DOF Intensity regelt die Unschärfe. Camera shake aktiviert ein wählbares Wackel-Preset, Shake strength bestimmt dessen Amplitude.",
      "tutorial.step.cameraScene.title": "Bereite eine saubere, komponierte Szene vor",
      "tutorial.step.cameraScene.body": "Allow player movement gibt WASD an Ped oder Fahrzeug zurück; Smart Follow bewahrt den Bildausschnitt. Schalte es zum erneuten Fliegen oder Ausrichten der Kamera aus. Look at camera dreht den Kopf des Spielers zum Objektiv. Cinematic bars fügt ein wählbares Seitenverhältnis hinzu; Hide game HUD und Hide notifications bereinigen das Bild. Rule of thirds, Center cross, Safe area und Info overlay sind Hilfen mit einstellbarer Stärke: Sie bleiben bei H sichtbar und verschwinden während der Wiedergabe.",
      "tutorial.step.cameraOutput.title": "Prüfe, erfasse, setze zurück und kehre zurück",
      "tutorial.step.cameraOutput.body": "Video startet oder stoppt eine Rockstar-Editor-Aufnahme. Play/Pause zeigt die Vorschau, Stop spult zum Anfang. Die Fußzeile zeigt Tempo und FOV: G schaltet Blickanker, Level entfernt Roll ohne Pitch oder Heading zu ändern, R setzt zurück, H verbirgt das Panel, ESC verlässt Camera. Aus Custom Scene oder Timeline geöffnete Cameras kehren dorthin zurück; speichere die übergeordnete Szene oder das Projekt. Eigenständige Sequenzen sind temporär.",

      "tutorial.step.customScenes.title": "Komponiere eine vollständige Custom Scene",
      "tutorial.step.customScenes.body": "Custom Scenes öffnet sich für diese Demonstration automatisch. Im normalen Betrieb wählst du New Custom Scene, benennst die Komposition und öffnest ihren Editor. Eine Custom Scene kombiniert unabhängige Einträge, ohne die ursprünglichen Bibliotheken zu verändern.",
      "tutorial.step.customSceneEditor.title": "Verstehe den Szeneneditor",
      "tutorial.step.customSceneEditor.body": "Die Kopfzeile nennt die Komposition und bietet Scene Tools, Save und Close. Scene Tools organisiert Ebenen, Sammlungen, Sichtbarkeit und Attachments; Save speichert die Komposition, sobald ihre Einträge und Zeitabläufe bereit sind.",
      "tutorial.step.customSceneEntries.title": "Lies und plane jeden Eintrag",
      "tutorial.step.customSceneEntries.body": "Jede Karte zeigt Typ, Quelle und Weltplatzierung. Nutze, sofern verfügbar, ihre Aktionen für Bearbeitung, Actor, Prop oder Attachment. Delay bestimmt den Startzeitpunkt des Eintrags; Presets sind schnelle Optionen, und Custom akzeptiert einen exakten Wert.",
      "tutorial.step.customSceneAdd.title": "Füge die Bausteine hinzu",
      "tutorial.step.customSceneAdd.body": "Füge Camera, Animation, eine synchronisierte Scene, Vehicle oder Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment oder Combat Ped hinzu. Jede Schaltfläche öffnet den passenden Picker oder spezialisierten Editor und bringt den konfigurierten Eintrag anschließend hierher zurück.",
      "tutorial.step.sceneTools.title": "Organisiere komplexe Szenen",
      "tutorial.step.sceneTools.body": "Scene Tools ist der Outliner für Custom Scenes. Nutze stabile Einträge, Ebenen, Sammlungen, Sichtbarkeit, Auswahl, Anhänge, Transformationen und Validierung, damit eine große Komposition verständlich und bearbeitbar bleibt.",
      "tutorial.step.customScenePlayback.title": "Teste vor der Aufnahme",
      "tutorial.step.customScenePlayback.body": "TEST zeigt die vollständige Komposition in der Vorschau, ohne einen Take zu erstellen. ACTION startet den Countdown und zeichnet für Rockstar Editor auf; Attach zeichnet mit einer ausgewählten Szenenentität mitfahrend auf, und Nearby teilt eine kompatible Wiedergabe. Stoppe die Vorschau, korrigiere die Einträge und speichere dann.",
      "tutorial.step.timeline.title": "Bearbeite die Produktion auf einer Timeline",
      "tutorial.step.timeline.body": "Timeline öffnet sich automatisch, ohne ein Projekt zu laden oder zu verändern. Im normalen Betrieb erstellst oder lädst du ein Projekt, gibst ihm einen Namen und speicherst seine Struktur. Timeline kombiniert viele zeitlich angeordnete Clips auf automatisch erstellten Spuren.",
      "tutorial.step.timelineLibrary.title": "Wähle aus, was du platzieren möchtest",
      "tutorial.step.timelineLibrary.body": "Die Bibliothek gruppiert Kameras, Favoriten, Szenen, Animationen, Effekte, Replays und spezialisierte Einträge. Suche zuerst; doppelklicke dann auf eine Option, um sie am Playhead einzufügen, oder ziehe sie auf den exakten Zeitpunkt. Die benötigte Spur wird automatisch erstellt.",
      "tutorial.step.timelineTracks.title": "Ordne Clips auf automatischen Spuren an",
      "tutorial.step.timelineTracks.body": "Spuren erscheinen, sobald Clips hinzugefügt werden. Verschiebe Clips oder ändere ihre Größe, um Start und Dauer festzulegen, nutze Playhead und Zoom für Präzision und öffne die Spureinstellungen, um eine Spur umzubenennen, neu anzuordnen, in der Größe zu ändern, solo zu schalten, stummzuschalten oder zu sperren.",
      "tutorial.step.timelineInspector.title": "Bearbeite den ausgewählten Clip",
      "tutorial.step.timelineInspector.body": "Wenn du einen Clip auswählst, öffnet sich sein Inspector im Bühnenbereich. Lege IN, OUT, Dauer, Quellen-Offset, Loop und Übergänge exakt fest und nutze anschließend Place, Props, Actor-Einstellungen, Keyframes oder den verschachtelten Editor, sofern der Clip-Typ dies unterstützt.",
      "tutorial.step.timelinePlayback.title": "Prüfe und zeichne den Schnitt auf",
      "tutorial.step.timelinePlayback.body": "Play from startet am aktuellen Playhead; TEST zeigt die vollständige Timeline von Anfang an. START spielt von Anfang an mit ausgeblendeter Oberfläche, ohne Countdown oder Aufnahme; Backspace stoppt die Wiedergabe und kehrt zur Timeline zurück. ACTION startet den Countdown und zeichnet das synchronisierte Ergebnis auf. Nearby synchronisiert kompatible Clips mit Spielern in der Nähe. Behebe Diagnosen und speichere vor dem finalen Take.",
      "tutorial.step.replays.title": "Verwende aufgezeichnete Darbietungen erneut",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle und Chase Replay erfassen unterschiedliche Bewegungs- und Aktionsarten. Zeichne einen sauberen Take auf, stoppe ihn und warte die Verarbeitung ab, speichere ihn und referenziere diese Quelle danach aus Custom Scenes oder Timeline.",
      "tutorial.step.advancedLayers.title": "Öffne spezialisierte Bearbeitungsebenen",
      "tutorial.step.advancedLayers.body": "Zu den erweiterten Einträgen gehören Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment und Anhänge. Jeder Editor behält seine eigene Vorschau und gibt das Ergebnis an die Szene oder Timeline zurück, aus der er geöffnet wurde.",

      "tutorial.step.catalog.title": "Suche, bevor du etwas erstellst",
      "tutorial.step.catalog.body": "Katalog-Panels verwenden Suche, Kategorien, Filter, Ordner, Favoriten und Ergebniszahlen. Grenze zuerst die Liste ein, prüfe die ausgewählte Karte und öffne erst danach Platzierung oder Wiedergabe, damit die Welt aufgeräumt bleibt.",
      "tutorial.step.safeWorkflow.title": "Vorschau prüfen, kontrollieren, speichern",
      "tutorial.step.safeWorkflow.body": "Die meisten Bearbeitungsänderungen bleiben bis zur Bestätigung oder zum Speichern vorläufig. Nutze Preview oder TEST, beende jede Freecam-/Gizmo-Sitzung, prüfe Timing und Ziele und speichere dann; mit Esc oder Backspace kehrst du sicher aus der aktiven Ebene zurück.",
      "tutorial.step.recording.title": "Verstehe die REC-Anzeige",
      "tutorial.step.recording.body": "Die Fußzeile zeigt den Rockstar-Aufnahmestatus und den globalen Schließhinweis. ACTION-Abläufe bereiten referenzierte Assets vor, starten den Countdown und zeichnen das synchronisierte Ergebnis auf; schließe die Ressource nicht, während ein Take finalisiert wird.",
      "tutorial.step.cutscenes.title": "Cutscene Player ist ein eigener Arbeitsbereich",
      "tutorial.step.cutscenes.body": "Drücke F6 oder verwende /cutscenes, um GTA-Cutscenes, Favoriten, neue optionale Kataloge, Actor-Overrides, Audio, HUD, Blenden und Zuschaueroptionen zu durchsuchen. Der Bereich bleibt vom Director-Hauptpanel getrennt, damit das aktive Setup geschützt wird.",
      "tutorial.step.shortcuts.title": "Beherrsche die gemeinsamen Steuerungen",
      "tutorial.step.shortcuts.body": "F5 öffnet Director. Halte in der Bearbeitungs-Freecam RMB gedrückt und nutze WASD mit Q/E, Shift, Ctrl und dem Mausrad. Im Gizmo verwendest du W/R, Tab, Alt, G, Enter und Backspace; jeder spezialisierte Editor zeigt außerdem sein eigenes Live-HUD.",

      "tutorial.step.finish.title": "Du bist bereit für die Regie",
      "tutorial.step.finish.body": "Beginne mit einem Actor oder einer Szene, prüfe jede Ebene in der Vorschau und erweitere die Produktion erst, wenn jeder Teil funktioniert. Starte /tutorial jederzeit erneut, wenn du diese geführte Tour wiederholen möchtest; nach dem Abschluss bleibt Director geöffnet, damit du sofort üben kannst."
    },
    pl: {
      "tutorial.title": "Interaktywny samouczek Director",
      "tutorial.progress": "Krok {{current}} z {{total}}",
      "tutorial.previous": "Wstecz",
      "tutorial.next": "Dalej",
      "tutorial.finish": "Zakończ samouczek",
      "tutorial.exit": "Wyjdź z samouczka",
      "tutorial.restart": "Uruchom ponownie",
      "tutorial.chapters": "Rozdziały",
      "tutorial.keyboardHint": "Użyj strzałek w lewo/w prawo, aby zmieniać kroki, oraz Esc, aby wyjść.",
      "tutorial.safeMode": "Widok z przewodnikiem: obszary robocze i prezentacje otwierają się automatycznie, ale wyróżnione elementy sterujące nigdy nie są uruchamiane.",
      "tutorial.targetUnavailable": "Ten element sterujący nie jest widoczny w bieżącym układzie. Możesz bezpiecznie przejść dalej.",
      "tutorial.finishWorkspace": "Przed uruchomieniem samouczka zakończ pracę w aktywnym edytorze lub go zamknij.",
      "tutorial.helpTitle": "Otwórz samouczek z przewodnikiem",
      "tutorial.languageLabel": "Język samouczka",

      "tutorial.chapter.orientation": "Poznaj interfejs",
      "tutorial.chapter.library": "Twoje biblioteki zawartości",
      "tutorial.chapter.liveTools": "Narzędzia reżyserii na żywo",
      "tutorial.chapter.camera": "Kamera filmowa",
      "tutorial.chapter.customScenes": "Proces Custom Scene",
      "tutorial.chapter.timeline": "Montaż na Timeline",
      "tutorial.chapter.authoring": "Zaawansowane narzędzia autorskie",
      "tutorial.chapter.workflow": "Bezpieczny przebieg pracy i sterowanie",
      "tutorial.chapter.finish": "Gotowy do reżyserowania",

      "tutorial.step.welcome.title": "Witamy w Spectrem Director",
      "tutorial.step.welcome.body": "Ta prezentacja z przewodnikiem objaśnia cały proces twórczy. Może automatycznie otwierać wizualne demonstracje, ale nie odtworzy, nie przywoła, nie nagra, nie usunie, nie zapisze ani nie zmieni niczego w Twoim świecie.",
      "tutorial.step.header.title": "Twój obszar roboczy Director",
      "tutorial.step.header.body": "Nagłówek gromadzi w jednym stałym miejscu nazwę Director, język, stan katalogu i najważniejsze informacje o sesji. Panel pozostaje dostępny podczas przechodzenia między narzędziami.",
      "tutorial.step.language.title": "Wybierz język interfejsu",
      "tutorial.step.language.body": "Użyj tego selektora, aby natychmiast zmienić język interfejsu. Config.Language określa język wczytywany podczas uruchamiania zasobu; angielski pozostaje bezpieczną wartością domyślną.",
      "tutorial.step.navigation.title": "Jedna mapa wszystkich narzędzi",
      "tutorial.step.navigation.body": "Siatka nawigacji grupuje biblioteki, narzędzia sterowania światem na żywo i edytory produkcji. Podświetlona karta wskazuje bieżące miejsce; powrót tutaj nigdy nie usuwa zapisanej pracy.",

      "tutorial.step.scenes.title": "Przeglądaj zsynchronizowane sceny",
      "tutorial.step.scenes.body": "Scenes zawiera katalog zsynchronizowanych scen. Wyszukaj lub otwórz kategorię, wybierz scenę, przypisz jej aktorów, umieść ją w świecie, wyświetl podgląd, a następnie wykorzystaj ponownie w Custom Scene.",
      "tutorial.step.favorites.title": "Miej często używane sceny pod ręką",
      "tutorial.step.favorites.body": "Oznacz scenę gwiazdką, aby umieścić ją w Scenes Fav. Ulubione są szybką biblioteką osobistą i nie powielają ani nie modyfikują oryginalnej definicji sceny.",
      "tutorial.step.peds.title": "Zbuduj obsadę wielokrotnego użytku",
      "tutorial.step.peds.body": "My Peds przechowuje wyglądy postaci w folderach. Utwórz, edytuj, sklonuj, zmień nazwę, przywołaj lub wciel się w zapisanego peda, a potem używaj tej obsady ponownie w scenach, animacjach, środowiskach, replayach i pościgach.",
      "tutorial.step.vehicles.title": "Zapisuj pojazdy gotowe do produkcji",
      "tutorial.step.vehicles.body": "My Vehicles zapisuje wczytany pojazd wraz z tuningiem, kolorami, dodatkami, światłami, uszkodzeniami i pozostałym stanem wizualnym. Zapisane presety można przywołać lub wykorzystać do zastąpienia pojazdów w procesach Replay i Chase.",
      "tutorial.step.animations.title": "Znajduj i umieszczaj animacje",
      "tutorial.step.animations.body": "Animations udostępnia wyszukiwanie, ulubione, typ odtwarzania, zapętlanie oraz filtry położenia Ground/Fly. Wybierz aktora, sprawdź podgląd, a następnie umieść lub odtwórz animację na skorygowanej wysokości świata.",
      "tutorial.step.customAnimations.title": "Korzystaj z animacji właściwych dla serwera",
      "tutorial.step.customAnimations.body": "Custom Anims wyświetla słowniki i klipy dostarczone przez konfigurację lub integrację z menu animacji. Korzystają one z tego samego procesu wyboru aktora, położenia, zapętlania i integracji ze sceną co główny katalog.",

      "tutorial.step.chase.title": "Wyreżyseruj filmowy pościg",
      "tutorial.step.chase.body": "Chase zaczyna od bezpiecznych ustawień policyjnych, a następnie pozwala dostosować jednostki, pojazdy, kierowców, pasażerów, syreny, wsparcie lotnicze, zachowanie, ochronę i broń po opuszczeniu pojazdu. Chase Replay nagrywa zsynchronizowane trasy pojazdów bez zachowania polegającego na wysiadaniu i strzelaniu.",
      "tutorial.step.density.title": "Steruj ruchem w tle",
      "tutorial.step.density.body": "Density dostosowuje lokalnych pieszych, poruszające się i zaparkowane pojazdy, losowy ruch oraz scenariusze. Niższe wartości oczyszczają plan, a wyższe tworzą bardziej ruchliwe tło bez edytowania zapisanych scen.",
      "tutorial.step.weather.title": "Kształtuj pogodę i czas",
      "tutorial.step.weather.body": "Weather & Time steruje pogodą, zegarem, prędkością czasu, zamrożeniem, zaciemnieniem, deszczem, wiatrem i oświetleniem miasta. Wybierz lokalne nadpisanie dla prywatnego planu albo skonfigurowaną integrację serwera, gdy ustawienia mają obowiązywać wszystkich.",
      "tutorial.step.environment.title": "Ustawiaj postacie NPC w tle",
      "tutorial.step.environment.body": "Environment tworzy grupy NPC wielokrotnego użytku z formacjami, modelami źródłowymi lub folderami zapisanych pedów, liczebnością, odstępami, zasięgiem, płcią, animacją i kierunkiem patrzenia. Zapisz wiele środowisk i dodaj dokładny zrzut do sceny lub Timeline.",
      "tutorial.step.effects.title": "Umieszczaj i animuj efekty",
      "tutorial.step.effects.body": "Effects wyszukuje zasoby cząsteczkowe i na żywo pokazuje skalę, przezroczystość, kolor oraz stan zapętlenia. Pozostaw efekt w pozycji świata lub dołącz go do zgodnego aktora, a następnie precyzyjnie zaplanuj w Custom Scenes albo Timeline.",
      "tutorial.step.clubs.title": "Zarządzaj wnętrzami i presetami klubów",
      "tutorial.step.clubs.body": "Clubs zapisuje filmowe presety wnętrz, współrzędne i stan IPL/wnętrza. Użyj teleportacji, aby sprawdzić plan, a następnie zapisz, zaktualizuj lub usuń preset, gdy konfiguracja świata będzie prawidłowa.",
      "tutorial.step.spooner.title": "Twórz i rozmieszczaj obiekty świata",
      "tutorial.step.spooner.body": "Object Spooner wyszukuje pedów, rekwizyty i pojazdy oraz umieszcza je za pomocą Freecam i natywnego gizma. Wybierz jeden lub wiele obiektów, aby je przekształcić, sklonować, dołączyć, uporządkować lub wysłać do innego procesu Director.",
      "tutorial.step.camera.title": "Poznaj filmowy obszar roboczy Camera",
      "tutorial.step.camera.body": "Samouczek otwiera ten chroniony podgląd bez uruchamiania Freecam ani zmieniania świata. W normalnej pracy Camera może zostać otwarta z głównej karty, wpisu Camera w Custom Scene albo klipu Camera na Timeline. H ukrywa lub przywraca panel, pozostawiając sterowanie kamerą aktywne; wyjście wraca do narzędzia, które ją otworzyło.",
      "tutorial.step.cameraCapture.title": "Przechwytuj i poprawiaj dokładne pozy kamery",
      "tutorial.step.cameraCapture.body": "Nadaj sekwencji nazwę u góry. Capture (L) dodaje bieżącą pozycję, obrót, FOV i ustawienia obrazu jako nową klatkę kluczową; na końcu samodzielnej sekwencji stosuje ustawiony odstęp Append, a w połączonym klipie respektuje playhead. Save frame nadpisuje tylko wybraną klatkę po przesunięciu kamery. Duplicate wstawia kopię między nią a następną lub po ustawionym odstępie na końcu; kosz usuwa wybraną klatkę.",
      "tutorial.step.cameraRecording.title": "Nagraj ruch kamery na żywo",
      "tutorial.step.cameraRecording.body": "Record rozpoczyna odliczanie i zamienia wykonywany na żywo ruch kamery w klatki kluczowe. REC: Replace usuwa poprzednie ujęcie; REC: Append zachowuje je i nagrywa nowy przebieg po ostatniej klatce. Z CLIP SYNC połączone klipy odtwarzają się podczas filmowania. Poza nagrywaniem F7 uruchamia lub pauzuje podgląd; podczas odliczania albo nagrywania F7 zatrzymuje operację. F8 zatrzymuje i przewija sekwencję do początku.",
      "tutorial.step.cameraKeyframes.title": "Przeglądaj i edytuj pojedyncze klatki kluczowe",
      "tutorial.step.cameraKeyframes.body": "Przeciągnij suwak do dokładnego czasu i kliknij romb, selektor klatek albo jego strzałki, aby wybrać klatkę. TIME zmienia jej znacznik czasu. EASING określa narastanie i wygaszanie prędkości; PATH wybiera zakrzywiony odcinek Spline albo prosty Linear; FOV zapisuje kąt obiektywu osobno w każdej klatce. Przesuń kamerę i użyj Save frame, aby zatwierdzić nową pozę.",
      "tutorial.step.cameraTiming.title": "Kontroluj czas, tempo i całą ścieżkę",
      "tutorial.step.cameraTiming.body": "SPEED skaluje prędkość podglądu i jest zablokowane, gdy klip Timeline zapewnia CLIP SYNC. PACING Natural używa zapisanych czasów klatek, Per segment utrzymuje stałą prędkość w każdym odcinku, a Continuous wyrównuje ją na całej trasie. Loop powtarza; Close loop przyciąga bliską ostatnią klatkę do pierwszej albo dodaje jej dokładną kopię; Distribute równomiernie rozstawia środkowe klatki; Path pokazuje lub ukrywa trasę w świecie.",
      "tutorial.step.cameraAttachments.title": "Wybierz obiekt śledzony przez kamerę",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) utrzymuje obiektyw na graczu. Po ukryciu panelu klawiszem H, Free look (N) obraca kamerę myszą bez trzymania RMB. Attach to entity pokazuje pojazdy replay, aktorów sceny i pobliskie obiekty; Refresh skanuje ponownie. Dla peda wybierz korzeń, kość ciała lub trzymaną broń, a dla pojazdu jego kość. Attach i Detach tworzą lub usuwają więź. Przy ukrytym panelu Target pointer oznacza cel, a LMB może go dołączyć nawet po wyłączeniu wskaźnika.",
      "tutorial.step.cameraAttachmentMotion.title": "Określ sposób ruchu dołączenia",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount obraca się z obiektem jak kamera na masce. Lock framing zachowuje dokładną pozycję i obrót względny podczas skrętów i przechyłów. Przy wyłączonym Rigid, Follow softness dodaje naturalne opóźnienie operatora zamiast sztywnego mocowania. Auto orbit zaczyna od gotowego kadru: W/S zmienia odległość, Q/E wysokość, a A/D prędkość orbity. Trzy suwaki ustawiają wartości dokładnie; ujemna prędkość odwraca kierunek.",
      "tutorial.step.cameraMovement.title": "Dostosuj ruch i reakcję operatora",
      "tutorial.step.cameraMovement.body": "Sensitivity steruje patrzeniem, a Zoom response obiektywem. Rotation smoothing łagodnie prowadzi kamerę do żądanego kąta; Mouse smoothing filtruje gwałtowne ruchy myszy; Movement smoothing wygładza początek i koniec przesunięcia. Base speed ustawia zwykłą prędkość lotu: Shift przyspiesza, Ctrl/Alt daje precyzję. Lens przełącza ogniskowe i FOV; RMB obraca, Z/C przybliża, Left/Right steruje przechyłem, a kółko zmienia Base speed.",
      "tutorial.step.cameraFlight.title": "Wybierz właściwy sposób lotu",
      "tutorial.step.cameraFlight.body": "Drone mode zamienia wejście w pęd, dzięki czemu kamera płynie i pochyla się zamiast natychmiast stawać. Walk mode utrzymuje obiektyw na wysokości oczu nad podłożem do ujęć operatorskich. World collision zapobiega przenikaniu przez ściany i stałą geometrię. W zwykłym locie WASD porusza lub przesuwa bokiem, a Q/E zmienia wysokość; w orbicie te same klawisze sterują dolly, obrotem i żurawiem.",
      "tutorial.step.cameraImage.title": "Ustaw filtry, ostrość i drgania kamery",
      "tutorial.step.cameraImage.body": "Effects przełącza filtr obrazu, a Intensity miesza jego siłę. Depth of field musi być włączone, aby ustawienia wpływały na obraz. Autofocus stale ostrzy widziany cel; Follow focus utrzymuje dołączony obiekt w ostrości; ręczne Distance jest dostępne po wyłączeniu Autofocus, a DOF Intensity reguluje rozmycie. Camera shake włącza wybrany preset drgań, a Shake strength ustawia jego amplitudę.",
      "tutorial.step.cameraScene.title": "Przygotuj czystą, dobrze skomponowaną scenę",
      "tutorial.step.cameraScene.body": "Allow player movement oddaje WASD pedowi lub pojazdowi, a inteligentne śledzenie zachowuje kadr; wyłącz tę opcję, aby ponownie latać lub obracać kamerą. Look at camera zwraca głowę gracza ku obiektywowi. Cinematic bars dodaje wybrane proporcje; Hide game HUD i Hide notifications oczyszczają obraz. Rule of thirds, Center cross, Safe area i Info overlay to prowadnice o regulowanej sile: pozostają po H i znikają podczas odtwarzania.",
      "tutorial.step.cameraOutput.title": "Podglądaj, przechwytuj, resetuj i wracaj",
      "tutorial.step.cameraOutput.body": "Video uruchamia lub zatrzymuje nagrywanie Rockstar Editor. Play/Pause pokazuje podgląd, Stop przewija do początku. Stopka pokazuje prędkość i FOV: G przełącza kotwicę spojrzenia, Level zeruje przechył bez zmiany pitch ani heading, R resetuje kamerę, H ukrywa panel, ESC wychodzi. Camera otwarta z Custom Scene lub Timeline wraca tam; zapisz scenę lub projekt nadrzędny. Samodzielne sekwencje są tymczasowe.",

      "tutorial.step.customScenes.title": "Skomponuj kompletną Custom Scene",
      "tutorial.step.customScenes.body": "Custom Scenes otwiera się automatycznie na potrzeby tej demonstracji. Podczas normalnej pracy wybierz New Custom Scene, nadaj kompozycji nazwę i otwórz jej edytor. Custom Scene łączy niezależne wpisy bez modyfikowania oryginalnych bibliotek.",
      "tutorial.step.customSceneEditor.title": "Poznaj edytor sceny",
      "tutorial.step.customSceneEditor.body": "Nagłówek pokazuje nazwę kompozycji i udostępnia Scene Tools, Save oraz Close. Scene Tools porządkuje warstwy, kolekcje, widoczność i Attachments; Save zapisuje kompozycję, gdy jej wpisy i czasy są gotowe.",
      "tutorial.step.customSceneEntries.title": "Odczytuj i ustawiaj czas każdego wpisu",
      "tutorial.step.customSceneEntries.body": "Każda karta wskazuje typ, źródło i położenie w świecie. Jeśli są dostępne, używaj akcji edycji, aktora, rekwizytu lub Attachment. Delay określa moment rozpoczęcia wpisu; presety zapewniają szybki wybór, a Custom przyjmuje dokładną wartość.",
      "tutorial.step.customSceneAdd.title": "Dodawaj elementy składowe",
      "tutorial.step.customSceneAdd.body": "Dodaj Camera, Animation, zsynchronizowaną Scene, Vehicle lub Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment albo Combat Ped. Każdy przycisk otwiera odpowiedni selektor lub wyspecjalizowany edytor, a następnie zwraca tutaj skonfigurowany wpis.",
      "tutorial.step.sceneTools.title": "Porządkuj złożone sceny",
      "tutorial.step.sceneTools.body": "Scene Tools to konspekt dla Custom Scenes. Używaj stabilnych wpisów, warstw, kolekcji, widoczności, zaznaczenia, dołączeń, transformacji i walidacji, aby duża kompozycja pozostała zrozumiała i edytowalna.",
      "tutorial.step.customScenePlayback.title": "Przetestuj przed nagraniem",
      "tutorial.step.customScenePlayback.body": "TEST wyświetla podgląd całej kompozycji bez tworzenia ujęcia. ACTION uruchamia odliczanie i nagrywa do Rockstar Editor; Attach nagrywa z kamerą poruszającą się wraz z wybraną encją sceny, a Nearby udostępnia zgodne odtwarzanie. Zatrzymaj podgląd, popraw wpisy, a następnie zapisz.",
      "tutorial.step.timeline.title": "Montuj produkcję na Timeline",
      "tutorial.step.timeline.body": "Timeline otwiera się automatycznie bez wczytywania ani zmieniania projektu. Podczas normalnej pracy utwórz lub wczytaj projekt, nadaj mu nazwę i zapisz jego strukturę. Timeline łączy wiele klipów osadzonych w czasie na automatycznie tworzonych ścieżkach.",
      "tutorial.step.timelineLibrary.title": "Wybierz, co chcesz umieścić",
      "tutorial.step.timelineLibrary.body": "Biblioteka grupuje kamery, ulubione, sceny, animacje, efekty, replaye i wyspecjalizowane wpisy. Najpierw wyszukaj, potem kliknij opcję dwukrotnie, aby dodać ją przy playheadzie, albo przeciągnij ją do dokładnego czasu; wymagana ścieżka zostanie utworzona automatycznie.",
      "tutorial.step.timelineTracks.title": "Rozmieść klipy na automatycznych ścieżkach",
      "tutorial.step.timelineTracks.body": "Ścieżki pojawiają się po dodaniu klipów. Przesuwaj klipy lub zmieniaj ich rozmiar, aby ustawić początek i czas trwania, używaj playheada i zoomu do precyzyjnej pracy, a w ustawieniach ścieżki możesz zmienić jej nazwę, kolejność i wysokość oraz włączyć solo, wyciszenie lub blokadę.",
      "tutorial.step.timelineInspector.title": "Edytuj wybrany klip",
      "tutorial.step.timelineInspector.body": "Wybranie klipu otwiera jego Inspector w obszarze sceny. Ustaw dokładne wartości IN, OUT, czasu trwania, przesunięcia źródła, zapętlenia i przejść, a następnie użyj Place, Props, ustawień aktora, klatek kluczowych lub zagnieżdżonego edytora, jeśli dany typ klipu je obsługuje.",
      "tutorial.step.timelinePlayback.title": "Wyświetl podgląd i nagraj montaż",
      "tutorial.step.timelinePlayback.body": "Play from rozpoczyna od bieżącego playheada; TEST wyświetla podgląd całej Timeline od początku. START odtwarza od początku z ukrytym interfejsem, bez odliczania i nagrywania; Backspace zatrzymuje odtwarzanie i wraca do Timeline. ACTION uruchamia odliczanie i nagrywa zsynchronizowany wynik. Nearby synchronizuje zgodne klipy z pobliskimi graczami. Usuń problemy diagnostyczne i zapisz projekt przed finalnym ujęciem.",
      "tutorial.step.replays.title": "Wykorzystuj ponownie nagrane występy",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle i Chase Replay przechwytują różne rodzaje ruchu i akcji. Nagraj czyste ujęcie, zatrzymaj je i poczekaj na zakończenie przetwarzania, zapisz, a potem odwołaj się do tego źródła w Custom Scenes lub Timeline.",
      "tutorial.step.advancedLayers.title": "Otwieraj wyspecjalizowane warstwy autorskie",
      "tutorial.step.advancedLayers.body": "Zaawansowane wpisy obejmują Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment i dołączenia. Każdy edytor zachowuje własny podgląd i zwraca wynik do sceny lub Timeline, z którego został otwarty.",

      "tutorial.step.catalog.title": "Wyszukuj, zanim zaczniesz budować",
      "tutorial.step.catalog.body": "Panele katalogów korzystają z wyszukiwania, kategorii, filtrów, folderów, ulubionych i liczników wyników. Najpierw zawęź listę, sprawdź wybraną kartę, a dopiero potem otwórz rozmieszczanie lub odtwarzanie, aby zachować porządek w świecie.",
      "tutorial.step.safeWorkflow.title": "Wyświetl podgląd, sprawdź i zapisz",
      "tutorial.step.safeWorkflow.body": "Większość zmian autorskich jest tymczasowa do momentu potwierdzenia lub zapisania. Użyj Preview albo TEST, zakończ każdą sesję Freecam/gizmo, sprawdź czas i cele, a następnie zapisz; Esc lub Backspace bezpiecznie cofa z aktywnej warstwy.",
      "tutorial.step.recording.title": "Poznaj znaczenie wskaźnika REC",
      "tutorial.step.recording.body": "Stopka pokazuje stan nagrywania Rockstar i ogólną podpowiedź zamykania. Procesy ACTION przygotowują wskazane zasoby, uruchamiają odliczanie i nagrywają zsynchronizowany rezultat; nie zamykaj zasobu podczas finalizowania ujęcia.",
      "tutorial.step.cutscenes.title": "Cutscene Player to osobny obszar roboczy",
      "tutorial.step.cutscenes.body": "Naciśnij F6 lub użyj /cutscenes, aby przeglądać przerywniki GTA, ulubione, nowe opcjonalne katalogi, nadpisania aktorów, dźwięk, HUD, zanikanie i opcje obserwatora. Narzędzie pozostaje oddzielone od głównego panelu Director, aby chronić aktywną konfigurację.",
      "tutorial.step.shortcuts.title": "Opanuj wspólne sterowanie",
      "tutorial.step.shortcuts.body": "F5 otwiera Director. W autorskim Freecam przytrzymaj RMB i używaj WASD razem z Q/E, Shift, Ctrl oraz kółkiem myszy. W gizmo używaj W/R, Tab, Alt, G, Enter i Backspace; każdy wyspecjalizowany edytor wyświetla również własny HUD na żywo.",

      "tutorial.step.finish.title": "Możesz rozpocząć reżyserowanie",
      "tutorial.step.finish.body": "Zacznij od jednego aktora lub jednej sceny, wyświetl podgląd każdej warstwy i rozwijaj produkcję dopiero wtedy, gdy każdy element działa. Uruchom /tutorial za każdym razem, gdy zechcesz powtórzyć przewodnik; po zakończeniu Director pozostanie otwarty, aby można było od razu ćwiczyć."
    },
    "pt-br": {
      "tutorial.title": "Tutorial interativo do Director",
      "tutorial.progress": "Etapa {{current}} de {{total}}",
      "tutorial.previous": "Anterior",
      "tutorial.next": "Próxima",
      "tutorial.finish": "Concluir tutorial",
      "tutorial.exit": "Sair do tutorial",
      "tutorial.restart": "Reiniciar",
      "tutorial.chapters": "Capítulos",
      "tutorial.keyboardHint": "Use Esquerda/Direita para mudar de etapa e Esc para sair.",
      "tutorial.safeMode": "Visualização guiada: áreas de trabalho e demonstrações abrem automaticamente, mas os controles destacados nunca são acionados.",
      "tutorial.targetUnavailable": "Este controle não está visível no layout atual. Você pode continuar com segurança.",
      "tutorial.finishWorkspace": "Conclua ou feche o editor ativo antes de iniciar o tutorial.",
      "tutorial.helpTitle": "Abrir o tutorial guiado",
      "tutorial.languageLabel": "Idioma do tutorial",

      "tutorial.chapter.orientation": "Primeiros passos",
      "tutorial.chapter.library": "Suas bibliotecas de conteúdo",
      "tutorial.chapter.liveTools": "Ferramentas de direção ao vivo",
      "tutorial.chapter.camera": "Câmera cinematográfica",
      "tutorial.chapter.customScenes": "Fluxo de trabalho de Custom Scene",
      "tutorial.chapter.timeline": "Edição na Timeline",
      "tutorial.chapter.authoring": "Camadas avançadas de criação",
      "tutorial.chapter.workflow": "Fluxo seguro e controles",
      "tutorial.chapter.finish": "Pronto para dirigir",

      "tutorial.step.welcome.title": "Boas-vindas ao Spectrem Director",
      "tutorial.step.welcome.body": "Este tour guiado explica o fluxo completo de criação. Ele pode abrir demonstrações visuais automaticamente, mas não vai reproduzir, gerar, gravar, excluir, salvar nem alterar nada no seu mundo.",
      "tutorial.step.header.title": "Sua área de trabalho do Director",
      "tutorial.step.header.body": "O cabeçalho reúne a identidade do Director, o idioma, o status do catálogo e as principais informações da sessão em um local fixo. O painel continua disponível enquanto você alterna entre as ferramentas.",
      "tutorial.step.language.title": "Escolha o idioma da interface",
      "tutorial.step.language.body": "Use este seletor para mudar imediatamente o idioma atual da interface. Config.Language define o idioma carregado quando o recurso inicia; o inglês continua sendo o padrão seguro.",
      "tutorial.step.navigation.title": "Um mapa para todas as ferramentas",
      "tutorial.step.navigation.body": "A grade de navegação agrupa bibliotecas, controles do mundo ao vivo e editores de produção. A aba destacada mostra onde você está; voltar para cá nunca apaga o trabalho salvo.",

      "tutorial.step.scenes.title": "Explore cenas sincronizadas",
      "tutorial.step.scenes.body": "Scenes contém o catálogo de cenas sincronizadas. Pesquise ou abra uma categoria, escolha uma cena, atribua seus atores, posicione-a no mundo, visualize o resultado e depois reutilize-a em uma Custom Scene.",
      "tutorial.step.favorites.title": "Mantenha suas cenas frequentes por perto",
      "tutorial.step.favorites.body": "Marque qualquer cena com uma estrela para adicioná-la a Scenes Fav. Os favoritos formam uma biblioteca pessoal rápida e não duplicam nem modificam a definição original da cena.",
      "tutorial.step.peds.title": "Monte um elenco reutilizável",
      "tutorial.step.peds.body": "My Peds armazena aparências em pastas. Crie, edite, clone, renomeie, gere ou assuma um ped salvo e depois reutilize esse elenco em cenas, animações, ambientes, replays e perseguições.",
      "tutorial.step.vehicles.title": "Salve veículos prontos para produção",
      "tutorial.step.vehicles.body": "My Vehicles captura um veículo carregado, incluindo tuning, cores, extras, luzes, danos e outros estados visuais. Os presets salvos podem ser gerados ou usados para substituir veículos nos fluxos de Replay e Chase.",
      "tutorial.step.animations.title": "Encontre e posicione animações",
      "tutorial.step.animations.body": "Animations oferece pesquisa, favoritos, tipo de reprodução, loop e filtros de posicionamento Ground/Fly. Escolha o ator, confira a prévia e posicione ou reproduza a animação na altura correta do mundo.",
      "tutorial.step.customAnimations.title": "Use animações específicas do servidor",
      "tutorial.step.customAnimations.body": "Custom Anims lista dicionários e clipes fornecidos pela sua configuração ou pela integração com o menu de animações. Eles usam o mesmo fluxo de seleção de ator, posicionamento, loop e integração com cenas do catálogo principal.",

      "tutorial.step.chase.title": "Dirija uma perseguição cinematográfica",
      "tutorial.step.chase.body": "Chase começa com padrões policiais seguros e depois permite personalizar unidades, veículos, motoristas, passageiros, sirenes, apoio aéreo, comportamento, proteção e armas ao sair do veículo. Chase Replay grava trajetórias sincronizadas sem o comportamento de sair e atirar.",
      "tutorial.step.density.title": "Controle o tráfego de fundo",
      "tutorial.step.density.body": "Density ajusta pedestres locais, veículos em movimento, veículos estacionados, tráfego aleatório e cenários. Valores menores limpam o set; valores maiores criam um fundo mais movimentado sem editar suas cenas salvas.",
      "tutorial.step.weather.title": "Defina o clima e o horário",
      "tutorial.step.weather.body": "Weather & Time controla clima, relógio, velocidade do tempo, congelamento, blackout, chuva, vento e iluminação urbana. Escolha substituições locais para um set privado ou a integração configurada do servidor quando todos precisarem acompanhar.",
      "tutorial.step.environment.title": "Organize NPCs de fundo",
      "tutorial.step.environment.body": "Environment cria grupos reutilizáveis de NPCs com formações, modelos de origem ou pastas de peds salvos, quantidade, espaçamento, extensão, gênero, animação e direção do olhar. Salve vários ambientes e adicione o snapshot exato a uma cena ou Timeline.",
      "tutorial.step.effects.title": "Posicione e anime efeitos",
      "tutorial.step.effects.body": "Effects pesquisa recursos de partículas e mostra ao vivo escala, alfa, cor e estado de loop. Mantenha um efeito em uma posição do mundo ou anexe-o a um ator compatível e depois programe-o com precisão em Custom Scenes ou Timeline.",
      "tutorial.step.clubs.title": "Gerencie interiores e presets de clubes",
      "tutorial.step.clubs.body": "Clubs armazena presets de interiores cinematográficos, coordenadas e estado de IPL/interior. Use o teleporte para inspecionar o set e depois salve, atualize ou exclua o preset quando a configuração do mundo estiver correta.",
      "tutorial.step.spooner.title": "Gere e organize entidades do mundo",
      "tutorial.step.spooner.body": "Object Spooner pesquisa peds, props e veículos e os posiciona usando Freecam e o gizmo nativo. Selecione uma ou várias entidades para transformar, clonar, anexar, organizar ou enviar para outro fluxo do Director.",
      "tutorial.step.camera.title": "Conheça a área cinematográfica de Camera",
      "tutorial.step.camera.body": "O tutorial abre esta área visual protegida sem iniciar a Freecam nem alterar o mundo. No uso normal, Camera pode ser aberta pela aba principal, por uma entrada Camera em Custom Scene ou por um clipe Camera na Timeline. H oculta ou restaura o painel, mas os controles de câmera continuam disponíveis; ao sair você volta para a ferramenta que abriu Camera.",
      "tutorial.step.cameraCapture.title": "Capture e corrija poses exatas da câmera",
      "tutorial.step.cameraCapture.body": "Dê um nome à sequência na parte superior. Capture (L) adiciona posição, rotação, FOV e ajustes de imagem como um keyframe novo; no fim de uma sequência independente usa o intervalo Append configurado, enquanto um clipe vinculado respeita seu playhead. Save frame sobrescreve somente o keyframe selecionado depois que você move a câmera. Duplicate coloca uma cópia entre ele e o próximo, ou após o intervalo configurado no fim; a lixeira exclui o keyframe selecionado.",
      "tutorial.step.cameraRecording.title": "Grave um movimento de câmera ao vivo",
      "tutorial.step.cameraRecording.body": "Record inicia uma contagem regressiva e converte o movimento feito ao vivo em keyframes. REC: Replace apaga a tomada anterior; REC: Append a preserva e grava uma nova passagem depois do último keyframe. Com CLIP SYNC, os clipes vinculados são reproduzidos enquanto você filma. Fora da gravação, F7 reproduz ou pausa; durante a contagem ou a gravação, F7 interrompe a operação. F8 para e rebobina a sequência até o início.",
      "tutorial.step.cameraKeyframes.title": "Percorra e edite cada keyframe",
      "tutorial.step.cameraKeyframes.body": "Arraste o scrubber para inspecionar um instante exato e clique em um losango, no seletor de keyframes ou nas setas para escolher um quadro. TIME altera sua marca temporal. EASING controla a entrada e saída de velocidade; PATH escolhe um trecho curvo Spline ou direto Linear; FOV salva um ângulo de lente por keyframe. Mova a câmera e use Save frame para confirmar a nova pose.",
      "tutorial.step.cameraTiming.title": "Controle o tempo, o ritmo e o caminho completo",
      "tutorial.step.cameraTiming.body": "SPEED multiplica a velocidade da prévia e fica bloqueado quando um clipe da Timeline fornece CLIP SYNC. PACING Natural segue os tempos dos keyframes, Per segment mantém velocidade constante em cada trecho e Continuous distribui uma velocidade uniforme pela rota inteira. Loop repete; Close loop ajusta o último quadro se ele já estiver perto do primeiro ou adiciona uma cópia exata; Distribute espaça igualmente os keyframes intermediários; Path mostra ou oculta a rota no mundo.",
      "tutorial.step.cameraAttachments.title": "Escolha o que a câmera deve seguir",
      "tutorial.step.cameraAttachments.body": "Anchor gaze to ped (G) mantém a lente apontada para o jogador. Depois que H ocultar o painel, Free look (N) permite girar com o mouse sem segurar RMB. Attach to entity lista veículos de replay, atores da cena e entidades próximas; Refresh faz uma nova varredura. Para um ped, escolha raiz, osso corporal ou arma empunhada; para um veículo, escolha um osso do veículo. Attach e Detach aplicam ou removem o vínculo. Com o painel oculto, Target pointer marca a entidade visada e LMB pode anexá-la mesmo com o ponteiro desativado.",
      "tutorial.step.cameraAttachmentMotion.title": "Defina como um anexo se movimenta",
      "tutorial.step.cameraAttachmentMotion.body": "Rigid mount gira junto com o alvo como uma câmera no capô. Lock framing preserva exatamente a posição e a rotação relativas durante curvas e inclinações. Com Rigid desligado, Follow softness cria um atraso de operador em vez de uma ligação rígida. Auto orbit parte do enquadramento atual: W/S altera a distância, Q/E a altura e A/D a velocidade orbital. Os três controles definem valores exatos; uma velocidade negativa inverte a direção.",
      "tutorial.step.cameraMovement.title": "Ajuste o movimento e a resposta do operador",
      "tutorial.step.cameraMovement.body": "Sensitivity controla a entrada de olhar e Zoom response a lente. Rotation smoothing conduz suavemente a câmera ao ângulo solicitado; Mouse smoothing filtra movimentos bruscos do mouse; Movement smoothing suaviza o início e o fim da translação. Base speed define a velocidade normal: segure Shift para rapidez ou Ctrl/Alt para precisão. Lens alterna distâncias focais e FOV; RMB gira, Z/C aplica zoom, Left/Right controla o roll e a roda altera Base speed.",
      "tutorial.step.cameraFlight.title": "Escolha o comportamento de voo adequado",
      "tutorial.step.cameraFlight.body": "Drone mode transforma a entrada em impulso, fazendo a câmera deslizar e inclinar em vez de parar imediatamente. Walk mode mantém a lente próxima à altura dos olhos sobre o solo para tomadas de operador. World collision impede atravessar paredes e geometria sólida. No voo normal, WASD move ou desloca lateralmente e Q/E muda a altura; em órbita, essas teclas passam a controlar dolly, giro e grua.",
      "tutorial.step.cameraImage.title": "Configure filtros, foco e tremor de câmera",
      "tutorial.step.cameraImage.body": "Effects alterna o filtro visual e Intensity mistura sua força. Depth of field precisa estar ativado para afetar a imagem. Autofocus mantém o foco no que a lente vê; Follow focus conserva um alvo anexado nítido; Distance manual fica disponível com Autofocus desligado e DOF Intensity controla o desfoque. Camera shake ativa um preset de tremor selecionável e Shake strength define sua amplitude.",
      "tutorial.step.cameraScene.title": "Prepare uma cena limpa e bem composta",
      "tutorial.step.cameraScene.body": "Allow player movement devolve WASD ao ped ou veículo e o acompanhamento inteligente preserva o enquadramento; desative a opção quando quiser voltar a voar ou girar a câmera. Look at camera vira a cabeça do jogador para a lente. Cinematic bars adiciona uma proporção selecionável; Hide game HUD e Hide notifications limpam o quadro. Rule of thirds, Center cross, Safe area e Info overlay são guias com intensidade ajustável: continuam visíveis ao usar H e desaparecem durante a reprodução.",
      "tutorial.step.cameraOutput.title": "Visualize, capture, redefina e retorne",
      "tutorial.step.cameraOutput.body": "Video inicia ou encerra uma gravação do Rockstar Editor. Play/Pause mostra a prévia e Stop volta ao início. O rodapé mostra velocidade e FOV: G alterna o olhar ancorado, Level remove o roll sem mudar pitch ou heading, R redefine a câmera, H oculta o painel e ESC sai. Camera aberta por Custom Scene ou Timeline retorna para lá; salve a cena ou projeto pai. Sequências independentes são temporárias.",

      "tutorial.step.customScenes.title": "Comece uma Custom Scene",
      "tutorial.step.customScenes.body": "Custom Scenes abre automaticamente para esta demonstração. No uso normal, escolha New Custom Scene, dê um nome à composição e abra seu editor. Uma Custom Scene combina entradas independentes sem modificar as bibliotecas originais.",
      "tutorial.step.customSceneEditor.title": "Entenda o editor de cenas",
      "tutorial.step.customSceneEditor.body": "O cabeçalho mostra o nome da composição e oferece Scene Tools, Save e Close. Scene Tools organiza camadas, coleções, visibilidade e Attachments; Save armazena a composição depois que suas entradas e tempos estiverem prontos.",
      "tutorial.step.customSceneEntries.title": "Confira e programe cada entrada",
      "tutorial.step.customSceneEntries.body": "Cada cartão identifica o tipo, a origem e o posicionamento no mundo. Use as ações de edição, ator, prop ou Attachment quando estiverem disponíveis. Delay define quando a entrada começa; os presets são opções rápidas e Custom aceita um valor exato.",
      "tutorial.step.customSceneAdd.title": "Adicione os componentes",
      "tutorial.step.customSceneAdd.body": "Adicione Camera, Animation, Scene sincronizada, Vehicle ou Ped Replay, Effect, Object Motion, Stage Light, Actor Sequence, Door Director, Environment ou Combat Ped. Cada botão abre o seletor ou editor especializado correspondente e depois retorna a entrada configurada para cá.",
      "tutorial.step.sceneTools.title": "Organize cenas complexas",
      "tutorial.step.sceneTools.body": "Scene Tools é o outliner de Custom Scenes. Use entradas estáveis, camadas, coleções, visibilidade, seleção, Attachments, transformações e validação para manter uma composição grande compreensível e editável.",
      "tutorial.step.customScenePlayback.title": "Teste antes de gravar",
      "tutorial.step.customScenePlayback.body": "TEST mostra a prévia da composição completa sem criar uma tomada. ACTION executa a contagem regressiva e grava no Rockstar Editor; Attach grava acompanhando uma entidade escolhida da cena, e Nearby compartilha uma reprodução compatível. Pare a prévia, corrija as entradas e depois use Save.",
      "tutorial.step.timeline.title": "Abra a área de Timeline",
      "tutorial.step.timeline.body": "Timeline abre automaticamente sem carregar nem alterar um projeto. No uso normal, crie ou carregue um projeto, dê um nome a ele e salve sua estrutura. Timeline combina vários clipes temporizados em faixas automáticas.",
      "tutorial.step.timelineLibrary.title": "Escolha o que deseja posicionar",
      "tutorial.step.timelineLibrary.body": "A biblioteca agrupa câmeras, favoritos, cenas, animações, efeitos, replays e entradas especializadas. Primeiro pesquise; depois clique duas vezes em uma opção para adicioná-la no playhead ou arraste-a até o tempo exato. A faixa necessária é criada automaticamente.",
      "tutorial.step.timelineTracks.title": "Organize clipes em faixas automáticas",
      "tutorial.step.timelineTracks.body": "As faixas aparecem quando os clipes são adicionados. Mova ou redimensione os clipes para definir início e duração, use o playhead e o zoom para trabalhar com precisão e abra as configurações da faixa para renomear, reordenar, redimensionar, usar solo, silenciar ou bloquear.",
      "tutorial.step.timelineInspector.title": "Edite o clipe selecionado",
      "tutorial.step.timelineInspector.body": "Selecionar um clipe abre seu Inspector na área do palco. Defina IN, OUT, duração, deslocamento da origem, loop e transições exatos; depois use Place, Props, ajustes de ator, keyframes ou o editor interno quando o tipo de clipe oferecer suporte.",
      "tutorial.step.timelinePlayback.title": "Visualize e grave a edição",
      "tutorial.step.timelinePlayback.body": "Play from começa no playhead atual; TEST mostra a prévia de toda a Timeline desde o início. START reproduz desde o início com a interface oculta, sem contagem regressiva nem gravação; Backspace interrompe a reprodução e volta à Timeline. ACTION executa a contagem regressiva e grava o resultado sincronizado. Nearby sincroniza clipes compatíveis com jogadores próximos. Resolva os diagnósticos e salve antes da tomada final.",
      "tutorial.step.replays.title": "Reutilize performances gravadas",
      "tutorial.step.replays.body": "Ghost, Ped, Vehicle e Chase Replay capturam diferentes tipos de movimento e ação. Grave uma tomada limpa, pare e aguarde o processamento, salve e depois use essa origem em Custom Scenes ou Timeline.",
      "tutorial.step.advancedLayers.title": "Abra camadas avançadas de criação",
      "tutorial.step.advancedLayers.body": "As entradas avançadas incluem Object Motion, Stage Lighting, Actor Sequencer, Door Director, Camera Sequence, Environment e Attachments. Cada editor mantém sua própria prévia e devolve o resultado à cena ou Timeline que o abriu.",

      "tutorial.step.catalog.title": "Pesquise antes de criar",
      "tutorial.step.catalog.body": "Os painéis de catálogo usam pesquisa, categorias, filtros, pastas, favoritos e contagens de resultados. Primeiro restrinja a lista, inspecione o cartão selecionado e só então abra o posicionamento ou a reprodução para manter o mundo organizado.",
      "tutorial.step.safeWorkflow.title": "Visualize, confira e salve",
      "tutorial.step.safeWorkflow.body": "A maioria das mudanças de criação é temporária até você confirmar ou salvar. Use Preview ou TEST, encerre qualquer sessão de Freecam/gizmo, confira tempos e alvos e depois salve; Esc ou Backspace retorna com segurança da camada ativa.",
      "tutorial.step.recording.title": "Entenda o indicador REC",
      "tutorial.step.recording.body": "O rodapé mostra o status de gravação do Rockstar e a dica global para fechar. Os fluxos ACTION preparam os recursos referenciados, executam a contagem regressiva e gravam o resultado sincronizado; não feche o recurso enquanto uma tomada estiver sendo finalizada.",
      "tutorial.step.cutscenes.title": "Cutscene Player é uma área separada",
      "tutorial.step.cutscenes.body": "Pressione F6 ou use /cutscenes para explorar cutscenes do GTA, favoritos, novos catálogos opcionais, substituições de atores, áudio, HUD, fades e opções de espectador. Ele permanece separado do painel principal do Director para proteger a configuração ativa.",
      "tutorial.step.shortcuts.title": "Domine os controles compartilhados",
      "tutorial.step.shortcuts.body": "F5 abre o Director. Na Freecam de criação, mantenha RMB pressionado e use WASD com Q/E, Shift, Ctrl e a roda. No gizmo, use W/R, Tab, Alt, G, Enter e Backspace; cada editor especializado também mostra seu próprio HUD ao vivo.",

      "tutorial.step.finish.title": "Você está pronto para dirigir",
      "tutorial.step.finish.body": "Comece com um ator ou uma cena, visualize cada camada e só amplie a produção depois que cada parte funcionar. Execute /tutorial sempre que quiser repetir este tour guiado; ao concluir, o Director permanece aberto para você praticar imediatamente."
    }
  };

  // Independent camera gaze and exclusive lens focus modes.
  const cameraTargetingTutorial = {
    "en": {
      "tutorial.step.cameraAttachments.body": "Gaze controls rotation; attachment controls position. They can use different targets. Hide the panel with H. LMB attaches; RMB selects the look target. Alt + RMB rotates manually; N enables free look. B/V switches targets without changing the attachment. Scene / Timeline first. Click — lock / release; Hold — track until release.",
      "tutorial.step.cameraImage.body": "Enable depth of field first. Follow focus uses the look target, then the attachment or G target. This changes sharpness, not camera direction. Lens focus: Manual distance; Autofocus — screen centre; Follow focus — look target."
    },
    "es": {
      "tutorial.step.cameraAttachments.body": "La mirada controla la rotación; el attachment controla la posición. Pueden usar objetivos diferentes. Oculta el panel con H. LMB vincula la cámara; RMB elige la mirada. Alt + RMB gira manualmente; N activa la mirada libre. B/V cambia de objetivo sin cambiar el attachment. Primero escena / Timeline. Clic — fijar / soltar; Mantener — seguir hasta soltar.",
      "tutorial.step.cameraImage.body": "Activa primero la profundidad de campo. El enfoque sigue al objetivo de mirada, después al attachment o al objetivo de G. Cambia la nitidez, no la dirección de la cámara. Enfoque de lente: Distancia manual; Autofocus — centro de pantalla; Seguir enfoque — objetivo de mirada."
    },
    "de": {
      "tutorial.step.cameraAttachments.body": "Der Blick steuert die Drehung, die Befestigung die Position. Beide können unterschiedliche Ziele nutzen. H blendet das Panel aus. LMB befestigt die Kamera; RMB wählt das Blickziel. Alt + RMB dreht manuell; N aktiviert den freien Blick. B/V wechselt Ziele ohne die Befestigung zu ändern. Szene / Timeline zuerst. Klick — fixieren / lösen; Halten — bis zum Loslassen folgen.",
      "tutorial.step.cameraImage.body": "Zuerst Tiefenschärfe aktivieren. Der Fokus folgt dem Blickziel, dann dem Befestigungsziel oder G-Ziel. Das ändert die Schärfe, nicht die Kamerarichtung. Objektivfokus: Manuelle Entfernung; Autofokus — Bildschirmmitte; Fokus folgen — Blickziel."
    },
    "tr": {
      "tutorial.step.cameraAttachments.body": "Bakış dönüşü, bağlantı konumu yönetir. Farklı hedefler kullanabilirler. H ile paneli gizle. LMB kamerayı bağlar; RMB bakış hedefini seçer. Alt + RMB elle döndürür; N serbest bakışı açar. B/V bağlantıyı değiştirmeden hedefler arasında geçer. Önce sahne / Timeline. Tıkla — kilitle / bırak; Basılı tut — bırakana kadar izle.",
      "tutorial.step.cameraImage.body": "Önce alan derinliğini aç. Odak önce bakış hedefine, sonra bağlantı veya G hedefine uyar. Kameranın yönünü değil, netliği değiştirir. Lens odağı: Elle mesafe; Otomatik odak — ekran merkezi; Odak takibi — bakış hedefi."
    },
    "fr": {
      "tutorial.step.cameraAttachments.body": "Le regard contrôle la rotation ; l'attachement contrôle la position. Leurs cibles peuvent être différentes. Masquez le panneau avec H. LMB attache la caméra ; RMB choisit le regard. Alt + RMB tourne manuellement ; N active le regard libre. B/V change de cible sans changer l'attachement. Scène / Timeline en priorité. Clic — verrouiller / libérer; Maintenir — suivre jusqu'au relâchement.",
      "tutorial.step.cameraImage.body": "Activez d'abord la profondeur de champ. Le point suit la cible du regard, puis celle de l'attachement ou de G. Cela change la netteté, pas la direction de la caméra. Mise au point: Distance manuelle; Autofocus — centre de l'écran; Suivi du point — cible du regard."
    },
    "ar": {
      "tutorial.step.cameraAttachments.body": "النظر يتحكم بالدوران والارتباط يتحكم بالموقع. يمكن استخدام هدف مختلف لكل منهما. أخفِ اللوحة باستخدام H. يربط LMB الكاميرا ويختار RMB هدف النظر. يدير Alt + RMB الكاميرا يدويًا ويفعّل N النظر الحر. يبدّل B/V الأهداف دون تغيير الارتباط. المشهد / Timeline أولاً. نقرة — تثبيت / تحرير; ضغط مستمر — متابعة حتى الإفلات.",
      "tutorial.step.cameraImage.body": "فعّل عمق المجال أولاً. يتبع التركيز هدف النظر ثم هدف الارتباط أو G. يغيّر الحدة وليس اتجاه الكاميرا. تركيز العدسة: مسافة يدوية; تركيز تلقائي — وسط الشاشة; تتبع التركيز — هدف النظر."
    },
    "vi": {
      "tutorial.step.cameraAttachments.body": "Hướng nhìn điều khiển góc xoay; liên kết điều khiển vị trí. Hai mục tiêu có thể khác nhau. Ẩn bảng bằng H. LMB gắn camera; RMB chọn mục tiêu nhìn. Alt + RMB xoay thủ công; N bật nhìn tự do. B/V đổi mục tiêu mà không đổi liên kết. Ưu tiên cảnh / Timeline. Nhấp — khóa / bỏ khóa; Giữ — theo dõi đến khi thả.",
      "tutorial.step.cameraImage.body": "Bật độ sâu trường ảnh trước. Lấy nét ưu tiên mục tiêu nhìn, rồi mục tiêu liên kết hoặc G. Chỉ thay đổi độ nét, không đổi hướng camera. Lấy nét ống kính: Khoảng cách thủ công; Tự động — giữa màn hình; Theo dõi nét — mục tiêu nhìn."
    },
    "pl": {
      "tutorial.step.cameraAttachments.body": "Spojrzenie steruje obrotem, a przypięcie pozycją. Mogą mieć różne cele. Ukryj panel klawiszem H. LMB przypina kamerę; RMB wybiera cel spojrzenia. Alt + RMB obraca ręcznie; N włącza swobodny widok. B/V zmienia cel bez zmiany przypięcia. Najpierw scena / Timeline. Kliknięcie — zablokuj / zwolnij; Przytrzymaj — śledź do puszczenia.",
      "tutorial.step.cameraImage.body": "Najpierw włącz głębię ostrości. Ostrość podąża za celem spojrzenia, następnie za celem przypięcia lub G. Zmienia ostrość, nie kierunek kamery. Ostrość obiektywu: Odległość ręczna; Autofokus — środek ekranu; Śledzenie ostrości — cel spojrzenia."
    },
    "pt-br": {
      "tutorial.step.cameraAttachments.body": "O olhar controla a rotação; a vinculação controla a posição. Eles podem usar alvos diferentes. Oculte o painel com H. LMB vincula a câmera; RMB escolhe o olhar. Alt + RMB gira manualmente; N ativa o olhar livre. B/V troca de alvo sem mudar a vinculação. Cena / Timeline primeiro. Clique — fixar / soltar; Segurar — seguir até soltar.",
      "tutorial.step.cameraImage.body": "Ative primeiro a profundidade de campo. O foco prioriza o alvo do olhar, depois o da vinculação ou de G. Isso muda a nitidez, não a direção da câmera. Foco da lente: Distância manual; Foco automático — centro da tela; Seguir foco — alvo do olhar."
    }
  };
  Object.entries(cameraTargetingTutorial).forEach(([locale, strings]) => {
    // Retain the existing bone/weapon attachment and filter/shake explanations.
    const attachmentKey = "tutorial.step.cameraAttachments.body";
    const imageKey = "tutorial.step.cameraImage.body";
    const attachment = catalogs[locale][attachmentKey];
    const image = catalogs[locale][imageKey];
    const attachStart = attachment.indexOf("Attach to entity");
    if (attachStart >= 0) strings[attachmentKey] += " " + attachment.slice(attachStart);
    const filterEnd = image.indexOf(". ");
    const shakeStart = image.indexOf("Camera shake");
    if (filterEnd >= 0) strings[imageKey] = image.slice(0, filterEnd + 2) + strings[imageKey];
    if (shakeStart >= 0) strings[imageKey] += " " + image.slice(shakeStart);
    Object.assign(catalogs[locale], strings);
  });

  const droneBankingHelp = {
    "en": "Drone banking: Maximum tilt when turning: 0° levels the horizon, 15° is standard, 45° is pronounced. Speed and inertia are unchanged.",
    "es": "Balanceo del drone: Inclinación máxima al girar: 0° nivela el horizonte, 15° es normal y 45° es pronunciado. No cambia la velocidad ni la inercia.",
    "de": "Drohnenneigung: Maximale Neigung beim Drehen: 0° richtet den Horizont aus, 15° ist Standard, 45° ist stark. Geschwindigkeit und Trägheit bleiben unverändert.",
    "tr": "Drone yatışı: Dönüşte en yüksek yatış: 0° ufku düzler, 15° standarttır, 45° belirgindir. Hız ve atalet değişmez.",
    "fr": "Inclinaison du drone: Inclinaison maximale en virage : 0° remet l’horizon à niveau, 15° est standard, 45° est prononcé. La vitesse et l’inertie restent inchangées.",
    "ar": "ميل الدرون: أقصى ميل عند الدوران: 0° يسوّي الأفق، و15° هو الوضع العادي، و45° ميل واضح. لا تتغير السرعة أو القصور الذاتي.",
    "vi": "Độ nghiêng drone: Độ nghiêng tối đa khi xoay: 0° cân bằng đường chân trời, 15° là mức chuẩn, 45° nghiêng mạnh. Không đổi tốc độ hay quán tính.",
    "pl": "Przechył drona: Maksymalny przechył przy skręcie: 0° poziomuje horyzont, 15° to standard, 45° to silny przechył. Prędkość i bezwładność pozostają bez zmian.",
    "pt-br": "Inclinação do drone: Inclinação máxima ao virar: 0° nivela o horizonte, 15° é o padrão e 45° é acentuado. A velocidade e a inércia não mudam."
  };
  Object.entries(droneBankingHelp).forEach(([locale, help]) => {
    catalogs[locale]["tutorial.step.cameraFlight.body"] += " " + help;
  });

  const lookSpeedHelp = {
  "en": "Look speed: 1–100%: lower values turn slowly; higher values aim quickly. Applies to RMB, B/V, panel targets and G, including tracking. Very low values lag behind fast subjects. Manual rotation and drone banking stay unchanged.",
  "es": "Velocidad de mirada: 1–100%: valores bajos giran lentamente; valores altos apuntan rápido. Se aplica a RMB, B/V, objetivos del panel y G, incluido el seguimiento. Valores muy bajos van detrás de sujetos rápidos. No cambia el giro manual ni el balanceo del drone.",
  "de": "Blickgeschwindigkeit: 1–100%: niedrige Werte drehen langsam, hohe zielen schnell. Gilt für RMB, B/V, Panel-Ziele und G, auch beim Verfolgen. Sehr niedrige Werte hinken schnellen Motiven hinterher. Manuelle Drehung und Drohnenneigung bleiben unverändert.",
  "tr": "Bakış hızı: %1–100: düşük değerler yavaş döner, yüksek değerler hızlı yönelir. Takip dahil RMB, B/V, panel hedefleri ve G için geçerlidir. Çok düşük değerler hızlı hedeflerin gerisinde kalır. Elle dönüş ve drone yatışı değişmez.",
  "fr": "Vitesse du regard: 1–100 % : une valeur basse tourne lentement, une valeur haute vise rapidement. S’applique à RMB, B/V, aux cibles du panneau et à G, suivi compris. Les valeurs très basses retardent le suivi des sujets rapides. La rotation manuelle et l’inclinaison du drone restent inchangées.",
  "ar": "سرعة توجيه النظر: 1–100%: القيم المنخفضة تدير الكاميرا ببطء والعالية توجهها بسرعة. ينطبق على RMB وB/V وأهداف اللوحة وG، بما في ذلك التتبع. القيم المنخفضة جداً تتأخر عن الأهداف السريعة. لا يتغير الدوران اليدوي أو ميل الدرون.",
  "vi": "Tốc độ hướng nhìn: 1–100%: giá trị thấp xoay chậm, giá trị cao hướng tới mục tiêu nhanh. Áp dụng cho RMB, B/V, mục tiêu trong bảng và G, kể cả khi theo dõi. Giá trị quá thấp sẽ theo chậm hơn chủ thể di chuyển nhanh. Không đổi xoay thủ công hay độ nghiêng drone.",
  "pl": "Szybkość spojrzenia: 1–100%: niskie wartości obracają powoli, wysokie szybko kierują kamerę na cel. Dotyczy RMB, B/V, celów z panelu i G, również podczas śledzenia. Bardzo niskie wartości opóźniają śledzenie szybkich obiektów. Ręczny obrót i przechył drona pozostają bez zmian.",
  "pt-br": "Velocidade do olhar: 1–100%: valores baixos giram devagar; valores altos apontam rápido. Aplica-se a RMB, B/V, alvos do painel e G, incluindo o acompanhamento. Valores muito baixos ficam atrás de alvos rápidos. A rotação manual e a inclinação do drone não mudam."
};
  Object.entries(lookSpeedHelp).forEach(([locale, help]) => {
    catalogs[locale]["tutorial.step.cameraAttachments.body"] += " " + help;
  });

  const zoomSpeedHelp = {
  "en": [
    "Zoom speed",
    "Hide the panel with H, then hold Z to zoom in or C to zoom out. 1–200%: lower is slower; 100% is normal; 200% is twice as fast. Changes FOV, not camera position. Lens presets and recorded zoom playback are unchanged."
  ],
  "es": [
    "Velocidad de zoom",
    "Oculta el panel con H y mantén Z para acercar o C para alejar. 1–200%: menos es más lento; 100% es normal; 200% es el doble de rápido. Cambia el FOV, no la posición. No altera los presets de lente ni la reproducción del zoom grabado."
  ],
  "de": [
    "Zoomgeschwindigkeit",
    "Blende das Panel mit H aus. Halte Z zum Heranzoomen oder C zum Herauszoomen. 1–200%: niedriger ist langsamer; 100% ist normal; 200% ist doppelt so schnell. Ändert den FOV, nicht die Position. Objektivvorgaben und aufgezeichnete Zooms bleiben unverändert."
  ],
  "tr": [
    "Yakınlaştırma hızı",
    "Paneli H ile gizle. Yakınlaştırmak için Z, uzaklaştırmak için C tuşunu basılı tut. %1–200: düşük değer yavaştır; %100 normal, %200 iki kat hızlıdır. Konumu değil FOV değerini değiştirir. Lens hazır ayarları ve kayıtlı yakınlaştırmanın oynatımı değişmez."
  ],
  "fr": [
    "Vitesse du zoom",
    "Masquez le panneau avec H, puis maintenez Z pour zoomer ou C pour dézoomer. 1–200 % : plus bas est plus lent ; 100 % est normal ; 200 % est deux fois plus rapide. Modifie le FOV, pas la position. Les préréglages d’objectif et les zooms enregistrés restent inchangés."
  ],
  "ar": [
    "سرعة التكبير",
    "أخفِ اللوحة بمفتاح H، ثم اضغط مطولاً على Z للتقريب أو C للإبعاد. 1–200%: الأقل أبطأ؛ 100% عادي؛ 200% ضعف السرعة. يغير مجال الرؤية FOV وليس الموضع. لا يغير إعدادات العدسة المسبقة أو تشغيل التكبير المسجل."
  ],
  "vi": [
    "Tốc độ thu phóng",
    "Ẩn bảng bằng H, rồi giữ Z để phóng to hoặc C để thu nhỏ. 1–200%: thấp hơn thì chậm hơn; 100% là bình thường; 200% nhanh gấp đôi. Thay đổi FOV, không đổi vị trí. Không đổi các thiết lập ống kính hay phát lại thu phóng đã ghi."
  ],
  "pl": [
    "Szybkość zoomu",
    "Ukryj panel klawiszem H, następnie przytrzymaj Z, aby przybliżyć, lub C, aby oddalić. 1–200%: niższa wartość oznacza wolniej; 100% to normalnie; 200% to dwa razy szybciej. Zmienia FOV, nie pozycję. Presety obiektywu i odtwarzanie nagranego zoomu pozostają bez zmian."
  ],
  "pt-br": [
    "Velocidade do zoom",
    "Oculte o painel com H e segure Z para aproximar ou C para afastar. 1–200%: menor é mais lento; 100% é normal; 200% é duas vezes mais rápido. Muda o FOV, não a posição. Não altera os presets de lente nem a reprodução do zoom gravado."
  ]
};
  Object.entries(zoomSpeedHelp).forEach(([locale, [label, help]]) => {
    const key = "tutorial.step.cameraMovement.body";
    catalogs[locale][key] = catalogs[locale][key].replace(/Zoom response/g, label) + " " + help;
  });

  // Focused production workflows. These steps highlight entry points only:
  // the tour must never start a recorder, spawn traffic or edit saved content.
  const productionTutorial = {
    en: {
      sceneGround: ["Place a scene on the ground", "After this tour, use Scene or the catalog's Place button. During placement, G snaps the whole scene to the surface below it without changing heading or actor/prop offsets. It works in move, free-camera and aim modes; aim returns to manual. Q/E fine-tunes height and Enter confirms. This is not the camera's G target lock."],
      environmentSave: ["Keep an environment in your production", "First create and place an Environment, set its formation, actors and facing direction, then select it. This Environment button adds a snapshot to the Custom Scene; Timeline offers the same layer. Later live changes do not automatically rewrite that snapshot: explicitly replace it when wanted, set its timing and save the parent production."],
      productionTiming: ["Coordinate the new layers", "A clip's start positions it on the production clock; source offset chooses where its own content begins. Traffic car delays are already inside the recorded take. Actor Sequence walking times are estimates: compare Preview with the camera, then adjust clip timing. Scrubbing checks a pose, not live AI behavior. Save the project after editing a nested layer."],
      replayCrew: ["Assign the driver and passengers", "From Vehicle Replay settings, assign peds to the seats supported by each vehicle. Driver is seat -1; seats 0 onward are passengers. Four total seats mean one driver and three passengers. Replay recorded weapon fire is off by default: leave it off for unarmed cars to avoid gestures from shared attack controls. Enable it only for a suitable armed take."],
      replaySave: ["Save another take safely", "Open a Vehicle Replay folder here, record, stop with E, name the take and Save. Wait for server confirmation before recording again. Names are labels; renaming does not change replay identity. You can append takes to a folder already used by a scene. If saving fails, keep the pending take and retry; never close the resource during upload."],
      trafficGenerate: ["Traffic Replay: prepare a stopped fleet", "After the tour, open Vehicle Replay here, create or open a folder and choose Traffic Replay. In Automatic mode, add zones and set count, speed and behavior, then Generate. Cars appear stopped; they do not drive yet. Inspect the actual vehicle count. Generate again rebuilds the fleet and discards its per-car edits and routes."],
      trafficPlace: ["Choose and position each traffic car", "Advanced mode adds installed spawn codes with prefix suggestions, or copies from My Vehicles. Replace or remove individual cars. Position on ground uses a vehicle preview, not gizmo axes: WASD moves relative to the view, wheel rotates, Space switches vehicle/camera, X aims placement. Enter confirms; Backspace cancels. Align to traffic is separate and chooses a nearby lane."],
      trafficRoute: ["Draw smooth vehicle trajectories", "For a staged car, open Vehicle trajectory → Draw route. The start stays on the car; left-click destinations ahead, then Enter to accept or Esc to cancel. Corner smoothing is 2–20 m. Leave room for the whole vehicle. Speed is a maximum; the controller slows for corners and the endpoint. Start delay must be shorter than the recording."],
      trafficRecord: ["Capture and reuse the traffic", "Finish positioning and routes, then Record traffic releases the stopped cars on one recording clock. Stop and save the take, then add it through Vehicle Replay to Custom Scenes or Timeline. This stores actual vehicle motion, not a future AI simulation. Confirming a new car position clears its route; replacing the model preserves it. Road AI can still collide, so inspect the take."],
      actorStyles: ["Give an actor a walking and aiming style", "Open Actor Sequence here, draw a route, then choose the actor. Actor → Actor styles sets the default gait and weapon style; waypoint settings can override them. Default restores normal movement, while inherited settings use the actor choice. Choose a compatible weapon for aiming. The bundled styles need no external emote resource; preview how the selected model performs them."],
      actorRoute: ["Smooth an actor's route", "In Route → Route motion, use Smooth path and Corner radius (0.20–3.00 m). New routes enable smoothing; older routes keep their behavior until you opt in. Transit corners and walk/run changes become gradual. Points with a wait or event remain exact stops. Check the green curve around obstacles: a smooth route is not permission to walk through a wall."],
      actorEvents: ["Combine movement with waypoint events", "In Events, select a waypoint and add waits, turns, animations, weapon changes or aiming. A waypoint event runs on arrival, not just because the estimated time elapsed. Compatible upper-body animations can overlap movement; full-body actions may need to stop. In Review, compare a scrubbed pose with live Preview, then save. A blocked smooth route times out without firing unreachable arrival events."],
      textFacing: ["Fixed text or text facing the camera", "Open Cinematic Text here. Write the content, choose a bundled font and appearance, then place its anchor with the gizmo. Fixed keeps a world rotation; Face camera turns toward the active camera. Finish the gizmo before switching. A fixed sign viewed edge-on or behind geometry may be invisible: inspect its angle and position before increasing scale."],
      textCapture: ["Time and record cinematic text", "Choose duration and entrance/exit animation, preview, then save the text into the scene or Timeline. Both facing modes use the same world-space size. Fonts work offline, with fallback for missing glyphs. Text appears in live previews and direct EXPORT, but Rockstar Editor cannot record its DUI surface: ACTION is blocked for productions containing Cinematic Text."],
    },
    es: {
      sceneGround: ["Coloca una escena en el suelo", "Después del tutorial, usa Scene o Place en el catálogo. Durante el placement, G ajusta toda la escena a la superficie inferior sin cambiar el giro ni los offsets de actores y props. Funciona en movimiento, cámara libre y apuntado; este último vuelve a manual. Q/E afina la altura y Enter confirma. No es el bloqueo de objetivo G de la cámara."],
      environmentSave: ["Guarda un entorno en tu producción", "Primero crea y coloca un Environment, configura su formación, actores y dirección de mirada, y selecciónalo. Este botón Environment añade una copia a la Custom Scene; Timeline ofrece la misma capa. Los cambios posteriores del entorno en vivo no reescriben esa copia: reemplázala expresamente cuando quieras, ajusta su tiempo y guarda la producción."],
      productionTiming: ["Coordina las nuevas capas", "El inicio del clip lo sitúa en el reloj de la producción; el offset de origen elige desde dónde empieza su contenido. Los retrasos de cada auto de Traffic ya están dentro de la toma grabada. Los tiempos de caminata de Actor Sequence son estimaciones: compara Preview con la cámara y ajusta los clips. Scrub verifica una pose, no la IA en vivo. Guarda el proyecto tras editar una capa."],
      replayCrew: ["Asigna conductor y pasajeros", "En los ajustes de Vehicle Replay, asigna peds a los asientos admitidos por cada vehículo. Driver es el asiento -1; del 0 en adelante son pasajeros. Cuatro plazas totales equivalen a conductor y tres pasajeros. Replay recorded weapon fire está desactivado por defecto: déjalo así en autos sin armas para evitar gestos del control de disparo. Actívalo solo para una toma armada compatible."],
      replaySave: ["Guarda otra toma sin perder las anteriores", "Abre aquí una carpeta de Vehicle Replay, graba, detén con E, pon nombre y pulsa Save. Espera la confirmación del servidor antes de volver a grabar. Los nombres son etiquetas; renombrar no cambia la identidad del replay. Puedes añadir tomas a carpetas usadas por una escena. Si falla el guardado, conserva la toma pendiente y reintenta; no cierres el recurso durante la subida."],
      trafficGenerate: ["Traffic Replay: prepara autos detenidos", "Al terminar el tutorial, abre aquí Vehicle Replay, crea o abre una carpeta y elige Traffic Replay. En Automatic, añade zonas, cantidad, velocidad y conducta; luego Generate. Los autos aparecen quietos: todavía no conducen. Revisa cuántos se generaron realmente. Generate de nuevo reconstruye la flota y descarta sus cambios individuales y rutas."],
      trafficPlace: ["Elige y coloca cada auto de tráfico", "Advanced permite códigos de vehículos instalados con sugerencias por prefijo o copias de My Vehicles. Reemplaza o elimina autos individuales. Position on ground muestra el vehículo, no ejes de gizmo: WASD mueve según la vista, la rueda gira, Espacio cambia vehículo/cámara y X coloca apuntando. Enter confirma y Retroceso cancela. Align to traffic es independiente y busca un carril cercano."],
      trafficRoute: ["Dibuja trayectorias suaves para vehículos", "En un auto preparado, abre Vehicle trajectory → Draw route. El inicio queda en el auto; marca destinos hacia delante con clic izquierdo y acepta con Enter o cancela con Esc. Corner smoothing va de 2 a 20 m. Deja espacio para todo el vehículo. La velocidad es máxima: reduce al doblar y al terminar. Start delay debe ser menor que la duración de grabación."],
      trafficRecord: ["Graba y reutiliza el tráfico", "Termina posiciones y rutas; Record traffic libera los autos quietos con un reloj común. Detén y guarda la toma, y añádela desde Vehicle Replay a Custom Scenes o Timeline. Se guarda el movimiento real, no una futura simulación de IA. Confirmar otra posición borra la ruta de ese auto; reemplazar su modelo la conserva. La IA aún puede chocar: revisa la toma."],
      actorStyles: ["Dale al actor un estilo de caminar y apuntar", "Abre aquí Actor Sequence, dibuja la ruta y elige al actor. Actor → Actor styles define el estilo de caminar y de arma; los puntos pueden sobrescribirlos. Default restaura el movimiento normal; heredar usa la elección del actor. Selecciona un arma compatible para apuntar. Los estilos incluidos no necesitan otro recurso de emotes; previsualiza cómo se ven en el modelo elegido."],
      actorRoute: ["Suaviza la trayectoria del actor", "En Route → Route motion, usa Smooth path y Corner radius (0,20–3,00 m). Las rutas nuevas lo activan; las antiguas conservan su comportamiento hasta que lo habilites. Las curvas de paso y los cambios caminar/correr son graduales. Los puntos con espera o evento siguen siendo paradas exactas. Revisa la curva verde junto a obstáculos: suavizar no permite atravesar paredes."],
      actorEvents: ["Combina movimiento y eventos por punto", "En Events, selecciona un punto y añade esperas, giros, animaciones, cambios de arma o apuntado. El evento se ejecuta al llegar, no solo porque pasó el tiempo estimado. Animaciones compatibles de torso pueden combinarse con caminar; las de cuerpo entero pueden requerir detenerse. En Review, compara Scrub con Preview y guarda. Si una ruta suave se bloquea, vence su tiempo sin ejecutar eventos de llegada inalcanzables."],
      textFacing: ["Texto fijo o mirando a la cámara", "Abre aquí Cinematic Text. Escribe, elige una fuente incluida y su apariencia, y coloca el anclaje con gizmo. Fixed conserva el giro en el mundo; Face camera gira hacia la cámara activa. Finaliza el gizmo antes de cambiar. Un cartel fijo de canto o detrás de geometría puede quedar oculto: revisa ángulo y posición antes de aumentar su tamaño."],
      textCapture: ["Programa y graba el texto cinematográfico", "Elige duración y animación de entrada/salida, previsualiza y guarda en la escena o Timeline. Ambos modos mantienen el mismo tamaño en el mundo. Las fuentes funcionan sin conexión, con sustitución para caracteres ausentes. El texto aparece en vivo y en EXPORT directo, pero Rockstar Editor no graba su superficie DUI: ACTION se bloquea si la producción contiene Cinematic Text."],
    },
    de: {
      sceneGround: ["Eine Szene auf den Boden setzen", "Öffne nach der Tour Scene oder Place im Katalog. G setzt im Platzierungsmodus die ganze Szene auf die Fläche darunter, ohne Drehung oder Actor-/Prop-Offsets zu ändern. Funktioniert beim Bewegen, in der freien Kamera und beim Zielen; Zielen wechselt zurück zu manuell. Q/E korrigiert die Höhe, Enter bestätigt. Das ist nicht die G-Zielsperre der Kamera."],
      environmentSave: ["Eine Umgebung in der Produktion speichern", "Erstelle und platziere zuerst ein Environment, wähle Formation, Darsteller und Blickrichtung und wähle es aus. Diese Environment-Schaltfläche fügt einen Snapshot zur Custom Scene hinzu; Timeline bietet dieselbe Ebene. Spätere Live-Änderungen überschreiben den Snapshot nicht automatisch. Ersetze ihn bei Bedarf ausdrücklich, passe das Timing an und speichere die Produktion."],
      productionTiming: ["Die neuen Ebenen koordinieren", "Der Clip-Start bestimmt seine Position auf der Produktionsuhr; der Quellversatz bestimmt den Einstieg in seinen Inhalt. Traffic-Verzögerungen einzelner Autos sind bereits in der Aufnahme enthalten. Gehzeiten in Actor Sequence sind Schätzungen: Vergleiche Preview und Kamera und passe das Timing an. Scrubbing prüft eine Pose, nicht die Live-KI. Speichere nach der Bearbeitung einer Ebene das Projekt."],
      replayCrew: ["Fahrer und Passagiere zuweisen", "Weise in den Vehicle-Replay-Einstellungen Peds den verfügbaren Fahrzeugsitzen zu. Driver ist Sitz -1, ab 0 folgen Passagiere. Vier Sitzplätze bedeuten einen Fahrer und drei Passagiere. Replay recorded weapon fire ist standardmäßig aus: Lasse es bei unbewaffneten Autos aus, um Gesten durch gemeinsame Angriffstasten zu vermeiden. Aktiviere es nur für eine geeignete bewaffnete Aufnahme."],
      replaySave: ["Eine weitere Aufnahme sicher speichern", "Öffne hier einen Vehicle-Replay-Ordner, nimm auf, stoppe mit E, benenne die Aufnahme und wähle Save. Warte vor der nächsten Aufnahme auf die Serverbestätigung. Namen sind Beschriftungen, keine Replay-Identität. Neue Aufnahmen können an bereits verwendete Ordner angehängt werden. Bei einem Fehler bleibt die ausstehende Aufnahme erhalten: erneut versuchen und die Ressource nicht während des Uploads schließen."],
      trafficGenerate: ["Traffic Replay: eine stehende Flotte vorbereiten", "Öffne nach der Tour hier Vehicle Replay, erstelle oder öffne einen Ordner und wähle Traffic Replay. Lege unter Automatic Zonen, Anzahl, Geschwindigkeit und Verhalten fest und wähle Generate. Die Autos erscheinen zunächst stehend. Prüfe die tatsächliche Anzahl. Erneutes Generate baut die Flotte neu auf und verwirft individuelle Änderungen und Routen."],
      trafficPlace: ["Jedes Verkehrsauto wählen und platzieren", "Advanced bietet installierte Spawn-Codes mit Präfixvorschlägen oder Kopien aus My Vehicles. Einzelne Autos lassen sich ersetzen oder entfernen. Position on ground zeigt ein Fahrzeug statt Gizmo-Achsen: WASD bewegt relativ zur Ansicht, das Mausrad dreht, Leertaste wechselt Fahrzeug/Kamera, X platziert per Zielpunkt. Enter bestätigt, Rücktaste bricht ab. Align to traffic sucht separat eine nahe Fahrspur."],
      trafficRoute: ["Weiche Fahrzeugtrajektorien zeichnen", "Öffne beim vorbereiteten Auto Vehicle trajectory → Draw route. Der Start bleibt am Auto. Setze Ziele nach vorne mit Linksklick, bestätige mit Enter oder brich mit Esc ab. Corner smoothing reicht von 2 bis 20 m. Lass Platz für das gesamte Auto. Die Geschwindigkeit ist ein Maximum; Kurven und Endpunkt bremsen es ab. Start delay muss kürzer als die Aufnahme sein."],
      trafficRecord: ["Verkehr aufnehmen und wiederverwenden", "Beende Platzierung und Routen. Record traffic startet die stehenden Autos mit einer gemeinsamen Uhr. Stoppe und speichere die Aufnahme und füge sie über Vehicle Replay in Custom Scenes oder Timeline ein. Gespeichert wird echte Bewegung, keine spätere KI-Simulation. Eine bestätigte neue Position löscht die Route; ein Modellwechsel erhält sie. Die KI kann weiterhin kollidieren: Prüfe die Aufnahme."],
      actorStyles: ["Geh- und Zielstile für den Darsteller", "Öffne hier Actor Sequence, zeichne eine Route und wähle den Darsteller. Actor → Actor styles legt Gangart und Waffenstil fest; Wegpunkte können sie überschreiben. Default stellt normales Verhalten wieder her, Vererben nutzt die Darstellerauswahl. Wähle zum Zielen eine passende Waffe. Die enthaltenen Stile brauchen keine externe Emote-Ressource; prüfe sie mit dem gewählten Modell in Preview."],
      actorRoute: ["Die Route eines Darstellers glätten", "Nutze unter Route → Route motion Smooth path und Corner radius (0,20–3,00 m). Neue Routen sind geglättet; alte behalten ihr Verhalten, bis du die Option aktivierst. Durchgangskurven und Geh-/Laufwechsel werden sanft. Punkte mit Wartezeit oder Ereignis bleiben genaue Stopps. Prüfe die grüne Kurve an Hindernissen: Eine glatte Route führt nicht durch Wände."],
      actorEvents: ["Bewegung und Wegpunktereignisse kombinieren", "Wähle unter Events einen Wegpunkt und füge Warten, Drehen, Animationen, Waffenwechsel oder Zielen hinzu. Ereignisse starten bei Ankunft, nicht allein nach geschätzter Zeit. Passende Oberkörperanimationen können Gehen überlagern; Ganzkörperaktionen können einen Stopp erfordern. Vergleiche in Review Scrub und Preview, dann speichere. Eine blockierte glatte Route läuft aus, ohne unerreichbare Ankunftsereignisse auszulösen."],
      textFacing: ["Fester Text oder Text zur Kamera", "Öffne hier Cinematic Text. Schreibe den Inhalt, wähle eine mitgelieferte Schrift und das Aussehen und platziere den Anker mit dem Gizmo. Fixed behält die Weltrotation; Face camera dreht zur aktiven Kamera. Beende das Gizmo vor dem Wechsel. Ein festes Schild ist seitlich oder hinter Geometrie möglicherweise unsichtbar: Prüfe Winkel und Position vor der Skalierung."],
      textCapture: ["Filmtext zeitlich steuern und aufnehmen", "Wähle Dauer und Ein-/Ausgangsanimation, prüfe Preview und speichere in Szene oder Timeline. Beide Ausrichtungen behalten dieselbe Weltgröße. Schriften funktionieren offline, fehlende Zeichen nutzen Ersatzschriften. Text erscheint live und im direkten EXPORT, aber Rockstar Editor nimmt die DUI-Fläche nicht auf: ACTION wird bei Produktionen mit Cinematic Text blockiert."],
    },
  };
  Object.assign(productionTutorial, {
    tr: {
      sceneGround: ["Sahneyi zemine yerleştir", "Turdan sonra Scene veya katalogdaki Place düğmesini kullan. Yerleştirme sırasında G, yönü ve oyuncu/nesne ofsetlerini değiştirmeden tüm sahneyi altındaki yüzeye oturtur. Taşıma, serbest kamera ve hedefleyerek yerleştirmede çalışır; hedefleme elle yerleştirmeye döner. Q/E yüksekliği ayarlar, Enter onaylar. Bu, kameranın G hedef kilidi değildir."],
      environmentSave: ["Ortamı yapımına kaydet", "Önce bir Environment oluşturup yerleştir; düzeni, oyuncuları ve bakış yönünü ayarla, ardından ortamı seç. Bu Environment düğmesi Custom Scene içine bir anlık görüntü ekler; Timeline aynı katmanı sunar. Sonraki canlı değişiklikler bu kopyayı otomatik değiştirmez. Gerektiğinde açıkça değiştir, zamanlamasını ayarla ve ana yapımı kaydet."],
      productionTiming: ["Yeni katmanları eş zamanla", "Klip başlangıcı yapım saatindeki yerini, kaynak ofseti ise içeriğin hangi anından başlayacağını belirler. Traffic araç gecikmeleri zaten kaydın içindedir. Actor Sequence yürüme süreleri tahminidir: Preview ile kamerayı karşılaştırıp zamanlamayı ayarla. Scrub bir pozu inceler, canlı yapay zekâyı değil. İç katmanı düzenledikten sonra projeyi kaydet."],
      replayCrew: ["Sürücü ve yolcuları ata", "Vehicle Replay ayarlarında her aracın desteklediği koltuklara ped ata. Driver koltuğu -1, yolcu koltukları 0 ve sonrasıdır. Dört toplam koltuk, bir sürücü ve üç yolcu demektir. Replay recorded weapon fire varsayılan olarak kapalıdır; ortak saldırı tuşunun jestlerini önlemek için silahsız araçlarda kapalı bırak. Yalnızca uygun silahlı çekimlerde aç."],
      replaySave: ["Yeni çekimi güvenle kaydet", "Buradan Vehicle Replay klasörünü aç, kayıt yap, E ile durdur, adlandır ve Save seç. Yeniden kayıttan önce sunucu onayını bekle. Adlar etikettir; yeniden adlandırma replay kimliğini değiştirmez. Sahnenin kullandığı klasöre de yeni çekim eklenebilir. Kayıt başarısızsa bekleyen çekimi koruyup tekrar dene; yükleme sırasında kaynağı kapatma."],
      trafficGenerate: ["Traffic Replay: duran bir filo hazırla", "Turdan sonra buradan Vehicle Replay aç, klasör oluştur veya aç ve Traffic Replay seç. Automatic modunda bölgeleri, araç sayısını, hızı ve davranışı ayarlayıp Generate kullan. Araçlar durarak belirir; henüz sürmezler. Gerçek sayıyı kontrol et. Tekrar Generate filoyu yeniden kurar, araçlara özel düzenlemeleri ve rotaları siler."],
      trafficPlace: ["Trafikteki her aracı seç ve yerleştir", "Advanced, önek önerileriyle kurulu spawn kodları veya My Vehicles kopyaları ekler. Tek araçları değiştir veya kaldır. Position on ground, gizmo eksenleri değil araç önizlemesi kullanır: WASD görüşe göre taşır, tekerlek döndürür, Space araç/kamera değiştirir, X hedefleyerek yerleştirir. Enter onaylar, Backspace iptal eder. Align to traffic ayrı olarak yakındaki şeridi seçer."],
      trafficRoute: ["Yumuşak araç rotaları çiz", "Hazırlanmış araçta Vehicle trajectory → Draw route aç. Başlangıç araçta kalır; ileri hedefleri sol tıkla ekle, Enter ile kabul et veya Esc ile iptal et. Corner smoothing 2–20 m arasındadır. Tüm araç için yer bırak. Hız üst sınırdır; virajlarda ve bitişte azalır. Start delay kayıt süresinden kısa olmalıdır."],
      trafficRecord: ["Trafiği kaydet ve yeniden kullan", "Konumlandırma ve rotaları bitir; Record traffic duran araçları ortak saatle başlatır. Çekimi durdurup kaydet, Vehicle Replay üzerinden Custom Scenes veya Timeline içine ekle. Gelecekteki yapay zekâ simülasyonu değil, gerçek hareket saklanır. Yeni konumu onaylamak o aracın rotasını siler; modeli değiştirmek korur. Yapay zekâ hâlâ çarpışabilir: çekimi kontrol et."],
      actorStyles: ["Oyuncuya yürüyüş ve nişan stili ver", "Buradan Actor Sequence aç, rotayı çiz ve oyuncuyu seç. Actor → Actor styles yürüyüş ve silah stilini belirler; rota noktaları bunları geçersiz kılabilir. Default normal harekete döner; devralma oyuncu seçimini kullanır. Nişan için uygun silah seç. Dahili stiller harici emote kaynağı gerektirmez; seçilen modelle önizleme yap."],
      actorRoute: ["Oyuncunun rotasını yumuşat", "Route → Route motion altında Smooth path ve Corner radius (0,20–3,00 m) kullan. Yeni rotalarda açıktır; eski rotalar sen açana kadar davranışını korur. Geçiş virajları ve yürüme/koşma değişimleri yumuşar. Bekleme veya olay içeren noktalar kesin durak olarak kalır. Engellerin yanında yeşil eğriyi incele: yumuşatma duvardan geçirmez."],
      actorEvents: ["Hareketi nokta olaylarıyla birleştir", "Events içinde bir nokta seçip bekleme, dönüş, animasyon, silah değiştirme veya nişan ekle. Olay, yalnız tahmini süre dolunca değil, varışta çalışır. Uygun üst gövde animasyonları yürürken oynayabilir; tam gövde eylemleri durmayı gerektirebilir. Review içinde Scrub ve Preview karşılaştırıp kaydet. Engellenen yumuşak rota zaman aşımına uğrar; ulaşılamayan varış olaylarını çalıştırmaz."],
      textFacing: ["Sabit veya kameraya bakan metin", "Buradan Cinematic Text aç. İçeriği yaz, dahili yazı tipi ve görünümü seç, ankrajı gizmo ile yerleştir. Fixed dünya dönüşünü korur; Face camera aktif kameraya döner. Değiştirmeden önce gizmo işlemini bitir. Sabit yazı yandan veya geometri arkasından görünmeyebilir: ölçeği artırmadan açı ve konumu kontrol et."],
      textCapture: ["Sinematik metni zamanla ve kaydet", "Süreyi, giriş/çıkış animasyonunu seç, önizle ve sahne veya Timeline içine kaydet. İki yön modu aynı dünya boyutunu kullanır. Yazı tipleri çevrimdışı çalışır; eksik karakterlerde yedek kullanılır. Metin canlı önizlemede ve doğrudan EXPORT içinde görünür, ancak Rockstar Editor DUI yüzeyini kaydedemez: Cinematic Text içeren yapımlarda ACTION engellenir."],
    },
    fr: {
      sceneGround: ["Poser une scène au sol", "Après le tutoriel, utilisez Scene ou Place dans le catalogue. Pendant le placement, G pose toute la scène sur la surface située dessous sans modifier sa rotation ni les décalages des acteurs et objets. Fonctionne en déplacement, caméra libre et visée ; la visée revient en manuel. Q/E affine la hauteur et Entrée confirme. Ce n'est pas le verrouillage de cible G de la caméra."],
      environmentSave: ["Conserver un environnement dans la production", "Créez et placez d'abord un Environment, choisissez formation, acteurs et direction du regard, puis sélectionnez-le. Ce bouton Environment ajoute un instantané à la Custom Scene ; Timeline propose la même couche. Les modifications ultérieures en direct ne remplacent pas cet instantané automatiquement. Remplacez-le explicitement si nécessaire, réglez son timing et sauvegardez la production."],
      productionTiming: ["Synchroniser les nouvelles couches", "Le début du clip le place sur l'horloge de production ; le décalage source choisit le point d'entrée dans son contenu. Les délais des voitures Traffic sont déjà dans la prise enregistrée. Les durées de marche Actor Sequence sont estimées : comparez Preview et caméra, puis ajustez les clips. Le scrub vérifie une pose, pas l'IA en direct. Sauvegardez après l'édition d'une couche."],
      replayCrew: ["Affecter conducteur et passagers", "Dans les réglages Vehicle Replay, affectez des peds aux sièges disponibles du véhicule. Driver correspond au siège -1 ; les passagers commencent à 0. Quatre places au total signifient un conducteur et trois passagers. Replay recorded weapon fire est désactivé par défaut : laissez-le désactivé dans les voitures sans armes pour éviter les gestes liés au bouton d'attaque. Activez-le seulement pour une prise armée compatible."],
      replaySave: ["Sauvegarder une autre prise sans risque", "Ouvrez ici un dossier Vehicle Replay, enregistrez, arrêtez avec E, nommez la prise et choisissez Save. Attendez la confirmation du serveur avant de recommencer. Les noms sont des étiquettes ; renommer ne change pas l'identité du replay. Vous pouvez ajouter des prises à un dossier déjà utilisé. En cas d'échec, conservez la prise en attente et réessayez ; ne fermez pas la ressource pendant l'envoi."],
      trafficGenerate: ["Traffic Replay : préparer une flotte à l'arrêt", "Après le tutoriel, ouvrez ici Vehicle Replay, créez ou ouvrez un dossier, puis choisissez Traffic Replay. En Automatic, ajoutez des zones, réglez quantité, vitesse et comportement, puis Generate. Les voitures apparaissent immobiles. Vérifiez le nombre réellement généré. Un nouveau Generate reconstruit la flotte et supprime les réglages individuels ainsi que les itinéraires."],
      trafficPlace: ["Choisir et placer chaque voiture", "Advanced permet des codes de véhicules installés avec suggestions par préfixe, ou des copies de My Vehicles. Remplacez ou retirez chaque voiture. Position on ground affiche le véhicule, sans axes de gizmo : WASD déplace selon la vue, la molette tourne, Espace alterne véhicule/caméra et X place par visée. Entrée confirme ; Retour arrière annule. Align to traffic choisit séparément une voie proche."],
      trafficRoute: ["Tracer des trajectoires fluides", "Sur une voiture préparée, ouvrez Vehicle trajectory → Draw route. Le départ reste sur la voiture ; placez les destinations devant avec le clic gauche, puis Entrée pour accepter ou Échap pour annuler. Corner smoothing va de 2 à 20 m. Laissez de la place au véhicule entier. La vitesse est un maximum ; virages et arrivée provoquent un ralentissement. Start delay doit rester inférieur à la durée d'enregistrement."],
      trafficRecord: ["Enregistrer et réutiliser le trafic", "Terminez placements et itinéraires, puis Record traffic libère les voitures avec une horloge commune. Arrêtez et sauvegardez la prise, puis ajoutez-la via Vehicle Replay à Custom Scenes ou Timeline. Le mouvement réel est enregistré, pas une future simulation d'IA. Confirmer une nouvelle position efface son itinéraire ; changer de modèle le conserve. L'IA peut encore heurter des obstacles : vérifiez la prise."],
      actorStyles: ["Choisir le style de marche et de visée", "Ouvrez ici Actor Sequence, tracez une route et choisissez l'acteur. Actor → Actor styles définit démarche et style d'arme ; les points peuvent les remplacer. Default rétablit le mouvement normal ; l'héritage utilise le choix de l'acteur. Choisissez une arme adaptée à la visée. Les styles inclus ne nécessitent pas de ressource d'emotes externe ; prévisualisez-les sur le modèle choisi."],
      actorRoute: ["Adoucir la trajectoire d'un acteur", "Dans Route → Route motion, utilisez Smooth path et Corner radius (0,20–3,00 m). Les nouvelles routes l'activent ; les anciennes gardent leur comportement jusqu'à activation. Les virages de passage et changements marche/course deviennent progressifs. Les points avec attente ou événement restent des arrêts précis. Vérifiez la courbe verte près des obstacles : une route lissée ne traverse pas les murs."],
      actorEvents: ["Combiner déplacement et événements", "Dans Events, sélectionnez un point et ajoutez attentes, rotations, animations, changements d'arme ou visée. L'événement démarre à l'arrivée, pas simplement après le temps estimé. Les animations compatibles du torse peuvent accompagner la marche ; celles du corps entier peuvent nécessiter un arrêt. Dans Review, comparez Scrub et Preview, puis sauvegardez. Une route lissée bloquée expire sans déclencher les événements d'arrivée inaccessibles."],
      textFacing: ["Texte fixe ou tourné vers la caméra", "Ouvrez ici Cinematic Text. Écrivez, choisissez une police incluse et son apparence, puis placez l'ancrage au gizmo. Fixed conserve la rotation dans le monde ; Face camera tourne vers la caméra active. Terminez le gizmo avant de changer. Un panneau fixe vu de profil ou derrière un objet peut disparaître : vérifiez angle et position avant d'augmenter la taille."],
      textCapture: ["Programmer et enregistrer le texte", "Choisissez durée et animation d'entrée/sortie, prévisualisez, puis sauvegardez dans la scène ou Timeline. Les deux orientations gardent la même taille mondiale. Les polices fonctionnent hors ligne, avec remplacement des caractères absents. Le texte apparaît en direct et en EXPORT direct, mais Rockstar Editor n'enregistre pas sa surface DUI : ACTION est bloqué pour les productions contenant Cinematic Text."],
    },
    ar: {
      sceneGround: ["وضع المشهد على الأرض", "بعد الدليل، استخدم Scene أو زر Place في الكتالوج. أثناء التمركز، يضع G المشهد كله على السطح تحته دون تغيير اتجاهه أو إزاحات الممثلين والأغراض. يعمل أثناء التحريك والكاميرا الحرة والتصويب؛ التصويب يعود للوضع اليدوي. يضبط Q/E الارتفاع ويؤكد Enter. هذا ليس قفل هدف الكاميرا بمفتاح G."],
      environmentSave: ["حفظ البيئة ضمن الإنتاج", "أنشئ Environment وضعه أولاً، واضبط التشكيل والممثلين واتجاه النظر ثم حدده. يضيف زر Environment هذا نسخة إلى Custom Scene؛ ويوفر Timeline الطبقة نفسها. التغييرات المباشرة اللاحقة لا تعيد كتابة النسخة تلقائياً. استبدلها صراحة عند الحاجة، واضبط توقيتها ثم احفظ الإنتاج الأساسي."],
      productionTiming: ["تنسيق الطبقات الجديدة", "تحدد بداية المقطع مكانه على ساعة الإنتاج؛ وتحدد إزاحة المصدر نقطة البداية داخل محتواه. تأخيرات سيارات Traffic موجودة بالفعل داخل التسجيل. أزمنة المشي في Actor Sequence تقديرية: قارن Preview بالكاميرا ثم اضبط المقاطع. فحص الإطار يعرض وضعية، لا سلوك الذكاء الاصطناعي المباشر. احفظ المشروع بعد تعديل طبقة داخلية."],
      replayCrew: ["تعيين السائق والركاب", "في إعدادات Vehicle Replay، وزّع الشخصيات على المقاعد التي يدعمها كل مركبة. Driver هو المقعد -1، والركاب يبدأون من 0. أربعة مقاعد إجمالاً تعني سائقاً وثلاثة ركاب. Replay recorded weapon fire معطل افتراضياً؛ اتركه معطلاً للسيارات غير المسلحة لتجنب إيماءات زر الهجوم المشترك. فعّله فقط لتسجيل مسلح متوافق."],
      replaySave: ["حفظ تسجيل إضافي بأمان", "افتح هنا مجلد Vehicle Replay وسجّل ثم أوقف بمفتاح E، وسمّ التسجيل واضغط Save. انتظر تأكيد الخادم قبل التسجيل مجدداً. الأسماء تسميات فقط؛ تغيير الاسم لا يغيّر هوية الإعادة. يمكنك إضافة تسجيلات إلى مجلد تستخدمه مشاهد بالفعل. عند فشل الحفظ احتفظ بالتسجيل المعلق وأعد المحاولة؛ لا تغلق المورد أثناء الرفع."],
      trafficGenerate: ["Traffic Replay: تجهيز سيارات متوقفة", "بعد الدليل، افتح Vehicle Replay من هنا، وأنشئ أو افتح مجلداً ثم اختر Traffic Replay. في Automatic، أضف مناطق واضبط العدد والسرعة والسلوك ثم Generate. تظهر السيارات متوقفة؛ لم تبدأ القيادة بعد. راجع العدد الفعلي. استخدام Generate مجدداً يعيد إنشاء المجموعة ويلغي تعديلات السيارات ومساراتها."],
      trafficPlace: ["اختيار كل سيارة وتمركزها", "يتيح Advanced رموز المركبات المثبتة مع اقتراحات حسب البداية، أو نسخاً من My Vehicles. استبدل سيارات منفردة أو احذفها. يعرض Position on ground السيارة لا محاور gizmo: يحرك WASD بحسب الرؤية، وتدير العجلة، ويبدّل Space السيارة/الكاميرا، ويضع X بالتصويب. يؤكد Enter ويلغي Backspace. يختار Align to traffic مسار طريق قريباً بشكل منفصل."],
      trafficRoute: ["رسم مسارات سيارات سلسة", "في سيارة مجهزة، افتح Vehicle trajectory → Draw route. تبقى البداية عند السيارة؛ ضع وجهات أمامها بالنقر الأيسر، ثم Enter للقبول أو Esc للإلغاء. يتراوح Corner smoothing بين 2 و20 متراً. اترك مساحة للسيارة كاملة. السرعة حد أقصى؛ تخف عند المنعطفات والنهاية. يجب أن يكون Start delay أقصر من مدة التسجيل."],
      trafficRecord: ["تسجيل المرور وإعادة استخدامه", "أكمل التمركز والمسارات؛ يطلق Record traffic السيارات المتوقفة بساعة واحدة. أوقف التسجيل واحفظه ثم أضفه عبر Vehicle Replay إلى Custom Scenes أو Timeline. يُحفظ التحرك الفعلي لا محاكاة ذكاء اصطناعي مستقبلية. تأكيد موضع جديد يمسح مسار السيارة؛ استبدال نموذجها يبقيه. قد يصطدم الذكاء الاصطناعي رغم ذلك؛ راجع التسجيل."],
      actorStyles: ["منح الممثل أسلوب مشي وتصويب", "افتح Actor Sequence هنا، وارسم المسار ثم اختر الممثل. يحدد Actor → Actor styles أسلوب المشي والسلاح؛ ويمكن للنقاط تجاوزه. يعيد Default الحركة العادية، بينما الوراثة تستخدم اختيار الممثل. اختر سلاحاً متوافقاً للتصويب. الأساليب المضمنة لا تحتاج مورداً خارجياً للحركات؛ عاين أداء النموذج المختار."],
      actorRoute: ["تنعيم مسار الممثل", "في Route → Route motion، استخدم Smooth path وCorner radius بين 0.20 و3.00 أمتار. تُفعّل للطرق الجديدة؛ القديمة تحتفظ بسلوكها حتى تختار تفعيلها. تصبح منعطفات المرور وتبدلات المشي/الجري تدريجية. النقاط ذات الانتظار أو الحدث تبقى توقفات دقيقة. افحص المنحنى الأخضر قرب العوائق؛ التنعيم لا يسمح باختراق الجدران."],
      actorEvents: ["الجمع بين الحركة وأحداث النقاط", "في Events، حدد نقطة وأضف انتظاراً أو دوراناً أو حركة أو تغيير سلاح أو تصويباً. يعمل الحدث عند الوصول، لا لمجرد انتهاء الوقت التقديري. قد تتداخل حركات الجزء العلوي المتوافقة مع المشي؛ وقد تتطلب حركات الجسم الكامل التوقف. في Review، قارن Scrub مع Preview ثم احفظ. ينتهي المسار السلس المعاق بمهلة دون تشغيل أحداث وصول غير قابلة للوصول."],
      textFacing: ["نص ثابت أو مواجه للكاميرا", "افتح Cinematic Text هنا. اكتب المحتوى واختر خطاً مضمناً ومظهراً، ثم ضع المرساة باستخدام gizmo. يحفظ Fixed دوران العالم؛ ويوجه Face camera النص إلى الكاميرا النشطة. أنهِ gizmo قبل التبديل. قد تختفي لوحة ثابتة عند النظر لحافتها أو خلف جسم؛ راجع الزاوية والموقع قبل تكبير الحجم."],
      textCapture: ["توقيت النص السينمائي وتسجيله", "اختر المدة وحركة الدخول والخروج، ثم عاين واحفظ في المشهد أو Timeline. يستخدم وضعا الاتجاه الحجم العالمي نفسه. تعمل الخطوط دون اتصال مع بدائل للمحارف الناقصة. يظهر النص مباشرة وفي EXPORT المباشر، لكن Rockstar Editor لا يسجل سطح DUI الخاص به؛ لذلك يُحظر ACTION في إنتاج يحتوي Cinematic Text."],
    },
  });
  Object.assign(productionTutorial, {
    vi: {
      sceneGround: ["Đặt cảnh xuống mặt đất", "Sau hướng dẫn, dùng Scene hoặc Place trong danh mục. Khi đặt cảnh, G đưa cả cảnh xuống bề mặt bên dưới mà không đổi hướng hay độ lệch diễn viên/đạo cụ. Hoạt động khi di chuyển, camera tự do và đặt theo hướng ngắm; chế độ ngắm trở về thủ công. Q/E chỉnh cao độ, Enter xác nhận. Đây không phải khóa mục tiêu G của camera."],
      environmentSave: ["Lưu môi trường vào sản phẩm", "Tạo và đặt Environment trước, chỉnh đội hình, diễn viên và hướng nhìn rồi chọn nó. Nút Environment này thêm một bản chụp vào Custom Scene; Timeline có cùng loại lớp. Thay đổi trực tiếp sau đó không tự sửa bản chụp. Hãy chủ động thay thế khi cần, chỉnh thời gian và lưu sản phẩm chứa nó."],
      productionTiming: ["Đồng bộ các lớp mới", "Thời điểm bắt đầu clip đặt nó trên đồng hồ sản phẩm; độ lệch nguồn chọn điểm bắt đầu trong nội dung. Độ trễ xe Traffic đã nằm trong bản ghi. Thời gian đi bộ Actor Sequence là ước tính: so Preview với camera rồi chỉnh clip. Scrub kiểm tra tư thế, không mô phỏng AI trực tiếp. Lưu dự án sau khi sửa lớp con."],
      replayCrew: ["Gán tài xế và hành khách", "Trong cài đặt Vehicle Replay, gán ped vào các ghế xe hỗ trợ. Driver là ghế -1; ghế từ 0 là hành khách. Bốn ghế tổng cộng nghĩa là một tài xế và ba hành khách. Replay recorded weapon fire mặc định tắt; giữ tắt trên xe không vũ trang để tránh cử chỉ do dùng chung nút tấn công. Chỉ bật với bản ghi vũ trang tương thích."],
      replaySave: ["Lưu thêm lượt quay an toàn", "Mở thư mục Vehicle Replay tại đây, ghi, dừng bằng E, đặt tên và Save. Chờ máy chủ xác nhận trước khi ghi tiếp. Tên chỉ là nhãn; đổi tên không đổi danh tính replay. Có thể thêm bản ghi vào thư mục đang được cảnh sử dụng. Nếu lưu lỗi, giữ bản ghi chờ và thử lại; không đóng tài nguyên khi đang tải lên."],
      trafficGenerate: ["Traffic Replay: chuẩn bị đoàn xe đứng yên", "Sau hướng dẫn, mở Vehicle Replay tại đây, tạo hoặc mở thư mục rồi chọn Traffic Replay. Trong Automatic, thêm vùng, đặt số lượng, tốc độ và hành vi rồi Generate. Xe xuất hiện đứng yên, chưa chạy. Kiểm tra số xe thực tế. Generate lần nữa dựng lại đoàn xe và bỏ chỉnh sửa riêng cùng tuyến đường."],
      trafficPlace: ["Chọn và đặt từng xe giao thông", "Advanced thêm mã xe đã cài với gợi ý theo tiền tố hoặc bản sao từ My Vehicles. Thay hay xóa từng xe. Position on ground hiển thị xe thay vì trục gizmo: WASD di chuyển theo góc nhìn, cuộn chuột xoay, Space đổi xe/camera, X đặt theo hướng ngắm. Enter xác nhận; Backspace hủy. Align to traffic chọn riêng một làn gần đó."],
      trafficRoute: ["Vẽ quỹ đạo xe mượt", "Trên xe đã chuẩn bị, mở Vehicle trajectory → Draw route. Điểm đầu giữ tại xe; nhấp trái đặt các đích phía trước, Enter chấp nhận hoặc Esc hủy. Corner smoothing từ 2–20 m. Chừa chỗ cho cả thân xe. Tốc độ là giới hạn tối đa; xe giảm tốc ở cua và điểm cuối. Start delay phải ngắn hơn thời gian ghi."],
      trafficRecord: ["Ghi và tái sử dụng giao thông", "Hoàn tất vị trí và tuyến đường; Record traffic cho xe chạy theo một đồng hồ chung. Dừng, lưu bản ghi rồi thêm qua Vehicle Replay vào Custom Scenes hoặc Timeline. Lưu chuyển động thực, không phải mô phỏng AI tương lai. Xác nhận vị trí mới xóa tuyến của xe đó; đổi mẫu xe giữ tuyến. AI vẫn có thể va chạm: kiểm tra bản ghi."],
      actorStyles: ["Chọn dáng đi và kiểu ngắm", "Mở Actor Sequence tại đây, vẽ đường rồi chọn diễn viên. Actor → Actor styles đặt dáng đi và kiểu vũ khí; từng điểm có thể ghi đè. Default khôi phục chuyển động thường; kế thừa dùng lựa chọn của diễn viên. Chọn vũ khí phù hợp để ngắm. Các kiểu có sẵn không cần tài nguyên emote ngoài; xem thử trên mẫu nhân vật đã chọn."],
      actorRoute: ["Làm mượt đường đi của diễn viên", "Trong Route → Route motion, dùng Smooth path và Corner radius (0,20–3,00 m). Đường mới bật sẵn; đường cũ giữ hành vi đến khi bạn bật. Các cua chuyển tiếp và đổi đi/chạy trở nên từ từ. Điểm có chờ hoặc sự kiện vẫn là điểm dừng chính xác. Kiểm tra đường xanh gần chướng ngại: làm mượt không cho phép xuyên tường."],
      actorEvents: ["Kết hợp di chuyển với sự kiện tại điểm", "Trong Events, chọn điểm rồi thêm chờ, xoay, hoạt ảnh, đổi vũ khí hoặc ngắm. Sự kiện chạy khi đến nơi, không chỉ vì hết thời gian ước tính. Hoạt ảnh thân trên tương thích có thể kết hợp đi bộ; hoạt động toàn thân có thể cần dừng. Trong Review, so Scrub với Preview rồi lưu. Đường mượt bị chặn sẽ hết thời gian mà không kích hoạt sự kiện đến nơi không thể tới."],
      textFacing: ["Chữ cố định hoặc hướng về camera", "Mở Cinematic Text tại đây. Viết nội dung, chọn phông có sẵn và hình thức rồi đặt neo bằng gizmo. Fixed giữ góc xoay trong thế giới; Face camera quay về camera đang dùng. Kết thúc gizmo trước khi đổi. Biển cố định nhìn từ cạnh hoặc sau vật thể có thể không thấy: kiểm tra góc và vị trí trước khi tăng cỡ."],
      textCapture: ["Đặt thời gian và ghi chữ điện ảnh", "Chọn thời lượng, hoạt ảnh vào/ra, xem thử rồi lưu vào cảnh hoặc Timeline. Hai hướng hiển thị dùng cùng kích thước thế giới. Phông hoạt động ngoại tuyến, ký tự thiếu dùng phông dự phòng. Chữ xuất hiện trực tiếp và trong EXPORT trực tiếp, nhưng Rockstar Editor không ghi bề mặt DUI: ACTION bị chặn với sản phẩm có Cinematic Text."],
    },
    pl: {
      sceneGround: ["Ustaw scenę na ziemi", "Po samouczku użyj Scene lub Place w katalogu. Podczas rozmieszczania G ustawia całą scenę na powierzchni poniżej bez zmiany obrotu i przesunięć aktorów/rekwizytów. Działa przy przesuwaniu, swobodnej kamerze i celowaniu; celowanie wraca do trybu ręcznego. Q/E koryguje wysokość, Enter zatwierdza. To nie jest blokada celu kamery pod G."],
      environmentSave: ["Zachowaj otoczenie w produkcji", "Najpierw utwórz i umieść Environment, ustaw formację, aktorów i kierunek spojrzenia, a następnie je wybierz. Ten przycisk Environment dodaje migawkę do Custom Scene; Timeline oferuje tę samą warstwę. Późniejsze zmiany na żywo nie nadpisują migawki automatycznie. Zastąp ją świadomie, gdy chcesz, ustaw czas i zapisz produkcję."],
      productionTiming: ["Zsynchronizuj nowe warstwy", "Początek klipu określa jego miejsce na zegarze produkcji; przesunięcie źródła wybiera moment wejścia w zawartość. Opóźnienia aut Traffic są już zawarte w nagraniu. Czasy chodzenia Actor Sequence są szacunkowe: porównaj Preview z kamerą i dopasuj klipy. Scrub sprawdza pozę, nie działanie AI na żywo. Zapisz projekt po edycji warstwy."],
      replayCrew: ["Przypisz kierowcę i pasażerów", "W ustawieniach Vehicle Replay przypisz pedy do miejsc obsługiwanych przez pojazd. Driver to miejsce -1, pasażerowie zaczynają się od 0. Cztery miejsca łącznie oznaczają kierowcę i trzech pasażerów. Replay recorded weapon fire jest domyślnie wyłączone: pozostaw je tak w nieuzbrojonych autach, aby uniknąć gestów wspólnego przycisku ataku. Włącz tylko dla odpowiedniego uzbrojonego nagrania."],
      replaySave: ["Bezpiecznie zapisz kolejne ujęcie", "Otwórz tutaj folder Vehicle Replay, nagraj, zatrzymaj klawiszem E, nazwij ujęcie i wybierz Save. Przed następnym nagraniem poczekaj na potwierdzenie serwera. Nazwy są etykietami, nie tożsamością replaya. Można dopisywać ujęcia do folderu używanego przez scenę. Przy błędzie zachowaj oczekujące ujęcie i spróbuj ponownie; nie zamykaj zasobu podczas wysyłania."],
      trafficGenerate: ["Traffic Replay: przygotuj stojącą flotę", "Po samouczku otwórz tutaj Vehicle Replay, utwórz lub otwórz folder i wybierz Traffic Replay. W Automatic dodaj strefy, liczbę aut, prędkość i zachowanie, następnie Generate. Auta pojawiają się nieruchome. Sprawdź faktyczną liczbę. Ponowne Generate odbudowuje flotę i usuwa indywidualne zmiany oraz trasy."],
      trafficPlace: ["Wybierz i ustaw każde auto", "Advanced dodaje zainstalowane kody pojazdów z podpowiedziami prefiksu lub kopie z My Vehicles. Zastępuj albo usuwaj pojedyncze auta. Position on ground pokazuje pojazd zamiast osi gizma: WASD przesuwa względem widoku, kółko obraca, Spacja przełącza auto/kamerę, X ustawia celowaniem. Enter zatwierdza, Backspace anuluje. Align to traffic osobno wybiera pobliski pas."],
      trafficRoute: ["Rysuj płynne trajektorie aut", "Dla przygotowanego auta otwórz Vehicle trajectory → Draw route. Początek pozostaje przy aucie; dodaj cele przed nim lewym kliknięciem, Enter zatwierdza, Esc anuluje. Corner smoothing ma zakres 2–20 m. Zostaw miejsce na cały pojazd. Prędkość jest maksimum; zakręty i punkt końcowy powodują hamowanie. Start delay musi być krótsze od nagrania."],
      trafficRecord: ["Nagraj ruch i użyj go ponownie", "Zakończ ustawianie i trasy; Record traffic uruchamia stojące auta według wspólnego zegara. Zatrzymaj i zapisz ujęcie, potem dodaj przez Vehicle Replay do Custom Scenes lub Timeline. Zapisywany jest rzeczywisty ruch, nie przyszła symulacja AI. Zatwierdzenie nowej pozycji usuwa trasę auta; wymiana modelu ją zachowuje. AI nadal może zderzać się z przeszkodami: sprawdź ujęcie."],
      actorStyles: ["Nadaj aktorowi styl chodu i celowania", "Otwórz tutaj Actor Sequence, narysuj trasę i wybierz aktora. Actor → Actor styles ustawia chód i styl broni; punkty mogą je nadpisywać. Default przywraca normalny ruch, dziedziczenie używa wyboru aktora. Wybierz odpowiednią broń do celowania. Wbudowane style nie wymagają zewnętrznych emotek; sprawdź ich wygląd na wybranym modelu."],
      actorRoute: ["Wygładź trasę aktora", "W Route → Route motion użyj Smooth path i Corner radius (0,20–3,00 m). Nowe trasy mają wygładzanie włączone; stare zachowują ruch do ręcznego włączenia. Przejazdowe zakręty i zmiany chód/bieg stają się stopniowe. Punkty z oczekiwaniem lub zdarzeniem pozostają dokładnymi przystankami. Sprawdź zieloną krzywą przy przeszkodach: wygładzanie nie pozwala przechodzić przez ściany."],
      actorEvents: ["Połącz ruch ze zdarzeniami punktów", "W Events wybierz punkt i dodaj oczekiwanie, obrót, animację, zmianę broni lub celowanie. Zdarzenie uruchamia się po dotarciu, nie tylko po upływie szacowanego czasu. Zgodne animacje tułowia mogą łączyć się z chodzeniem; całego ciała mogą wymagać postoju. W Review porównaj Scrub i Preview, potem zapisz. Zablokowana wygładzona trasa kończy się limitem czasu bez zdarzeń nieosiągalnego punktu."],
      textFacing: ["Tekst stały lub skierowany do kamery", "Otwórz tutaj Cinematic Text. Wpisz treść, wybierz dołączoną czcionkę i wygląd, potem ustaw kotwicę gizmem. Fixed zachowuje obrót świata; Face camera zwraca się do aktywnej kamery. Zakończ gizmo przed zmianą. Stały napis widziany z boku lub za geometrią może być niewidoczny: sprawdź kąt i pozycję przed zwiększeniem skali."],
      textCapture: ["Ustaw czas i nagraj tekst filmowy", "Wybierz czas oraz animację wejścia/wyjścia, sprawdź podgląd i zapisz w scenie lub Timeline. Oba tryby zachowują ten sam rozmiar w świecie. Czcionki działają offline, brakujące znaki korzystają z zamienników. Tekst jest widoczny na żywo i w bezpośrednim EXPORT, ale Rockstar Editor nie nagrywa powierzchni DUI: ACTION jest blokowane dla produkcji z Cinematic Text."],
    },
    "pt-br": {
      sceneGround: ["Coloque a cena no chão", "Depois do tutorial, use Scene ou Place no catálogo. Durante o posicionamento, G coloca toda a cena na superfície abaixo sem alterar a rotação nem os offsets de atores e objetos. Funciona ao mover, na câmera livre e ao mirar; a mira volta ao modo manual. Q/E ajusta a altura e Enter confirma. Não é a trava de alvo G da câmera."],
      environmentSave: ["Guarde um ambiente na produção", "Primeiro crie e posicione um Environment, ajuste formação, atores e direção do olhar e selecione-o. Este botão Environment adiciona uma cópia à Custom Scene; Timeline oferece a mesma camada. Mudanças ao vivo posteriores não reescrevem a cópia automaticamente. Substitua-a explicitamente quando quiser, ajuste o tempo e salve a produção principal."],
      productionTiming: ["Sincronize as novas camadas", "O início do clipe o posiciona no relógio da produção; o deslocamento de origem escolhe onde seu conteúdo começa. Os atrasos dos carros Traffic já estão dentro da gravação. Os tempos de caminhada de Actor Sequence são estimativas: compare Preview com a câmera e ajuste os clipes. Scrub verifica uma pose, não a IA ao vivo. Salve o projeto após editar uma camada."],
      replayCrew: ["Atribua motorista e passageiros", "Nas configurações de Vehicle Replay, atribua peds aos assentos disponíveis de cada veículo. Driver é o assento -1; de 0 em diante são passageiros. Quatro lugares no total significam motorista e três passageiros. Replay recorded weapon fire vem desativado: deixe assim nos carros sem armas para evitar gestos do controle compartilhado de ataque. Ative apenas para uma gravação armada compatível."],
      replaySave: ["Salve outra tomada com segurança", "Abra aqui uma pasta de Vehicle Replay, grave, pare com E, dê um nome e use Save. Aguarde a confirmação do servidor antes de gravar novamente. Nomes são rótulos; renomear não muda a identidade do replay. É possível acrescentar tomadas a pastas já usadas por cenas. Se o salvamento falhar, mantenha a tomada pendente e tente novamente; não feche o recurso durante o envio."],
      trafficGenerate: ["Traffic Replay: prepare uma frota parada", "Depois do tutorial, abra Vehicle Replay aqui, crie ou abra uma pasta e escolha Traffic Replay. Em Automatic, adicione zonas, quantidade, velocidade e comportamento; depois Generate. Os carros aparecem parados e ainda não dirigem. Confira a quantidade real. Generate novamente reconstrói a frota e descarta alterações individuais e rotas."],
      trafficPlace: ["Escolha e posicione cada carro", "Advanced permite códigos de veículos instalados com sugestões por prefixo ou cópias de My Vehicles. Substitua ou remova carros individuais. Position on ground mostra o veículo, não eixos de gizmo: WASD move conforme a visão, a roda gira, Espaço alterna veículo/câmera e X posiciona mirando. Enter confirma e Backspace cancela. Align to traffic escolhe uma faixa próxima separadamente."],
      trafficRoute: ["Desenhe trajetórias suaves para carros", "Em um carro preparado, abra Vehicle trajectory → Draw route. O início fica no carro; marque destinos à frente com clique esquerdo, Enter aceita e Esc cancela. Corner smoothing vai de 2 a 20 m. Deixe espaço para o veículo inteiro. A velocidade é máxima; ele reduz nas curvas e no fim. Start delay deve ser menor que a duração da gravação."],
      trafficRecord: ["Grave e reutilize o trânsito", "Conclua posições e rotas; Record traffic libera os carros parados usando um relógio comum. Pare e salve a tomada, depois adicione via Vehicle Replay a Custom Scenes ou Timeline. O movimento real é salvo, não uma simulação futura de IA. Confirmar outra posição apaga a rota daquele carro; substituir o modelo a preserva. A IA ainda pode bater: confira a tomada."],
      actorStyles: ["Dê ao ator um estilo de andar e mirar", "Abra Actor Sequence aqui, desenhe a rota e escolha o ator. Actor → Actor styles define o estilo de caminhada e de arma; os pontos podem substituí-los. Default restaura o movimento normal; herdar usa a escolha do ator. Escolha uma arma compatível para mirar. Os estilos incluídos não precisam de outro recurso de emotes; visualize como ficam no modelo escolhido."],
      actorRoute: ["Suavize a trajetória do ator", "Em Route → Route motion, use Smooth path e Corner radius (0,20–3,00 m). Rotas novas ativam a opção; antigas mantêm seu comportamento até você habilitar. Curvas de passagem e mudanças andar/correr ficam graduais. Pontos com espera ou evento continuam sendo paradas exatas. Confira a curva verde perto de obstáculos: suavizar não permite atravessar paredes."],
      actorEvents: ["Combine movimento e eventos por ponto", "Em Events, selecione um ponto e adicione esperas, giros, animações, trocas de arma ou mira. O evento acontece na chegada, não só porque o tempo estimado passou. Animações compatíveis de torso podem acompanhar a caminhada; ações de corpo inteiro podem exigir parada. Em Review, compare Scrub com Preview e salve. Uma rota suave bloqueada expira sem executar eventos de chegada inacessíveis."],
      textFacing: ["Texto fixo ou voltado à câmera", "Abra Cinematic Text aqui. Escreva o conteúdo, escolha uma fonte incluída e a aparência, e posicione a âncora com gizmo. Fixed mantém a rotação no mundo; Face camera gira para a câmera ativa. Termine o gizmo antes de alternar. Um letreiro fixo de lado ou atrás de geometria pode sumir: confira ângulo e posição antes de aumentar a escala."],
      textCapture: ["Programe e grave o texto cinematográfico", "Escolha duração e animação de entrada/saída, visualize e salve na cena ou Timeline. Os dois modos mantêm o mesmo tamanho no mundo. As fontes funcionam offline, com substituição para caracteres ausentes. O texto aparece ao vivo e no EXPORT direto, mas Rockstar Editor não grava sua superfície DUI: ACTION é bloqueado em produções com Cinematic Text."],
    },
  });
  Object.entries(productionTutorial).forEach(([locale, steps]) => {
    Object.entries(steps).forEach(([id, [title, body]]) => {
      catalogs[locale][`tutorial.step.${id}.title`] = title;
      catalogs[locale][`tutorial.step.${id}.body`] = body;
    });
  });

  const editingTutorial = {
  "en": {
    "pedClothes": [
      "Choose clothes and textures",
      "After the tour, open My Peds and edit an appearance. In Clothes, Drawable selects the garment and Texture selects its variant. The number after / is the maximum valid index for that model. The arrows wrap around the range; props also use -1 for no accessory. Changing a garment resets its texture. Check arms, undershirt and jacket together for gaps."
    ],
    "pedRandomize": [
      "Randomize only your selection",
      "In Ped Studio, expand Randomize, tick the parts you want and choose Randomize selection. Male freemode supports hair, eyebrows, beard, jackets, shoes and pants; randomizing male clothing also sets Undershirt to 15. Female freemode supports hair, undershirt, shoes and jackets. Review the result before saving; parts not selected stay unchanged except the male undershirt rule."
    ],
    "pedSave": [
      "Inspect and save the appearance",
      "Drag in the preview to rotate the character and use the wheel to move the camera. The side tools focus the face or body and temporarily hide clothing for inspection. Hidden preview clothing is not saved. Choose Save Ped and confirm to keep the appearance; Cancel and Discard changes restore the appearance from before opening the editor. A freemode model is required for face sculpting and heritage."
    ],
    "previewFolders": [
      "Preview before adding or filing",
      "Open a scene, animation or effect preview and browse its list without leaving the view. Save to folder lets you choose or create a folder; Add to Timeline and Add to Custom Scene send the selection to those editors. A preview alone does not add an entry. Effects appear five units above the ground for inspection; check their final placement after adding them. Vehicle folders are separate from ped folders."
    ],
    "sceneReplacements": [
      "Replace and align scene elements",
      "Open a scene's cast and replacements, or edit its Timeline clip. Expand Scene Vehicles or Scene Objects to select an element and replace it; saved vehicles include their customization. Scrub to the moment of interaction, pause, then use Adjust entire scene to align the elements. Confirm the replacement and test the complete motion. Different vehicle dimensions can require alignment with the actors. Save the parent scene or project afterward."
    ],
    "timelineMarkers": [
      "Mark the current playhead position",
      "Place the cyan playhead at the exact time you want to remember. Click Marker or press M outside a text field to leave a project marker there. Drag the marker to move it; right-click removes it. Markers are timing references, not camera or text keyframes. Save the Timeline project to keep them with the edit."
    ],
    "textKeyframes": [
      "Shape a text entrance with keyframes",
      "Save the text to Timeline, select its clip and open the text keyframes. At the playhead, add points for opacity, movement, scale or blur. For a fade, start at opacity 0% and reach 100% later; alternate 0% and 100% for flicker, then keep the final point visible. Choose interpolation and preview between points. When attaching text, select the body or vehicle part and refine its offset with the gizmo."
    ],
    "saveTroubleshooting": [
      "Confirm that the project was saved",
      "Finishing a placement or preview does not save the parent composition. Return to the scene or Timeline and use Save, then wait for confirmation. Check TEST before the final recording. If saving fails, keep the editor and draft open so you can retry. A Database save failed message needs the corresponding server console error; the notification alone does not identify the cause."
    ]
  },
  "es": {
    "pedClothes": [
      "Elige prendas y texturas",
      "Al terminar el tutorial, abre My Peds y edita una apariencia. En Ropa, Variación (Drawable) elige la pieza y Textura su variante. El número tras / indica el índice máximo válido para ese personaje. Las flechas recorren el rango y vuelven al otro extremo; los accesorios incluyen -1 para quitarlos. Cambiar de prenda reinicia su textura. Revisa brazos, camiseta interior y chaqueta juntos para evitar huecos."
    ],
    "pedRandomize": [
      "Aleatoriza solo tu selección",
      "En Ped Studio, abre Aleatorizar, marca las partes que quieras y pulsa Aleatorizar selección. En el modelo masculino puedes elegir cabello, cejas, barba, chaquetas, zapatos y pantalones; al aleatorizar ropa masculina, la camiseta interior queda en 15. En el femenino puedes elegir cabello, camiseta interior, zapatos y chaquetas. Revisa el resultado antes de guardar. Las partes sin marcar se conservan, salvo la regla de la camiseta masculina."
    ],
    "pedSave": [
      "Revisa y guarda la apariencia",
      "Arrastra en la vista previa para girar al personaje y usa la rueda para mover la cámara. Las herramientas laterales enfocan rostro o cuerpo y ocultan ropa temporalmente para revisar. Esa ocultación no se guarda. Pulsa Guardar personaje y confirma para conservar la apariencia; Cancelar y Descartar cambios restauran la apariencia anterior al editor. La herencia y el modelado facial requieren un modelo freemode."
    ],
    "previewFolders": [
      "Previsualiza antes de añadir u organizar",
      "Abre la previsualización de una escena, animación o efecto y recorre su lista sin salir. Guardar en carpeta permite elegir o crear una carpeta; Añadir al Timeline y Añadir a Custom Scene envían la selección a sus editores. Previsualizar no añade una entrada por sí solo. Los efectos se muestran cinco unidades sobre el suelo para revisarlos; comprueba su colocación final al añadirlos. Las carpetas de vehículos son independientes de las de personajes."
    ],
    "sceneReplacements": [
      "Reemplaza y alinea los elementos",
      "Abre el reparto y reemplazos de una escena, o edita su clip en Timeline. Despliega Vehículos u Objetos de la escena para elegir un elemento y reemplazarlo; los vehículos guardados incluyen su personalización. Sitúate en el momento de interacción, pausa y usa Ajustar escena completa para alinear los elementos. Confirma el reemplazo y prueba el movimiento completo. Un vehículo de otras dimensiones puede necesitar ajustes con los actores. Después guarda la escena o proyecto."
    ],
    "timelineMarkers": [
      "Marca la posición de la barra celeste",
      "Coloca la barra celeste en el instante que quieras recordar. Pulsa Marcador o la tecla M fuera de un campo de texto para dejar una marca del proyecto allí. Arrastra la marca para moverla; el clic derecho la elimina. Estas marcas sirven como referencias de tiempo, no como puntos clave de cámara o texto. Guarda el proyecto Timeline para conservarlas con la edición."
    ],
    "textKeyframes": [
      "Crea la entrada del texto con puntos clave",
      "Guarda el texto en Timeline, selecciona su clip y abre los puntos clave de texto. En la posición de la barra añade puntos de opacidad, movimiento, escala o desenfoque. Para un fundido, empieza en opacidad 0% y llega a 100% después; alterna 0% y 100% para parpadear y deja visible el punto final. Elige la interpolación y revisa el recorrido. Al vincular el texto, elige la parte del cuerpo o vehículo y afina su posición con el gizmo."
    ],
    "saveTroubleshooting": [
      "Confirma que el proyecto se guardó",
      "Terminar una colocación o previsualización no guarda la composición principal. Vuelve a la escena o Timeline, pulsa Guardar y espera la confirmación. Revisa TEST antes de la toma final. Si falla el guardado, conserva el editor y el borrador abiertos para reintentar. El aviso Database save failed necesita el error correspondiente de la consola del servidor: la notificación sola no identifica la causa."
    ]
  },
  "de": {
    "pedClothes": [
      "Kleidung und Texturen wählen",
      "Öffne nach der Tour My Peds und bearbeite ein Aussehen. Unter Kleidung wählt Drawable das Kleidungsstück und Textur dessen Variante. Die Zahl nach / ist der höchste gültige Index des Modells. Die Pfeile springen an den Bereichsgrenzen zum anderen Ende; Accessoires lassen sich mit -1 entfernen. Ein Kleidungswechsel setzt die Textur zurück. Prüfe Arme, Unterhemd und Jacke zusammen auf Lücken."
    ],
    "pedRandomize": [
      "Nur die Auswahl zufällig ändern",
      "Öffne Zufallsauswahl in Ped Studio, markiere die gewünschten Teile und wende sie an. Beim männlichen Freemode-Modell sind Haare, Augenbrauen, Bart, Jacken, Schuhe und Hosen verfügbar; Kleidung setzt auch das Unterhemd auf 15. Beim weiblichen Modell sind es Haare, Unterhemd, Schuhe und Jacken. Prüfe das Ergebnis vor dem Speichern. Nicht markierte Teile bleiben bis auf die Unterhemd-Regel unverändert."
    ],
    "pedSave": [
      "Aussehen prüfen und speichern",
      "Ziehe in der Vorschau, um die Figur zu drehen; das Mausrad bewegt die Kamera. Seitliche Werkzeuge fokussieren Gesicht oder Körper und blenden Kleidung vorübergehend aus. Diese Ausblendung wird nicht gespeichert. Speichern und bestätigen übernimmt das Aussehen; Abbrechen und Verwerfen stellt den Zustand vor dem Editor wieder her. Gesicht und Herkunft benötigen ein Freemode-Modell."
    ],
    "previewFolders": [
      "Vor dem Einfügen ansehen und ablegen",
      "Öffne eine Szenen-, Animations- oder Effektvorschau und durchsuche ihre Liste. Im Ordner speichern wählt oder erstellt einen Ordner; die Hinzufügen-Schaltflächen senden die Auswahl an Timeline oder Custom Scene. Die Vorschau allein fügt keinen Eintrag hinzu. Effekte erscheinen zur Prüfung fünf Einheiten über dem Boden; kontrolliere die endgültige Position. Fahrzeugordner sind von Figurenordnern getrennt."
    ],
    "sceneReplacements": [
      "Szenenelemente ersetzen und ausrichten",
      "Öffne Besetzung und Ersatzobjekte einer Szene oder bearbeite den Timeline-Clip. Klappe Szenenfahrzeuge oder Szenenobjekte auf und ersetze das gewählte Element; gespeicherte Fahrzeuge übernehmen ihr Tuning. Pausiere am Interaktionszeitpunkt und richte die Elemente über Gesamte Szene anpassen aus. Bestätige den Ersatz und teste den gesamten Ablauf. Andere Fahrzeugmaße erfordern eventuell eine Anpassung an die Darsteller. Speichere danach Szene oder Projekt."
    ],
    "timelineMarkers": [
      "Die aktuelle Abspielposition markieren",
      "Setze den hellblauen Abspielkopf auf den gewünschten Zeitpunkt. Klicke auf Marker oder drücke M außerhalb eines Textfelds. Ziehen verschiebt die Markierung; Rechtsklick entfernt sie. Marker sind Zeitreferenzen, keine Kamera- oder Text-Keyframes. Speichere das Timeline-Projekt, um sie mit dem Schnitt zu behalten."
    ],
    "textKeyframes": [
      "Texteinblendung mit Keyframes gestalten",
      "Speichere Text in der Timeline, wähle den Clip und öffne seine Keyframes. Ergänze am Abspielkopf Punkte für Deckkraft, Bewegung, Größe oder Unschärfe. Für eine Einblendung beginne mit Deckkraft 0% und erreiche später 100%; wechselnde Werte erzeugen Flackern, der letzte bleibt sichtbar. Wähle die Interpolation und prüfe den Verlauf. Wähle beim Anheften das Körper- oder Fahrzeugteil und justiere den Versatz mit dem Gizmo."
    ],
    "saveTroubleshooting": [
      "Prüfen, ob das Projekt gespeichert wurde",
      "Platzierung oder Vorschau speichert die übergeordnete Komposition nicht. Kehre zur Szene oder Timeline zurück, speichere und warte auf die Bestätigung. Prüfe TEST vor der finalen Aufnahme. Bei einem Fehler lass Editor und Entwurf geöffnet, um erneut zu speichern. Database save failed erfordert die zugehörige Meldung der Serverkonsole; die Benachrichtigung allein erklärt die Ursache nicht."
    ]
  },
  "tr": {
    "pedClothes": [
      "Kıyafet ve doku seç",
      "Turdan sonra My Peds bölümünde bir görünümü düzenle. Kıyafetlerde Drawable parçayı, Doku ise varyantını seçer. / işaretinden sonraki sayı model için geçerli en yüksek indekstir. Oklar sınıra ulaşınca diğer uca geçer; aksesuarları kaldırmak için -1 kullanılır. Parçayı değiştirmek dokuyu sıfırlar. Boşlukları önlemek için kolları, iç gömleği ve ceketi birlikte kontrol et."
    ],
    "pedRandomize": [
      "Yalnızca seçimi rastgele değiştir",
      "Ped Studio içinde Rastgele bölümünü aç, istediğin parçaları işaretle ve seçimi uygula. Erkek freemode için saç, kaş, sakal, ceket, ayakkabı ve pantolon seçilebilir; kıyafet değişimi iç gömleği de 15 yapar. Kadın freemode için saç, iç gömlek, ayakkabı ve ceket seçilebilir. Kaydetmeden önce sonucu incele. Erkek iç gömlek kuralı dışında seçilmeyen parçalar korunur."
    ],
    "pedSave": [
      "Görünümü incele ve kaydet",
      "Önizlemede sürükleyerek karakteri döndür, tekerlekle kamerayı hareket ettir. Yan araçlar yüze veya gövdeye odaklanır ve inceleme için kıyafetleri geçici gizler. Bu gizleme kaydedilmez. Karakteri kaydet ve onayla; İptal ve Değişiklikleri at, editörden önceki görünümü geri getirir. Yüz biçimlendirme ve kalıtım için freemode modeli gerekir."
    ],
    "previewFolders": [
      "Eklemeden önce önizle ve düzenle",
      "Sahne, animasyon veya efekt önizlemesini açıp listede gezin. Klasöre kaydet ile klasör seç veya oluştur; ekleme düğmeleri seçimi Timeline ya da Custom Scene editörüne gönderir. Önizleme tek başına giriş eklemez. Efektler inceleme için yerden beş birim yukarıda gösterilir; ekledikten sonra son konumlarını kontrol et. Araç klasörleri karakter klasörlerinden ayrıdır."
    ],
    "sceneReplacements": [
      "Sahne öğelerini değiştir ve hizala",
      "Sahnenin oyuncu ve değiştirme ayarlarını ya da Timeline klibini aç. Sahne araçları veya nesnelerini genişletip bir öğeyi değiştir; kayıtlı araçlar özelleştirmelerini taşır. Etkileşim anına ilerle, duraklat ve Tüm sahneyi ayarla ile hizala. Değişimi onaylayıp hareketin tamamını test et. Farklı araç boyutları oyuncularla hizalama gerektirebilir. Ardından sahneyi veya projeyi kaydet."
    ],
    "timelineMarkers": [
      "Oynatma konumunu işaretle",
      "Açık mavi oynatma çizgisini hatırlamak istediğin zamana getir. İşaretçi düğmesine bas veya metin alanı dışında M tuşunu kullan. İşaretçiyi sürükleyerek taşı; sağ tıkla kaldır. Bunlar zaman referansıdır, kamera ya da metin anahtar karesi değildir. Düzenlemeyle birlikte saklamak için Timeline projesini kaydet."
    ],
    "textKeyframes": [
      "Metin girişini anahtar karelerle oluştur",
      "Metni Timeline'a kaydet, klibini seç ve metin anahtar karelerini aç. Oynatma çizgisinde opaklık, hareket, ölçek veya bulanıklık noktaları ekle. Solma için 0% opaklıkla başlayıp sonra 100%'e ulaş; titreme için 0% ve 100%'i değiştir ve son noktayı görünür bırak. Geçişi seçip önizle. Metni bağlarken gövde ya da araç parçasını seç ve gizmo ile ofseti düzelt."
    ],
    "saveTroubleshooting": [
      "Projenin kaydedildiğini doğrula",
      "Yerleştirmeyi veya önizlemeyi bitirmek ana kompozisyonu kaydetmez. Sahneye ya da Timeline'a dön, Kaydet'e bas ve onayı bekle. Son kayıttan önce TEST ile kontrol et. Hata olursa yeniden denemek için editörü ve taslağı açık tut. Database save failed için sunucu konsolundaki ilgili hata gerekir; bildirim tek başına nedeni açıklamaz."
    ]
  },
  "fr": {
    "pedClothes": [
      "Choisir vêtements et textures",
      "Après la visite, ouvrez My Peds et modifiez une apparence. Dans Vêtements, Drawable choisit la pièce et Texture sa variante. Le nombre après / est l’indice maximal du modèle. Les flèches reviennent à l’autre extrémité de la plage ; -1 retire un accessoire. Changer de pièce réinitialise sa texture. Vérifiez ensemble les bras, le sous-vêtement et la veste pour éviter les trous."
    ],
    "pedRandomize": [
      "Randomiser uniquement la sélection",
      "Dans Ped Studio, ouvrez la sélection aléatoire, cochez les parties puis appliquez. Le modèle masculin accepte cheveux, sourcils, barbe, vestes, chaussures et pantalons ; randomiser les vêtements règle aussi le sous-vêtement sur 15. Le modèle féminin accepte cheveux, sous-vêtement, chaussures et vestes. Vérifiez avant d’enregistrer. Les parties non cochées restent inchangées, sauf cette règle masculine."
    ],
    "pedSave": [
      "Vérifier et enregistrer l’apparence",
      "Faites glisser l’aperçu pour tourner le personnage et utilisez la molette pour déplacer la caméra. Les outils latéraux cadrent visage ou corps et masquent temporairement les vêtements. Ce masquage n’est pas enregistré. Enregistrez et confirmez pour conserver l’apparence ; annuler puis abandonner rétablit l’apparence précédente. La morphologie faciale et l’hérédité exigent un modèle freemode."
    ],
    "previewFolders": [
      "Prévisualiser avant d’ajouter ou classer",
      "Ouvrez l’aperçu d’une scène, animation ou d’un effet et parcourez la liste. Enregistrer dans un dossier permet d’en choisir ou d’en créer un ; les boutons d’ajout envoient la sélection au Timeline ou à Custom Scene. L’aperçu seul n’ajoute rien. Les effets sont montrés cinq unités au-dessus du sol ; vérifiez leur position finale. Les dossiers de véhicules sont indépendants de ceux des personnages."
    ],
    "sceneReplacements": [
      "Remplacer et aligner les éléments",
      "Ouvrez la distribution et les remplacements d’une scène ou éditez son clip Timeline. Dépliez les véhicules ou objets, puis remplacez l’élément choisi ; les véhicules enregistrés conservent leur personnalisation. Mettez en pause au moment de l’interaction et ajustez la scène entière. Confirmez puis testez tout le mouvement. Des dimensions différentes peuvent exiger un alignement avec les acteurs. Enregistrez ensuite la scène ou le projet."
    ],
    "timelineMarkers": [
      "Marquer la position de lecture",
      "Placez la tête de lecture cyan au moment voulu. Cliquez sur Marqueur ou appuyez sur M hors d’un champ de texte. Faites glisser la marque pour la déplacer ; un clic droit la supprime. Ce sont des repères temporels, pas des images clés de caméra ou de texte. Enregistrez le projet Timeline pour les conserver."
    ],
    "textKeyframes": [
      "Créer une entrée de texte par images clés",
      "Enregistrez le texte dans Timeline, sélectionnez son clip et ouvrez ses images clés. Ajoutez au curseur des points d’opacité, mouvement, échelle ou flou. Pour un fondu, passez de 0% à 100% ; alternez pour clignoter puis gardez le dernier point visible. Choisissez l’interpolation et vérifiez le résultat. Pour attacher le texte, choisissez la partie du corps ou du véhicule et ajustez le décalage avec le gizmo."
    ],
    "saveTroubleshooting": [
      "Confirmer l’enregistrement du projet",
      "Terminer un placement ou un aperçu n’enregistre pas la composition principale. Revenez à la scène ou au Timeline, enregistrez et attendez la confirmation. Vérifiez TEST avant la prise finale. En cas d’échec, gardez l’éditeur et le brouillon ouverts pour réessayer. Database save failed nécessite l’erreur correspondante dans la console serveur ; la notification seule n’en donne pas la cause."
    ]
  },
  "ar": {
    "pedClothes": [
      "اختيار الملابس والخامات",
      "بعد الجولة، افتح My Peds وعدّل المظهر. في الملابس، يختار Drawable القطعة وتختار الخامة نسختها. الرقم بعد / هو أعلى فهرس صالح للنموذج. تنتقل الأسهم إلى الطرف الآخر عند تجاوز الحد؛ وتزيل القيمة -1 الإكسسوار. تغيير القطعة يعيد ضبط خامتها. افحص الذراعين والقميص الداخلي والسترة معًا لتجنب الفراغات."
    ],
    "pedRandomize": [
      "تغيير الأجزاء المحددة عشوائيًا",
      "في Ped Studio افتح التغيير العشوائي وحدد الأجزاء ثم طبّق الاختيار. يدعم نموذج freemode الذكر الشعر والحاجبين واللحية والسترات والأحذية والسراويل؛ وتغيير الملابس يضبط القميص الداخلي على 15. تدعم الأنثى الشعر والقميص الداخلي والأحذية والسترات. راجع النتيجة قبل الحفظ. تبقى الأجزاء غير المحددة كما هي باستثناء قاعدة القميص للذكر."
    ],
    "pedSave": [
      "مراجعة المظهر وحفظه",
      "اسحب داخل المعاينة لتدوير الشخصية واستخدم العجلة لتحريك الكاميرا. تركّز الأدوات الجانبية على الوجه أو الجسم وتخفي الملابس مؤقتًا للفحص. لا يُحفظ إخفاء المعاينة. اختر حفظ الشخصية وأكّد للاحتفاظ بالمظهر؛ الإلغاء وتجاهل التغييرات يعيدان المظهر السابق للمحرر. يتطلب نحت الوجه والوراثة نموذج freemode."
    ],
    "previewFolders": [
      "المعاينة قبل الإضافة أو التنظيم",
      "افتح معاينة مشهد أو حركة أو تأثير وتصفح القائمة. يتيح الحفظ في مجلد اختياره أو إنشاءه؛ وترسل أزرار الإضافة العنصر إلى Timeline أو Custom Scene. المعاينة وحدها لا تضيف عنصرًا. تظهر التأثيرات على ارتفاع خمس وحدات عن الأرض للفحص؛ راجع موضعها النهائي بعد الإضافة. مجلدات المركبات مستقلة عن مجلدات الشخصيات."
    ],
    "sceneReplacements": [
      "استبدال عناصر المشهد ومحاذاتها",
      "افتح إعدادات طاقم المشهد والاستبدال أو عدّل مقطع Timeline. وسّع مركبات المشهد أو عناصره واختر العنصر البديل؛ تتضمن المركبات المحفوظة تخصيصاتها. توقف عند لحظة التفاعل واستخدم ضبط المشهد كاملًا للمحاذاة. أكّد الاستبدال واختبر الحركة كاملة. قد تتطلب أبعاد المركبة المختلفة ضبطها مع الممثلين. احفظ المشهد أو المشروع بعدها."
    ],
    "timelineMarkers": [
      "تحديد موضع مؤشر التشغيل",
      "ضع المؤشر السماوي عند الوقت المطلوب. اضغط علامة أو المفتاح M خارج حقل نص لإضافة علامة للمشروع. اسحبها لنقلها وانقر بزر الفأرة الأيمن لحذفها. هذه مراجع زمنية وليست إطارات مفتاحية للكاميرا أو النص. احفظ مشروع Timeline للاحتفاظ بها مع التعديل."
    ],
    "textKeyframes": [
      "إنشاء ظهور النص بإطارات مفتاحية",
      "احفظ النص في Timeline وحدد مقطعه وافتح إطاراته المفتاحية. أضف عند المؤشر نقاطًا للعتامة والحركة والحجم والضبابية. للتلاشي ابدأ بعتامة 0% ثم ارفعها إلى 100%؛ بدّل القيم للوميض واترك النقطة الأخيرة ظاهرة. اختر الاستيفاء وراجع المعاينة. عند ربط النص اختر جزء الجسم أو المركبة واضبط الإزاحة بالأداة."
    ],
    "saveTroubleshooting": [
      "تأكيد حفظ المشروع",
      "إنهاء الموضع أو المعاينة لا يحفظ التركيب الرئيسي. عد إلى المشهد أو Timeline واضغط حفظ وانتظر التأكيد. راجع TEST قبل التسجيل النهائي. إذا فشل الحفظ أبقِ المحرر والمسودة مفتوحين لإعادة المحاولة. تحتاج رسالة Database save failed إلى الخطأ المقابل في وحدة تحكم الخادم؛ فالإشعار وحده لا يحدد السبب."
    ]
  },
  "vi": {
    "pedClothes": [
      "Chọn quần áo và chất liệu",
      "Sau hướng dẫn, mở My Peds và sửa diện mạo. Trong Quần áo, Drawable chọn trang phục còn Texture chọn biến thể. Số sau / là chỉ số tối đa hợp lệ của mẫu. Các mũi tên quay vòng khi tới giới hạn; -1 tháo phụ kiện. Đổi trang phục sẽ đặt lại chất liệu. Kiểm tra cánh tay, áo trong và áo khoác cùng nhau để tránh khoảng hở."
    ],
    "pedRandomize": [
      "Chỉ ngẫu nhiên hóa phần đã chọn",
      "Trong Ped Studio, mở Ngẫu nhiên, đánh dấu các phần rồi áp dụng. Mẫu freemode nam hỗ trợ tóc, lông mày, râu, áo khoác, giày và quần; thay quần áo ngẫu nhiên cũng đặt áo trong thành 15. Mẫu nữ hỗ trợ tóc, áo trong, giày và áo khoác. Xem lại trước khi lưu. Phần không chọn được giữ nguyên, trừ quy tắc áo trong nam."
    ],
    "pedSave": [
      "Kiểm tra và lưu diện mạo",
      "Kéo trong xem trước để xoay nhân vật, dùng bánh xe để di chuyển camera. Công cụ bên cạnh lấy nét mặt hoặc thân và tạm ẩn quần áo để kiểm tra. Trạng thái ẩn này không được lưu. Chọn lưu nhân vật và xác nhận để giữ diện mạo; hủy rồi bỏ thay đổi sẽ khôi phục diện mạo trước khi mở trình sửa. Khuôn mặt và di truyền cần mẫu freemode."
    ],
    "previewFolders": [
      "Xem trước rồi thêm hoặc xếp thư mục",
      "Mở xem trước cảnh, hoạt ảnh hoặc hiệu ứng và duyệt danh sách. Lưu vào thư mục cho phép chọn hoặc tạo thư mục; các nút thêm gửi lựa chọn vào Timeline hoặc Custom Scene. Chỉ xem trước không thêm mục. Hiệu ứng hiện cách mặt đất năm đơn vị để kiểm tra; hãy kiểm tra vị trí cuối sau khi thêm. Thư mục xe độc lập với thư mục nhân vật."
    ],
    "sceneReplacements": [
      "Thay và căn chỉnh các phần tử",
      "Mở diễn viên và thay thế của cảnh hoặc sửa clip Timeline. Mở rộng xe hay vật thể của cảnh rồi thay phần tử; xe đã lưu giữ cả tùy chỉnh. Tua tới lúc tương tác, tạm dừng rồi dùng điều chỉnh toàn cảnh để căn chỉnh. Xác nhận thay thế và thử toàn bộ chuyển động. Kích thước xe khác có thể cần căn lại với diễn viên. Sau đó lưu cảnh hoặc dự án."
    ],
    "timelineMarkers": [
      "Đánh dấu vị trí phát hiện tại",
      "Đặt vạch phát màu xanh lơ ở thời điểm cần nhớ. Nhấn Dấu mốc hoặc phím M ngoài ô nhập chữ. Kéo để di chuyển dấu; nhấp phải để xóa. Đây là mốc thời gian, không phải keyframe camera hay văn bản. Lưu dự án Timeline để giữ chúng cùng bản dựng."
    ],
    "textKeyframes": [
      "Tạo hiệu ứng xuất hiện bằng keyframe",
      "Lưu văn bản vào Timeline, chọn clip và mở keyframe văn bản. Thêm điểm tại vạch phát cho độ đục, chuyển động, tỷ lệ hoặc độ mờ. Để hiện dần, đi từ độ đục 0% tới 100%; luân phiên hai giá trị để nhấp nháy rồi giữ điểm cuối hiện rõ. Chọn nội suy và xem trước. Khi gắn chữ, chọn bộ phận người hoặc xe rồi chỉnh độ lệch bằng gizmo."
    ],
    "saveTroubleshooting": [
      "Xác nhận dự án đã lưu",
      "Hoàn tất đặt vị trí hoặc xem trước không lưu bản dựng chính. Quay lại cảnh hoặc Timeline, nhấn Lưu và chờ xác nhận. Kiểm tra TEST trước lần quay cuối. Nếu lưu lỗi, giữ trình sửa và bản nháp mở để thử lại. Thông báo Database save failed cần lỗi tương ứng trong console máy chủ; riêng thông báo không cho biết nguyên nhân."
    ]
  },
  "pl": {
    "pedClothes": [
      "Wybierz ubrania i tekstury",
      "Po samouczku otwórz My Peds i edytuj wygląd. W ubraniach Drawable wybiera element, a Tekstura jego wariant. Liczba po / to najwyższy poprawny indeks modelu. Strzałki po przekroczeniu granicy wracają na drugi koniec; -1 usuwa akcesorium. Zmiana ubrania zeruje teksturę. Sprawdź razem ramiona, podkoszulek i kurtkę, aby uniknąć luk."
    ],
    "pedRandomize": [
      "Losuj tylko zaznaczone części",
      "W Ped Studio otwórz losowanie, zaznacz części i zastosuj wybór. Męski freemode obsługuje włosy, brwi, brodę, kurtki, buty i spodnie; losowanie ubrań ustawia też podkoszulek na 15. Żeński obsługuje włosy, podkoszulek, buty i kurtki. Sprawdź wynik przed zapisem. Niezaznaczone części pozostają bez zmian poza regułą męskiego podkoszulka."
    ],
    "pedSave": [
      "Sprawdź i zapisz wygląd",
      "Przeciągnij podgląd, by obrócić postać; kółko przesuwa kamerę. Narzędzia boczne kadrują twarz lub ciało i tymczasowo ukrywają ubrania. To ukrycie nie jest zapisywane. Zapisz postać i potwierdź, by zachować wygląd; anulowanie i odrzucenie przywraca wygląd sprzed otwarcia edytora. Rzeźbienie twarzy i dziedziczenie wymagają modelu freemode."
    ],
    "previewFolders": [
      "Podgląd przed dodaniem i porządkowaniem",
      "Otwórz podgląd sceny, animacji lub efektu i przeglądaj listę. Zapis do folderu pozwala wybrać lub utworzyć folder; przyciski dodawania wysyłają wybór do Timeline albo Custom Scene. Sam podgląd nie dodaje wpisu. Efekty są pokazywane pięć jednostek nad ziemią; sprawdź końcowe położenie. Foldery pojazdów są niezależne od folderów postaci."
    ],
    "sceneReplacements": [
      "Zastąp i wyrównaj elementy sceny",
      "Otwórz obsadę i zamienniki sceny albo edytuj klip Timeline. Rozwiń pojazdy lub obiekty sceny i zastąp wybrany element; zapisane pojazdy zachowują tuning. Zatrzymaj się w chwili interakcji i dopasuj elementy przez regulację całej sceny. Potwierdź i sprawdź pełny ruch. Inne wymiary auta mogą wymagać dopasowania do aktorów. Następnie zapisz scenę lub projekt."
    ],
    "timelineMarkers": [
      "Zaznacz pozycję głowicy",
      "Ustaw błękitną głowicę w wybranym momencie. Kliknij znacznik lub naciśnij M poza polem tekstowym. Przeciągnij znacznik, aby go przesunąć; prawy przycisk usuwa go. To odniesienia czasowe, nie klatki kluczowe kamery ani tekstu. Zapisz projekt Timeline, aby je zachować."
    ],
    "textKeyframes": [
      "Zbuduj wejście tekstu klatkami kluczowymi",
      "Zapisz tekst do Timeline, wybierz klip i otwórz jego klatki kluczowe. Dodaj przy głowicy punkty krycia, ruchu, skali lub rozmycia. Dla zanikania przejdź od krycia 0% do 100%; zmieniaj te wartości dla migotania i pozostaw ostatni punkt widoczny. Wybierz interpolację i sprawdź efekt. Przy przypinaniu wybierz część ciała lub pojazdu i dopracuj przesunięcie gizmem."
    ],
    "saveTroubleshooting": [
      "Potwierdź zapis projektu",
      "Zakończenie ustawiania lub podglądu nie zapisuje głównej kompozycji. Wróć do sceny albo Timeline, zapisz i poczekaj na potwierdzenie. Sprawdź TEST przed końcowym nagraniem. Przy błędzie zostaw edytor i szkic otwarte, by ponowić zapis. Database save failed wymaga odpowiedniego błędu z konsoli serwera; sam komunikat nie wskazuje przyczyny."
    ]
  },
  "pt-br": {
    "pedClothes": [
      "Escolha roupas e texturas",
      "Após o tutorial, abra My Peds e edite uma aparência. Em Roupas, Drawable escolhe a peça e Textura sua variante. O número após / é o índice máximo válido do modelo. As setas voltam à outra ponta ao passar do limite; -1 remove acessórios. Trocar a peça reinicia a textura. Confira braços, camiseta interna e jaqueta juntos para evitar falhas."
    ],
    "pedRandomize": [
      "Aleatorize apenas a seleção",
      "No Ped Studio, abra Aleatorizar, marque as partes e aplique a seleção. O freemode masculino permite cabelo, sobrancelhas, barba, jaquetas, sapatos e calças; aleatorizar roupas também define a camiseta interna como 15. O feminino permite cabelo, camiseta interna, sapatos e jaquetas. Revise antes de salvar. As partes desmarcadas são mantidas, exceto pela regra da camiseta masculina."
    ],
    "pedSave": [
      "Revise e salve a aparência",
      "Arraste na prévia para girar o personagem e use a roda para mover a câmera. As ferramentas laterais focam rosto ou corpo e ocultam roupas temporariamente. Essa ocultação não é salva. Salve o personagem e confirme para manter a aparência; cancelar e descartar restaura a aparência anterior ao editor. Herança e ajustes faciais exigem um modelo freemode."
    ],
    "previewFolders": [
      "Visualize antes de adicionar ou organizar",
      "Abra a prévia de cena, animação ou efeito e percorra a lista. Salvar na pasta permite escolher ou criar uma pasta; os botões de adicionar enviam a seleção ao Timeline ou Custom Scene. Só visualizar não adiciona uma entrada. Efeitos aparecem cinco unidades acima do chão para inspeção; confira a posição final. Pastas de veículos são independentes das de personagens."
    ],
    "sceneReplacements": [
      "Substitua e alinhe os elementos",
      "Abra elenco e substituições da cena ou edite seu clipe no Timeline. Expanda veículos ou objetos da cena e substitua o elemento; veículos salvos incluem a personalização. Pause no momento da interação e ajuste a cena inteira para alinhar. Confirme e teste todo o movimento. Dimensões diferentes podem exigir alinhamento com os atores. Depois salve a cena ou projeto."
    ],
    "timelineMarkers": [
      "Marque a posição de reprodução",
      "Coloque a barra azul-clara no instante desejado. Clique em Marcador ou pressione M fora de um campo de texto. Arraste a marca para movê-la; clique direito remove. São referências de tempo, não quadros-chave de câmera ou texto. Salve o projeto Timeline para mantê-las na edição."
    ],
    "textKeyframes": [
      "Crie a entrada do texto com quadros-chave",
      "Salve o texto no Timeline, selecione o clipe e abra seus quadros-chave. Adicione pontos de opacidade, movimento, escala ou desfoque na barra. Para aparecer gradualmente, comece em 0% e chegue a 100%; alterne para piscar e deixe o ponto final visível. Escolha a interpolação e revise. Ao vincular texto, escolha a parte do corpo ou veículo e ajuste o deslocamento com o gizmo."
    ],
    "saveTroubleshooting": [
      "Confirme que o projeto foi salvo",
      "Concluir posicionamento ou prévia não salva a composição principal. Volte à cena ou ao Timeline, salve e aguarde a confirmação. Confira TEST antes da gravação final. Se falhar, mantenha editor e rascunho abertos para tentar novamente. Database save failed precisa do erro correspondente no console do servidor; a notificação sozinha não explica a causa."
    ]
  }
};
  Object.entries(editingTutorial).forEach(([locale, steps]) => {
    Object.entries(steps).forEach(([id, [title, body]]) => {
      catalogs[locale][`tutorial.step.${id}.title`] = title;
      catalogs[locale][`tutorial.step.${id}.body`] = body;
    });
  });

  // Keep the authored tables visible to the build-time audit so dynamically
  // addressed step keys cannot silently fall back to English.
  window.SD_TUTORIAL_CATALOGS = catalogs;

  Object.entries(catalogs).forEach(([locale, strings]) => {
    if (packs[locale]) Object.assign(packs[locale], strings);
    else localeOverrides[locale] = Object.assign(localeOverrides[locale] || {}, strings);
  });
})();
