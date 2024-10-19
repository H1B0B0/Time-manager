<template>
  <div class="min-h-screen w-full">
    <div class="flex flex-col justify-center items-center w-full">
      <!-- Clock Manager -->
      <div class="rounded-lg p-4 w-full flex justify-center items-center">
        <ClockManager />
      </div>

      <!-- Chart Manager -->
      <div class="rounded-lg p-4 w-full">
        <ChartManager />
      </div>

      <!-- Worked Hours Charts -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 w-full p-5">
        <div class="rounded-lg p-4 w-full">
          <WorkedHoursPerMonth />
        </div>
        <div class="rounded-lg p-4 w-full">
          <WorkedHoursPerDayChart />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useUserStore } from "@/stores/use-user-store";
import ChartManager from "./ChartManager.vue";
import ClockManager from "./ClockManager.vue";
import WorkedHoursPerDayChart from "./WorkedHoursPerDayChart.vue";
import WorkedHoursPerMonth from "./WorkedHoursPerMonth.vue";

export default defineComponent({
  name: "UserDashboard",
  components: {
    ChartManager,
    ClockManager,
    WorkedHoursPerDayChart,
    WorkedHoursPerMonth,
  },
  setup() {
    const router = useRouter();
    const route = useRoute();
    const userStore = useUserStore();

    onMounted(() => {
      const userId = parseInt(route.params.userId, 10);
      const loggedInUserId = userStore.user?.id;
      const userRole = userStore.user?.role_id;

      if (!loggedInUserId) {
        // Redirect to login if user is not logged in
        router.push("/login");
      } else if (
        userId !== loggedInUserId &&
        userRole !== 2 &&
        userRole !== 3
      ) {
        // Redirect to the logged-in user's dashboard
        router.push(`/dashboard/${loggedInUserId}`);
      }
    });

    return {};
  },
});
</script>

<style scoped>
.recharts-wrapper {
  width: 100% !important;
  height: auto !important;
}
</style>
