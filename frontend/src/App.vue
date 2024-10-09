<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'
import User from './components/User.vue'
import NavBar from './components/NavBar.vue'
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="w-full">
      
    </header>
    <main class="flex-grow">
      <NavBar />
      <User />
    </main>
  </div>
</template>
