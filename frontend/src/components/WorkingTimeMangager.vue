<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import { useRoute } from "vue-router";
import { getWorkingTimes } from "../functions/WorkingTime";
import { toast, type ToastOptions } from "vue3-toastify";
import "vue3-toastify/dist/index.css";

const route = useRoute();
interface WorkingTime {
  id: number;
  start: string;
  end: string;
}

const workingTimes = ref<WorkingTime[]>([]);
const userId = ref(Array.isArray(route.params.userID) ? route.params.userID[0] : route.params.userID);

const toastOptions: ToastOptions = {
  autoClose: 3000,
};

const fetchData = async () => {
  try {
    const today = new Date();
    const startDate = "1951-01-14T00:00:00Z";
    const endDate = new Date(today.setFullYear(today.getFullYear() + 100)).toISOString();

    const response = await getWorkingTimes(userId.value, startDate, endDate);
    workingTimes.value = response;
    
    toast.success("Working times fetched successfully", toastOptions);
  } catch (error) {
    console.error(error);
    toast.error("Error fetching working times", toastOptions);
  }
};

onMounted(() => {
  console.log("Component mounted, fetching data...");
  fetchData();
});

watch(route, () => {
  console.log("Route changed, fetching new data...");
  userId.value = Array.isArray(route.params.userID) ? route.params.userID[0] : route.params.userID;
  fetchData();
});
</script>

<template>
  <div class="w-full h-full flex flex-col bg-gray-900 text-gray-100 p-6 rounded-lg">
    <header class="w-full flex justify-center py-4">
      <h1 class="text-2xl font-bold bg-blue-600 text-white py-2 px-4 rounded-full shadow-lg">
        Working Times for User {{ userId }}
      </h1>
    </header>
    <main class="flex-grow p-4">
      <div class="overflow-x-auto">
        <table class="min-w-full bg-gray-800 shadow-md rounded-lg overflow-hidden">
          <thead class="bg-gray-700">
            <tr>
              <th class="py-2 px-4 text-left">Start Time</th>
              <th class="py-2 px-4 text-left">End Time</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="workingTime in workingTimes" :key="workingTime.id"
              class="border-b border-gray-700 hover:bg-gray-600">
              <router-link :to="`/workingtime/${userId}/${workingTime.id}`" class="contents">
                <td class="py-2 px-4">{{ new Date(workingTime.start).toLocaleString() }}</td>
                <td class="py-2 px-4">{{ new Date(workingTime.end).toLocaleString() }}</td>
              </router-link>
            </tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</template>