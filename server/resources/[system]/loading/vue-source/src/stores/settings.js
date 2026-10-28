import { defineStore } from "pinia";
import { ref } from "vue";

// ==================== ESTADO GLOBAL DA LOADING SCREEN ====================
// A maior parte é preenchida no App.vue a partir do window.nuiHandoverData
// (deferrals.handover no server-side/core.lua): socials, playlist, shortcuts
// e autoplay. O progress vem do evento NUI "loadProgress" enviado pelo jogo.
export const useSettingsStore = defineStore("settings", () => {
  const display = ref(false);
  const progress = ref(0);
  const autoplay = ref(false);
  const socials = ref([]);
  const playlist = ref([]);
  const shortcuts = ref(true); // shared-side: Shortcuts (mostra/oculta o botão Atalhos)
  const keybindings = ref({}); // shared-side: Keybindings (tecla → atalho)
  const progressVisible = ref(true); // shared-side: Progress (mostra/oculta a barra)
  const classification = ref(false); // shared-side: Classification (mostra/oculta o selo)
  const classificationAge = ref(18);
  const classificationTitle = ref("");
  const classificationText = ref("");
  const tips = ref(true); // shared-side: Tips (mostra/oculta o botão Dicas)
  const tipsSlides = ref([]); // shared-side: TipsSlides (array de slides)
  const autoplayInterval = ref(5000); // shared-side: AutoplayInterval (ms entre slides)

  return {
    display,
    progress,
    autoplay,
    socials,
    playlist,
    shortcuts,
    keybindings,
    progressVisible,
    classification,
    classificationAge,
    classificationTitle,
    classificationText,
    tips,
    tipsSlides,
    autoplayInterval,
  };
});
