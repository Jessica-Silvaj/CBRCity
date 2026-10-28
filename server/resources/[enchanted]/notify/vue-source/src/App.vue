<script setup>
import { onMounted } from "vue";
import {
  notifications,
  addNotification,
  removeNotification,
  showVehicle,
} from "@composables/useNotifications";
import DefaultNotify from "@components/DefaultNotify.vue";
import VehicleNotify from "@components/VehicleNotify.vue";

const positions = [
  { name: "middle-left",   ulClasses: ["justify-center"], liClasses: ["items-start"] },
  { name: "middle-right",  ulClasses: ["justify-center"], liClasses: ["items-end"] },
  { name: "top-left",      ulClasses: [],                 liClasses: ["items-start"] },
  { name: "top-center",    ulClasses: [],                 liClasses: ["items-center"] },
  { name: "top-right",     ulClasses: [],                 liClasses: ["items-end"] },
  { name: "bottom-left",   ulClasses: ["justify-end"],    liClasses: ["items-start"] },
  { name: "bottom-center", ulClasses: ["justify-end"],    liClasses: ["items-center"] },
  { name: "bottom-right",  ulClasses: ["justify-end"],    liClasses: ["items-end"] },
];

const VEHICLE_TIMEOUT = 5000;
let vehicleTimer = null;

onMounted(() => {
  window.addEventListener("message", (event) => {
    const { Action, Payload } = event.data;

    if (Action === "Notify") {
      const { Title, Message, Timer, Theme, Position, Progress } = Payload;

      const id = addNotification(Position, {
        title: Title,
        message: Message,
        timer: Timer,
        theme: Theme,
        progress: Progress,
      });

      setTimeout(() => {
        removeNotification(Position, id);
      }, Timer);
    }

    if (Action === "Vehicle") {
      clearTimeout(vehicleTimer);
      const id = showVehicle(!!Payload);
      vehicleTimer = setTimeout(() => {
        removeNotification("bottom-center", id);
      }, VEHICLE_TIMEOUT);
    }
  });
});
</script>

<template>
  <div class="size-full flex items-center justify-center pointer-events-none">
    <TransitionGroup
      v-for="pos in positions"
      :key="pos.name"
      :name="pos.name"
      tag="ul"
      class="absolute size-full flex flex-col gap-4 z-[999] py-10"
      :class="pos.ulClasses"
    >
      <li
        v-for="notif in notifications[pos.name]"
        :key="notif.id"
        class="flex flex-col w-full px-10"
        :class="pos.liClasses"
      >
        <DefaultNotify
          v-if="notif.type === 'default'"
          :notification="notif"
        />
        <VehicleNotify
          v-else-if="notif.type === 'vehicle'"
          :locked="notif.locked"
        />
      </li>
    </TransitionGroup>
  </div>
</template>
