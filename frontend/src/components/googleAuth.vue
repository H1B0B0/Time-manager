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
      <span>{{ loading ? "Signing in..." : "Sign in with Google" }}</span>
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
import { ref, onMounted } from "vue";
import axios from "axios";

const GOOGLE_CLIENT_ID =
  "832550689961-uk981s634d9r755nuoa8fg3gqpu9gcjb.apps.googleusercontent.com";
const BACKEND_URL = "https://backend.traefik.me";
const REDIRECT_URI = encodeURIComponent(
  "https://backend.traefik.me/api/auth/google"
);

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

      const googleAuthUrl =
        `https://accounts.google.com/o/oauth2/v2/auth?` +
        `client_id=${GOOGLE_CLIENT_ID}` +
        `&redirect_uri=${REDIRECT_URI}` +
        `&response_type=code` +
        `&scope=${encodeURIComponent("email profile openid")}` +
        `&access_type=offline` +
        `&prompt=consent`;

      // Redirection vers Google
      window.location.href = googleAuthUrl;
    };

    const handleOAuthCallback = async () => {
      const urlParams = new URLSearchParams(window.location.search);
      const code = urlParams.get("code");

      if (code) {
        try {
          const response = await axios.post(
            `${BACKEND_URL}/api/auth/google/callback`,
            { code }
          );
          emit("login-success", response.data);
        } catch (err) {
          error.value = "Failed to login with Google.";
          debug.value = err.response ? err.response.data : err.message;
          emit("login-error", err);
        } finally {
          loading.value = false;
        }
      }
    };

    onMounted(() => {
      handleOAuthCallback();
    });

    return {
      login,
      loading,
      error,
      debug,
    };
  },
};
</script>
