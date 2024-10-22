import axios from "axios";
import Cookies from "js-cookie";
import type { UserType } from "../types/UserType";
import router from "../router";
import { useUserStore } from "@/stores/use-user-store";

const BASE_URL = "https://" + import.meta.env.VITE_BACKEND_DNS + "/api";

const getAuthHeaders = () => {
  const token = Cookies.get("token");
  return token ? { Authorization: `Bearer ${token}` } : {};
};

export const getUserById = async (id: number) => {
  try {
    const response = await axios.get(`${BASE_URL}/users/${id}`, {
      headers: getAuthHeaders(),
    });
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const getUser = async (username: string, email: string) => {
  try {
    const response = await axios.get(`${BASE_URL}/users/`, {
      params: {
        username,
        email,
      },
      headers: getAuthHeaders(),
    });
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const createUser = async (data: UserType) => {
  try {
    const config = {
      headers: {
        "Content-Type": "application/json",
      },
    };
    const response = await axios.post(
      `${BASE_URL}/users`,
      JSON.stringify({ user: data }),
      config
    );
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const updateUser = async (
  id: number,
  data: {
    username: string;
    email: string;
    old_password?: string;
    password?: string;
    oldPassword?: string;
    newPassword?: string;
  }
) => {
  try {
    const config = {
      headers: {
        "Content-Type": "application/json",
        ...getAuthHeaders(),
      },
    };

    const userData = {
      ...data,
      old_password: data.old_password || data.oldPassword,
      password: data.password || data.newPassword,
    };

    delete userData.oldPassword;
    delete userData.newPassword;

    const response = await axios.put(
      `${BASE_URL}/users/${id}`,
      JSON.stringify({ user: userData }),
      config
    );
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const deleteUser = async (id: number): Promise<void> => {
  try {
    const userStore = useUserStore();
    await axios.delete(`${BASE_URL}/users/${id}`, {
      headers: getAuthHeaders(),
    });
    userStore.logout();
    router.push("/");
  } catch (error) {
    console.error(`Failed to delete user with id ${id}:`, error);
    throw new Error(`Failed to delete user with id ${id}`);
  }
};

export const login = async (email: string, password: string) => {
  try {
    const response = await axios.post(`${BASE_URL}/auth/login`, {
      user: { email, password },
    });
    const token = response.data.token;
    const expirationDate = new Date(new Date().getTime() + 12 * 60 * 60 * 1000);
    Cookies.set("token", token, { expires: expirationDate });
    return response.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const GetUserByToken = async () => {
  try {
    const token = Cookies.get("token");
    if (!token) {
      throw new Error("No token found");
    }
    const response = await axios.post(
      `${BASE_URL}/auth/user`,
      {},
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data.user;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const getAllUsers = async () => {
  try {
    const token = Cookies.get("token");
    if (!token) {
      throw new Error("No token found");
    }
    const response = await axios.get(`${BASE_URL}/all-users`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return response.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const getUserByTeam = async (teamId: number) => {
  try {
    const response = await axios.get(`${BASE_URL}/team/${teamId}/users`, {
      headers: getAuthHeaders(),
    });
    return response.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const addUserToTeam = async (userId: number, teamId: number) => {
  try {
    const response = await axios.post(
      `${BASE_URL}/user/${userId}/team/${teamId}`,
      {},
      {
        headers: getAuthHeaders(),
      }
    );
    return response.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const removeUserFromTeam = async (userId: number, teamId: number) => {
  const token = Cookies.get("token");
  if (!token) {
    throw new Error("No token found");
  }

  try {
    const response = await axios.delete(
      `${BASE_URL}/user/${userId}/team/${teamId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
