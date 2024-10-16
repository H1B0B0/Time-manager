<template>
    <h1>
        Admin Dashboard
    </h1>
</template>

<script>
import { getAllUsers } from '@/functions/User';
import { ref } from 'vue';

const users = ref([]);

getAllUsers().then((response) => {
    users.value = response.data;
    console.log(users.value);
});
</script>