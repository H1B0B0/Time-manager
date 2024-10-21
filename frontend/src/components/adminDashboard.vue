<template>
  <div class="text-white p-6">
    <div class="flex flex-col lg:flex-row justify-between items-center mb-4">
      <div class="mb-4 lg:mb-0">
        <h2 class="text-xl font-bold">
          Manager:
          <span v-if="manager" class="text-green-500">You</span
          ><span v-else class="text-red-500">No Manager</span>
        </h2>
      </div>
      <h1 class="text-2xl font-bold">{{ teamName }}</h1>
    </div>
    <div
      class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl overflow-x-auto"
    >
      <table class="min-w-full divide-y divide-gray-700">
        <thead>
          <tr>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Id
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Username
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Email
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Role
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Info
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-700">
          <tr
            v-for="user in filteredUsers"
            :key="user.id"
            class="hover:bg-gray-600"
          >
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              {{ user.id }}
            </td>
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              {{ user.username }}
            </td>
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              {{ user.email }}
            </td>
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              {{ user.role_id === 2 ? "Manager" : "Employee" }}
            </td>
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              <button
                @click="viewUserInfo(user.id)"
                class="text-white bg-purple-500 hover:bg-purple-600 focus:ring-4 focus:outline-none focus:ring-purple-300 font-medium rounded-lg text-sm px-4 py-2"
              >
                View
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal for editing team info -->
    <div
      v-if="showEditTeamModal"
      class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50"
    >
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <h2 class="text-xl font-bold mb-4">Edit Team Info</h2>
        <form @submit.prevent="updateTeamInfo">
          <div class="mb-4">
            <label
              for="teamName"
              class="block text-sm font-medium text-gray-300"
              >Team Name</label
            >
            <input
              v-model="teamName"
              id="teamName"
              type="text"
              class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
              required
            />
          </div>
          <div class="mb-4">
            <label for="addUser" class="block text-sm font-medium text-gray-300"
              >Add User</label
            >
            <select
              v-model="selectedUserToAdd"
              id="addUser"
              class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
            >
              <option
                v-for="user in availableUsers"
                :key="user.id"
                :value="user.id"
              >
                {{ user.username }}
              </option>
            </select>
            <button
              type="button"
              @click="addUserToTeam"
              class="mt-2 text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Add User
            </button>
          </div>
          <div class="mb-4">
            <label
              for="removeUser"
              class="block text-sm font-medium text-gray-300"
              >Remove User</label
            >
            <select
              v-model="selectedUserToRemove"
              id="removeUser"
              class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
            >
              <option v-for="user in usersTeam" :key="user.id" :value="user.id">
                {{ user.username }}
              </option>
            </select>
            <button
              type="button"
              @click="removeUserFromTeam"
              class="mt-2 text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Remove User
            </button>
          </div>
          <div class="flex justify-end space-x-4">
            <button
              type="button"
              @click="showEditTeamModal = false"
              class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="text-white bg-blue-500 hover:bg-blue-600 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Save
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import {
  getAllUsers,
  getUserByTeam,
  addUserToTeam,
  removeUserFromTeam,
  GetUserByToken,
} from "@/functions/User";
import { getOneTeam, updateTeam } from "@/functions/Team";
import router from "@/router";
import { ref, onMounted, computed } from "vue";
import { useUserStore } from "@/stores/use-user-store";

export default {
  name: "AdminDashboard",
  setup() {
    const usersTeam = ref([]);
    const availableUsers = ref([]);
    const teamName = ref("");
    const showEditTeamModal = ref(false);
    const selectedUserToAdd = ref(null);
    const selectedUserToRemove = ref(null);
    const manager = ref(null);
    const userStore = useUserStore();

    onMounted(async () => {
      try {
        const user = await GetUserByToken();
        if (user.role_id < 2) {
          router.push({ path: `/dashboard/${user.id}` });
        }
        try {
          const teamResponse = await getOneTeam(user.team_id);
          teamName.value = teamResponse.name;

          const response = await getUserByTeam(user.team_id);
          usersTeam.value = response;

          // Find the manager
          manager.value = response.find((u) => u.role_id === 2);

          const allUsers = await getAllUsers();
          availableUsers.value = allUsers.filter(
            (u) => !response.find((r) => r.id === u.id)
          );
        } catch (error) {
          console.error(error);
        }
      } catch (error) {
        console.error(error);
        router.push({ path: `/` });
      }
    });

    const filteredUsers = computed(() => {
      return usersTeam.value.filter((user) => user.role_id !== 2);
    });

    const updateTeamInfo = async () => {
      try {
        const user = userStore.user;
        await updateTeam(user.team_id, { name: teamName.value });
        showEditTeamModal.value = false;

        const teamResponse = await getOneTeam(user.team_id);
        teamName.value = teamResponse.name;
      } catch (error) {
        console.error(error);
      }
    };

    const addUserToTeam = async () => {
      try {
        const user = userStore.user;
        await addUserToTeam(user.team_id, selectedUserToAdd.value);
        const response = await getUserByTeam(user.team_id);
        usersTeam.value = response;
        availableUsers.value = availableUsers.value.filter(
          (u) => u.id !== selectedUserToAdd.value
        );
        selectedUserToAdd.value = null;
      } catch (error) {
        console.error(error);
      }
    };

    const removeUserFromTeam = async () => {
      try {
        const user = userStore.user;

        await removeUserFromTeam(selectedUserToRemove.value);

        const response = await getUserByTeam(user.team_id);
        usersTeam.value = response;
        availableUsers.value.push(
          availableUsers.value.find((u) => u.id === selectedUserToRemove.value)
        );
        selectedUserToRemove.value = null;
      } catch (error) {
        console.error(error);
      }
    };

    const viewUserInfo = (id) => {
      router.push({ path: `/dashboard/${id}` });
    };

    const modifyUserSchedule = (id) => {
      router.push({ path: `/workingTimeManager/${id}` });
    };

    const createUserSchedule = (id) => {
      router.push({ path: `/workingTime/${id}` });
    };

    return {
      usersTeam,
      availableUsers,
      teamName,
      showEditTeamModal,
      selectedUserToAdd,
      selectedUserToRemove,
      manager,
      filteredUsers,
      updateTeamInfo,
      addUserToTeam,
      removeUserFromTeam,
      viewUserInfo,
      modifyUserSchedule,
      createUserSchedule,
    };
  },
};
</script>
