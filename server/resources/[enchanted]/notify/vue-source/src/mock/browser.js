/**
 * Mock de ambiente NUI (FiveM) para testar o Notify no navegador durante dev.
 *
 * Fora do jogo não existe `GetParentResourceName`, o `fetch` não resolve,
 * e o client nunca dispara os eventos via `SendNUIMessage`.
 * Este módulo simula tudo isso. Todo o corpo fica atrás de
 * `import.meta.env.DEV && isBrowser()`, então em produção some do bundle.
 */
import isBrowser from "@utils/isBrowser";

if (import.meta.env.DEV && isBrowser()) {
  const RESOURCE = "notify";
  const BACKGROUND_URL =
    "https://raw.githubusercontent.com/SouLucasHen/Versions/refs/heads/main/images/wallpaper.png";

  // Stub do resource name.
  if (typeof window.GetParentResourceName !== "function") {
    window.GetParentResourceName = () => RESOURCE;
  }

  // Fundo de dev no body.
  const applyAssets = () => {
    const s = document.body.style;
    s.backgroundImage = `url("${BACKGROUND_URL}")`;
    s.backgroundSize = "cover";
    s.backgroundPosition = "center";
    s.backgroundRepeat = "no-repeat";
  };
  if (document.body) applyAssets();
  else document.addEventListener("DOMContentLoaded", applyAssets);

  // ── Themes (espelha shared-side/shared.lua) ─────────────────────────────
  const THEMES = {
    christmas: {
      background: "#0f0f0fcc",
      border: "#ea7e21",
      icon: { align: "top", image: "default" },
      title: "#ea7e21",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#ea7e21" },
    },
    server: {
      background: "#0f0f0fcc",
      border: "#bf94ff",
      icon: { align: "top", image: "server" },
      title: "#bf94ff",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#bf94ff" },
    },
    amarelo: {
      background: "#0f0f0fcc",
      border: "#fda84f",
      icon: { align: "top", image: "amarelo" },
      title: "#fda84f",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#fda84f" },
    },
    verde: {
      background: "#0f0f0fcc",
      border: "#3fd794",
      icon: { align: "top", image: "verde" },
      title: "#3fd794",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#3fd794" },
    },
    vermelho: {
      background: "#0f0f0fcc",
      border: "#f3413d",
      icon: { align: "top", image: "vermelho" },
      title: "#f3413d",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#f3413d" },
    },
    fome: {
      background: "#0f0f0fcc",
      border: "#fda84f",
      icon: { align: "top", image: "fome" },
      title: "#fda84f",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#fda84f" },
    },
    sede: {
      background: "#0f0f0fcc",
      border: "#408df9",
      icon: { align: "top", image: "sede" },
      title: "#408df9",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#408df9" },
    },
    default: {
      background: "#0f0f0fcc",
      border: "#ffffff",
      icon: { align: "top", image: "default" },
      title: "#ffffff",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#ffffff" },
    },
    sangue: {
      background: "#0f0f0fcc",
      border: "#f3413d",
      icon: { align: "top", image: "sangue" },
      title: "#f3413d",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#f3413d" },
    },
    policia: {
      background: "#0f0f0fcc",
      border: "#408df9",
      icon: { align: "top", image: "policia" },
      title: "#408df9",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#408df9" },
    },
    halloween: {
      background: "#0f0f0fcc",
      border: "#ff6a00",
      icon: { align: "top", image: "halloween" },
      title: "#ff6a00",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#ff6a00" },
    },
    clima: {
      background: "#0f0f0fcc",
      border: "#38bdf8",
      icon: { align: "top", image: "clima" },
      title: "#38bdf8",
      text: "#D1D1D1",
      bold: "#ffffff",
      progress: { background: "#0f0f0fcc", color: "#38bdf8" },
    },
  };

  // ── Helpers ────────────────────────────────────────────────────────────
  const send = (Action, Payload) =>
    window.postMessage({ Action, Payload }, "*");

  window.nui = {
    send,

    /**
     * Notificação padrão.
     * @param {string} Title
     * @param {string} Message
     * @param {string} Color — chave do THEMES
     * @param {string} Position — uma das 8 posições
     * @param {string} Progress — "circle" | "bar"
     */
    notify: (
      Title = "Notificação",
      Message = "Mensagem de exemplo",
      Color = "vermelho",
      Position = "middle-right",
      Progress = "circle",
    ) => {
      send("Notify", {
        Title,
        Message,
        Timer: 5000,
        Theme: THEMES[Color] || THEMES.default,
        Position,
        Progress,
      });
    },

    /** Notificação de veículo trancado (vermelho). */
    vehicleLock: () => send("Vehicle", true),

    /** Notificação de veículo destrancado (verde). */
    vehicleUnlock: () => send("Vehicle", false),
  };

  // ── Painel de teste ─────────────────────────────────────────────────────
  const buildPanel = () => {
    let collapsed = false;

    const panel = document.createElement("div");
    panel.id = "mock-panel";
    Object.assign(panel.style, {
      position: "fixed",
      top: "8px",
      left: "8px",
      zIndex: "9999",
      width: "min(260px, calc(100vw - 16px))",
      maxHeight: "calc(100vh - 16px)",
      background: "rgba(12, 12, 20, 0.88)",
      backdropFilter: "blur(16px) saturate(1.4)",
      border: "1px solid rgba(255,255,255,0.08)",
      borderRadius: "8px",
      boxShadow: "0 8px 32px rgba(0,0,0,0.45)",
      fontFamily: "'Inter', 'SF Pro', system-ui, sans-serif",
      color: "#fff",
      userSelect: "none",
      display: "flex",
      flexDirection: "column",
      overflow: "hidden",
      transition:
        "max-height 0.3s cubic-bezier(0.4,0,0.2,1), opacity 0.2s ease",
    });

    // Scrollbar styles
    const styleTag = document.createElement("style");
    styleTag.textContent = `
      #mock-panel ::-webkit-scrollbar { width: 4px; }
      #mock-panel ::-webkit-scrollbar-track { background: transparent; }
      #mock-panel ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.15); border-radius: 4px; }
    `;
    panel.appendChild(styleTag);

    // Header
    const header = document.createElement("div");
    Object.assign(header.style, {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      padding: "6px 10px",
      borderBottom: "1px solid rgba(255,255,255,0.06)",
      cursor: "pointer",
      flexShrink: "0",
    });

    const headerLeft = document.createElement("div");
    Object.assign(headerLeft.style, {
      display: "flex",
      alignItems: "center",
      gap: "8px",
    });

    const dot = document.createElement("span");
    Object.assign(dot.style, {
      width: "6px",
      height: "6px",
      borderRadius: "50%",
      background: "#4ade80",
      boxShadow: "0 0 6px rgba(74,222,128,0.5)",
      flexShrink: "0",
    });

    const titleEl = document.createElement("span");
    titleEl.textContent = "Notify Dev";
    Object.assign(titleEl.style, {
      fontSize: "11px",
      fontWeight: "600",
      letterSpacing: "0.04em",
      color: "rgba(255,255,255,0.9)",
    });

    const chevron = document.createElement("span");
    chevron.textContent = "\u25B2";
    Object.assign(chevron.style, {
      fontSize: "10px",
      color: "rgba(255,255,255,0.4)",
      transition: "transform 0.25s ease",
      lineHeight: "1",
    });

    headerLeft.append(dot, titleEl);
    header.append(headerLeft, chevron);
    panel.appendChild(header);

    // Body
    const body = document.createElement("div");
    Object.assign(body.style, {
      display: "flex",
      flexDirection: "column",
      gap: "0",
      padding: "4px 6px 8px",
      overflowY: "auto",
      overflowX: "hidden",
      flex: "1 1 auto",
    });

    const toggleCollapse = () => {
      collapsed = !collapsed;
      if (collapsed) {
        body.style.maxHeight = "0";
        body.style.paddingTop = "0";
        body.style.paddingBottom = "0";
        body.style.opacity = "0";
        body.style.overflow = "hidden";
        header.style.borderBottom = "none";
        chevron.style.transform = "rotate(180deg)";
      } else {
        body.style.maxHeight = "9999px";
        body.style.paddingTop = "4px";
        body.style.paddingBottom = "6px";
        body.style.opacity = "1";
        body.style.overflowY = "auto";
        header.style.borderBottom = "1px solid rgba(255,255,255,0.06)";
        chevron.style.transform = "rotate(0deg)";
      }
    };
    header.addEventListener("click", toggleCollapse);

    const btn = (label, action, accent) => {
      const b = document.createElement("button");
      b.textContent = label;
      b.title = label;
      Object.assign(b.style, {
        padding: "3px 6px",
        fontSize: "10px",
        fontWeight: "500",
        background: "rgba(255,255,255,0.06)",
        color: accent || "rgba(255,255,255,0.85)",
        border: `1px solid ${accent ? accent + "33" : "rgba(255,255,255,0.08)"}`,
        borderRadius: "4px",
        cursor: "pointer",
        whiteSpace: "nowrap",
        lineHeight: "1.3",
        transition: "all 0.15s ease",
        overflow: "hidden",
        textOverflow: "ellipsis",
        minWidth: "0",
      });
      b.addEventListener("mouseenter", () => {
        b.style.background = accent ? accent + "22" : "rgba(255,255,255,0.12)";
        b.style.borderColor = accent ? accent + "55" : "rgba(255,255,255,0.15)";
      });
      b.addEventListener("mouseleave", () => {
        b.style.background = "rgba(255,255,255,0.06)";
        b.style.borderColor = accent
          ? accent + "33"
          : "rgba(255,255,255,0.08)";
      });
      b.addEventListener("click", action);
      return b;
    };

    const group = (label, buttons, cols = 2) => {
      const sep = document.createElement("div");
      Object.assign(sep.style, {
        display: "flex",
        alignItems: "center",
        gap: "4px",
        marginTop: "4px",
        marginBottom: "2px",
        paddingLeft: "2px",
      });
      const line = document.createElement("div");
      Object.assign(line.style, {
        flex: "1",
        height: "1px",
        background: "rgba(255,255,255,0.06)",
      });
      const lbl = document.createElement("span");
      lbl.textContent = label;
      Object.assign(lbl.style, {
        fontSize: "8px",
        fontWeight: "600",
        letterSpacing: "0.08em",
        textTransform: "uppercase",
        color: "rgba(255,255,255,0.3)",
        flexShrink: "0",
      });
      sep.append(line.cloneNode(true), lbl, line.cloneNode(true));
      body.appendChild(sep);

      const grid = document.createElement("div");
      Object.assign(grid.style, {
        display: "grid",
        gridTemplateColumns: `repeat(${cols}, 1fr)`,
        gap: "3px",
        padding: "0 2px",
      });
      buttons.forEach(([label, action, accent]) =>
        grid.appendChild(btn(label, action, accent)),
      );
      body.appendChild(grid);
    };

    // Helper: cria notificação com posição específica
    const notifyAt = (pos, color = "vermelho") =>
      window.nui.notify(
        "Posição",
        pos,
        color,
        pos,
        "circle",
      );

    // ── Grupos ──────────────────────────────────────────────────────────
    group("Temas", [
      ["🔴 Vermelho", () => window.nui.notify("Erro", "Algo deu errado!", "vermelho"), "#f3413d"],
      ["🟢 Verde", () => window.nui.notify("Sucesso", "Operação concluída!", "verde"), "#3fd794"],
      ["🟡 Amarelo", () => window.nui.notify("Aviso", "Atenção ao procedimento", "amarelo"), "#fda84f"],
      ["🔵 Polícia", () => window.nui.notify("Policia", "Abordagem policial", "policia"), "#408df9"],
      ["🟣 Server", () => window.nui.notify("Server", "Mensagem do servidor", "server"), "#bf94ff"],
      ["🩸 Sangue", () => window.nui.notify("Sangue", "Vida baixa", "sangue"), "#f3413d"],
      ["🍽 Fome", () => window.nui.notify("Fome", "Você está com fome", "fome"), "#fda84f"],
      ["💧 Sede", () => window.nui.notify("Sede", "Você está com sede", "sede"), "#408df9"],
      ["⬜ Default", () => window.nui.notify("Default", "Notificação padrão", "default")],
      ["🎄 Christmas", () => window.nui.notify("Natal", "Feliz Natal!", "christmas"), "#ea7e21"],
      ["🎃 Halloween", () => window.nui.notify("Halloween", "Boo! Noite das bruxas", "halloween"), "#ff6a00"],
      ["🌤 Clima", () => window.nui.notify("Clima", "Tempestade a caminho", "clima"), "#38bdf8"],
    ]);

    group("Progress", [
      ["⭕ Circle", () => window.nui.notify("Circle", "Animação circular", "vermelho", "middle-right", "circle"), "#f3413d"],
      ["▬ Bar", () => window.nui.notify("Bar", "Animação barra", "verde", "middle-right", "bar"), "#3fd794"],
    ], 2);

    group("Posições", [
      ["⟵ middle-left", () => notifyAt("middle-left", "vermelho"), "#f3413d"],
      ["⟶ middle-right", () => notifyAt("middle-right", "verde"), "#3fd794"],
      ["⟵ top-left", () => notifyAt("top-left", "amarelo"), "#fda84f"],
      ["↕ top-center", () => notifyAt("top-center", "policia"), "#408df9"],
      ["⟶ top-right", () => notifyAt("top-right", "server"), "#bf94ff"],
      ["⟵ bottom-left", () => notifyAt("bottom-left", "sangue"), "#f3413d"],
      ["↕ bottom-center", () => notifyAt("bottom-center", "sede"), "#408df9"],
      ["⟶ bottom-right", () => notifyAt("bottom-right", "default")],
    ], 2);

    group("Veículo", [
      ["🔒 Trancar", () => window.nui.vehicleLock(), "#ef4444"],
      ["🔓 Destrancar", () => window.nui.vehicleUnlock(), "#22c55e"],
    ], 2);

    panel.appendChild(body);
    document.body.appendChild(panel);
  };

  if (document.body) buildPanel();
  else document.addEventListener("DOMContentLoaded", buildPanel);
}
