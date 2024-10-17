<template>
  <div class="p-4 min-h-screen w-full" ref="chartContainer">
    <div
      class="flex flex-col max-w-7xl mx-auto space-y-6 justify-center items-center w-full"
    >
      <!-- Clock Manager -->
      <div class="rounded-lg p-4 w-full flex justify-center items-center">
        <ClockManager />
      </div>

      <!-- Chart Manager -->
      <div class="rounded-lg p-4 w-full">
        <ChartManager />
      </div>

      <!-- Worked Hours Charts -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 w-full">
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
import { defineComponent, onMounted, onUnmounted, ref } from "vue";
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
    const chartContainer = ref(null);

    const resizeCharts = () => {
      if (chartContainer.value) {
        const charts =
          chartContainer.value.querySelectorAll(".recharts-wrapper");
        charts.forEach((chart) => {
          const containerWidth = chart.parentElement.offsetWidth;
          chart.style.width = `${containerWidth}px`;
          chart.style.height = `${containerWidth * 0.5}px`; // Adjust the aspect ratio as needed
        });
      }
    };

    onMounted(() => {
      resizeCharts();
      window.addEventListener("resize", resizeCharts);
    });

    onUnmounted(() => {
      window.removeEventListener("resize", resizeCharts);
    });

    return {
      chartContainer,
    };
  },
});
</script>
