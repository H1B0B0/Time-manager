import { createRouter, createWebHistory } from "vue-router";
import WorkingTime from "../components/WorkingTime.vue";
import WorkingTimes from "../components/WorkingTimes.vue";
import User from "../components/User.vue";
import ClockManager from "../components/ClockManager.vue";
import ChartManager from "@/components/ChartManager.vue";
import NotFound from "@/components/NotFound.vue";
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
  {
    path: "/clocks/:userID",
    name: "ClockManager",
    component: ClockManager,
    props: true,
  },
  {
    path: "/chartManager/:userID",
    name: "ChartManager",
    component: ChartManager,
    props: true,
  },
  {
    path: "/:pathMatch(.*)*",
    name: "NotFound",
    component: NotFound,
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
