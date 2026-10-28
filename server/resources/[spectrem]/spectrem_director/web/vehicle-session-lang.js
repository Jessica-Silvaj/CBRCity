// Small static messages registered once, after all locale packs.
(function () {
  const locales = ['en', 'es', 'de', 'tr', 'fr', 'ar', 'vi', 'pl', 'pt-br'];
  const rows = [
    ['Folder refreshed. Your new take is kept; press Save again.',
      'Carpeta actualizada. Tu toma nueva se conserva; pulsa Guardar otra vez.',
      'Ordner aktualisiert. Deine neue Aufnahme bleibt erhalten; drücke erneut Speichern.',
      'Klasör yenilendi. Yeni çekimin korundu; tekrar Kaydet düğmesine bas.',
      'Dossier actualisé. Votre nouvelle prise est conservée ; appuyez à nouveau sur Enregistrer.',
      'تم تحديث المجلد. تم الاحتفاظ بلقطتك الجديدة؛ اضغط حفظ مرة أخرى.',
      'Đã làm mới thư mục. Lượt quay mới vẫn được giữ; hãy nhấn Lưu lần nữa.',
      'Folder odświeżony. Nowe ujęcie zachowano; naciśnij ponownie Zapisz.',
      'Pasta atualizada. Sua nova tomada foi mantida; pressione Salvar novamente.'],
    ['The vehicle folder changed. Your new take is kept; refresh the folder and save again.',
      'La carpeta de vehículos cambió. Tu toma nueva se conserva; actualiza la carpeta y vuelve a guardar.',
      'Der Fahrzeugordner wurde geändert. Deine neue Aufnahme bleibt erhalten; aktualisiere den Ordner und speichere erneut.',
      'Araç klasörü değişti. Yeni çekimin korundu; klasörü yenileyip tekrar kaydet.',
      'Le dossier des véhicules a changé. Votre nouvelle prise est conservée ; actualisez le dossier et enregistrez à nouveau.',
      'تغيّر مجلد المركبات. تم الاحتفاظ بلقطتك الجديدة؛ حدّث المجلد واحفظ مرة أخرى.',
      'Thư mục xe đã thay đổi. Lượt quay mới vẫn được giữ; làm mới thư mục rồi lưu lại.',
      'Folder pojazdów się zmienił. Nowe ujęcie zachowano; odśwież folder i zapisz ponownie.',
      'A pasta de veículos mudou. Sua nova tomada foi mantida; atualize a pasta e salve novamente.'],
    ['Could not verify the saved vehicle recording; try again',
      'No se pudo verificar la grabación guardada del vehículo; inténtalo otra vez',
      'Die gespeicherte Fahrzeugaufnahme konnte nicht geprüft werden; versuche es erneut',
      'Kayıtlı araç çekimi doğrulanamadı; tekrar dene',
      'Impossible de vérifier la capture du véhicule sauvegardée ; réessayez',
      'تعذر التحقق من تسجيل المركبة المحفوظ؛ حاول مرة أخرى',
      'Không thể xác minh bản ghi xe đã lưu; hãy thử lại',
      'Nie udało się sprawdzić zapisanej jazdy pojazdu; spróbuj ponownie',
      'Não foi possível verificar a gravação salva do veículo; tente novamente'],
    ['Invalid vehicle recording append',
      'La toma que se intenta añadir no es válida',
      'Die hinzuzufügende Fahrzeugaufnahme ist ungültig',
      'Eklenecek araç çekimi geçersiz',
      'La capture de véhicule à ajouter est invalide',
      'تسجيل المركبة المراد إضافته غير صالح',
      'Bản ghi xe cần thêm không hợp lệ',
      'Nieprawidłowe ujęcie pojazdu do dodania',
      'A gravação de veículo a adicionar é inválida'],
    ['Could not prepare the vehicle recording append',
      'No se pudo preparar el guardado de la nueva toma del vehículo',
      'Das Hinzufügen der Fahrzeugaufnahme konnte nicht vorbereitet werden',
      'Araç çekiminin eklenmesi hazırlanamadı',
      'Impossible de préparer l’ajout de la capture du véhicule',
      'تعذر تجهيز إضافة تسجيل المركبة',
      'Không thể chuẩn bị thêm bản ghi xe',
      'Nie udało się przygotować dodania ujęcia pojazdu',
      'Não foi possível preparar a adição da gravação do veículo'],
    ['Could not verify the vehicle recording append',
      'No se pudo verificar el guardado de la nueva toma del vehículo',
      'Das Hinzufügen der Fahrzeugaufnahme konnte nicht geprüft werden',
      'Araç çekiminin eklenmesi doğrulanamadı',
      'Impossible de vérifier l’ajout de la capture du véhicule',
      'تعذر التحقق من إضافة تسجيل المركبة',
      'Không thể xác minh việc thêm bản ghi xe',
      'Nie udało się sprawdzić dodania ujęcia pojazdu',
      'Não foi possível verificar a adição da gravação do veículo'],
  ];
  for (const values of rows) {
    if (values.length !== locales.length) throw new Error('Incomplete vehicle session translation');
    locales.forEach((locale, index) => {
      const pack = window.SD_LANG_PACKS?.[locale];
      if (pack) (pack.staticText || (pack.staticText = {}))[values[0]] = values[index];
    });
  }
})();
