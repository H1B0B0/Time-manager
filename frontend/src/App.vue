<script setup lang="ts">
import { RouterView } from "vue-router";
import NavBar from "./components/NavBar.vue";

import "https://unpkg.com/@splinetool/viewer@1.9.30/build/spline-viewer.js";
</script>

<template>
  <div class="min-h-screen flex flex-col relative bg-transparent">
    <spline-viewer
      class="absolute inset-0 w-full h-full z-0"
      url="https://prod.spline.design/8CeuKuE2uJNDDSt9/scene.splinecode"
    >
    </spline-viewer>

    <header class="w-full z-10 bg-transparent relative">
      <NavBar />
    </header>

    <main
      class="flex-grow flex items-center justify-center pt-16 z-10 relative"
    >
      <RouterView />
    </main>
  </div>
</template>
