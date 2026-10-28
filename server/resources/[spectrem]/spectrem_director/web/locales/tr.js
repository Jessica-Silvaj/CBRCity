(function () {
  "use strict";

  const packs = window.SD_LANG_PACKS || {};
  const english = packs.en || {};
  const spanish = packs.es || {};

  // Long phrases are handled before individual words so the generated catalog
  // remains natural while still covering legacy exact-text entries added later.
  const phrases = {
    "Custom Scene": "Özel Sahne",
    "Custom Scenes": "Özel Sahneler",
    "Actor Sequencer": "Oyuncu Sıralayıcı",
    "Actor Sequence": "Oyuncu Sekansı",
    "Door Director": "Kapı Yönetmeni",
    "Stage Lighting": "Sahne Aydınlatması",
    "Rockstar Editor": "Rockstar Editor",
    "Object Spooner": "Nesne Yerleştirici",
    "Ped Replay": "Ped Tekrarı",
    "Vehicle Replay": "Araç Tekrarı",
    "Camera Sequence": "Kamera Sekansı",
    "World position": "Dünya konumu",
    "Current player": "Geçerli oyuncu",
    "Saved ped": "Kayıtlı ped",
    "Saved vehicle": "Kayıtlı araç",
    "Free camera": "Serbest kamera",
    "Freecam": "Serbest kamera",
    "keyframe": "anahtar kare",
    "keyframes": "anahtar kareler",
    "line of sight": "görüş hattı",
    "depth of field": "alan derinliği",
    "field of view": "görüş alanı",
    "not available": "kullanılamıyor",
    "could not be": "yapılamadı",
    "could not": "yapılamadı",
    "no longer exists": "artık mevcut değil",
    "no longer available": "artık kullanılamıyor",
    "before saving": "kaydetmeden önce",
    "while the editor was opening": "düzenleyici açılırken",
    "Try again": "Tekrar deneyin",
    "Choose a": "Bir tane seçin:",
    "Select a": "Bir tane seçin:",
    "Click to": "Şunun için tıklayın:",
    "Press ESC": "ESC tuşuna basın",
    "Back to": "Şuraya dön:",
    "Add to Timeline": "Zaman Çizelgesine Ekle",
    "Add to scene": "Sahneye ekle",
    "Add to Scene": "Sahneye Ekle",
    "Save changes": "Değişiklikleri kaydet",
    "Save Changes": "Değişiklikleri Kaydet",
    "Start preview": "Önizlemeyi başlat",
    "Stop preview": "Önizlemeyi durdur",
    "Preview paused": "Önizleme duraklatıldı",
    "PREVIEW PAUSED": "ÖNİZLEME DURAKLATILDI",
    "NEEDS ATTENTION": "İLGİ GEREKİYOR",
    "No options available.": "Kullanılabilir seçenek yok.",
    "No results": "Sonuç yok",
    "Search scenes": "Sahneleri ara",
    "Search animations": "Animasyonları ara",
    "Search saved": "Kayıtlıları ara",
    "Open & close": "Aç ve kapat",
    "Unlock & open": "Kilidi aç ve aç",
    "Close & lock": "Kapat ve kilitle",
    "Fixed world position": "Sabit dünya konumu",
    "Current Scene": "Geçerli Sahne",
    "Timeline playback": "Zaman çizelgesi oynatımı",
    "input focus": "giriş odağı",
    "recording candidate": "kayıt adayı",
    "embedded-light fixture": "gömülü ışık armatürü",
    "directional Spot lights": "yönlü Spot ışıkları",
    "directional spotlight": "yönlü spot ışığı",
    "point light": "noktasal ışık",
    "route points": "rota noktaları",
    "walkable surface": "yürünebilir yüzey",
    "scene actor": "sahne oyuncusu",
    "spawned NPC": "oluşturulan NPC",
    "Facial expression": "Yüz ifadesi",
    "Follow route": "Rotayı takip et",
    "Follow actor": "Oyuncuyu takip et",
    "Walk to point": "Noktaya yürü",
    "Drive to point": "Noktaya sür",
    "Look at point": "Noktaya bak",
    "Aim at point": "Noktaya nişan al",
    "Shoot at point": "Noktaya ateş et",
    "Play animation": "Animasyonu oynat",
    "Play scenario": "Senaryoyu oynat",
    "Equip weapon": "Silah kuşan",
    "Enter vehicle": "Araca bin",
    "Leave vehicle": "Araçtan in",
    "Camera Controls": "Kamera Kontrolleri", "Camera controls": "Kamera kontrolleri",
    "Timeline Controls": "Zaman Çizelgesi Kontrolleri", "Timeline controls": "Zaman çizelgesi kontrolleri",
    "Vehicle Controls": "Araç Kontrolleri", "Scene Controls": "Sahne Kontrolleri",
    "Clear all": "Tümünü temizle", "Clear search": "Aramayı temizle",
    "Discard changes": "Değişiklikleri at", "Discard Changes": "Değişiklikleri At",
    "Enable all": "Tümünü etkinleştir", "Disable all": "Tümünü devre dışı bırak",
    "Refresh list": "Listeyi yenile", "Replace selected": "Seçileni değiştir",
    "Try Again": "Tekrar Dene", "Starting…": "Başlatılıyor…",
    "Undo last action": "Son eylemi geri al", "Redo last action": "Son eylemi yinele",
    "Target entity": "Hedef varlık", "Target actor": "Hedef oyuncu", "Target vehicle": "Hedef araç",
    "Playback controls": "Oynatma kontrolleri", "Timeline position": "Zaman çizelgesi konumu",
    "Vehicle customization": "Araç özelleştirme", "Scene objects": "Sahne nesneleri"
  };

  const words = {
    language: "dil", scale: "ölçek", favorite: "favori", favorites: "favoriler",
    scene: "sahne", scenes: "sahneler", animation: "animasyon", animations: "animasyonlar",
    actor: "oyuncu", actors: "oyuncular", player: "oyuncu", players: "oyuncular",
    ped: "ped", peds: "pedler", npc: "NPC", vehicle: "araç", vehicles: "araçlar",
    object: "nesne", objects: "nesneler", prop: "nesne", props: "nesneler",
    camera: "kamera", cameras: "kameralar", light: "ışık", lights: "ışıklar",
    lighting: "aydınlatma", fixture: "armatür", fixtures: "armatürler",
    timeline: "zaman çizelgesi", track: "iz", tracks: "izler", clip: "klip", clips: "klipler",
    replay: "tekrar", replays: "tekrarlar", route: "rota", routes: "rotalar",
    point: "nokta", points: "noktalar", waypoint: "rota noktası", waypoints: "rota noktaları",
    door: "kapı", doors: "kapılar", environment: "ortam", environments: "ortamlar",
    effect: "efekt", effects: "efektler", weather: "hava", time: "zaman",
    density: "yoğunluk", crowd: "kalabalık", chase: "takip", club: "kulüp",
    search: "ara", filter: "filtrele", select: "seç", choose: "seç", selected: "seçili",
    add: "ekle", remove: "kaldır", delete: "sil", duplicate: "çoğalt", copy: "kopyala",
    paste: "yapıştır", rename: "yeniden adlandır", edit: "düzenle", update: "güncelle",
    save: "kaydet", saved: "kaydedildi", saving: "kaydediliyor", load: "yükle", loaded: "yüklendi",
    loading: "yükleniyor", create: "oluştur", created: "oluşturuldu", open: "aç", close: "kapat",
    closed: "kapalı", cancel: "iptal", confirm: "onayla", apply: "uygula", reset: "sıfırla",
    start: "başlat", stop: "durdur", pause: "duraklat", resume: "sürdür", play: "oynat",
    preview: "önizleme", record: "kaydet", recording: "kayıt", capture: "yakala",
    place: "yerleştir", placement: "yerleştirme", position: "konum", rotation: "döndürme",
    direction: "yön", movement: "hareket", motion: "hareket", speed: "hız", duration: "süre",
    distance: "mesafe", height: "yükseklik", width: "genişlik", angle: "açı", radius: "yarıçap",
    intensity: "yoğunluk", brightness: "parlaklık", color: "renk", colours: "renkler",
    red: "kırmızı", green: "yeşil", blue: "mavi", white: "beyaz", black: "siyah",
    left: "sol", right: "sağ", front: "ön", back: "geri", forward: "ileri",
    up: "yukarı", down: "aşağı", side: "taraf", world: "dünya", local: "yerel",
    current: "geçerli", custom: "özel", default: "varsayılan", advanced: "gelişmiş",
    basic: "temel", exact: "kesin", optional: "isteğe bağlı", required: "gerekli",
    enabled: "etkin", disabled: "devre dışı", available: "kullanılabilir", unavailable: "kullanılamıyor",
    active: "etkin", inactive: "etkin değil", visible: "görünür", hidden: "gizli",
    show: "göster", hide: "gizle", lock: "kilitle", locked: "kilitli", unlock: "kilidi aç",
    unlocked: "kilitsiz", attach: "bağla", attached: "bağlı", detach: "ayır",
    follow: "takip et", aim: "nişan al", shoot: "ateş et", walk: "yürü", run: "koş",
    wait: "bekle", enter: "gir", leave: "çık", drive: "sür", fight: "dövüş",
    weapon: "silah", weapons: "silahlar", unarmed: "silahsız", ammo: "cephane",
    action: "eylem", actions: "eylemler", event: "olay", events: "olaylar",
    mode: "mod", type: "tür", name: "ad", model: "model", category: "kategori",
    folder: "klasör", folders: "klasörler", preset: "ön ayar", presets: "ön ayarlar",
    option: "seçenek", options: "seçenekler", setting: "ayar", settings: "ayarlar",
    status: "durum", state: "durum", value: "değer", amount: "miktar",
    smooth: "yumuşak", linear: "doğrusal", natural: "doğal", fast: "hızlı", slow: "yavaş",
    normal: "normal", soft: "yumuşak", manual: "manuel", automatic: "otomatik",
    loop: "döngü", once: "bir kez", repeat: "tekrarla", continuous: "sürekli",
    working: "işleniyor", checking: "kontrol ediliyor", preparing: "hazırlanıyor",
    ready: "hazır", complete: "tamamlandı", incomplete: "eksik", error: "hata", errors: "hatalar",
    warning: "uyarı", warnings: "uyarılar", failed: "başarısız", invalid: "geçersiz",
    missing: "eksik", empty: "boş", unknown: "bilinmeyen", untitled: "başlıksız",
    before: "önce", after: "sonra", during: "sırasında", while: "iken", first: "ilk",
    next: "sonraki", previous: "önceki", finish: "bitir", continue: "devam et",
    help: "yardım", information: "bilgi", description: "açıklama", summary: "özet",
    click: "tıklayın", press: "basın", hold: "basılı tutun", drag: "sürükleyin",
    move: "taşı", rotate: "döndür", adjust: "ayarla", change: "değiştir",
    use: "kullan", uses: "kullanır", increase: "artır", decrease: "azalt",
    yes: "evet", no: "hayır", none: "yok", all: "tümü", only: "yalnızca",
    and: "ve", or: "veya", with: "ile", without: "olmadan", from: "şuradan",
    to: "şuraya", at: "konumunda", in: "içinde", on: "üzerinde", for: "için",
    is: "", are: "", was: "", were: "", the: "", a: "", an: "",
    this: "bu", that: "şu", these: "bunlar", your: "sizin", its: "onun",
    now: "şimdi", again: "tekrar", yet: "henüz", still: "hâlâ", successfully: "başarıyla",
    clear: "temizle", disable: "devre dışı bırak", discard: "at", done: "bitti", enable: "etkinleştir",
    refresh: "yenile", replace: "değiştir", retry: "yeniden dene", starting: "başlatılıyor",
    undo: "geri al", redo: "yinele", frequency: "frekans", phase: "faz", target: "hedef",
    controls: "kontroller", playback: "oynatma", frame: "kare", frames: "kareler",
    scrub: "zamanı tara", zoom: "yakınlaştırma", sensitivity: "hassasiyet", smoothing: "yumuşatma",
    lens: "lens", focus: "odak", shake: "sarsıntı", orbit: "yörünge", anchor: "sabitleme",
    driver: "sürücü", passenger: "yolcu", passengers: "yolcular", seat: "koltuk", seats: "koltuklar",
    livery: "kaplama", liveries: "kaplamalar", tuning: "modifiye", mechanic: "mekanik",
    streamed: "yayınlanan", source: "kaynak", destination: "hedef", replaceable: "değiştirilebilir"
  };

  const protectedToken = /(\{\{[^}]+\}\}|\{[^{}]+\}|%s|\b(?:ESC|ENTER|BACKSPACE|TAB|SHIFT|CTRL|ALT|RMB|LMB|WASD|F\d+|WEAPON_[A-Z0-9_]+)\b)/g;
  const escapeRegExp = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const phraseEntries = Object.entries(phrases).sort((a, b) => b[0].length - a[0].length);
  const wordPattern = new RegExp("\\b(" + Object.keys(words).sort((a, b) => b.length - a.length).map(escapeRegExp).join("|") + ")\\b", "gi");

  function translateText(source) {
    if (typeof source !== "string" || !source) return source;
    const tokens = [];
    let result = source.replace(protectedToken, (token) => `\uE000${tokens.push(token) - 1}\uE001`);
    for (const [englishPhrase, turkishPhrase] of phraseEntries) {
      result = result.replace(new RegExp(escapeRegExp(englishPhrase), "gi"), turkishPhrase);
    }
    result = result.replace(wordPattern, (word) => words[word.toLowerCase()] || word);
    result = result.replace(/\s{2,}/g, " ").replace(/\s+([,.:;!?])/g, "$1").trim();
    return result.replace(/\uE000(\d+)\uE001/g, (_match, index) => tokens[Number(index)] || "");
  }

  function translateTree(source) {
    if (Array.isArray(source)) return source.map(translateTree);
    if (!source || typeof source !== "object") return source;
    const result = {};
    for (const [key, value] of Object.entries(source)) {
      result[key] = typeof value === "string" ? translateText(value) : translateTree(value);
    }
    return result;
  }

  const optionPhrases = {
    "Ninguna": "Yok", "Pistola de combate": "Çatışma tabancası", "Pistola pesada": "Ağır tabanca",
    "Pistola ametralladora": "Makineli tabanca", "Pistola": "Tabanca", "Rifle de asalto": "Saldırı tüfeği",
    "Rifle avanzado": "Gelişmiş tüfek", "Rifle compacto": "Kompakt tüfek", "Rifle bullpup": "Bullpup tüfek",
    "Carabina especial": "Özel karabina", "Carabina": "Karabina", "Escopeta de bombeo": "Pompalı tüfek",
    "Escopeta de asalto": "Saldırı pompalısı", "Escopeta pesada": "Ağır pompalı tüfek",
    "Rifle de francotirador": "Keskin nişancı tüfeği", "Francotirador pesado": "Ağır keskin nişancı tüfeği",
    "Lanzagranadas": "Bombaatar", "Lanzacohetes": "Roketatar", "Lanzacohetes guiado": "Güdümlü roketatar",
    "Granada": "El bombası", "Granada de humo": "Sis bombası", "Gas lacrimógeno": "Göz yaşartıcı gaz",
    "Cóctel molotov": "Molotofkokteyli", "Extintor": "Yangın söndürücü", "Bidón de gasolina": "Benzin bidonu",
    "Cuchillo": "Bıçak", "Porra": "Cop", "Martillo": "Çekiç", "Bate": "Beyzbol sopası",
    "Palanca": "Levye", "Palo de golf": "Golf sopası", "Hacha": "Balta", "Puño americano": "Muşta",
    "Pistola AP": "AP tabancası", "Pistola .50": ".50 tabanca", "Pistola SNS": "SNS tabancası",
    "Revolver": "Altıpatlar", "Micro SMG": "Micro SMG", "SMG": "SMG", "SMG de asalto": "Saldırı SMG'si",
    "PDW de combate": "Çatışma PDW'si", "Mini SMG": "Mini SMG", "MG": "MG", "MG de combate": "Çatışma MG'si",
    "Recortada": "Kısa namlulu pompalı", "Rifle de tirador": "Nişancı tüfeği", "RPG": "RPG", "Minigun": "Minigun",
    "Baston": "Polis copu", "Machete": "Pala", "Navaja": "Sustalı bıçak", "Linterna": "El feneri",
    "Taser": "Şok tabancası", "Bidon de gasolina": "Benzin bidonu", "Botella": "Şişe",
    "Freemode masculino": "Erkek Freemode", "Freemode femenino": "Kadın Freemode",
    "Chico de calle": "Sokak genci", "Hipster": "Yenilikçi genç", "Hombre de negocios": "İş adamı",
    "Mujer de negocios": "İş kadını", "Mujer de playa": "Plaj kadını", "Skater": "Kaykaycı",
    "Turista": "Turist", "Policia hombre": "Erkek polis", "Policia mujer": "Kadın polis",
    "SWAT": "SWAT", "Marine": "Deniz piyadesi", "Paramedico": "Sağlık görevlisi",
    "Bombero": "İtfaiyeci", "Seguridad": "Güvenlik görevlisi", "Pastor aleman": "Alman çoban köpeği",
    "Patrulla": "Devriye aracı", "Moto policial": "Polis motosikleti", "Furgón policial": "Polis minibüsü",
    "Transporte policial": "Polis taşıma aracı", "Riot policial": "Polis çevik kuvvet aracı",
    "Patrulla 2": "Devriye aracı 2", "Patrulla 3": "Devriye aracı 3", "Buffalo policial": "Polis Buffalo",
    "Sedan FBI": "FBI Sedanı", "SUV FBI": "FBI SUV", "Patrulla sheriff": "Şerif devriye aracı",
    "SUV sheriff": "Şerif SUV", "Codigo personalizado...": "Özel kod...",
    "Extra soleado": "Çok güneşli", "Despejado": "Açık", "Nublado": "Bulutlu", "Nubes": "Bulutlar",
    "Con smog": "Dumanlı", "Niebla": "Sisli", "Cubierto": "Kapalı", "Lluvia": "Yağmurlu",
    "Tormenta": "Fırtınalı", "Despeje": "Açılıyor", "Neutral": "Nötr", "Nieve": "Karlı",
    "Ventisca": "Tipi", "Nieve ligera": "Hafif kar", "Aclarando": "Hava açılıyor",
    "Smog": "Dumanlı hava", "Navidad": "Noel"
  };

  function translateOptionTree(source) {
    if (!source || typeof source !== "object") return source;
    const result = {};
    for (const [key, value] of Object.entries(source)) {
      if (value && typeof value === "object") result[key] = translateOptionTree(value);
      else result[key] = optionPhrases[String(value)] || String(value);
    }
    return result;
  }

  const strings = {};
  for (const [key, value] of Object.entries(english)) {
    if (["shortLabel", "languageName", "direction", "staticText", "optionLabels"].includes(key)) continue;
    if (typeof value === "string") strings[key] = translateText(value);
  }

  // Natural Turkish overrides for terse controls, inspectors and catalog categories.
  Object.assign(strings, {
    railFavs: "Favoriler", railAnims: "Animasyonlar", railCustomAnims: "Animasyonlar+",
    railEnvironment: "Ortam", railClubs: "Kulüpler", railSpooner: "Nesne Yerleştirici", welcomeButton: "Teşekkürler",
    customScenesEditorEntries: "Kayıtlar", customScenesSolo: "Tek başına", customScenesDelay: "Gecikme:",
    test: "Test et", countdown: "Geri sayım:", seconds: "saniye", flags: "Bayraklar", upper: "Üst",
    activated: "Etkinleştirildi", deactivated: "Devre dışı bırakıldı", men: "erkek", generating: "Oluşturuluyor...",
    performance: "Performans", parts: "Parçalar", cosmetics: "Görünüm", wheels: "Tekerlekler",
    colors: "Renkler", body: "Gövde", interior: "İç mekân", paint: "Boya", condition: "Durum", understood: "Anlaşıldı",
    "common.fixed": "Sabit", "common.off": "Kapalı", "common.test": "Test et", "common.seconds": "saniye",
    "director.integrityMessage": "Spectrem Director kullanılırken tutarsızlıklar algılandı. Lütfen sunucuyu yeniden başlatın.",
    "director.clubs": "Kulüpler", "startup.recover": "Kurtar", "startup.entry": "kayıt", "startup.entries": "kayıt",
    "gizmo.ground": "Zemin", "gizmo.fly": "Uç", "gizmo.precision": "Hassasiyet", "gizmo.gridSnap": "Izgaraya tuttur",
    "gizmo.exitSpooner": "Nesne Yerleştiriciden çık",
    "camera.easing": "YUMUŞATMA", "camera.path": "YOL", "camera.pacing": "TEMPO", "camera.perSegment": "Her bölüm için",
    "camera.distribute": "Dağıt", "camera.freeLook": "Serbest bakış", "camera.entityRoot": "Varlık kökü",
    "camera.bodyPart": "Vücut bölümü", "camera.rigidMount": "Sabit bağlantı", "camera.image": "Görüntü",
    "camera.autofocus": "Otomatik odak", "camera.cinematicBars": "Sinematik çubuklar",
    "camera.framingGuides": "Kadraj kılavuzları", "camera.ruleOfThirds": "Üçler kuralı",
    "camera.centerCross": "Merkez artısı", "camera.safeArea": "Güvenli alan", "camera.infoOverlay": "Bilgi katmanı",
    "camera.levelHorizon": "Ufku düzle", "camera.photo": "Fotoğraf", "camera.video": "Video",
    "timeline.newProject": "Yeni proje", "timeline.inspector": "Denetleyici", "timeline.playhead": "Oynatma başlığı",
    "timeline.marker": "İşaretçi", "timeline.snap": "Tuttur", "vehicles.occupants": "Yolcular",
    "peds.spawnNpc": "NPC olarak oluştur", "mechanic.maxUpgrade": "En yüksek yükseltme", "mechanic.stock": "Fabrika ayarı",
    "mechanic.randomize": "Rastgele seç", "mechanic.repair": "Onar", "mechanic.indexed": "Dizinli",
    "mechanic.numberPlate": "Plaka", "mechanic.xenonHeadlights": "Xenon farlar", "mechanic.neonColour": "Neon rengi",
    "mechanic.health": "Sağlık", "mechanic.brokenGlass": "Kırık cam", "mechanic.tyres": "Lastikler",
    "mechanic.convertibleRoof": "Açılır tavan", "environment.formation": "Diziliş",
    "environment.quantity": "Miktar", "environment.spacing": "Aralık",
    "environment.facingDirection": "NPC bakış yönü",
    "environment.facingHelp": "0° dizilişin doğal bakış yönünü korur. Sabit NPC'ler seçilen yönü korur; dolaşan NPC'ler hareket ederken doğal olarak yönelir.",
    "sceneTools.outliner": "Sahne ağacı", "sceneTools.attachments": "Bağlantılar", "sceneTools.collections": "KOLEKSİYONLAR",
    "sceneTools.newCollectionPlaceholder": "Yeni koleksiyon…", "sceneTools.layers": "katman",
    "sceneTools.viewStates": "Görünüm durumları", "sceneTools.solo": "Tek başına", "sceneTools.selection": "SEÇİM",
    "sceneTools.stableUid": "Sabit UID", "sceneTools.attachmentRole": "Bağlantı rolü",
    "sceneTools.notAttachable": "Bağlanamaz", "sceneTools.collection": "Koleksiyon", "sceneTools.validation": "DOĞRULAMA",
    "sceneTools.new": "Yeni", "sceneTools.attachmentDefinition": "BAĞLANTI TANIMI",
    "sceneTools.childEntity": "Alt varlık", "sceneTools.parentEntity": "Üst varlık",
    "sceneTools.pitch": "Eğim", "sceneTools.roll": "Yatış", "sceneTools.yaw": "Yönelme",
    "sceneTools.collision": "Çarpışma", "sceneTools.unsavedOrganizationChanges": "KAYDEDİLMEMİŞ DÜZEN DEĞİŞİKLİKLERİ",
    "sceneTools.session": "Oturum",
    "doorDirector.look": "Bak", "doorDirector.closing": "Kapanıyor", "doorDirector.notAssigned": "Atanmadı",
    "doorDirector.guided": "REHBERLİ", "doorDirector.oppositeSwing": "Ters açılma", "doorDirector.opening": "Açılıyor",
    "doorDirector.easeOut": "Yavaş bitiş", "doorDirector.closingUpper": "KAPANIYOR",
    "actorSequencer.look": "Bak", "actorSequencer.standalone": "BAĞIMSIZ",
    "actorSequencer.guidedSetup": "REHBERLİ KURULUM", "actorSequencer.buildPerformance": "Performansı oluştur",
    "actorSequencer.review": "Gözden geçir", "actorSequencer.problems": "{count} sorun",
    "actorSequencer.castUpper": "OYUNCULAR", "actorSequencer.scenario": "Senaryo", "actorSequencer.dictionary": "Sözlük",
    "actorSequencer.reviewSequence": "Sekansı gözden geçir", "actorSequencer.step4Review": "4. ADIM · GÖZDEN GEÇİR",
    "actorSequencer.seconds": "{value} saniye", "actorSequencer.closingUpper": "KAPANIYOR",
    "actorSequencer.playingUpper": "OYNATILIYOR",
    "stageLighting.closing": "Kapanıyor", "stageLighting.guidedSetup": "REHBERLİ KURULUM",
    "stageLighting.look": "Bak", "stageLighting.keepBeamFocused": "Işık huzmesini odakta tut",
    "stageLighting.placing": "Yerleştiriliyor…", "stageLighting.recenterFaders": "Sürgüleri ortala",
    "stageLighting.pitch": "Eğim", "stageLighting.heading": "Yön", "stageLighting.photometricsUpper": "FOTOMETRİ",
    "stageLighting.editableUpper": "DÜZENLENEBİLİR", "stageLighting.motionPreset.static": "sabit",
    "stageLighting.motionPreset.float": "süzülme", "stageLighting.motionPreset.sweep": "tarama",
    "stageLighting.motionPresetDescription.float": "Hafif dikey süzülme",
    "stageLighting.motionPresetDescription.pulse": "Düzenli açılıp kapanma",
    "stageLighting.motionPresetDescription.flicker": "Düzensiz açılıp kapanma",
    "stageLighting.timing": "ZAMANLAMA", "stageLighting.proceduralLayers": "PROSEDÜREL KATMANLAR",
    "stageLighting.layersCanBeCombined": "Katmanlar birleştirilebilir", "stageLighting.amplitudeMeters": "GENLİK · METRE",
    "stageLighting.roll": "Yatış", "stageLighting.yaw": "Yönelme", "stageLighting.swayDegrees": "SALINIM · DERECE",
    "stageLighting.pattern": "Desen", "stageLighting.randomSeed": "Rastgele tohum", "stageLighting.fixed": "Sabit",
    "stageLighting.following": "Takip ediyor", "stageLighting.aiming": "Nişan alıyor",
    "stageLighting.referenced": "Referanslı", "stageLighting.viewUpper": "GÖRÜNÜM",
    "stageLighting.gizmoEditing": "Gizmo ile düzenleniyor",
    "spooner.categoryAnimals": "Hayvanlar", "spooner.categoryCiviliansFemale": "Kadın siviller",
    "spooner.categoryCiviliansMale": "Erkek siviller", "spooner.categoryGangs": "Çeteler",
    "spooner.categoryCutscene": "Ara sahne", "spooner.categoryServices": "Hizmetler", "spooner.categoryUnique": "Özel",
    "spooner.categoryFurniture": "Mobilya", "spooner.categoryDecoration": "Dekorasyon", "spooner.categoryMusic": "Müzik",
    "spooner.categoryTrash": "Çöp", "spooner.categoryFood": "Yiyecek", "spooner.categoryGames": "Oyunlar",
    "spooner.categoryCompacts": "Kompakt araçlar", "spooner.categorySedans": "Sedanlar", "spooner.categorySuvs": "SUV'lar",
    "spooner.categoryCoupes": "Kupeler", "spooner.categoryMuscle": "Kaslı araçlar",
    "spooner.categorySportsClassics": "Klasik spor araçlar", "spooner.categorySports": "Spor araçlar",
    "spooner.categorySuper": "Süper araçlar", "spooner.categoryMotorcycles": "Motosikletler",
    "spooner.categoryOffRoad": "Arazi araçları", "spooner.categoryIndustrial": "Endüstriyel",
    "spooner.categoryUtility": "Hizmet araçları", "spooner.categoryVans": "Minibüsler", "spooner.categoryCycles": "Bisikletler",
    "spooner.categoryBoats": "Tekneler", "spooner.categoryHelicopters": "Helikopterler", "spooner.categoryPlanes": "Uçaklar",
    "spooner.categoryService": "Hizmet", "spooner.categoryEmergency": "Acil durum", "spooner.categoryMilitary": "Askerî",
    "spooner.categoryCommercial": "Ticari", "spooner.categoryTrains": "Trenler", "spooner.modelsCount": "{{count}} model"
  });

  const staticText = {};
  for (const key of Object.keys(spanish.staticText || {})) staticText[key] = translateText(key);

  // Spanish exposes the complete option-key universe; keys remain stable and
  // only their visible labels are converted. This guarantees all four groups.
  const optionLabels = translateOptionTree(spanish.optionLabels || {});

  Object.assign(strings, {
    "cutscenePlayer.allBadge": "Tümü",
    "cutscenePlayer.allCutscenes": "Tüm Ara Sahneler",
    "cutscenePlayer.newBadge": "Yeni",
    "cutscenePlayer.newCutscenes": "Yeni Ara Sahneler",
    "cutscenePlayer.noNewCutscenes": "Yeni ara sahne bulunamadı"
  });

  Object.assign(strings, {
  "cameraTargeting.unavailable": "Uygun hedef yok. Listeyi yenile veya etkin bir sahne seç.",
  "cameraTargeting.scope": "Hedef önceliği",
    "cameraTargeting.sceneFirst": "Önce sahne / Timeline",
    "cameraTargeting.sceneOnly": "Yalnızca sahne / Timeline",
    "cameraTargeting.all": "Yakındaki tüm varlıklar",
    "cameraTargeting.look": "Bakış hedefi",
    "cameraTargeting.independent": "Bakış dönüşü, bağlantı konumu yönetir. Farklı hedefler kullanabilirler.",
    "cameraTargeting.rightMouse": "Sağ fare tuşu",
    "cameraTargeting.free": "Serbest — kamerayı döndür",
    "cameraTargeting.click": "Tıkla — kilitle / bırak",
    "cameraTargeting.hold": "Basılı tut — bırakana kadar izle",
    "cameraTargeting.choose": "Bakış hedefi seç…",
    "cameraTargeting.previous": "Önceki",
    "cameraTargeting.next": "Sonraki",
    "cameraTargeting.release": "Bırak",
    "cameraTargeting.none": "Bakış hedefi yok",
    "cameraTargeting.waiting": "Sahne hedefinin yeniden oluşması bekleniyor",
    "cameraTargeting.help": "H ile paneli gizle. LMB kamerayı bağlar; RMB bakış hedefini seçer. Alt + RMB elle döndürür; N serbest bakışı açar. B/V bağlantıyı değiştirmeden hedefler arasında geçer.",
    "cameraTargeting.focusMode": "Lens odağı",
    "cameraTargeting.manualFocus": "Elle mesafe",
    "cameraTargeting.centerFocus": "Otomatik odak — ekran merkezi",
    "cameraTargeting.targetFocus": "Odak takibi — bakış hedefi",
    "cameraTargeting.focusHelp": "Önce alan derinliğini aç. Odak önce bakış hedefine, sonra bağlantı veya G hedefine uyar. Kameranın yönünü değil, netliği değiştirir."
  });

  Object.assign(strings, {
    "cameraDrone.banking": "Drone yatışı",
    "cameraDrone.bankingHelp": "Dönüşte en yüksek yatış: 0° ufku düzler, 15° standarttır, 45° belirgindir. Hız ve atalet değişmez."
  });

  Object.assign(strings, {
    "cameraTargeting.lookSpeed": "Bakış hızı",
    "cameraTargeting.lookSpeedHelp": "%1–100: düşük değerler yavaş döner, yüksek değerler hızlı yönelir. Takip dahil RMB, B/V, panel hedefleri ve G için geçerlidir. Çok düşük değerler hızlı hedeflerin gerisinde kalır. Elle dönüş ve drone yatışı değişmez."
  });

  Object.assign(strings, {
    "cameraZoom.speed": "Yakınlaştırma hızı",
    "cameraZoom.help": "Paneli H ile gizle. Yakınlaştırmak için Z, uzaklaştırmak için C tuşunu basılı tut. %1–200: düşük değer yavaştır; %100 normal, %200 iki kat hızlıdır. Konumu değil FOV değerini değiştirir. Lens hazır ayarları ve kayıtlı yakınlaştırmanın oynatımı değişmez."
  });

  window.SD_I18N.registerLocale("tr", {
    shortLabel: "TR",
    languageName: "Türkçe",
    direction: "ltr",
    strings: strings,
    staticText: staticText,
    optionLabels: optionLabels
  });
})();
