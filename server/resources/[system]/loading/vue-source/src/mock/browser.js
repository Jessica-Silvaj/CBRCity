/**
 * Mock de ambiente NUI (FiveM) para rodar a loading screen no navegador
 * durante o dev — mesmo padrão do mock das outras resources (hud, garages).
 *
 * Fora do jogo não existe window.nuiHandoverData (vem do deferrals.handover do
 * server) nem o evento NUI "loadProgress" do jogo. Este módulo simula ambos:
 *   - injeta um handover no MESMO formato do server-side/core.lua
 *     ({ video, socials, playlist, theme, autoplay, shortcuts });
 *   - posta mensagens { eventName: "loadProgress", loadFraction } simulando o
 *     carregamento até 100%.
 * Todo o corpo fica atrás de `import.meta.env.DEV && isBrowser()`, então em
 * produção (vite build) vira código morto e some do bundle.
 */
import isBrowser from "@utils/isBrowser";

if (import.meta.env.DEV && isBrowser()) {
  // ==================== STUBS DO AMBIENTE ====================
  // GetParentResourceName é usado apenas na resolução do tema (scripts por
  // resource) — aqui apenas para o applyTheme não quebrar.
  if (typeof window.GetParentResourceName !== "function") {
    window.GetParentResourceName = () => "loading";
  }

  // Em CEF o FiveM expõe invokeNative; no navegador abrimos o link numa aba.
  if (typeof window.invokeNative !== "function") {
    window.invokeNative = (name, ...args) => {
      if (name === "openUrl" && args[0]) window.open(args[0], "_blank");
    };
  }

  // ==================== HANDOVER SIMULADO ====================
  // Mesmo formato do server-side/core.lua (deferrals.handover). O tema espelha
  // o Theme em vrp/config/Global.lua. Edite aqui para testar variações
  // (mode light/dark, model 1/2, progress false, cor cinza p/ grayscale...).
  window.nuiHandoverData = {
    video: "video.webm",
    socials: [
      { type: "discord", url: "https://discord.gg/VKkWDXSaHh" },
      { type: "instagram", url: "https://instagram.com" },
      { type: "x", url: "https://x.com" },
    ],
    playlist: [
      { artist: "CBR CITY", name: "CBR CITY", file: "music.mp3" },
      { artist: "CBR CITY", name: "CBR CITY 2", file: "music.mp3" },
    ],
    theme: {
      main: "#0a0a0a",
      mainText: "#ffffff",
      loading: { mode: "dark", model: 2 },
    },
    autoplay: true,
    autoplayInterval: 5000,
    shortcuts: true,
    keybindings: { N: "CBR CITY" },
    progress: true,
    classification: true,
    classificationAge: 18,
    classificationTitle: "CLASSIFICAÇÃO INDICATIVA",
    classificationText: "Violência, Drogas, Conteúdo sexual",
    tips: true,
    tipsSlides: [
      {
        image: "/tips/CBRCityTips.png",
        title: "CBR CITY",
        description: "A base sólida que o seu projeto precisa. Traga seu servidor para quem não apenas cria sistemas, mas garante o sucesso da sua cidade!",
      },
    ],
  };

  // ==================== PROGRESSO SIMULADO ====================
  // Mesmo evento que o jogo envia: { eventName: "loadProgress", loadFraction }.
  const sendProgress = (fraction) =>
    window.postMessage({ eventName: "loadProgress", loadFraction: fraction }, "*");

  let progress = 0;
  const interval = setInterval(() => {
    progress = Math.min(1, progress + 0.02 + Math.random() * 0.04);
    sendProgress(progress);
    if (progress >= 1) clearInterval(interval);
  }, 1200);
}
