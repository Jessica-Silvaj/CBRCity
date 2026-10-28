/**
 * Mock de ambiente NUI para dev no navegador.
 * Auto-abre com PlayerFunctions. Painel simplificado no canto direito.
 */
import isBrowser from "@utils/isBrowser";

// Images served from public/shells/ by Vite dev server
const SHELLS = [
  { name: "Amethyst",   img: "/shells/Amethyst.png",   price: "$2.000.000", gems: "100.000" },
  { name: "Amber",      img: "/shells/Amber.png",      price: "$2.000.000", gems: "100.000" },
  { name: "Sapphire",   img: "/shells/Sapphire.png",   price: "$2.000.000", gems: "100.000" },
  { name: "Emerald",    img: "/shells/Emerald.png",    price: "$2.000.000", gems: "100.000" },
  { name: "Topaz",      img: "/shells/Topaz.png",      price: "$2.000.000", gems: "100.000" },
  { name: "Opal",       img: "/shells/Opal.png",       price: "$2.000.000", gems: "100.000" },
  { name: "Jade",       img: "/shells/Jade.png",       price: "$2.000.000", gems: "100.000" },
  { name: "Pearl",      img: "/shells/Pearl.png",      price: "$2.000.000", gems: "100.000" },
  { name: "Aquamarine", img: "/shells/Aquamarine.png", price: "$2.000.000", gems: "100.000" },
  { name: "Turquoise",  img: "/shells/Turquoise.png",  price: "$2.000.000", gems: "100.000" },
  { name: "Onyx",       img: "/shells/Onyx.png",       price: "$2.000.000", gems: "100.000" },
];

