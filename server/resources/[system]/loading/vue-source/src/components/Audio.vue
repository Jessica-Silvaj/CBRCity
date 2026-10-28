<script setup>
import { computed, onMounted, onUnmounted, reactive, ref, watch } from "vue";
import { Howl, Howler } from "howler";
import { useSettingsStore } from "@stores/settings";
import { themeState } from "@stores/theme";
import formatTime from "@utils/formatTime";
import Spinner from "./Spinner.vue";
import Scrubber from "./Scrubber.vue";
import SkipBack from "@icons/SkipBack.vue";
import SkipForward from "@icons/SkipForward.vue";
import Play from "@icons/Play.vue";
import Pause from "@icons/Pause.vue";
import Volume from "@icons/Volume.vue";
import VolumeMuted from "@icons/VolumeMuted.vue";

// ==================== PLAYER DE MÚSICA ====================
// Toca a playlist enviada no handover (Playlist no shared-side/shared.lua).
// As músicas ficam em web-side/audio/<file> e são tocadas com howler.js.

const settings = useSettingsStore();

let seekInterval = null;

const loading = ref(true);
const state = reactive({ playing: false, track: 0, duration: 0, seek: 0 });
const volume = ref(0.5);

const current = computed(
    () =>
        settings.playlist[state.track] ?? { name: "Sem título", artist: "Desconhecido", file: "" },
);

class Player {
    constructor(tracks) {
        this.tracks = tracks;
        this.index = 0;
    }

    play(track) {
        loading.value = true;
        const index = typeof track === "number" ? track : this.index;
        const item = this.tracks[index];
        if (!item) return;

        let howl;
        if (item.howl) {
            // Já carregado: retoma a reprodução (loop entre faixas/volta)
            loading.value = false;
            howl = item.howl;
            state.duration = Math.round(howl.duration());
            howl.play();
            this.index = index;
            state.track = index;
            state.playing = true;
            this.startSeekLoop(howl);
        } else {
            howl = item.howl = new Howl({
                src: "./audio/" + item.file,
                autoplay: true,
                html5: true,
                volume: volume.value,
                onplay: () => {
                    state.seek = Math.round(howl.seek() || 0);
                },
                onload: () => {
                    loading.value = false;
                    state.track = index;
                    state.duration = Math.round(howl.duration());
                },
                onend: () => {
                    this.skip("next");
                },
            });
            this.startSeekLoop(howl);
            howl.play();
            this.index = index;
            state.track = index;
            state.playing = true;
        }
    }

    startSeekLoop(howl) {
        if (seekInterval) clearInterval(seekInterval);
        seekInterval = setInterval(() => {
            if (howl.playing()) state.seek = Math.round(howl.seek() || 0);
        }, 1000);
    }

    pause() {
        const item = this.tracks[this.index];
        if (!item || !item.howl) return;
        item.howl.pause();
        state.playing = false;
        if (seekInterval) {
            clearInterval(seekInterval);
            seekInterval = null;
        }
    }

    skip(direction) {
        let index = 0;
        if (direction === "prev") {
            index = this.index - 1;
            if (index < 0) index = this.tracks.length - 1;
        } else {
            index = this.index + 1;
            if (index >= this.tracks.length) index = 0;
        }
        this.skipTo(index);
    }

    skipTo(index) {
        state.seek = 0;
        if (seekInterval) {
            clearInterval(seekInterval);
            seekInterval = null;
        }
        const currentItem = this.tracks[this.index];
        if (currentItem?.howl) currentItem.howl.stop();
        this.play(index);
    }

    volume(value) {
        Howler.volume(value);
    }

    seek(ratio) {
        const item = this.tracks[this.index];
        if (!item || !item.howl) return;
        const howl = item.howl;
        if (howl.playing()) howl.seek(howl.duration() * ratio);
    }
}

const player = new Player(settings.playlist);

const toggle = () => {
    state.playing ? player.pause() : player.play();
};

watch(volume, (value) => player.volume(value));

onMounted(() => {
    player.volume(volume.value);
    player.play();
    if (!settings.autoplay) player.pause();
});

onUnmounted(() => {
    if (seekInterval) clearInterval(seekInterval);
});
</script>

<template>
    <div
        :class="[
            'w-80 rounded-lg py-3 px-4 backdrop-blur-[0.5rem] flex items-center gap-8',
            themeState.loading?.mode === 'light' ? 'bg-white/10' : 'bg-from/40',
        ]"
    >
        <div v-if="loading" class="w-full h-full flex items-center justify-center">
            <Spinner class="size-6" />
        </div>
        <div v-else class="w-full space-y-2">
            <div class="text-center">
                <h3 class="text-xs text-white/50 truncate">{{ current.artist }}</h3>
                <p class="text-sm font-extrabold">{{ current.name }}</p>
            </div>

            <div class="flex items-center justify-center gap-6">
                <p class="text-xs">{{ formatTime(state.seek) }}</p>
                <SkipBack
                    :class="[
                        'w-4 h-4 min-w-4 max-h-4',
                        settings.playlist.length <= 1
                            ? 'opacity-50 pointer-events-none'
                            : themeState.grayscale
                              ? 'cursor-pointer transition-all hover:text-white/50'
                              : 'cursor-pointer transition-all hover:text-main',
                    ]"
                    @click="player.skip('prev')"
                />
                <div
                    :class="[
                        'cursor-pointer transition-all',
                        themeState.grayscale ? 'hover:text-white/50' : 'hover:text-main',
                    ]"
                    @click="toggle"
                >
                    <Pause v-if="state.playing" class="size-4 min-w-4 max-h-4" />
                    <Play v-else class="size-4 min-w-4 max-h-4" />
                </div>
                <SkipForward
                    :class="[
                        'w-4 h-4 min-w-4 max-h-4',
                        settings.playlist.length <= 1
                            ? 'opacity-50 pointer-events-none'
                            : themeState.grayscale
                              ? 'cursor-pointer transition-all hover:text-white/50'
                              : 'cursor-pointer transition-all hover:text-main',
                    ]"
                    @click="player.skip('next')"
                />
                <p class="text-xs">{{ formatTime(state.duration) }}</p>
            </div>

            <div class="flex items-center gap-4">
                <Volume v-if="volume > 0" class="size-4 min-w-4" />
                <VolumeMuted v-else class="size-4 min-w-4" />
                <Scrubber v-model="volume" :max="1" class="w-full" />
            </div>
        </div>
    </div>
</template>
