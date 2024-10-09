<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'
import User from './components/User.vue'
import NavBar from './components/NavBar.vue'
</script>

<template>
  <header>
      <NavBar />
      <User />
  </header>
</template>
