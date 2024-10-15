<template>
  <nav class="p-4 w-full flex items-center">
    <div class="container mx-auto flex items-center justify-between">
      <div class="text-white text-lg font-bold">
        <router-link to="/" class="text-white">Time Manager</router-link>
      </div>
      <div
        class="hidden lg:flex lg:flex-grow lg:justify-center lg:items-center lg:space-x-4"
      >
        <ul class="flex space-x-4">
          <li v-if="!isHomePage">
            <router-link
              to="/dashboard/1"
              class="text-white hover:text-blue-200"
              >Dashboard</router-link
            >
          </li>
          <li v-if="!isHomePage">
            <router-link to="/news" class="text-white hover:text-blue-200 mr-9"
              >News</router-link
            >
          </li>
        </ul>
      </div>
      <div class="hidden lg:flex ml-auto">
        <ul class="flex space-x-4">
          <li class="border border-blue-950 p-2 rounded-lg hover:bg-indigo-950">
            <router-link to="/user" class="text-white">Sign in →</router-link>
          </li>
        </ul>
      </div>
      <div class="flex flex-col lg:hidden">
        <button @click="toggleMenu" class="text-white ml-auto">
          <svg
            class="w-6 h-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16m-7 6h7"
            ></path>
          </svg>
        </button>
        <div
          v-if="menuOpen"
          class="absolute right-0 mt-4 w-full rounded-lg shadow-lg z-50"
        >
          <ul class="flex flex-col space-y-2 p-4">
            <li v-if="!isHomePage">
              <router-link
                to="/dashboard/1"
                class="text-white hover:text-blue-200 p-2"
                >Dashboard</router-link
              >
            </li>
            <li v-if="!isHomePage">
              <router-link to="/news" class="text-white hover:text-blue-200 p-2"
                >News</router-link
              >
            </li>
            <li
              class="border border-blue-950 p-2 rounded-lg hover:bg-indigo-950"
            >
              <router-link to="/user" class="text-white">Sign in →</router-link>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { useRoute } from "vue-router";
import { computed, ref } from "vue";

const route = useRoute();
const isHomePage = computed(() => route.path === "/");
const showSignIn = true; // Always show Sign In
const menuOpen = ref(false);

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value;
};
</script>
