import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
  },
  {
    path: "/about",
    name: "about",
    component: () => import("../views/AboutView.vue"),
  },
  {
    path: "/workingtime",
    name: "workingtime",
    component: () => import("../views/WorkingTime.vue"),
  },
  {
    path: "/workingtimes/:userID",
    name: "workingtimes",
    component: () => import("../views/WorkingTimes.vue"),
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
