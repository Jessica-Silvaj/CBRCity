/* Attachment help is static: no DOM traversal or runtime translation requests. */
(() => {
  const locales = ['en','es','de','tr','fr','ar','vi','pl','pt-br'];
  const strings = {
    title: ['Text attachment','Vincular texto','Text anheften','Metni bağla','Attacher le texte','ربط النص','Gắn văn bản','Przypinanie tekstu','Vincular texto'],
    search: ['Find an entity…','Buscar una entidad…','Entität suchen…','Varlık ara…','Rechercher une entité…','البحث عن كيان…','Tìm thực thể…','Szukaj obiektu…','Buscar entidade…'],
    choose: ['Choose a live target','Elige un objetivo visible','Aktives Ziel wählen','Etkin hedef seç','Choisir une cible active','اختر هدفًا موجودًا','Chọn mục tiêu đang có','Wybierz dostępny cel','Escolha um alvo ativo'],
    refresh: ['Refresh','Actualizar','Aktualisieren','Yenile','Actualiser','تحديث','Làm mới','Odśwież','Atualizar'],
    attach: ['Attach / apply anchor','Vincular / aplicar anclaje','Anheften / Anker anwenden','Bağla / bağlantıyı uygula','Attacher / appliquer l’ancrage','ربط / تطبيق نقطة الربط','Gắn / áp dụng điểm neo','Przypnij / zastosuj kotwicę','Vincular / aplicar ancoragem'],
    detach: ['Detach at current position','Desvincular en la posición actual','An aktueller Position lösen','Geçerli konumda ayır','Détacher à la position actuelle','فك الربط في الموضع الحالي','Tách tại vị trí hiện tại','Odepnij w bieżącej pozycji','Desvincular na posição atual'],
    bone: ['Bone / anchor (optional)','Hueso / anclaje (opcional)','Knochen / Anker (optional)','Kemik / bağlantı (isteğe bağlı)','Os / ancrage (facultatif)','عظمة / نقطة ربط (اختياري)','Xương / điểm neo (tùy chọn)','Kość / kotwica (opcjonalnie)','Osso / ancoragem (opcional)'],
    boneHelp: ['Empty = entity center; bone name or ped bone ID','Vacío = centro; nombre de hueso o ID de hueso del ped','Leer = Mitte; Knochenname oder Ped-Knochen-ID','Boş = merkez; kemik adı veya ped kemik kimliği','Vide = centre ; nom d’os ou ID d’os du ped','فارغ = المركز؛ اسم العظمة أو معرّف عظمة الشخصية','Trống = tâm; tên xương hoặc ID xương ped','Puste = środek; nazwa kości lub ID kości peda','Vazio = centro; nome do osso ou ID do osso do ped'],
    keep: ['Keep current world position','Mantener posición actual en el mundo','Aktuelle Weltposition behalten','Geçerli dünya konumunu koru','Conserver la position actuelle','الاحتفاظ بالموضع الحالي في العالم','Giữ vị trí hiện tại trong thế giới','Zachowaj bieżącą pozycję świata','Manter posição atual no mundo'],
    follow: ['In Fixed mode, inherit target rotation','En Fixed, heredar rotación del objetivo','Im Modus Fixed die Zieldrehung übernehmen','Fixed modunda hedef dönüşünü izle','En mode Fixed, suivre la rotation de la cible','في وضع Fixed، اتبع دوران الهدف','Ở chế độ Fixed, theo góc xoay mục tiêu','W trybie Fixed dziedzicz obrót celu','Em Fixed, herdar rotação do alvo'],
    help: [
      'Choose an entity, optionally a bone, then Attach. Without Keep position, the text moves just above its anchor. Use the gizmo to adjust the local offset. Face camera follows position while staying readable. Scene/Timeline targets come first; refresh after previewing or moving nearby.',
      'Elige una entidad, opcionalmente un hueso, y pulsa Vincular. Sin Mantener posición, el texto se coloca sobre el anclaje. Ajusta su desplazamiento local con el gizmo. Face camera sigue la posición y mira a cámara. Primero aparecen objetivos de escena/Timeline; actualiza tras previsualizar o acercarte.',
      'Entität und optional einen Knochen wählen, dann anheften. Ohne Position behalten erscheint der Text über dem Anker. Lokalen Versatz mit dem Gizmo einstellen. Face camera folgt der Position und bleibt zur Kamera ausgerichtet. Szene/Timeline zuerst; nach Vorschau oder Annäherung aktualisieren.',
      'Varlık ve istersen kemik seçip Bağla düğmesine bas. Konumu koru kapalıysa metin bağlantının üstüne taşınır. Yerel ofseti gizmo ile ayarla. Face camera konumu izlerken kameraya bakar. Sahne/Timeline hedefleri önce gelir; önizleme veya yaklaştıktan sonra yenile.',
      'Choisissez une entité, éventuellement un os, puis attachez. Sans Conserver la position, le texte se place au-dessus de l’ancrage. Réglez le décalage local avec le gizmo. Face camera suit la position en restant face caméra. Scène/Timeline en premier ; actualisez après aperçu ou rapprochement.',
      'اختر كيانًا وعظمة اختيارية ثم اربط النص. دون الاحتفاظ بالموضع، ينتقل النص فوق نقطة الربط. اضبط الإزاحة المحلية بالأداة. يتبع Face camera الموضع مع مواجهة الكاميرا. تظهر أهداف المشهد وTimeline أولًا؛ حدّث بعد المعاينة أو الاقتراب.',
      'Chọn thực thể, tùy chọn xương, rồi Gắn. Nếu không giữ vị trí, văn bản chuyển lên trên điểm neo. Dùng gizmo chỉnh độ lệch cục bộ. Face camera theo vị trí và luôn hướng về camera. Mục tiêu Scene/Timeline đứng trước; làm mới sau khi xem trước hoặc đến gần.',
      'Wybierz obiekt, opcjonalnie kość, i przypnij tekst. Bez zachowania pozycji tekst trafia nad kotwicę. Przesunięcie lokalne ustaw gizmem. Face camera śledzi pozycję, pozostając zwrócony do kamery. Cele sceny/Timeline są pierwsze; odśwież po podglądzie lub zbliżeniu.',
      'Escolha uma entidade e, se quiser, um osso, depois vincule. Sem Manter posição, o texto vai para cima da ancoragem. Ajuste o deslocamento local com o gizmo. Face camera segue a posição olhando para a câmera. Alvos da cena/Timeline vêm primeiro; atualize após visualizar ou se aproximar.'],
    temporary: [
      'World target: valid only while this entity exists in this resource session. It cannot reconnect after a restart. Use an authored Scene/Timeline subject for reusable playback.',
      'Objetivo del mundo: válido mientras exista en esta sesión del recurso. No se reconecta tras reiniciar. Usa un objetivo de escena/Timeline para reutilizar la repetición.',
      'Weltziel: nur gültig, solange diese Entität in dieser Ressourcensitzung existiert. Keine Wiederverbindung nach Neustart. Für wiederverwendbare Wiedergabe ein Szene-/Timeline-Ziel nutzen.',
      'Dünya hedefi yalnızca bu kaynak oturumunda var olduğu sürece geçerlidir; yeniden başlatınca bağlanmaz. Tekrar kullanılabilir oynatma için Sahne/Timeline hedefi kullan.',
      'Cible du monde : valable tant que cette entité existe dans cette session. Pas de reconnexion après redémarrage. Utilisez une cible de scène/Timeline pour une lecture réutilisable.',
      'هدف العالم صالح ما دام موجودًا في جلسة المورد الحالية فقط. لا يعاد ربطه بعد إعادة التشغيل. استخدم هدف مشهد أو Timeline لإعادة تشغيل قابلة لإعادة الاستخدام.',
      'Mục tiêu thế giới chỉ hợp lệ khi thực thể còn tồn tại trong phiên tài nguyên này. Không nối lại sau khởi động lại. Dùng mục tiêu Scene/Timeline để phát lại nhiều lần.',
      'Cel świata działa tylko, gdy istnieje w tej sesji zasobu. Po restarcie nie połączy się ponownie. Do wielokrotnego odtwarzania użyj celu sceny/Timeline.',
      'Alvo do mundo: válido enquanto existir nesta sessão do recurso. Não reconecta após reiniciar. Use um alvo da cena/Timeline para repetir a reprodução.'],
    waiting: ['Target or bone unavailable: text hidden until it returns.','Objetivo o hueso no disponible: texto oculto hasta que vuelva.','Ziel oder Knochen nicht verfügbar: Text bis zur Rückkehr ausgeblendet.','Hedef veya kemik yok: dönene kadar metin gizlenir.','Cible ou os indisponible : texte masqué jusqu’à son retour.','الهدف أو العظمة غير متاح: يُخفى النص حتى عودته.','Mục tiêu hoặc xương không có: ẩn văn bản cho đến khi trở lại.','Cel lub kość niedostępne: tekst ukryty do ich powrotu.','Alvo ou osso indisponível: texto oculto até retornar.'],
    badBone: ['This bone does not exist on the target.','Este hueso no existe en el objetivo.','Dieser Knochen existiert am Ziel nicht.','Bu kemik hedefte yok.','Cet os n’existe pas sur la cible.','هذه العظمة غير موجودة في الهدف.','Xương này không tồn tại trên mục tiêu.','Ta kość nie istnieje w celu.','Esse osso não existe no alvo.'],
    unavailable: ['Target unavailable. Refresh and try again.','Objetivo no disponible. Actualiza e inténtalo de nuevo.','Ziel nicht verfügbar. Aktualisieren und erneut versuchen.','Hedef yok. Yenileyip tekrar dene.','Cible indisponible. Actualisez et réessayez.','الهدف غير متاح. حدّث وحاول مجددًا.','Mục tiêu không có. Làm mới rồi thử lại.','Cel niedostępny. Odśwież i spróbuj ponownie.','Alvo indisponível. Atualize e tente novamente.'],
    project: ['Scene / Timeline','Escena / Timeline','Szene / Timeline','Sahne / Timeline','Scène / Timeline','المشهد / Timeline','Cảnh / Timeline','Scena / Timeline','Cena / Timeline'],
    world: ['World · temporary','Mundo · temporal','Welt · temporär','Dünya · geçici','Monde · temporaire','العالم · مؤقت','Thế giới · tạm thời','Świat · tymczasowy','Mundo · temporário'],
    player: ['Player','Jugador','Spieler','Oyuncu','Joueur','اللاعب','Người chơi','Gracz','Jogador'],
    actor: ['Ped','Ped','Ped','Ped','Ped','شخصية','Ped','Ped','Ped'],
    vehicle: ['Vehicle','Vehículo','Fahrzeug','Araç','Véhicule','مركبة','Xe','Pojazd','Veículo'],
    object: ['Object / prop','Objeto / prop','Objekt / Requisite','Nesne / eşya','Objet / accessoire','عنصر / مجسم','Vật thể / đạo cụ','Obiekt / rekwizyt','Objeto / prop'],
    local: ['Local offset','Desplazamiento local','Lokaler Versatz','Yerel ofset','Décalage local','إزاحة محلية','Độ lệch cục bộ','Przesunięcie lokalne','Deslocamento local']
  };
  for (const [key, values] of Object.entries(strings)) {
    if (values.length !== locales.length) throw new Error('Incomplete text attachment locale: '+key);
    locales.forEach((locale,index) => {
      const pack = window.SD_LANG_PACKS?.[locale];
      if (pack) pack['textAttach.'+key] = values[index];
    });
  }
  locales.forEach((locale,index) => {
    const catalog = window.SD_TUTORIAL_CATALOGS?.[locale];
    const key = 'tutorial.step.textFacing.body';
    if (catalog?.[key]) {
      catalog[key] += ' ' + strings.help[index] + ' ' + strings.temporary[index];
      if (window.SD_LANG_PACKS?.[locale]) window.SD_LANG_PACKS[locale][key] = catalog[key];
    }
  });
})();

