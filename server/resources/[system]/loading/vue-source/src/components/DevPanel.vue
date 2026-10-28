<script setup>
import { ref } from "vue";
import { themeState } from "@stores/theme";
import { useSettingsStore } from "@stores/settings";
import applyTheme from "@utils/applyTheme";

// ==================== PAINEL DE DEV (SÓ NO npm run dev) ====================
// Botão flutuante para testar todos os estilos da loading screen no
// navegador: modelo (1/2), tema (dark/light), cor principal e os toggles do
// shared-side (Música/Atalhos/Progresso/Classificação). Só existe em dev —
// o App.vue importa dinamicamente dentro de import.meta.env.DEV, então no
// build (produção) este componente não entra no bundle.

const settings = useSettingsStore();
const open = ref(false);

const COLORS = [
    { label: "Verde", main: "#66ad43" },
    { label: "Blurple", main: "#2e8b57" },
    { label: "Vermelho", main: "#e03131" },
    { label: "Cinza", main: "#9b9b9b" }, // saturação 0 → modo grayscale
];

const TOGGLES = [
    { key: "autoplay", label: "Música" },
    { key: "shortcuts", label: "Atalhos" },
    { key: "progressVisible", label: "Progresso" },
    { key: "classification", label: "Classificação" },
];

const AGE_PRESETS = [
    { age: 0, label: "Livre" },
    { age: 10, label: "10" },
    { age: 12, label: "12" },
    { age: 14, label: "14" },
    { age: 16, label: "16" },
    { age: 18, label: "18" },
    { age: 21, label: "21" },
];

// Troca a cor mantendo o modelo/tema atuais.
const setColor = (main) => {
    applyTheme({
        main,
        mainText: "#ffffff",
        loading: themeState.value.loading,
    });
};

const setModel = (model) => {
    themeState.value.loading = { ...themeState.value.loading, model };
};

const setMode = (mode) => {
    themeState.value.loading = { ...themeState.value.loading, mode };
};
</script>

<template>
    <div class="fixed top-4 right-4 z-50 flex flex-col items-end gap-2">
        <button
            @click="open = !open"
            class="rounded-lg px-3 py-1.5 text-sm font-extrabold tracking-wide bg-black/70 text-white/90 backdrop-blur-[0.5rem] border border-white/15 cursor-pointer"
        >
            DEV{{ open ? " ✕" : "" }}
        </button>

        <transition name="fade-down">
            <div
                v-show="open"
                class="w-60 rounded-lg bg-black/75 backdrop-blur-[0.5rem] border border-white/15 p-3 space-y-3 text-white/90"
            >
                <!-- Modelo -->
                <div>
                    <p class="text-[0.625rem] uppercase tracking-widest opacity-50 mb-1.5">Modelo</p>
                    <div class="flex gap-1">
                        <button
                            v-for="m in [1, 2]"
                            :key="m"
                            @click="setModel(m)"
                            :class="[
                                'flex-1 rounded-md py-1 text-sm font-bold transition-colors cursor-pointer',
                                themeState.loading?.model === m ? 'bg-main text-mainText' : 'bg-white/10 hover:bg-white/20',
                            ]"
                        >
                            {{ m }}
                        </button>
                    </div>
                </div>

                <!-- Tema -->
                <div>
                    <p class="text-[0.625rem] uppercase tracking-widest opacity-50 mb-1.5">Tema</p>
                    <div class="flex gap-1">
                        <button
                            v-for="mode in ['dark', 'light']"
                            :key="mode"
                            @click="setMode(mode)"
                            :class="[
                                'flex-1 rounded-md py-1 text-sm font-bold capitalize transition-colors cursor-pointer',
                                themeState.loading?.mode === mode ? 'bg-main text-mainText' : 'bg-white/10 hover:bg-white/20',
                            ]"
                        >
                            {{ mode }}
                        </button>
                    </div>
                </div>

                <!-- Cor -->
                <div>
                    <p class="text-[0.625rem] uppercase tracking-widest opacity-50 mb-1.5">Cor</p>
                    <div class="grid grid-cols-2 gap-1">
                        <button
                            v-for="c in COLORS"
                            :key="c.main"
                            @click="setColor(c.main)"
                            class="rounded-md py-1 px-2 text-xs font-bold bg-white/10 hover:bg-white/20 transition-colors cursor-pointer"
                        >
                            {{ c.label }}
                        </button>
                    </div>
                </div>

                <!-- Opções -->
                <div>
                    <p class="text-[0.625rem] uppercase tracking-widest opacity-50 mb-1.5">Opções</p>
                    <div class="grid grid-cols-2 gap-1">
                        <button
                            v-for="t in TOGGLES"
                            :key="t.key"
                            @click="settings[t.key] = !settings[t.key]"
                            :class="[
                                'rounded-md py-1 px-2 text-xs font-bold transition-colors cursor-pointer',
                                settings[t.key] ? 'bg-main text-mainText' : 'bg-white/10 hover:bg-white/20',
                            ]"
                        >
                            {{ settings[t.key] ? "✓" : "" }} {{ t.label }}
                        </button>
                    </div>
                </div>
                <!-- Classificação Indicativa -->
                <div>
                    <p class="text-[0.625rem] uppercase tracking-widest opacity-50 mb-1.5">Idade (Classificação)</p>
                    <div class="grid grid-cols-4 gap-1">
                        <button
                            v-for="a in AGE_PRESETS"
                            :key="a.age"
                            @click="settings.classificationAge = a.age"
                            :class="[
                                'rounded-md py-1 px-1.5 text-xs font-bold transition-colors cursor-pointer',
                                settings.classificationAge === a.age ? 'bg-main text-mainText' : 'bg-white/10 hover:bg-white/20',
                            ]"
                        >
                            {{ a.label }}
                        </button>
                    </div>
                    <div class="flex items-center gap-2 mt-1.5">
                        <input
                            type="range"
                            :min="0"
                            :max="21"
                            v-model.number="settings.classificationAge"
                            class="flex-1 accent-white/50"
                        />
                        <span class="text-xs font-bold w-6 text-center">{{ settings.classificationAge }}</span>
                    </div>
                </div>
            </div>
        </transition>
    </div>
</template>
