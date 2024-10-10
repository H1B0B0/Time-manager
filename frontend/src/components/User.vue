<template>
  <div class="mx-auto mt-10 p-6 bg-gray-900 rounded-lg shadow-xl">
    <h2 v-if="!isCreating" class="text-2xl font-bold mb-6 text-center text-white">Log in 🔐</h2>

    <div v-if="!data && !isCreating" class="mb-6">
      <input v-model="email" placeholder="Email"
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <input v-model="username" placeholder="Username"
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <button @click="getUser" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">
        Search
      </button>
    </div>

    <p v-if="!data && !isCreating" class="text-white text-center my-2 -mt-5 font-bold">or</p>

    <button v-if="!data && !isCreating" @click="startCreating"
      class="w-full bg-green-600 text-white p-2 rounded hover:bg-green-700">Create an account</button>

    <div v-if="isCreating">
      <h2 class="text-2xl font-bold mb-6 text-center text-white mt-2">Create an account 👋🏻</h2>
      <input v-model="newEmail" placeholder="Email"
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <input v-model="newUsername" placeholder="Username"
        class="w-full p-2 mb-3 border rounded text-white bg-gray-600 border-gray-400" />
      <button @click="createAccount" class="w-full bg-green-500 text-white p-2 rounded hover:bg-green-600">Create an
        account</button>
      <button type="button" @click="cancelCreating"
        class=" w-full bg-gray-500 text-white p-2 rounded hover:bg-gray-600 mt-5">
        Already have an account
      </button>
    </div>

    <div v-if="data">
      <div v-if="!isEditing">
        <p class="mb-2 text-white"><strong>Username</strong> {{ data.data.username }}</p>
        <p class="mb-4 text-white"><strong>Email:</strong> {{ data.data.email }}</p>
        <div class="flex justify-between">
          <button @click="startEditing" class="bg-green-500 text-white p-2 rounded hover:bg-green-600">
            Edit account
          </button>
          <button @click="deleteAccount" class="bg-red-500 text-white p-2 rounded hover:bg-red-600">
            Delete account
          </button>
        </div>
      </div>

      <form v-else @submit.prevent="updateUser" class="space-y-4">
        <input v-model="editedUsername" placeholder="New username"
          class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400" required />
        <input v-model="editedEmail" placeholder="New email"
          class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400" required type="email" />
        <div class="flex justify-between">
          <button type="submit" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600">
            Update account
          </button>
          <button type="button" @click="cancelEditing" class="bg-gray-500 text-white p-2 rounded hover:bg-gray-600">
            Cancel
          </button>
        </div>
      </form>
    </div>

    <div v-if="error" class="mt-4 p-4 bg-red-100 text-red-700 rounded">
      {{ error.message }}
    </div>
  </div>
</template>

<script>
import { defineStore } from 'pinia'
export default {
  data() {
    return {
      email: '',
      username: '',
      newEmail: '',
      newUsername: '',

      data: null,
      error: null,
      isCreating: false,
      isEditing: false,
      editedUsername: '',
      editedEmail: ''
    };
  },
  methods: {
    async getUser() {
      try {
        const response = await fetch(`https://backend.traefik.me/api/users?email=${this.email}&username=${this.username}`);
        if (!response.ok) throw new Error('Error fetching the account');
        this.data = await response.json();
        this.error = null;
      } catch (error) {
        this.error = error;
        console.error('Error fetching the account:', error);
      }
    },
    startCreating() {
      this.isCreating = true;
    },
    cancelCreating() {
      this.isCreating = false;
    },
    async createAccount() {
      try {
        const response = await fetch('https://backend.traefik.me/api/users', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            user: {
              username: this.newUsername,
              email: this.newEmail,
            }
          })
        });
        if (!response.ok) throw new Error('Error creating the account');
        const data = await response.json();
        this.data = data;
        this.error = null;
        this.isCreating = false;
      } catch (error) {
        this.error = error;
        console.error('Error creating the account:', error);
      }
    },
    startEditing() {
      this.isEditing = true;
      this.editedUsername = this.data.data.username;
      this.editedEmail = this.data.data.email;
    },
    cancelEditing() {
      this.isEditing = false;
    },
    async updateUser() {
      try {
        const response = await fetch(`https://backend.traefik.me/api/users/${this.data.data.id}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            user: {
              username: this.editedUsername,
              email: this.editedEmail
            }
          })
        });
        if (!response.ok) throw new Error('Error updating the account');
        this.data.data.username = this.editedUsername;
        this.data.data.email = this.editedEmail;
        this.isEditing = false;
        this.error = null;
      } catch (error) {
        this.error = error;
        console.error('Error updating the account', error);
      }
    },
    async deleteAccount() {
      if (!confirm('Are you sure ?')) return;
      try {
        const response = await fetch(`https://backend.traefik.me/api/users/${this.data.data.id}`, {
          method: 'DELETE'
        });
        if (!response.ok) throw new Error('Error deleting the account');
        this.data = null;
        this.error = null;
      } catch (error) {
        this.error = error;
        console.error('There was a problem ', error);
      }
    }
  }
};
</script>
