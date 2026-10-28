<!--
  Loading Screen CBR CITY — NUI de carregamento (FiveM)
  Base Vue 3 + Tailwind + Pinia. Os dados vêm do window.nuiHandoverData
  (deferrals.handover no server-side/core.lua) e do evento NUI "loadProgress"
  enviado pelo jogo. O modelo da interface (1 ou 2) vem de Theme.loading.model
  em vrp/config/Global.lua.
-->
<script setup>
import { computed, onMounted, ref } from "vue";
import { useSettingsStore } from "@stores/settings";
import { themeState } from "@stores/theme";
import applyTheme from "@utils/applyTheme";
import useNuiEvent from "@composables/useNuiEvent";
import Version1 from "@components/Version1.vue";
import Version2 from "@components/Version2.vue";

const settings = useSettingsStore();
const video = ref("");
// Painel de dev (só no navegador em npm run dev) — alterna modelos/temas.
const devPanel = ref(null);

// ==================== MODELO DA INTERFACE ====================
// Theme.loading.model: 1 = barra de progresso inferior + player fixo;
// 2 = widgets no centro inferior com botões de música/atalhos (padrão atual).
const currentModel = computed(() => {
  switch (themeState.value.loading?.model) {
    case 1:
    default:
      return Version1;
    case 2:
      return Version2;
  }
});

// ==================== PROGRESSO DO CARREGAMENTO ====================
// O jogo envia { eventName: "loadProgress", loadFraction: 0..1 } quando o
// fxmanifest usa loadscreen_manual_shutdown "yes".
useNuiEvent("loadProgress", (data) => {
  settings.progress = 100 * data.loadFraction;
});

// ==================== DADOS DO HANDOVER ====================
// O server-side envia { video, socials, playlist, theme, autoplay, shortcuts,
// keybindings, progress, classification, classificationAge,
// classificationTitle, classificationText } via deferrals.handover → o jogo
// injeta em window.nuiHandoverData.
const applyHandoverData = () => {
  const data = window.nuiHandoverData;
  if (!data) return;

  if (data.video) video.value = data.video;
  if (data.socials) settings.socials = data.socials;
  if (typeof data.autoplay === "boolean") settings.autoplay = data.autoplay;
  if (data.playlist && Array.isArray(data.playlist)) {
    settings.playlist = data.playlist.map((track) => ({ ...track, howl: null }));
  }
  if (typeof data.shortcuts === "boolean") settings.shortcuts = data.shortcuts;
  if (data.keybindings) settings.keybindings = data.keybindings;
  if (typeof data.progress === "boolean") settings.progressVisible = data.progress;
  if (typeof data.classification === "boolean") settings.classification = data.classification;
  if (data.classificationAge != null) settings.classificationAge = data.classificationAge;
  if (data.classificationTitle) settings.classificationTitle = data.classificationTitle;
  if (data.classificationText) settings.classificationText = data.classificationText;
  if (typeof data.tips === 'boolean') settings.tips = data.tips;
  if (data.tipsSlides && Array.isArray(data.tipsSlides)) settings.tipsSlides = data.tipsSlides;
  if (typeof data.autoplayInterval === 'number') settings.autoplayInterval = data.autoplayInterval;
  if (data.theme) applyTheme(data.theme);
};

onMounted(() => {
  // Carregado só no dev server; em produção o import morre com o if (false).
  // Não usar isBrowser() aqui: o mock/browser.js define window.invokeNative
  // (para simular a NUI), o que faria isBrowser() retornar false em dev.
  if (import.meta.env.DEV) {
    import("@components/DevPanel.vue").then((module) => {
      devPanel.value = module.default;
    });
  }

  if (window.nuiHandoverData) {
    applyHandoverData();
  } else if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", applyHandoverData, { once: true });
  } else {
    setTimeout(applyHandoverData, 100);
  }
});
</script>

<template>
    <div class="size-full flex items-center justify-center">
        <!-- Vídeo de fundo (web-side/video/<video>) -->
        <video
            :src="`./video/${video}`"
            autoplay
            muted
            loop
            class="fixed top-0 left-0 size-full object-cover object-center"
        ></video>
        <component :is="currentModel" />
        <component :is="devPanel" v-if="devPanel" />
    </div>
</template>
