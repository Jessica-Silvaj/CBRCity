<script setup>
import Splash from "@icons/Splash.vue";
</script>

<template>
  <div class="absolute z-0 top-0 left-0 size-full bg-default pointer-events-none">
    <div class="opacity-50">
      <!-- Blob 1 (faint) -->
      <Splash class="absolute -top-[25rem] -left-[17.5rem] w-[50rem] h-[50rem] opacity-5 text-main" />

      <!-- Shadow circle 1 -->
      <div class="absolute -top-[34.5rem] -left-[30rem] w-[60rem] h-[60rem] opacity-40 bg-shadow-circle" />

      <!-- Blob 2 (stronger) -->
      <Splash class="absolute -top-[29.5rem] -left-[25rem] w-[50rem] h-[50rem] text-main opacity-50" />

      <!-- Shadow circle 2 -->
      <div class="absolute -top-[17.5rem] -left-[15.5rem] w-[60rem] h-[60rem] opacity-20 bg-shadow-circle" />
    </div>
  </div>
</template>