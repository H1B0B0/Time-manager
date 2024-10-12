import { defineStore } from 'pinia'
import type { UserType } from '@/types/UserType'
import { getUserById } from '@/functions/User'

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

  },
  getters: {
    getUser(): UserType {
      return this.user;
    }
  }
})