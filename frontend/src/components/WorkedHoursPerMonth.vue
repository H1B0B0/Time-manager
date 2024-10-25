<template>
  <div class="p-4 rounded-lg h-full flex flex-col">
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl flex-1">
      <Line
        :key="chartKey"
        id="my-chart-id"
        :options="chartOptions"
        :data="chartData"
      />
      <div class="text-center text-white mt-4">
        <h2>
          Total hours worked this month: {{ formatTotalHours(totalHours) }}
        </h2>
      </div>
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
import { ref, onMounted } from "vue";
import router from "@/router";
import { getClocksDate, hoursWorkedPerDay } from "../functions/Clock";

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
          backgroundColor: "rgba(0, 0, 0, 0)",
          borderColor: "#0bf5f1",
          label: "Worked hours per month (Cumulative)",
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
        tooltip: {
          callbacks: {
            label: function (context) {
              const hours = Math.floor(context.raw);
              const minutes = Math.round((context.raw - hours) * 60);
              return `${hours}h ${minutes}m`;
            },
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
            callback: function (value) {
              const hours = Math.floor(value);
              const minutes = Math.round((value - hours) * 60);
              return `${hours}h ${minutes}m`;
            },
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
    const totalHours = ref(0); // Track total hours worked in the month
    const date = ref(new Date());

    startDate.value = new Date(
      date.value.getFullYear(),
      date.value.getMonth(),
      1
    );
    startDate.value.setUTCHours(0, 0, 0, 0);

    endDate.value = new Date(
      date.value.getFullYear(),
      date.value.getMonth() + 1,
      0
    );
    endDate.value.setUTCHours(23, 59, 59, 999);

    const fetchData = async () => {
      try {
        const response = await getClocksDate(
          router.currentRoute.value.params.userID,
          startDate.value.toString(),
          endDate.value.toString()
        );
        const workedTimePerDay = hoursWorkedPerDay(response);

        const daysInMonth = new Date(
          date.value.getFullYear(),
          date.value.getMonth() + 1,
          0
        ).getDate();
        const labels = Array.from({ length: daysInMonth }, (_, i) => i + 1);

        const dailyData = Array(daysInMonth).fill(0);

        workedTimePerDay.forEach((workDay) => {
          const [day, month, year] = workDay.date.split("/").map(Number);
          const dayOfMonth = new Date(
            Date.UTC(year, month - 1, day)
          ).getUTCDate();
          dailyData[dayOfMonth - 1] = workDay.hours;
        });

        // Compute cumulative data
        const cumulativeData = dailyData.reduce((acc, curr, index) => {
          if (index === 0) {
            acc.push(curr);
          } else {
            acc.push(acc[index - 1] + curr);
          }
          return acc;
        }, []);

        // Update chart data and total hours
        chartData.value.labels = labels;
        chartData.value.datasets[0].data = cumulativeData;
        totalHours.value = cumulativeData[cumulativeData.length - 1]; // Total hours at the end of the month

        chartKey.value += 1;
      } catch (error) {
        errorMessage.value = "Failed to fetch data";
        console.error(error);
      }
    };

    const formatTotalHours = (total) => {
      const hours = Math.floor(total);
      const minutes = Math.round((total - hours) * 60);
      return `${hours}h ${minutes}m`;
    };

    onMounted(fetchData);

    return {
      chartData,
      chartOptions,
      errorMessage,
      chartKey,
      startDate,
      endDate,
      totalHours, // Pass total hours to the template
      formatTotalHours, // Pass the format function to the template
    };
  },
};
</script>
