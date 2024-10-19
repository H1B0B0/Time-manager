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
import { defineComponent } from "vue";
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
});
</script>

<style scoped>
.recharts-wrapper {
  width: 100% !important;
  height: auto !important;
}
</style>
