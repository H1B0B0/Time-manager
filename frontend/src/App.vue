<script setup lang="ts">
import { RouterView } from "vue-router";
import NavBar from "./components/NavBar.vue";

import "https://unpkg.com/@splinetool/viewer@1.9.30/build/spline-viewer.js";
</script>

<template>
  <div class="min-h-screen flex flex-col relative">
    <header class="w-full z-20 bg-transparent">
      <NavBar />
    </header>

    <main
      class="flex-grow flex items-center justify-center bg-transparent z-10"
    >
      <spline-viewer
        class="absolute inset-0 w-full h-full"
        url="https://prod.spline.design/soRsUYV4PO0dCd6S/scene.splinecode"
      ></spline-viewer>
      <div class="z-20">
        <RouterView />
      </div>
    </main>
  </div>
</template>
