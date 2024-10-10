<template>
  <div>
    <h1>Chart Manager</h1>
    <div>
      <BarChart :chartData="barChartData" :options="chartOptions" />
      <LineChart :chartData="lineChartData" :options="chartOptions" />
      <PieChart :chartData="pieChartData" :options="chartOptions" />
    </div>
  </div>
</template>

<script>
import { Bar, Line, Pie } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  LineController,
  CategoryScale,
  LinearScale,
  PieController,
  ArcElement,
} from "chart.js";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  LineController,
  CategoryScale,
  LinearScale,
  PieController,
  ArcElement
);

export default {
  name: "ChartManager",
  components: {
    BarChart: Bar,
    LineChart: Line,
    PieChart: Pie,
  },
  data() {
    return {
      barChartData: {
        labels: [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
        ],
        datasets: [
          {
            label: "Working Hours",
            backgroundColor: "#f87979",
            data: [40, 39, 10, 40, 39, 80, 40],
          },
        ],
      },
      lineChartData: {
        labels: [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
        ],
        datasets: [
          {
            label: "Working Hours",
            backgroundColor: "#f87979",
            data: [40, 39, 10, 40, 39, 80, 40],
          },
        ],
      },
      pieChartData: {
        labels: [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
        ],
        datasets: [
          {
            label: "Working Hours",
            backgroundColor: [
              "#f87979",
              "#a8e6cf",
              "#ff8b94",
              "#ffaaa5",
              "#ffd3b6",
              "#dcedc1",
              "#a8e6cf",
            ],
            data: [40, 39, 10, 40, 39, 80, 40],
          },
        ],
      },
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
      },
    };
  },
  methods: {
    fetchChartData() {},
  },
  mounted() {
    this.fetchChartData();
  },
};
</script>

<style scoped>
h1 {
  text-align: center;
}
div {
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
}
</style>
