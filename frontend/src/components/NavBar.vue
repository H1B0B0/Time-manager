<template>
  <nav class="p-4 ">
    <div class="container mx-auto flex flex-wrap justify-between items-center">
      <div class="text-white text-lg font-bold">
        <router-link to="/" class="text-white">Time Manager</router-link>
      </div>
      <button @click="toggleMenu" class="lg:hidden text-white">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"></path>
        </svg>
      </button>
      <div :class="{'hidden': !menuOpen, 'block': menuOpen}" class="w-full lg:flex lg:items-center lg:w-auto mt-4 lg:mt-0">
        <ul class="flex flex-col lg:flex-row space-y-2 lg:space-y-0 lg:space-x-4">
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/clocks/1" class="text-white hover:text-blue-200">Clock in / Clock out</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/dashboard/1" class="text-white hover:text-blue-200">Dashboard</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/workingTimes/1" class="text-white hover:text-blue-200">Working Times</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/workingTime/1/1" class="text-white hover:text-blue-200">Working Time</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/chartManager/1" class="text-white hover:text-blue-200">Chart Manager</router-link>
          </li>
          <li v-if="!isHomePage" class="p-2">
            <router-link to="/news" class="text-white hover:text-blue-200">News</router-link>
          </li>
          <li class="border border-blue-950 p-2 rounded-lg hover:bg-indigo-950">
            <router-link to="/user" class="text-white">Sign in →</router-link>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router';
import { computed, ref } from 'vue';

const route = useRoute();
const isHomePage = computed(() => route.path === '/');
const showSignIn = true; // Always show Sign In
const menuOpen = ref(false);

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value;
};
</script>
