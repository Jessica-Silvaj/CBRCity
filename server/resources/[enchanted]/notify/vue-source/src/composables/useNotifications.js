import { reactive } from "vue";

let nextId = 0;

/** Estado reativo: cada chave é uma posição, cada valor é um array de notificações. */
export const notifications = reactive({
  "middle-left": [],
  "middle-right": [],
  "top-left": [],
  "top-center": [],
  "top-right": [],
  "bottom-left": [],
  "bottom-center": [],
  "bottom-right": [],
});

/**
 * Adiciona uma notificação padrão na posição indicada.
 * @returns {number} id — usar no setTimeout para remover depois.
 */
export function addNotification(position, notification) {
  const id = ++nextId;
  const entry = { id, type: "default", ...notification };
  notifications[position]?.push(entry);
  return id;
}

/**
 * Remove uma notificação pelo id dentro da posição.
 */
export function removeNotification(position, id) {
  const list = notifications[position];
  if (!list) return;
  const index = list.findIndex((n) => n.id === id);
  if (index !== -1) list.splice(index, 1);
}

/**
 * Mostra a notificação de veículo (singleton em bottom-center).
 * @param {boolean} locked — true = vermelho (trancado), false = verde (destrancado)
 * @returns {number} id
 */
export function showVehicle(locked) {
  hideVehicle();
  const id = ++nextId;
  notifications["bottom-center"].push({
    id,
    type: "vehicle",
    locked: !!locked,
  });
  return id;
}

/**
 * Remove a notificação de veículo se existir.
 */
export function hideVehicle() {
  const list = notifications["bottom-center"];
  const index = list.findIndex((n) => n.type === "vehicle");
  if (index !== -1) list.splice(index, 1);
}
