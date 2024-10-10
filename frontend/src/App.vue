<script setup lang="ts">
import { onMounted } from "vue";
import { createWorkingTime, showWorkingTime } from "./functions/workingTime";

const fetchData = async () => {
  try {
    let data = {
      workingtime: {
        start: "2024-10-06T12:13:00",
        end: "2024-10-06T12:13:00",
        user_id: 49,
      },
    };
    const workingTime = await createWorkingTime(data);
    console.log(workingTime);
  } catch (error) {
    console.error(error);
  }

  try {
    const workingTime = await showWorkingTime("49", "120"); // 49 is the user_id and 120 is the id of the working time
    console.log(workingTime);
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
      <NavBar />
      <User />
    </main>
  </div>
</template>
