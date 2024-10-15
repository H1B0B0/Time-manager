<template>
  <div class="p-4 rounded-lg h-full flex flex-col">
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl flex-1">
      <Line :key="chartKey" id="my-chart-id" :options="chartOptions" :data="chartData" />
    </div>
  </div>
</template>

<script>
import { Line } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
} from "chart.js";
import { ref } from "vue";
import router from "@/router";
import { getClocksDate, hoursWorkedPerDay } from '../functions/Clock'

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale
);

export default {
  name: "LineChart",
  components: { Line },
  setup() {
    const chartData = ref({
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: "#36A2EB",
          borderColor: "#36A2EB",
          label: "Worked hours per month",
          fill: true,
          tension: 0.4,
        },
      ],
    });

    const chartOptions = ref({
      responsive: true,
      aspectRatio: 1,
      plugins: {
        legend: {
          labels: {
            color: "white",
          },
        },
      },
      scales: {
        x: {
          ticks: {
            color: "white",
          },
          grid: {
            color: "rgba(255, 255, 255, 0.2)",
            lineWidth: 1,
            drawOnChartArea: true,
            drawTicks: true,
            tickColor: "white",
            tickLength: 10,
            tickWidth: 1,
          },
        },
        y: {
          ticks: {
            color: "white",
          },
          grid: {
            color: "rgba(255, 255, 255, 0.2)",
            lineWidth: 1,
            drawOnChartArea: true,
            drawTicks: true,
            tickColor: "white",
            tickLength: 10,
            tickWidth: 1,
          },
        },
      },
    });

    const errorMessage = ref("");
    const chartKey = ref(0);
    const startDate = ref("");
    const endDate = ref("");
    const date = ref("");

    date.value = new Date();

    // Calculer le premier jour du mois
    startDate.value = new Date(date.value.getFullYear(), date.value.getMonth(), 1);
    startDate.value.setHours(0, 0, 0, 0);

    // Calculer le dernier jour du mois
    endDate.value = new Date(date.value.getFullYear(), date.value.getMonth() + 1, 0);
    endDate.value.setHours(23, 59, 59, 999);

    const fetchData = async () => {
      try {
        const response = await getClocksDate(router.currentRoute.value.params.userID, startDate.value, endDate.value)
        const workedTimePerDay = await hoursWorkedPerDay(response)
        chartData.value.labels = workedTimePerDay.map(day => day.date)
        chartData.value.datasets[0].data = workedTimePerDay.map(day => day.hours)

        chartKey.value += 1
      } catch (error) {
        errorMessage.value = "Failed to fetch data";
        console.error(error);
      }
    };

    fetchData();

    return {
      chartData,
      chartOptions,
      errorMessage,
      chartKey,
      startDate,
      endDate,
    };
  },
};
</script>