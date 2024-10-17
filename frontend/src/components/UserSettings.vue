<template>
  <div class="mx-auto mt-10 p-6 bg-gray-900 rounded-lg shadow-xl">
    <form @submit.prevent="updateAccount" class="space-y-4">
      <input
        v-model="username"
        placeholder="New username"
        class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
        required
      />
      <input
        v-model="email"
        placeholder="New email"
        class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
        required
        type="email"
      />
      <input
        v-model="oldPassword"
        placeholder="Old password"
        class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
        type="password"
      />
      <input
        v-model="newPassword"
        placeholder="New password"
        class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
        type="password"
      />
      <div class="flex justify-between">
        <button
          type="submit"
          class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600 w-full"
        >
          Update account
        </button>
      </div>
    </form>
  </div>
  <button
    @click="confirmDeleteAccount"
    type="button"
    class="bg-red-500 text-white p-2 rounded hover:bg-red-600 w-full mt-4"
  >
    Delete account
  </button>
</template>

<script setup>
import { ref } from "vue";
import { useUserStore } from "@/stores/use-user-store";
import { updateUser, deleteUser } from "@/functions/User";
import { toast } from "vue3-toastify";
import { passwordStrength } from 'check-password-strength'

const userStore = useUserStore();
const email = ref(userStore.user?.email ?? "");
const username = ref(userStore.user?.username ?? "");
const oldPassword = ref("");
const newPassword = ref("");

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
      if (passwordStrength(newPassword.value).id < 2) {
        const contains = passwordStrength(newPassword.value).contains;
        if (!contains.includes('lowercase')) {
          toast.error("Password must contain at least one lowercase letter.");
          return;
        }
        if (!contains.includes('uppercase')) {
          toast.error("Password must contain at least one uppercase letter.");
          return;
        }
        if (!contains.includes('number')) {
          toast.error("Password must contain at least one number.");
          return;
        }
      }
      updatedData.old_password = oldPassword.value;
      updatedData.password = newPassword.value;
    }

    const response = await updateUser(userStore.user.id, updatedData);

    if (response && response.id) {
      userStore.setUser(response);
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
    userStore.setUser(null);
    toast.success("Successfully deleted account");
  } catch (error) {
    toast.error(`Error deleting account: ${error.message}`);
  }
};
</script>
