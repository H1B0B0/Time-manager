<template>
  <div class="p-4 rounded-lg w-full max-w-7xl mx-auto">
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl w-full">
      <div class="flex flex-row items-center justify-between mb-4">
        <div class="flex justify-center mb-4">
          <select
            v-model="view"
            @change="updateDateRange"
            class="px-4 py-2 mx-2 rounded-lg transition duration-300 ease-in-out transform hover:scale-105 backdrop-blur-2xl border text-black shadow-lg hover:bg-white hover:text-black"
          >
            <option value="day">Day</option>
            <option value="week">Week</option>
            <option value="month">Month</option>
          </select>
        </div>
        <div class="flex mb-4 justify-end">
          <div class="flex flex-wrap justify-end">
            <input
              v-if="view === 'day'"
              type="date"
              v-model="selectedDate"
              @change="updateDateRange"
              class="px-4 py-2 mx-2 mb-2 rounded-lg transition duration-300 ease-in-out transform hover:scale-105 backdrop-blur-2xl border text-black shadow-lg hover:bg-white"
            />
            <input
              v-if="view === 'week'"
              type="week"
              v-model="selectedWeek"
              @change="updateDateRange"
              class="px-4 py-2 mx-2 mb-2 rounded-lg transition duration-300 ease-in-out transform hover:scale-105 backdrop-blur-2xl border text-black shadow-lg hover:bg-white"
            />
            <input
              v-if="view === 'month'"
              type="month"
              v-model="selectedMonth"
              @change="updateDateRange"
              class="px-4 py-2 mx-2 mb-2 rounded-lg transition duration-300 ease-in-out transform hover:scale-105 backdrop-blur-2xl border text-black shadow-lg hover:bg-white"
            />
          </div>
        </div>
      </div>
      <div class="text-center text-white mb-4">
        <p v-if="view === 'day'">{{ currentDay }}</p>
        <p v-if="view === 'week'">{{ currentWeek }}</p>
        <p v-if="view === 'month'">{{ currentMonth }}</p>
      </div>
      <div class="relative w-full h-96">
        <Bar
          :key="chartKey"
          id="my-chart-id"
          :options="chartOptions"
          :data="chartData"
          class="w-full h-full"
        />
      </div>
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
import { ref, watch, onMounted } from "vue";
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
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: "#36A2EB",
          borderColor: "#36A2EB",
          label: "Schedule",
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
    const view = ref("week");
    const startDate = ref(new Date());
    const endDate = ref(new Date());
    const currentDay = ref("");
    const currentWeek = ref("");
    const currentMonth = ref("");
    const selectedDate = ref("");
    const selectedWeek = ref("");
    const selectedMonth = ref("");

    const setView = (newView) => {
      view.value = newView;
      updateDateRange();
    };

    const getStartAndEndOfWeek = (weekString) => {
      const [year, week] = weekString.split("-W").map(Number);
      const firstDayOfYear = new Date(Date.UTC(year, 0, 1));
      const daysOffset = (week - 1) * 7;
      const startOfWeek = new Date(
        firstDayOfYear.setUTCDate(firstDayOfYear.getUTCDate() + daysOffset)
      );
      const dayOfWeek = startOfWeek.getUTCDay();
      const diffToMonday = (dayOfWeek + 6) % 7;
      startOfWeek.setUTCDate(startOfWeek.getUTCDate() - diffToMonday);
      const endOfWeek = new Date(startOfWeek);
      endOfWeek.setUTCDate(startOfWeek.getUTCDate() + 6);
      endOfWeek.setUTCHours(23, 59, 59, 999);
      return { startOfWeek, endOfWeek };
    };

    const getCurrentWeek = () => {
      const today = new Date();
      const firstDayOfYear = new Date(Date.UTC(today.getUTCFullYear(), 0, 1));
      const pastDaysOfYear = (today - firstDayOfYear) / 86400000;
      const weekNumber = Math.ceil(
        (pastDaysOfYear + firstDayOfYear.getUTCDay() + 1) / 7
      );
      return `${today.getUTCFullYear()}-W${String(weekNumber).padStart(
        2,
        "0"
      )}`;
    };

    const updateDateRange = () => {
      const today = new Date();
      if (view.value === "day") {
        const selected = selectedDate.value
          ? new Date(selectedDate.value)
          : today;
        startDate.value = new Date(selected);
        startDate.value.setUTCHours(0, 0, 0, 0);
        endDate.value = new Date(selected);
        endDate.value.setUTCHours(23, 59, 59, 999);
        currentDay.value = selected.toLocaleDateString("en-US", {
          weekday: "long",
          year: "numeric",
          month: "long",
          day: "numeric",
        });
      } else if (view.value === "week") {
        if (!selectedWeek.value) {
          selectedWeek.value = getCurrentWeek();
        }
        const { startOfWeek, endOfWeek } = getStartAndEndOfWeek(
          selectedWeek.value
        );
        startDate.value = startOfWeek;
        endDate.value = endOfWeek;
        currentWeek.value = `${startDate.value.toLocaleDateString("en-US", {
          month: "long",
          day: "numeric",
        })} - ${endDate.value.toLocaleDateString("en-US", {
          month: "long",
          day: "numeric",
        })}`;
      } else if (view.value === "month") {
        const selected = selectedMonth.value
          ? new Date(selectedMonth.value + "-01")
          : today;
        startDate.value = new Date(
          selected.getFullYear(),
          selected.getMonth(),
          1
        );
        endDate.value = new Date(
          selected.getFullYear(),
          selected.getMonth() + 1,
          0
        );
        endDate.value.setUTCHours(23, 59, 59, 999);

        currentMonth.value = selected.toLocaleDateString("en-US", {
          month: "long",
          year: "numeric",
        });
      }
      fetchData();
    };

    const fetchData = async () => {
      try {
        const response = await getWorkingTimes(
          1,
          startDate.value.toISOString(),
          endDate.value.toISOString()
        );

        const workHoursPerDay = Array(
          view.value === "month" ? endDate.value.getUTCDate() : 7
        ).fill(0);

        response.data.forEach((element) => {
          const startDate = new Date(element.start);
          const endDate = new Date(element.end);

          const startHours = startDate.getUTCHours();
          const startMinutes = startDate.getUTCMinutes();
          const endHours = endDate.getUTCHours();
          const endMinutes = endDate.getUTCMinutes();

          const durationHours = endHours - startHours;
          const durationMinutes = endMinutes - startMinutes;
          const totalDuration = durationHours + durationMinutes / 60;

          const dayOfWeek = startDate.getUTCDay();
          const dayOfMonth = startDate.getUTCDate() - 1;

          if (view.value === "day") {
            workHoursPerDay[0] += totalDuration;
          } else if (view.value === "week") {
            workHoursPerDay[dayOfWeek] += totalDuration;
          } else if (view.value === "month") {
            workHoursPerDay[dayOfMonth] += totalDuration;
          }
        });

        if (view.value === "day") {
          chartData.value.labels = ["Today"];
          chartData.value.datasets[0].data = workHoursPerDay.slice(0, 1);
        } else if (view.value === "week") {
          chartData.value.labels = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
          ];
          chartData.value.datasets[0].data = workHoursPerDay;
        } else if (view.value === "month") {
          chartData.value.labels = Array.from(
            { length: endDate.value.getUTCDate() },
            (_, i) => i + 1
          );
          chartData.value.datasets[0].data = workHoursPerDay;
        }

        chartKey.value += 1;
      } catch (error) {
        errorMessage.value = "Failed to fetch data";
        console.error(error);
      }
    };

    onMounted(() => {
      const today = new Date();
      selectedDate.value = today.toISOString().split("T")[0];
      selectedWeek.value = getCurrentWeek();
      selectedMonth.value = today.toISOString().split("T")[0].slice(0, 7);

      updateDateRange();
    });

    watch([selectedDate, selectedWeek, selectedMonth, view], updateDateRange);

    return {
      chartData,
      chartOptions,
      errorMessage,
      chartKey,
      view,
      setView,
      currentDay,
      currentWeek,
      currentMonth,
      selectedDate,
      selectedWeek,
      selectedMonth,
    };
  },
};
</script>
