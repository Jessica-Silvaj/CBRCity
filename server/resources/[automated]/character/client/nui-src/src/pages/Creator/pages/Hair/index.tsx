import Cell from "./components/Cell";
import ColorCell from "../../components/ColorCell";
import ColorPanel from "../../components/ColorPanel";
import Footer from "../../components/Footer";
import Header from "../../components/Header";
import { Post } from "@/hooks/post";
import { useEffect, useState } from "react";
import { usePartial, type Data } from "./stores/usePartial";
import { usePalettes } from "../../stores/usePalettes";
import { useCamera } from "../../stores/useCamera";
import { useSave } from "../../stores/useSave";
import { cn } from "@/utils/misc";

export default function Hair() {
  const partial = usePartial();
  const palettes = usePalettes();
  const { set: setCamera } = useCamera();
  const [openColor, setOpenColor] = useState<string | false>(false);
  const { current: data } = partial;
  useEffect(() => {
    palettes.load();
    Post.create<Record<string, Data>>(
      "Creator:GetData",
      { section: "Hair" },
      {
        hairColor: {
          title: "Cor do Cabelo",
          value: 1,
          min: 0,
          max: 63,
          type: "color",
          palette: "hair",
          order: 1,
        },
        beardOpacity: {
          title: "Intensidade da Barba",
          value: 100,
          min: 0,
          max: 100,
          type: "opacity",
          order: 2,
        },
      },
    ).then(partial.set);
  }, []);
  const save = useSave();
  useEffect(() => {
    Post.create("Creator:UpdatePedPreview", { section: "hair", data });
  }, [data]);

  const keys = Object.keys(data).sort((a, b) => (data[a].order ?? 99) - (data[b].order ?? 99));
  const changeColor = (key: string, value: number) => {
    partial.update(key, value);
    const camera = data[key].camera;
    if (camera) {
      Post.create("Character:SetCamera", { section: "Creator", id: camera }).then((response) => {
        if (response) setCamera(camera);
      });
    }
  };
  const open = openColor ? data[openColor] : undefined;

  return (
    <div className={cn("flex size-full items-center justify-between overflow-visible", open && "pr-16")}>
      <div className="flex w-[20.125rem] flex-col items-center overflow-visible">
        <Header />
        <ul className="scroll-hidden mb-2 mt-6 flex h-[37.0625rem] w-full flex-col gap-3.5 overflow-y-scroll">
          {keys.map((key) => {
            const char = data[key];
            if (char.type === "color") {
              return (
                <ColorCell
                  key={key}
                  data={char}
                  active={openColor === key}
                  onToggle={() => setOpenColor(openColor === key ? false : key)}
                  onChange={(value) => changeColor(key, value)}
                />
              );
            }
            return <Cell key={key} descriminator={key} data={char} />;
          })}
        </ul>
        <Footer canReturn page="4" isSave canClick={save.current} />
      </div>
      {openColor && open && (
        <ColorPanel
          title={open.title}
          palette={open.palette}
          value={open.value}
          onSelect={(value) => changeColor(openColor, value)}
        />
      )}
    </div>
  );
}
