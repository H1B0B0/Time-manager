<template>
  <div class="mx-auto mt-10 p-6 bg-gray-900 rounded-lg shadow-xl">
    <form class="space-y-4">
      <input v-model="username" placeholder="New username"
        class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400" required />
      <input v-model="email" placeholder="New email"
        class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400" required type="email" />
      <div class="flex justify-between">
        <button @click="updateAccount" type="button" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600 w-full">
          Update account
        </button>
      </div>
    </form>
  </div>
  <button @click="deleteAccount" type="button" class="bg-red-500 text-white p-2 rounded hover:bg-red-600 w-full mt-4">
    Delete account
  </button>
</template>

<script setup>
import { ref } from 'vue';
import { useUserStore } from '@/stores/use-user-store';
import { updateUser, deleteUser } from '@/functions/User';
import { toast } from 'vue3-toastify';

const email = ref('');
const username = ref('');
const userStore = useUserStore();

const updateAccount = async () => {
  try {
    const response = await updateUser(userStore.user.id, { email: email.value, username: username.value });
    userStore.setUser(response);
    toast.success('Successfully updated account');
  } catch (error) {
    toast.error('Error updating account');
  }
};

const deleteAccount = async () => {
  try {
    await deleteUser();
    userStore.setUser(null);
    toast.success('Successfully deleted account');
  } catch (error) {
    toast.error('Error deleting account');
  }
};
</script>
