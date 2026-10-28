import React from "react";
import { cn, isEnvBrowser } from "@/utils/misc";
import { useLocation, useNavigate } from "react-router-dom";

import { AnimationProvider } from "./Animation";
import { Post } from "@/hooks/post";
import { observe } from "@/hooks/observe";
import { listen } from "@/hooks/listen";

import Popup from "@/components/Popup";
import Notifys from "@/components/Notifys";

export const VisibilityProvider = ({
  children,
}: {
  children: React.ReactNode;
}) => {
  const navigate = useNavigate();
  const location = useLocation();
  const visible = location.pathname.length > 2;

  observe<string | false>("setVisibility", (route) => {
    navigate(`/${route || ""}`, { replace: true });
  });

  observe<string>("setColor", (data) => {
    document.documentElement.style.setProperty("--main-color", data);
  });

  listen<KeyboardEvent>("keydown", (e) => {
    if (visible && ["Escape"].includes(e.code)) Post.create("removeFocus");
  });

  // Girar o personagem segurando A (esquerda) ou D (direita)
  const rotateHeld = React.useRef<0 | 1 | -1>(0);
  const canRotate = /^\/(creator|barbershop|skinshop|tattooshop)/.test(location.pathname);
  const isTyping = (e: KeyboardEvent) =>
    e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement;

  listen<KeyboardEvent>("keydown", (e) => {
    if (!canRotate || isTyping(e)) return;
    if (e.code === "KeyA") rotateHeld.current = -1;
    else if (e.code === "KeyD") rotateHeld.current = 1;
  });

  listen<KeyboardEvent>("keyup", (e) => {
    if ((e.code === "KeyA" && rotateHeld.current === -1) || (e.code === "KeyD" && rotateHeld.current === 1)) {
      rotateHeld.current = 0;
    }
  });

  React.useEffect(() => {
    if (!canRotate) rotateHeld.current = 0;
    const timer = setInterval(() => {
      if (rotateHeld.current !== 0) {
        Post.create("Character:RotatePed", { delta: rotateHeld.current * 4 });
      }
    }, 30);
    return () => clearInterval(timer);
  }, [canRotate]);

  return (
    <AnimationProvider show={visible}>
      <div
        className={cn("h-screen", {
          "bg-gray-600": isEnvBrowser(),
        })}
      >
        {children}
        <Popup />
        <Notifys />
      </div>
    </AnimationProvider>
  );
};
