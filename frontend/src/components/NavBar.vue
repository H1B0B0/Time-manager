<template>
  <nav class="bg-gray-900 border-gray-200">
    <div
      class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4"
    >
      <div class="flex items-center space-x-4">
        <router-link to="/" class="text-lg font-bold text-white"
          >TIME MANAGER</router-link
        >
      </div>
      <div
        class="flex items-center md:order-2 space-x-3 md:space-x-0 rtl:space-x-reverse"
      >
        <button
          type="button"
          :class="`flex text-sm bg-gray-800 rounded-full md:me-0 focus:ring-4 focus:ring-gray-600 ${
            username ? '' : 'hidden'
          }`"
          id="user-menu-button"
          aria-expanded="false"
          data-dropdown-toggle="user-dropdown"
          data-dropdown-placement="bottom"
        >
          <span class="sr-only">Open user menu</span>
          <img
            class="w-8 h-8 rounded-full"
            src="https://thispersondoesnotexist.com/"
            alt="user photo"
          />
        </button>
        <div
          class="z-50 hidden my-4 text-base list-none bg-gray-700 divide-y divide-gray-600 rounded-lg shadow"
          id="user-dropdown"
        >
          <div class="px-4 py-3">
            <span class="block text-sm text-white">{{ username }}</span>
            <span class="block text-sm text-gray-400 truncate">{{
              email
            }}</span>
          </div>
          <ul class="py-2" aria-labelledby="user-menu-button">
            <li>
              <router-link
                to="/settings"
                class="block px-4 py-2 text-sm text-gray-200 hover:bg-gray-600 hover:text-white"
                >Settings</router-link
              >
            </li>
            <li>
              <router-link
                to="/"
                @click="logout"
                class="block w-full text-left px-4 py-2 text-sm text-gray-200 hover:bg-gray-600 hover:text-white"
                >Sign out</router-link
              >
            </li>
          </ul>
        </div>
        <button
          data-collapse-toggle="navbar-user"
          type="button"
          class="inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-gray-400 rounded-lg md:hidden hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-600"
          aria-controls="navbar-user"
          aria-expanded="false"
        >
          <span class="sr-only">Open main menu</span>
          <svg
            class="w-5 h-5"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 17 14"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M1 1h15M1 7h15M1 13h15"
            />
          </svg>
        </button>
      </div>
      <div
        class="items-center justify-between hidden w-full md:flex md:w-auto md:order-1"
        id="navbar-user"
      >
        <ul
          class="flex flex-col font-medium p-4 md:p-0 mt-4 border border-gray-700 rounded-lg bg-gray-800 md:space-x-8 rtl:space-x-reverse md:flex-row md:mt-0 md:border-0 md:bg-gray-900"
        >
          <li>
            <router-link
              to="/clocks/1"
              class="block py-2 px-3 text-white rounded hover:bg-gray-700 md:hover:bg-transparent md:hover:text-blue-500 md:p-0"
              >Clock in / Clock out</router-link
            >
          </li>
          <li>
            <router-link
              to="/dashboard/1"
              class="block py-2 px-3 text-white rounded hover:bg-gray-700 md:hover:bg-transparent md:hover:text-blue-500 md:p-0"
              >Dashboard</router-link
            >
          </li>
          <li>
            <router-link
              to="/workingTimes/1"
              class="block py-2 px-3 text-white rounded hover:bg-gray-700 md:hover:bg-transparent md:hover:text-blue-500 md:p-0"
              >Working Times</router-link
            >
          </li>
          <li>
            <router-link
              to="/workingTime/1/1"
              class="block py-2 px-3 text-white rounded hover:bg-gray-700 md:hover:bg-transparent md:hover:text-blue-500 md:p-0"
              >Working Time</router-link
            >
          </li>
          <li>
            <router-link
              to="/chartManager/1"
              class="block py-2 px-3 text-white rounded hover:bg-gray-700 md:hover:bg-transparent md:hover:text-blue-500 md:p-0"
              >Chart Manager</router-link
            >
          </li>
          <li class="relative">
            <router-link
              to="/news"
              class="block py-2 px-3 text-white rounded hover:bg-gray-700 md:hover:bg-transparent md:hover:text-blue-500 md:p-0"
            >
              News
              <span
                v-if="!isLatestNewsRead"
                class="absolute top-0 right-15 inline-block w-2 h-2 bg-red-500 rounded-full"
              ></span>
            </router-link>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script>
import { useUserStore } from "@/stores/use-user-store";
import { ref, watch, onMounted, onUnmounted } from "vue";

export default {
  setup() {
    const userStore = useUserStore();
    const username = ref(userStore.user?.username ?? "");
    const email = ref(userStore.user?.email ?? "");
    const isLatestNewsRead = ref(true);

    // Watch for changes in the userStore
    watch(
      () => userStore.user,
      (newUser) => {
        username.value = newUser?.username ?? "";
        email.value = newUser?.email ?? "";
      }
    );

    // Check if the latest news has been read
    const checkLatestNewsRead = () => {
      const latestNewsVersion = localStorage.getItem("latest-news-version");
      isLatestNewsRead.value =
        localStorage.getItem(`article-${latestNewsVersion}`) === "true";
    };

    onMounted(() => {
      checkLatestNewsRead();
      // Écouter l'événement global pour mettre à jour isLatestNewsRead
      window.addEventListener("latest-news-read", checkLatestNewsRead);
    });

    onUnmounted(() => {
      // Nettoyer l'écouteur d'événement pour éviter les fuites de mémoire
      window.removeEventListener("latest-news-read", checkLatestNewsRead);
    });

    const logout = () => {
      userStore.setUser(null);
    };

    return {
      username,
      email,
      logout,
      isLatestNewsRead,
    };
  },
};
</script>
