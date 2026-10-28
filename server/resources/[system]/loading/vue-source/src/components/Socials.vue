<script setup>
import { computed } from "vue";
import { themeState } from "@stores/theme";
import SocialVersion1 from "./SocialVersion1.vue";
import SocialVersion2 from "./SocialVersion2.vue";
import Discord from "@icons/Discord.vue";
import Facebook from "@icons/Facebook.vue";
import Instagram from "@icons/Instagram.vue";
import Tiktok from "@icons/Tiktok.vue";
import X from "@icons/X.vue";
import Youtube from "@icons/Youtube.vue";

// ==================== REDES SOCIAIS ====================
// Recebe o { type, url } de Socials (shared-side/shared.lua) e escolhe o
// estilo do botão conforme o modelo da interface (Theme.loading.model).

const props = defineProps({
    type: {},
    url: {},
});

const Component = computed(() =>
    themeState.value.loading?.model === 2 ? SocialVersion2 : SocialVersion1,
);

const meta = computed(() => {
    switch (props.type) {
        case "discord":
            return { up: "Entre em nosso", down: "Discord", icon: Discord };
        case "facebook":
            return { up: "Curta nossa página no", down: "Facebook", icon: Facebook };
        case "instagram":
            return { up: "Siga-nos no", down: "Instagram", icon: Instagram };
        case "tiktok":
            return { up: "Siga-nos no", down: "Tiktok", icon: Tiktok };
        case "x":
            return { up: "Siga-nos no", down: "X", icon: X };
        case "youtube":
            return { up: "Increva-se no", down: "Youtube", icon: Youtube };
        default:
            return null;
    }
});
</script>

<template>
    <component
        :is="Component"
        v-if="meta"
        :icon="meta.icon"
        :url="url"
        :up="meta.up"
        :down="meta.down"
    />
</template>
