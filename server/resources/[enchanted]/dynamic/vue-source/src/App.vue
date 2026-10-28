<script setup>
import { onMounted, onUnmounted } from "vue";
import { useDynamicStore } from "@stores/dynamic";
import Background from "@components/Background.vue";
import MenuList from "@components/MenuList.vue";

const dynamic = useDynamicStore();

function handleMessage(event) {
  const action = event.data.Action || event.data.name;
  const payload = event.data.Payload || event.data.payload;

  switch (action) {
    case "Open":
      dynamic.open();
      break;
    case "Close":
      dynamic.close();
      break;
    case "AddMenu":
      if (payload) {
        dynamic.addMenu(
          payload.Title,
          payload.Description,
          payload.Id,
          payload.ParentId,
          payload.Image
        );
      }
      break;
    case "AddButton":
      if (payload) {
        dynamic.addButton(
          payload.Title,
          payload.Description,
          payload.Trigger,
          payload.Param,
          payload.ParentId,
          payload.Server,
          payload.Back
        );
      }
      break;
    case "AddProgress":
      if (payload) {
        dynamic.addProgress(
          payload.Title,
          payload.Description,
          payload.Value,
          payload.ParentId
        );
      }
      break;
  }
}

function handleKeydown(event) {
  if (event.key === "Escape" && dynamic.display) {
    dynamic.close();
    fetchNui("Close");
  }
}

import fetchNui from "@utils/fetchNui";

onMounted(() => {
  window.addEventListener("message", handleMessage);
  window.addEventListener("keydown", handleKeydown);
});

onUnmounted(() => {
  window.removeEventListener("message", handleMessage);
  window.removeEventListener("keydown", handleKeydown);
});
</script>

<template>
  <div class="size-full flex items-center justify-center">
    <transition name="bg-fade">
      <Background v-show="dynamic.visible" />
    </transition>
    <MenuList />
  </div>
</template>
