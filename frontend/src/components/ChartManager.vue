<template>
  <div class="p-4 bg-gray-100 rounded-lg shadow">
    <h1 class="text-center text-gray-800 text-2xl font-bold mb-4">Chart Manager</h1>
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>
    <template v-if="start && end">

     <div class="bg-white p-4 rounded-lg">
        <p></p>
        <canvas ref="chartCanvas"></canvas>
      </div>
    </template>
  </div>
</template>

<script>
import { Chart, registerables } from 'chart.js';
import 'chartjs-adapter-date-fns';

Chart.register(...registerables);

export default {
  data() {
    return {
      start: null,
      end: null,
      errorMessage: null,
      chart: null
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      fetch("http://backend.traefik.me/api/workingtime/1/1")
        .then(async response => {
          const data = await response.json();
          if (!response.ok) {
            throw new Error(data.message || response.statusText);
          }
          this.start = new Date(data.data.start);
          this.end = new Date(data.data.end);
          this.$nextTick(() => {
            this.createChart();
          });
        })
        .catch(error => {
          this.errorMessage = error.message;
        });
    },
    createChart() {
      const ctx = this.$refs.chartCanvas.getContext('2d');
      const duration = (this.end.getTime() - this.start.getTime()) / (1000 * 60 * 60);

      this.chart = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: ['Working Time'],
          datasets: [{
            label: 'Duration (hours)',
            data: [duration],
            backgroundColor: 'lightblue',
            borderColor: 'lightblue',
            borderWidth: 1
          }]
        },
        options: {
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Hours'
              }
            }
          },
          plugins: {
            tooltip: {
              callbacks: {
                label: (context) => `Duration: ${context.parsed.y.toFixed(2)} hours`
              }
            }
          }
        }
      });
    },
    formatDate(date) {
      return date.toLocaleString();
    }
  }
};
</script>
