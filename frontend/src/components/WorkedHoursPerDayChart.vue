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
        <VueDatePicker
          v-model="dateRange"
          range
          :format="dateFormat"
          input-class="custom-input"
          popup-class="custom-popup"
          calendar-class="custom-calendar"
          placeholder="Select date range"
          @change="validateDateRange"
        />
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
  Filler,
} from "chart.js";
import { ref, watch, onMounted } from "vue";
import { getClocksDate, hoursWorkedPerDay } from "../functions/Clock";
import router from "@/router";
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  Filler
);

export default {
  name: "BarChart",
  components: { Bar, VueDatePicker },
  setup() {
    const chartData = ref({
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: "#0bf5f1",
          borderColor: "#0bf5f1",
          label: "Worked hours",
          fill: true, // Enable fill
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
    const dateRange = ref([new Date(), new Date()]);
    const isDateRangeValid = ref(true);
    const dateFormat = "yyyy-MM-dd";

    const validateDateRange = () => {
      if (dateRange.value[0] && dateRange.value[1]) {
        isDateRangeValid.value =
          new Date(dateRange.value[0]) <= new Date(dateRange.value[1]);
      }
    };

    const fetchData = async () => {
      validateDateRange();
      if (
        !dateRange.value[0] ||
        !dateRange.value[1] ||
        !isDateRangeValid.value
      ) {
        return;
      }

      try {
        const dates = await getClocksDate(
          router.currentRoute.value.params.userID,
          dateRange.value[0],
          dateRange.value[1]
        );
        const workedTimePerDay = await hoursWorkedPerDay(dates);

        workedTimePerDay.sort((a, b) => {
          const [dayA, monthA, yearA] = a.date.split("/").map(Number);
          const [dayB, monthB, yearB] = b.date.split("/").map(Number);

          const dateA = new Date(yearA, monthA - 1, dayA);
          const dateB = new Date(yearB, monthB - 1, dayB);

          return dateA - dateB;
        });

        chartData.value.labels = workedTimePerDay.map((day) => day.date);
        chartData.value.datasets[0].data = workedTimePerDay.map(
          (day) => day.hours
        );

        chartKey.value += 1;
      } catch (error) {
        errorMessage.value = "Failed to fetch data";
        console.error(error);
      }
    };

    watch(dateRange, fetchData);

    onMounted(fetchData);

    return {
      chartData,
      chartOptions,
      errorMessage,
      chartKey,
      dateRange,
      isDateRangeValid,
      validateDateRange,
      dateFormat,
    };
  },
};
</script>

<style>
.dp__theme_light {
  /* --dp-background-color: #212121; */
  --dp-text-color: #fff;
  --dp-hover-color: #484848;
  --dp-hover-text-color: #fff;
  --dp-hover-icon-color: #959595;
  --dp-primary-color: #8500b2;
  --dp-primary-disabled-color: #ba61ea;
  --dp-primary-text-color: #fff;
  --dp-secondary-color: #a9a9a9;
  --dp-border-color: #2d2d2d;
  --dp-menu-border-color: #2d2d2d;
  --dp-border-color-hover: #aaaeb7;
  --dp-border-color-focus: #aaaeb7;
  --dp-disabled-color: #737373;
  --dp-disabled-color-text: #d0d0d0;
  --dp-scroll-bar-background: #212121;
  --dp-scroll-bar-color: #484848;
  --dp-success-color: #00701a;
  --dp-success-color-disabled: #428f59;
  --dp-icon-color: #959595;
  --dp-danger-color: #e53935;
  --dp-marker-color: #e53935;
  --dp-tooltip-color: #3e3e3e;
  --dp-highlight-color: rgb(0 92 178 / 20%);
  --dp-range-between-dates-background-color: var(--dp-hover-color, #484848);
  --dp-range-between-dates-text-color: var(--dp-hover-text-color, #fff);
  --dp-range-between-border-color: var(--dp-hover-color, #fff);
}

.dp__theme_dark {
  --dp-background-color: #212121;
  --dp-text-color: #fff;
  --dp-hover-color: #484848;
  --dp-hover-text-color: #fff;
  --dp-hover-icon-color: #959595;
  --dp-primary-color: #8500b2;
  --dp-primary-disabled-color: #d161ea;
  --dp-primary-text-color: #fff;
  --dp-secondary-color: #a9a9a9;
  --dp-border-color: #2d2d2d;
  --dp-menu-border-color: #2d2d2d;
  --dp-border-color-hover: #aaaeb7;
  --dp-border-color-focus: #aaaeb7;
  --dp-disabled-color: #737373;
  --dp-disabled-color-text: #d0d0d0;
  --dp-scroll-bar-background: #212121;
  --dp-scroll-bar-color: #484848;
  --dp-success-color: #00701a;
  --dp-success-color-disabled: #428f59;
  --dp-icon-color: #959595;
  --dp-danger-color: #e53935;
  --dp-marker-color: #e53935;
  --dp-tooltip-color: #3e3e3e;
  --dp-highlight-color: rgb(0 92 178 / 20%);
  --dp-range-between-dates-background-color: var(--dp-hover-color, #484848);
  --dp-range-between-dates-text-color: var(--dp-hover-text-color, #fff);
  --dp-range-between-border-color: var(--dp-hover-color, #fff);
}
</style>
