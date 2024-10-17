<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import { useRoute } from "vue-router";
import { getLatestClock, createClock } from "@/functions/Clock";
import type { ClockType } from "@/types/ClockType";

const route = useRoute();

const userId = ref(parseInt(route.params.userID as string));
const latestClock = ref({} as ClockType);
const clockedIn = ref(false);

onMounted(async () => {
  try {
    latestClock.value = await getLatestClock(userId.value);
    clockedIn.value = latestClock.value.status;
  } catch (error) {
    console.error(error);
  }
});

const formatDate = (date: string) => {
  const today = new Date().toLocaleDateString();
  if (new Date(date).toLocaleDateString() === today) {
    return new Date(date).toLocaleTimeString();
  }
  return new Date(date).toLocaleString();
};

const handleClockCreation = async () => {
  try {
    const newClock = await createClock(userId.value.toString(), {
      user_id: userId.value.toString(),
      status: !clockedIn.value,
      time: new Date(),
    });
    latestClock.value = newClock;
    clockedIn.value = newClock.status;
  } catch (error) {
    console.error("Error creating clock:", error);
  }
};

const message = computed(() => {
  if (clockedIn.value) {
    return `You are currently clocked in since ${formatDate(
      latestClock.value.time.toString()
    )}`;
  } else {
    return "You are currently clocked out";
  }
});
</script>

<template>
  <div
    class="flex flex-col text-gray-100 items-center justify-center p-8 rounded-lg"
  >
    <main class="w-full flex flex-col items-center py-4">
      <button
        v-on:click="handleClockCreation"
        :class="[
          'text-2xl',
          'font-bold',
          'text-white',
          'py-2',
          'px-4',
          'rounded-full',
          'shadow-lg',
          clockedIn ? 'bg-red-500' : 'bg-green-500',
        ]"
      >
        {{ clockedIn ? "Clock Out" : "Clock In" }}
      </button>

      <p class="text-gray-500 mt-4">{{ message }}</p>
    </main>
  </div>
</template>
