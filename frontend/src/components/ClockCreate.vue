<script setup lang="ts">
import { createClock } from '@/functions/Clock';
import { ref } from 'vue';

const status = ref(false);
const date = ref('02/25/2024');
const time = ref('00:00');

const handleSubmit = async (event: Event) => {
    event.preventDefault();

    let data = {
        clock:{
            status: status.value,
            time: new Date(date.value + ' ' + time.value).toISOString(),
        }
    }

    try {
        const result = await createClock('1', data);
        console.log('Clock created:', result);
    } catch (error) {
        console.error('Error creating clock:', error);
    }
};
</script>

<template>
    <div
        class="block max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700 text-center mx-auto">
        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">New clock</h5>
        <hr class="h-px my-8 bg-gray-200 border-0 dark:bg-gray-700">
        <form class="max-w-sm mx-auto" @submit="handleSubmit">
            <label for="status" class="inline-flex items-center mb-5 cursor-pointer">
                <input type="checkbox" id="status" class="sr-only peer" v-model="status" checked>
                <div
                    class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:w-5 after:h-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600">
                </div>
                <span class="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Status</span>
            </label>
            <div class="relative max-w-sm">
                <div class="absolute inset-y-0 start-0 flex items-center ps-3.5 pointer-events-none">
                    <svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                        <path
                            d="M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z" />
                    </svg>
                </div>
                <input v-model="date" datepicker id="default-datepicker" type="text"
                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full ps-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                    placeholder="Select date">
            </div>
            <label for="time" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Select time:</label>
            <div class="flex">
                <input v-model="time" type="time" id="time"
                    class="rounded-none rounded-s-lg bg-gray-50 border text-gray-900 leading-none focus:ring-blue-500 focus:border-blue-500 block flex-1 w-full text-sm border-gray-300 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                    min="07:00" max="23:00" value="00:00" required>
                <span
                    class="inline-flex items-center px-3 text-sm text-gray-900 bg-gray-200 border rounded-s-0 border-s-0 border-gray-300 rounded-e-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600">
                    <svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
                        <path fill-rule="evenodd"
                            d="M2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10S2 17.523 2 12Zm11-4a1 1 0 1 0-2 0v4a1 1 0 0 0 .293.707l3 3a1 1 0 0 0 1.414-1.414L13 11.586V8Z"
                            clip-rule="evenodd" />
                    </svg>
                </span>
            </div>
            <button type="submit"
                class="text-white bg-blue-700 mt-3 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">Submit</button>
        </form>
    </div>
</template>