<script setup>
import { computed } from "vue";
import iconMap from "@utils/iconMap";

const props = defineProps({
  notification: {
    type: Object,
    required: true,
  },
});

const { title, message, timer, theme, progress } = props.notification;

const CIRCLE_CIRCUMFERENCE = 2 * Math.PI * 7;

const cssVars = computed(() => ({
  "--background": theme.background,
  "--title": theme.title,
  "--text": theme.text,
  "--bold": theme.bold,
  "--progress-background": theme.progress.background,
  "--progress-color": theme.progress.color,
  "--timeout": `${timer}ms`,
}));

const iconComponent = computed(() => {
  if (!theme.icon) return null;
  return iconMap[theme.icon.image] || iconMap.default;
});

/** Segundo background sutil com a cor do tema */
const accentGradient = computed(() => {
  const c = theme.border;
  return `linear-gradient(135deg, ${c}26, transparent 60%)`;
});
</script>

<template>
  <div
    class="relative overflow-hidden max-w-96 flex gap-3 px-5 py-4 rounded-md transition duration-200 items-center"
    :style="{ background: 'var(--background)', ...cssVars }"
  >
    <!-- Accent overlay — cor do tema sutil -->
    <div
      class="absolute inset-0 rounded-md pointer-events-none"
      :style="{ background: accentGradient }"
    ></div>

    <!-- Icon -->
    <div
      v-if="iconComponent"
      class="relative shrink-0 flex items-center justify-center"
      :style="{ width: '1.5rem', height: '1.5rem', color: 'var(--title)' }"
    >
      <component :is="iconComponent" class="size-full" />
    </div>

    <!-- Content -->
    <div class="relative flex-1 min-w-0">
      <h1 class="font-medium text-[var(--title)] text-sm leading-5">{{ title }}</h1>
      <p
        class="text-xs text-[var(--text)] [&>b]:text-[var(--bold)] [&>b]:font-bold leading-4"
        v-html="message"
      ></p>
    </div>

    <!-- Progress Circle -->
    <div v-if="progress === 'circle'" class="relative shrink-0">
      <svg class="size-[1.125rem] -rotate-90" viewBox="0 0 18 18">
        <circle
          r="7"
          cx="9"
          cy="9"
          fill="transparent"
          stroke-width="2"
          style="stroke: var(--progress-background)"
        />
        <circle
          r="7"
          cx="9"
          cy="9"
          fill="transparent"
          stroke-width="2"
          :stroke-dasharray="CIRCLE_CIRCUMFERENCE"
          :stroke-dashoffset="CIRCLE_CIRCUMFERENCE"
          class="transition-all animate-progresscircle"
          :style="{
            '--total-progress': 0,
            '--minimum-progress': CIRCLE_CIRCUMFERENCE,
            stroke: 'var(--progress-color)',
          }"
        />
      </svg>
    </div>

    <!-- Progress Bar -->
    <div
      v-else-if="progress === 'bar'"
      class="absolute bottom-0 left-0 w-full h-1"
    >
      <div
        class="h-full animate-progressbar"
        :style="{ background: 'var(--progress-color)' }"
      ></div>
    </div>
  </div>
</template>
