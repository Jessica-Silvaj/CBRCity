import { nextTick } from "vue";

// ==================== DIRETIVA v-tooltip ====================
// Réplica fiel do bundle original: cria um tooltip fixo posicionado acima do
// elemento (com fallback abaixo) e mostra após um pequeno delay no hover.
// Usada nas teclas do painel de atalhos para exibir o texto do atalho
// (ex.: tecla N → "CBR CITY").

const showTooltip = async (el) => {
  if (!el._tooltipInstance) return;
  const { tooltip } = el._tooltipInstance;
  tooltip.style.opacity = "1";
  await nextTick();
  positionTooltip(el, tooltip);
};

const positionTooltip = (el, tooltip) => {
  const elRect = el.getBoundingClientRect();
  const tooltipRect = tooltip.getBoundingClientRect();

  let left = elRect.left + elRect.width / 2 - tooltipRect.width / 2;
  let top = elRect.top - tooltipRect.height - 8;

  // Mantém dentro da viewport
  if (left < 8) left = 8;
  if (left + tooltipRect.width > window.innerWidth - 8) {
    left = window.innerWidth - tooltipRect.width - 8;
  }
  if (top < 8) top = elRect.bottom + 8;

  tooltip.style.left = `${left}px`;
  tooltip.style.top = `${top}px`;
};

const createTooltip = (text) => {
  const tooltip = document.createElement("div");
  tooltip.className =
    "fixed z-[9999] px-3 py-1 text-sm text-white bg-from/90 ring-1 ring-white/10 rounded-md whitespace-nowrap pointer-events-none opacity-0 transition-opacity duration-200";
  tooltip.textContent = text;
  document.body.appendChild(tooltip);
  return tooltip;
};

export default {
  mounted(el, binding) {
    const value =
      typeof binding.value === "string"
        ? { text: binding.value, delay: 50 }
        : { delay: 50, ...binding.value };
    if (!value.text) return;

    const tooltip = createTooltip(value.text);

    const show = () => {
      if (el._tooltipInstance?.timeoutId) clearTimeout(el._tooltipInstance.timeoutId);
      el._tooltipInstance.timeoutId = window.setTimeout(() => showTooltip(el), value.delay);
    };

    const hide = () => {
      if (!el._tooltipInstance) return;
      const { tooltip, timeoutId } = el._tooltipInstance;
      if (timeoutId) {
        clearTimeout(timeoutId);
        el._tooltipInstance.timeoutId = null;
      }
      tooltip.style.opacity = "0";
    };

    el.addEventListener("mouseenter", show);
    el.addEventListener("mouseleave", hide);
    el._tooltipInstance = {
      tooltip,
      timeoutId: null,
      cleanup: () => {
        el.removeEventListener("mouseenter", show);
        el.removeEventListener("mouseleave", hide);
        tooltip.parentNode && document.body.removeChild(tooltip);
        if (el._tooltipInstance?.timeoutId) clearTimeout(el._tooltipInstance.timeoutId);
      },
    };
  },

  updated(el, binding) {
    if (!el._tooltipInstance) return;
    const value =
      typeof binding.value === "string" ? { text: binding.value } : { ...binding.value };
    el._tooltipInstance.tooltip.textContent = value.text;
  },

  unmounted(el) {
    if (el._tooltipInstance) {
      el._tooltipInstance.cleanup();
      delete el._tooltipInstance;
    }
  },
};
