import "./assets/main.css";
import "./assets/index.css";

import { createApp } from "vue";
import { createPinia } from "pinia";
import Vue3Toastify, { type ToastContainerOptions } from "vue3-toastify";
import "vue3-toastify/dist/index.css";
import { useUserStore } from "@/stores/use-user-store";

import App from "./App.vue";
import router from "./router";

const toastOptions: ToastContainerOptions = {
  autoClose: 3000,
};

const app = createApp(App);
const pinia = createPinia();

app.use(router);
app.use(pinia);
app.use(Vue3Toastify, toastOptions);

const userStore = useUserStore();
userStore.fetchUser();

app.mount("#app");

// Service Worker Registration
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker
      .register("/service-worker.js")
      .then((registration) => {
        console.log("SW registered: ", registration);
      })
      .catch((registrationError) => {
        console.log("SW registration failed: ", registrationError);
      });
  });
}
