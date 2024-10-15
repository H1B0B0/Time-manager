<template>
  <div
    class="max-w-md mx-auto mt-10 p-6 backdrop-blur-2xl border rounded-lg shadow-2xl"
  >
    <div v-if="!isCreating" class="mb-6">
      <h2 class="text-3xl font-bold mb-6 text-center text-white">Log in 🔐</h2>
      <input
        v-model="email"
        placeholder="Email"
        required
        class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <input
        v-model="username"
        placeholder="Username"
        required
        class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <button
        @click="login"
        :disabled="!email || !username"
        class="w-full bg-indigo-500 text-white p-3 rounded-lg hover:bg-indigo-600 transition duration-300 disabled:cursor-not-allowed"
      >
        Log in
      </button>
    </div>

    <button
      v-if="!isCreating"
      @click="startCreating"
      class="w-full bg-gradient-to-r from-[#7B61FF] via-[#4BC0C0] to-[#36A2EB] text-white p-3 rounded-lg hover:from-[#6A52E0] hover:via-[#3AA0A0] hover:to-[#2A82C9] transition duration-300"
    >
      Create an account
    </button>

    <div v-if="isCreating">
      <h2 class="text-3xl font-bold mb-6 text-center text-white mt-2">
        Create an account 👋🏻
      </h2>
      <input
        v-model="newEmail"
        placeholder="Email"
        required
        class="w-full p-3 mb-4 border rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <input
        v-model="newUsername"
        placeholder="Username"
        required
        class="w-full p-3 mb-4 border rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <button
        @click="register"
        :disabled="!newEmail || !newUsername"
        class="w-full bg-gradient-to-r from-[#7B61FF] via-[#4BC0C0] to-[#36A2EB] text-white p-3 rounded-lg hover:from-[#6A52E0] hover:via-[#3AA0A0] hover:to-[#2A82C9] transition duration-300 disabled:bg-[#A3D1F7] disabled:cursor-not-allowed"
      >
        Create an account
      </button>
      <button
        type="button"
        @click="cancelCreating"
        class="w-full bg-indigo-500 text-white p-3 rounded-lg hover:bg-indigo-600 transition duration-300 mt-5"
      >
        Already have an account ?
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useUserStore } from "@/stores/use-user-store";
import { createUser, getUser } from "@/functions/User";
import { toast } from "vue3-toastify";
import confetti from "canvas-confetti";

const email = ref("");
const username = ref("");
const newEmail = ref("");
const newUsername = ref("");
const isCreating = ref(false);

const login = async () => {
  try {
    const response = await getUser(username.value, email.value);
    useUserStore().setUser(response);
    toast.success("Successfully logged in");
  } catch (error) {
    toast.error("Error logging in");
  }
};

const register = async () => {
  try {
    await createUser({
      email: newEmail.value,
      username: newUsername.value,
    });
    toast.success("Account created successfully");
    confetti({
      particleCount: 200,
      spread: 160,
      origin: { x: 0.5, y: 0.5 },
      zIndex: 9999,
    });
  } catch (error) {
    toast.error("Error creating the account");
  }
};

const startCreating = () => {
  isCreating.value = true;
};

const cancelCreating = () => {
  isCreating.value = false;
};
</script>
