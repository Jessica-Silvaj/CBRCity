/**
 * Copia o build (dist/) para web-side/ da resource — a pasta que o fxmanifest
 * usa (loadscreen "web-side/index.html"). Rode via: npm run build:resource
 *
 * Diferente das outras resources, o web-side da loading guarda também as
 * pastas audio/ e video/ (que não fazem parte do build). Este script apaga
 * apenas os arquivos gerados pelo Vite e preserva essas pastas.
 *
 * Estrutura esperada:
 *   <resource>/vue-source/            (este projeto — onde o script vive)
 *   <resource>/web-side/             (destino do build)
 */
import { cpSync, existsSync, rmSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const VUE_SOURCE = dirname(dirname(fileURLToPath(import.meta.url))); // <resource>/vue-source
const RESOURCE = dirname(VUE_SOURCE);                                // <resource>/
const DIST = join(VUE_SOURCE, "dist");
const TARGET = join(RESOURCE, "web-side");

if (!existsSync(DIST)) {
  console.error("Pasta dist/ não encontrada. Rode 'npm run build' primeiro.");
  process.exit(1);
}

// Remove somente os arquivos gerados pelo build (audio/ e video/ ficam intactos)
for (const file of ["index.html", "script.js", "style.css"]) {
  rmSync(join(TARGET, file), { force: true });
}
// Não remove as pastas de mídia (audio/, video/, tips/) — são mantidas no web-side.

cpSync(DIST, TARGET, { recursive: true });

console.log(`Build copiado para ${TARGET}`);
