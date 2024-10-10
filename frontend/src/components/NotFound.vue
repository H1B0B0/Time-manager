<template>
  <div class="relative w-full h-screen">
    <dotlottie-player
      ref="lottiePlayer"
      :src="lottieSrc"
      background="transparent"
      speed="1"
      style="width: 100vw; height: 100vh"
      loop
      autoplay
    ></dotlottie-player>
    <router-link
      :class="[
        'fixed top-20 left-4 px-6 rounded text-lg font-semibold z-20',
        isDarkTheme ? 'bg-white text-black' : 'bg-black text-white',
      ]"
      to="/"
      >Go to Home</router-link
    >
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from "vue";

// Détecter le thème actuel
const isDarkTheme = ref(
  window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches
);

const lottiePlayer = ref(null);
const lottieSrc = ref(
  isDarkTheme.value
    ? "https://lottie.host/e9be075b-2786-439b-870d-6bcc36c69902/6F2srWbFm0.json"
    : "https://lottie.host/2320b5bd-7449-40ac-8b9e-675485869585/CFMhN4NOmf.json"
);

onMounted(() => {
  import(
    "https://unpkg.com/@dotlottie/player-component@latest/dist/dotlottie-player.mjs"
  )
    .then(() => {
      if (lottiePlayer.value) {
        lottiePlayer.value.load(lottieSrc.value);
      }
    })
    .catch((error) => {
      console.error("Failed to load Lottie player:", error);
    });

  // Écouter les changements de thème
  window
    .matchMedia("(prefers-color-scheme: dark)")
    .addEventListener("change", (event) => {
      isDarkTheme.value = event.matches;
      lottieSrc.value = event.matches
        ? "https://lottie.host/7f290a0a-0b3e-4b66-bdf4-cd39812df305/j6nP9xFXka.json"
        : "https://lottie.host/2320b5bd-7449-40ac-8b9e-675485869585/CFMhN4NOmf.json";
      if (lottiePlayer.value) {
        lottiePlayer.value.load(lottieSrc.value);
      }
    });
});
</script>
