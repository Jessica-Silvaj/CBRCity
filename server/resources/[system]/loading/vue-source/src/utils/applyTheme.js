import { themeState } from "@stores/theme";
import { darken, hexToRgb, hslToRgb, rgbToHsl } from "./color";

// ==================== APLICAÇÃO DO TEMA (HANDOVER) ====================
// O server-side envia Theme (vrp/config/Global.lua) dentro do handover:
//   Theme = { main = "#66ad43", mainText = "#ffffff", loading = { mode, model } }
// Este helper replica o comportamento do bundle original:
//   - main     → escreve --main, deriva --from/--to (fromTo) e --mainHover
//                (hover = escurecer 20%); saturação 0 ativa o modo grayscale;
//   - mainText → escreve --mainText;
//   - loading  → guarda { mode, model } no themeState (consumido pelos
//                componentes: modelo da interface e fundo dark/light). A
//                visibilidade do progresso vem do Progress do shared-side.

// Constantes de derivação do fundo (RGB → HSL), idênticas ao bundle original:
// o --from usa saturação/luminosidade de RGB(18,4,2) e o --to de RGB(31,6,3),
// ambos com o matiz da cor principal.
const FROM_BASE = rgbToHsl(18, 4, 2);
const TO_BASE = rgbToHsl(31, 6, 3);

const DEFAULT_THEME = {
  main: {
    rgb: true,
    fromTo: true,
    hover: true,
    grayscaleCheck: true,
    default: "#2e8b57",
  },
  mainText: {
    rgb: true,
    default: "#ffffff",
  },
  loading: {
    variable: "loading",
    default: { mode: "dark", model: 2 },
  },
};

const getIn = (obj, keys) =>
  keys.reduce((acc, key) => (acc && acc[key] !== undefined ? acc[key] : undefined), obj);

export default function applyTheme(theme, config = DEFAULT_THEME) {
  const resource =
    typeof GetParentResourceName === "function" ? GetParentResourceName() : "nui-fallback";

  for (const key in config) {
    const options = config[key];
    if (!options) continue;

    // Caminho no tema (ex.: "main" → theme.main; "main-text" → theme.main.text)
    const parts = key.split("-");
    let value = getIn(theme, parts);

    // Override por resource (theme.scripts[<resource>][...]) — mesmo formato
    // do bundle original (usado pela HUD para temas por painel).
    if (options.rgb && parts[0] && theme?.scripts?.[resource]?.[parts[0]]) {
      const override = getIn(theme.scripts[resource], parts);
      if (typeof override === "string") value = override;
    }

    if (value == null || value === "") value = options.default;

    // Variáveis de estado (ex.: Theme.loading → themeState.loading)
    if (options.variable) themeState.value[options.variable] = value;

    if (typeof value !== "string") continue;

    const rgb = hexToRgb(value);
    if (!rgb) continue;
    const hsl = rgbToHsl(rgb.r, rgb.g, rgb.b);

    if (options.rgb) {
      document.documentElement.style.setProperty(`--${key}`, `${rgb.r} ${rgb.g} ${rgb.b}`);
    }

    if (options.fromTo) {
      const from = hslToRgb(hsl.h, hsl.s === 0 ? hsl.s : FROM_BASE.s, FROM_BASE.l);
      const to = hslToRgb(hsl.h, hsl.s === 0 ? hsl.s : TO_BASE.s, TO_BASE.l);
      document.documentElement.style.setProperty("--from", `${from.r} ${from.g} ${from.b}`);
      document.documentElement.style.setProperty("--to", `${to.r} ${to.g} ${to.b}`);
    }

    if (options.grayscaleCheck) {
      // Reseta também ao voltar para uma cor saturada (necessário no dev panel).
      themeState.value.grayscale = hsl.s === 0;
    }

    if (options.hover) {
      const hovered = darken(rgb.r, rgb.g, rgb.b, 20);
      document.documentElement.style.setProperty(`--${key}Hover`, `${hovered.r} ${hovered.g} ${hovered.b}`);
    }
  }
}
