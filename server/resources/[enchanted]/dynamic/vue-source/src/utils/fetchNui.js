/**
 * Chamada NUI para o resource do FiveM. O tema sempre vem do resource "vrp";
 * os demais eventos vão para o resource atual (GetParentResourceName).
 * @param {string} method
 * @param {object} [data]
 * @returns {Promise<any>}
 */
const isEnvBrowser = !(typeof window !== "undefined" && window.nw === undefined);

export default async function fetchNui(method, data = {}) {
  if (isEnvBrowser) return;

  const resource =
    method === "Theme"
      ? "vrp"
      : typeof GetParentResourceName === "function"
        ? GetParentResourceName()
        : "dynamic";

  try {
    const response = await fetch(`https://${resource}/${method}`, {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify(data),
    });

    const result = await response.json();
    if (!result) return false;
    return result || {};
  } catch {
    // silently fail in dev
  }
}
