<script setup>
import { computed } from "vue";
import { useSettingsStore } from "@stores/settings";
import { themeState } from "@stores/theme";
// Diretiva registrada automaticamente no <script setup> pelo nome vTooltip.
import vTooltip from "@directives/tooltip";

// ==================== TECLA DO TECLADO (PAINEL DE ATALHOS) ====================
// Teclas com atalho configurado (Keybindings no shared-side/shared.lua) ganham
// o anel na cor do tema + tooltip com o texto do atalho no hover.

const props = defineProps({
    identifier: {},
    colSpan: { default: 2 },
    top: Boolean,
    bottomEnter: Boolean,
    enter: Boolean,
    transparent: Boolean,
    small: Boolean,
    xsmall: Boolean,
});

const settings = useSettingsStore();

const hasShortcut = computed(
    () => props.identifier && settings.keybindings[props.identifier],
);

const keyClasses = computed(() => ({
    // A tecla Enter desenha a extensão inferior (o "rabo" do Enter)
    "after:absolute after:right-0.5 after:top-full after:w-[calc(66.666667%-0.25rem)] after:h-1 after:-mt-0.5": props.enter,
    "after:bg-from/40": props.enter && themeState.value.loading?.mode !== "light",
    "after:bg-white/10": props.enter && themeState.value.loading?.mode === "light",
    "mb-2": props.top,
    "col-span-1": props.colSpan === 1,
    "col-span-2": props.colSpan === 2,
    "col-span-3": props.colSpan === 3,
    "col-span-4": props.colSpan === 4,
    "col-span-6": props.colSpan === 6,
    "col-[span_16_/_span_16]": props.colSpan === 16,
}));
</script>

<template>
    <div
        v-tooltip="identifier && settings.keybindings[identifier] || ''"
        :class="['relative p-0.5 h-16', keyClasses]"
    >
        <div
            :class="[
                'relative overflow-hidden rounded-lg w-full h-full flex items-center justify-center',
                {
                    'rounded-t-none': bottomEnter,
                    'rounded-br-none': enter,
                    'bg-from/40': !transparent && themeState.loading?.mode !== 'light',
                    'bg-white/10': !transparent && themeState.loading?.mode === 'light',
                    'text-sm leading-4': small && !xsmall,
                    'text-xs leading-3': xsmall && !small,
                    'ring-1 after:absolute after:top-0 after:left-0 after:size-full': hasShortcut,
                    'ring-main after:bg-main/20 transition-colors hover:bg-main hover:text-mainText':
                        hasShortcut && !themeState.grayscale,
                    'ring-white after:bg-white/20 transition-colors hover:bg-white hover:text-from':
                        hasShortcut && themeState.grayscale,
                },
            ]"
        >
            <span class="relative z-10"><slot /></span>
        </div>
    </div>
</template>
