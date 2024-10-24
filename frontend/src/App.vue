<script setup lang="ts">
import { RouterView } from "vue-router";
import NavBar from "./components/NavBar.vue";
import { ref, onMounted } from "vue";
import { toast } from "vue3-toastify";

import "https://unpkg.com/@splinetool/viewer@1.9.30/build/spline-viewer.js"; // Spline Viewer

const defaultSplineViewerUrl =
  "https://prod.spline.design/soRsUYV4PO0dCd6S/scene.splinecode";
const tristantModeSplineViewerUrl =
  "https://prod.spline.design/yYE1SLuUDlq5OnM8/scene.splinecode";

const splineViewerUrl = ref(defaultSplineViewerUrl);
const isTristantMode = ref(false);
const performanceMode = ref(false);
const isMobile = ref(false);
const isOffline = ref(!navigator.onLine);
const wasOffline = ref(false); // Track if the user was offline

const updateSplineViewerUrl = () => {
  isTristantMode.value = localStorage.getItem("tristantMode") === "true";
  splineViewerUrl.value = isTristantMode.value
    ? tristantModeSplineViewerUrl
    : defaultSplineViewerUrl;

  if (isTristantMode.value) {
    document.body.classList.add("tristant-mode");
  } else {
    document.body.classList.remove("tristant-mode");
  }
};

const handlePerformanceMode = () => {
  performanceMode.value = !performanceMode.value;
};

const isMobileDevice = () => {
  return /Mobi|Android/i.test(navigator.userAgent);
};

const showInstallPrompt = ref(false);
let deferredPrompt: any = null;

const installApp = () => {
  if (deferredPrompt) {
    deferredPrompt.prompt();
    deferredPrompt.userChoice.then((choiceResult: any) => {
      if (choiceResult.outcome === "accepted") {
        toast.success("App installed successfully!");
      } else {
        console.log("User dismissed the install prompt");
      }
      deferredPrompt = null;
      showInstallPrompt.value = false;
    });
  }
};

const dismiss = () => {
  showInstallPrompt.value = false;
};

const handleOfflineStatus = () => {
  const currentlyOffline = !navigator.onLine;
  if (currentlyOffline && !isOffline.value) {
    toast.error("You are offline!");
    wasOffline.value = true;
  } else if (!currentlyOffline && isOffline.value && wasOffline.value) {
    toast.success("You are back online!");
    wasOffline.value = false;
  }
  isOffline.value = currentlyOffline;
};

onMounted(() => {
  updateSplineViewerUrl();
  handleOfflineStatus();

  if (isMobileDevice()) {
    performanceMode.value = true;
    isMobile.value = true;
  }

  window.addEventListener("beforeinstallprompt", (e) => {
    console.log("beforeinstallprompt event triggered");
    e.preventDefault();
    deferredPrompt = e;
    showInstallPrompt.value = true;
    console.log("showInstallPrompt:", showInstallPrompt.value);
  });

  window.addEventListener("keydown", async (event) => {
    if (event.ctrlKey && event.key === "m") {
      // Toggle tristant mode
      const currentMode = localStorage.getItem("tristantMode") === "true";
      localStorage.setItem("tristantMode", (!currentMode).toString());

      // Clear cache
      if ("caches" in window) {
        const cacheNames = await caches.keys();
        for (const cacheName of cacheNames) {
          await caches.delete(cacheName);
        }
      }
      console.log("Cache cleared!");

      location.reload();
    }
  });

  window.addEventListener("online", handleOfflineStatus);
  window.addEventListener("offline", handleOfflineStatus);
});

setTimeout(() => {
  let favicon_video_image_counter = 0;
  let favicon_video_icon_tag = document.querySelector(
    "link[rel='icon']"
  ) as HTMLLinkElement | null;
  let favicon_video_images: string[] = [
    "https://favicongenerator.s3.amazonaws.com/7cbcd118557f4.png",
    "https://favicongenerator.s3.amazonaws.com/6c245afde6856.png",
    "https://favicongenerator.s3.amazonaws.com/b3f2d946d4b5e.png",
    "https://favicongenerator.s3.amazonaws.com/c0c9303e3fb88.png",
    "https://favicongenerator.s3.amazonaws.com/e731852814abf.png",
    "https://favicongenerator.s3.amazonaws.com/b5f1eb24129be.png",
    "https://favicongenerator.s3.amazonaws.com/6e517279226a7.png",
    "https://favicongenerator.s3.amazonaws.com/0b6fc7a19e666.png",
    "https://favicongenerator.s3.amazonaws.com/1ea328f73b5f6.png",
    "https://favicongenerator.s3.amazonaws.com/ec4a31f30da88.png",
    "https://favicongenerator.s3.amazonaws.com/41ae8f668fde5.png",
  ];

  async function favicon_video_to_data_url(
    url: string,
    callback: (dataUrl: string | ArrayBuffer | null) => void
  ) {
    let xhr = new XMLHttpRequest();
    xhr.onload = function () {
      let reader = new FileReader();
      reader.onloadend = function () {
        callback(reader.result);
      };
      reader.readAsDataURL(xhr.response);
    };
    xhr.open("GET", url);
    xhr.responseType = "blob";
    xhr.send();
  }

  let favicon_video_loaded_images: (string | ArrayBuffer | null)[] = [];

  favicon_video_images.map((url, idx) => {
    favicon_video_to_data_url(url, function (dataUrl) {
      favicon_video_loaded_images[idx] = dataUrl;
    });
  });

  setInterval(function () {
    if (
      favicon_video_icon_tag &&
      favicon_video_loaded_images[favicon_video_image_counter]
    ) {
      favicon_video_icon_tag.href = (
        favicon_video_loaded_images[favicon_video_image_counter] as string
      ).replace("application/octet-stream", "image/png");
    }
    if (favicon_video_image_counter == favicon_video_loaded_images.length - 1)
      favicon_video_image_counter = 0;
    else favicon_video_image_counter++;
  }, 100);
}, 2000);
</script>

