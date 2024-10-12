<template>
  <div class="mx-auto mt-10 p-6 bg-gray-900 rounded-lg shadow-xl">
    <div v-if="!isCreating" class="mb-6">
      <h2 v-if="!isCreating" class="text-2xl font-bold mb-6 text-center text-white">Log in 🔐</h2>
      <input v-model="email" placeholder="Email" required
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <input v-model="username" placeholder="Username" required
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <button @click="login" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">
        Search
      </button>
    </div>

    <p v-if="!isCreating" class="text-white text-center my-2 -mt-5 font-bold">or</p>

    <button v-if="!isCreating" @click="startCreating"
      class="w-full bg-green-600 text-white p-2 rounded hover:bg-green-700">
      Create an account
    </button>

    <div v-if="isCreating">
      <h2 class="text-2xl font-bold mb-6 text-center text-white mt-2">Create an account 👋🏻</h2>
      <input v-model="newEmail" placeholder="Email" required
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <input v-model="newUsername" placeholder="Username" required
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <button @click="register" class="w-full bg-green-500 text-white p-2 rounded hover:bg-green-600">Create an
        account</button>
      <button type="button" @click="cancelCreating"
        class=" w-full bg-gray-500 text-white p-2 rounded hover:bg-gray-600 mt-5">
        Already have an account
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useUserStore } from '@/stores/use-user-store';
import { createUser, getUser } from '@/functions/User';
import { toast } from 'vue3-toastify';

const email = ref('');
const username = ref('');
const newEmail = ref('');
const newUsername = ref('');
const isCreating = ref(false);

const login = async () => {
  try {
    const response = await getUser(username.value, email.value);
    useUserStore().setUser(response);
    toast.success('Successfully logged in');
  } catch (error) {
    toast.error('Error logging in');
  }
};

const register = async () => {
  try {
    await createUser({
      email: newEmail.value,
      username: newUsername.value
    });
    toast.success('Account created successfully');
  } catch (error) {
    toast.error('Error creating the account');
  }
};

const startCreating = () => {
  isCreating.value = true;
};

const cancelCreating = () => {
  isCreating.value = false;
};
</script>
