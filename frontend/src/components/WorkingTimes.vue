<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import { useRoute } from "vue-router";
import { getWorkingTimes } from "../functions/workingTime";
import { toast, type ToastOptions } from "vue3-toastify";
import "vue3-toastify/dist/index.css";

const route = useRoute();
const workingTimes = ref([]);
const userId = ref(route.params.userID);

const toastOptions: ToastOptions = {
  autoClose: 3000,
};

const fetchData = async () => {
  try {
    const response = await getWorkingTimes(
      userId.value,
      "2024-10-05 12:10:00Z",
      "2024-10-06 20:14:00Z"
    );
    console.log(response.data);
    workingTimes.value = response.data;
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
  userId.value = route.params.userID;
  fetchData();
});
</script>

<template>
  <div class="min-h-screen flex flex-col bg-gray-900 text-gray-100">
    <header class="w-full flex justify-center py-4">
      <h1
        class="text-2xl font-bold bg-blue-600 text-white py-2 px-4 rounded-full shadow-lg"
      >
        Working Times for User {{ userId }}
      </h1>
    </header>
    <main class="flex-grow p-4">
      <div class="overflow-x-auto">
        <table
          class="min-w-full bg-gray-800 shadow-md rounded-lg overflow-hidden"
        >
          <thead class="bg-gray-700">
            <tr>
              <th class="py-2 px-4 text-left">Start Time</th>
              <th class="py-2 px-4 text-left">End Time</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="workingTime in workingTimes"
              :key="workingTime.id"
              class="border-b border-gray-700"
            >
              <td class="py-2 px-4">{{ workingTime.start }}</td>
              <td class="py-2 px-4">{{ workingTime.end }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</template>
