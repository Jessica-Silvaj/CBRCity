import { createApp } from "vue";
import App from "./App.vue";
import "./style.css";
import isBrowser from "@utils/isBrowser";

async function bootstrap() {
  // Em dev no navegador, ativa o mock ANTES do mount.
  if (import.meta.env.DEV && isBrowser()) {
    await import("./mock/browser");
  }

  createApp(App).mount("#app");
}

bootstrap();
