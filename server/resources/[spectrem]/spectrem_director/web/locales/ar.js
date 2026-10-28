(function () {
  "use strict";

  const packs = window.SD_LANG_PACKS || {};
  const english = packs.en || {};
  const spanish = packs.es || {};

  const phrases = {
    "Custom Scene": "مشهد مخصص", "Custom Scenes": "المشاهد المخصصة",
    "Actor Sequencer": "منظم الممثل", "Actor Sequence": "تسلسل الممثل",
    "Door Director": "مخرج الأبواب", "Stage Lighting": "إضاءة المسرح",
    "Rockstar Editor": "محرر Rockstar", "Object Spooner": "أداة وضع العناصر",
    "Ped Replay": "إعادة شخصية", "Vehicle Replay": "إعادة مركبة",
    "Camera Sequence": "تسلسل الكاميرا", "World position": "موضع العالم",
    "Current player": "اللاعب الحالي", "Saved ped": "شخصية محفوظة",
    "Saved vehicle": "مركبة محفوظة", "Free camera": "كاميرا حرة", "Freecam": "كاميرا حرة",
    "keyframe": "إطار مفتاحي", "keyframes": "إطارات مفتاحية",
    "line of sight": "خط الرؤية", "depth of field": "عمق المجال", "field of view": "مجال الرؤية",
    "not available": "غير متاح", "could not be": "تعذر", "could not": "تعذر",
    "no longer exists": "لم يعد موجودًا", "no longer available": "لم يعد متاحًا",
    "before saving": "قبل الحفظ", "while the editor was opening": "أثناء فتح المحرر",
    "Try again": "حاول مرة أخرى", "Choose a": "اختر", "Select a": "حدد",
    "Click to": "انقر من أجل", "Press ESC": "اضغط ESC", "Back to": "العودة إلى",
    "Add to Timeline": "إضافة إلى الخط الزمني", "Add to scene": "إضافة إلى المشهد",
    "Add to Scene": "إضافة إلى المشهد", "Save changes": "حفظ التغييرات",
    "Save Changes": "حفظ التغييرات", "Start preview": "بدء المعاينة",
    "Stop preview": "إيقاف المعاينة", "Preview paused": "المعاينة متوقفة مؤقتًا",
    "PREVIEW PAUSED": "المعاينة متوقفة مؤقتًا", "NEEDS ATTENTION": "يتطلب الانتباه",
    "No options available.": "لا توجد خيارات متاحة.", "No results": "لا توجد نتائج",
    "Search scenes": "بحث في المشاهد", "Search animations": "بحث في الحركات",
    "Search saved": "بحث في المحفوظات", "Open & close": "فتح وإغلاق",
    "Unlock & open": "فتح القفل والباب", "Close & lock": "إغلاق وقفل",
    "Fixed world position": "موضع ثابت في العالم", "Current Scene": "المشهد الحالي",
    "Timeline playback": "تشغيل الخط الزمني", "input focus": "تركيز الإدخال",
    "recording candidate": "مرشح تسجيل", "embedded-light fixture": "وحدة إضاءة مدمجة",
    "directional Spot lights": "أضواء Spot اتجاهية", "directional spotlight": "كشاف اتجاهي",
    "point light": "ضوء نقطي", "route points": "نقاط المسار", "walkable surface": "سطح قابل للمشي",
    "scene actor": "ممثل المشهد", "spawned NPC": "شخصية NPC منشأة",
    "Facial expression": "تعبير الوجه", "Follow route": "اتباع المسار",
    "Follow actor": "اتباع الممثل", "Walk to point": "المشي إلى النقطة",
    "Drive to point": "القيادة إلى النقطة", "Look at point": "النظر إلى النقطة",
    "Aim at point": "التصويب على النقطة", "Shoot at point": "إطلاق النار على النقطة",
    "Play animation": "تشغيل الحركة", "Play scenario": "تشغيل السيناريو",
    "Equip weapon": "تجهيز السلاح", "Enter vehicle": "دخول المركبة", "Leave vehicle": "مغادرة المركبة"
  };

  const words = {
    language: "اللغة", scale: "المقياس", favorite: "مفضل", favorites: "المفضلة",
    scene: "مشهد", scenes: "مشاهد", animation: "حركة", animations: "حركات",
    actor: "ممثل", actors: "ممثلون", player: "لاعب", players: "لاعبون",
    ped: "شخصية", peds: "شخصيات", npc: "NPC", vehicle: "مركبة", vehicles: "مركبات",
    object: "عنصر", objects: "عناصر", prop: "عنصر", props: "عناصر",
    camera: "كاميرا", cameras: "كاميرات", light: "ضوء", lights: "أضواء", lighting: "إضاءة",
    fixture: "وحدة إضاءة", fixtures: "وحدات إضاءة", timeline: "الخط الزمني",
    track: "مسار", tracks: "مسارات", clip: "مقطع", clips: "مقاطع", replay: "إعادة", replays: "إعادات",
    route: "مسار", routes: "مسارات", point: "نقطة", points: "نقاط",
    waypoint: "نقطة مسار", waypoints: "نقاط مسار", door: "باب", doors: "أبواب",
    environment: "بيئة", environments: "بيئات", effect: "تأثير", effects: "تأثيرات",
    weather: "الطقس", time: "الوقت", density: "الكثافة", crowd: "حشد", chase: "مطاردة", club: "نادٍ",
    search: "بحث", filter: "تصفية", select: "تحديد", choose: "اختيار", selected: "محدد",
    add: "إضافة", remove: "إزالة", delete: "حذف", duplicate: "تكرار", copy: "نسخ", paste: "لصق",
    rename: "إعادة تسمية", edit: "تحرير", update: "تحديث", save: "حفظ", saved: "محفوظ",
    saving: "جارٍ الحفظ", load: "تحميل", loaded: "محمّل", loading: "جارٍ التحميل",
    create: "إنشاء", created: "تم الإنشاء", open: "فتح", close: "إغلاق", closed: "مغلق",
    cancel: "إلغاء", confirm: "تأكيد", apply: "تطبيق", reset: "إعادة ضبط",
    start: "بدء", stop: "إيقاف", pause: "إيقاف مؤقت", resume: "استئناف", play: "تشغيل",
    preview: "معاينة", record: "تسجيل", recording: "تسجيل", capture: "التقاط",
    place: "وضع", placement: "تحديد الموضع", position: "الموضع", rotation: "الدوران",
    direction: "الاتجاه", movement: "الحركة", motion: "الحركة", speed: "السرعة", duration: "المدة",
    distance: "المسافة", height: "الارتفاع", width: "العرض", angle: "الزاوية", radius: "نصف القطر",
    intensity: "الشدة", brightness: "السطوع", color: "اللون", colours: "الألوان",
    red: "أحمر", green: "أخضر", blue: "أزرق", white: "أبيض", black: "أسود",
    left: "يسار", right: "يمين", front: "أمام", back: "رجوع", forward: "إلى الأمام",
    up: "أعلى", down: "أسفل", side: "جانب", world: "العالم", local: "محلي",
    current: "الحالي", custom: "مخصص", default: "افتراضي", advanced: "متقدم", basic: "أساسي",
    exact: "دقيق", optional: "اختياري", required: "مطلوب", enabled: "مفعل", disabled: "معطل",
    available: "متاح", unavailable: "غير متاح", active: "نشط", inactive: "غير نشط",
    visible: "مرئي", hidden: "مخفي", show: "إظهار", hide: "إخفاء",
    lock: "قفل", locked: "مقفل", unlock: "فتح القفل", unlocked: "غير مقفل",
    attach: "إرفاق", attached: "مرفق", detach: "فصل", follow: "اتباع", aim: "تصويب",
    shoot: "إطلاق النار", walk: "مشي", run: "ركض", wait: "انتظار", enter: "دخول",
    leave: "مغادرة", drive: "قيادة", fight: "قتال", weapon: "سلاح", weapons: "أسلحة",
    unarmed: "بدون سلاح", ammo: "ذخيرة", action: "إجراء", actions: "إجراءات",
    event: "حدث", events: "أحداث", mode: "وضع", type: "نوع", name: "الاسم", model: "الطراز",
    category: "الفئة", folder: "مجلد", folders: "مجلدات", preset: "إعداد مسبق", presets: "إعدادات مسبقة",
    option: "خيار", options: "خيارات", setting: "إعداد", settings: "إعدادات",
    status: "الحالة", state: "الحالة", value: "القيمة", amount: "المقدار",
    smooth: "سلس", linear: "خطي", natural: "طبيعي", fast: "سريع", slow: "بطيء",
    normal: "عادي", soft: "ناعم", manual: "يدوي", automatic: "تلقائي",
    loop: "تكرار", once: "مرة واحدة", repeat: "تكرار", continuous: "مستمر",
    working: "جارٍ العمل", checking: "جارٍ التحقق", preparing: "جارٍ التحضير", ready: "جاهز",
    complete: "مكتمل", incomplete: "غير مكتمل", error: "خطأ", errors: "أخطاء",
    warning: "تحذير", warnings: "تحذيرات", failed: "فشل", invalid: "غير صالح",
    missing: "مفقود", empty: "فارغ", unknown: "غير معروف", untitled: "بلا عنوان",
    before: "قبل", after: "بعد", during: "أثناء", while: "بينما", first: "أول",
    next: "التالي", previous: "السابق", finish: "إنهاء", continue: "متابعة",
    help: "مساعدة", information: "معلومات", description: "وصف", summary: "ملخص",
    click: "انقر", press: "اضغط", hold: "استمر بالضغط", drag: "اسحب", move: "تحريك",
    rotate: "تدوير", adjust: "ضبط", change: "تغيير", use: "استخدام", uses: "يستخدم",
    increase: "زيادة", decrease: "تقليل", yes: "نعم", no: "لا", none: "لا شيء", all: "الكل",
    only: "فقط", and: "و", or: "أو", with: "مع", without: "بدون", from: "من", to: "إلى",
    at: "عند", in: "في", on: "على", for: "لـ", is: "", are: "", was: "", were: "",
    the: "", a: "", an: "", this: "هذا", that: "ذلك", these: "هذه", your: "الخاص بك",
    its: "الخاص به", now: "الآن", again: "مرة أخرى", yet: "حتى الآن", still: "ما زال",
    successfully: "بنجاح"
  };

  Object.assign(words, {
    of: "من", as: "بصفة", so: "لذلك", not: "غير", then: "ثم", it: "هو",
    can: "يمكن", you: "أنت", my: "الخاص بي", more: "المزيد", less: "أقل",
    some: "بعض", any: "أي", every: "كل", each: "كل", one: "واحد", two: "اثنان",
    last: "الأخير", below: "أدناه", above: "أعلاه", here: "هنا", together: "معًا",
    until: "حتى", when: "عندما", than: "من", because: "لأن", but: "لكن",
    never: "أبدًا", always: "دائمًا", directly: "مباشرة", automatically: "تلقائيًا",
    exactly: "بالضبط", properly: "بشكل صحيح", currently: "حاليًا", temporarily: "مؤقتًا",
    subject: "الهدف", collection: "مجموعة", collections: "مجموعات", entity: "كيان",
    entities: "كيانات", attachment: "مرفق", attachments: "مرفقات", changes: "تغييرات",
    layer: "طبقة", layers: "طبقات", view: "العرض", transform: "التحويل",
    transforms: "التحويلات", editor: "المحرر", step: "الخطوة", playback: "التشغيل",
    new: "جديد", fixed: "ثابت", look: "النظر", sequence: "التسلسل",
    seconds: "ثوانٍ", starting: "البدء", controls: "عناصر التحكم", frame: "إطار",
    segment: "مقطع", child: "تابع", children: "توابع", parent: "أصل", parents: "أصول",
    offset: "إزاحة", closing: "الإغلاق", opening: "الفتح", gizmo: "أداة التحريك",
    entries: "إدخالات", entry: "إدخال", solo: "فردي", test: "اختبار", discard: "تجاهل",
    orbit: "مدار", project: "مشروع", playhead: "رأس التشغيل", out: "الخروج",
    selection: "التحديد", inspect: "فحص", should: "ينبغي", physical: "مادي",
    procedural: "إجرائي", authored: "مضبوط", embedded: "مدمج", sweep: "مسح",
    pulse: "نبض", random: "عشوائي", visibility: "الرؤية", target: "الهدف",
    count: "العدد", found: "موجود",
    version: "إصدار", please: "يرجى", work: "يعمل", playing: "قيد التشغيل",
    performance: "الأداء", livery: "الطلاء الخارجي", disable: "تعطيل", enable: "تفعيل",
    replace: "استبدال", detected: "مكتشف", tools: "الأدوات", recover: "استعادة",
    unsaved: "غير محفوظ", path: "المسار", anchor: "مرساة", zoom: "التكبير",
    smoothing: "التنعيم", game: "اللعبة", stage: "المسرح", stable: "ثابت",
    index: "الفهرس", read: "قراءة", live: "مباشر", guided: "موجّه",
    ease: "تدرج", draw: "رسم", review: "مراجعة", beam: "الشعاع", space: "الحيز",
    binary: "ثنائي", welcome: "مرحبًا", thank: "شكرًا", thanks: "شكرًا",
    purchasing: "شراء", script: "البرنامج النصي", support: "الدعم", means: "يعني",
    lot: "الكثير", truly: "حقًا", helps: "يساعد", developer: "مطور",
    mind: "الاعتبار", beta: "تجريبي", features: "الميزات", behave: "يتصرف",
    unexpectedly: "بشكل غير متوقع", gameplay: "اللعب", toggle: "تبديل", delay: "تأخير",
    countdown: "عد تنازلي", flags: "علامات", upper: "علوي", code: "الرمز",
    activated: "مفعّل", deactivated: "معطّل", women: "نساء", men: "رجال",
    generating: "جارٍ الإنشاء", regenerate: "إعادة الإنشاء", parts: "الأجزاء",
    cosmetics: "المظهر", wheels: "العجلات", colors: "الألوان", body: "الهيكل",
    interior: "المقصورة", paint: "الطلاء", condition: "الحالة", notice: "تنبيه",
    records: "يسجل", nearby: "القريبة", captured: "مُلتقطة", tool: "الأداة",
    development: "التطوير", reproduce: "إعادة الإنتاج", understood: "مفهوم",
    clear: "مسح", done: "تم", refresh: "تحديث", retry: "إعادة المحاولة",
    undo: "تراجع", redo: "إعادة", frequency: "التردد", phase: "الطور",
    inconsistencies: "تعارضات", using: "استخدام", restart: "أعد تشغيل", server: "الخادم",
    we: "نحن", axis: "المحور", rings: "حلقات", ground: "الأرض", fly: "طيران",
    focus: "تركيز", precision: "الدقة", grid: "الشبكة", exit: "خروج", panel: "اللوحة",
    easing: "الانتقال", pacing: "الإيقاع", distribute: "توزيع", gaze: "النظر",
    free: "حر", part: "جزء", equipped: "مجهز", pointer: "المؤشر", rigid: "صلب",
    mount: "تثبيت", auto: "تلقائي", softness: "النعومة", sensitivity: "الحساسية",
    response: "الاستجابة", mouse: "الفأرة", base: "أساسي", lens: "العدسة",
    drone: "الطائرة المسيرة", image: "الصورة", autofocus: "تركيز تلقائي",
    strength: "القوة", allow: "السماح", bars: "الأشرطة", notifications: "الإشعارات",
    guides: "الأدلة", rule: "قاعدة", thirds: "الأثلاث", center: "الوسط",
    cross: "التقاطع", safe: "آمن", area: "المنطقة", info: "المعلومات",
    overlay: "التراكب", level: "تسوية", horizon: "الأفق", photo: "صورة", video: "فيديو",
    inspector: "المفتش", marker: "علامة", snap: "محاذاة", fit: "ملاءمة",
    building: "بناء", properties: "الخصائص", get: "استعد", finished: "انتهيت",
    driver: "السائق", passenger: "راكب", occupants: "الركاب", seat: "المقعد",
    max: "الحد الأقصى", upgrade: "ترقية", stock: "افتراضي", randomize: "عشوائي",
    repair: "إصلاح", matches: "يطابق", indexed: "مفهرس", number: "رقم", plate: "اللوحة",
    xenon: "زينون", headlights: "المصابيح الأمامية", neon: "نيون", colour: "اللون",
    classic: "كلاسيكي", roof: "السقف", extras: "الإضافات", dirt: "الأوساخ",
    health: "السلامة", broken: "مكسور", glass: "الزجاج", torn: "منزوع",
    tyres: "الإطارات", convertible: "قابل للطي", manager: "المدير", formation: "التشكيل",
    source: "المصدر", quantity: "الكمية", spacing: "التباعد", restoring: "جارٍ الاستعادة",
    validated: "موثّقة", hierarchy: "التسلسل الهرمي", states: "الحالات",
    attachable: "قابل للإرفاق", validation: "التحقق", definitions: "التعريفات",
    unsupported: "غير مدعوم", them: "إياها", override: "استبدال", pin: "تثبيت",
    backed: "مدعومة", listed: "مدرجة", driven: "متحكم بها", owns: "يمتلك",
    requests: "يطلب", network: "الشبكة", ownership: "الملكية", control: "التحكم",
    nothing: "لا شيء", changed: "تغيّر", validate: "تحقق", organization: "التنظيم",
    discarding: "تجاهل", over: "فوق", send: "إرسال", scrub: "تمرير",
    opens: "يفتح", system: "النظام", assigned: "مُعيّن", temporary: "مؤقت",
    resource: "المورد", shutdown: "الإيقاف", set: "ضبط", what: "ماذا", do: "يفعل",
    cycle: "دورة", which: "أي", pick: "اختر", looks: "يبدو", correct: "صحيح",
    opposite: "معاكس", used: "مستخدم", by: "بواسطة", total: "الإجمالي",
    length: "الطول", timed: "موقّت", fine: "دقيق", tuning: "الضبط", curves: "المنحنيات",
    style: "النمط", moment: "لحظة", standalone: "مستقل", build: "بناء", placed: "موضوع",
    steps: "الخطوات", estimated: "المقدر", problem: "مشكلة", destructive: "متلف",
    mark: "تحديد", drawing: "الرسم", main: "الرئيسي", appears: "يظهر", who: "من",
    cast: "طاقم", afterward: "بعد ذلك", removes: "يزيل", handles: "المعرّفات المؤقتة",
    existing: "موجود", ids: "المعرّفات", along: "مع", needs: "يحتاج", arrival: "الوصول",
    equip: "تجهيز", holster: "إخفاء السلاح", scenario: "سيناريو", dictionary: "القاموس",
    finishes: "ينتهي", need: "تحتاج", halfway: "منتصف", through: "خلال", full: "كامل",
    casting: "اختيار الطاقم", stored: "محفوظ", portable: "قابل للنقل", value: "القيمة",
    visual: "مرئي", output: "الإخراج", persistent: "مستمر", directional: "اتجاهي",
    fix: "إصلاح", return: "عودة", essential: "الأساسية", whether: "سواء",
    animated: "متحرك", longer: "أطول", overlaps: "يتداخل", tracking: "التتبع",
    resolved: "محلول", focused: "مركز", placing: "جارٍ الوضع", near: "قرب",
    useful: "مفيد", recenter: "إعادة التوسيط", faders: "المنزلقات", heading: "الاتجاه",
    known: "معروف", swatch: "عينة اللون", retain: "الاحتفاظ", reach: "المدى",
    cone: "المخروط", remain: "يبقى", photometrics: "الخصائص الضوئية",
    they: "هم", produce: "تنتج", same: "نفس", static: "ثابت", float: "طفو",
    gentle: "لطيف", vertical: "عمودي", drift: "انجراف", spotlight: "كشاف",
    regular: "منتظم", irregular: "غير منتظم", spot: "كشاف", releases: "يلغي",
    flicker: "وميض", switch: "تبديل", itself: "نفسه", amplitude: "السعة",
    pattern: "النمط", seed: "البذرة", following: "يتبع", aiming: "يصوّب",
    referenced: "مرتبط", editing: "التحرير", civilians: "مدنيون", sports: "رياضية"
  });

  Object.assign(words, {
    showing: "عرض", results: "النتائج", refine: "حسّن", see: "رؤية", keep: "احتفظ",
    may: "قد", unexpected: "غير متوقع", fav: "المفضلة", anims: "الحركات",
    session: "الجلسة", release: "اترك", per: "لكل", sync: "مزامنة", root: "الجذر",
    held: "ممسوك", framing: "التأطير", collision: "التصادم", shake: "الاهتزاز",
    cinematic: "سينمائي", streamed: "محمّلة", spawn: "إنشاء", appearance: "المظهر",
    applying: "جارٍ تطبيق", has: "يحتوي", role: "الدور", reference: "مرجع",
    non: "غير", definition: "التعريف", bone: "العظمة", pitch: "الميل", roll: "التدحرج",
    yaw: "الانحراف", be: "يكون", their: "الخاص بهم", previewing: "معاينة",
    result: "النتيجة", returns: "يعود", cursor: "المؤشر", original: "الأصلية",
    swing: "اتجاه الفتح", how: "كيف", setup: "الإعداد", ends: "ينتهي",
    destination: "الوجهة", order: "الترتيب", creates: "ينشئ", pace: "السرعة",
    follows: "يتبع", least: "الأقل", timing: "التوقيت", stays: "يبقى",
    asset: "الأصل", editable: "قابل للتحرير", behavior: "السلوك", degrees: "درجات",
    animals: "حيوانات", gangs: "عصابات", cutscene: "مشهد سينمائي", services: "خدمات",
    unique: "فريدة", furniture: "أثاث", decoration: "زينة", music: "موسيقى",
    trash: "نفايات", food: "طعام", games: "ألعاب", compacts: "سيارات صغيرة",
    sedans: "سيارات سيدان", suvs: "سيارات SUV", coupes: "سيارات كوبيه",
    muscle: "سيارات عضلية", classics: "كلاسيكية", super: "خارقة",
    motorcycles: "دراجات نارية", road: "الطرق", industrial: "صناعية",
    utility: "خدمات", vans: "شاحنات صغيرة", cycles: "دراجات", boats: "قوارب",
    helicopters: "مروحيات", planes: "طائرات", service: "خدمة", emergency: "طوارئ",
    military: "عسكرية", commercial: "تجارية", trains: "قطارات", models: "طرز",
    wheel: "العجلات", engine: "المحرك", switch: "تبديل", meters: "أمتار",
    combined: "مدمجة", gentle: "لطيف", sine: "جيبية", wave: "موجة",
    oscillating: "متذبذب", author: "ضبط", around: "حول", locked: "مقفل",
    hold: "استمر بالضغط", use: "استخدم", choose: "اختر", add: "أضف"
  });

  const optionPhrases = {
    "Ninguna": "لا شيء", "Pistola de combate": "مسدس قتالي", "Pistola pesada": "مسدس ثقيل",
    "Pistola ametralladora": "مسدس رشاش", "Pistola": "مسدس", "Rifle de asalto": "بندقية هجومية",
    "Rifle avanzado": "بندقية متقدمة", "Rifle compacto": "بندقية مدمجة", "Rifle bullpup": "بندقية Bullpup",
    "Carabina especial": "كاربين خاص", "Carabina": "كاربين", "Escopeta de bombeo": "بندقية ضخ",
    "Escopeta de asalto": "بندقية هجومية", "Escopeta pesada": "بندقية ثقيلة",
    "Rifle de francotirador": "بندقية قنص", "Francotirador pesado": "قناص ثقيل",
    "Lanzagranadas": "قاذف قنابل", "Lanzacohetes": "قاذف صواريخ", "Lanzacohetes guiado": "قاذف صواريخ موجه",
    "Granada": "قنبلة يدوية", "Granada de humo": "قنبلة دخان", "Gas lacrimógeno": "غاز مسيل للدموع",
    "Cóctel molotov": "مولوتوف", "Extintor": "طفاية حريق", "Bidón de gasolina": "عبوة بنزين",
    "Cuchillo": "سكين", "Porra": "هراوة", "Martillo": "مطرقة", "Bate": "مضرب",
    "Palanca": "عتلة", "Palo de golf": "مضرب غولف", "Hacha": "فأس", "Puño americano": "قبضة حديدية",
    "Freemode masculino": "Freemode ذكر", "Freemode femenino": "Freemode أنثى",
    "Patrulla": "دورية", "Moto policial": "دراجة شرطة", "Furgón policial": "شاحنة شرطة",
    "Transporte policial": "نقل شرطة", "Riot policial": "مركبة مكافحة شغب",
    "Extra soleado": "مشمس جدًا", "Despejado": "صافٍ", "Nublado": "غائم", "Nubes": "سحب",
    "Con smog": "ضباب دخاني", "Niebla": "ضباب", "Cubierto": "ملبد بالغيوم", "Lluvia": "ممطر",
    "Tormenta": "عاصفة", "Despeje": "يتحسن", "Neutral": "محايد", "Nieve": "ثلج",
    "Ventisca": "عاصفة ثلجية", "Nieve ligera": "ثلج خفيف"
  };

  const namedOverrides = {
    railFavs: "المفضلة", railAnims: "الحركات", railCustomAnims: "حركات+",
    "environment.facingDirection": "اتجاه نظر شخصيات NPC",
    "environment.facingHelp": "يحافظ 0° على اتجاه التشكيل الطبيعي. تحتفظ شخصيات NPC الثابتة بالاتجاه المحدد، بينما تتجه الشخصيات المتجولة بشكل طبيعي أثناء الحركة.",
    railEnvironment: "البيئة", railClubs: "النوادي", railSpooner: "أداة العناصر",
    paletteSearch: "ابحث في المشاهد أو الحركات أو الشخصيات أو التأثيرات...",
    listTruncated: "يتم عرض النتائج الأولى فقط — حسّن البحث لرؤية المزيد",
    welcomeTitle: "مرحبًا بك في Spectrem Director",
    welcomeThanks: "شكرًا لشرائك هذا الإصدار من البرنامج — دعمك مهم جدًا ويساعدني حقًا كمطور",
    welcomeBeta: "يرجى تذكر أن هذه نسخة تجريبية حاليًا؛ قد لا تعمل بعض الميزات أو الحركات كما ينبغي أو قد تتصرف على نحو غير متوقع",
    placementHint: "اضبط الموضع ثم ثبّته. ما زال ENTER وBACKSPACE يعملان.",
    scenesFav: "المشاهد المفضلة", pressEscToClose: "اضغط ESC للإغلاق", npcsInScene: "شخصيات NPC في المشهد",
    pedReplayDisclaimerBody: "يسجل Replay الشخصية إجراءات شخصية اللاعب النشطة فقط؛ ولا يلتقط شخصيات NPC القريبة. لا تزال هذه الأداة قيد التطوير، لذلك قد لا تتكرر بعض الإجراءات بدقة.",
    "common.off": "إيقاف", "director.title": "Spectrem Director", "director.unavailable": "Spectrem Director غير متاح",
    "director.integrityMessage": "تم اكتشاف تعارضات أثناء استخدام Spectrum Director؛ يرجى إعادة تشغيل الخادم",
    "director.toolsDisabled": "جميع أدوات Director معطلة مؤقتًا.", "director.customAnimations": "حركات مخصصة",
    "director.clubs": "النوادي", "director.pressEscape": "اضغط ESC للإغلاق",
    "startup.recoverBody": "عُثر على مشهد مخصص غير محفوظ من جلستك السابقة: {name} ({count} {entryLabel}).",
    "startup.recoverHint": "استعده لمتابعة العمل أو تجاهله.", "gizmo.releaseToEdit": "اترك الزر للتحرير",
    "gizmo.exitSpooner": "الخروج من أداة العناصر", "camera.perSegment": "لكل مقطع",
    "camera.clipSync": "مزامنة المقطع", "camera.entityRoot": "جذر الكيان", "camera.heldWeapon": "السلاح الممسوك",
    "camera.lockFraming": "قفل التأطير", "camera.manualFov": "مجال رؤية يدوي", "camera.worldCollision": "تصادم العالم",
    "camera.cameraShake": "اهتزاز الكاميرا", "camera.shakeStrength": "قوة الاهتزاز",
    "camera.cinematicBars": "الأشرطة السينمائية", "camera.hideGameHud": "إخفاء واجهة اللعبة",
    "camera.framingGuides": "أدلة التأطير", "camera.fieldOfView": "FOV",
    "vehicles.selectStreamed": "حدد مركبة محمّلة...", "peds.spawnNpc": "إنشاء كشخصية NPC",
    "peds.editAppearance": "تحرير المظهر", "peds.removeLastNpc": "إزالة آخر NPC", "peds.removeAllNpcs": "إزالة جميع شخصيات NPC",
    "mechanic.customRgb": "لون RGB مخصص", "mechanic.allOff": "إيقاف الكل", "mechanic.tornDoors": "أبواب منزوعة",
    "sceneTools.title": "مخطط المشهد والمرفقات", "sceneTools.outliner": "مخطط المشهد",
    "sceneTools.closeRestorePreview": "إغلاق واستعادة المعاينة", "sceneTools.applyingValidatedChanges": "جارٍ تطبيق تغييرات المشهد الموثقة...",
    "sceneTools.noSceneEntries": "لا يحتوي هذا المشهد على إدخالات", "sceneTools.stableUid": "UID ثابت",
    "sceneTools.attachmentRole": "دور المرفق", "sceneTools.sceneRoot": "جذر المشهد",
    "sceneTools.invalidAttachmentsWarning": "يشير تعريف مرفق محفوظ واحد أو أكثر إلى طبقة ليست كيانًا أو إلى دور مرفق غير مدعوم. عدّلها أو احذفها قبل التطبيق.",
    "sceneTools.attachmentDefinition": "تعريف المرفق", "sceneTools.boneNameOrIndex": "اسم العظمة أو فهرسها",
    "sceneTools.vehicleBoneOverride": "تجاوز عظمة المركبة", "sceneTools.pitch": "الميل", "sceneTools.roll": "التدحرج",
    "sceneTools.yaw": "الانحراف", "sceneTools.syncRotation": "مزامنة الدوران", "sceneTools.collision": "التصادم",
    "sceneTools.attachmentOwnershipHelp": "تظهر فقط الطبقات المرتبطة بكيان. يمكن للطبقات التي تقودها التحويلات (حركة العنصر ومسارات Replay) أن تكون أصولًا لا توابع، لأن تشغيلها يتحكم في التحويل العالمي. لا تطلب المعاينة ملكية الشبكة؛ ومن دون التحكم في الكيان التابع لن يتغير شيء.",
    "sceneTools.validateSaveDefinition": "تحقق واحفظ التعريف", "sceneTools.session": "الجلسة",
    "sceneTools.previewingSceneChanges": "معاينة تغييرات المشهد",
    "sceneTools.viewportHelp": "المحرر مخفي لتتمكن من فحص النتيجة. يعيدك ESC إلى المحرر من دون تجاهلها.",
    "doorDirector.moveCursorOverDoor": "حرّك المؤشر فوق الباب", "doorDirector.streamedWorldObject": "عنصر عالم محمّل",
    "doorDirector.selectDoorInWorldHelp": "تفتح الكاميرا الحرة للقراءة فقط في أداة العناصر تلقائيًا. وجّه المؤشر إلى الباب وانقر عليه.",
    "doorDirector.trackUid": "UID المسار", "doorDirector.doorSystemHash": "معرّف نظام الباب",
    "doorDirector.previewTemporaryHelp": "تغييرات المعاينة مؤقتة. يعيد الإيقاف أو الرجوع أو إيقاف المورد حالة الباب الأصلية.",
    "doorDirector.oppositeSwing": "اتجاه فتح معاكس", "doorDirector.defaultSwing": "اتجاه الفتح الافتراضي",
    "doorDirector.howFast": "ما سرعة حركة الباب؟", "doorDirector.animateLockState": "تحريك حالة القفل",
    "doorDirector.dragPlayheadAddKeyframe": "اسحب رأس التشغيل · انقر نقرًا مزدوجًا لإضافة إطار مفتاحي",
    "doorDirector.dragPlayheadAddLockEvent": "اسحب رأس التشغيل · انقر نقرًا مزدوجًا لإضافة حدث قفل",
    "doorDirector.timelineHelp": "اسحب رأس التشغيل لفحص أي لحظة · يعيد ESC / رجوع الباب الأصلي",
    "actorSequencer.frameHeld": "الإطار مثبت", "actorSequencer.freecamHint": "RMB + WASD للكاميرا الحرة",
    "actorSequencer.guidedSetup": "إعداد موجّه", "actorSequencer.pointsPlaced": "تم وضع {count} نقطة",
    "actorSequencer.waypointEvents": "{count} من أحداث نقاط المسار", "actorSequencer.loopSequenceHelp": "كرر التسلسل حتى نهاية مقطع الخط الزمني أو المشهد.",
    "actorSequencer.problems": "{count} مشكلة", "actorSequencer.nonDestructiveHelp": "لا تصبح تغييرات المسار نهائية حتى تحفظها. يعيدك ESC دائمًا إلى المحرر السابق.",
    "actorSequencer.routeCaptureHelp": "انقر نقطة البداية ثم كل وجهة بالترتيب.",
    "actorSequencer.routeEmptyHelp": "تحدد النقرة الأولى موضع بداية الممثل. وتنشئ كل نقرة تالية مقطع مشي أو ركض.",
    "actorSequencer.waypoint": "نقطة المسار {index}", "actorSequencer.howShouldSegmentMove": "كيف يجب اجتياز هذا المقطع؟",
    "actorSequencer.naturalPace": "سرعة طبيعية", "actorSequencer.fastPace": "سرعة عالية",
    "actorSequencer.chooseRouteActor": "اختر من سيتبع المسار", "actorSequencer.npc": "NPC",
    "actorSequencer.playerRestoreHelp": "تعيد المعاينة اللاعب إلى حالته بعد الانتهاء.",
    "actorSequencer.stableActorReferenceHelp": "يستخدم مرجع ممثل المشهد الثابت.",
    "actorSequencer.cinematicNpcHelp": "ينشئ التسلسل شخصية NPC السينمائية هذه ويزيلها تلقائيًا.",
    "actorSequencer.npcPreset": "إعداد NPC مسبق", "actorSequencer.addonModelOptional": "طراز Addon (اختياري)",
    "actorSequencer.stableReferencesHelp": "لا تُحفظ المعرّفات المؤقتة أبدًا. تستخدم الشخصيات الموجودة معرّفات ثابتة، بينما تحفظ شخصيات NPC المنشأة طرازها ومظهرها.",
    "actorSequencer.eventsNeedRouteHelp": "ترتبط الأحداث بنقاط المسار، لذلك يحتاج المسار إلى بداية ووجهة على الأقل.",
    "actorSequencer.onArrivalAtWaypoint": "عند الوصول إلى نقطة المسار {index}", "actorSequencer.eventsRunInOrder": "تعمل الأحداث أدناه بهذا الترتيب.",
    "actorSequencer.minimumRoutePointsHelp": "أضف نقطتي مسار على الأقل قبل المعاينة أو الحفظ.",
    "actorSequencer.seconds": "{value} ثانية", "actorSequencer.footerSummary": "{points} نقاط · {events} أحداث · {actor}",
    "stageLighting.backTo": "العودة إلى {target}", "stageLighting.rockstarEditorOutput": "إخراج محرر Rockstar",
    "stageLighting.persistentFreecamHelp": "استمر بالضغط على RMB واستخدم WASD / Q / E لفحص الضوء. اترك RMB لاستخدام الواجهة أو أداة التحريك.",
    "stageLighting.guidedSetup": "إعداد موجّه", "stageLighting.motionSummary": "الحركة والتوقيت",
    "stageLighting.fixtureTransformHelp": "وحدة الإضاءة كشاف اتجاهي مادي. ضعها عبر الكاميرا الحرة ثم اختر أن تبقى ثابتة أو تتبع الهدف.",
    "stageLighting.unavailableTargetChooseAnother": "الهدف غير متاح — اختر هدفًا آخر",
    "stageLighting.lightStaysAtWorldPosition": "يبقى الضوء في موضعه العالمي المضبوط.",
    "stageLighting.trackingResolvedDuringPlayback": "يتم حل تتبع {subject} أثناء التشغيل.",
    "stageLighting.keepBeamFocused": "إبقاء الشعاع مركزًا", "stageLighting.pitch": "الميل",
    "stageLighting.colorPresetHelp": "اختر أصل الإضاءة المدمجة الدقيق. لكل عينة لون وسطوع ثابتان يمكن لمحرر Rockstar الاحتفاظ بهما.",
    "stageLighting.embeddedAssetHelp": "اللون والسطوع والمدى والمخروط مدمجة في {model}. يظل التحويل والحركة قابلين للتحرير.",
    "stageLighting.embeddedInAsset": "مدمج في الأصل", "stageLighting.editableUpper": "قابل للتحرير",
    "stageLighting.chooseStartingBehavior": "اختر سلوك بدء واحدًا",
    "stageLighting.motionPresetsHelp": "تعيد إعدادات الحركة المسبقة ضبط الطبقات الإجرائية، فتنتج النتيجة نفسها دائمًا.",
    "stageLighting.motionPreset.pulse": "نبض تشغيل/إيقاف", "stageLighting.motionPreset.flicker": "تشغيل/إيقاف عشوائي",
    "stageLighting.physicalFixtureAnimationHelp": "يحرك الموضع والدوران وحدة الإضاءة المادية. يبدل النبض والوميض تشغيل الوحدة وإيقافها؛ ويظل سطوع الأصل المدمج ثابتًا.",
    "stageLighting.timing": "التوقيت", "stageLighting.playbackBehavior": "سلوك التشغيل",
    "stageLighting.repeatUntilClipEnds": "التكرار حتى نهاية المقطع", "stageLighting.layersCanBeCombined": "يمكن دمج الطبقات",
    "stageLighting.sinusoidalWorldOffset": "إزاحة جيبية في الحيز العالمي", "stageLighting.amplitudeMeters": "السعة · أمتار",
    "stageLighting.disableAimForSweep": "عطّل التصويب إلى الهدف لضبط المسح", "stageLighting.continuousOscillatingRotation": "دوران مستمر ومتذبذب",
    "stageLighting.speedDegreesPerSecond": "السرعة · درجات في الثانية", "stageLighting.roll": "التدحرج", "stageLighting.yaw": "الانحراف",
    "stageLighting.swayDegrees": "التأرجح · درجات", "stageLighting.binaryVisibilityHelp": "نبض تشغيل/إيقاف ثنائي أو ظهور عشوائي",
    "stageLighting.onOffPulse": "نبض تشغيل/إيقاف", "stageLighting.randomOnOff": "تشغيل/إيقاف عشوائي",
    "stageLighting.backShortcut": "ESC / Backspace · العودة إلى {target}",
    "spooner.categoryAnimals": "حيوانات", "spooner.categoryCiviliansFemale": "مدنيات", "spooner.categoryCiviliansMale": "مدنيون",
    "spooner.categoryGangs": "عصابات", "spooner.categoryCutscene": "مشهد سينمائي", "spooner.categoryServices": "خدمات",
    "spooner.categoryUnique": "فريدة", "spooner.categoryFurniture": "أثاث", "spooner.categoryDecoration": "زينة",
    "spooner.categoryMusic": "موسيقى", "spooner.categoryTrash": "نفايات", "spooner.categoryFood": "طعام",
    "spooner.categoryGames": "ألعاب", "spooner.categoryCompacts": "سيارات صغيرة", "spooner.categorySedans": "سيارات سيدان",
    "spooner.categorySuvs": "سيارات SUV", "spooner.categoryCoupes": "سيارات كوبيه", "spooner.categoryMuscle": "سيارات عضلية",
    "spooner.categorySportsClassics": "سيارات رياضية كلاسيكية", "spooner.categorySports": "سيارات رياضية",
    "spooner.categorySuper": "سيارات خارقة", "spooner.categoryMotorcycles": "دراجات نارية", "spooner.categoryOffRoad": "مركبات طرق وعرة",
    "spooner.categoryIndustrial": "مركبات صناعية", "spooner.categoryUtility": "مركبات خدمات", "spooner.categoryVans": "شاحنات صغيرة",
    "spooner.categoryCycles": "دراجات", "spooner.categoryBoats": "قوارب", "spooner.categoryHelicopters": "مروحيات",
    "spooner.categoryPlanes": "طائرات", "spooner.categoryService": "خدمة", "spooner.categoryEmergency": "طوارئ",
    "spooner.categoryMilitary": "عسكرية", "spooner.categoryCommercial": "تجارية", "spooner.categoryTrains": "قطارات",
    "spooner.categoryOpenWheel": "سيارات أحادية المقعد", "spooner.modelsCount": "{{count}} طراز",
    "spooner.spawnEngineOn": "تشغيل المحرك عند الإنشاء"
  };

  const protectedToken = /(\{\{[^}]+\}\}|\{[^{}]+\}|%s|\b(?:ESC|ENTER|BACKSPACE|TAB|SHIFT|CTRL|ALT|RMB|LMB|WASD|F\d+|WEAPON_[A-Z0-9_]+)\b)/g;
  const escapeRegExp = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const phraseEntries = Object.entries(phrases).sort((a, b) => b[0].length - a[0].length);
  const wordPattern = new RegExp("\\b(" + Object.keys(words).sort((a, b) => b.length - a.length).map(escapeRegExp).join("|") + ")\\b", "gi");

  function translateText(source) {
    if (typeof source !== "string" || !source) return source;
    const tokens = [];
    let result = source.replace(protectedToken, (token) => `\uE000${tokens.push(token) - 1}\uE001`);
    for (const [englishPhrase, arabicPhrase] of phraseEntries) {
      result = result.replace(new RegExp(escapeRegExp(englishPhrase), "gi"), arabicPhrase);
    }
    result = result.replace(wordPattern, (word) => {
      const key = word.toLowerCase();
      return Object.prototype.hasOwnProperty.call(words, key) ? words[key] : word;
    });
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
    if (typeof value === "string") strings[key] = namedOverrides[key] || translateText(value);
  }

  const staticText = {};
  for (const key of Object.keys(spanish.staticText || {})) staticText[key] = translateText(key);
  const optionLabels = {
    weapons: {
      __none: "لا شيء",
      WEAPON_PISTOL: "مسدس", WEAPON_COMBATPISTOL: "مسدس قتالي", WEAPON_APPISTOL: "مسدس AP",
      WEAPON_PISTOL50: "مسدس .50", WEAPON_SNSPISTOL: "مسدس SNS", WEAPON_HEAVYPISTOL: "مسدس ثقيل",
      WEAPON_REVOLVER: "مسدس دوار", WEAPON_MICROSMG: "رشاش صغير", WEAPON_SMG: "رشاش SMG",
      WEAPON_ASSAULTSMG: "رشاش SMG هجومي", WEAPON_COMBATPDW: "سلاح PDW قتالي",
      WEAPON_MACHINEPISTOL: "مسدس رشاش", WEAPON_MINISMG: "رشاش صغير", WEAPON_ASSAULTRIFLE: "بندقية هجومية",
      WEAPON_CARBINERIFLE: "بندقية كاربين", WEAPON_ADVANCEDRIFLE: "بندقية متقدمة",
      WEAPON_SPECIALCARBINE: "كاربين خاص", WEAPON_BULLPUPRIFLE: "بندقية Bullpup",
      WEAPON_COMPACTRIFLE: "بندقية مدمجة", WEAPON_MG: "رشاش", WEAPON_COMBATMG: "رشاش قتالي",
      WEAPON_PUMPSHOTGUN: "بندقية ضخ", WEAPON_SAWNOFFSHOTGUN: "بندقية صيد قصيرة",
      WEAPON_ASSAULTSHOTGUN: "بندقية صيد هجومية", WEAPON_HEAVYSHOTGUN: "بندقية صيد ثقيلة",
      WEAPON_SNIPERRIFLE: "بندقية قنص", WEAPON_HEAVYSNIPER: "بندقية قنص ثقيلة",
      WEAPON_MARKSMANRIFLE: "بندقية رماية", WEAPON_RPG: "قاذف صواريخ", WEAPON_GRENADELAUNCHER: "قاذف قنابل",
      WEAPON_MINIGUN: "رشاش دوار", WEAPON_KNIFE: "سكين", WEAPON_BAT: "مضرب", WEAPON_CROWBAR: "عتلة",
      WEAPON_GOLFCLUB: "مضرب غولف", WEAPON_NIGHTSTICK: "هراوة شرطة", WEAPON_MACHETE: "ساطور",
      WEAPON_SWITCHBLADE: "سكين مطوي", WEAPON_HATCHET: "فأس صغيرة", WEAPON_FLASHLIGHT: "مصباح يدوي",
      WEAPON_STUNGUN: "مسدس صاعق", WEAPON_FIREEXTINGUISHER: "طفاية حريق",
      WEAPON_PETROLCAN: "عبوة وقود", WEAPON_BOTTLE: "زجاجة"
    },
    peds: {
      mp_m_freemode_01: "Freemode ذكر", mp_f_freemode_01: "Freemode أنثى",
      player_one: "Michael", player_two: "Franklin", player_zero: "Trevor",
      a_m_y_genstreet_02: "رجل شارع", a_m_y_hipster_01: "هيبستر", a_m_y_business_03: "رجل أعمال",
      a_f_y_business_01: "سيدة أعمال", a_f_y_beach_01: "سيدة شاطئ", a_m_y_skater_01: "متزلج",
      a_m_y_tourist_01: "سائح", s_m_y_cop_01: "ضابط شرطة", s_f_y_cop_01: "ضابطة شرطة",
      s_m_y_swat_01: "قوات SWAT", s_m_m_marine_01: "جندي مشاة بحرية", s_m_m_paramedic_01: "مسعف",
      s_m_y_fireman_01: "رجل إطفاء", s_m_m_security_01: "حارس أمن", g_m_y_ballaorig_01: "Ballas",
      g_m_y_mexgoon_01: "Vagos", g_m_y_lost_01: "Lost MC", a_c_rottweiler: "روت وايلر",
      a_c_husky: "هاسكي", a_c_shepherd: "راعي ألماني"
    },
    policeVehicles: {
      police: "دورية شرطة", police2: "دورية شرطة 2", police3: "دورية شرطة 3",
      police4: "Buffalo شرطة غير مميزة", policet: "شاحنة شرطة", fbi: "سيدان FIB",
      fbi2: "سيارة SUV تابعة لـ FIB", sheriff: "دورية الشريف", sheriff2: "سيارة SUV للشريف",
      __custom__: "رمز طراز مخصص..."
    },
    weatherTypes: {
      EXTRASUNNY: "مشمس جدًا", CLEAR: "صافٍ", CLOUDS: "غائم", OVERCAST: "ملبد بالغيوم",
      CLEARING: "انقشاع", RAIN: "مطر", THUNDER: "عاصفة رعدية", SMOG: "ضباب دخاني",
      FOGGY: "ضباب", NEUTRAL: "محايد", SNOW: "ثلج", SNOWLIGHT: "ثلج خفيف",
      BLIZZARD: "عاصفة ثلجية", XMAS: "عيد الميلاد"
    }
  };

  Object.assign(strings, {
    "cutscenePlayer.allBadge": "الكل",
    "cutscenePlayer.allCutscenes": "كل المشاهد السينمائية",
    "cutscenePlayer.newBadge": "جديد",
    "cutscenePlayer.newCutscenes": "المشاهد السينمائية الجديدة",
    "cutscenePlayer.noNewCutscenes": "لم يتم العثور على مشاهد سينمائية جديدة"
  });

  Object.assign(strings, {
  "cameraTargeting.unavailable": "لا يوجد هدف متاح. حدّث القائمة أو اختر مشهدًا نشطًا.",
  "cameraTargeting.scope": "أولوية الأهداف",
    "cameraTargeting.sceneFirst": "المشهد / Timeline أولاً",
    "cameraTargeting.sceneOnly": "المشهد / Timeline فقط",
    "cameraTargeting.all": "كل الكيانات القريبة",
    "cameraTargeting.look": "هدف النظر",
    "cameraTargeting.independent": "النظر يتحكم بالدوران والارتباط يتحكم بالموقع. يمكن استخدام هدف مختلف لكل منهما.",
    "cameraTargeting.rightMouse": "زر الفأرة الأيمن",
    "cameraTargeting.free": "حر — تدوير الكاميرا",
    "cameraTargeting.click": "نقرة — تثبيت / تحرير",
    "cameraTargeting.hold": "ضغط مستمر — متابعة حتى الإفلات",
    "cameraTargeting.choose": "اختر هدف النظر…",
    "cameraTargeting.previous": "السابق",
    "cameraTargeting.next": "التالي",
    "cameraTargeting.release": "تحرير",
    "cameraTargeting.none": "لا يوجد هدف للنظر",
    "cameraTargeting.waiting": "بانتظار ظهور هدف المشهد مجددًا",
    "cameraTargeting.help": "أخفِ اللوحة باستخدام H. يربط LMB الكاميرا ويختار RMB هدف النظر. يدير Alt + RMB الكاميرا يدويًا ويفعّل N النظر الحر. يبدّل B/V الأهداف دون تغيير الارتباط.",
    "cameraTargeting.focusMode": "تركيز العدسة",
    "cameraTargeting.manualFocus": "مسافة يدوية",
    "cameraTargeting.centerFocus": "تركيز تلقائي — وسط الشاشة",
    "cameraTargeting.targetFocus": "تتبع التركيز — هدف النظر",
    "cameraTargeting.focusHelp": "فعّل عمق المجال أولاً. يتبع التركيز هدف النظر ثم هدف الارتباط أو G. يغيّر الحدة وليس اتجاه الكاميرا."
  });

  Object.assign(strings, {
    "cameraDrone.banking": "ميل الدرون",
    "cameraDrone.bankingHelp": "أقصى ميل عند الدوران: 0° يسوّي الأفق، و15° هو الوضع العادي، و45° ميل واضح. لا تتغير السرعة أو القصور الذاتي."
  });

  Object.assign(strings, {
    "cameraTargeting.lookSpeed": "سرعة توجيه النظر",
    "cameraTargeting.lookSpeedHelp": "1–100%: القيم المنخفضة تدير الكاميرا ببطء والعالية توجهها بسرعة. ينطبق على RMB وB/V وأهداف اللوحة وG، بما في ذلك التتبع. القيم المنخفضة جداً تتأخر عن الأهداف السريعة. لا يتغير الدوران اليدوي أو ميل الدرون."
  });

  Object.assign(strings, {
    "cameraZoom.speed": "سرعة التكبير",
    "cameraZoom.help": "أخفِ اللوحة بمفتاح H، ثم اضغط مطولاً على Z للتقريب أو C للإبعاد. 1–200%: الأقل أبطأ؛ 100% عادي؛ 200% ضعف السرعة. يغير مجال الرؤية FOV وليس الموضع. لا يغير إعدادات العدسة المسبقة أو تشغيل التكبير المسجل."
  });

  window.SD_I18N.registerLocale("ar", {
    shortLabel: "AR",
    languageName: "العربية",
    direction: "rtl",
    strings: strings,
    staticText: staticText,
    optionLabels: optionLabels
  });
})();
