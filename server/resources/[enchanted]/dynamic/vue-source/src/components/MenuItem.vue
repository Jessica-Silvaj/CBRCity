<script setup>
import { ref, computed } from "vue";
import { getIcon } from "@utils/iconMap";
import ArrowLeft from "@icons/ArrowLeft.vue";
import ImageModal from "@components/ImageModal.vue";

const props = defineProps([
  "title", "description", "type", "menuId", "trigger",
  "param", "server", "back", "index", "value", "image",
]);

const emit = defineEmits(["action"]);
const showModal = ref(false);
const thumbError = ref(false);

// Pre-compiled tag map — regex created once, not per-render
const TAG_MAP = [
  { re: /<rare>([^<]*)<\/rare>/gi, color: "rgb(var(--rare))" },
  { re: /<common>([^<]*)<\/common>/gi, color: "rgb(var(--common))" },
  { re: /<yellow>([^<]*)<\/yellow>/gi, color: "#f0c040" },
  { re: /<epic>([^<]*)<\/epic>/gi, color: "rgb(var(--epic))" },
  { re: /<legendary>([^<]*)<\/legendary>/gi, color: "rgb(var(--legendary))" },
  { re: /<mythic>([^<]*)<\/mythic>/gi, color: "rgb(var(--mythic))" },
  { re: /<span>([^<]*)<\/span>/gi, cls: "span-tag" },
];

const hasImage = computed(() => props.type === "menu" && !!props.image);
const isInteractive = computed(() => props.type === "back" || props.type === "menu" || (props.trigger && props.trigger !== ""));

const parsedDescription = computed(() => {
  const d = props.description;
  if (!d) return "";
  // Fast path: no tags at all
  if (!d.includes("<")) return d;
  let t = d;    for (const tag of TAG_MAP) {
    tag.re.lastIndex = 0;
    if (tag.cls) {
      t = t.replace(tag.re, `<span class="${tag.cls}">$1</span>`);
    } else {
      t = t.replace(tag.re, `<span style="color:${tag.color};font-weight:600">$1</span>`);
    }
  }
  return t;
});

const progressWidth = computed(() => `${Math.min(100, Math.max(0, props.value ?? 0))}%`);

const iconComponent = computed(() => {
  if (props.type === "back") return ArrowLeft;
  if (props.type === "menu") return getIcon(props.type, props.menuId, props.title);
  return null;
});

function openImage() { showModal.value = true; }
</script>

<template>
  <div class="w-full" style="contain: layout style">
    <!-- Main card -->
    <div
      class="relative w-full py-3 px-4"
      :class="[
        hasImage ? 'rounded-t-md' : 'rounded-md',
        isInteractive ? 'bg-from/50 hover:bg-main hover:text-mainText cursor-pointer group' : 'bg-from/50 cursor-default',
        'transition-[background-color,color,opacity] duration-150',
      ]"
      @click="emit('action')"
    >
      <div class="relative flex items-center gap-3">
        <!-- Icon -->
        <div
          v-if="type === 'back' || type === 'menu'"
          class="flex items-center justify-center w-10 h-10 min-w-10 rounded-lg bg-main/20 text-main transition-[background-color,color] duration-150 group-hover:bg-mainText/20 group-hover:text-mainText"
        >
          <component :is="iconComponent" class="w-5 h-5" />
        </div>

        <div class="flex-1 min-w-0">
          <h1 class="font-semibold">{{ title }}</h1>

          <!-- Progress bar -->
          <template v-if="type === 'progress'">
            <div class="mt-1.5 w-full">
              <div class="w-full h-1.5 rounded-full bg-white/10 overflow-hidden">
                <div
                  class="h-full rounded-full transition-all duration-500 ease-out"
                  :style="{ width: progressWidth, backgroundColor: 'rgb(var(--main))' }"
                />
              </div>
              <div class="flex items-center justify-between mt-1.5">
                <p class="text-xs text-white/40">{{ title }}</p>
                <span class="text-xs font-semibold text-main">{{ Math.round(value ?? 0) }}%</span>
              </div>
            </div>
          </template>

          <!-- Description with rich tags -->
          <template v-else>
            <p
              class="text-sm text-white/50 transition-[color] duration-150 group-hover:text-mainText/50"
              v-html="parsedDescription"
            />
          </template>
        </div>

        <!-- Chevron -->
        <svg
          v-if="type === 'menu'"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          width="20"
          height="20"
          fill="none"
          class="size-5 min-w-5 text-main transition-[color] duration-150 group-hover:text-mainText"
        >
          <path d="M9.00005 6C9.00005 6 15 10.4189 15 12C15 13.5812 9 18 9 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
        </svg>

        <svg
          v-else-if="type === 'back'"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          width="20"
          height="20"
          fill="none"
          class="size-5 min-w-5 text-main transition-[color] duration-150 group-hover:text-mainText"
        >
          <path d="M15 18l-6-6 6-6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </div>
    </div>

    <!-- Image thumbnail -->
    <div
      v-if="hasImage"
      class="relative w-full h-28 rounded-b-md overflow-hidden cursor-pointer bg-from group/img"
      @click="openImage"
    >
      <div v-if="thumbError" class="absolute inset-0 flex flex-col items-center justify-center bg-from">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-white/20">
          <rect x="3" y="3" width="18" height="18" rx="2" />
          <circle cx="8.5" cy="8.5" r="1.5" />
          <path d="M21 15l-5-5L5 21" />
        </svg>
        <span class="text-[0.6rem] text-white/20 mt-1">Indisponível</span>
      </div>
      <img v-else :src="image" loading="lazy" class="absolute inset-0 w-full h-full object-cover" alt="" @error="thumbError = true" />

      <!-- Gradient overlay -->
      <div
        class="absolute inset-0 pointer-events-none"
        style="background-image: linear-gradient(to top, rgb(var(--from) / 0.85), rgb(var(--from) / 0) 60%)"
      />

      <!-- Hover overlay -->
      <div class="absolute inset-0 bg-main/0 group-hover/img:bg-main/10 transition-[background-color] duration-150 pointer-events-none" />

      <!-- Text hint -->
      <div class="absolute bottom-0 left-0 right-0 px-3 pb-2.5 pointer-events-none">
        <span class="text-xs font-medium tracking-wide text-white/50 group-hover/img:text-white/80 transition-[color] duration-150">
          Clique para visualizar
        </span>
      </div>
    </div>

    <!-- Modal -->
    <ImageModal
      v-if="showModal"
      :src="image"
      :alt="title"
      :title="title"
      :description="description"
      @close="showModal = false"
    />
  </div>
</template>
