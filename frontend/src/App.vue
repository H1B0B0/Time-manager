<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router";
import NavBar from "./components/NavBar.vue";
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="w-full">
      <NavBar />
    </header>
    <main class="flex-grow pt-16">
      <RouterView />
    </main>
  </div>
</template>
