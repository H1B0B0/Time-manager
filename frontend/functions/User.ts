import axios from "axios";
import type { UserType } from "../types/UserType";

const BASE_URL = "https://backend.traefik.me";

export const getUserById = async (id: number) => {
  try {
    const response = await axios.get(`${BASE_URL}/api/users/${id}`);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const getUser = async (username: string, email: string) => {
  try {
    const response = await axios.get(`${BASE_URL}/api/users/`, {
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
    const response = await axios.post(`${BASE_URL}/api/users`, JSON.stringify({ user: data }), config);
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
    const response = await axios.put(`${BASE_URL}/api/users/${id}`, JSON.stringify({ user: data }), config);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const deleteUser = async (id: number) => {
  try {
    const response = await axios.delete(`${BASE_URL}/api/users/${id}`);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}
