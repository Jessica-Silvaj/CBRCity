(function () {
  "use strict";

  const packs = window.SD_LANG_PACKS || {};
  const english = packs.en || {};
  const spanish = packs.es || {};

  const phrases = {
    "Custom Scene": "Cảnh tùy chỉnh", "Custom Scenes": "Các cảnh tùy chỉnh",
    "Actor Sequencer": "Bộ tạo chuỗi diễn viên", "Actor Sequence": "Chuỗi diễn viên",
    "Door Director": "Đạo diễn cửa", "Stage Lighting": "Ánh sáng sân khấu",
    "Rockstar Editor": "Rockstar Editor", "Object Spooner": "Trình đặt vật thể",
    "Ped Replay": "Phát lại nhân vật", "Vehicle Replay": "Phát lại phương tiện",
    "Camera Sequence": "Chuỗi camera", "World position": "Vị trí thế giới",
    "Current player": "Người chơi hiện tại", "Saved ped": "Nhân vật đã lưu",
    "Saved vehicle": "Phương tiện đã lưu", "Free camera": "Camera tự do", "Freecam": "Camera tự do",
    "keyframe": "khung hình chính", "keyframes": "các khung hình chính",
    "line of sight": "đường ngắm", "depth of field": "độ sâu trường ảnh", "field of view": "trường nhìn",
    "not available": "không khả dụng", "could not be": "không thể", "could not": "không thể",
    "no longer exists": "không còn tồn tại", "no longer available": "không còn khả dụng",
    "before saving": "trước khi lưu", "while the editor was opening": "trong khi trình chỉnh sửa đang mở",
    "Try again": "Hãy thử lại", "Choose a": "Chọn một", "Select a": "Chọn một",
    "Click to": "Nhấp để", "Press ESC": "Nhấn ESC", "Back to": "Quay lại",
    "Add to Timeline": "Thêm vào dòng thời gian", "Add to scene": "Thêm vào cảnh",
    "Add to Scene": "Thêm vào cảnh", "Save changes": "Lưu thay đổi", "Save Changes": "Lưu thay đổi",
    "Start preview": "Bắt đầu xem trước", "Stop preview": "Dừng xem trước",
    "Preview paused": "Đã tạm dừng xem trước", "PREVIEW PAUSED": "ĐÃ TẠM DỪNG XEM TRƯỚC",
    "NEEDS ATTENTION": "CẦN CHÚ Ý", "No options available.": "Không có tùy chọn khả dụng.",
    "No results": "Không có kết quả", "Search scenes": "Tìm cảnh", "Search animations": "Tìm hoạt ảnh",
    "Search saved": "Tìm nội dung đã lưu", "Open & close": "Mở và đóng",
    "Unlock & open": "Mở khóa và mở", "Close & lock": "Đóng và khóa",
    "Fixed world position": "Vị trí cố định trong thế giới", "Current Scene": "Cảnh hiện tại",
    "Timeline playback": "Phát dòng thời gian", "input focus": "quyền nhập liệu",
    "recording candidate": "ứng viên ghi hình", "embedded-light fixture": "bộ đèn tích hợp",
    "directional Spot lights": "đèn Spot định hướng", "directional spotlight": "đèn rọi định hướng",
    "point light": "đèn điểm", "route points": "các điểm tuyến đường", "walkable surface": "bề mặt có thể đi",
    "scene actor": "diễn viên trong cảnh", "spawned NPC": "NPC đã tạo",
    "Facial expression": "Biểu cảm khuôn mặt", "Follow route": "Đi theo tuyến đường",
    "Follow actor": "Đi theo diễn viên", "Walk to point": "Đi bộ tới điểm",
    "Drive to point": "Lái xe tới điểm", "Look at point": "Nhìn vào điểm",
    "Aim at point": "Ngắm vào điểm", "Shoot at point": "Bắn vào điểm",
    "Play animation": "Phát hoạt ảnh", "Play scenario": "Phát kịch bản",
    "Equip weapon": "Trang bị vũ khí", "Enter vehicle": "Vào phương tiện", "Leave vehicle": "Rời phương tiện"
  };

  const words = {
    language: "ngôn ngữ", scale: "tỷ lệ", favorite: "yêu thích", favorites: "mục yêu thích",
    scene: "cảnh", scenes: "các cảnh", animation: "hoạt ảnh", animations: "các hoạt ảnh",
    actor: "diễn viên", actors: "các diễn viên", player: "người chơi", players: "người chơi",
    ped: "nhân vật", peds: "các nhân vật", npc: "NPC", vehicle: "phương tiện", vehicles: "các phương tiện",
    object: "vật thể", objects: "các vật thể", prop: "đạo cụ", props: "các đạo cụ",
    camera: "camera", cameras: "các camera", light: "đèn", lights: "các đèn", lighting: "ánh sáng",
    fixture: "bộ đèn", fixtures: "các bộ đèn", timeline: "dòng thời gian", track: "rãnh", tracks: "các rãnh",
    clip: "đoạn", clips: "các đoạn", replay: "phát lại", replays: "các bản phát lại",
    route: "tuyến đường", routes: "các tuyến đường", point: "điểm", points: "các điểm",
    waypoint: "điểm tuyến", waypoints: "các điểm tuyến", door: "cửa", doors: "các cửa",
    environment: "môi trường", environments: "các môi trường", effect: "hiệu ứng", effects: "các hiệu ứng",
    weather: "thời tiết", time: "thời gian", density: "mật độ", crowd: "đám đông", chase: "truy đuổi", club: "câu lạc bộ",
    search: "tìm kiếm", filter: "lọc", select: "chọn", choose: "chọn", selected: "đã chọn",
    add: "thêm", remove: "gỡ", delete: "xóa", duplicate: "nhân bản", copy: "sao chép", paste: "dán",
    rename: "đổi tên", edit: "chỉnh sửa", update: "cập nhật", save: "lưu", saved: "đã lưu",
    saving: "đang lưu", load: "tải", loaded: "đã tải", loading: "đang tải", create: "tạo", created: "đã tạo",
    open: "mở", close: "đóng", closed: "đã đóng", cancel: "hủy", confirm: "xác nhận", apply: "áp dụng",
    reset: "đặt lại", start: "bắt đầu", stop: "dừng", pause: "tạm dừng", resume: "tiếp tục", play: "phát",
    preview: "xem trước", record: "ghi", recording: "bản ghi", capture: "ghi lại", place: "đặt",
    placement: "đặt vị trí", position: "vị trí", rotation: "xoay", direction: "hướng", movement: "chuyển động",
    motion: "chuyển động", speed: "tốc độ", duration: "thời lượng", distance: "khoảng cách",
    height: "chiều cao", width: "chiều rộng", angle: "góc", radius: "bán kính", intensity: "cường độ",
    brightness: "độ sáng", color: "màu", colours: "các màu", red: "đỏ", green: "xanh lá",
    blue: "xanh dương", white: "trắng", black: "đen", left: "trái", right: "phải", front: "trước",
    back: "quay lại", forward: "tiến", up: "lên", down: "xuống", side: "phía", world: "thế giới", local: "cục bộ",
    current: "hiện tại", custom: "tùy chỉnh", default: "mặc định", advanced: "nâng cao", basic: "cơ bản",
    exact: "chính xác", optional: "tùy chọn", required: "bắt buộc", enabled: "đã bật", disabled: "đã tắt",
    available: "khả dụng", unavailable: "không khả dụng", active: "đang hoạt động", inactive: "không hoạt động",
    visible: "hiển thị", hidden: "ẩn", show: "hiện", hide: "ẩn", lock: "khóa", locked: "đã khóa",
    unlock: "mở khóa", unlocked: "đã mở khóa", attach: "gắn", attached: "đã gắn", detach: "tháo",
    follow: "đi theo", aim: "ngắm", shoot: "bắn", walk: "đi bộ", run: "chạy", wait: "chờ",
    enter: "vào", leave: "rời", drive: "lái", fight: "chiến đấu", weapon: "vũ khí", weapons: "các vũ khí",
    unarmed: "không vũ khí", ammo: "đạn", action: "hành động", actions: "các hành động",
    event: "sự kiện", events: "các sự kiện", mode: "chế độ", type: "loại", name: "tên", model: "mẫu",
    category: "danh mục", folder: "thư mục", folders: "các thư mục", preset: "cấu hình sẵn", presets: "các cấu hình sẵn",
    option: "tùy chọn", options: "các tùy chọn", setting: "cài đặt", settings: "các cài đặt",
    status: "trạng thái", state: "trạng thái", value: "giá trị", amount: "mức",
    smooth: "mượt", linear: "tuyến tính", natural: "tự nhiên", fast: "nhanh", slow: "chậm", normal: "bình thường",
    soft: "nhẹ", manual: "thủ công", automatic: "tự động", loop: "lặp", once: "một lần", repeat: "lặp lại",
    continuous: "liên tục", working: "đang xử lý", checking: "đang kiểm tra", preparing: "đang chuẩn bị", ready: "sẵn sàng",
    complete: "hoàn tất", incomplete: "chưa hoàn tất", error: "lỗi", errors: "các lỗi", warning: "cảnh báo",
    warnings: "các cảnh báo", failed: "thất bại", invalid: "không hợp lệ", missing: "thiếu", empty: "trống",
    unknown: "không rõ", untitled: "chưa đặt tên", before: "trước", after: "sau", during: "trong khi",
    while: "trong khi", first: "đầu tiên", next: "tiếp theo", previous: "trước đó", finish: "hoàn tất", continue: "tiếp tục",
    help: "trợ giúp", information: "thông tin", description: "mô tả", summary: "tóm tắt", click: "nhấp",
    press: "nhấn", hold: "giữ", drag: "kéo", move: "di chuyển", rotate: "xoay", adjust: "điều chỉnh",
    change: "thay đổi", use: "dùng", uses: "dùng", increase: "tăng", decrease: "giảm",
    yes: "có", no: "không", none: "không có", all: "tất cả", only: "chỉ", and: "và", or: "hoặc",
    with: "với", without: "không có", from: "từ", to: "đến", at: "tại", in: "trong", on: "trên", for: "cho",
    is: "", are: "", was: "", were: "", the: "", a: "", an: "", this: "này", that: "đó",
    these: "những", your: "của bạn", its: "của nó", now: "bây giờ", again: "lại", yet: "chưa",
    still: "vẫn", successfully: "thành công"
  };

  const optionPhrases = {
    "Pistola AP": "Súng lục AP", "Pistola .50": "Súng lục .50", "Pistola SNS": "Súng lục SNS",
    "Revolver": "Súng lục ổ xoay", "Micro SMG": "Micro SMG", "SMG": "SMG",
    "SMG de asalto": "SMG tấn công", "PDW de combate": "PDW chiến đấu", "Mini SMG": "Mini SMG",
    "MG": "MG", "MG de combate": "MG chiến đấu", "Recortada": "Shotgun nòng ngắn",
    "Rifle de tirador": "Súng trường thiện xạ", "RPG": "RPG", "Minigun": "Minigun",
    "Baston": "Dùi cui", "Machete": "Dao rựa", "Navaja": "Dao gấp", "Linterna": "Đèn pin",
    "Taser": "Súng điện", "Bidon de gasolina": "Can xăng", "Botella": "Chai",
    "Ninguna": "Không có", "Pistola de combate": "Súng lục chiến đấu", "Pistola pesada": "Súng lục hạng nặng",
    "Pistola ametralladora": "Súng lục liên thanh", "Pistola": "Súng lục", "Rifle de asalto": "Súng trường tấn công",
    "Rifle avanzado": "Súng trường nâng cao", "Rifle compacto": "Súng trường nhỏ gọn", "Rifle bullpup": "Súng trường bullpup",
    "Carabina especial": "Carbine đặc biệt", "Carabina": "Carbine", "Escopeta de bombeo": "Súng shotgun bơm",
    "Escopeta de asalto": "Shotgun tấn công", "Escopeta pesada": "Shotgun hạng nặng",
    "Rifle de francotirador": "Súng bắn tỉa", "Francotirador pesado": "Súng bắn tỉa hạng nặng",
    "Lanzagranadas": "Súng phóng lựu", "Lanzacohetes": "Súng phóng tên lửa", "Lanzacohetes guiado": "Súng phóng tên lửa dẫn đường",
    "Granada": "Lựu đạn", "Granada de humo": "Lựu đạn khói", "Gas lacrimógeno": "Hơi cay",
    "Cóctel molotov": "Bom xăng", "Extintor": "Bình chữa cháy", "Bidón de gasolina": "Can xăng",
    "Cuchillo": "Dao", "Porra": "Dùi cui", "Martillo": "Búa", "Bate": "Gậy bóng chày",
    "Palanca": "Xà beng", "Palo de golf": "Gậy golf", "Hacha": "Rìu", "Puño americano": "Tay đấm sắt",
    "Freemode masculino": "Freemode nam", "Freemode femenino": "Freemode nữ",
    "Chico de calle": "Thanh niên đường phố", "Hipster": "Hipster", "Hombre de negocios": "Nam doanh nhân",
    "Mujer de negocios": "Nữ doanh nhân", "Mujer de playa": "Phụ nữ bãi biển", "Skater": "Người trượt ván",
    "Turista": "Khách du lịch", "Policia hombre": "Nam cảnh sát", "Policia mujer": "Nữ cảnh sát",
    "SWAT": "SWAT", "Marine": "Lính thủy đánh bộ", "Paramedico": "Nhân viên y tế",
    "Bombero": "Lính cứu hỏa", "Seguridad": "Bảo vệ", "Ballas": "Ballas", "Vagos": "Vagos",
    "Lost MC": "Lost MC", "Rottweiler": "Rottweiler", "Husky": "Husky", "Pastor aleman": "Chó chăn cừu Đức",
    "Patrulla": "Xe tuần tra", "Moto policial": "Mô tô cảnh sát", "Furgón policial": "Xe tải cảnh sát",
    "Transporte policial": "Xe chở cảnh sát", "Riot policial": "Xe chống bạo động",
    "Patrulla 2": "Xe tuần tra 2", "Patrulla 3": "Xe tuần tra 3", "Buffalo policial": "Buffalo cảnh sát",
    "Sedan FBI": "Sedan FBI", "SUV FBI": "SUV FBI", "Patrulla sheriff": "Xe tuần tra cảnh sát trưởng",
    "SUV sheriff": "SUV cảnh sát trưởng", "Codigo personalizado...": "Mã tùy chỉnh...",
    "Extra soleado": "Rất nắng", "Despejado": "Trời quang", "Nublado": "Nhiều mây", "Nubes": "Mây",
    "Con smog": "Khói mù", "Niebla": "Sương mù", "Cubierto": "U ám", "Lluvia": "Mưa",
    "Tormenta": "Bão", "Despeje": "Đang quang", "Neutral": "Trung tính", "Nieve": "Tuyết",
    "Ventisca": "Bão tuyết", "Nieve ligera": "Tuyết nhẹ", "Aclarando": "Đang quang dần",
    "Smog": "Khói mù", "Navidad": "Giáng sinh"
  };

  const protectedToken = /(\{\{[^}]+\}\}|\{[^{}]+\}|%s|\b(?:ESC|ENTER|BACKSPACE|TAB|SHIFT|CTRL|ALT|RMB|LMB|WASD|F\d+|WEAPON_[A-Z0-9_]+)\b)/g;
  const escapeRegExp = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const phraseEntries = Object.entries(phrases).sort((a, b) => b[0].length - a[0].length);
  const wordPattern = new RegExp("\\b(" + Object.keys(words).sort((a, b) => b.length - a.length).map(escapeRegExp).join("|") + ")\\b", "gi");

  function translateText(source) {
    if (typeof source !== "string" || !source) return source;
    const tokens = [];
    let result = source.replace(protectedToken, (token) => `\uE000${tokens.push(token) - 1}\uE001`);
    for (const [englishPhrase, vietnamesePhrase] of phraseEntries) {
      result = result.replace(new RegExp(escapeRegExp(englishPhrase), "gi"), vietnamesePhrase);
    }
    result = result.replace(wordPattern, (word) => words[word.toLowerCase()] || word);
    result = result.replace(/\s{2,}/g, " ").replace(/\s+([,.:;!?])/g, "$1").trim();
    return result.replace(/\uE000(\d+)\uE001/g, (_match, index) => tokens[Number(index)] || "");
  }

  function translateOptionTree(source) {
    if (!source || typeof source !== "object") return source;
    const result = {};
    for (const [key, value] of Object.entries(source)) {
      result[key] = value && typeof value === "object"
        ? translateOptionTree(value)
        : (optionPhrases[String(value)] || String(value));
    }
    return result;
  }

  const strings = {};
  for (const [key, value] of Object.entries(english)) {
    if (["shortLabel", "languageName", "direction", "staticText", "optionLabels"].includes(key)) continue;
    if (typeof value === "string") strings[key] = translateText(value);
  }

  // Natural Vietnamese overrides for compact controls, inspectors and catalog labels.
  // Keys are used instead of matching source text so technical values and model names stay untouched.
  Object.assign(strings, {
    railFavs: "Yêu thích", railAnims: "Hoạt ảnh", railCustomAnims: "Hoạt ảnh+",
    railEnvironment: "Môi trường", railClubs: "Câu lạc bộ", railSpooner: "Đặt vật thể",
    welcomeButton: "Cảm ơn", customScenesEditorEntries: "Mục", customScenesSolo: "Chỉ hiện",
    customScenesDelay: "Độ trễ:", playback: "Phát lại", test: "Kiểm tra", countdown: "Đếm ngược:",
    seconds: "giây", flags: "Cờ", upper: "Trên", activated: "Đã kích hoạt", deactivated: "Đã tắt",
    men: "nam", generating: "Đang tạo...", performance: "Hiệu năng", parts: "Bộ phận",
    cosmetics: "Ngoại hình", wheels: "Bánh xe", colors: "Màu sắc", body: "Thân xe",
    interior: "Nội thất", paint: "Sơn", livery: "Tem xe", condition: "Tình trạng", understood: "Đã hiểu",
    "common.clear": "Xóa", "common.disable": "Tắt", "common.discard": "Hủy bỏ",
    "common.done": "Xong", "common.enable": "Bật", "common.fixed": "Cố định", "common.off": "Tắt",
    "common.refresh": "Làm mới", "common.replace": "Thay thế", "common.retry": "Thử lại",
    "common.starting": "Đang bắt đầu", "common.test": "Kiểm tra", "common.undo": "Hoàn tác",
    "common.redo": "Làm lại", "common.frequency": "Tần số", "common.phase": "Pha",
    "common.target": "Mục tiêu", "common.seconds": "giây",
    "director.integrityMessage": "Phát hiện dữ liệu không nhất quán khi dùng Spectrem Director. Vui lòng khởi động lại máy chủ.",
    "director.clubs": "Câu lạc bộ", "startup.recover": "Khôi phục", "startup.entry": "mục", "startup.entries": "mục",
    "gizmo.ground": "Mặt đất", "gizmo.fly": "Bay", "gizmo.focusTarget": "Tập trung mục tiêu",
    "gizmo.precision": "Độ chính xác", "gizmo.gridSnap": "Bám lưới", "gizmo.exitSpooner": "Thoát trình đặt vật thể",
    "camera.replaceRecording": "GHI: Thay thế", "camera.easing": "CHUYỂN ĐỘNG", "camera.path": "QUỸ ĐẠO",
    "camera.pacing": "NHỊP ĐỘ", "camera.perSegment": "Theo từng đoạn", "camera.distribute": "Phân bố",
    "camera.freeLook": "Nhìn tự do", "camera.entityRoot": "Gốc thực thể", "camera.bodyPart": "Bộ phận cơ thể",
    "camera.targetPointer": "Con trỏ mục tiêu", "camera.rigidMount": "Gắn cố định", "camera.autoOrbit": "Quay tự động",
    "camera.sensitivity": "Độ nhạy", "camera.zoomResponse": "Độ nhạy thu phóng",
    "camera.mouseSmoothing": "Làm mượt chuột", "camera.lens": "Ống kính", "camera.image": "Hình ảnh",
    "camera.autofocus": "Tự động lấy nét", "camera.shakeStrength": "Độ rung", "camera.cinematicBars": "Viền điện ảnh",
    "camera.framingGuides": "Đường căn khung", "camera.ruleOfThirds": "Quy tắc một phần ba",
    "camera.centerCross": "Tâm chữ thập", "camera.safeArea": "Vùng an toàn", "camera.infoOverlay": "Lớp thông tin",
    "camera.levelHorizon": "Cân đường chân trời", "camera.photo": "Ảnh", "camera.video": "Video",
    "timeline.newProject": "Dự án mới", "timeline.inspector": "Trình kiểm tra", "timeline.playhead": "Đầu phát",
    "timeline.marker": "Dấu mốc", "timeline.snap": "Bám", "timeline.zoomOut": "Thu nhỏ",
    "customScenes.clearAttachment": "Xóa liên kết",
    "vehicles.driver": "Tài xế", "vehicles.passenger": "Hành khách", "vehicles.occupants": "Người trên xe",
    "peds.spawnNpc": "Tạo dưới dạng NPC", "mechanic.maxUpgrade": "Nâng cấp tối đa", "mechanic.stock": "Nguyên bản",
    "mechanic.randomize": "Ngẫu nhiên", "mechanic.repair": "Sửa chữa", "mechanic.discardChanges": "Hủy thay đổi",
    "mechanic.indexed": "Theo bảng màu", "mechanic.numberPlate": "Biển số", "mechanic.xenonHeadlights": "Đèn Xenon",
    "mechanic.neonColour": "Màu đèn neon", "mechanic.classicLivery": "Tem xe cổ điển",
    "mechanic.roofLivery": "Tem nóc xe", "mechanic.health": "Độ bền", "mechanic.brokenGlass": "Kính vỡ",
    "mechanic.tyres": "Lốp xe", "mechanic.convertibleRoof": "Mui trần",
    "environment.formation": "Đội hình", "environment.quantity": "Số lượng", "environment.spacing": "Khoảng cách",
    "environment.facingDirection": "Hướng nhìn của NPC",
    "environment.facingHelp": "0° giữ hướng nhìn tự nhiên của đội hình. NPC đứng yên giữ hướng đã chọn; NPC đi lại sẽ tự xoay tự nhiên khi di chuyển.",
    "sceneTools.outliner": "Cây cảnh", "sceneTools.attachments": "Liên kết", "sceneTools.collections": "BỘ SƯU TẬP",
    "sceneTools.newCollectionPlaceholder": "Bộ sưu tập mới…", "sceneTools.layers": "lớp",
    "sceneTools.viewStates": "Trạng thái hiển thị", "sceneTools.solo": "Chỉ hiện", "sceneTools.selection": "LỰA CHỌN",
    "sceneTools.stableUid": "UID ổn định", "sceneTools.attachmentRole": "Vai trò liên kết",
    "sceneTools.notAttachable": "Không thể liên kết", "sceneTools.collection": "Bộ sưu tập",
    "sceneTools.validation": "KIỂM TRA", "sceneTools.new": "Mới", "sceneTools.attachmentDefinition": "THIẾT LẬP LIÊN KẾT",
    "sceneTools.childEntity": "Thực thể con", "sceneTools.parentEntity": "Thực thể cha",
    "sceneTools.pitch": "Độ nghiêng", "sceneTools.roll": "Độ lăn", "sceneTools.yaw": "Hướng xoay",
    "sceneTools.collision": "Va chạm", "sceneTools.unsavedOrganizationChanges": "THAY ĐỔI SẮP XẾP CHƯA LƯU",
    "sceneTools.session": "Phiên làm việc",
    "doorDirector.look": "Nhìn", "doorDirector.closing": "Đang đóng", "doorDirector.scrubFrame": "KHUNG ĐANG XEM",
    "doorDirector.notAssigned": "Chưa gán", "doorDirector.guided": "HƯỚNG DẪN",
    "doorDirector.oppositeSwing": "Mở về phía đối diện", "doorDirector.opening": "Đang mở",
    "doorDirector.easeOut": "Giảm tốc cuối", "doorDirector.closingUpper": "ĐANG ĐÓNG",
    "doorDirector.livePlayback": "PHÁT TRỰC TIẾP",
    "actorSequencer.look": "Nhìn", "actorSequencer.undo": "Hoàn tác", "actorSequencer.standalone": "ĐỘC LẬP",
    "actorSequencer.frameHeld": "ĐÃ GIỮ KHUNG", "actorSequencer.guidedSetup": "THIẾT LẬP CÓ HƯỚNG DẪN",
    "actorSequencer.buildPerformance": "Dựng phần trình diễn", "actorSequencer.review": "Xem lại",
    "actorSequencer.problems": "{count} vấn đề", "actorSequencer.castUpper": "DÀN DIỄN VIÊN",
    "actorSequencer.scenario": "Kịch bản", "actorSequencer.dictionary": "Từ điển",
    "actorSequencer.reviewSequence": "Xem lại chuỗi", "actorSequencer.step4Review": "BƯỚC 4 · XEM LẠI",
    "actorSequencer.seconds": "{value} giây", "actorSequencer.closingUpper": "ĐANG ĐÓNG",
    "actorSequencer.playingUpper": "ĐANG PHÁT",
    "stageLighting.closing": "Đang đóng", "stageLighting.guidedSetup": "THIẾT LẬP CÓ HƯỚNG DẪN",
    "stageLighting.look": "Nhìn", "stageLighting.keepBeamFocused": "Giữ tia sáng tập trung",
    "stageLighting.placing": "Đang đặt…", "stageLighting.recenterFaders": "Đưa thanh trượt về giữa",
    "stageLighting.pitch": "Độ nghiêng", "stageLighting.heading": "Hướng", "stageLighting.photometricsUpper": "THÔNG SỐ ÁNH SÁNG",
    "stageLighting.editableUpper": "CÓ THỂ CHỈNH", "stageLighting.motionPreset.static": "tĩnh",
    "stageLighting.motionPreset.float": "trôi", "stageLighting.motionPreset.sweep": "quét",
    "stageLighting.motionPresetDescription.float": "Trôi dọc nhẹ nhàng",
    "stageLighting.motionPresetDescription.pulse": "Bật tắt đều đặn",
    "stageLighting.motionPresetDescription.flicker": "Bật tắt không đều",
    "stageLighting.timing": "THỜI GIAN", "stageLighting.playbackBehavior": "Hành vi phát lại",
    "stageLighting.proceduralLayers": "CÁC LỚP CHUYỂN ĐỘNG", "stageLighting.layersCanBeCombined": "Có thể kết hợp các lớp",
    "stageLighting.amplitudeMeters": "BIÊN ĐỘ · MÉT", "stageLighting.frequency": "Tần số", "stageLighting.phase": "Pha",
    "stageLighting.roll": "Độ lăn", "stageLighting.yaw": "Hướng xoay", "stageLighting.swayDegrees": "ĐỘ LẮC · ĐỘ",
    "stageLighting.pattern": "Kiểu", "stageLighting.randomSeed": "Mầm ngẫu nhiên", "stageLighting.targetUpper": "MỤC TIÊU",
    "stageLighting.fixed": "Cố định", "stageLighting.following": "Đang đi theo", "stageLighting.aiming": "Đang nhắm",
    "stageLighting.referenced": "Đã tham chiếu", "stageLighting.viewUpper": "GÓC XEM",
    "stageLighting.gizmoEditing": "Đang chỉnh bằng gizmo", "stageLighting.starting": "Đang bắt đầu",
    "spooner.categoryAnimals": "Động vật", "spooner.categoryCiviliansFemale": "Dân thường nữ",
    "spooner.categoryCiviliansMale": "Dân thường nam", "spooner.categoryGangs": "Băng nhóm",
    "spooner.categoryCutscene": "Cảnh cắt", "spooner.categoryServices": "Dịch vụ", "spooner.categoryUnique": "Đặc biệt",
    "spooner.categoryFurniture": "Nội thất", "spooner.categoryDecoration": "Trang trí", "spooner.categoryMusic": "Âm nhạc",
    "spooner.categoryTrash": "Rác", "spooner.categoryFood": "Thực phẩm", "spooner.categoryGames": "Trò chơi",
    "spooner.categoryCompacts": "Xe cỡ nhỏ", "spooner.categorySedans": "Sedan", "spooner.categorySuvs": "SUV",
    "spooner.categoryCoupes": "Coupe", "spooner.categoryMuscle": "Xe cơ bắp", "spooner.categorySportsClassics": "Xe thể thao cổ điển",
    "spooner.categorySports": "Xe thể thao", "spooner.categorySuper": "Siêu xe", "spooner.categoryMotorcycles": "Mô tô",
    "spooner.categoryOffRoad": "Địa hình", "spooner.categoryIndustrial": "Công nghiệp", "spooner.categoryUtility": "Tiện ích",
    "spooner.categoryVans": "Xe van", "spooner.categoryCycles": "Xe đạp", "spooner.categoryBoats": "Thuyền",
    "spooner.categoryHelicopters": "Trực thăng", "spooner.categoryPlanes": "Máy bay", "spooner.categoryService": "Dịch vụ",
    "spooner.categoryEmergency": "Khẩn cấp", "spooner.categoryMilitary": "Quân sự", "spooner.categoryCommercial": "Thương mại",
    "spooner.categoryTrains": "Tàu hỏa", "spooner.modelsCount": "{{count}} mẫu"
  });
  const staticText = {};
  for (const key of Object.keys(spanish.staticText || {})) staticText[key] = translateText(key);
  const optionLabels = translateOptionTree(spanish.optionLabels || {});

  Object.assign(strings, {
    "cutscenePlayer.allBadge": "Tất cả",
    "cutscenePlayer.allCutscenes": "Tất cả cảnh cắt",
    "cutscenePlayer.newBadge": "Mới",
    "cutscenePlayer.newCutscenes": "Cảnh cắt mới",
    "cutscenePlayer.noNewCutscenes": "Không tìm thấy cảnh cắt mới"
  });

  Object.assign(strings, {
  "cameraTargeting.unavailable": "Không có mục tiêu khả dụng. Làm mới danh sách hoặc chọn cảnh đang hoạt động.",
  "cameraTargeting.scope": "Ưu tiên mục tiêu",
    "cameraTargeting.sceneFirst": "Ưu tiên cảnh / Timeline",
    "cameraTargeting.sceneOnly": "Chỉ cảnh / Timeline",
    "cameraTargeting.all": "Mọi thực thể ở gần",
    "cameraTargeting.look": "Mục tiêu nhìn",
    "cameraTargeting.independent": "Hướng nhìn điều khiển góc xoay; liên kết điều khiển vị trí. Hai mục tiêu có thể khác nhau.",
    "cameraTargeting.rightMouse": "Nút chuột phải",
    "cameraTargeting.free": "Tự do — xoay camera",
    "cameraTargeting.click": "Nhấp — khóa / bỏ khóa",
    "cameraTargeting.hold": "Giữ — theo dõi đến khi thả",
    "cameraTargeting.choose": "Chọn mục tiêu nhìn…",
    "cameraTargeting.previous": "Trước",
    "cameraTargeting.next": "Tiếp",
    "cameraTargeting.release": "Bỏ khóa",
    "cameraTargeting.none": "Chưa có mục tiêu nhìn",
    "cameraTargeting.waiting": "Đang chờ mục tiêu trong cảnh xuất hiện lại",
    "cameraTargeting.help": "Ẩn bảng bằng H. LMB gắn camera; RMB chọn mục tiêu nhìn. Alt + RMB xoay thủ công; N bật nhìn tự do. B/V đổi mục tiêu mà không đổi liên kết.",
    "cameraTargeting.focusMode": "Lấy nét ống kính",
    "cameraTargeting.manualFocus": "Khoảng cách thủ công",
    "cameraTargeting.centerFocus": "Tự động — giữa màn hình",
    "cameraTargeting.targetFocus": "Theo dõi nét — mục tiêu nhìn",
    "cameraTargeting.focusHelp": "Bật độ sâu trường ảnh trước. Lấy nét ưu tiên mục tiêu nhìn, rồi mục tiêu liên kết hoặc G. Chỉ thay đổi độ nét, không đổi hướng camera."
  });

  Object.assign(strings, {
    "cameraDrone.banking": "Độ nghiêng drone",
    "cameraDrone.bankingHelp": "Độ nghiêng tối đa khi xoay: 0° cân bằng đường chân trời, 15° là mức chuẩn, 45° nghiêng mạnh. Không đổi tốc độ hay quán tính."
  });

  Object.assign(strings, {
    "cameraTargeting.lookSpeed": "Tốc độ hướng nhìn",
    "cameraTargeting.lookSpeedHelp": "1–100%: giá trị thấp xoay chậm, giá trị cao hướng tới mục tiêu nhanh. Áp dụng cho RMB, B/V, mục tiêu trong bảng và G, kể cả khi theo dõi. Giá trị quá thấp sẽ theo chậm hơn chủ thể di chuyển nhanh. Không đổi xoay thủ công hay độ nghiêng drone."
  });

  Object.assign(strings, {
    "cameraZoom.speed": "Tốc độ thu phóng",
    "cameraZoom.help": "Ẩn bảng bằng H, rồi giữ Z để phóng to hoặc C để thu nhỏ. 1–200%: thấp hơn thì chậm hơn; 100% là bình thường; 200% nhanh gấp đôi. Thay đổi FOV, không đổi vị trí. Không đổi các thiết lập ống kính hay phát lại thu phóng đã ghi."
  });

  window.SD_I18N.registerLocale("vi", {
    shortLabel: "VI",
    languageName: "Tiếng Việt",
    direction: "ltr",
    strings: strings,
    staticText: staticText,
    optionLabels: optionLabels
  });
})();
