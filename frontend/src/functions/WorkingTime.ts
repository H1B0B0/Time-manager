import axios from "axios";
import Cookies from "js-cookie";

const BASE_URL = "https://" + import.meta.env.VITE_BACKEND_DNS + "/api";

const getAuthHeaders = () => {
  const token = Cookies.get("token");
  return token ? { Authorization: `Bearer ${token}` } : {};
};

export const deleteWorkingTime = async (id: string): Promise<void> => {
  await axios.delete(`${BASE_URL}/workingtime/${id}`, {
    headers: getAuthHeaders(),
  });
};

export const updateWorkingTime = async (
  userID: string,
  data: any
): Promise<void> => {
  const response = await axios.put(
    `${BASE_URL}/workingtime/${userID}`,
    {
      workingtime: data,
    },
    {
      headers: {
        "Content-Type": "application/json",
        ...getAuthHeaders(),
      },
    }
  );
  return response.data;
};

export const createWorkingTime = async (data: any): Promise<void> => {
  const response = await axios.post(`${BASE_URL}/workingtime/users`, data, {
    headers: {
      "Content-Type": "application/json",
      ...getAuthHeaders(),
    },
  });
  return response.data;
};

export const showWorkingTime = async (
  userID: string,
  id: string
): Promise<any> => {
  const response = await axios.get(`${BASE_URL}/workingtime/${userID}/${id}`, {
    headers: getAuthHeaders(),
  });
  return response.data;
};

export const getWorkingTimes = async (
  userID: string,
  start: string,
  end: string
): Promise<any[]> => {
  const response = await axios.get(
    `${BASE_URL}/workingtime/${userID}?start=${start}&end=${end}`,
    {
      headers: getAuthHeaders(),
    }
  );
  return response.data;
};
