<template>
  <div>
    <input v-model="userId" placeholder="Enter user ID" />
    <button @click="fetchData">Fetch Data</button>
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
      userId: '',
      data: null,
      error: null
    };
  },
  methods: {
    async fetchData() {
      try {
        const response = await fetch(`http://localhost:4000/api/users/${this.userId}`);
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        this.data = await response.json();
      } catch (error) {
        this.error = error;
        console.error('There was a problem with the fetch operation:', error);
      }
    }
  }
};
</script>

<style scoped>
/* Add your styles here */
</style>