<template>
  <div
    :class="{ 'tristant-mode': isTristantMode }"
    class="min-h-screen flex flex-col relative bg-black w-full"
  >
    <header class="w-full z-20 bg-transparent">
      <NavBar />
    </header>

    <main class="flex items-center justify-center bg-transparent z-10">
      <spline-viewer
        class="absolute inset-0 w-full h-full"
        :url="splineViewerUrl"
        play="true"
        v-show="!performanceMode"
      />
      <div class="z-20 m-0 p-0">
        <RouterView />
      </div>
      <div
        v-show="performanceMode"
        class="absolute inset-0 w-full h-full bg-animated-lights"
      >
        <div class="circle1"></div>
        <div class="circle2"></div>
        <div class="circle3"></div>
        <div class="circle4"></div>
        <div class="circle5"></div>
      </div>
    </main>
  </div>
  <label
    v-if="!isMobile"
    class="inline-flex items-center cursor-pointer fixed bottom-4 left-4 z-30"
  >
    <input
      type="checkbox"
      @change="handlePerformanceMode"
      class="sr-only peer"
    />
    <div
      class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"
    ></div>
    <span class="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300"
      >Performance Mode</span
    >
  </label>
  <div v-if="isOffline" class="offline-banner">You are offline!</div>
  <div
    v-if="showInstallPrompt"
    class="fixed bottom-5 left-1/2 transform -translate-x-1/2 border backdrop-blur-2xl rounded-lg shadow-lg p-4 z-50 text-white max-w-xs sm:max-w-md md:max-w-lg lg:max-w-xl"
    role="dialog"
    aria-labelledby="pwa-popup-title"
    aria-describedby="pwa-popup-description"
  >
    <div class="flex flex-col sm:flex-row items-center">
      <div class="mr-0 sm:mr-4 mb-4 sm:mb-0">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="w-6 h-6"
        >
          <path
            d="M12 22C12 22 2 18 2 13V9C2 4 7 2 12 2s10 2 10 7v4c0 5-10 9-10 9z"
          ></path>
          <path d="M18 19a3 3 0 0 1-3-3h6a3 3 0 0 1-3 3z"></path>
        </svg>
      </div>
      <div class="flex-grow text-center sm:text-left">
        <h3 id="pwa-popup-title" class="text-lg font-semibold mr-2">
          Install App
        </h3>
        <p id="pwa-popup-description" class="text-sm">
          Install this app on your home screen for quick and easy access when
          you’re on the go.
        </p>
      </div>
      <div class="flex justify-center items-center space-x-4 mt-4 sm:mt-0">
        <button
          @click="installApp"
          class="bg-indigo-500 text-white rounded px-4 py-2 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-opacity-50"
          aria-label="Install App"
        >
          Install
        </button>
        <button
          @click="dismiss"
          class="bg-gray-300 text-gray-700 rounded px-4 py-2 hover:bg-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-opacity-50"
          aria-label="Dismiss"
        >
          Dismiss
        </button>
      </div>
    </div>
  </div>
</template>

<style>
#container #logo {
  display: none !important;
}

body.tristant-mode {
  cursor: url("./assets/tristan.png"), auto;
}

.bg-animated-lights {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  background: black;
}

.bg-animated-lights .circle1,
.bg-animated-lights .circle2,
.bg-animated-lights .circle3,
.bg-animated-lights .circle4,
.bg-animated-lights .circle5 {
  position: absolute;
  width: 75%;
  height: 75%;
  border-radius: 50%;
  filter: blur(100px);
  animation: move 20s linear infinite;
}

.bg-animated-lights .circle1 {
  background: radial-gradient(
    circle,
    rgba(139, 92, 246, 0.5) 0%,
    rgba(79, 70, 229, 0.5) 100%
  );
  animation-delay: 0s;
  top: -50%;
  left: -50%;
}

.bg-animated-lights .circle2 {
  background: radial-gradient(
    circle,
    rgba(79, 70, 229, 0.5) 0%,
    rgba(6, 182, 212, 0.5) 100%
  );
  animation-delay: 5s;
  top: 50%;
  left: 50%;
}

.bg-animated-lights .circle3 {
  background: radial-gradient(
    circle,
    rgba(6, 182, 212, 0.5) 0%,
    rgba(139, 92, 246, 0.5) 100%
  );
  animation-delay: 10s;
  top: -50%;
  left: 50%;
}

.bg-animated-lights .circle4 {
  background: radial-gradient(
    circle,
    rgba(139, 92, 246, 0.5) 0%,
    rgba(79, 70, 229, 0.5) 100%
  );
  animation-delay: 15s;
  top: 50%;
  left: -50%;
}

.bg-animated-lights .circle5 {
  background: radial-gradient(
    circle,
    rgba(79, 70, 229, 0.5) 0%,
    rgba(6, 182, 212, 0.5) 100%
  );
  animation-delay: 20s;
  top: 0%;
  left: 0%;
}

@keyframes move {
  0% {
    transform: translate(0, 0);
  }
  25% {
    transform: translate(50%, -50%);
  }
  50% {
    transform: translate(-50%, 50%);
  }
  75% {
    transform: translate(50%, 50%);
  }
  100% {
    transform: translate(0, 0);
  }
}

.offline-banner {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background-color: rgba(255, 0, 0, 0.8); /* Semi-transparent red */
  color: white;
  text-align: center;
  padding: 5px; /* Smaller padding */
  font-size: 0.875rem; /* Smaller font size */
  z-index: 1000;
}
</style>
