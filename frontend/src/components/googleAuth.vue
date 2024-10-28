<template>
  <div
    class="flex flex-col items-center bg-black text-white border border-white rounded py-3 mt-3 hover:bg-black"
  >
    <button
      @click="login"
      :disabled="loading"
      class="flex items-center gap-2 px-4"
    >
      <img
        class="w-6 h-6"
        src="https://www.svgrepo.com/show/475656/google-color.svg"
        loading="lazy"
        alt="Google logo"
      />
      <span>{{ loading ? "Login in..." : "Log in with Google" }}</span>
    </button>

    <div
      v-if="error"
      class="mt-3 p-3 bg-red-50 border border-red-200 rounded-lg"
    >
      <p class="text-sm text-red-600">{{ error }}</p>
      <pre v-if="debug" class="mt-2 text-xs text-gray-600">{{ debug }}</pre>
    </div>
  </div>
</template>

<script>
import { ref } from "vue";
const GOOGLE_CLIENT_ID =
  "832550689961-uk981s634d9r755nuoa8fg3gqpu9gcjb.apps.googleusercontent.com";

export default {
  name: "GoogleAuth",
  emits: ["login-success", "login-error"],

  setup(props, { emit }) {
    const loading = ref(false);
    const error = ref(null);
    const debug = ref(null);

    const login = () => {
      loading.value = true;
      error.value = null;
      debug.value = null;

      google.accounts.id.initialize({
        client_id: GOOGLE_CLIENT_ID,
        callback: handleCredentialResponse,
      });
      google.accounts.id.prompt(); // Show the prompt to the user
    };

    const handleCredentialResponse = async (response) => {
      if (response.credential) {
        emit("login-success", response.credential);
        loading.value = false;
      } else {
        error.value = "Failed to login with Google.";
        debug.value = response;
        emit("login-error", response);
        loading.value = false;
      }
    };

    return {
      login,
      loading,
      error,
      debug,
    };
  },
};
</script>
