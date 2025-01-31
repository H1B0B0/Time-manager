<template>
  <nav class="p-4 w-full flex items-center relative">
    <div class="container mx-auto flex items-center justify-between">
      <div class="text-white text-lg font-bold flex-shrink-0">
        <router-link to="/" class="text-white">Time Manager</router-link>
      </div>
      <div class="hidden lg:flex ml-auto flex-shrink-0">
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
              :user_id="userStore.user.id ?? 0"
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
          class="absolute right-0 mt-12 w-48 text-white backdrop-blur-2xl border rounded-lg shadow-lg z-50 transition-transform transform origin-top-right scale-95 m-4"
          @click.outside="closeMenu"
        >
          <ul class="py-2">
            <li v-if="userStore.user.username && !isHomePage">
              <router-link
                :to="`/dashboard/${userStore.user.id}`"
                class="block px-4 py-2 hover:text-lg"
                >My Dashboard</router-link
              >
            </li>
            <li v-if="userStore.user.role_id >= 2">
              <router-link
                :to="
                  userStore.user.role_id === 2
                    ? `/admin/dashboard/${userStore.user.id}`
                    : `/admin/dashboard/${userStore.user.id}`
                "
                class="block px-4 py-2 hover:text-lg"
                >{{
                  userStore.user.role_id === 2
                    ? "Manager Dashboard"
                    : "Admin Dashboard"
                }}</router-link
              >
            </li>
            <li v-if="!isHomePage">
              <router-link to="/news" class="block px-4 py-2 hover:text-lg"
                >News</router-link
              >
            </li>
            <li v-if="!userStore.user.username">
              <router-link to="/login" class="block px-4 py-2 hover:"
                >Sign in →</router-link
              >
            </li>
            <template v-else>
              <li>
                <router-link
                  :to="`/settings/${userStore.user.id}`"
                  class="block px-4 py-2 hover:text-lg"
                >
                  Edit
                </router-link>
              </li>
              <li>
                <button
                  @click="logout"
                  class="block w-full text-left px-4 py-2 text-red-500 hover:text-lg"
                >
                  Logout
                </button>
              </li>
            </template>
          </ul>
        </div>
      </div>
    </div>
    <div
      class="hidden lg:flex absolute left-1/2 transform -translate-x-1/2 space-x-4"
    >
      <router-link
        class="text-white hover:text-blue-200"
        :to="`/dashboard/${userStore.user.id}`"
      >
        My Dashboard
      </router-link>
      <router-link to="/news" class="text-white hover:text-blue-200">
        News
      </router-link>
      <router-link
        v-if="userStore.user.role_id >= 2"
        :to="
          userStore.user.role_id === 2
            ? `/admin/dashboard/${userStore.user.id}`
            : `/admin/dashboard/${userStore.user.id}`
        "
        class="text-white hover:text-blue-200"
      >
        {{
          userStore.user.role_id === 2 ? "Manager Dashboard" : "Admin Dashboard"
        }}
      </router-link>
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
