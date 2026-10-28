import fetchNui from "./fetchNui";

/**
 * Converte "#rrggbb" em { r, g, b }.
 */
function hexToRgb(hex) {
  if (hex[0] === "#") hex = hex.substring(1);
  if (hex.length > 6) hex = hex.substring(0, 6);
  if (hex.length === 3)
    hex = `${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}`;
  const match = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return match
    ? {
        r: parseInt(match[1], 16),
        g: parseInt(match[2], 16),
        b: parseInt(match[3], 16),
      }
    : null;
}

const toRgb = (rgb) => `${rgb.r} ${rgb.g} ${rgb.b}`;

/**
 * Ajusta brilho de uma cor hex (0 = preto, 1 = original, >1 = mais claro).
 */
function adjustBrightness(hex, factor) {
  const c = hexToRgb(hex);
  if (!c) return hex;
  const clamp = (v) => Math.min(255, Math.max(0, Math.round(v)));
  return `#${[clamp(c.r * factor), clamp(c.g * factor), clamp(c.b * factor)]
    .map((v) => v.toString(16).padStart(2, "0"))
    .join("")}`;
}

/**
 * Busca o Theme no resource "vrp" (NUI "Theme") e aplica as CSS variables
 * no elemento <html> para o dynamic menu.
 *
 * Estrutura do Theme relevante:
 *   main, mainText, common, rare, epic, legendary, mythic
 */
export default async function loadTheme() {
  const response = await fetchNui("Theme");
  if (!response) return;

  const html = document.documentElement;
  const main = response.main || "#2e8b57";
  const mainText = response.mainText || "#ffffff";

  // Deriva --from (mais escuro) e --to (ainda mais escuro) a partir de --main
  const from = adjustBrightness(main, 0.06);
  const to = adjustBrightness(main, 0.1);
  const mainHover = adjustBrightness(main, 0.8);

  const setVar = (name, hex) => {
    const rgb = hexToRgb(hex);
    if (rgb) html.style.setProperty("--" + name, toRgb(rgb));
  };

  setVar("main", main);
  setVar("mainText", mainText);
  setVar("from", from);
  setVar("to", to);
  setVar("mainHover", mainHover);

  // Raridades
  for (const key of ["common", "rare", "epic", "legendary", "mythic"]) {
    if (response[key]) setVar(key, response[key]);
  }
}
