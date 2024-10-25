<template>
  <div class="flex items-center justify-center min-h-screen">
    <div
      class="max-w-md m-10 p-6 backdrop-blur-2xl border rounded-lg shadow-2xl"
    >
      <div v-if="!isCreating" class="mb-6">
        <h2 class="text-3xl font-bold mb-6 text-center text-white">
          Log in 🔐
        </h2>
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

      <div v-if="isCreating" class="">
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
          class="w-full p-3 mb-1 border rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
        />
        <button
          type="button"
          @click="cancelCreating"
          class="mb-4 text-purple-500 hover:text-purple-700 transition duration-300 underline items-center ml-2 text-sm"
        >
          Already have an account?
        </button>
        <button
          @click="register"
          :disabled="
            !newEmail || !newUsername || !newPassword || !confirmPassword
          "
          class="w-full bg-gradient-to-r from-[#7B61FF] via-[#4BC0C0] to-[#36A2EB] text-white p-3 rounded-lg hover:from-[#6A52E0] hover:via-[#3AA0A0] hover:to-[#2A82C9] transition duration-300 disabled:bg-[#A3D1F7] disabled:cursor-not-allowed mb-4"
        >
          Create an account
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import { useRouter } from "vue-router";
import { useUserStore } from "@/stores/use-user-store";
import { createUser, login } from "@/functions/User";
import { passwordStrength } from "check-password-strength";
import { toast } from "vue3-toastify";
import confetti from "canvas-confetti";
import axios from "axios";

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
  if (!email.value || !password.value) {
    toast.error("Please fill in all fields");
    return;
  }
  try {
    error.value = "";
    const response = await login(email.value, password.value);
    userStore.setUser(response.user);
    if (response.user.role_id >= 2) {
      router.push(`/admin/dashboard/${response.user.id}`);
    } else {
      router.push(`/dashboard/${response.user.id}`);
    }
  } catch (err) {
    if (axios.isAxiosError(err) && err.response) {
      if (err.response.status === 401) {
        error.value = "Invalid login credentials";
      } else {
        error.value = err.response.data.message || "Error logging in";
      }
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

  if (newPassword.value) {
    const strength = passwordStrength(newPassword.value);
    if (strength.id < 3 && newPassword.value.length < 8) {
      const contains = strength.contains;
      if (!contains.includes("lowercase")) {
        toast.error("Password must contain at least one lowercase letter.");
        return;
      }
      if (!contains.includes("uppercase")) {
        toast.error("Password must contain at least one uppercase letter.");
        return;
      }
      if (!contains.includes("number")) {
        toast.error("Password must contain at least one number.");
        return;
      }
      if (!contains.includes("symbol")) {
        toast.error("Password must contain at least one special character.");
        return;
      }
    }
  }

  try {
    await createUser({
      email: newEmail.value,
      username: newUsername.value,
      password: newPassword.value,
    });
    setTimeout(() => {
      confetti({
        particleCount: 200,
        spread: 160,
        origin: { x: 0.5, y: 0.5 },
        zIndex: 9999,
      });
    }, 100);
    cancelCreating();
    toast.success("Account created successfully");
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

const handleKeyDown = (event) => {
  if (event.key === "Enter") {
    if (!isCreating.value) {
      Handlelogin();
    } else {
      register();
    }
  }
};

onMounted(async () => {
  document.addEventListener("keydown", handleKeyDown);
  try {
    const user = GetUserByToken();
    console.log("User:", user);
    if (user) {
      console.log("User is logged in");
      userStore.setUser(user);
      router.push(`/dashboard/${user.id}`);
    }
  } catch (error) {
    console.log("User not logged in");
  }
});

onUnmounted(() => {
  document.removeEventListener("keydown", handleKeyDown);
});
</script>
