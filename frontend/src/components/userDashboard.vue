<template>
  <div class="">
    <div class="flex flex-col justify-center items-center space-y-6">
      <!-- Clock Manager -->
      <div class="flex justify-center items-center">
        <ClockManager />
      </div>

      <!-- Chart Manager -->
      <div class="md:pl-20 md:pr-20 w-full">
        <ChartManager />
      </div>
      <!-- Worked Hours Charts -->
      <div
        class="grid grid-cols-1 gap-6 lg:grid-cols-2 w-full md:pl-20 md:pr-20"
      >
        <div class="p-4">
          <WorkedHoursPerMonth />
        </div>
        <div class="p-4">
          <WorkedHoursPerDayChart />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, defineComponent, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useUserStore } from "@/stores/use-user-store";
import ChartManager from "./ChartManager.vue";
import ClockManager from "./ClockManager.vue";
import WorkedHoursPerDayChart from "./WorkedHoursPerDayChart.vue";
import WorkedHoursPerMonth from "./WorkedHoursPerMonth.vue";
import { toast } from "vue3-toastify";

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
    const isOffline = ref(!navigator.onLine);

    onMounted(() => {
      if (isOffline.value) {
        toast.error("You are offline. Some features may not be available.");
        return;
      }

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
