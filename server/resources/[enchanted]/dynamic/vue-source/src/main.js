import { createApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import "./style.css";
import isBrowser from "@utils/isBrowser";
import loadTheme from "@utils/loadTheme";

async function bootstrap() {
  // Em dev no navegador, ativa o mock (patch de fetch + seed) ANTES do mount.
  // Em produção o branch some e o mock nem entra no grafo do bundle.
  if (import.meta.env.DEV && isBrowser()) {
    await import("./mock/browser");
  }

  const pinia = createPinia();
  createApp(App).use(pinia).mount("#app");

  // Busca o Theme do vrp e aplica as CSS variables
  await loadTheme();
}

bootstrap();
