<template>
  <div class="text-white p-6">
    <div v-if="!isAdmin">
      <div class="flex flex-col lg:flex-row justify-between items-center mb-4">
        <div class="mb-4 lg:mb-0">
          <h2 class="text-xl font-bold">
            Role:
            <span v-if="isAdmin" class="text-green-500">Manager</span>
            <span v-else class="text-purple-500">General Manager</span>
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
    </div>

    <div v-if="isAdmin">
      <h2 class="text-xl font-bold mb-4">All Teams</h2>
      <div
        class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl overflow-x-auto"
      >
        <table class="min-w-full divide-y divide-gray-700">
          <thead>
            <tr>
              <th
                class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
              >
                Team Id
              </th>
              <th
                class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
              >
                Team Name
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-700">
            <tr
              v-for="team in allTeams"
              :key="team.id"
              class="hover:bg-slate-400 cursor-pointer rounded-lg over"
              @click="selectTeam(team.id)"
            >
              <td class="px-6 py-4 text-sm text-gray-300 text-center">
                {{ team.id }}
              </td>
              <td class="px-6 py-4 text-sm text-gray-300 text-center">
                {{ team.name }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="selectedTeam" class="mt-8">
        <h2 class="text-xl font-bold mb-4">Team : {{ teamName }}</h2>
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
                  Actions
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
                <td
                  class="px-6 py-4 text-sm text-gray-300 text-center space-x-2"
                >
                  <button
                    @click="viewUserInfo(user.id)"
                    class="text-white bg-purple-500 hover:bg-purple-600 focus:ring-4 focus:outline-none focus:ring-purple-300 font-medium rounded-lg text-sm px-2 py-1"
                  >
                    View
                  </button>
                  <button
                    @click="removeUserFromTeamAction(user.id)"
                    class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-2 py-1"
                  >
                    Remove
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="mt-4 space-x-2">
          <button
            @click="showEditTeamModal = true"
            class="text-white bg-blue-500 hover:bg-blue-600 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2"
          >
            Edit
          </button>
          <button
            @click="showAddUserModal = true"
            class="text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2"
          >
            Add a User
          </button>
        </div>
      </div>
    </div>

    <div
      v-if="showEditTeamModal"
      class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50"
    >
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <h2 class="text-xl font-bold mb-4">Modify Team Information</h2>
        <form @submit.prevent="updateTeamInfo">
          <div class="mb-4">
            <label
              for="teamName"
              class="block text-sm font-medium text-gray-300"
              >Name of the Team</label
            >
            <input
              v-model="teamName"
              id="teamName"
              type="text"
              class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
              required
            />
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

    <div
      v-if="showAddUserModal"
      class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50"
    >
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <h2 class="text-xl font-bold mb-4">Add a User to the Team</h2>
        <form @submit.prevent="addUserToTeamAction">
          <div class="mb-4">
            <label for="addUser" class="block text-sm font-medium text-gray-300"
              >Select a User</label
            >
            <select
              v-model="selectedUserToAdd"
              id="addUser"
              class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
              required
            >
              <option value="" disabled selected>Chose a User</option>
              <option
                v-for="user in availableUsers"
                :key="user.id"
                :value="user.id"
              >
                {{ user.username }}
              </option>
            </select>
          </div>
          <div class="flex justify-end space-x-4">
            <button
              type="button"
              @click="showAddUserModal = false"
              class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Add
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
  addUserToTeam as addUserToTeamAPI,
  removeUserFromTeam as removeUserFromTeamAPI,
  GetUserByToken,
} from "@/functions/User";
import { getOneTeam, updateTeam, getAllTeams } from "@/functions/Team";
import router from "@/router";
import { ref, onMounted, computed } from "vue";

export default {
  name: "AdminDashboard",
  setup() {
    const usersTeam = ref([]);
    const availableUsers = ref([]);
    const teamName = ref("");
    const showEditTeamModal = ref(false);
    const showAddUserModal = ref(false);
    const selectedUserToAdd = ref(null);
    const isAdmin = ref(false);
    const allTeams = ref([]);
    const selectedTeam = ref(null);
    const userRole = ref(null);

    onMounted(async () => {
      try {
        const user = await GetUserByToken();
        userRole.value = user.role_id;
        isAdmin.value = user.role_id == 3;
        if (user.role_id < 2) {
          router.push({ path: `/dashboard/${user.id}` });
        }
        const teamsResponse = await getAllTeams();
        allTeams.value = teamsResponse;
      } catch (error) {
        console.error(error);
        router.push({ path: `/` });
      }
    });

    const selectTeam = async (teamId) => {
      try {
        const teamResponse = await getOneTeam(teamId);
        teamName.value = teamResponse.name;

        const response = await getUserByTeam(teamId);
        usersTeam.value = response;

        const allUsersResponse = await getAllUsers();
        if (Array.isArray(allUsersResponse)) {
          availableUsers.value = allUsersResponse.filter(
            (u) => !response.find((r) => r.id === u.id)
          );
        }

        selectedTeam.value = teamId;
      } catch (error) {
        console.error(error);
      }
    };

    const filteredUsers = computed(() => usersTeam.value);

    const updateTeamInfo = async () => {
      try {
        await updateTeam(selectedTeam.value, { name: teamName.value });
        showEditTeamModal.value = false;
        const teamResponse = await getOneTeam(selectedTeam.value);
        teamName.value = teamResponse.name;
      } catch (error) {
        console.error(error);
      }
    };

    const addUserToTeamAction = async () => {
      try {
        await addUserToTeamAPI(selectedTeam.value, selectedUserToAdd.value);
        const response = await getUserByTeam(selectedTeam.value);
        usersTeam.value = response;

        const allUsersResponse = await getAllUsers();
        if (Array.isArray(allUsersResponse)) {
          availableUsers.value = allUsersResponse.filter(
            (u) => !response.find((r) => r.id === u.id)
          );
        }

        showAddUserModal.value = false;
        selectedUserToAdd.value = null;
      } catch (error) {
        console.error(error);
      }
    };

    const removeUserFromTeamAction = async (userId) => {
      try {
        await removeUserFromTeamAPI(userId);
        const response = await getUserByTeam(selectedTeam.value);
        usersTeam.value = response;

        const allUsersResponse = await getAllUsers();
        if (Array.isArray(allUsersResponse)) {
          availableUsers.value = allUsersResponse.filter(
            (u) => !response.find((r) => r.id === u.id)
          );
        }
      } catch (error) {
        console.error(error);
      }
    };

    const viewUserInfo = (id) => {
      router.push({ path: `/dashboard/${id}` });
    };

    return {
      usersTeam,
      availableUsers,
      teamName,
      showEditTeamModal,
      showAddUserModal,
      selectedUserToAdd,
      filteredUsers,
      updateTeamInfo,
      addUserToTeamAction,
      removeUserFromTeamAction,
      viewUserInfo,
      isAdmin,
      allTeams,
      selectedTeam,
      selectTeam,
      userRole,
    };
  },
};
</script>
