<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";
import { useSettingsStore } from "@stores/settings";
import { themeState } from "@stores/theme";

// ==================== DICAS / SLIDER ====================
// Carousel de dicas/regras que aparece ao clicar no botão "Dicas".
// As imagens e textos vêm do handover (window.nuiHandoverData.tips).
// Padrão visual replicado do tostudy/index.html (class="slider-container").
// O autoplay intervalo pode ser ajustado via settings.autoplayInterval (ms).

const settings = useSettingsStore();
const currentSlide = ref(0);
let autoplayInterval = null;

const slides = computed(() => settings.tipsSlides ?? []);
const totalSlides = computed(() => slides.value.length);

const cardTitle = computed(() => slides.value[currentSlide.value]?.title ?? "");
const cardDescription = computed(() => slides.value[currentSlide.value]?.description ?? "");

const goToSlide = (index) => {
    currentSlide.value = index;
    resetAutoplay();
};

const nextSlide = () => {
    currentSlide.value = (currentSlide.value + 1) % totalSlides.value;
};

const startAutoplay = () => {
    const delay = settings.autoplayInterval ?? 5000;
    autoplayInterval = setInterval(nextSlide, delay);
};

const resetAutoplay = () => {
    if (autoplayInterval) clearInterval(autoplayInterval);
    startAutoplay();
};

onMounted(() => {
    if (totalSlides.value > 1) startAutoplay();
});

onUnmounted(() => {
    if (autoplayInterval) clearInterval(autoplayInterval);
});
</script>

<template>
    <div
        class="w-80 h-[28rem] rounded-xl overflow-hidden relative"
        :class="themeState.loading?.mode === 'light' ? 'bg-black/56' : 'bg-black/56'"
    >
        <!-- Slider track com transição -->
        <div class="absolute inset-0 overflow-hidden">
            <div
                class="flex h-full transition-transform duration-500 ease-in-out"
                :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
            >
                <div
                    v-for="(tip, i) in slides"
                    :key="i"
                    class="min-w-full h-full relative overflow-hidden"
                >
                    <img
                        :src="tip.image"
                        :alt="tip.title"
                        class="absolute inset-0 w-full h-full object-cover"
                    />
                </div>
            </div>
        </div>

        <!-- Overlay gradiente (cobre todo o container, acima das imagens) -->
        <div
            class="absolute inset-0 pointer-events-none z-[5]"
            style="background: linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.85) 100%);"
        />

        <!-- Conteúdo: título + descrição -->
        <div class="absolute bottom-0 left-0 right-0 z-10 px-5 pb-14">
            <h3 class="text-lg font-bold text-white uppercase tracking-wide mb-1">
                {{ cardTitle }}
            </h3>
            <p class="text-xs text-white/80 leading-relaxed" v-html="cardDescription" />
        </div>

        <!-- Pagination dots -->
        <div class="absolute bottom-4 left-1/2 -translate-x-1/2 z-10 flex gap-2">
            <button
                v-for="(_, i) in slides"
                :key="i"
                @click="goToSlide(i)"
                :class="[
                    'w-2.5 h-2.5 rounded-full transition-all cursor-pointer',
                    i === currentSlide
                        ? 'bg-white/85'
                        : 'bg-white/50 hover:bg-white/60',
                ]"
            />
        </div>
    </div>
</template>
