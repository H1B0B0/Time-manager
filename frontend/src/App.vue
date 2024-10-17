<script setup lang="ts">
import { RouterView } from "vue-router";
import NavBar from "./components/NavBar.vue";
import { ref, onMounted } from "vue";

import "https://unpkg.com/@splinetool/viewer@1.9.30/build/spline-viewer.js"; // Spline Viewer

const defaultSplineViewerUrl =
  "https://prod.spline.design/soRsUYV4PO0dCd6S/scene.splinecode";
const tristantModeSplineViewerUrl =
  "https://prod.spline.design/yYE1SLuUDlq5OnM8/scene.splinecode";

const splineViewerUrl = ref(defaultSplineViewerUrl);
const isTristantMode = ref(false);
const performanceMode = ref(false);
const isMobile = ref(false);

const updateSplineViewerUrl = () => {
  isTristantMode.value = localStorage.getItem("tristantMode") === "true";
  splineViewerUrl.value = isTristantMode.value
    ? tristantModeSplineViewerUrl
    : defaultSplineViewerUrl;

  // Ajouter ou supprimer la classe tristant-mode au body
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

onMounted(() => {
  updateSplineViewerUrl();

  if (isMobileDevice()) {
    performanceMode.value = true;
    isMobile.value = true;
  }

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
    class="min-h-screen flex flex-col relative bg-black"
  >
    <header class="w-full z-20 bg-transparent">
      <NavBar />
    </header>

    <main
      class="flex-grow flex items-center justify-center bg-transparent z-10"
    >
      <spline-viewer
        class="absolute inset-0 w-full h-full"
        :url="splineViewerUrl"
        play="true"
        v-show="!performanceMode"
      />
      <div class="z-20">
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
</style>