if (import.meta.env.DEV && isBrowser()) {
  const RESOURCE = "dynamic";
  const BG_URL =
    "https://raw.githubusercontent.com/SouLucasHen/Versions/refs/heads/main/images/wallpaper.png";

  const VRP_THEME = {
    main: "#66ad43",
    mainText: "#ffffff",
    common: "#6fc66a",
    rare: "#6ac6c5",
    epic: "#c66a75",
    legendary: "#c6986a",
    mythic: "#c66ae0",
  };

  if (typeof window.GetParentResourceName !== "function")
    window.GetParentResourceName = () => RESOURCE;

  // Intercept fetch
  const realFetch = window.fetch.bind(window);
  const callbacks = {
    Theme: () => VRP_THEME,
    Clicked: (b) => { console.log("[Dynamic:Clicked]", b); return "Ok"; },
    Close: () => { console.log("[Dynamic:Close]"); return "Ok"; },
  };
  window.fetch = async (input, init) => {
    const url = typeof input === "string" ? input : input?.url ?? "";
    const m = new RegExp(`^https?://(?:${RESOURCE}|vrp|nui-fallback)/(.+)$`).exec(url);
    if (!m) return realFetch(input, init);
    let body = {};
    try { if (init?.body) body = JSON.parse(init.body); } catch {}
    const data = callbacks[m[1]] ? await callbacks[m[1]](body) : {};
    return new Response(JSON.stringify(data ?? {}), { status: 200, headers: { "Content-Type": "application/json" } });
  };

  // Background
  const applyBG = () => {
    Object.assign(document.body.style, {
      backgroundImage: `url("${BG_URL}")`,
      backgroundSize: "cover",
      backgroundPosition: "center",
    });
  };
  if (document.body) applyBG();
  else document.addEventListener("DOMContentLoaded", applyBG);

  // Helpers
  const post = (Action, Payload) => window.postMessage({ Action, Payload }, "*");
  window.nui = { post, open: () => post("Open"), close: () => post("Close") };

  // ════════════════════════════════════════════════════
  // SEEDS — replicam os commands do Lua
  // ════════════════════════════════════════════════════

  function seedPlayerFunctions() {
    post("Close");

    post("AddMenu", { Title: "Armário", Description: "Abrir lista com todas as vestimentas.", Id: "wardrobe", ParentId: null });
    post("AddButton", { Title: "Guardar", Description: "Salvar vestimentas do corpo.", Trigger: "dynamic:Clothes", Param: "Save", ParentId: "wardrobe", Server: true });
    ["Motorista", "Paramédico"].forEach((name, i) => {
      const id = String(i + 1);
      post("AddMenu", { Title: name, Description: "Informações da vestimenta.", Id: id, ParentId: "wardrobe" });
      post("AddButton", { Title: "Aplicar", Description: "Vestir-se com as vestimentas.", Trigger: "dynamic:Clothes", Param: "Apply-" + name, ParentId: id, Server: true });
      post("AddButton", { Title: "Remover", Description: "Deletar a vestimenta do armário.", Trigger: "dynamic:Clothes", Param: "Delete-" + name, ParentId: id, Server: true, Back: true });
    });

    post("AddMenu", { Title: "Roupas", Description: "Colocar/Retirar roupas.", Id: "clothes", ParentId: null });
    [["Chapéu","Hat"],["Máscara","Mask"],["Óculos","Glasses"],["Camisa","Shirt"],["Jaqueta","Torso"],["Luvas","Arms"],["Colete","Vest"],["Calça","Pants"],["Sapatos","Shoes"],["Acessórios","Accessory"]].forEach(([l, p]) => {
      post("AddButton", { Title: l, Description: `Colocar/Retirar ${l.toLowerCase()}.`, Trigger: "player:Outfit", Param: p, ParentId: "clothes", Server: true });
    });
    post("AddButton", { Title: "Enviar", Description: "Vestir roupas no próximo.", Trigger: "skinshop:Send", Param: "", ParentId: "clothes", Server: true });

    post("AddMenu", { Title: "Jogador", Description: "Pessoa mais próxima de você.", Id: "closestpeds", ParentId: null });
    post("AddButton", { Title: "Colocar no Veículo", Description: "Colocar no veículo mais próximo.", Trigger: "player:cvFunctions", Param: "cv", ParentId: "closestpeds", Server: true });
    post("AddButton", { Title: "Remover do Veículo", Description: "Remover do veículo mais próximo.", Trigger: "player:cvFunctions", Param: "rv", ParentId: "closestpeds", Server: true });

    post("AddMenu", { Title: "Portas", Description: "Portas do veículo.", Id: "doors", ParentId: null });
    [["Porta do Motorista","1"],["Porta do Passageiro","2"],["Porta Traseira Esquerda","3"],["Porta Traseira Direita","4"],["Porta-Malas","5"],["Capô","6"]].forEach(([l, p]) => {
      post("AddButton", { Title: l, Description: `Abrir ${l.toLowerCase()}.`, Trigger: "player:Doors", Param: p, ParentId: "doors", Server: true });
    });

    post("AddMenu", { Title: "Computador", Description: "Abrir o software dos grupos.", Id: "painel", ParentId: null });
    post("AddButton", { Title: "LSPD", Description: "Painel de Controle do usuário.", Trigger: "mdt:Open", Param: "LSPD", ParentId: "painel", Server: true });
    post("AddButton", { Title: "Paramédico", Description: "Painel de Controle do usuário.", Trigger: "ems:Open", Param: "Paramedico", ParentId: "painel", Server: true });

    post("AddMenu", { Title: "Outros", Description: "Todas as funções do personagem.", Id: "others", ParentId: null });
    post("AddButton", { Title: "Lixeiro", Description: "Marcar/Desmarcar sacos no mapa.", Trigger: "farmer:Blips", Param: "", ParentId: "others" });
    post("AddButton", { Title: "Propriedades", Description: "Marcar/Desmarcar propriedades no mapa.", Trigger: "propertys:Blips", Param: "", ParentId: "others" });
    post("AddButton", { Title: "Ferimentos", Description: "Verificar ferimentos no corpo.", Trigger: "paramedic:Injuries", Param: "", ParentId: "others" });
    post("AddButton", { Title: "Desbugar", Description: "Recarregar o personagem.", Trigger: "player:Debug", Param: "", ParentId: "others", Server: true });

    post("Open");
  }

  function seedEmergencyFunctions() {
    post("Close");

    post("AddMenu", { Title: "Emergência", Description: "Avisos emergenciais.", Id: "tencode", ParentId: null });
    post("AddButton", { Title: "10-13", Description: "Oficial desmaiado/ferido.", Trigger: "dynamic:Tencode", Param: "13", ParentId: "tencode", Server: true });
    post("AddButton", { Title: "10-20", Description: "Localização.", Trigger: "dynamic:Tencode", Param: "20", ParentId: "tencode", Server: true });
    post("AddButton", { Title: "10-38", Description: "Abordagem de trânsito.", Trigger: "dynamic:Tencode", Param: "38", ParentId: "tencode", Server: true });
    post("AddButton", { Title: "10-78", Description: "Apoio com prioridade.", Trigger: "dynamic:Tencode", Param: "78", ParentId: "tencode", Server: true });

    post("AddMenu", { Title: "Jogador", Description: "Pessoa mais próxima de você.", Id: "player", ParentId: null });
    post("AddButton", { Title: "Carregar", Description: "Carregar a pessoa mais próxima.", Trigger: "inventory:Carry", Param: "", ParentId: "player", Server: true });
    post("AddButton", { Title: "Colocar no Veículo", Description: "Colocar no veículo mais próximo.", Trigger: "player:cvFunctions", Param: "cv", ParentId: "player", Server: true });
    post("AddButton", { Title: "Remover do Veículo", Description: "Remover do veículo mais próximo.", Trigger: "player:cvFunctions", Param: "rv", ParentId: "player", Server: true });
    post("AddButton", { Title: "Remover Chapéu", Description: "Remover da pessoa mais próxima.", Trigger: "skinshop:Remove", Param: "Hat", ParentId: "player", Server: true });
    post("AddButton", { Title: "Remover Máscara", Description: "Remover da pessoa mais próxima.", Trigger: "skinshop:Remove", Param: "Mask", ParentId: "player", Server: true });
    post("AddButton", { Title: "Remover Óculos", Description: "Remover da pessoa mais próxima.", Trigger: "skinshop:Remove", Param: "Glasses", ParentId: "player", Server: true });

    post("AddMenu", { Title: "Fardamentos", Description: "Todos os fardamentos policiais.", Id: "prePolice", ParentId: null });
    post("AddButton", { Title: "Principal", Description: "Fardamento de oficial.", Trigger: "player:Preset", Param: "1", ParentId: "prePolice", Server: true });

    post("AddMenu", { Title: "Portas", Description: "Portas do veículo.", Id: "doors2", ParentId: null });
    [["Porta do Motorista","1"],["Porta do Passageiro","2"],["Porta Traseira Esquerda","3"],["Porta Traseira Direita","4"],["Porta-Malas","5"],["Capô","6"]].forEach(([l, p]) => {
      post("AddButton", { Title: l, Description: `Abrir ${l.toLowerCase()}.`, Trigger: "player:Doors", Param: p, ParentId: "doors2", Server: true });
    });

    post("Open");
  }

  function seedEngineVehrify() {
    post("Close");

    post("AddProgress", { Title: "Motor", Description: "Modificação 4 / 5", Value: 80 });
    post("AddProgress", { Title: "Freios", Description: "Modificação 3 / 5", Value: 60 });
    post("AddProgress", { Title: "Transmissão", Description: "Modificação 5 / 5", Value: 100 });
    post("AddProgress", { Title: "Suspensão", Description: "Modificação 2 / 5", Value: 40 });
    post("AddProgress", { Title: "Blindagem", Description: "Modificação 1 / 5", Value: 20 });
    post("AddProgress", { Title: "Potência", Description: "Saúde do motor", Value: 73 });
    post("AddProgress", { Title: "Lataria", Description: "Integridade da lataria", Value: 56 });
    post("AddProgress", { Title: "Chassi", Description: "Rigidez do chassi", Value: 89 });

    post("Open");
  }

  function seedPropertysInterior() {
    post("Close");

    SHELLS.forEach((shell) => {
      const id = shell.name.toLowerCase();
      post("AddMenu", { Title: shell.name, Description: "Informações sobre o interior.", Id: id, ParentId: null, Image: shell.img });
      post("AddButton", { Title: "Credenciais", Description: "Máximo <span>1</span> proprietário e <span>3</span> adicionais.", ParentId: id });
      post("AddButton", { Title: "Comprar com Dinheiro", Description: "Custo de <span>" + shell.price + "</span>.", Trigger: "propertys:Buy", Param: shell.name + "-Dollar", ParentId: id, Server: true });
      post("AddButton", { Title: "Comprar com Diamantes", Description: "Custo de <span>" + shell.gems + "</span>.", Trigger: "propertys:Buy", Param: shell.name + "-Gemstone", ParentId: id, Server: true });
    });

    post("Open");
  }

  function seedRichTags() {
    post("Close");

    post("AddButton", { Title: "Tag <rare>", Description: "Texto em <rare>cor rara</rare> usando tema", ParentId: null });
    post("AddButton", { Title: "Tag <common>", Description: "Texto em <common>cor comum</common> usando tema", ParentId: null });
    post("AddButton", { Title: "Tag <yellow>", Description: "Texto em <yellow>amarelo</yellow> customizado", ParentId: null });
    post("AddButton", { Title: "Tag <epic>", Description: "Texto em <epic>épico</epic> usando tema", ParentId: null });
    post("AddButton", { Title: "Tag <legendary>", Description: "Texto em <legendary>lendário</legendary> usando tema", ParentId: null });
    post("AddButton", { Title: "Tag <mythic>", Description: "Texto em <mythic>mítico</mythic> usando tema", ParentId: null });
    post("AddButton", { Title: "Tag <span>", Description: "Texto em <span>cor principal</span> usando tema", ParentId: null });
    post("AddButton", { Title: "Misto", Description: "Motor <rare>4/5</rare> | Preço <yellow>$50.000</yellow> | Status <common>Ótimo</common> | Dono <span>João</span>", ParentId: null });

    post("Open");
  }

  // Auto-open com PlayerFunctions
  setTimeout(seedPlayerFunctions, 100);

  // ════════════════════════════════════════════════════
  // PAINEL DE DEV — simplificado
  // ════════════════════════════════════════════════════
  const buildPanel = () => {
    let collapsed = false;

    const glass = {
      background: "rgba(12,12,20,0.82)",
      backdropFilter: "blur(16px) saturate(1.4)",
      WebkitBackdropFilter: "blur(16px) saturate(1.4)",
      border: "1px solid rgba(255,255,255,0.08)",
      borderRadius: "8px",
      boxShadow: "0 8px 32px rgba(0,0,0,0.45)",
      fontFamily: "'Inter','SF Pro',system-ui,sans-serif",
      color: "#fff",
      userSelect: "none",
    };
    const btn = {
      padding: "6px 10px",
      fontSize: "11px",
      fontWeight: "500",
      background: "rgba(255,255,255,0.06)",
      color: "rgba(255,255,255,0.85)",
      border: "1px solid rgba(255,255,255,0.08)",
      borderRadius: "5px",
      cursor: "pointer",
      transition: "all 0.15s ease",
      textAlign: "center",
    };

    const panel = document.createElement("div");
    panel.id = "mock-panel";
    Object.assign(panel.style, {
      ...glass,
      position: "fixed",
      top: "8px",
      right: "8px",
      zIndex: "9999",
      width: "min(200px, calc(100vw - 16px))",
    });

    const header = document.createElement("div");
    Object.assign(header.style, {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      padding: "6px 10px",
      borderBottom: "1px solid rgba(255,255,255,0.06)",
      cursor: "pointer",
    });

    const hdrLeft = document.createElement("div");
    Object.assign(hdrLeft.style, { display: "flex", alignItems: "center", gap: "6px" });
    const dot = document.createElement("span");
    Object.assign(dot.style, { width: "5px", height: "5px", borderRadius: "50%", background: "#4ade80", boxShadow: "0 0 6px rgba(74,222,128,0.5)" });
    const lbl = document.createElement("span");
    lbl.textContent = "Dev";
    Object.assign(lbl.style, { fontSize: "11px", fontWeight: "600", letterSpacing: "0.04em" });
    const chev = document.createElement("span");
    chev.textContent = "\u25B2";
    Object.assign(chev.style, { fontSize: "9px", color: "rgba(255,255,255,0.4)", transition: "transform 0.25s ease" });
    hdrLeft.append(dot, lbl);
    header.append(hdrLeft, chev);
    panel.appendChild(header);

    const st = document.createElement("style");
    st.textContent = `#mock-panel button:hover{background:rgba(255,255,255,0.12)!important;border-color:rgba(255,255,255,0.15)!important}`;
    panel.appendChild(st);

    const body = document.createElement("div");
    Object.assign(body.style, { display: "flex", flexDirection: "column", gap: "4px", padding: "6px 8px 8px" });

    const toggleCollapse = () => {
      collapsed = !collapsed;
      body.style.display = collapsed ? "none" : "flex";
      chev.style.transform = collapsed ? "rotate(180deg)" : "";
      header.style.borderBottom = collapsed ? "none" : "1px solid rgba(255,255,255,0.06)";
    };
    header.addEventListener("click", toggleCollapse);

    const row1 = document.createElement("div");
    Object.assign(row1.style, { display: "flex", gap: "4px" });

    const btnOpen = document.createElement("button");
    btnOpen.textContent = "Open";
    Object.assign(btnOpen.style, { ...btn, flex: "1", borderColor: "#4ade8033", color: "#4ade80" });
    btnOpen.addEventListener("click", () => post("Open"));

    const btnClose = document.createElement("button");
    btnClose.textContent = "Close";
    Object.assign(btnClose.style, { ...btn, flex: "1" });
    btnClose.addEventListener("click", () => post("Close"));

    row1.append(btnOpen, btnClose);
    body.appendChild(row1);

    const sep = document.createElement("div");
    Object.assign(sep.style, { fontSize: "8px", fontWeight: "600", letterSpacing: "0.08em", textTransform: "uppercase", color: "rgba(255,255,255,0.25)", textAlign: "center", marginTop: "2px" });
    sep.textContent = "Menus";
    body.appendChild(sep);

    const row2 = document.createElement("div");
    Object.assign(row2.style, { display: "flex", flexDirection: "column", gap: "4px" });

    const menuBtns = [
      { label: "▶ PlayerFunctions", action: seedPlayerFunctions, accent: "#4ade80" },
      { label: "▶ EmergencyFunctions", action: seedEmergencyFunctions, accent: "#f87171" },
      { label: "▶ engine:Vehrify", action: seedEngineVehrify, accent: "#6ac6c5" },
      { label: "▶ Propertys Interior", action: seedPropertysInterior, accent: "#f0c040" },
      { label: "▶ Rich Tags", action: seedRichTags, accent: "#c6986a" },
    ];

    menuBtns.forEach(({ label, action, accent }) => {
      const b = document.createElement("button");
      b.textContent = label;
      Object.assign(b.style, { ...btn, borderColor: accent + "33", color: accent });
      b.addEventListener("click", action);
      row2.appendChild(b);
    });

    body.appendChild(row2);
    panel.appendChild(body);
    document.body.appendChild(panel);
  };

  if (document.body) buildPanel();
  else document.addEventListener("DOMContentLoaded", buildPanel);
}
