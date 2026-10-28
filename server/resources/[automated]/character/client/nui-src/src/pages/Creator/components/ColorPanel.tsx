import { cn } from "@/utils/misc";
import { rgb, usePalettes } from "../stores/usePalettes";

// Caixa à direita com todas as cores da paleta (mesmo estilo da escolha de Parentesco).
export default function ColorPanel({
  title,
  palette,
  value,
  onSelect,
}: {
  title: string;
  palette?: string;
  value: number;
  onSelect: (value: number) => void;
}) {
  const { current: palettes } = usePalettes();
  const list = palette === "makeup" ? palettes.makeup : palettes.hair;

  return (
    <div className="flex h-[39.9375rem] w-[21.3125rem] flex-col gap-[0.44rem] rounded-xl bg-white/3 p-[0.56rem]">
      <div className="bg-gradient-primary flex h-10 w-full flex-none items-center justify-center rounded border border-white/15 text-base font-bold text-white">
        {title}
      </div>
      <div className="scroll-hidden grid w-full flex-1 grid-cols-6 content-start gap-[0.44rem] overflow-y-scroll">
        {list.map((color, index) => (
          <button
            key={index}
            onClick={() => onSelect(index)}
            className={cn(
              "relative aspect-square w-full rounded-md border-2 transition-all duration-200 hover:scale-105",
              value === index ? "border-white" : "border-white/10",
            )}
            style={{ backgroundColor: rgb(color) }}
          >
            {value === index && (
              <span className="absolute inset-0 grid place-items-center text-sm font-bold text-white [text-shadow:0_0_4px_black]">
                ✓
              </span>
            )}
          </button>
        ))}
      </div>
    </div>
  );
}
