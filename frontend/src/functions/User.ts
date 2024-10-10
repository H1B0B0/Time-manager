import axios from "axios";
import type { UserType } from "../types/UserType";

const BASE_URL = "https://backend.traefik.me/api";

export const getUserById = async (id: number) => {
  try {
    const response = await axios.get(`${BASE_URL}/users/${id}`);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const getUser = async (username: string, email: string) => {
  try {
    const response = await axios.get(`${BASE_URL}/users/`, {
      params: {
        username,
        email
      }
    });
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const createUser = async (data: UserType) => {
  try {
    const config = {
      headers: {
        'Content-Type': 'application/json'
      }
    }
    const response = await axios.post(`${BASE_URL}/users`, JSON.stringify({ user: data }), config);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const updateUser = async (id: number, data: UserType) => {
  try {
    const config = {
      headers: {
        'Content-Type': 'application/json'
      }
    }
    const response = await axios.put(`${BASE_URL}/users/${id}`, JSON.stringify({ user: data }), config);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const deleteUser = async (id: number) => {
  try {
    return await axios.delete(`${BASE_URL}/users/${id}`);
  } catch (error) {
    console.error(error);
    throw error;
  }
}

// Usage:
// onMounted(async () => {
//   const user = await getUserById(5)
//   console.log(user)
// })
