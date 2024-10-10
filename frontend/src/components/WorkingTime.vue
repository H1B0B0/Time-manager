<script setup lang="ts">
import { onMounted } from "vue";
import { createWorkingTime, showWorkingTime } from "../functions/workingTime";

const fetchData = async () => {
  try {
    let data = {
      workingtime: {
        start: "2024-10-06T12:13:00",
        end: "2024-10-06T12:13:00",
        user_id: 4,
      },
    };
    const workingTime = await createWorkingTime(data);
    console.log(workingTime);
  } catch (error) {
    console.error(error);
  }

  try {
    const workingTime = await showWorkingTime("4", "4");
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
  <header></header>
</template>
