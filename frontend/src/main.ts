import "./assets/main.css";
import "./assets/index.css";

import { createApp } from "vue";
import { createPinia } from "pinia";
import Vue3Toastify, { type ToastContainerOptions } from "vue3-toastify";
import "vue3-toastify/dist/index.css";

import App from "./App.vue";
import router from "./router";

const toastOptions: ToastContainerOptions = {
  autoClose: 3000,
};

createApp(App)
  .use(router)
  .use(createPinia())
  .use(Vue3Toastify, toastOptions)
  .mount("#app");
