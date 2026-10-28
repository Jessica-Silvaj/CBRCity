<script setup>
import { ref } from "vue";
import { useSettingsStore } from "@stores/settings";
import { themeState } from "@stores/theme";
import Audio from "./Audio.vue";
import Dicas from "./Dicas.vue";
import Shortcuts from "./Shortcuts.vue";
import Socials from "./Socials.vue";
import Spinner from "./Spinner.vue";
import Classification from "./Classification.vue";
import Lightbulb from "@icons/Lightbulb.vue";
import Music from "@icons/Music.vue";
import Keyboard from "@icons/Keyboard.vue";

// ==================== MODELO 2 (PADRÃO ATUAL) ====================
// Redes sociais no topo, widgets (player de música + painel de atalhos) e o
// progresso "Carregando" na base à esquerda, e o selo de classificação
// indicativa no canto inferior direito.

const settings = useSettingsStore();
const showDicas = ref(true);
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
    <div class="relative flex flex-col justify-between size-full p-16">
        <!-- Redes sociais -->
        <div v-if="settings.socials.length" class="flex items-center gap-2">
            <Socials
                v-for="social in settings.socials"
                :key="social.type"
                :type="social.type"
                :url="social.url"
            />
        </div>

        <!-- Base: widgets/progresso à esquerda, classificação à direita -->
        <div class="flex items-end justify-between gap-4">
            <div class="space-y-4">
                <div class="flex items-stretch gap-4 relative">
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

                    <!-- Botão de dicas -->
                    <button
                        v-if="settings.tips"
                        @click="toggleDicas"
                        :class="[
                        'backdrop-blur-[0.5rem] rounded-lg py-2 px-4 flex items-center gap-2 transition-colors',
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
                    <Lightbulb class="w-5 h-5 min-w-5" />
                    <p>Dicas</p>
                </button>

                    <!-- Botão de música -->
                    <button
                        v-if="settings.playlist.length"
                        @click="toggleMusic"
                        :class="[
                        'backdrop-blur-[0.5rem] rounded-lg py-2 px-4 flex items-center gap-2 transition-colors',
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
                    <Music class="w-5 h-5 min-w-5" />
                    <p>Música</p>
                </button>

                    <!-- Botão de atalhos -->
                    <button
                        v-if="settings.shortcuts"
                        @click="toggleShortcuts"
                        :class="[
                            'backdrop-blur-[0.5rem] rounded-lg py-2 px-4 flex items-center gap-2 transition-colors',
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
                        <Keyboard class="w-5 h-5 min-w-5" />
                        <p>Atalhos</p>
                    </button>
                </div>

                <!-- Progresso do carregamento -->
                <div v-if="settings.progressVisible" class="flex items-stretch gap-4">
                    <div
                        :class="[
                            'backdrop-blur-[0.5rem] rounded-lg py-2 px-4 flex items-center gap-2',
                            themeState.loading?.mode === 'light' ? 'bg-white/10' : 'bg-from/40',
                        ]"
                    >
                        <p>Carregando</p>
                        <Spinner class="w-4 h-4" />
                    </div>
                    <div
                        :class="[
                            'backdrop-blur-[0.5rem] rounded-lg py-2 px-4 flex items-center gap-4 w-96',
                            themeState.loading?.mode === 'light' ? 'bg-white/10' : 'bg-from/40',
                        ]"
                    >
                        <div class="flex-1 bg-white/15 rounded-full h-1.5">
                            <div
                                class="h-full bg-white rounded-full"
                                :style="{ width: settings.progress + '%' }"
                            ></div>
                        </div>
                        <p>{{ Math.floor(settings.progress) }}%</p>
                    </div>
                </div>
            </div>

            <!-- Selo de classificação indicativa (canto inferior direito) -->
            <Classification />
        </div>
    </div>
</template>
