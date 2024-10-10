<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import { useRoute } from "vue-router";
import { getWorkingTimes } from "../functions/workingTime";

const route = useRoute();
const workingTimes = ref([]);
const userId = ref(route.params.userID);

const fetchData = async () => {
  try {
    const response = await getWorkingTimes(
      userId.value,
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

watch(route, () => {
  userId.value = route.params.userID;
  fetchData();
});
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="w-full">
      <h1>Working Times for User {{ userId }}</h1>
    </header>
    <main class="flex-grow">
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
