<template>
  <div class="p-4 rounded-lg w-full">
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl w-full">
      <Bar
        :key="chartKey"
        id="my-chart-id"
        :options="chartOptions"
        :data="chartData"
        class="w-full"
      />
    </div>
  </div>
</template>

<script>
import { Bar } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
} from "chart.js";
import { ref } from "vue";
import { getClocksDate, hoursWorkedPerDay } from "../functions/Clock";
import router from "@/router";
import { getWorkingTimes } from "../functions/WorkingTime";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
);

export default {
  name: "BarChart",
  components: { Bar },
  setup() {
    const chartData = ref({
      labels: [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
      ],
      datasets: [
        {
          data: [],
          backgroundColor: "#36A2EB",
          borderColor: "#36A2EB",
          label: "Schedule of the week",
        },
      ],
    });

    const chartOptions = ref({
      responsive: true,
      maintainAspectRatio: false,
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
    const dayOfWeek = date.value.getDay(); // 0 (Sunday) to 6 (Saturday)
    const diffToMonday = (dayOfWeek + 6) % 7; // Calculate difference to Monday (1)

    startDate.value = new Date(date.value);
    startDate.value.setDate(date.value.getDate() - diffToMonday);
    startDate.value.setHours(0, 0, 0, 0);

    endDate.value = new Date(startDate.value);
    endDate.value.setDate(startDate.value.getDate() + 6);
    endDate.value.setHours(23, 59, 59, 999);

    const fetchData = async () => {
      try {
        const response = await getWorkingTimes(
          1,
          startDate.value.toISOString(),
          endDate.value.toISOString()
        );

        const workHoursPerDay = Array(7).fill(0);

        response.data.forEach((element) => {
          const startDate = new Date(element.start);
          const endDate = new Date(element.end);

          const startHours = startDate.getHours();
          const startMinutes = startDate.getMinutes();
          const endHours = endDate.getHours();
          const endMinutes = endDate.getMinutes();

          const durationHours = endHours - startHours;
          const durationMinutes = endMinutes - startMinutes;
          const totalDuration = durationHours + durationMinutes / 60;

          const dayOfWeek = startDate.getDay();
          workHoursPerDay[dayOfWeek] += totalDuration;
        });

        chartData.value.datasets[0].data = workHoursPerDay;
        chartKey.value += 1;
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
