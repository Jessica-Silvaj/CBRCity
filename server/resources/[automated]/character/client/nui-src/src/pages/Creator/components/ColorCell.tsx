import { GeneralIcons } from "@/components/Icons";
import { cn } from "@/utils/misc";
import { rgb, usePalettes } from "../stores/usePalettes";

// Campo de cor: amostra clicável (abre a paleta à direita) + setas para trocar.
export default function ColorCell({
  data,
  active,
  onToggle,
  onChange,
}: {
  data: { title: string; value: number; min: number; max: number; palette?: string };
  active: boolean;
  onToggle: () => void;
  onChange: (value: number) => void;
}) {
  const { current: palettes } = usePalettes();
  const list = data.palette === "makeup" ? palettes.makeup : palettes.hair;
  const max = list.length > 0 ? Math.min(data.max, list.length - 1) : data.max;

  return (
    <li className="flex w-full flex-none flex-col gap-2.5">
      <p className="text-base font-medium text-white/85">{data.title}</p>
      <div className="flex h-[2.8125rem] gap-[0.31rem]">
        <button
          onClick={onToggle}
          className={cn(
            "size-[2.8125rem] flex-none rounded-md border-2 transition-all duration-200",
            active ? "border-white" : "border-white/15 hover:border-white/40",
          )}
          style={{ backgroundColor: rgb(list[data.value]) }}
        />
        <div className="bg-section flex h-full w-full items-center justify-between gap-2 rounded-md border border-white/15 p-1.5">
          <button
            onClick={() => data.value - 1 >= data.min && onChange(data.value - 1)}
            className="grid size-[1.875rem] flex-none place-items-center rounded bg-white/15 hover:bg-white/20 active:scale-95 transition-all duration-200"
          >
            <GeneralIcons.ChevronLeft />
          </button>
          <p className="w-full truncate text-center text-base font-bold text-white/85">
            Cor {data.value + 1}
          </p>
          <button
            onClick={() => data.value + 1 <= max && onChange(data.value + 1)}
            className="grid size-[1.875rem] flex-none place-items-center rounded bg-white/15 hover:bg-white/20 active:scale-95 transition-all duration-200"
          >
            <GeneralIcons.ChevronRight />
          </button>
        </div>
      </div>
    </li>
  );
}
