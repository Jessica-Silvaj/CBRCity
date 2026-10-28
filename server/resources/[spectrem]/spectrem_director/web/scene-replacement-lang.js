/* Loaded once with the language packs; no per-open translation pass. */
(() => {
  const locales = ['en', 'es', 'de', 'tr', 'fr', 'ar', 'vi', 'pl', 'pt-br'];
  const strings = {
    stock: ['Stock vehicle','Vehículo normal','Serienfahrzeug','Standart araç','Véhicule de série','مركبة عادية','Xe nguyên bản','Pojazd seryjny','Veículo original'],
    myVehicles: ['My Vehicles','Mis vehículos','Meine Fahrzeuge','Araçlarım','Mes véhicules','مركباتي','Xe của tôi','Moje pojazdy','Meus veículos'],
    chooseSaved: ['Select a saved vehicle','Selecciona un vehículo guardado','Gespeichertes Fahrzeug wählen','Kayıtlı araç seç','Choisir un véhicule enregistré','اختر مركبة محفوظة','Chọn xe đã lưu','Wybierz zapisany pojazd','Selecione um veículo salvo'],
    loadingVehicles: ['Loading vehicles…','Cargando vehículos…','Fahrzeuge werden geladen…','Araçlar yükleniyor…','Chargement des véhicules…','جارٍ تحميل المركبات…','Đang tải xe…','Ładowanie pojazdów…','Carregando veículos…'],
    noSavedVehicles: ['Save a vehicle in My Vehicles first.','Primero guarda un vehículo en Mis vehículos.','Speichere zuerst ein Fahrzeug unter Meine Fahrzeuge.','Önce Araçlarım bölümünde bir araç kaydet.','Enregistrez un véhicule dans Mes véhicules.','احفظ مركبة في مركباتي أولاً.','Lưu một xe trong Xe của tôi trước.','Najpierw zapisz pojazd w Moje pojazdy.','Primeiro salve um veículo em Meus veículos.'],
    savedSettings: ['Keeps its saved paint, wheels, extras and modifications. Select it, then press Replace.','Conserva pintura, ruedas, extras y modificaciones. Selecciónalo y pulsa Reemplazar.','Behält Lackierung, Räder, Extras und Umbauten. Wähle es und drücke Ersetzen.','Boya, jant, ekstra ve modifikasyonları korur. Seçip Değiştir düğmesine bas.','Conserve peinture, roues, extras et modifications. Sélectionnez-le puis cliquez sur Remplacer.','يحتفظ بالطلاء والعجلات والإضافات والتعديلات. اختره ثم اضغط استبدال.','Giữ màu sơn, bánh xe, phụ kiện và nâng cấp. Chọn rồi nhấn Thay thế.','Zachowuje lakier, koła, dodatki i modyfikacje. Wybierz i kliknij Zastąp.','Mantém pintura, rodas, extras e modificações. Selecione e pressione Substituir.'],
    alignAll: ["Adjust entire scene","Ajustar toda la escena","Ganze Szene ausrichten","Tüm sahneyi ayarla","Ajuster toute la scène","ضبط المشهد بالكامل","Căn chỉnh toàn bộ cảnh","Dopasuj całą scenę","Ajustar toda a cena"],
    alignHelp: ["Align vehicles, actors and props at a paused frame. Choose each element and move or rotate it.","Alinea vehículos, actores y props en un fotograma pausado. Selecciona cada elemento para moverlo o girarlo.","Richte Fahrzeuge, Schauspieler und Requisiten im angehaltenen Bild aus. Wähle ein Element zum Verschieben oder Drehen.","Araçları, oyuncuları ve nesneleri duraklatılmış karede hizala. Taşımak veya döndürmek için bir öğe seç.","Alignez véhicules, acteurs et objets sur une image en pause. Sélectionnez chaque élément pour le déplacer ou le tourner.","حاذِ المركبات والشخصيات والعناصر عند إطار متوقف. اختر كل عنصر لتحريكه أو تدويره.","Căn xe, diễn viên và đạo cụ tại khung hình tạm dừng. Chọn từng thành phần để di chuyển hoặc xoay.","Dopasuj pojazdy, aktorów i rekwizyty na zatrzymanej klatce. Wybierz element, aby go przesunąć lub obrócić.","Alinhe veículos, atores e props em um quadro pausado. Selecione cada elemento para mover ou girar."],
    elements: ["Scene elements","Elementos de la escena","Szenenelemente","Sahne öğeleri","Éléments de la scène","عناصر المشهد","Thành phần cảnh","Elementy sceny","Elementos da cena"],
    chooseTarget: ["Choose what to align","Elige qué ajustar","Element zum Ausrichten wählen","Ayarlanacak öğeyi seç","Choisir quoi ajuster","اختر ما تريد ضبطه","Chọn thành phần cần căn","Wybierz element do dopasowania","Escolha o que ajustar"],
    actors: ["Actors","Actores","Schauspieler","Oyuncular","Acteurs","الشخصيات","Diễn viên","Aktorzy","Atores"],
    vehiclesProps: ["Vehicles, objects & attached props","Vehículos, objetos y props adjuntos","Fahrzeuge, Objekte & befestigte Requisiten","Araçlar, nesneler ve bağlı aksesuarlar","Véhicules, objets et accessoires attachés","المركبات والعناصر والملحقات المتصلة","Xe, vật thể và đạo cụ gắn kèm","Pojazdy, obiekty i dołączone rekwizyty","Veículos, objetos e props anexados"],
    gizmo: ["Adjust with gizmo","Ajustar con gizmo","Mit Gizmo ausrichten","Gizmo ile ayarla","Ajuster avec le gizmo","ضبط باستخدام أداة التحريك","Điều chỉnh bằng gizmo","Dopasuj za pomocą gizma","Ajustar com gizmo"],
    resetTarget: ["Reset this element","Restablecer este elemento","Dieses Element zurücksetzen","Bu öğeyi sıfırla","Réinitialiser cet élément","إعادة تعيين هذا العنصر","Đặt lại thành phần này","Resetuj ten element","Redefinir este elemento"],
    precision: ["Fine adjustment","Ajuste fino","Feineinstellung","Hassas ayar","Réglage fin","ضبط دقيق","Tinh chỉnh","Dokładne dopasowanie","Ajuste fino"],
    moveStep: ["Move increment","Paso de movimiento","Bewegungsschritt","Hareket adımı","Pas de déplacement","خطوة التحريك","Bước di chuyển","Krok przesunięcia","Passo de movimento"],
    turnStep: ["Rotation increment","Paso de rotación","Drehschritt","Dönüş adımı","Pas de rotation","خطوة الدوران","Bước xoay","Krok obrotu","Passo de rotação"],
    turn: ["Rotation","Rotación","Drehung","Dönüş","Rotation","الدوران","Xoay","Obrót","Rotação"],
    axesHelp: ["Actors: scene axes. Vehicles and props: local axes. Use the gizmo for pitch and roll.","Actores: ejes de la escena. Vehículos y props: ejes locales. Usa el gizmo para inclinar.","Schauspieler: Szenenachsen. Fahrzeuge und Requisiten: lokale Achsen. Neigung mit dem Gizmo einstellen.","Oyuncular: sahne eksenleri. Araçlar ve nesneler: yerel eksenler. Eğmek için gizmo kullan.","Acteurs : axes de la scène. Véhicules et objets : axes locaux. Utilisez le gizmo pour incliner.","الشخصيات: محاور المشهد. المركبات والعناصر: محاور محلية. استخدم أداة التحريك للإمالة.","Diễn viên: trục cảnh. Xe và đạo cụ: trục cục bộ. Dùng gizmo để chỉnh độ nghiêng.","Aktorzy: osie sceny. Pojazdy i rekwizyty: osie lokalne. Pochylenie ustaw gizmem.","Atores: eixos da cena. Veículos e props: eixos locais. Use o gizmo para inclinar."],
    alignNote: ["Apply keeps these corrections for this scene selection and placement, not as global defaults. Cancel discards this editing session. Scene origin only moves the preview. Check several frames: alignment cannot change model dimensions or missing bones.","Aplicar conserva los ajustes para esta selección y su placement, sin cambiar los valores globales. Cancelar descarta esta sesión. El origen sólo mueve la vista previa. Revisa varios fotogramas: el ajuste no cambia dimensiones ni crea huesos faltantes.","Anwenden behält Korrekturen für diese Auswahl und Platzierung, nicht als globale Vorgaben. Abbrechen verwirft diese Sitzung. Der Ursprung bewegt nur die Vorschau. Prüfe mehrere Bilder: Maße und fehlende Bones ändern sich nicht.","Uygula, düzeltmeleri yalnızca bu seçim ve yerleştirme için tutar; genel varsayılanları değiştirmez. İptal bu oturumu siler. Başlangıç noktası yalnızca önizlemeyi taşır. Birkaç kareyi kontrol et: boyutlar ve eksik kemikler değişmez.","Appliquer conserve les corrections pour cette sélection et son placement, sans modifier les valeurs globales. Annuler abandonne cette session. L’origine ne déplace que l’aperçu. Vérifiez plusieurs images : les dimensions et les os manquants ne changent pas.","يحفظ التطبيق التصحيحات لهذا الاختيار وموضعه فقط، دون تغيير القيم العامة. يلغي الإلغاء تعديلات هذه الجلسة. يحرك الأصل المعاينة فقط. راجع عدة إطارات: لا يغيّر الضبط الأبعاد ولا ينشئ العظام المفقودة.","Áp dụng giữ chỉnh sửa cho lựa chọn và vị trí này, không đổi mặc định chung. Hủy bỏ thay đổi trong phiên này. Gốc chỉ di chuyển bản xem trước. Kiểm tra nhiều khung hình: căn chỉnh không đổi kích thước hoặc tạo xương thiếu.","Zastosuj zachowuje korekty dla tego wyboru i rozmieszczenia, bez zmiany ustawień globalnych. Anuluj odrzuca tę sesję. Początek przesuwa tylko podgląd. Sprawdź kilka klatek: dopasowanie nie zmienia wymiarów ani brakujących kości.","Aplicar mantém os ajustes para esta seleção e posicionamento, sem mudar os padrões globais. Cancelar descarta esta sessão. A origem só move a prévia. Confira vários quadros: o ajuste não muda dimensões nem cria ossos ausentes."],
    applyAlignment: ["Apply alignment","Aplicar ajustes","Ausrichtung anwenden","Hizalamayı uygula","Appliquer les ajustements","تطبيق الضبط","Áp dụng căn chỉnh","Zastosuj dopasowanie","Aplicar ajustes"],
    cancel: ["Cancel","Cancelar","Abbrechen","İptal","Annuler","إلغاء","Hủy","Anuluj","Cancelar"],
    cast: ['Scene cast and replacements','Actores y reemplazos de la escena','Szenenbesetzung und Ersatzmodelle','Sahne oyuncuları ve değişimler','Acteurs et remplacements de la scène','شخصيات المشهد والاستبدالات','Diễn viên và thay thế trong cảnh','Obsada i zamienniki sceny','Atores e substituições da cena'],
    objects: ['Scene Objects','Objetos de la escena','Szenenobjekte','Sahne nesneleri','Objets de la scène','عناصر المشهد','Vật thể trong cảnh','Obiekty sceny','Objetos da cena'],
    vehicles: ['Scene Vehicles','Vehículos de la escena','Szenenfahrzeuge','Sahne araçları','Véhicules de la scène','مركبات المشهد','Xe trong cảnh','Pojazdy sceny','Veículos da cena'],
    help: [
      'Choose a vehicle from the catalog or search by spawn code. Preview and adjust it before placing the scene.',
      'Elige un vehículo del catálogo o busca por código de spawn. Previsualízalo y ajústalo antes de colocar la escena.',
      'Wähle ein Fahrzeug aus dem Katalog oder suche nach dem Spawn-Code. Prüfe und justiere es vor dem Platzieren der Szene.',
      'Katalogdan araç seç veya spawn koduyla ara. Sahneyi yerleştirmeden önce önizle ve ayarla.',
      'Choisissez un véhicule du catalogue ou cherchez son code de spawn. Prévisualisez-le et ajustez-le avant de placer la scène.',
      'اختر مركبة من الكتالوج أو ابحث برمز الاستدعاء. عاينها واضبطها قبل وضع المشهد.',
      'Chọn xe từ danh mục hoặc tìm bằng mã spawn. Xem trước và điều chỉnh trước khi đặt cảnh.',
      'Wybierz pojazd z katalogu lub wyszukaj kod spawn. Obejrzyj podgląd i dopasuj pojazd przed ustawieniem sceny.',
      'Escolha um veículo do catálogo ou pesquise pelo código de spawn. Visualize e ajuste antes de posicionar a cena.'
    ],
    replace: ['Replace','Reemplazar','Ersetzen','Değiştir','Remplacer','استبدال','Thay thế','Zastąp','Substituir'],
    change: ['Change','Cambiar','Ändern','Değiştir','Changer','تغيير','Đổi','Zmień','Alterar'],
    reset: ['Reset replacement','Restablecer reemplazo','Ersatz zurücksetzen','Değişimi sıfırla','Réinitialiser le remplacement','إعادة تعيين الاستبدال','Đặt lại thay thế','Resetuj zamiennik','Redefinir substituição'],
    disable: ['Disable scene element','Desactivar elemento','Szenenelement deaktivieren','Sahne öğesini kapat','Désactiver cet élément','تعطيل عنصر المشهد','Tắt thành phần cảnh','Wyłącz element sceny','Desativar elemento'],
    enable: ['Enable scene element','Activar elemento','Szenenelement aktivieren','Sahne öğesini aç','Activer cet élément','تفعيل عنصر المشهد','Bật thành phần cảnh','Włącz element sceny','Ativar elemento'],
    editor: ['Scene Vehicle Editor','Editor de vehículos de escena','Szenenfahrzeug-Editor','Sahne aracı düzenleyicisi','Éditeur de véhicule de scène','محرر مركبة المشهد','Trình sửa xe trong cảnh','Edytor pojazdu sceny','Editor de veículos da cena'],
    pose: [
      'Pause or scrub to an exact scene pose before adjusting the replacement.',
      'Pausa o avanza hasta un instante exacto antes de ajustar el reemplazo.',
      'Pausiere oder wähle einen genauen Szenenzeitpunkt, bevor du den Ersatz justierst.',
      'Değişimi ayarlamadan önce duraklat veya tam bir sahne anına git.',
      'Mettez en pause ou choisissez un instant précis avant d’ajuster le remplacement.',
      'أوقف التشغيل مؤقتًا أو انتقل إلى لحظة محددة قبل ضبط البديل.',
      'Tạm dừng hoặc tua đến đúng thời điểm trước khi điều chỉnh vật thay thế.',
      'Wstrzymaj lub przewiń do dokładnej chwili sceny przed dopasowaniem zamiennika.',
      'Pause ou avance até um instante exato antes de ajustar a substituição.'
    ],
    adjust: ['Adjust vehicle','Ajustar vehículo','Fahrzeug justieren','Aracı ayarla','Ajuster le véhicule','ضبط المركبة','Điều chỉnh xe','Dopasuj pojazd','Ajustar veículo'],
    compatibility: [
      'The replacement follows the scene motion. Different models keep their own body and glass, with compatible doors and steering synchronized. Adjust the position to match the actors.',
      'El reemplazo sigue el movimiento de la escena. Los modelos diferentes conservan su carrocería y cristales, con puertas y dirección compatibles sincronizadas. Ajusta la posición para que coincida con los actores.',
      'Der Ersatz folgt der Szenenbewegung. Andere Modelle behalten ihre Karosserie und Scheiben; kompatible Türen und Lenkung werden synchronisiert. Passe die Position an die Schauspieler an.',
      'Yeni araç sahne hareketini takip eder. Farklı modeller kendi gövdesini ve camlarını korur; uyumlu kapılar ve direksiyon eşzamanlı çalışır. Konumu oyunculara göre ayarla.',
      'Le véhicule suit le mouvement de la scène. Les modèles différents conservent leur carrosserie et leurs vitres ; les portes et la direction compatibles sont synchronisées. Ajustez la position aux acteurs.',
      'تتبع المركبة حركة المشهد. تحتفظ النماذج المختلفة بهيكلها وزجاجها مع مزامنة الأبواب والتوجيه المتوافقين. اضبط موضعها ليتناسب مع الشخصيات.',
      'Xe thay thế đi theo chuyển động của cảnh. Mẫu xe khác giữ thân và kính riêng, đồng bộ cửa và góc lái tương thích. Điều chỉnh vị trí cho khớp với nhân vật.',
      'Zamiennik podąża za ruchem sceny. Inne modele zachowują własne nadwozie i szyby; zgodne drzwi i skręt są synchronizowane. Dopasuj pozycję do aktorów.',
      'O veículo segue o movimento da cena. Modelos diferentes mantêm a própria carroceria e os vidros, com portas e direção compatíveis sincronizadas. Ajuste a posição aos atores.'
    ],
    invalidModel: ['This model is not available. Check the spawn code and installed resources.','Este modelo no está disponible. Revisa el código de spawn y los recursos instalados.','Dieses Modell ist nicht verfügbar. Prüfe Spawn-Code und installierte Ressourcen.','Bu model yok. Spawn kodunu ve yüklü kaynakları kontrol et.','Ce modèle est indisponible. Vérifiez le code de spawn et les ressources installées.','هذا النموذج غير متاح. تحقق من رمز الاستدعاء والموارد المثبتة.','Mẫu này không khả dụng. Kiểm tra mã spawn và tài nguyên đã cài.','Ten model jest niedostępny. Sprawdź kod spawn i zainstalowane zasoby.','Este modelo não está disponível. Verifique o código de spawn e os recursos instalados.'],
    wrongType: ['Replace vehicles with vehicles and props with props.','Reemplaza vehículos por vehículos y props por props.','Ersetze Fahrzeuge durch Fahrzeuge und Requisiten durch Requisiten.','Araçları araçlarla, nesneleri nesnelerle değiştir.','Remplacez les véhicules par des véhicules et les objets par des objets.','استبدل المركبات بمركبات والعناصر بعناصر.','Thay xe bằng xe và đạo cụ bằng đạo cụ.','Zastępuj pojazdy pojazdami, a rekwizyty rekwizytami.','Substitua veículos por veículos e props por props.'],
    unavailable: ['The replacement could not be loaded. The previous selection was kept.','No se pudo cargar el reemplazo. Se conservó la selección anterior.','Der Ersatz konnte nicht geladen werden. Die bisherige Auswahl bleibt erhalten.','Değişim yüklenemedi. Önceki seçim korundu.','Le remplacement n’a pas pu être chargé. La sélection précédente est conservée.','تعذر تحميل البديل. تم الاحتفاظ بالاختيار السابق.','Không tải được mẫu thay thế. Lựa chọn trước đó được giữ nguyên.','Nie udało się wczytać zamiennika. Zachowano poprzedni wybór.','Não foi possível carregar a substituição. A seleção anterior foi mantida.']
  };
  for (const [key, values] of Object.entries(strings)) {
    if (values.length !== locales.length) throw new Error('Incomplete scene replacement locale: ' + key);
    locales.forEach((locale, index) => {
      const pack = window.SD_LANG_PACKS?.[locale];
      if (pack) pack['sceneReplace.' + key] = values[index];
    });
  }
  locales.forEach((locale, index) => {
    const catalog = window.SD_TUTORIAL_CATALOGS?.[locale];
    const key = 'tutorial.step.scenes.body';
    if (catalog?.[key]) {
      catalog[key] += ' ' + strings.vehicles[index] + ': ' + strings.help[index] + ' ' + strings.compatibility[index] + ' ' + strings.alignAll[index] + ': ' + strings.alignHelp[index] + ' ' + strings.alignNote[index];
      if (window.SD_LANG_PACKS?.[locale]) window.SD_LANG_PACKS[locale][key] = catalog[key];
    }
  });
})();
