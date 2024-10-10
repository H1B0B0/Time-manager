<script setup lang="ts">
import { getClock } from '@/functions/Clock';
import { ref, onMounted } from 'vue';

const clockData = ref(null);
const render = ref(false);

const fetchClockData = async () => {
    try {
        const result = await getClock('1');
        clockData.value = result.data;
        
        render.value = clockData.value.length > 0;
    } catch (error) {
        console.error('Error fetching clock data:', error);
    }
};

onMounted(() => {
    fetchClockData();
});

</script>

<template>
    <div v-if="render" class="relative overflow-x-auto shadow-md sm:rounded-lg">
        <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                <tr>
                    <th scope="col" class="px-6 py-3">
                        Status
                    </th>
                    <th scope="col" class="px-6 py-3">
                        Time
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr
                    class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
                    v-for="clock in clockData"
                    >
                    <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                        {{ clock['status'] }}
                    </th>
                    <td class="px-6 py-4">
                        {{ clock['time'] }}
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div v-else>
        <div
            class="max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
                <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">You don't have any clock !</h5>
            <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">To create one clock click on button</p>
            <a href="#"
                class="inline-flex items-center px-3 py-2 text-sm font-medium text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
                Create
                <svg class="rtl:rotate-180 w-3.5 h-3.5 ms-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                    fill="none" viewBox="0 0 14 10">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M1 5h12m0 0L9 1m4 4L9 9" />
                </svg>
            </a>
        </div>
    </div>

</template>