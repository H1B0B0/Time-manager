<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import { useRoute } from "vue-router";
import { useUserStore } from "@/stores/use-user-store";
import { getLatestClock, createClock } from "@/functions/Clock";
import type { ClockType } from "@/types/ClockType";
import confetti from "canvas-confetti";
import { toast } from "vue3-toastify";

const route = useRoute();

const userId = ref(parseInt(route.params.userID as string));
const latestClock = ref({} as ClockType);
const clockedIn = ref(false);
const isButtonDisabled = ref(false);
const userStore = useUserStore();

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
  if (isButtonDisabled.value) return;

  isButtonDisabled.value = true;
  setTimeout(() => {
    isButtonDisabled.value = false;
  }, 2000);

  try {
    if (userId.value.toString() != userStore.user.id?.toString()) {
      toast.error("Unauthorized to perform this action");
      throw new Error("Unauthorized");
    } else {
      const newClock = await createClock(userId.value.toString(), {
        user_id: userId.value.toString(),
        status: !clockedIn.value,
        time: new Date(),
      });
      latestClock.value = newClock;
      clockedIn.value = newClock.status;
      if (!clockedIn.value) {
        setTimeout(() => {
          confetti({
            particleCount: 200,
            spread: 160,
            origin: { x: 0.5, y: 0.5 },
            zIndex: 9999,
          });
        }, 100);
      }
    }
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
    class="flex flex-col text-gray-100 items-center justify-center p-8 rounded-2xl backdrop-blur-2xl border max-w-96"
  >
    <main class="flex flex-col items-center py-4">
      <button
        v-on:click="handleClockCreation"
        :disabled="isButtonDisabled"
        :class="[
          'text-2xl',
          'font-bold',
          'text-white',
          'py-2',
          'px-4',
          'rounded-2xl',
          'shadow-lg',
          'backdrop-blur-2xl',
          clockedIn
            ? 'border border-red-500 hover:bg-red-500 hover:text-white'
            : 'border border-green-500 hover:bg-green-500 hover:text-white',
          isButtonDisabled
            ? 'opacity-50 cursor-not-allowed'
            : 'opacity-100 cursor-pointer',
        ]"
      >
        {{ clockedIn ? "Clock Out" : "Clock In" }}
      </button>

      <p class="text-gray-500 mt-4">{{ message }}</p>
    </main>
  </div>
</template>
