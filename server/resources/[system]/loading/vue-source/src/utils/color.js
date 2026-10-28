// ==================== UTILITÁRIOS DE COR ====================
// Réplica fiel dos helpers do bundle original (usados no tema do handover).
// As conversões usam arredondamento/toFixed idênticos ao original para que as
// CSS variables geradas (--main, --from, --to, --mainHover) batam exatamente.

// "#rrggbb" ou "#rgb" → { r, g, b }. Retorna null para formato inválido.
export function hexToRgb(hex) {
  hex = hex.replace("#", "");
  if (hex.length === 3) hex = hex.split("").map((c) => c + c).join("");
  if (hex.length !== 6) return null;

  const match = hex.match(/([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})/i);
  if (!match) return null;

  return {
    r: parseInt(match[1], 16),
    g: parseInt(match[2], 16),
    b: parseInt(match[3], 16),
  };
}

// RGB (0-255) → HSL (h 0-360, s/l 0-100). s e l com uma casa decimal (toFixed).
export function rgbToHsl(r, g, b) {
  r /= 255;
  g /= 255;
  b /= 255;

  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  const delta = max - min;

  let hue = 0;
  if (delta !== 0) {
    hue =
      max === r
        ? ((g - b) / delta) % 6
        : max === g
          ? (b - r) / delta + 2
          : (r - g) / delta + 4;
  }
  hue = Math.round((60 * hue + 360) % 360);

  const lightness = (max + min) / 2;

  return {
    h: hue,
    s: +(100 * (delta === 0 ? 0 : delta / (1 - Math.abs(2 * lightness - 1)))).toFixed(1),
    l: +(100 * lightness).toFixed(1),
  };
}

// HSL (h 0-360, s/l 0-100) → RGB (0-255, arredondado).
export function hslToRgb(h, s, l) {
  s /= 100;
  l /= 100;

  const c = (1 - Math.abs(2 * l - 1)) * s;
  const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  const m = l - c / 2;

  let r = 0;
  let g = 0;
  let b = 0;
  [r, g, b] =
    h < 60
      ? [c, x, 0]
      : h < 120
        ? [x, c, 0]
        : h < 180
          ? [0, c, x]
          : h < 240
            ? [0, x, c]
            : h < 300
              ? [x, 0, c]
              : [c, 0, x];

  return {
    r: Math.round(255 * (r + m)),
    g: Math.round(255 * (g + m)),
    b: Math.round(255 * (b + m)),
  };
}

// Escurece uma cor (0-255) por uma porcentagem (ex.: 20 = escurecer 20%).
export function darken(r, g, b, percent) {
  const factor = 1 - percent / 100;
  const clamp = (value) => Math.max(0, Math.min(255, Math.floor(value * factor)));
  return {
    r: clamp(r),
    g: clamp(g),
    b: clamp(b),
  };
}
