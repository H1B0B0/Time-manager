<template>
  <div class="relative border p-1 rounded-xl">
    <button @click="toggleDropdown" class="text-white flex items-center">
      <img
        :src="`https://api.dicebear.com/9.x/lorelei/svg?seed=${username}`"
        class="rounded-full h-8 mx-2"
      />
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
    <transition name="dropdown">
      <div
        v-if="isOpen"
        class="dropdown-menu absolute right-0 mt-4 w-48 z-50 border border-white rounded-xl backdrop-blur-sm"
      >
        <ul class="py-2">
          <li>
            <router-link
              to="/settings"
              class="block px-4 py-2 text-white hover:text-lg transition-all"
              >Edit</router-link
            >
          </li>
          <li>
            <button
              @click="handleLogout"
              class="block w-full text-left px-4 py-2 text-red-700 hover:text-lg transition-all"
            >
              Logout
            </button>
          </li>
        </ul>
      </div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";

const props = defineProps<{
  username: string;
}>();

const emit = defineEmits(["logout"]);

const isOpen = ref(false);

const toggleDropdown = (event: MouseEvent) => {
  event.stopPropagation();
  isOpen.value = !isOpen.value;
};

const closeDropdown = () => {
  isOpen.value = false;
};

const handleClickOutside = (event: MouseEvent) => {
  const dropdownElement = document.querySelector(".dropdown-menu");
  if (dropdownElement && !dropdownElement.contains(event.target as Node)) {
    closeDropdown();
  }
};

onMounted(() => {
  document.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);
});

const handleLogout = () => {
  emit("logout");
  closeDropdown();
};
</script>

<style scoped>
.dropdown-enter-active,
.dropdown-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
