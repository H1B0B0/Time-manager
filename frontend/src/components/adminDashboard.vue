<template>
  <div class="text-white p-6">
    <div class="flex justify-between items-center mb-4">
      <h1 class="text-2xl font-bold">{{ teamName }}</h1>
      <button
        @click="showEditTeamModal = true"
        class="flex items-center text-white bg-blue-500 hover:bg-blue-600 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2"
      >
        <svg
          class="w-6 h-6"
          viewBox="0 0 24 24"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M11 4H7.2C6.0799 4 5.51984 4 5.09202 4.21799C4.71569 4.40974 4.40973 4.7157 4.21799 5.09202C4 5.51985 4 6.0799 4 7.2V16.8C4 17.9201 4 18.4802 4.21799 18.908C4.40973 19.2843 4.71569 19.5903 5.09202 19.782C5.51984 20 6.0799 20 7.2 20H16.8C17.9201 20 18.4802 20 18.908 19.782C19.2843 19.5903 19.5903 19.2843 19.782 18.908C20 18.4802 20 17.9201 20 16.8V12.5M15.5 5.5L18.3284 8.32843M10.7627 10.2373L17.411 3.58902C18.192 2.80797 19.4584 2.80797 20.2394 3.58902C21.0205 4.37007 21.0205 5.6364 20.2394 6.41745L13.3774 13.2794C12.6158 14.0411 12.235 14.4219 11.8012 14.7247C11.4162 14.9936 11.0009 15.2162 10.564 15.3882C10.0717 15.582 9.54378 15.6885 8.48793 15.9016L8 16L8.04745 15.6678C8.21536 14.4925 8.29932 13.9048 8.49029 13.3561C8.65975 12.8692 8.89125 12.4063 9.17906 11.9786C9.50341 11.4966 9.92319 11.0768 10.7627 10.2373Z"
            stroke="white"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
        </svg>
      </button>
    </div>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl">
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
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Create Schedule
            </th>
            <th
              class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
            >
              Modify Schedule
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-700">
          <tr
            v-for="user in usersTeam"
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
              {{ user.role }}
            </td>
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              <button
                @click="viewUserInfo(user.id, user.role_id)"
                class="text-white bg-purple-500 hover:bg-purple-600 focus:ring-4 focus:outline-none focus:ring-purple-300 font-medium rounded-lg text-sm px-4 py-2"
              >
                View
              </button>
            </td>
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              <button
                @click="createUserSchedule(user.id)"
                class="text-white bg-purple-500 hover:bg-purple-600 focus:ring-4 focus:outline-none focus:ring-purple-300 font-medium rounded-lg text-sm px-4 py-2"
              >
                Create
              </button>
            </td>
            <td class="px-6 py-4 text-sm text-gray-300 text-center">
              <button
                @click="modifyUserSchedule(user.id)"
                class="text-white bg-purple-500 hover:bg-purple-600 focus:ring-4 focus:outline-none focus:ring-purple-300 font-medium rounded-lg text-sm px-4 py-2"
              >
                Modify
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
import { ref, onMounted } from "vue";
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

    const viewUserInfo = (id, roleId) => {
      const loggedInUserId = userStore.user.id;
      if (roleId < 2) {
        router.push({ path: `/dashboard/${loggedInUserId}` });
      } else {
        router.push({ path: `/dashboard/${id}` });
      }
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
