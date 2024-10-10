// store/use-user-store.ts
import { defineStore } from 'pinia'
import type { UserType } from '@/../types/UserType'
import { getUserById } from '@/../functions/User'

export const useUserStore = defineStore('storeUser', {
  state() {
    return {
      user: {} as UserType,
    }
  },
  actions: {
    setUser(user: UserType) {
      this.user = user;
    },
    refreshUser() {
      const id = this.user.id;
      if (id) {
        getUserById(id).then((user) => {
          this.setUser(user);
        });
      }
    },
    resetUser() {
      this.user = {} as UserType;
    }
  },
  getters: {
    getUser(): UserType {
      return this.user;
    }
  }
})