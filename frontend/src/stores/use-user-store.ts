import { defineStore } from "pinia";
import type { UserType } from "@/types/UserType";
import { GetUserByToken } from "@/functions/User";
import Cookies from "js-cookie";

export const useUserStore = defineStore("storeUser", {
  state() {
    return {
      user: {} as UserType,
    };
  },
  actions: {
    setUser(user: UserType) {
      this.user = user;
    },
    async fetchUser() {
      const token = Cookies.get("token");
      if (token) {
        try {
          const response = await GetUserByToken();
          this.setUser(response);
        } catch (error) {
          console.error("Failed to fetch user:", error);
        }
      }
    },
    logout() {
      this.user = {} as UserType;
      if (Cookies.get("token")) {
        Cookies.remove("token");
      }
    },
  },
  getters: {
    getUser(): UserType {
      return this.user;
    },
  },
});
