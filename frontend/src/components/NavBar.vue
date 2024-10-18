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
          <li
            v-if="
              userStore.user.username && (!isHomePage || !userStore.getUser)
            "
          >
            <router-link
              class="text-white hover:text-blue-200"
              :to="
                userStore.user.role === 'Manager'
                  ? `/admin/dashboard/${userStore.user.id}`
                  : '/dashboard/1'
              "
            >
              Dashboard
            </router-link>
          </li>
          <li v-if="!isHomePage">
            <router-link to="/news" class="text-white hover:text-blue-200"
              >News</router-link
            >
            <span
              v-if="!isLatestNewsRead"
              class="absolute top-30 right-15 inline-block w-2 h-2 bg-red-500 rounded-full"
            ></span>
          </li>
        </ul>
      </div>
      <div class="hidden lg:flex ml-auto">
        <ul class="flex space-x-4">
          <li
            v-if="!userStore.user.username"
            class="border border-blue-950 p-2 rounded-lg hover:bg-indigo-950"
          >
            <router-link to="/login" class="text-white">Sign in →</router-link>
          </li>
          <li v-else>
            <DropdownProfile
              :username="userStore.user.username"
              @logout="logout"
            />
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
          class="absolute right-0 mt-12 w-48 bg-white rounded-lg shadow-lg z-50 transition-transform transform origin-top-right scale-95"
          @click.outside="closeMenu"
        >
          <ul class="py-2">
            <li v-if="userStore.user.username && !isHomePage">
              <router-link
                to="/dashboard/1"
                class="block px-4 py-2 text-gray-800 hover:bg-gray-100"
                >Dashboard</router-link
              >
            </li>
            <li v-if="!isHomePage">
              <router-link
                to="/news"
                class="block px-4 py-2 text-gray-800 hover:bg-gray-100"
                >News</router-link
              >
            </li>
            <li v-if="!userStore.user.username">
              <router-link
                to="/login"
                class="block px-4 py-2 text-gray-800 hover:bg-gray-100"
                >Sign in →</router-link
              >
            </li>
            <template v-else>
              <li>
                <router-link
                  to="/settings"
                  class="block px-4 py-2 text-gray-800 hover:bg-gray-100"
                  >Edit</router-link
                >
              </li>
              <li>
                <button
                  @click="logout"
                  class="block w-full text-left px-4 py-2 text-gray-800 hover:bg-gray-100"
                >
                  Logout
                </button>
              </li>
            </template>
          </ul>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { useRoute, useRouter } from "vue-router";
import { computed, ref, onMounted, onUnmounted } from "vue";
import { useUserStore } from "@/stores/use-user-store";
import DropdownProfile from "./DropdownProfile.vue";

const route = useRoute();
const router = useRouter();
const isHomePage = computed(() => route.path === "/");
const menuOpen = ref(false);
const userStore = useUserStore();
const isLatestNewsRead = ref(true);

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value;
};

const closeMenu = () => {
  menuOpen.value = false;
};

const logout = () => {
  userStore.logout();
  router.push("/");
};

const checkLatestNewsRead = () => {
  const latestNewsVersion = localStorage.getItem("latest-news-version");
  isLatestNewsRead.value =
    localStorage.getItem(`article-${latestNewsVersion}`) === "true";
};

onMounted(() => {
  checkLatestNewsRead();
  window.addEventListener("latest-news-read", checkLatestNewsRead);
  document.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
  window.removeEventListener("latest-news-read", checkLatestNewsRead);
  document.removeEventListener("click", handleClickOutside);
});

const handleClickOutside = (event: MouseEvent) => {
  const menuElement = document.querySelector(".dropdown-menu");
  if (menuElement && !menuElement.contains(event.target as Node)) {
    closeMenu();
  }
};
</script>
