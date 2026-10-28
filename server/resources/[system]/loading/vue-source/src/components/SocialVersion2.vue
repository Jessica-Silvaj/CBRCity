<script setup>
import { themeState } from "@stores/theme";

// ==================== BOTÃO SOCIAL (MODELO 2) ====================
// Apenas o ícone, com a sublinha na cor do tema no hover.
const props = defineProps({
    url: {},
    up: {},
    down: {},
    icon: {},
});

const open = () => window.invokeNative?.("openUrl", props.url);
</script>

<template>
    <a
        :href="url"
        target="_blank"
        rel="noopener noreferrer"
        @click="open"
        :class="[
            'rounded-lg p-3 flex items-center gap-4 transition-colors backdrop-blur-[0.5rem] after:absolute after:-bottom-2 after:left-1/2 after:-translate-x-1/2 after:w-3/4 after:h-0.5 after:rounded-full after:opacity-0 after:transition-opacity hover:after:opacity-100',
            themeState.grayscale
                ? 'hover:bg-white hover:text-from after:bg-white'
                : 'hover:bg-main hover:text-mainText after:bg-main',
            themeState.loading?.mode === 'light' ? 'bg-white/10' : 'bg-from/40',
        ]"
    >
        <component :is="icon" class="w-6 h-6" />
    </a>
</template>
