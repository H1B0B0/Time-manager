<template>
  <div class="text-white p-6">
    <div v-if="!isAdmin">
      <div class="flex flex-col lg:flex-row justify-between items-center mb-4">
        <div class="mb-4 lg:mb-0">
          <h2 class="text-xl font-bold">
            Role:
            <span v-if="!isAdmin" class="text-green-500">Manager</span>
            <span v-else class="text-purple-500">General Manager</span>
          </h2>
        </div>
        <h1 class="text-2xl font-bold">{{ teamName }}</h1>
      </div>
      <div class="mb-4" v-if="managerTeams.length > 0">
        <h2 class="text-xl font-bold mb-4">My Teams</h2>
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
                <th
                  class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
                >
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-700">
              <tr
                v-for="team in managerTeams"
                :key="team.id"
                @click="selectTeam(team.id)"
                class="transform transition-transform duration-300 hover:scale-105 cursor-pointer"
              >
                <td class="px-6 py-4 text-sm text-gray-300 text-center">
                  {{ team.id }}
                </td>
                <td class="px-6 py-4 text-sm text-gray-300 text-center">
                  {{ team.name }}
                </td>
                <td
                  class="px-6 py-4 text-sm text-gray-300 text-center space-x-2"
                >
                  <button
                    @click.stop="showEditTeamModal = true"
                    class="text-white bg-blue-500 hover:bg-blue-600 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2"
                  >
                    Edit
                  </button>
                  <button
                    @click.stop="deleteTeam(team.id)"
                    class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
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
              class="transform transition-transform duration-300 hover:scale-105 cursor-pointer"
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
      <div class="flex justify-between mb-4">
        <button
          @click="showCreateTeamModal = true"
          class="text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2"
        >
          Create Team
        </button>
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
                Team Id
              </th>
              <th
                class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
              >
                Team Name
              </th>
              <th
                class="px-6 py-3 text-center text-xs font-medium text-gray-300 uppercase tracking-wider"
              >
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-700">
            <template v-for="team in allTeams" :key="team.id">
              <tr
                @click="selectTeam(team.id)"
                class="hover:bg-slate-400 cursor-pointer rounded-lg over"
              >
                <td class="px-6 py-4 text-sm text-gray-300 text-center">
                  {{ team.id }}
                </td>
                <td class="px-6 py-4 text-sm text-gray-300 text-center">
                  {{ team.name }}
                </td>
                <td
                  class="px-6 py-4 text-sm text-gray-300 text-center space-x-2"
                >
                  <button
                    @click.stop="showEditTeamModal = true"
                    class="text-white bg-blue-500 hover:bg-blue-600 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2"
                  >
                    Edit
                  </button>
                  <button
                    @click.stop="deleteTeam(team.id)"
                    class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
                  >
                    Delete
                  </button>
                </td>
              </tr>
              <tr v-if="selectedTeam === team.id">
                <td colspan="3">
                  <div class="">
                    <div class="flex justify-end">
                      <button
                        @click="showAddUserModal = true"
                        class="text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2 m-4 w-full"
                      >
                        Add User
                      </button>
                    </div>
                    <div class="markdown-content h-64 overflow-y-auto">
                      <div
                        v-for="user in usersTeam"
                        :key="user.id"
                        class="mb-4 p-4 border rounded-lg shadow-lg bg-gray-800 flex-col"
                      >
                        <img
                          :src="`https://api.dicebear.com/9.x/lorelei/svg?seed=${user.username}`"
                          class="rounded-full h-8 w-8 mr-4"
                        />
                        <h3 class="text-lg font-semibold text-purple-400">
                          {{ user.username }}
                        </h3>
                        <p class="text-sm text-gray-300">
                          Email: {{ user.email }}
                        </p>
                        <p class="text-sm text-gray-300">
                          Role:
                          {{
                            user.role_id === 3
                              ? "General Manager"
                              : user.role_id === 2
                              ? "Manager"
                              : "Employee"
                          }}
                        </p>
                        <div class="flex justify-end space-x-2 ml-auto">
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
                        </div>
                      </div>
                    </div>
                  </div>
                </td>
              </tr>
            </template>
          </tbody>
        </table>
      </div>
      <div class="text-white p-6">
        <h2 class="text-xl font-bold mb-4">User Management</h2>
        <div class="flex justify-between mb-4">
          <button
            @click="showCreateUserModal = true"
            class="text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2"
          >
            Create User
          </button>
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
                  User Id
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
                v-for="user in users"
                :key="user.id"
                class="hover:bg-slate-400 cursor-pointer rounded-lg"
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
                  {{
                    user.role_id === 3
                      ? "General Manager"
                      : user.role_id === 2
                      ? "Manager"
                      : "Employee"
                  }}
                </td>
                <td
                  class="px-6 py-4 text-sm text-gray-300 text-center space-x-2"
                >
                  <button
                    @click="editUser(user.id)"
                    class="text-white bg-blue-500 hover:bg-blue-600 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2"
                  >
                    Edit
                  </button>
                  <button
                    @click="deleteUser(user.id)"
                    class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Create User Modal -->
        <div
          v-if="showCreateUserModal"
          class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50"
        >
          <div class="p-6 rounded-lg shadow-lg backdrop-blur-2xl border w-6/12">
            <h2 class="text-xl font-bold mb-4">Create a New User</h2>
            <form @submit.prevent="createUser">
              <div class="mb-4">
                <label
                  for="newUsername"
                  class="block text-sm font-medium text-gray-300"
                  >Username</label
                >
                <input
                  v-model="newUsername"
                  id="newUsername"
                  type="text"
                  class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
                  required
                />
              </div>
              <div class="mb-4">
                <label
                  for="newEmail"
                  class="block text-sm font-medium text-gray-300"
                  >Email</label
                >
                <input
                  v-model="newEmail"
                  id="newEmail"
                  type="email"
                  class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
                  required
                />
              </div>
              <div class="mb-4">
                <label
                  for="newPassword"
                  class="block text-sm font-medium text-gray-300"
                  >Password</label
                >
                <input
                  v-model="newPassword"
                  id="newPassword"
                  type="password"
                  class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
                  required
                />
              </div>
              <div class="mb-4">
                <label
                  for="confirmPassword"
                  class="block text-sm font-medium text-gray-300"
                  >Confirm Password</label
                >
                <input
                  v-model="confirmPassword"
                  id="confirmPassword"
                  type="password"
                  class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
                  required
                />
              </div>
              <div class="mb-4">
                <label
                  for="newRole"
                  class="block text-sm font-medium text-gray-300"
                  >Role</label
                >
                <select
                  v-model="newRole"
                  id="newRole"
                  class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
                  required
                >
                  <option value="" disabled selected>Choose a Role</option>
                  <option value="2">Manager</option>
                  <option value="1">Employee</option>
                </select>
              </div>

              <div class="flex flex-col w-full space-y-4">
                <button
                  type="button"
                  @click="showCreateUserModal = false"
                  class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  class="text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2"
                >
                  Create
                </button>
              </div>
            </form>
          </div>
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
              <option value="" disabled selected>Choose a User</option>
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

    <div
      v-if="showCreateTeamModal"
      class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50"
    >
      <div class="bg-gray-800 p-6 rounded-lg shadow-lg">
        <h2 class="text-xl font-bold mb-4">Create a New Team</h2>
        <form @submit.prevent="createTeam">
          <div class="mb-4">
            <label
              for="newTeamName"
              class="block text-sm font-medium text-gray-300"
              >Team Name</label
            >
            <input
              v-model="newTeamName"
              id="newTeamName"
              type="text"
              class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
              required
            />
          </div>
          <div class="mb-4">
            <label
              for="teamOwner"
              class="block text-sm font-medium text-gray-300"
              >Select Team Owner</label
            >
            <select
              v-model="selectedTeamOwner"
              id="teamOwner"
              class="w-full p-2 border rounded text-white bg-gray-600 border-gray-400"
              required
            >
              <option value="" disabled selected>Choose an Owner</option>
              <option
                v-for="user in availableOwners"
                :key="user.id"
                :value="user.id"
              >
                {{ user.username }} ({{
                  user.role_id === 3 ? "General Manager" : "Manager"
                }})
              </option>
            </select>
          </div>
          <div class="flex justify-end space-x-4">
            <button
              type="button"
              @click="showCreateTeamModal = false"
              class="text-white bg-red-500 hover:bg-red-600 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="text-white bg-green-500 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2"
            >
              Create
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
  createUser as createUserAPI,
  deleteUserByAdmin,
  UpdateRole,
} from "@/functions/User";
import {
  getOneTeam,
  updateTeam,
  getAllTeams,
  createTeam as createTeamAPI,
  deleteTeam as deleteTeamAPI,
  getTeamByUser,
} from "@/functions/Team";
import router from "@/router";
import { ref, onMounted, computed } from "vue";
import { toast } from "vue3-toastify";
import confetti from "canvas-confetti";

