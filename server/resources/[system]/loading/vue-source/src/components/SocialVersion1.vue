<script setup>
import { themeState } from "@stores/theme";

// ==================== BOTÃO SOCIAL (MODELO 1) ====================
// Ícone + rótulo de duas linhas ("Entre em nosso" / "Discord").
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
            'rounded-lg p-3 flex items-center gap-3 transition-colors backdrop-blur-[0.5rem]',
            themeState.grayscale ? 'hover:bg-white hover:text-from' : 'hover:bg-main hover:text-mainText',
            themeState.loading?.mode === 'light' ? 'bg-white/10' : 'bg-from/40',
        ]"
    >
        <component :is="icon" class="w-6 h-6" />
        <div>
            <p class="text-[0.625rem] font-light leading-3 opacity-50 tracking-normal">{{ up }}</p>
            <p class="text-lg font-extrabold leading-5 tracking-normal">{{ down }}</p>
        </div>
    </a>
</template>
