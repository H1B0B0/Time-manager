<template>
  <nav class="p-4">
    <div class="container mx-auto flex justify-between items-center">
      <div class="text-white text-lg">  <router-link to="/" class="text-white">Time Manager</router-link></div>
      <div v-if="!isHomePage || isHomePage && showSignIn">
        <ul class="flex space-x-4">
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/clocks/1" class="text-white">Clock in / Clock out</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/dashboard/1" class="text-white">Dashboard</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/workingTimes/1" class="text-white">Working Times</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/workingTime/1/1" class="text-white">Working Time</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/chartManager/1" class="text-white">Chart Manager</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/news" class="text-white">News</router-link>
          </li>
          <li  class="border border-blue-950 p-2 rounded-lg hover:bg-indigo-950">
            <router-link to="/user" class="text-white">Sign in →</router-link>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router';
import { computed } from 'vue';

const route = useRoute();
const isHomePage = computed(() => route.path === '/');
const showSignIn = true; // Always show Sign In
</script>