export default {
  name: "AdminDashboard",
  setup() {
    const usersTeam = ref([]);
    const availableUsers = ref([]);
    const availableOwners = ref([]);
    const teamName = ref("");
    const managerTeams = ref([]);
    const showEditTeamModal = ref(false);
    const showAddUserModal = ref(false);
    const showCreateTeamModal = ref(false);
    const selectedUserToAdd = ref(null);
    const selectedTeamOwner = ref(null);
    const newTeamName = ref("");
    const isAdmin = ref(false);
    const allTeams = ref([]);
    const selectedTeam = ref(null);
    const userRole = ref(null);
    const users = ref([]);
    const showCreateUserModal = ref(false);
    const newUsername = ref("");
    const newEmail = ref("");
    const newRole = ref("");
    const newPassword = ref("");
    const confirmPassword = ref("");

    onMounted(async () => {
      try {
        const user = await GetUserByToken();
        userRole.value = user.role_id;
        isAdmin.value = user.role_id == 3;
        if (user.role_id < 2) {
          router.push({ path: `/dashboard/${user.id}` });
        }
        if (isAdmin.value) {
          const teamsResponse = await getAllTeams();
          allTeams.value = teamsResponse;

          const allUsersResponse = await getAllUsers();
          if (Array.isArray(allUsersResponse.data)) {
            users.value = allUsersResponse.data.filter((u) => u.role_id !== 3);
            console.log(users.value);
            availableUsers.value = allUsersResponse.data;
            availableOwners.value = allUsersResponse.data.filter(
              (u) => u.role_id === 2 || u.role_id === 3
            );
          }
        } else {
          console.log("user", user);
          const teamResponse = await getTeamByUser(user.id);
          if (Array.isArray(teamResponse)) {
            managerTeams.value = teamResponse.filter(
              (team) => team.owner_id === user.id
            );
            if (managerTeams.value.length > 0) {
              const team = managerTeams.value[0];
              teamName.value = team.name;
              console.log("teamResponse", teamResponse);

              const response = await getUserByTeam(team.id);
              console.log("response", response);
              usersTeam.value = response;
            }
          } else {
            teamName.value = teamResponse.name;
            console.log("teamResponse", teamResponse);

            const response = await getUserByTeam(teamResponse.id);
            console.log("response", response);
            usersTeam.value = response;
          }
        }
      } catch (error) {
        console.error(error);
        router.push({ path: `/` });
      }
    });

    const createUser = async () => {
      try {
        if (newPassword.value !== confirmPassword.value) {
          toast.error("Passwords do not match");
          return;
        }
        const newUser = await createUserAPI({
          username: newUsername.value,
          email: newEmail.value,
          password: newPassword.value,
        });

        const response = await UpdateRole(newUser, newUser.id, newRole.value);
        if (response) {
          const userWithRole = {
            ...newUser,
            role_id: parseInt(newRole.value, 10),
          };
          console.log(userWithRole);
          users.value.push(userWithRole);
          showCreateUserModal.value = false;
          newUsername.value = "";
          newEmail.value = "";
          newRole.value = "";
          newPassword.value = "";
          confirmPassword.value = "";
          confetti();
        } else {
          toast.error("Error creating user");
        }
      } catch (error) {
        toast.error("Error creating user");
        console.error(error);
      }
    };

    const UpdateUserRole = async (userId, role) => {
      try {
        const response = await UpdateRole(userId, role);
        return response;
      } catch (error) {
        console.error(error);
      }
    };

    const editUser = (userId) => {
      router.push({ path: `/settings/${userId}` });
    };

    const deleteUser = async (userId) => {
      try {
        await deleteUserByAdmin(userId);
        users.value = users.value.filter((u) => u.id !== userId);
      } catch (error) {
        console.error(error);
      }
    };

    const selectTeam = async (teamId) => {
      try {
        const teamResponse = await getOneTeam(teamId);
        teamName.value = teamResponse.name;

        const response = await getUserByTeam(teamId);
        usersTeam.value = response;

        const allUsersResponse = await getAllUsers();
        if (Array.isArray(allUsersResponse.data)) {
          availableUsers.value = allUsersResponse.data.filter(
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

        const teamsResponse = await getAllTeams();
        allTeams.value = teamsResponse;
      } catch (error) {
        console.error(error);
      }
    };

    const addUserToTeamAction = async () => {
      try {
        await addUserToTeamAPI(selectedUserToAdd.value, selectedTeam.value);
        const response = await getUserByTeam(selectedTeam.value);
        usersTeam.value = response;

        const allUsersResponse = await getAllUsers();
        if (Array.isArray(allUsersResponse.data)) {
          availableUsers.value = allUsersResponse.data.filter(
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
        await removeUserFromTeamAPI(userId, selectedTeam.value);

        const response = await getUserByTeam(selectedTeam.value);
        usersTeam.value = response;

        const allUsersResponse = await getAllUsers();
        if (Array.isArray(allUsersResponse.data)) {
          availableUsers.value = allUsersResponse.data.filter(
            (u) => !response.find((r) => r.id === u.id)
          );
        }
      } catch (error) {
        console.error(error);
      }
    };

    const createTeam = async () => {
      try {
        const newTeam = await createTeamAPI({
          name: newTeamName.value,
          owner_id: selectedTeamOwner.value,
        });

        await addUserToTeamAPI(selectedTeamOwner.value, newTeam.id);

        const teamsResponse = await getAllTeams();
        allTeams.value = teamsResponse;
        showCreateTeamModal.value = false;
        newTeamName.value = "";
        selectedTeamOwner.value = null;
      } catch (error) {
        console.error(error);
      }
    };

    const deleteTeam = async (teamId) => {
      try {
        await deleteTeamAPI(teamId);
        const teamsResponse = await getAllTeams();
        allTeams.value = teamsResponse;
        if (selectedTeam === teamId) {
          selectedTeam.value = null;
          teamName.value = "";
          usersTeam.value = [];
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
      availableOwners,
      teamName,
      showEditTeamModal,
      showAddUserModal,
      showCreateTeamModal,
      selectedUserToAdd,
      selectedTeamOwner,
      newTeamName,
      filteredUsers,
      updateTeamInfo,
      addUserToTeamAction,
      removeUserFromTeamAction,
      createTeam,
      deleteTeam,
      viewUserInfo,
      isAdmin,
      allTeams,
      selectedTeam,
      selectTeam,
      userRole,
      createUser,
      editUser,
      deleteUser,
      users,
      users,
      showCreateUserModal,
      newUsername,
      newEmail,
      newRole,
      managerTeams,
      newPassword,
      confirmPassword,
    };
  },
};
</script>

<style>
.markdown-content h3 {
  color: #8b5cf6; /* Tailwind violet-500 */
  margin-top: 1rem;
  margin-bottom: 0.5rem;
}

.markdown-content p {
  color: #d1d5db; /* Tailwind cool-gray-300 */
  margin-bottom: 1rem;
}

.markdown-content .flex {
  justify-content: flex-end;
  margin-top: 1rem;
}
</style>
