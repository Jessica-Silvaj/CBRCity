/**
 * true quando rodando num navegador comum (dev), false dentro do CEF do FiveM
 * (onde existe `window.invokeNative`).
 */
export default function isBrowser() {
  return typeof window !== "undefined" && !window.invokeNative;
}
