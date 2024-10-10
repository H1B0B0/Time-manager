import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import WorkingTime from "../components/WorkingTime.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
  },
  // {
  //   path: "/workingTimes/:userID",
  //   name: "WorkingTimes",
  //   component: WorkingTimes,
  //   props: true,
  // },
  {
    path: "/workingTime/:userID/:workingTimeID?",
    name: "WorkingTime",
    component: WorkingTime,
    props: true,
  },
  // {
  //   path: "/clock/:userID",
  //   name: "ClockManager",
  //   component: ClockManager,
  //   props: true,
  // },
  // {
  //   path: "/chartManager/:userID",
  //   name: "ChartManager",
  //   component: ChartManager,
  //   props: true,
  // },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
