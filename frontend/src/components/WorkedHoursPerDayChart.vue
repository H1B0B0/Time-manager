<template>
  <div class="h-full flex flex-col justify-center items-center p-4">
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>

    <div
      class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl w-full max-w-4xl"
    >
      <div class="chart-container w-full" style="height: 400px">
        <Bar
          :key="chartKey"
          id="my-chart-id"
          :options="chartOptions"
          :data="chartData"
          class="w-full h-full"
        />
      </div>
      <div
        id="date-range-picker"
        class="flex items-center mt-10 justify-center sm:flex-row flex-col"
      >
        <div class="relative">
          <input
            type="date"
            v-model="startDate"
            id="startDate"
            name="startDate"
            class="border border-gray-300 text-white bg-gray-800 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full ps-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
            placeholder="Select date start"
            @change="validateDateRange"
          />
        </div>
        <span class="mx-4 text-white capitalize">to</span>
        <div class="relative">
          <input
            type="date"
            v-model="endDate"
            id="endDate"
            name="endDate"
            class="border border-gray-300 text-white bg-gray-800 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full ps-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
            placeholder="Select date end"
            @change="validateDateRange"
          />
        </div>
      </div>
      <p v-if="!isDateRangeValid" class="text-red-500 mt-2">
        The end date cannot be earlier than the start date.
      </p>
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
import { ref, watch } from "vue";
import { getClocksDate, hoursWorkedPerDay } from "../functions/Clock";
import router from "@/router";

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
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: "#36A2EB",
          borderColor: "#36A2EB",
          label: "Worked hours",
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
    const isDateRangeValid = ref(true);

    const validateDateRange = () => {
      if (startDate.value && endDate.value) {
        isDateRangeValid.value =
          new Date(startDate.value) <= new Date(endDate.value);
      }
    };

    watch([startDate, endDate], async () => {
      validateDateRange();
      if (!startDate.value || !endDate.value || !isDateRangeValid.value) {
        return;
      }

      try {
        const dates = await getClocksDate(
          router.currentRoute.value.params.userID,
          startDate.value,
          endDate.value
        );
        const workedTimePerDay = await hoursWorkedPerDay(dates);

        chartData.value.labels = workedTimePerDay.map((day) => day.date);
        chartData.value.datasets[0].data = workedTimePerDay.map(
          (day) => day.hours
        );

        chartKey.value += 1;
      } catch (error) {
        errorMessage.value = "Failed to fetch data";
        console.error(error);
      }
    });

    return {
      chartData,
      chartOptions,
      errorMessage,
      chartKey,
      startDate,
      endDate,
      isDateRangeValid,
      validateDateRange,
    };
  },
};
</script>
