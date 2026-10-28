(function registerBrazilianPortugueseLocale() {
  "use strict";

  const packs = window.SD_LANG_PACKS || {};
  const english = packs.en || {};
  const spanish = packs.es || {};

  // Frases completas têm prioridade para manter a interface natural. O
  // dicionário de palavras abaixo completa a cobertura dos textos legados.
  const phrases = {
    "Custom Scene": "Cena personalizada",
    "Custom Scenes": "Cenas personalizadas",
    "Actor Sequencer": "Sequenciador de atores",
    "Actor Sequence": "Sequência de ator",
    "Door Director": "Diretor de portas",
    "Stage Lighting": "Iluminação de palco",
    "Rockstar Editor": "Editor Rockstar",
    "Object Motion": "Movimento de objeto",
    "Object Spooner": "Editor de objetos",
    "Ped Replay": "Replay de ped",
    "Vehicle Replay": "Replay de veículo",
    "Chase Replay": "Replay de perseguição",
    "Camera Sequence": "Sequência de câmera",
    "Free camera": "Câmera livre",
    "Freecam": "Câmera livre",
    "World position": "Posição no mundo",
    "Current player": "Jogador atual",
    "Saved ped": "Ped salvo",
    "Saved vehicle": "Veículo salvo",
    "Fixed world position": "Posição fixa no mundo",
    "Current Scene": "Cena atual",
    "Timeline playback": "Reprodução da linha do tempo",
    "depth of field": "profundidade de campo",
    "field of view": "campo de visão",
    "line of sight": "linha de visão",
    "keyframes": "quadros-chave",
    "keyframe": "quadro-chave",
    "route points": "pontos da rota",
    "route point": "ponto da rota",
    "walkable surface": "superfície transitável",
    "scene actor": "ator da cena",
    "spawned NPC": "NPC criado",
    "Facial expression": "Expressão facial",
    "Follow route": "Seguir rota",
    "Follow actor": "Seguir ator",
    "Walk to point": "Caminhar até o ponto",
    "Drive to point": "Dirigir até o ponto",
    "Look at point": "Olhar para o ponto",
    "Aim at point": "Mirar no ponto",
    "Shoot at point": "Atirar no ponto",
    "Play animation": "Reproduzir animação",
    "Play scenario": "Executar cenário",
    "Equip weapon": "Equipar arma",
    "Enter vehicle": "Entrar no veículo",
    "Leave vehicle": "Sair do veículo",
    "not available": "não disponível",
    "no longer available": "não está mais disponível",
    "no longer exists": "não existe mais",
    "could not be": "não pôde ser",
    "Could not": "Não foi possível",
    "could not": "não foi possível",
    "before saving": "antes de salvar",
    "while the editor was opening": "enquanto o editor era aberto",
    "Try again": "Tente novamente",
    "Choose a": "Escolha um",
    "Choose an": "Escolha um",
    "Select a": "Selecione um",
    "Select an": "Selecione um",
    "Click to": "Clique para",
    "Press ESC": "Pressione ESC",
    "Press ENTER": "Pressione ENTER",
    "Back to": "Voltar para",
    "Add to Timeline": "Adicionar à linha do tempo",
    "Add to timeline": "Adicionar à linha do tempo",
    "Add to scene": "Adicionar à cena",
    "Add to Scene": "Adicionar à cena",
    "Save changes": "Salvar alterações",
    "Save Changes": "Salvar alterações",
    "Save as default": "Salvar como padrão",
    "Start preview": "Iniciar pré-visualização",
    "Stop preview": "Parar pré-visualização",
    "Preview paused": "Pré-visualização pausada",
    "PREVIEW PAUSED": "PRÉ-VISUALIZAÇÃO PAUSADA",
    "NEEDS ATTENTION": "REQUER ATENÇÃO",
    "No options available.": "Nenhuma opção disponível.",
    "No results": "Nenhum resultado",
    "Search scenes": "Buscar cenas",
    "Search animations": "Buscar animações",
    "Search saved": "Buscar itens salvos",
    "English": "Inglês",
    "Environ.": "Ambiente",
    "Clubs": "Clubes",
    "Thanks": "Obrigado",
    "My Peds": "Meus peds",
    "Entries": "Entradas",
    "Test": "Testar",
    "Upper": "Parte superior",
    "Activated": "Ativado",
    "Deactivated": "Desativado",
    "men": "homens",
    "Generating...": "Gerando...",
    "Parts": "Peças",
    "Cosmetics": "Estética",
    "Wheels": "Rodas",
    "Colors": "Cores",
    "Body": "Carroceria",
    "Paint": "Pintura",
    "Condition": "Condição",
    "Understood": "Entendi",
    "Clear": "Limpar",
    "Disable": "Desativar",
    "Discard": "Descartar",
    "Done": "Concluir",
    "Enable": "Ativar",
    "Fixed": "Fixo",
    "Off": "Desligado",
    "Refresh": "Atualizar",
    "Replace": "Substituir",
    "Retry": "Tentar novamente",
    "Starting": "Iniciando",
    "Undo": "Desfazer",
    "Redo": "Refazer",
    "Recover": "Recuperar",
    "entry": "entrada",
    "entries": "entradas",
    "Precision": "Precisão",
    "Grid snap": "Ajuste à grade",
    "Exit Spooner": "Sair do editor de objetos",
    "PACING": "RITMO",
    "Per segment": "Por segmento",
    "Distribute": "Distribuir",
    "Free look": "Visão livre",
    "Ped anchor": "Âncora do ped",
    "Entity root": "Raiz da entidade",
    "Body part": "Parte do corpo",
    "Rigid mount": "Montagem rígida",
    "Auto orbit": "Órbita automática",
    "Zoom response": "Resposta do zoom",
    "Manual FOV": "FOV manual",
    "Cinematic bars": "Barras cinematográficas",
    "Rule of thirds": "Regra dos terços",
    "Center cross": "Cruz central",
    "Safe area": "Área segura",
    "Info overlay": "Sobreposição de informações",
    "Level horizon": "Nivelar horizonte",
    "Photo": "Foto",
    "Video": "Vídeo",
    "Zoom out": "Afastar",
    "Clear attachment": "Remover anexo",
    "Spawn as NPC": "Criar como NPC",
    "Max upgrade": "Melhoria máxima",
    "Randomize": "Aleatorizar",
    "Discard changes": "Descartar alterações",
    "Indexed": "Indexada",
    "Number Plate": "Placa",
    "Xenon Headlights": "Faróis de xenônio",
    "Neon Colour": "Cor do neon",
    "Classic Livery": "Estampa clássica",
    "Roof Livery": "Estampa do teto",
    "Broken Glass": "Vidros quebrados",
    "Tyres": "Pneus",
    "Convertible Roof": "Teto conversível",
    "Favs": "Favoritos",
    "Anims": "Animações",
    "Anims+": "Animações+",
    "Flags": "Opções",
    "Playhead": "Cursor de reprodução",
    "Snap": "Ajuste",
    "Stock": "Original",
    "Livery": "Estampa",
    "Open & close": "Abrir e fechar",
    "Unlock & open": "Destravar e abrir",
    "Close & lock": "Fechar e travar",
    "input focus": "foco de entrada",
    "recording candidate": "candidato à gravação",
    "embedded-light fixture": "luminária integrada",
    "directional Spot lights": "spots direcionais",
    "directional spotlight": "spot direcional",
    "point light": "luz pontual"
  };

  const words = {
    language: "idioma", scale: "escala", favorite: "favorito", favorites: "favoritos",
    scene: "cena", scenes: "cenas", animation: "animação", animations: "animações",
    actor: "ator", actors: "atores", player: "jogador", players: "jogadores",
    ped: "ped", peds: "peds", npc: "NPC", vehicle: "veículo", vehicles: "veículos",
    object: "objeto", objects: "objetos", prop: "objeto", props: "objetos",
    camera: "câmera", cameras: "câmeras", light: "luz", lights: "luzes", lighting: "iluminação",
    fixture: "luminária", fixtures: "luminárias", timeline: "linha do tempo", track: "faixa", tracks: "faixas",
    clip: "clipe", clips: "clipes", replay: "replay", replays: "replays",
    route: "rota", routes: "rotas", point: "ponto", points: "pontos",
    waypoint: "ponto de rota", waypoints: "pontos de rota", door: "porta", doors: "portas",
    environment: "ambiente", environments: "ambientes", effect: "efeito", effects: "efeitos",
    weather: "clima", time: "tempo", density: "densidade", crowd: "multidão", chase: "perseguição", club: "clube",
    search: "buscar", filter: "filtro", select: "selecionar", choose: "escolher", selected: "selecionado",
    add: "adicionar", remove: "remover", delete: "excluir", duplicate: "duplicar", copy: "copiar", paste: "colar",
    rename: "renomear", edit: "editar", update: "atualizar", save: "salvar", saved: "salvo",
    saving: "salvando", load: "carregar", loaded: "carregado", loading: "carregando", create: "criar", created: "criado",
    open: "abrir", close: "fechar", closed: "fechado", cancel: "cancelar", confirm: "confirmar", apply: "aplicar",
    reset: "redefinir", start: "iniciar", stop: "parar", pause: "pausar", resume: "retomar", play: "reproduzir",
    preview: "pré-visualização", record: "gravar", recording: "gravação", capture: "capturar", place: "posicionar",
    placement: "posicionamento", position: "posição", rotation: "rotação", direction: "direção", movement: "movimento",
    motion: "movimento", speed: "velocidade", duration: "duração", distance: "distância",
    height: "altura", width: "largura", angle: "ângulo", radius: "raio", intensity: "intensidade",
    brightness: "brilho", color: "cor", colours: "cores", red: "vermelho", green: "verde",
    blue: "azul", white: "branco", black: "preto", left: "esquerda", right: "direita", front: "frente",
    back: "voltar", forward: "avançar", up: "cima", down: "baixo", side: "lado", world: "mundo", local: "local",
    current: "atual", custom: "personalizado", default: "padrão", advanced: "avançado", basic: "básico",
    exact: "exato", optional: "opcional", required: "obrigatório", enabled: "ativado", disabled: "desativado",
    available: "disponível", unavailable: "indisponível", active: "ativo", inactive: "inativo",
    visible: "visível", hidden: "oculto", show: "mostrar", hide: "ocultar", lock: "travar", locked: "travado",
    unlock: "destravar", unlocked: "destravado", attach: "anexar", attached: "anexado", detach: "desanexar",
    follow: "seguir", aim: "mirar", shoot: "atirar", walk: "caminhar", run: "correr", wait: "aguardar",
    enter: "entrar", leave: "sair", drive: "dirigir", fight: "lutar", weapon: "arma", weapons: "armas",
    unarmed: "desarmado", ammo: "munição", action: "ação", actions: "ações",
    event: "evento", events: "eventos", mode: "modo", type: "tipo", name: "nome", model: "modelo",
    category: "categoria", folder: "pasta", folders: "pastas", preset: "predefinição", presets: "predefinições",
    option: "opção", options: "opções", setting: "configuração", settings: "configurações",
    status: "status", state: "estado", value: "valor", amount: "quantidade",
    smooth: "suave", linear: "linear", natural: "natural", fast: "rápido", slow: "lento", normal: "normal",
    soft: "suave", manual: "manual", automatic: "automático", loop: "repetição", once: "uma vez", repeat: "repetir",
    continuous: "contínuo", working: "processando", checking: "verificando", preparing: "preparando", ready: "pronto",
    complete: "concluído", incomplete: "incompleto", error: "erro", errors: "erros", warning: "aviso",
    warnings: "avisos", failed: "falhou", invalid: "inválido", missing: "ausente", empty: "vazio",
    unknown: "desconhecido", untitled: "sem título", before: "antes", after: "depois", during: "durante",
    while: "enquanto", first: "primeiro", next: "próximo", previous: "anterior", finish: "concluir", continue: "continuar",
    help: "ajuda", information: "informação", description: "descrição", summary: "resumo", click: "clique",
    press: "pressione", hold: "segure", drag: "arraste", move: "mover", rotate: "girar", adjust: "ajustar",
    change: "alterar", use: "usar", uses: "usa", increase: "aumentar", decrease: "diminuir",
    yes: "sim", no: "não", none: "nenhum", all: "todos", only: "somente", and: "e", or: "ou",
    with: "com", without: "sem", from: "de", to: "para", at: "em", in: "em", on: "ativado", for: "para",
    is: "é", are: "são", was: "foi", were: "foram", the: "o", a: "um", an: "um", this: "este", that: "esse",
    these: "estes", your: "seu", its: "seu", now: "agora", again: "novamente", yet: "ainda",
    still: "ainda", successfully: "com sucesso", new: "novo", recent: "recente", recenty: "recentemente",
    source: "origem", target: "alvo", origin: "origem", inspector: "inspetor", project: "projeto",
    library: "biblioteca", collection: "coleção", collections: "coleções", layer: "camada", layers: "camadas",
    frame: "quadro", frames: "quadros", key: "chave", keys: "chaves", marker: "marcador", markers: "marcadores",
    zoom: "zoom", sensitivity: "sensibilidade", smoothing: "suavização", lens: "lente", image: "imagem",
    focus: "foco", autofocus: "foco automático", shake: "tremor", strength: "intensidade", guide: "guia", guides: "guias",
    playback: "reprodução", diagnostics: "diagnóstico", diagnostic: "diagnóstico", path: "trajeto", curve: "curva",
    curves: "curvas", easing: "suavização", transition: "transição", transitions: "transições",
    delay: "atraso", countdown: "contagem regressiva", seconds: "segundos", second: "segundo",
    cast: "elenco", performance: "desempenho", review: "revisão", sequence: "sequência",
    formation: "formação", spacing: "espaçamento", quantity: "quantidade", facing: "orientação",
    heading: "direção", pitch: "inclinação", roll: "rolagem", yaw: "guinada", range: "alcance",
    frequency: "frequência", phase: "fase", amplitude: "amplitude", pattern: "padrão", seed: "semente",
    physics: "física", collision: "colisão", health: "integridade", damage: "dano", repair: "reparar",
    driver: "motorista", passenger: "passageiro", passengers: "passageiros", occupants: "ocupantes", seat: "assento",
    police: "polícia", siren: "sirene", helicopter: "helicóptero", aggressive: "agressivo", defensive: "defensivo",
    random: "aleatório", specific: "específico", nearby: "próximo", ground: "solo", fly: "voar"
  };

  const optionPhrases = {
    "Ninguna": "Nenhuma", "Pistola": "Pistola", "Pistola de combate": "Pistola de combate",
    "Pistola AP": "Pistola AP", "Pistola .50": "Pistola .50", "Pistola SNS": "Pistola SNS",
    "Pistola pesada": "Pistola pesada", "Revolver": "Revólver", "Micro SMG": "Micro SMG",
    "SMG": "SMG", "SMG de asalto": "SMG de assalto", "PDW de combate": "PDW de combate",
    "Pistola ametralladora": "Pistola-metralhadora", "Mini SMG": "Mini SMG",
    "Rifle de asalto": "Fuzil de assalto", "Carabina": "Carabina", "Rifle avanzado": "Fuzil avançado",
    "Carabina especial": "Carabina especial", "Rifle bullpup": "Fuzil bullpup", "Rifle compacto": "Fuzil compacto",
    "MG": "Metralhadora", "MG de combate": "Metralhadora de combate", "Escopeta de bombeo": "Escopeta de ação deslizante",
    "Recortada": "Escopeta de cano serrado", "Escopeta de asalto": "Escopeta de assalto",
    "Escopeta pesada": "Escopeta pesada", "Rifle de francotirador": "Rifle de precisão",
    "Francotirador pesado": "Rifle de precisão pesado", "Rifle de tirador": "Rifle de atirador",
    "RPG": "Lança-foguetes", "Lanzagranadas": "Lança-granadas", "Lanzacohetes": "Lança-foguetes",
    "Lanzacohetes guiado": "Lança-foguetes teleguiado", "Minigun": "Minigun", "Granada": "Granada",
    "Granada de humo": "Granada de fumaça", "Gas lacrimógeno": "Gás lacrimogêneo",
    "Cóctel molotov": "Coquetel molotov", "Cuchillo": "Faca", "Porra": "Cassetete",
    "Martillo": "Martelo", "Bate": "Taco de beisebol", "Palanca": "Pé de cabra",
    "Palo de golf": "Taco de golfe", "Hacha": "Machado", "Puño americano": "Soco-inglês",
    "Baston": "Cassetete", "Machete": "Facão", "Navaja": "Canivete", "Linterna": "Lanterna",
    "Taser": "Arma de choque", "Extintor": "Extintor", "Bidón de gasolina": "Galão de gasolina",
    "Bidon de gasolina": "Galão de gasolina", "Botella": "Garrafa",
    "Freemode masculino": "Freemode masculino", "Freemode femenino": "Freemode feminino",
    "Chico de calle": "Jovem de rua", "Hipster": "Hipster", "Hombre de negocios": "Empresário",
    "Mujer de negocios": "Empresária", "Mujer de playa": "Mulher da praia", "Skater": "Skatista",
    "Turista": "Turista", "Policia hombre": "Policial", "Policia mujer": "Policial feminina",
    "SWAT": "SWAT", "Marine": "Fuzileiro", "Paramedico": "Paramédico", "Bombero": "Bombeiro",
    "Seguridad": "Segurança", "Ballas": "Ballas", "Vagos": "Vagos", "Lost MC": "Lost MC",
    "Rottweiler": "Rottweiler", "Husky": "Husky", "Pastor aleman": "Pastor-alemão",
    "Patrulla": "Viatura", "Patrulla 2": "Viatura 2", "Patrulla 3": "Viatura 3",
    "Buffalo policial": "Buffalo policial", "Moto policial": "Moto policial", "Furgón policial": "Van policial",
    "Transporte policial": "Transporte policial", "Riot policial": "Blindado antimotim",
    "Sedan FBI": "Sedã do FIB", "SUV FBI": "SUV do FIB", "Patrulla sheriff": "Viatura do xerife",
    "SUV sheriff": "SUV do xerife", "Codigo personalizado...": "Código personalizado...",
    "Extra soleado": "Ensolarado", "Despejado": "Céu limpo", "Nublado": "Nublado", "Nubes": "Nuvens",
    "Con smog": "Com poluição", "Niebla": "Neblina", "Cubierto": "Encoberto", "Lluvia": "Chuva",
    "Tormenta": "Tempestade", "Despeje": "Abrindo", "Neutral": "Neutro", "Nieve": "Neve",
    "Ventisca": "Nevasca", "Nieve ligera": "Neve leve", "Aclarando": "Clareando",
    "Smog": "Poluição", "Navidad": "Natal"
  };

  const protectedToken = /(\{\{[^}]+\}\}|\{[^{}]+\}|%[sdif]|<\/?[A-Za-z][^>]*>|https?:\/\/[^\s]+|\b(?:ESC|ENTER|RETURN|BACKSPACE|DELETE|TAB|SHIFT|CTRL|ALT|RMB|LMB|WASD|WHEEL|F\d+|FOV|DOF|RGB|FPS|UID|NPCs?|GTA|FiveM|Lua|SQL|NUI|API|HUD|REC|IN|OUT|WEAPON_[A-Z0-9_]+)\b|\b(?:W|A|S|D|Q|E|Z|C|X|Y)\b|\b[A-Za-z0-9]+(?:_[A-Za-z0-9]+)+\b)/g;
  const escapeRegExp = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const phraseEntries = Object.entries(phrases).sort((left, right) => right[0].length - left[0].length);
  const wordKeys = Object.keys(words).sort((left, right) => right.length - left.length).map(escapeRegExp).join("|");
  const wordPattern = new RegExp(`(^|[^A-Za-zÀ-ÖØ-öø-ÿ0-9_])(${wordKeys})(?=$|[^A-Za-zÀ-ÖØ-öø-ÿ0-9_])`, "gi");

  function matchCase(source, translated) {
    if (source === source.toUpperCase() && source !== source.toLowerCase()) return translated.toLocaleUpperCase("pt-BR");
    if (/^[A-ZÀ-ÖØ-Þ]/.test(source)) return translated.charAt(0).toLocaleUpperCase("pt-BR") + translated.slice(1);
    return translated;
  }

  function polishPortuguese(value) {
    return value
      .replace(/\bde o\b/gi, "do")
      .replace(/\bde a\b/gi, "da")
      .replace(/\bde os\b/gi, "dos")
      .replace(/\bde as\b/gi, "das")
      .replace(/\bem o\b/gi, "no")
      .replace(/\bem a\b/gi, "na")
      .replace(/\bpara o\b/gi, "para o")
      .replace(/\s{2,}/g, " ")
      .replace(/\s+([,.:;!?])/g, "$1")
      .trim();
  }

  function translateText(source) {
    if (typeof source !== "string" || !source) return source;
    if (Object.prototype.hasOwnProperty.call(phrases, source)) return phrases[source];
    const protectedTokens = [];
    const phraseTokens = [];
    let result = source.replace(protectedToken, (token) => `\uE000${protectedTokens.push(token) - 1}\uE001`);
    for (const [sourcePhrase, portuguesePhrase] of phraseEntries) {
      result = result.replace(new RegExp(escapeRegExp(sourcePhrase), "gi"), (match) => {
        const translated = matchCase(match, portuguesePhrase);
        return `\uE002${phraseTokens.push(translated) - 1}\uE003`;
      });
    }
    result = result.replace(wordPattern, (_match, prefix, word) => {
      const translated = words[word.toLocaleLowerCase("en-US")] || word;
      return prefix + matchCase(word, translated);
    });
    result = polishPortuguese(result);
    result = result.replace(/\uE002(\d+)\uE003/g, (_match, index) => phraseTokens[Number(index)] || "");
    return result.replace(/\uE000(\d+)\uE001/g, (_match, index) => protectedTokens[Number(index)] || "");
  }

  function translateOptionTree(source) {
    if (!source || typeof source !== "object") return source;
    const result = {};
    for (const [key, value] of Object.entries(source)) {
      result[key] = value && typeof value === "object"
        ? translateOptionTree(value)
        : (optionPhrases[String(value)] || translateText(String(value)));
    }
    return result;
  }

  const strings = {};
  for (const [key, value] of Object.entries(english)) {
    if (["shortLabel", "languageName", "direction", "staticText", "optionLabels"].includes(key)) continue;
    if (typeof value === "string") strings[key] = translateText(value);
  }

  // Traduções revisadas para controles compactos e áreas de criação mais usadas.
  Object.assign(strings, {
    language: "Idioma", uiScale: "Escala da interface", railFavs: "Favoritos", railCustomScenes: "Cenas+",
    railAnims: "Animações", railCustomAnims: "Animações+", railPeds: "Peds", railWeather: "Clima",
    railEnvironment: "Ambiente", railDensity: "Densidade", railEffects: "Efeitos", railChase: "Perseguição",
    railClubs: "Clubes", railSpooner: "Editor de objetos", paletteSearch: "Buscar ferramentas...",
    paletteGoTo: "Ir para", listTruncated: "Exibindo apenas os primeiros resultados — refine sua busca para ver mais",
    welcomeTitle: "Bem-vindo ao Spectrem Director",
    welcomeThanks: "Obrigado por comprar esta versão do script — seu apoio significa muito e realmente me ajuda como desenvolvedor",
    welcomeBeta: "Esta ainda é uma versão beta, portanto alguns recursos ou animações podem não funcionar corretamente ou podem apresentar um comportamento inesperado",
    welcomeButton: "Obrigado",
    crowdPlacement: "Posicionamento da multidão", placementMode: "Modo de posicionamento",
    placementCrowdHint: "Mova a pré-visualização da multidão e confirme ou cancele.",
    placementHint: "Ajuste o posicionamento e depois trave-o. ENTER e BACKSPACE continuam funcionando.",
    recTooltip: "Gravar clipe de gameplay (alternar)", scenes: "Cenas", searchScenes: "Buscar cenas...",
    nowPlaying: "Em reprodução", normalAnimation: "Animação normal", stop: "Parar", scenesFav: "Cenas favoritas",
    myPeds: "Meus peds", myVehicles: "Meus veículos", animations: "Animações", policeChase: "Perseguição policial",
    density: "Densidade", weatherTime: "Clima e hora", customScenesPreview: "Cenas personalizadas",
    loadingScenes: "Carregando cenas...", noScenesFound: "Nenhuma cena encontrada", back: "Voltar",
    customScenesEditorSave: "Salvar", customScenesEditorEntries: "Entradas",
    customScenesNoEntries: "Ainda não há entradas. Adicione animações ou cenas abaixo.",
    customScenesSolo: "Solo", customScenesScene: "Cena", customScenesDelay: "Atraso:",
    customScenesCustom: "Personalizado", addSoloAnimation: "Adicionar animação solo", addScene: "Adicionar cena",
    playback: "Reprodução", test: "Testar", stopTest: "Parar teste", action: "Ação!",
    stopSave: "Parar e salvar", countdown: "Contagem regressiva:", seconds: "segundos",
    newCustomScene: "Nova cena personalizada", noCustomScenes: "Ainda não há cenas personalizadas",
    addEntryToCustomScene: "Adicionar entrada à cena personalizada", soloAnimation: "Animação solo",
    searchAnimations: "Buscar animações...", searchScenesInModal: "Buscar cenas...",
    showFavoritesOnly: "Mostrar apenas favoritos", noAnimationsFound: "Nenhuma animação encontrada",
    noFavoriteAnimations: "Nenhuma animação favorita", loading: "Carregando...", flags: "Opções",
    normal: "Normal", loop: "Repetição", upper: "Parte superior", upLoop: "Parte superior em repetição",
    pedModel: "Modelo do ped", customModelCode: "Código de modelo personalizado", weapon: "Arma",
    startDelaySeconds: "Atraso inicial (segundos)", cancel: "Cancelar", place: "Posicionar",
    noScenesFoundModal: "Nenhuma cena encontrada", actor: "Ator", untitledScene: "Cena sem título",
    sceneSavedSuccessfully: "Cena salva com sucesso", failedToSaveScene: "Não foi possível salvar a cena",
    pressEscToClose: "Pressione ESC para fechar", pressF5ToToggle: "/director para abrir ou fechar", environment: "Ambiente",
    activated: "Ativado", deactivated: "Desativado", npcsInScene: "NPCs na cena", menOnly: "Somente homens",
    womenOnly: "Somente mulheres", men: "homens", generating: "Gerando...",
    regenerateEnvironment: "Gerar ambiente novamente", previewEnvironment: "Pré-visualizar ambiente",
    performance: "Desempenho", parts: "Peças", cosmetics: "Estética", wheels: "Rodas", colors: "Cores",
    neon: "Neon e luzes", body: "Carroceria", interior: "Interior", paint: "Pintura", lights: "Luzes",
    livery: "Estampa", condition: "Condição", pedReplayDisclaimerTitle: "Aviso de desenvolvimento",
    pedReplayDisclaimerBody: "O Replay de ped grava somente as ações do ped ativo do jogador; NPCs próximos não são capturados. Esta ferramenta ainda está em desenvolvimento, então algumas ações podem não ser reproduzidas com exatidão.",
    understood: "Entendi",

    "common.clear": "Limpar", "common.disable": "Desativar", "common.discard": "Descartar",
    "common.done": "Concluir", "common.enable": "Ativar", "common.fixed": "Fixo", "common.off": "Desligado",
    "common.refresh": "Atualizar", "common.replace": "Substituir", "common.retry": "Tentar novamente",
    "common.starting": "Iniciando", "common.test": "Testar", "common.undo": "Desfazer",
    "common.redo": "Refazer", "common.frequency": "Frequência", "common.phase": "Fase",
    "common.target": "Alvo", "common.seconds": "segundos",
    "director.integrityMessage": "Foram detectadas inconsistências nos dados do Spectrem Director. Reinicie o servidor.",
    "director.clubs": "Clubes", "startup.recover": "Recuperar", "startup.entry": "entrada", "startup.entries": "entradas",

    "gizmo.ground": "Solo", "gizmo.fly": "Voar", "gizmo.focusTarget": "Focar no alvo",
    "gizmo.precision": "Precisão", "gizmo.gridSnap": "Ajuste à grade", "gizmo.exitSpooner": "Sair do editor de objetos",

    "camera.replaceRecording": "GRAVAR: Substituir", "camera.easing": "SUAVIZAÇÃO", "camera.path": "TRAJETO",
    "camera.pacing": "RITMO", "camera.perSegment": "Por segmento", "camera.distribute": "Distribuir",
    "camera.freeLook": "Visão livre", "camera.entityRoot": "Raiz da entidade", "camera.bodyPart": "Parte do corpo",
    "camera.targetPointer": "Ponteiro do alvo", "camera.rigidMount": "Montagem rígida", "camera.autoOrbit": "Órbita automática",
    "camera.sensitivity": "Sensibilidade", "camera.zoomResponse": "Resposta do zoom",
    "camera.mouseSmoothing": "Suavização do mouse", "camera.lens": "Lente", "camera.image": "Imagem",
    "camera.autofocus": "Foco automático", "camera.shakeStrength": "Intensidade do tremor",
    "camera.cinematicBars": "Barras cinematográficas", "camera.framingGuides": "Guias de enquadramento",
    "camera.ruleOfThirds": "Regra dos terços", "camera.centerCross": "Cruz central", "camera.safeArea": "Área segura",
    "camera.infoOverlay": "Sobreposição de informações", "camera.levelHorizon": "Nivelar horizonte",
    "camera.photo": "Foto", "camera.video": "Vídeo",
    "camera.pedAnchor": "Âncora do ped", "camera.manualFov": "FOV manual",

    "timeline.newProject": "Novo projeto", "timeline.inspector": "Inspetor", "timeline.playhead": "Cursor de reprodução",
    "timeline.marker": "Marcador", "timeline.snap": "Ajuste", "timeline.zoomOut": "Afastar",
    "customScenes.clearAttachment": "Remover anexo",

    "vehicles.driver": "Motorista", "vehicles.passenger": "Passageiro", "vehicles.occupants": "Ocupantes",
    "peds.title": "Meus peds",
    "peds.spawnNpc": "Criar como NPC", "mechanic.maxUpgrade": "Melhoria máxima", "mechanic.stock": "Original",
    "mechanic.randomize": "Aleatorizar", "mechanic.repair": "Reparar", "mechanic.discardChanges": "Descartar alterações",
    "mechanic.indexed": "Indexada", "mechanic.numberPlate": "Placa", "mechanic.xenonHeadlights": "Faróis de xenônio",
    "mechanic.neonColour": "Cor do neon", "mechanic.classicLivery": "Estampa clássica",
    "mechanic.roofLivery": "Estampa do teto", "mechanic.health": "Integridade", "mechanic.brokenGlass": "Vidros quebrados",
    "mechanic.tyres": "Pneus", "mechanic.convertibleRoof": "Teto conversível",

    "environment.formation": "Formação", "environment.quantity": "Quantidade", "environment.spacing": "Espaçamento",
    "environment.facingDirection": "Direção dos NPCs",
    "environment.facingHelp": "0° mantém a direção natural da formação. NPCs parados mantêm a direção escolhida; NPCs em movimento giram naturalmente ao caminhar.",

    "sceneTools.outliner": "Hierarquia", "sceneTools.attachments": "Anexos", "sceneTools.collections": "COLEÇÕES",
    "sceneTools.newCollectionPlaceholder": "Nova coleção…", "sceneTools.layers": "camadas",
    "sceneTools.viewStates": "Estados de visualização", "sceneTools.solo": "Solo", "sceneTools.selection": "SELEÇÃO",
    "sceneTools.stableUid": "UID estável", "sceneTools.attachmentRole": "Função do anexo",
    "sceneTools.notAttachable": "Não pode ser anexado", "sceneTools.collection": "Coleção",
    "sceneTools.validation": "VALIDAÇÃO", "sceneTools.new": "Novo", "sceneTools.attachmentDefinition": "CONFIGURAÇÃO DO ANEXO",
    "sceneTools.childEntity": "Entidade filha", "sceneTools.parentEntity": "Entidade principal",
    "sceneTools.pitch": "Inclinação", "sceneTools.roll": "Rolagem", "sceneTools.yaw": "Guinada",
    "sceneTools.collision": "Colisão", "sceneTools.unsavedOrganizationChanges": "ALTERAÇÕES DE ORGANIZAÇÃO NÃO SALVAS",
    "sceneTools.session": "Sessão",

    "doorDirector.look": "Olhar", "doorDirector.closing": "Fechando", "doorDirector.scrubFrame": "QUADRO ATUAL",
    "doorDirector.notAssigned": "Não atribuído", "doorDirector.guided": "GUIADO",
    "doorDirector.oppositeSwing": "Abertura no sentido oposto", "doorDirector.opening": "Abrindo",
    "doorDirector.easeOut": "Desaceleração final", "doorDirector.closingUpper": "FECHANDO",
    "doorDirector.livePlayback": "REPRODUÇÃO AO VIVO",

    "actorSequencer.look": "Olhar", "actorSequencer.undo": "Desfazer", "actorSequencer.standalone": "INDEPENDENTE",
    "actorSequencer.frameHeld": "QUADRO PAUSADO", "actorSequencer.guidedSetup": "CONFIGURAÇÃO GUIADA",
    "actorSequencer.buildPerformance": "Montar a atuação", "actorSequencer.review": "Revisar",
    "actorSequencer.problems": "{count} problemas", "actorSequencer.castUpper": "ELENCO",
    "actorSequencer.scenario": "Cenário", "actorSequencer.dictionary": "Dicionário",
    "actorSequencer.reviewSequence": "Revisar sequência", "actorSequencer.step4Review": "ETAPA 4 · REVISÃO",
    "actorSequencer.seconds": "{value} segundos", "actorSequencer.closingUpper": "FECHANDO",
    "actorSequencer.playingUpper": "REPRODUZINDO",
    "actorSequencer.naturalPace": "Ritmo natural",

    "chase.customized": "Personalizado", "chase.defaults": "Padrões",
    "chase.unitNumber": "Unidade {{number}}", "chase.occupied": "Ocupado",
    "chase.pedModelPlaceholder": "Exemplo: s_m_y_cop_01", "chase.fleetConfigurationMode": "Configuração da frota",
    "chase.recommended": "Recomendado", "chase.configureEachUnit": "Configurar cada unidade",
    "chase.deployed": "Em campo", "chase.operational": "Operacional", "chase.airSupport": "Suporte aéreo",
    "chase.maximumReached": "Número máximo de unidades atingido", "chase.dismiss": "Dispensar mensagem",
    "chase.setup": "Configuração", "chase.initialUnits": "Unidades iniciais",
    "chase.drivingStyle": "Estilo de condução", "chase.appliesLive": "Aplicado em tempo real",
    "chase.ramming": "Abalroamento", "chase.sirens": "Sirenes",
    "chase.helicopterHint": "Manter suporte aéreo cinematográfico", "chase.unitProtection": "Proteção das unidades",
    "chase.helicopterPlaceholder": "Exemplo: polmav", "chase.starting": "Iniciando...",
    "chase.stopping": "Parando...", "chase.running": "Em andamento", "chase.updating": "Atualizando...",
    "chase.unitAdded": "Unidade adicionada.", "chase.unitRemoved": "Unidade removida.",
    "chase.presetBalanced": "Equilibrado", "chase.presetLowProfile": "Discreto",
    "chase.presetMaximum": "Resposta máxima", "chase.presetApplied": "{{name}} aplicado.",
    "chase.presetDeleted": "{{name}} excluído.",
    "chaseReplay.playing": "Reproduzindo", "chaseReplay.finalizing": "Finalizando",

    "stageLighting.closing": "Fechando", "stageLighting.guidedSetup": "CONFIGURAÇÃO GUIADA",
    "stageLighting.look": "Olhar", "stageLighting.keepBeamFocused": "Manter o feixe focalizado",
    "stageLighting.placing": "Posicionando…", "stageLighting.recenterFaders": "Centralizar controles",
    "stageLighting.pitch": "Inclinação", "stageLighting.heading": "Direção", "stageLighting.photometricsUpper": "FOTOMETRIA",
    "stageLighting.editableUpper": "EDITÁVEL", "stageLighting.motionPreset.static": "estático",
    "stageLighting.motionPreset.float": "flutuar", "stageLighting.motionPreset.sweep": "varredura",
    "stageLighting.motionPresetDescription.float": "Flutuação vertical suave",
    "stageLighting.motionPresetDescription.pulse": "Liga e desliga em um ritmo constante",
    "stageLighting.motionPresetDescription.flicker": "Liga e desliga de forma irregular",
    "stageLighting.timing": "TEMPO", "stageLighting.playbackBehavior": "Comportamento de reprodução",
    "stageLighting.proceduralLayers": "CAMADAS DE MOVIMENTO", "stageLighting.layersCanBeCombined": "As camadas podem ser combinadas",
    "stageLighting.amplitudeMeters": "AMPLITUDE · METROS", "stageLighting.frequency": "Frequência", "stageLighting.phase": "Fase",
    "stageLighting.roll": "Rolagem", "stageLighting.yaw": "Guinada", "stageLighting.swayDegrees": "OSCILAÇÃO · GRAUS",
    "stageLighting.pattern": "Padrão", "stageLighting.randomSeed": "Semente aleatória", "stageLighting.targetUpper": "ALVO",
    "stageLighting.fixed": "Fixo", "stageLighting.following": "Seguindo", "stageLighting.aiming": "Mirando",
    "stageLighting.referenced": "Referenciado", "stageLighting.viewUpper": "VISUALIZAÇÃO",
    "stageLighting.gizmoEditing": "Editando com o gizmo", "stageLighting.starting": "Iniciando",

    "spooner.categoryAnimals": "Animais", "spooner.categoryCiviliansFemale": "Civis femininos",
    "spooner.categoryCiviliansMale": "Civis masculinos", "spooner.categoryGangs": "Gangues",
    "spooner.categoryCutscene": "Cinemáticas", "spooner.categoryServices": "Serviços", "spooner.categoryUnique": "Únicos",
    "spooner.categoryFurniture": "Móveis", "spooner.categoryDecoration": "Decoração", "spooner.categoryMusic": "Música",
    "spooner.categoryTrash": "Lixo", "spooner.categoryFood": "Comida", "spooner.categoryGames": "Jogos",
    "spooner.categoryCompacts": "Compactos", "spooner.categorySedans": "Sedãs", "spooner.categorySuvs": "SUVs",
    "spooner.categoryCoupes": "Cupês", "spooner.categoryMuscle": "Muscle", "spooner.categorySportsClassics": "Esportivos clássicos",
    "spooner.categorySports": "Esportivos", "spooner.categorySuper": "Supercarros", "spooner.categoryMotorcycles": "Motos",
    "spooner.categoryOffRoad": "Off-road", "spooner.categoryIndustrial": "Industriais", "spooner.categoryUtility": "Utilitários",
    "spooner.categoryVans": "Vans", "spooner.categoryCycles": "Bicicletas", "spooner.categoryBoats": "Barcos",
    "spooner.categoryHelicopters": "Helicópteros", "spooner.categoryPlanes": "Aviões", "spooner.categoryService": "Serviço",
    "spooner.categoryEmergency": "Emergência", "spooner.categoryMilitary": "Militares", "spooner.categoryCommercial": "Comerciais",
    "spooner.categoryTrains": "Trens", "spooner.modelsCount": "{{count}} modelos",

    "cutscenePlayer.allBadge": "Todas", "cutscenePlayer.allCutscenes": "Todas as cinemáticas",
    "cutscenePlayer.newBadge": "Novas", "cutscenePlayer.newCutscenes": "Novas cinemáticas",
    "cutscenePlayer.noNewCutscenes": "Nenhuma nova cinemática encontrada"
  });

  const staticText = {};
  for (const source of Object.keys(spanish.staticText || english.staticText || {})) {
    staticText[source] = translateText(source);
  }
  const optionLabels = translateOptionTree(spanish.optionLabels || english.optionLabels || {});

  Object.assign(strings, {
  "cameraTargeting.unavailable": "Alvo indisponível. Atualize a lista ou selecione uma cena ativa.",
  "cameraTargeting.scope": "Prioridade dos alvos",
    "cameraTargeting.sceneFirst": "Cena / Timeline primeiro",
    "cameraTargeting.sceneOnly": "Somente cena / Timeline",
    "cameraTargeting.all": "Todas as entidades próximas",
    "cameraTargeting.look": "Alvo do olhar",
    "cameraTargeting.independent": "O olhar controla a rotação; a vinculação controla a posição. Eles podem usar alvos diferentes.",
    "cameraTargeting.rightMouse": "Botão direito do mouse",
    "cameraTargeting.free": "Livre — girar câmera",
    "cameraTargeting.click": "Clique — fixar / soltar",
    "cameraTargeting.hold": "Segurar — seguir até soltar",
    "cameraTargeting.choose": "Selecionar alvo do olhar…",
    "cameraTargeting.previous": "Anterior",
    "cameraTargeting.next": "Próximo",
    "cameraTargeting.release": "Soltar",
    "cameraTargeting.none": "Sem alvo do olhar",
    "cameraTargeting.waiting": "Aguardando o alvo da cena reaparecer",
    "cameraTargeting.help": "Oculte o painel com H. LMB vincula a câmera; RMB escolhe o olhar. Alt + RMB gira manualmente; N ativa o olhar livre. B/V troca de alvo sem mudar a vinculação.",
    "cameraTargeting.focusMode": "Foco da lente",
    "cameraTargeting.manualFocus": "Distância manual",
    "cameraTargeting.centerFocus": "Foco automático — centro da tela",
    "cameraTargeting.targetFocus": "Seguir foco — alvo do olhar",
    "cameraTargeting.focusHelp": "Ative primeiro a profundidade de campo. O foco prioriza o alvo do olhar, depois o da vinculação ou de G. Isso muda a nitidez, não a direção da câmera."
  });

  Object.assign(strings, {
    "cameraDrone.banking": "Inclinação do drone",
    "cameraDrone.bankingHelp": "Inclinação máxima ao virar: 0° nivela o horizonte, 15° é o padrão e 45° é acentuado. A velocidade e a inércia não mudam."
  });

  Object.assign(strings, {
    "cameraTargeting.lookSpeed": "Velocidade do olhar",
    "cameraTargeting.lookSpeedHelp": "1–100%: valores baixos giram devagar; valores altos apontam rápido. Aplica-se a RMB, B/V, alvos do painel e G, incluindo o acompanhamento. Valores muito baixos ficam atrás de alvos rápidos. A rotação manual e a inclinação do drone não mudam."
  });

  Object.assign(strings, {
    "cameraZoom.speed": "Velocidade do zoom",
    "cameraZoom.help": "Oculte o painel com H e segure Z para aproximar ou C para afastar. 1–200%: menor é mais lento; 100% é normal; 200% é duas vezes mais rápido. Muda o FOV, não a posição. Não altera os presets de lente nem a reprodução do zoom gravado."
  });

  window.SD_I18N.registerLocale("pt-br", {
    shortLabel: "PT-BR",
    languageName: "Português (Brasil)",
    direction: "ltr",
    strings,
    staticText,
    optionLabels
  });
})();
