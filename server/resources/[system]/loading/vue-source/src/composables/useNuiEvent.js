import { getCurrentInstance, onMounted, onUnmounted } from "vue";

// ==================== LISTENER DE MENSAGENS NUI ====================
// Mesma convenção do bundle original e do FiveM: o jogo envia mensagens no
// formato { eventName, ...data } — ex.: { eventName: "loadProgress",
// loadFraction: 0.5 }. O listener global despacha para os handlers por nome.
const listeners = new Map();
let isListening = false;
let messageHandler = null;

export default function useNuiEvent(eventName, handler) {
  const add = () => {
    if (!isListening) {
      messageHandler = (event) => {
        const { eventName: name, ...data } = event.data ?? {};
        listeners.get(name)?.forEach((callback) => callback(data));
      };
      window.addEventListener("message", messageHandler);
      isListening = true;
    }
    if (!listeners.has(eventName)) listeners.set(eventName, new Set());
    listeners.get(eventName).add(handler);
  };

  const remove = () => {
    const set = listeners.get(eventName);
    set?.delete(handler);
    if (set && set.size === 0) listeners.delete(eventName);
    if (isListening && listeners.size === 0) {
      window.removeEventListener("message", messageHandler);
      isListening = false;
      messageHandler = null;
    }
  };

  const instance = getCurrentInstance();
  if (instance) {
    onMounted(add);
    onUnmounted(remove);
  } else {
    add();
  }
}
