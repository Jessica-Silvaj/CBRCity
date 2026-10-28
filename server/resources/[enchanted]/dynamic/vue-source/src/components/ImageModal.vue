<script setup>
import { ref, onMounted, onUnmounted, nextTick } from "vue";

const props = defineProps(["src", "alt", "title", "description"]);
const emit = defineEmits(["close"]);

const visible = ref(false);
const imgError = ref(false);

function handleKeydown(e) {
  if (e.key === "Escape") close();
}

function close() {
  visible.value = false;
  setTimeout(() => emit("close"), 300);
}

onMounted(() => {
  window.addEventListener("keydown", handleKeydown);
  nextTick(() => { visible.value = true; });
});

onUnmounted(() => {
  window.removeEventListener("keydown", handleKeydown);
});

function parseDesc(text) {
  if (!text) return "";
  const tagMap = {
    rare: "rgb(var(--rare))",
    common: "rgb(var(--common))",
    yellow: "#f0c040",
    epic: "rgb(var(--epic))",
    legendary: "rgb(var(--legendary))",
    mythic: "rgb(var(--mythic))",
  };
  let result = text;
  for (const [tag, color] of Object.entries(tagMap)) {
    const regex = new RegExp(`<${tag}>([^<]*)</${tag}>`, "gi");
    result = result.replace(regex, `<span style="color:${color};font-weight:600">$1</span>`);
  }
  return result;
}
</script>

<template>
  <Teleport to="body">
    <!-- Background overlay -->
    <transition name="modal-bg">
      <div
        v-if="visible"
        class="fixed inset-0 z-[9999]"
        style="background: linear-gradient(to top, rgb(var(--from) / 0.7), rgb(var(--from) / 0.4) 50%, rgb(var(--from) / 0.7))"
        @click.self="close"
      />
    </transition>

    <!-- Modal card -->
    <transition name="modal-panel">
      <div
        v-if="visible"
        class="fixed inset-0 z-[9999] flex items-center justify-center pointer-events-none p-6"
      >
        <div
          class="bg-from rounded-xl border border-white/10 shadow-2xl w-full max-w-3xl overflow-hidden pointer-events-auto"
          @click.self="close"
        >
          <!-- Header -->
          <div class="flex items-center justify-between px-5 py-4">
            <div class="flex-1 min-w-0 pr-4">
              <h2 class="font-semibold text-white text-lg truncate">{{ title }}</h2>
              <p
                v-if="description"
                class="text-sm text-white/40 truncate mt-0.5"
                v-html="parseDesc(description)"
              />
            </div>
            <button
              class="flex-shrink-0 w-9 h-9 rounded-lg bg-white/5 hover:bg-white/10 flex items-center justify-center text-white/50 hover:text-white transition-colors text-sm"
              @click="close"
            >
              ✕
            </button>
          </div>

          <!-- Image frame: padding around + darker main-tinted background -->
          <div class="px-5 pb-5">
            <div
              class="rounded-lg p-3"
              style="background: rgb(var(--main) / 0.08)"
            >
              <div v-if="imgError" class="flex flex-col items-center justify-center py-12 text-white/30">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                  <rect x="3" y="3" width="18" height="18" rx="2" />
                  <circle cx="8.5" cy="8.5" r="1.5" />
                  <path d="M21 15l-5-5L5 21" />
                </svg>
                <p class="text-xs mt-2">Imagem não encontrada</p>
              </div>
              <img
                v-else
                :src="src"
                :alt="alt || title || ''"
                class="w-full object-contain max-h-[65vh] rounded"
                @error="imgError = true"
              />
            </div>
          </div>
        </div>
      </div>
    </transition>
  </Teleport>
</template>

<style scoped>
.modal-bg-enter-active {
  transition: opacity 0.3s ease;
}
.modal-bg-leave-active {
  transition: opacity 0.3s ease 0.2s;
}
.modal-bg-enter-from,
.modal-bg-leave-to {
  opacity: 0;
}

.modal-panel-enter-active {
  transition: opacity 0.3s ease 0.2s, transform 0.3s ease 0.2s;
}
.modal-panel-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.modal-panel-enter-from,
.modal-panel-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>
