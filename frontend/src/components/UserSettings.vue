<template>
  <div class="items-center justify-center flex min-h-screen">
    <div
      class="max-w-md m-10 p-6 backdrop-blur-2xl border rounded-lg shadow-2xl items-center justify-center"
    >
      <h2 class="text-3xl font-bold mb-6 text-center text-white">
        Update Account 🔄
      </h2>
      <form @submit.prevent="updateAccount" class="space-y-4">
        <input
          v-model="username"
          placeholder="New username"
          class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
          required
        />
        <input
          v-model="email"
          placeholder="New email"
          class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
          required
          type="email"
        />
        <input
          v-model="oldPassword"
          placeholder="Old password"
          class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
          type="password"
        />
        <input
          v-model="newPassword"
          placeholder="New password"
          class="w-full p-3 mb-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
          type="password"
        />
        <div
          v-if="loggedInUserRole === 3 && loggedInUserId !== userIdFromRoute"
        >
          <label for="role" class="block text-sm font-medium text-gray-300"
            >Role</label
          >
          <select
            v-model="newRole"
            id="role"
            class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
          >
            <option value="" disabled selected>Choose a Role</option>
            <option value="2">Manager</option>
            <option value="1">Employee</option>
          </select>
        </div>
        <button
          type="submit"
          class="w-full bg-indigo-500 text-white p-3 rounded-lg hover:bg-indigo-600 transition duration-300"
        >
          Update account
        </button>
      </form>
      <button
        @click="confirmDeleteAccount"
        type="button"
        class="w-full bg-red-500 text-white p-3 rounded-lg hover:bg-red-600 transition duration-300 mt-4"
      >
        Delete account
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useUserStore } from "@/stores/use-user-store";
import {
  getUserById,
  updateUser,
  deleteUser,
  UpdateRole,
  GetUserByToken,
} from "@/functions/User";
import { toast } from "vue3-toastify";
import { passwordStrength } from "check-password-strength";

const userStore = useUserStore();
const route = useRoute();
const router = useRouter();
const email = ref("");
const username = ref("");
const oldPassword = ref("");
const newPassword = ref("");
const newRole = ref("");
const loggedInUserRole = ref(null);
const originalRole = ref(null);
const loggedInUserId = ref("");
const userIdFromRoute = Number(route.params.userID);
const Offline = ref(!navigator.onLine);

onMounted(async () => {
  if (!Offline.value) {
    toast.error("You are offline. Some features may not be available.");
  } else {
    try {
      const user = await GetUserByToken();
      if (user) {
        userStore.setUser(user.value);
        loggedInUserId.value = user.id;
        loggedInUserRole.value = user.role_id;
      } else {
        router.push("/login");
        return;
      }
    } catch (error) {
      console.log("User not logged in");
      router.push("/login");
      return;
    }
  }

  try {
    const user = await getUserById(userIdFromRoute);
    username.value = user.username;
    email.value = user.email;
    newRole.value = user.role_id;
    originalRole.value = user.role_id;
  } catch (error) {
    toast.error("Error fetching user data.");
    console.error(error);
  }
});

const updateAccount = async () => {
  if (!userStore.user?.id) {
    toast.error("User ID not found. Please log in again.");
    return;
  }

  try {
    const updatedData = {
      email: email.value,
      username: username.value,
    };

    if (oldPassword.value || newPassword.value) {
      if (!oldPassword.value || !newPassword.value) {
        toast.error(
          "Both old and new passwords are required for password update."
        );
        return;
      }
      if (
        passwordStrength(newPassword.value).id < 2 &&
        newPassword.value.length < 8
      ) {
        const contains = passwordStrength(newPassword.value).contains;
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
      }
      updatedData.old_password = oldPassword.value;
      updatedData.password = newPassword.value;
    }

    const userIdFromRoute = route.params.userID;

    if (loggedInUserRole.value === 3 && newRole.value !== originalRole.value) {
      await UpdateRole(
        {
          username: username.value,
          email: email.value,
          password: newPassword.value,
        },
        userIdFromRoute,
        newRole.value
      );
    }

    const response = await updateUser(userIdFromRoute, updatedData);

    if (response && response.id) {
      if (userIdFromRoute === userStore.user.id) {
        userStore.setUser(response);
      }
      toast.success("Account successfully updated");
      if (updatedData.newPassword) {
        toast.info("Password has been changed");
      }

      oldPassword.value = "";
      newPassword.value = "";
    } else {
      throw new Error("Invalid response from server");
    }
  } catch (error) {
    toast.error(`Error updating account: ${error.message}`);
    console.error("Error details:", error);
  }
};

const confirmDeleteAccount = () => {
  if (
    confirm(
      "Are you sure you want to delete your account? This action cannot be undone."
    )
  ) {
    deleteAccount();
  }
};

const deleteAccount = async () => {
  try {
    await deleteUser(userStore.user.id);
    toast.success("Successfully deleted account");
  } catch (error) {
    toast.error(`Error deleting account: ${error.message}`);
  }
};
</script>
