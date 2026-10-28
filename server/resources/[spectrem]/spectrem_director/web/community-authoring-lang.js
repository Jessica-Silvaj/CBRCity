(function () {
  const locales = ['en','es','de','tr','fr','ar','vi','pl','pt-br'];
  const rows = [
    ['Random parents','Padres aleatorios','Zufällige Eltern','Rastgele ebeveynler','Parents aléatoires','والدان عشوائيان','Bố mẹ ngẫu nhiên','Losowi rodzice','Pais aleatórios'],
    ['Parent blend','Mezcla de padres','Elternmischung','Ebeveyn karışımı','Mélange des parents','مزج الوالدين','Pha trộn bố mẹ','Mieszanie rodziców','Mistura dos pais'],
    ['Facial features','Rasgos faciales','Gesichtszüge','Yüz hatları','Traits du visage','ملامح الوجه','Đặc điểm khuôn mặt','Rysy twarzy','Traços faciais'],
    ['Animation source','Origen de animaciones','Animationsquelle','Animasyon kaynağı','Source des animations','مصدر الحركات','Nguồn hoạt ảnh','Źródło animacji','Origem das animações'],
    ['All animations','Todas las animaciones','Alle Animationen','Tüm animasyonlar','Toutes les animations','كل الحركات','Tất cả hoạt ảnh','Wszystkie animacje','Todas as animações'],
    ['Cutscene animations','Animaciones de cutscenes','Zwischensequenz-Animationen','Ara sahne animasyonları','Animations des cinématiques','حركات المشاهد السينمائية','Hoạt ảnh cảnh cắt','Animacje przerywników','Animações de cutscenes'],
    ['Cutscene','Cutscene','Zwischensequenz','Ara sahne','Cinématique','مشهد سينمائي','Cảnh cắt','Przerywnik','Cutscene'],
    ['All cutscenes','Todas las cutscenes','Alle Zwischensequenzen','Tüm ara sahneler','Toutes les cinématiques','كل المشاهد السينمائية','Tất cả cảnh cắt','Wszystkie przerywniki','Todas as cutscenes'],
    ['Load more','Cargar más','Mehr laden','Daha fazla yükle','Charger plus','تحميل المزيد','Tải thêm','Wczytaj więcej','Carregar mais'],
    ['Could not load animations. Try again.','No se pudieron cargar las animaciones. Inténtalo de nuevo.','Animationen konnten nicht geladen werden. Erneut versuchen.','Animasyonlar yüklenemedi. Tekrar deneyin.','Impossible de charger les animations. Réessayez.','تعذر تحميل الحركات. حاول مجددًا.','Không thể tải hoạt ảnh. Hãy thử lại.','Nie można wczytać animacji. Spróbuj ponownie.','Não foi possível carregar as animações. Tente novamente.'],
    ['Facial emotions','Emociones faciales','Gesichtsausdrücke','Yüz ifadeleri','Émotions du visage','تعابير الوجه','Biểu cảm khuôn mặt','Emocje twarzy','Emoções faciais'],
    ['Change expression at each point','Cambiar expresión en cada punto','Ausdruck je Punkt ändern','Her noktada ifadeyi değiştir','Changer d’expression à chaque point','تغيير التعبير عند كل نقطة','Đổi biểu cảm tại mỗi điểm','Zmieniaj wyraz twarzy w każdym punkcie','Mudar expressão em cada ponto'],
    ['Emotion','Emoción','Emotion','Duygu','Émotion','التعبير','Biểu cảm','Emocja','Emoção'],
    ['Unchanged','Sin modificar','Unverändert','Değiştirme','Inchangée','دون تغيير','Không đổi','Bez zmian','Sem alteração'],
    ['Neutral','Neutral','Neutral','Nötr','Neutre','محايد','Bình thường','Neutralna','Neutra'],
    ['Talking','Hablando','Sprechend','Konuşma','Parle','يتحدث','Đang nói','Mówienie','Falando'],
    ['Happy','Feliz','Glücklich','Mutlu','Heureux','سعيد','Vui vẻ','Radosna','Feliz'],
    ['Angry','Enfadado','Wütend','Kızgın','En colère','غاضب','Tức giận','Zła','Zangada'],
    ['Sad','Triste','Traurig','Üzgün','Triste','حزين','Buồn','Smutna','Triste'],
    ['Stressed','Estresado','Gestresst','Stresli','Stressé','متوتر','Căng thẳng','Zestresowana','Estressada'],
    ['Excited','Emocionado','Aufgeregt','Heyecanlı','Enthousiaste','متحمس','Hào hứng','Podekscytowana','Animada'],
    ['Shocked','Sorprendido','Schockiert','Şaşkın','Choqué','مصدوم','Sửng sốt','Zszokowana','Chocada'],
    ['Catalogued clips only. Some require the original cutscene; use Preview before adding.',
     'Solo clips del catálogo. Algunos necesitan la cutscene original; usa Vista previa antes de añadirlos.',
     'Nur katalogisierte Clips. Einige benötigen die ursprüngliche Zwischensequenz; vor dem Hinzufügen Vorschau nutzen.',
     'Yalnızca katalogdaki klipler. Bazıları orijinal ara sahneyi gerektirir; eklemeden önce önizleyin.',
     'Clips du catalogue uniquement. Certains exigent la cinématique d’origine ; utilisez l’aperçu avant de les ajouter.',
     'مقاطع الكتالوج فقط. بعضها يحتاج المشهد الأصلي؛ استخدم المعاينة قبل الإضافة.',
     'Chỉ các clip trong danh mục. Một số cần cảnh cắt gốc; hãy xem trước khi thêm.',
     'Tylko klipy z katalogu. Niektóre wymagają oryginalnego przerywnika; użyj podglądu przed dodaniem.',
     'Somente clipes do catálogo. Alguns precisam da cutscene original; use a prévia antes de adicionar.'],
    ['An emotion holds until the next point or clip end. Set Mouth to 0 for expression only. This does not generate voice audio.',
     'La emoción se mantiene hasta el siguiente punto o el final. Pon Boca en 0 para usar solo la expresión. No genera audio de voz.',
     'Die Emotion bleibt bis zum nächsten Punkt oder Clipende. Mund auf 0 für reinen Ausdruck. Es wird keine Stimme erzeugt.',
     'Duygu sonraki noktaya veya klip sonuna kadar sürer. Yalnızca ifade için Ağız değerini 0 yapın. Ses üretmez.',
     'L’émotion reste jusqu’au prochain point ou à la fin du clip. Réglez Bouche sur 0 pour l’expression seule. Aucune voix n’est générée.',
     'يبقى التعبير حتى النقطة التالية أو نهاية المقطع. اضبط الفم على 0 للتعبير فقط. لا يتم توليد صوت.',
     'Biểu cảm giữ đến điểm kế tiếp hoặc cuối clip. Đặt Miệng bằng 0 nếu chỉ cần biểu cảm. Không tạo âm thanh giọng nói.',
     'Emocja trwa do następnego punktu lub końca klipu. Ustaw Usta na 0 dla samej mimiki. Nie tworzy dźwięku głosu.',
     'A emoção dura até o próximo ponto ou o fim do clipe. Coloque Boca em 0 para usar só a expressão. Não gera áudio de voz.'],
  ];
  for (const [i,locale] of locales.entries()) {
    const pack=window.SD_LANG_PACKS?.[locale]; if (!pack) continue;
    pack.staticText=pack.staticText||{};
    for (const row of rows) pack.staticText[row[0]]=row[i];
  }
})();
