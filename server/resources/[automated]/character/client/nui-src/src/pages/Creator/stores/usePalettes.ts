import { create } from "zustand";
import { Post } from "@/hooks/post";

type Rgb = [number, number, number];

export type Palettes = {
  hair: Rgb[];
  makeup: Rgb[];
};

interface NuiFrame {
  current: Palettes;
  loaded: boolean;
  load: () => void;
}

// Cores reais do GTA (GetPedHairRgbColor / GetPedMakeupRgbColor), buscadas uma vez no Lua.
const mock: Palettes = {
  hair: [[28, 31, 33], [39, 42, 44], [49, 46, 44], [53, 38, 28], [75, 50, 31], [92, 59, 36]],
  makeup: [[153, 37, 50], [200, 57, 93], [189, 81, 108], [184, 99, 122], [166, 82, 107], [177, 67, 76]],
};

export const usePalettes = create<NuiFrame>((set, get) => ({
  current: { hair: [], makeup: [] },
  loaded: false,

  load: () => {
    if (get().loaded) return;
    set({ loaded: true });
    Post.create<Palettes>("Creator:GetPalettes", {}, mock).then((current) => {
      if (current) set({ current });
    });
  },
}));

export const rgb = (color?: Rgb) =>
  color ? `rgb(${color[0]}, ${color[1]}, ${color[2]})` : "transparent";
