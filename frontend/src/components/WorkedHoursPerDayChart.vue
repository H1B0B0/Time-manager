<template>
  <div class="p-4 rounded-lg shadow bg-gray-800">
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>

    <div id="date-range-picker" class="flex items-center">
      <div class="relative">
        <input type="date" v-model="startDate" id="startDate" name="startDate"
          class=" border border-gray-300 bg-gray-800 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full ps-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
          placeholder="Select date start" />
      </div>
      <span class="mx-4 text-gray-500">to</span>
      <div class="relative">
        <input type="date" v-model="endDate" id="endDate" name="endDate"
          class="border border-gray-300 bg-gray-800 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full ps-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
          placeholder="Select date end" />
      </div>
    </div>

    <br>

    <div class="bg-gray-800 p-4 rounded-lg">
      <Bar :key="chartKey" id="my-chart-id" :options="chartOptions" :data="chartData" />
    </div>
  </div>
</template>

<script>
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
import { ref, watch } from 'vue'
import { getClocksDate, hoursWorkedPerDay } from '../functions/Clock'
import router from '@/router'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

export default {
  name: 'BarChart',
  components: { Bar },
  setup() {
    const chartData = ref({
      labels: [],
      datasets: [
        {
          data: [],
          backgroundColor: '#7B61FF',
          borderColor: '#7B61FF',
          label: 'Worked hours'
        }
      ]
    })

    const chartOptions = ref({
      responsive: true,
      plugins: {
        legend: {
          labels: {
            color: 'white'
          }
        }
      },
      scales: {
        x: {
          ticks: {
            color: 'white'
          }
        },
        y: {
          ticks: {
            color: 'white'
          }
        }
      }
    })

    const errorMessage = ref('')
    const chartKey = ref(0)
    const startDate = ref('')
    const endDate = ref('')

    watch([startDate, endDate], async () => {
      if (!startDate.value || !endDate.value) {
        return;
      }

      try {
        const dates = await getClocksDate(router.currentRoute.value.params.userID, startDate.value, endDate.value)
        const workedTimePerDay = await hoursWorkedPerDay(dates)

        chartData.value.labels = workedTimePerDay.map(day => day.date)
        chartData.value.datasets[0].data = workedTimePerDay.map(day => day.hours)

        chartKey.value += 1
      } catch (error) {
        errorMessage.value = 'Failed to fetch data'
        console.error(error)
      }
    })

    return {
      chartData,
      chartOptions,
      errorMessage,
      chartKey,
      startDate,
      endDate
    }
  }
}
</script>
