<template>
  <div class="relative">
    <button @click="toggleDropdown" class="text-white flex items-center">
      {{ username }}
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
      class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg z-50"
    >
      <ul class="py-2">
        <li>
          <router-link
            to="/edit"
            class="block px-4 py-2 text-gray-800 hover:bg-gray-100"
            >Edit</router-link
          >
        </li>
        <li>
          <button
            @click="handleLogout"
            class="block w-full text-left px-4 py-2 text-gray-800 hover:bg-gray-100"
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
