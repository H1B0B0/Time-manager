<template>
  <div
    class="fixed bottom-5 left-1/2 transform -translate-x-1/2 bg-white border border-gray-300 rounded-lg shadow-lg p-4 z-50"
    role="dialog"
    aria-labelledby="pwa-popup-title"
    aria-describedby="pwa-popup-description"
  >
    <div class="flex items-center">
      <div class="mr-4">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="w-6 h-6 text-gray-700"
        >
          <path
            d="M12 22C12 22 2 18 2 13V9C2 4 7 2 12 2s10 2 10 7v4c0 5-10 9-10 9z"
          ></path>
          <path d="M18 19a3 3 0 0 1-3-3h6a3 3 0 0 1-3 3z"></path>
        </svg>
      </div>
      <div class="flex-grow">
        <h3 id="pwa-popup-title" class="text-lg font-semibold">Install App</h3>
        <p id="pwa-popup-description" class="text-sm text-gray-600">
          Install this app on your home screen for quick and easy access when
          you’re on the go.
        </p>
      </div>
      <div>
        <button
          @click="installApp"
          class="bg-blue-500 text-white rounded px-4 py-2 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
          aria-label="Install App"
        >
          Install
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    installApp() {
      // Logic to install the app
    },
  },
};
</script>

<style scoped>
@media (min-width: 769px) {
  .fixed {
    display: none;
    z-index: 50;
  }
}
</style>
