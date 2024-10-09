<template>
  <div>
    <input v-model="email" placeholder="Enter email" />
    <input v-model="username" placeholder="Enter username" />
    <button @click="fetchData">Fetch Data</button>
    <button @click="deleteAccount">Delete Account</button>
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
