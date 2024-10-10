<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import {
  createWorkingTime,
  showWorkingTime,
  updateWorkingTime,
  deleteWorkingTime,
} from "../functions/workingTime";

const route = useRoute();
const router = useRouter();
const userID = ref(route.params.userID);
const workingTimeID = ref(route.params.workingTimeID);
const workingTimeData = ref({
  start: "",
  end: "",
  user_id: userID.value,
});

const fetchData = async () => {
  if (workingTimeID.value) {
    try {
      const fetchedWorkingTime = await showWorkingTime(
        userID.value,
        workingTimeID.value
      );
      workingTimeData.value = fetchedWorkingTime;
    } catch (error) {
      console.error("Error fetching working time:", error);
    }
  }
};

const handleCreate = async () => {
  try {
    await createWorkingTime({ workingtime: workingTimeData.value });
    router.push(`/workingTime/${userID.value}`);
  } catch (error) {
    console.error("Error creating working time:", error);
  }
};

const handleUpdate = async () => {
  try {
    await updateWorkingTime(userID.value, workingTimeID.value, {
      workingtime: workingTimeData.value,
    });
    router.push(`/workingTime/${userID.value}`);
  } catch (error) {
    console.error("Error updating working time:", error);
  }
};

const handleDelete = async () => {
  try {
    await deleteWorkingTime(userID.value, workingTimeID.value);
    router.push(`/workingTime/${userID.value}`);
  } catch (error) {
    console.error("Error deleting working time:", error);
  }
};

onMounted(() => {
  fetchData();
});

watch(route, () => {
  userID.value = route.params.userID;
  workingTimeID.value = route.params.workingTimeID;
  fetchData();
});
</script>

<template>
  <div class="container">
    <header>
      <h1>Working Time Details</h1>
    </header>
    <main>
      <form @submit.prevent="workingTimeID ? handleUpdate() : handleCreate()">
        <div>
          <label for="start">Start Time:</label>
          <input
            type="datetime-local"
            v-model="workingTimeData.start"
            id="start"
            required
          />
        </div>
        <div>
          <label for="end">End Time:</label>
          <input
            type="datetime-local"
            v-model="workingTimeData.end"
            id="end"
            required
          />
        </div>
        <button type="submit">{{ workingTimeID ? "Update" : "Create" }}</button>
      </form>
      <button v-if="workingTimeID" @click="handleDelete">Delete</button>
    </main>
  </div>
</template>

<style scoped>
.container {
  padding: 20px;
  max-width: 600px;
  margin: 0 auto;
}

header {
  text-align: center;
  margin-bottom: 20px;
}

form {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

form div {
  margin-bottom: 10px;
}

label {
  display: block;
  margin-bottom: 5px;
}

input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

button {
  padding: 10px 15px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}

button + button {
  margin-left: 10px;
}
</style>
