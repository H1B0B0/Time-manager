<template>
  <div
    class="max-w-md mx-auto mt-10 p-6 backdrop-blur-2xl border rounded-lg shadow-2xl"
  >
    <div v-if="!isCreating" class="mb-6">
      <h2 class="text-3xl font-bold mb-6 text-center text-white">Log in 🔐</h2>
      <input
        v-model="email"
        placeholder="Email"
        type="email"
        required
        class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <input
        v-model="password"
        placeholder="Password"
        type="password"
        required
        class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <button
        @click="Handlelogin"
        :disabled="!email || !password"
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
      <input
        v-model="newPassword"
        placeholder="Password"
        type="password"
        required
        class="w-full p-3 mb-4 border rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <input
        v-model="confirmPassword"
        placeholder="Confirm Password"
        type="password"
        required
        class="w-full p-3 mb-4 border rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
      />
      <button
        @click="register"
        :disabled="
          !newEmail || !newUsername || !newPassword || !confirmPassword
        "
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
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useUserStore } from "@/stores/use-user-store";
import { createUser, login, GetUserByToken } from "@/functions/User";
import { toast } from "vue3-toastify";
import confetti from "canvas-confetti";
import axios from "axios"; // Import axios

const router = useRouter();
const userStore = useUserStore();

const email = ref("");
const username = ref("");
const password = ref("");
const newEmail = ref("");
const newUsername = ref("");
const newPassword = ref("");
const confirmPassword = ref("");
const isCreating = ref(false);
const error = ref("");

const Handlelogin = async () => {
  try {
    error.value = "";
    const response = await login(email.value, password.value);
    userStore.setUser(response.data);
    console.log(response.data);
    toast.success("Successfully logged in");
    router.push(`/dashboard/${response.data.id}`); // Rediriger vers le tableau de bord
  } catch (err) {
    if (axios.isAxiosError(err) && err.response) {
      error.value = err.response.data.message || "Error logging in";
    } else {
      error.value = "An unexpected error occurred";
    }
    toast.error(error.value);
  }
};

const register = async () => {
  if (newPassword.value !== confirmPassword.value) {
    toast.error("Passwords do not match");
    return;
  }

  if (
    !newEmail.value ||
    !newUsername.value ||
    !newPassword.value ||
    !confirmPassword.value
  ) {
    toast.error("Please fill in all fields");
    return;
  }

  try {
    await createUser({
      email: newEmail.value,
      username: newUsername.value,
      password: newPassword.value,
    });
    toast.success("Account created successfully");
    confetti({
      particleCount: 200,
      spread: 160,
      origin: { x: 0.5, y: 0.5 },
      zIndex: 9999,
    });
    isCreating.value = false; // Revenir à l'écran de connexion
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

onMounted(async () => {
  try {
    const user = await GetUserByToken();
    if (user) {
      userStore.setUser(user);
      router.push(`/dashboard/${user.id}`); // Rediriger vers le tableau de bord si déjà connecté
    }
  } catch (error) {
    console.log("User not logged in");
  }
});
</script>