/* Text keyframes and precise attachment controls. English fallback for other locales. */
(() => {
  const strings = {
  "basicHelp": [
    "Basic motion only. Author entrances and exits with Timeline points.",
    "Solo movimiento básico. Crea las entradas y salidas con puntos en Timeline."
  ],
  "reveal": [
    "Character reveal (seconds)",
    "Revelar caracteres (segundos)"
  ],
  "timelineHelp": [
    "Save the text, then select its Timeline clip to animate opacity, blur, scale and position with keyframes.",
    "Guarda el texto y selecciona su clip en Timeline para animar opacidad, desenfoque, escala y posición con puntos clave."
  ],
  "savedKeys": [
    "Saved Timeline points",
    "Puntos de Timeline guardados"
  ],
  "legacy": [
    "This saved text keeps its previous preset until you choose a basic animation.",
    "Este texto conserva su preset anterior hasta que elijas una animación básica."
  ],
  "part": [
    "Body / vehicle part",
    "Parte del cuerpo / vehículo"
  ],
  "markerHelp": [
    "The yellow marker and axes show the selected anchor. Apply it, then refine the offset or use the gizmo.",
    "La marca amarilla y los ejes muestran el anclaje elegido. Aplícalo y ajusta el desplazamiento o usa el gizmo."
  ],
  "customBone": [
    "Custom bone name / ped bone ID",
    "Nombre de hueso / ID de hueso del ped"
  ],
  "rotation": [
    "Rotation",
    "Rotación"
  ],
  "addPoint": [
    "Point at playhead",
    "Punto en el cursor"
  ],
  "flicker": [
    "Flicker entrance",
    "Entrada con parpadeo"
  ],
  "blurIn": [
    "Soft entrance",
    "Entrada difuminada"
  ],
  "pointHelp": [
    "Points hold their last value. Drag diamonds to retime. XYZ are offsets in the text’s local axes (metres). Interpolation applies until the next point. Entrance buttons replace points in the next second at the cursor.",
    "Los puntos mantienen su último valor. Arrastra los rombos para cambiar el tiempo. XYZ son desplazamientos en los ejes locales del texto (metros). La interpolación llega hasta el siguiente punto. Las entradas reemplazan los puntos del próximo segundo desde el cursor."
  ],
  "time": [
    "Time",
    "Tiempo"
  ],
  "opacity": [
    "Opacity",
    "Opacidad"
  ],
  "blur": [
    "Blur",
    "Desenfoque"
  ],
  "interpolation": [
    "To next point",
    "Al siguiente punto"
  ],
  "linear": [
    "Linear",
    "Lineal"
  ],
  "smooth": [
    "Smooth",
    "Suave"
  ],
  "hold": [
    "Hold / cut",
    "Mantener / corte"
  ],
  "deletePoint": [
    "Delete point",
    "Eliminar punto"
  ],
  "scale": [
    "Scale",
    "Escala"
  ],
  "marker": [
    "Mark",
    "Marca"
  ],
  "markerAtPlayhead": [
    "Mark this playhead position",
    "Marcar esta posición del cursor"
  ],
  "part.root": [
    "Entity center",
    "Centro de la entidad"
  ],
  "part.head": [
    "Head",
    "Cabeza"
  ],
  "part.neck": [
    "Neck",
    "Cuello"
  ],
  "part.chest": [
    "Chest",
    "Pecho"
  ],
  "part.waist": [
    "Waist",
    "Cintura"
  ],
  "part.pelvis": [
    "Pelvis",
    "Pelvis"
  ],
  "part.body": [
    "Body",
    "Carrocería"
  ],
  "part.chassis": [
    "Chassis",
    "Chasis"
  ],
  "part.hood": [
    "Hood",
    "Capó"
  ],
  "part.trunk": [
    "Trunk",
    "Maletero"
  ],
  "part.roof": [
    "Roof",
    "Techo"
  ],
  "part.windshield": [
    "Windshield",
    "Parabrisas"
  ],
  "part.exhaust": [
    "Exhaust",
    "Escape"
  ],
  "part.engine": [
    "Engine",
    "Motor"
  ],
  "part.mainRotor": [
    "Main rotor",
    "Rotor principal"
  ],
  "part.tailRotor": [
    "Tail rotor",
    "Rotor de cola"
  ],
  "part.turret": [
    "Turret",
    "Torreta"
  ],
  "part.frontBumper": [
    "Front bumper",
    "Parachoques delantero"
  ],
  "part.rearBumper": [
    "Rear bumper",
    "Parachoques trasero"
  ],
  "part.leftShoulder": [
    "Left shoulder",
    "Hombro izquierdo"
  ],
  "part.leftElbow": [
    "Left elbow",
    "Codo izquierdo"
  ],
  "part.leftHand": [
    "Left hand",
    "Mano izquierda"
  ],
  "part.leftThigh": [
    "Left thigh",
    "Muslo izquierdo"
  ],
  "part.leftKnee": [
    "Left knee",
    "Rodilla izquierda"
  ],
  "part.leftFoot": [
    "Left foot",
    "Pie izquierdo"
  ],
  "part.rightShoulder": [
    "Right shoulder",
    "Hombro derecho"
  ],
  "part.rightElbow": [
    "Right elbow",
    "Codo derecho"
  ],
  "part.rightHand": [
    "Right hand",
    "Mano derecha"
  ],
  "part.rightThigh": [
    "Right thigh",
    "Muslo derecho"
  ],
  "part.rightKnee": [
    "Right knee",
    "Rodilla derecha"
  ],
  "part.rightFoot": [
    "Right foot",
    "Pie derecho"
  ],
  "part.frontLeftDoor": [
    "Front left door",
    "Puerta delantera izquierda"
  ],
  "part.frontLeftWheel": [
    "Front left wheel",
    "Rueda delantera izquierda"
  ],
  "part.frontRightDoor": [
    "Front right door",
    "Puerta delantera derecha"
  ],
  "part.frontRightWheel": [
    "Front right wheel",
    "Rueda delantera derecha"
  ],
  "part.rearLeftDoor": [
    "Rear left door",
    "Puerta trasera izquierda"
  ],
  "part.rearLeftWheel": [
    "Rear left wheel",
    "Rueda trasera izquierda"
  ],
  "part.rearRightDoor": [
    "Rear right door",
    "Puerta trasera derecha"
  ],
  "part.rearRightWheel": [
    "Rear right wheel",
    "Rueda trasera derecha"
  ]
};
  for (const [locale, pack] of Object.entries(window.SD_LANG_PACKS || {})) {
    for (const [key, values] of Object.entries(strings)) pack["textMotion."+key] = values[locale === "es" ? 1 : 0];
  }
})();
