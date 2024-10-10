<script setup lang="ts">
import { onMounted } from "vue";
import {
  createWorkingTime,
  showWorkingTime,
  getWorkingTimes,
} from "../functions/workingTime";

const workingTimes = ref([]);
const userId = "1";

const fetchData = async () => {
  try {
    const response = await getWorkingTimes(
      userId,
      "2024-10-05 12:10:00Z",
      "2024-10-06 20:14:00Z"
    );
    console.log(response.data);
    workingTimes.value = response.data;
  } catch (error) {
    console.error(error);
  }
};

onMounted(() => {
  fetchData();
});
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="w-full"></header>
    <main class="flex-grow">
      <h1>Fetched data for User {{ userId }}</h1>
      <table>
        <thead>
          <tr>
            <th>Start Time</th>
            <th>End Time</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="workingTime in workingTimes" :key="workingTime.id">
            <td>{{ workingTime.start }}</td>
            <td>{{ workingTime.end }}</td>
          </tr>
        </tbody>
      </table>
    </main>
  </div>
</template>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  border: 1px solid #ddd;
  padding: 8px;
}

th {
  background-color: #f2f2f2;
}
</style>
