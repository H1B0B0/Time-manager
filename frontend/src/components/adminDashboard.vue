<template>
  <div class="text-white">
    <h1 class="text-2xl font-bold mb-4 text-center">Team 1</h1>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl">
      <table class="max-w-full divide-y divide-white">
        <thead>
          <tr>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Id
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Username
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Email
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Role
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Info
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Schedule
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-white">
          <tr v-for="user in users" :key="user.id">
            <td
              class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-300 text-center"
            >
              {{ user.id }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              {{ user.username }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              {{ user.email }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              {{ user.role }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              <button
                v-on:click="viewUserInfo(user.id)"
                type="button"
                class="text-white bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-purple-300 dark:focus:ring-purple-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
              >
                View
              </button>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              <button
                type="button"
                class="text-white bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-purple-300 dark:focus:ring-purple-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
              >
                Modify
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <h1 class="text-2xl font-bold mb-4 mt-4 text-center">Team 2</h1>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl">
      <table class="max-w-full divide-y divide-white">
        <thead>
          <tr>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Id
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Username
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Email
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Role
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Schedule
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-white">
          <tr v-for="user in users" :key="user.id">
            <td
              class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-300 text-center"
            >
              {{ user.id }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              {{ user.username }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              {{ user.email }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              {{ user.role }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300 text-center">
              <button
                type="button"
                class="text-white bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-purple-300 dark:focus:ring-purple-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
              >
                Modify
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { getAllUsers } from "@/functions/User";
import router from "@/router";
import { ref } from "vue";

export default {
  name: "AdminDashboard",
  setup() {
    const users = ref([]);

    const viewUserInfo = (id) => {
      router.push({ name: "Dashboard", params: { id: id } });
    };

    getAllUsers().then((response) => {
      users.value = response.data;
    });

    return {
      users,
      viewUserInfo,
    };
  },
};
</script>