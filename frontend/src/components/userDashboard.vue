<template>
  <div class="">
    <div class="flex flex-col justify-center items-center space-y-6">
      <!-- Title -->
      <h1 class="text-2xl font-bold text-center text-white mb-4">
        Dashboard of {{ userName }}
      </h1>

      <!-- Clock Manager -->
      <div class="flex justify-center items-center">
        <ClockManager />
      </div>

      <!-- Chart Manager -->
      <div class="md:pl-40 md:pr-40 w-full md:h-[900px]">
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
import { GetUserById, GetUserByToken } from "@/functions/User"; // Assurez-vous d'avoir une fonction pour obtenir l'utilisateur par ID
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
    const isOffline = ref(!navigator.onLine);
    const userName = ref("");

    onMounted(async () => {
      if (isOffline.value) {
        toast.error("You are offline. Some features may not be available.");
        return;
      }

      try {
        const userId = Number(route.params.userID);
        const user = await GetUserById(userId);

        if (!user) {
          console.log("User not found");
          router.push("/login");
          return;
        }

        userName.value = user.username;
        console.log(user.username);

        const loggedInUser = await GetUserByToken();
        const loggedInUserId = loggedInUser.id;
        const userRole = loggedInUser.role_id;

        if (userId !== loggedInUserId && userRole !== 2 && userRole !== 3) {
          router.push(`/dashboard/${loggedInUserId}`);
        }
      } catch (error) {
        console.error("Failed to fetch user:", error);
        router.push("/login");
      }
    });

    return {
      userName,
    };
  },
});
</script>
