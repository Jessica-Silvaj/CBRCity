import { createReadStream, existsSync } from "node:fs";
import { extname, join } from "node:path";
import { fileURLToPath, URL } from "node:url";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

const VUE_SOURCE = fileURLToPath(new URL(".", import.meta.url));
const WEB_SIDE = join(VUE_SOURCE, "..", "web-side");

const MEDIA_MIME = {
  ".mp3": "audio/mpeg",
  ".webm": "video/webm",
  ".ogg": "audio/ogg",
  ".wav": "audio/wav",
  ".mp4": "video/mp4",
};

// Em dev (navegador), serve as mídias reais (web-side/video e web-side/audio)
// para o fundo de vídeo e a playlist funcionarem — configureServer nunca roda
// no build, então não entra no bundle de produção.
function devMedia() {
  return {
    name: "loading-dev-media",
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        const url = (req.url || "").split("?")[0];
        if (!url.startsWith("/video/") && !url.startsWith("/audio/") && !url.startsWith("/tips/")) {
          next();
          return;
        }
        const file = join(WEB_SIDE, url);
        if (!existsSync(file)) {
          res.writeHead(404);
          res.end("404");
          return;
        }
        res.writeHead(200, { "Content-Type": MEDIA_MIME[extname(file)] || "application/octet-stream" });
        createReadStream(file).pipe(res);
      });
    },
  };
}

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), devMedia()],
  base: "./",
  resolve: {
    extensions: [".mjs", ".js", ".mts", ".ts", ".jsx", ".tsx", ".json", ".vue"],
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
      "@components": fileURLToPath(new URL("./src/components", import.meta.url)),
      "@composables": fileURLToPath(new URL("./src/composables", import.meta.url)),
      "@directives": fileURLToPath(new URL("./src/directives", import.meta.url)),
      "@icons": fileURLToPath(new URL("./src/icons", import.meta.url)),
      "@stores": fileURLToPath(new URL("./src/stores", import.meta.url)),
      "@utils": fileURLToPath(new URL("./src/utils", import.meta.url)),
    },
  },
  build: {
    outDir: "dist",
    emptyOutDir: true,
    assetsInlineLimit: 0,
    cssCodeSplit: false,
    minify: "terser",
    cssMinify: false,
    terserOptions: {
      format: { comments: false },
    },
    rollupOptions: {
      output: {
        format: "iife",
        inlineDynamicImports: true,
        entryFileNames: "script.js",
        chunkFileNames: "[name].js",
        assetFileNames: (assetInfo) =>
          assetInfo.name && assetInfo.name.endsWith(".css")
            ? "style.css"
            : "[name].[ext]",
      },
    },
  },
});
