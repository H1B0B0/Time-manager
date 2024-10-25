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
import { GetUserByToken } from "@/functions/User";
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

    onMounted(async () => {
      if (isOffline.value) {
        toast.error("You are offline. Some features may not be available.");
        return;
      }

      try {
        const user = await GetUserByToken();
        console.log("User: ", user);

        if (!user) {
          // Redirect to login if user is not logged in
          console.log("User not logged in");
          router.push("/login");
          return;
        }

        const loggedInUserId = user.id;
        console.log("Logged in user ID: ", loggedInUserId);
        const userId = Number(route.params.userID);
        const userRole = user.role_id;
        console.log("User role: ", userRole);
        console.log("User ID from route: ", userId);

        if (userId !== loggedInUserId && userRole !== 2 && userRole !== 3) {
          // Redirect to the logged-in user's dashboard
          router.push(`/dashboard/${loggedInUserId}`);
        }
      } catch (error) {
        console.error("Failed to fetch user:", error);
        router.push("/login");
      }
    });

    return {};
  },
});
</script>
