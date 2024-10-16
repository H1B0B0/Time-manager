<template>
  <div class="text-white">
    <h1 class="text-2xl font-bold mb-4 text-center mb-2">Admin Dashboard</h1>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl">
      <table class="max-w-full divide-y  divide-white">
        <thead >
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Id</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Username</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Email</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Role</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-white">
          <tr v-for="user in users" :key="user.id">
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-300">{{ user.id }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">{{ user.username }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">{{ user.email }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">{{ user.role }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { getAllUsers } from '@/functions/User';
import { ref } from 'vue';

export default {
  name: 'AdminDashboard',
  setup() {
    const users = ref([]);

    getAllUsers().then((response) => {
      users.value = response.data;
    });

    return {
      users,
    };
  },
};
</script>