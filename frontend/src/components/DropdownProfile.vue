<template>
  <div class="relative">
    <button @click="toggleDropdown" class="text-white flex items-center">
    <img :src="`https://api.dicebear.com/9.x/lorelei/svg?seed=${username}`" class="rounded-full h-8 mx-2" />      {{ username }}
      <svg
        class="w-4 h-4 ml-1"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M19 9l-7 7-7-7"
        ></path>
      </svg>
    </button>
    <div
      v-if="isOpen"
      class="absolute right-0 mt-2 w-48 z-50 border border-white rounded backdrop-blur-sm"
    >
      <ul class="py-2">
        <li>
          <router-link
            to="/settings"
            class="block px-4 py-2 text-white "
            >Edit</router-link
          >
        </li>
        <li>
          <button
            @click="handleLogout"
            class="block w-full text-left px-4 py-2 text-white "
          >
            Logout
          </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const props = defineProps<{
  username: string;
}>();

const emit = defineEmits(['logout']);

const isOpen = ref(false);

const toggleDropdown = () => {
  isOpen.value = !isOpen.value;
};

const handleLogout = () => {
  emit('logout');
  isOpen.value = false;
};
</script>
