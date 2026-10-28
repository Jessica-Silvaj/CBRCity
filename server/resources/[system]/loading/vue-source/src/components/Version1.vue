<script setup>
import { ref } from "vue";
import { useSettingsStore } from "@stores/settings";
import { themeState } from "@stores/theme";
import Audio from "./Audio.vue";
import Dicas from "./Dicas.vue";
import Shortcuts from "./Shortcuts.vue";
import Socials from "./Socials.vue";
import Progressbar from "./Progressbar.vue";
import Classification from "./Classification.vue";
import Lightbulb from "@icons/Lightbulb.vue";
import Music from "@icons/Music.vue";
import Keyboard from "@icons/Keyboard.vue";

// ==================== MODELO 1 ====================
// Overlay na parte inferior da tela (gradiente a partir da base), com o player
// de música, dicas, atalhos e redes sociais à direita e a
// barra de progresso (SVG equalizer) na base. Alternativa ao modelo 2 via
// Theme.loading.model = 1.

const settings = useSettingsStore();
const showDicas = ref(false);
const showMusic = ref(false);
const showShortcuts = ref(false);

const toggleDicas = () => {
    showMusic.value = false;
    showShortcuts.value = false;
    showDicas.value = !showDicas.value;
};

const toggleMusic = () => {
    showDicas.value = false;
    showShortcuts.value = false;
    showMusic.value = !showMusic.value;
};

const toggleShortcuts = () => {
    showDicas.value = false;
    showMusic.value = false;
    showShortcuts.value = !showShortcuts.value;
};
</script>

<template>
    <div
        :class="[
            'fixed top-0 left-0 size-full flex flex-col justify-end gap-4 p-16',
            settings.progressVisible ? 'bg-default' : 'bg-default-without-progress',
        ]"
    >
        <div class="flex items-end justify-between gap-4">
            <!-- LADO ESQUERDO: botões de dicas, música e atalhos -->
            <div class="relative">
                <!-- Slider de dicas (abre acima do botão) -->
                <transition name="fade-down">
                    <div v-show="showDicas" class="absolute bottom-full mb-4">
                        <Dicas v-if="settings.tips" />
                    </div>
                </transition>

                <!-- Player de música (abre acima do botão) -->
                <transition name="fade-down">
                    <div v-show="showMusic" class="absolute bottom-full mb-4">
                        <Audio v-if="settings.playlist.length" />
                    </div>
                </transition>

                <!-- Painel de atalhos (abre acima do botão) -->
                <transition name="fade-down">
                    <div v-show="showShortcuts" class="absolute bottom-full left-0 mb-4">
                        <Shortcuts />
                    </div>
                </transition>

                <div class="flex items-center gap-2">
                    <!-- Botão de dicas -->
                    <button
                        v-if="settings.tips"
                        @click="toggleDicas"
                        :class="[
                            'rounded-lg p-3 flex items-center gap-4 transition-colors backdrop-blur-[0.5rem] cursor-pointer',
                            themeState.grayscale ? 'hover:bg-white hover:text-from' : 'hover:bg-main hover:text-mainText',
                            showDicas
                                ? themeState.grayscale
                                    ? 'bg-white text-from'
                                    : 'bg-main text-mainText'
                                : themeState.loading?.mode === 'light'
                                  ? 'bg-white/10'
                                  : 'bg-from/40',
                        ]"
                    >
                        <Lightbulb class="w-6 h-6" />
                        <div>
                            <p class="text-[0.625rem] font-light leading-3 opacity-50 tracking-normal">
                                Veja nossas
                            </p>
                            <p class="text-lg font-extrabold leading-5 tracking-normal">Dicas</p>
                        </div>
                    </button>

                    <!-- Botão de música -->
                    <button
                        v-if="settings.playlist.length"
                        @click="toggleMusic"
                        :class="[
                            'rounded-lg p-3 flex items-center gap-4 transition-colors backdrop-blur-[0.5rem] cursor-pointer',
                            themeState.grayscale ? 'hover:bg-white hover:text-from' : 'hover:bg-main hover:text-mainText',
                            showMusic
                                ? themeState.grayscale
                                    ? 'bg-white text-from'
                                    : 'bg-main text-mainText'
                                : themeState.loading?.mode === 'light'
                                  ? 'bg-white/10'
                                  : 'bg-from/40',
                        ]"
                    >
                        <Music class="w-6 h-6" />
                        <div>
                            <p class="text-[0.625rem] font-light leading-3 opacity-50 tracking-normal">
                                Ouça
                            </p>
                            <p class="text-lg font-extrabold leading-5 tracking-normal">Música</p>
                        </div>
                    </button>

                    <!-- Botão de atalhos -->
                    <button
                        v-if="settings.shortcuts"
                        @click="toggleShortcuts"
                        :class="[
                            'rounded-lg p-3 flex items-center gap-4 transition-colors backdrop-blur-[0.5rem] cursor-pointer',
                            themeState.grayscale ? 'hover:bg-white hover:text-from' : 'hover:bg-main hover:text-mainText',
                            showShortcuts
                                ? themeState.grayscale
                                    ? 'bg-white text-from'
                                    : 'bg-main text-mainText'
                                : themeState.loading?.mode === 'light'
                                  ? 'bg-white/10'
                                  : 'bg-from/40',
                        ]"
                    >
                        <Keyboard class="w-6 h-6" />
                        <div>
                            <p class="text-[0.625rem] font-light leading-3 opacity-50 tracking-normal">
                                Veja nossos
                            </p>
                            <p class="text-lg font-extrabold leading-5 tracking-normal">Atalhos</p>
                        </div>
                    </button>
                </div>
            </div>

            <!-- LADO DIREITO: redes sociais + classificação -->
            <div v-if="settings.socials.length || settings.classification" class="flex items-center gap-2">
                <Socials
                    v-for="social in settings.socials"
                    :key="social.type"
                    :type="social.type"
                    :url="social.url"
                />

                <!-- Selo de classificação indicativa -->
                <Classification />
            </div>
        </div>

        <Progressbar v-if="settings.progressVisible" />
    </div>
</template>
