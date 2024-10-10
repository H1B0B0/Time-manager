import { createRouter, createWebHistory } from "vue-router";
import WorkingTime from "../components/WorkingTime.vue";
import WorkingTimes from "../components/WorkingTimes.vue";
import User from "../components/User.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: User,
  },
  {
    path: "/workingTimes/:userID",
    name: "WorkingTimes",
    component: WorkingTimes,
    props: true,
  },
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
