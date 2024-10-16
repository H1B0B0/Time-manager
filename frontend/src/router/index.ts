import { createRouter, createWebHistory } from "vue-router";
import WorkingTime from "../components/WorkingTime.vue";
import WorkingTimes from "../components/WorkingTimes.vue";
import ClockManager from "../components/ClockManager.vue";
import ChartManager from "@/components/ChartManager.vue";
import NotFound from "@/components/NotFound.vue";
import LoginRegister from "../components/LoginRegister.vue";
import UserSettings from "../components/UserSettings.vue";
import Home from "../components/Home.vue";
import News from "../components/News.vue";
import WorkedHoursPerMonth from "@/components/WorkedHoursPerMonth.vue";
import UserDashboard from "@/components/userDashboard.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: Home,
  },
  {
    path: "/login",
    name: "User",
    component: LoginRegister,
  },
  {
    path: "/settings",
    name: "Settings",
    component: UserSettings,
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
    path: "/dashboard/:userID",
    name: "Dashboard",
    component: UserDashboard,
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
    component: WorkedHoursPerMonth,
    props: true,
  },
  {
    path: "/:pathMatch(.*)*",
    name: "NotFound",
    component: NotFound,
  },
  {
    path: "/news",
    name: "News Feed",
    component: News,
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
