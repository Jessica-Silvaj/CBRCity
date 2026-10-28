<script setup>
import { computed } from "vue";

const props = defineProps({
  locked: {
    type: Boolean,
    default: true,
  },
});

const cssVars = computed(() =>
  props.locked
    ? {
        "--background": "linear-gradient(90deg, #332413ec, #07090bec)",
        "--border": "#fda84f",
        "--title": "#fda84f",
        "--text": "#ffffff80",
        "--bold": "#ffffff",
        "--progress-background": "#ffffff40",
        "--progress-color": "#fda84f",
        "--timeout": "5000ms",
      }
    : {
        "--background": "linear-gradient(90deg, #13240fec, #070b0bec)",
        "--border": "#3fd794",
        "--title": "#3fd794",
        "--text": "#ffffff80",
        "--bold": "#ffffff",
        "--progress-background": "#ffffff40",
        "--progress-color": "#3fd794",
        "--timeout": "5000ms",
      },
);

const text = computed(() =>
  props.locked ? "Ve\u00EDculo trancado" : "Ve\u00EDculo destrancado",
);
</script>

<template>
  <div
    class="relative w-60 pb-2 [filter:drop-shadow(0_0_0.0625rem_rgb(0_0_0/0.5))_drop-shadow(0_0_0.125rem_rgb(0_0_0/0.5))_drop-shadow(0_0_0.275rem_rgb(0_0_0/0.25))]"
    :style="cssVars"
  >
    <div class="relative w-full flex items-center gap-2">
      <!-- Left line -->
      <div
        class="flex-1 h-1"
        :class="locked ? 'bg-gradient-to-l from-red-500' : 'bg-gradient-to-l from-green-500'"
      ></div>

      <!-- Lock icon (locked) -->
      <svg
        v-if="locked"
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        class="size-6 text-red-500"
      >
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M12 3.25C10.067 3.25 8.49999 4.817 8.49999 6.75V8.31016C9.61772 8.27048 10.7654 8.25 12 8.25C13.2346 8.25 14.3823 8.27048 15.5 8.31016V6.75C15.5 4.817 13.933 3.25 12 3.25ZM6.49999 6.75V8.52712C4.93232 9.00686 3.74924 10.3861 3.52451 12.0552C3.37635 13.1556 3.24999 14.3118 3.24999 15.5C3.24999 16.6882 3.37636 17.8444 3.52451 18.9448C3.79608 20.9618 5.46715 22.5555 7.52521 22.6501C8.95364 22.7158 10.4042 22.75 12 22.75C13.5958 22.75 15.0464 22.7158 16.4748 22.6501C18.5328 22.5555 20.2039 20.9618 20.4755 18.9448C20.6236 17.8444 20.75 16.6882 20.75 15.5C20.75 14.3118 20.6236 13.1556 20.4755 12.0552C20.2507 10.3861 19.0677 9.00686 17.5 8.52712V6.75C17.5 3.71243 15.0376 1.25 12 1.25C8.96243 1.25 6.49999 3.71243 6.49999 6.75ZM13 14.5C13 13.9477 12.5523 13.5 12 13.5C11.4477 13.5 11 13.9477 11 14.5V16.5C11 17.0523 11.4477 17.5 12 17.5C12.5523 17.5 13 17.0523 13 16.5V14.5Z"
          fill="currentColor"
        />
      </svg>

      <!-- Check icon (unlocked) -->
      <svg
        v-else
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        class="size-6 text-green-500"
      >
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M2.25 12C2.25 6.61522 6.61522 2.25 12 2.25C17.3848 2.25 21.75 6.61522 21.75 12C21.75 17.3848 17.3848 21.75 12 21.75C6.61522 21.75 2.25 17.3848 2.25 12ZM15.28 9.22C15.5729 8.92711 15.5729 8.45289 15.28 8.16C14.9871 7.86711 14.5129 7.86711 14.22 8.16L10.5 11.88L8.78 10.16C8.48711 9.86711 8.01289 9.86711 7.72 10.16C7.42711 10.4529 7.42711 10.9271 7.72 11.22L10.22 13.72C10.3605 13.8605 10.5512 13.9399 10.75 13.9399C10.9488 13.9399 11.1395 13.8605 11.28 13.72L15.28 9.22Z"
          fill="currentColor"
        />
      </svg>

      <!-- Right line -->
      <div
        class="flex-1 h-1"
        :class="locked ? 'bg-gradient-to-r from-red-500' : 'bg-gradient-to-r from-green-500'"
      ></div>
    </div>
    <p
      class="relative text-center font-semibold [filter:drop-shadow(0.0625rem_0.0625rem_0.0625rem_rgb(0_0_0/0.15))_drop-shadow(-0.0625rem_0.0625rem_0.0625rem_rgb(0_0_0/0.15))_drop-shadow(-0.0625rem_-0.0625rem_0.0625rem_rgb(0_0_0/0.15))_drop-shadow(0.0625rem_0.0625rem_0.0625rem_rgb(0_0_0/0.15))]"
    >
      {{ text }}
    </p>
  </div>
</template>
