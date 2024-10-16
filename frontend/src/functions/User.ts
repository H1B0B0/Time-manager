import axios from "axios";
import type { UserType } from "../types/UserType";

const BASE_URL = "https://" + import.meta.env.VITE_BACKEND_DNS + "/api";

export const getUserById = async (id: number) => {
  try {
    const response = await axios.get(`${BASE_URL}/users/${id}`);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
export const getUser = async (email: string, password: string) => {
  try {
    const response = await axios.post(`${BASE_URL}/auth/login`, {
      user: { email, password }
    });
    return response.data.data;
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.error("Axios error:", error.message);
    } else {
      console.error("Unexpected error:", error);
    }
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

export const updateUser = async (id: number, data: UserType) => {
  try {
    const config = {
      headers: {
        "Content-Type": "application/json",
      },
    };
    const response = await axios.put(
      `${BASE_URL}/users/${id}`,
      JSON.stringify({ user: data }),
      config
    );
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const deleteUser = async (id: number) => {
  try {
    return await axios.delete(`${BASE_URL}/users/${id}`);
  } catch (error) {
    console.error(error);
    throw error;
  }
};

// Usage:
// onMounted(async () => {
//   const user = await getUserById(5)
//   console.log(user)
// })
