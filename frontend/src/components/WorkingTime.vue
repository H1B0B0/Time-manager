<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import {
  createWorkingTime,
  showWorkingTime,
  updateWorkingTime,
  deleteWorkingTime,
} from "../functions/WorkingTime";
import { toast, type ToastOptions } from "vue3-toastify";
import "vue3-toastify/dist/index.css";

const route = useRoute();
const router = useRouter();
const userID = ref(route.params.userID as string);
const workingTimeID = ref(route.params.workingTimeID as string);
const workingTimeData = ref({
  start: "",
  end: "",
  user_id: userID.value,
});

const toastOptions: ToastOptions = {
  autoClose: 3000,
};

const formatDateTime = (dateTimeString: string) => {
  const date = new Date(dateTimeString);
  if (isNaN(date.getTime())) {
    return "";
  }
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  return `${year}-${month}-${day}T${hours}:${minutes}`;
};

const fetchData = async () => {
  if (workingTimeID.value) {
    try {
      const fetchedWorkingTime = await showWorkingTime(
        userID.value,
        workingTimeID.value
      );
      workingTimeData.value = {
        ...fetchedWorkingTime,
        start: formatDateTime(fetchedWorkingTime.data.start),
        end: formatDateTime(fetchedWorkingTime.data.end),
      };
      toast.success("Working time fetched successfully", toastOptions);
    } catch (error) {
      console.error("Error fetching working time:", error);
      toast.error("Error fetching working time", toastOptions);
    }
  }
};

const handleCreate = async () => {
  try {
    await createWorkingTime({ workingtime: workingTimeData.value });
    toast.success("Working time created successfully", toastOptions);
  } catch (error) {
    console.error("Error creating working time:", error);
    toast.error("Error creating working time", toastOptions);
  }
};

const handleUpdate = async () => {
  try {
    await updateWorkingTime(userID.value, {
      start: workingTimeData.value.start,
      end: workingTimeData.value.end,
      id: workingTimeID.value,
    });
    console.log("Working time updated successfully");
    toast.success("Working time updated successfully", toastOptions);
  } catch (error) {
    console.error("Error updating working time:", error);
    toast.error("Error updating working time", toastOptions);
  }
};

const handleDelete = async () => {
  try {
    console.log("Deleting working time with ID:", workingTimeID.value);
    await deleteWorkingTime(workingTimeID.value);
    console.log("Working time deleted successfully");
    toast.success("Working time deleted successfully", toastOptions);
  } catch (error) {
    console.error("Error deleting working time:", error);
    toast.error("Error deleting working time", toastOptions);
  }
};

onMounted(() => {
  console.log("Component mounted, fetching data...");
  fetchData();
});

watch(route, () => {
  console.log("Route changed, fetching new data...");
  userID.value = route.params.userID as string;
  workingTimeID.value = route.params.workingTimeID as string;
  fetchData();
});
</script>

<template>
  <div
    class="w-full h-full flex flex-col items-center justify-center bg-gray-900 text-gray-100 p-8 rounded-lg"
  >
    <header class="mb-6">
      <h1 class="text-3xl font-bold">Working Time Details</h1>
    </header>
    <main class="w-full max-w-lg bg-gray-800 p-6 rounded-lg shadow-lg">
      <form
        @submit.prevent="workingTimeID ? handleUpdate() : handleCreate()"
        class="space-y-4"
      >
        <div>
          <label for="start" class="block mb-2">Start Time:</label>
          <input
            type="datetime-local"
            v-model="workingTimeData.start"
            id="start"
            required
            class="w-full p-2 bg-gray-700 text-gray-100 rounded border border-gray-600"
          />
        </div>
        <div>
          <label for="end" class="block mb-2">End Time:</label>
          <input
            type="datetime-local"
            v-model="workingTimeData.end"
            id="end"
            required
            class="w-full p-2 bg-gray-700 text-gray-100 rounded border border-gray-600"
          />
        </div>
        <div class="flex justify-between">
          <button
            type="submit"
            class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600"
          >
            {{ workingTimeID ? "Update" : "Create" }}
          </button>
          <button
            v-if="workingTimeID"
            @click="handleDelete"
            type="button"
            class="bg-red-500 text-white p-2 rounded hover:bg-red-600"
          >
            Delete
          </button>
        </div>
      </form>
    </main>
  </div>
</template>
