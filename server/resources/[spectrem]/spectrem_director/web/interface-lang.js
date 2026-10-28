(function registerInterfaceSizeStrings() {
  const locales = ['en','es','de','tr','fr','ar','vi','pl','pt-br'];
  const rows = [
  [
    "timelineOpacity",
    "Timeline playback opacity",
    "Opacidad del Timeline al reproducir",
    "Deckkraft der Timeline-Wiedergabe",
    "Timeline oynatma opaklığı",
    "Opacité du Timeline pendant la lecture",
    "عتامة Timeline أثناء التشغيل",
    "Độ mờ Timeline khi phát",
    "Krycie Timeline podczas odtwarzania",
    "Opacidade do Timeline na reprodução"
  ],
  [
    "timelineOpacityHelp",
    "Applies to the playback panel in full and compact view. 0% hides it; 100% is fully opaque. Default: 70%.",
    "Se aplica al panel de reproducción en vista completa y compacta. 0% lo oculta; 100% es totalmente opaco. Predeterminado: 70%.",
    "Gilt für das Wiedergabefenster in voller und kompakter Ansicht. 0 % blendet es aus; 100 % ist vollständig undurchsichtig. Standard: 70 %.",
    "Tam ve kompakt görünümdeki oynatma paneline uygulanır. %0 gizler; %100 tamamen opaktır. Varsayılan: %70.",
    "S’applique au panneau de lecture en vue complète et compacte. 0 % le masque ; 100 % est entièrement opaque. Valeur par défaut : 70 %.",
    "يُطبق على لوحة التشغيل في العرض الكامل والمصغر. 0% يخفيها و100% يجعلها معتمة تماماً. الافتراضي: 70%.",
    "Áp dụng cho bảng phát ở chế độ đầy đủ và thu gọn. 0% ẩn bảng; 100% hoàn toàn không trong suốt. Mặc định: 70%.",
    "Dotyczy panelu odtwarzania w widoku pełnym i kompaktowym. 0% go ukrywa, a 100% jest całkowicie nieprzezroczyste. Domyślnie: 70%.",
    "Aplica-se ao painel de reprodução nas visualizações completa e compacta. 0% oculta; 100% é totalmente opaco. Padrão: 70%."
  ],
  [
    "restoreOpacity",
    "Restore opacity",
    "Restaurar opacidad",
    "Deckkraft zurücksetzen",
    "Opaklığı sıfırla",
    "Rétablir l’opacité",
    "استعادة العتامة",
    "Khôi phục độ mờ",
    "Przywróć krycie",
    "Restaurar opacidade"
  ],
  [
    "preview",
    "Preview",
    "Vista previa",
    "Vorschau",
    "Önizleme",
    "Aperçu",
    "معاينة",
    "Xem trước",
    "Podgląd",
    "Prévia"
  ],
  [
    "title",
    "Interface settings",
    "Ajustes de interfaz",
    "Oberflächeneinstellungen",
    "Arayüz ayarları",
    "Réglages de l’interface",
    "إعدادات الواجهة",
    "Cài đặt giao diện",
    "Ustawienia interfejsu",
    "Configurações da interface"
  ],
  [
    "help",
    "Adjust text, buttons and panels for your screen. Preview changes immediately.",
    "Ajusta textos, botones y paneles a tu pantalla. Los cambios se muestran al instante.",
    "Passe Texte, Schaltflächen und Fenster an deinen Bildschirm an. Änderungen sind sofort sichtbar.",
    "Yazı, düğme ve panelleri ekranına göre ayarla. Değişiklikler anında görünür.",
    "Adaptez textes, boutons et panneaux à votre écran. Les changements sont visibles immédiatement.",
    "اضبط النصوص والأزرار واللوحات لشاشتك. تظهر التغييرات فورًا.",
    "Điều chỉnh chữ, nút và bảng theo màn hình. Thay đổi hiển thị ngay.",
    "Dopasuj tekst, przyciski i panele do ekranu. Zmiany widać od razu.",
    "Ajuste textos, botões e painéis à sua tela. Veja as alterações na hora."
  ],
  [
    "size",
    "Size",
    "Tamaño",
    "Größe",
    "Boyut",
    "Taille",
    "الحجم",
    "Kích thước",
    "Rozmiar",
    "Tamanho"
  ],
  [
    "smaller",
    "Make smaller",
    "Reducir tamaño",
    "Verkleinern",
    "Küçült",
    "Réduire",
    "تصغير",
    "Thu nhỏ",
    "Pomniejsz",
    "Diminuir"
  ],
  [
    "larger",
    "Make larger",
    "Aumentar tamaño",
    "Vergrößern",
    "Büyüt",
    "Agrandir",
    "تكبير",
    "Phóng to",
    "Powiększ",
    "Aumentar"
  ],
  [
    "auto",
    "Restore recommended size",
    "Restaurar tamaño recomendado",
    "Empfohlene Größe wiederherstellen",
    "Önerilen boyuta dön",
    "Rétablir la taille recommandée",
    "استعادة الحجم الموصى به",
    "Khôi phục kích thước đề xuất",
    "Przywróć zalecany rozmiar",
    "Restaurar tamanho recomendado"
  ],
  [
    "saved",
    "Your preferences are saved automatically on this device.",
    "Tus preferencias se guardan automáticamente en este equipo.",
    "Deine Einstellungen werden automatisch auf diesem Gerät gespeichert.",
    "Tercihlerin bu cihazda otomatik kaydedilir.",
    "Vos préférences sont enregistrées automatiquement sur cet appareil.",
    "تُحفظ تفضيلاتك تلقائيًا على هذا الجهاز.",
    "Tùy chọn của bạn được tự động lưu trên thiết bị này.",
    "Twoje ustawienia są automatycznie zapisywane na tym urządzeniu.",
    "Suas preferências são salvas automaticamente neste dispositivo."
  ],
  [
    "sessionOnly",
    "Applied for this session. This device could not save the preference.",
    "Aplicado en esta sesión. No se pudo guardar la preferencia en este equipo.",
    "Für diese Sitzung angewendet. Die Einstellung konnte nicht gespeichert werden.",
    "Bu oturum için uygulandı. Tercih bu cihaza kaydedilemedi.",
    "Appliqué pour cette session. Impossible d’enregistrer la préférence.",
    "طُبق لهذه الجلسة. تعذر حفظ التفضيل على هذا الجهاز.",
    "Đã áp dụng cho phiên này. Không thể lưu tùy chọn trên thiết bị.",
    "Zastosowano w tej sesji. Nie udało się zapisać ustawienia.",
    "Aplicado nesta sessão. Não foi possível salvar a preferência."
  ],
  [
    "close",
    "Close settings",
    "Cerrar ajustes",
    "Einstellungen schließen",
    "Ayarları kapat",
    "Fermer les réglages",
    "إغلاق الإعدادات",
    "Đóng cài đặt",
    "Zamknij ustawienia",
    "Fechar ajustes"
  ],
  [
    "done",
    "Done",
    "Listo",
    "Fertig",
    "Tamam",
    "Terminé",
    "تم",
    "Xong",
    "Gotowe",
    "Pronto"
  ]
];
  locales.forEach((locale,index) => {
    const pack = window.SD_LANG_PACKS?.[locale];
    if (pack) for (const row of rows) pack['interfaceSize.' + row[0]] = row[index + 1];
  });
})();
