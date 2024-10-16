import axios from "axios";
import Cookies from "js-cookie";
import type { UserType } from "../types/UserType";

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


export const createUser = async (email: string, username: string, password: string) => {
  try {
    const response = await axios.post("/api/users", {
      email,
      username,
      password,
    });
    return response;
  } catch (error) {
    if (axios.isAxiosError(error) && error.response) {
      throw new Error(error.response.data.message || "Failed to create user");
    } else {
      throw new Error("Failed to create user");
    }
  }
};

export const updateUser = async (id: number, data: UserType) => {
  try {
    const config = {
      headers: {
        "Content-Type": "application/json",
        ...getAuthHeaders(),
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
    return await axios.delete(`${BASE_URL}/users/${id}`, {
      headers: getAuthHeaders(),
    });
  } catch (error) {
    console.error(error);
    throw error;
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
      {
        token: token,
      },
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
