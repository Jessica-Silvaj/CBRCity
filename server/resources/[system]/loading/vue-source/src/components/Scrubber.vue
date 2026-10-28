<script setup>
import { ref, watch } from "vue";
import { useEventListener, useMouseInElement, useVModel } from "@vueuse/core";
import { themeState } from "@stores/theme";

// ==================== SCRUBBER (BARRA ARRASTÁVEL) ====================
// Usado no player de música para o volume (e para o tempo). Réplica fiel do
// bundle original: mouse down inicia o arrasto, mouseup finaliza, e o valor é
// emitido via update:modelValue enquanto arrasta.

const props = defineProps({
    min: { default: 0 },
    max: { default: 100 },
    modelValue: {},
});
const emit = defineEmits(["update:modelValue"]);

const scrubber = ref(null);
const dragging = ref(false);
const pending = ref(0);

const model = useVModel(props, "modelValue", emit);
const { elementX, elementWidth } = useMouseInElement(scrubber);

useEventListener("mouseup", () => {
    dragging.value = false;
});

watch([dragging, elementX], () => {
    const ratio = Math.max(0, Math.min(1, elementX.value / elementWidth.value));
    pending.value = ratio * props.max;
    if (dragging.value) model.value = pending.value;
});
</script>

<template>
    <div
        ref="scrubber"
        class="relative h-1.5 rounded-full cursor-pointer select-none bg-white/10"
        @mousedown="dragging = true"
    >
        <div class="relative overflow-hidden h-full w-full rounded-full">
            <div
                :class="[
                    'relative h-full w-full rounded-full',
                    themeState.grayscale ? 'bg-white' : 'bg-main',
                ]"
                :style="{ transform: `translateX(${(model / max) * 100 - 100}%)` }"
            ></div>
        </div>
        <div
            :class="['absolute inset-0 hover:opacity-100 opacity-0', { '!opacity-100': dragging }]"
        >
            <slot :pendingValue="pending" :position="`${Math.max(0, Math.min(elementX, elementWidth))}px`"></slot>
        </div>
    </div>
</template>
