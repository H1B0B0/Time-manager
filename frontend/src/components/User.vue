<template>
  <div>
    <input v-model="email" placeholder="Enter email" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"/>
    <input v-model="username" placeholder="Enter username" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
    <button
      @click="fetchData"
      class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
    >
      Fetch Data
    </button>
    <button
      @click="deleteAccount"
      class="focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900"
    >
      Delete Account
    </button>
    <div v-if="data">
      <p>Hello, {{ data.data.username }}</p>
    </div>
    <div v-if="error">
      <pre>{{ error.message }}</pre>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      username: '',
      data: null,
      error: null
    };
  },
  methods: {
    async fetchData() {
      try {
        const response = await fetch(`http://localhost:4000/api/users?email=${this.email}&username=${this.username}`);
        if (!response.ok) {
          throw new Error('There was an error with the fetch operation');
        }
        this.data = await response.json();
      } catch (error) {
        this.error = error;
        console.error('There was a problem with the fetch operation:', error);
      }
    },
    async deleteAccount() {
      try {
        const userId = this.data.data.id; // Assuming the user ID is stored in this.data.data.id
        const response = await fetch(`http://localhost:4000/api/users/${userId}`, {
          method: 'DELETE'
        });
        if (!response.ok) {
          throw new Error('There was an error with the delete operation');
        }
        this.data = null; // Clear the data after successful deletion
      } catch (error) {
        this.error = error;
        console.error('There was a problem with the delete operation:', error);
      }
    }
  }
};
</script>
