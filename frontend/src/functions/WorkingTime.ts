import axios from "axios";

const BASE_URL = "https://" + import.meta.env.VITE_BACKEND_DNS + "/api";

export const deleteWorkingTime = async (id: string): Promise<void> => {
  await axios.delete(`${BASE_URL}/workingtime/${id}`);
};

export const updateWorkingTime = async (
  userID: string,
  data: any
): Promise<void> => {
  const response = await axios.put(`${BASE_URL}/workingtime/${userID}`, {
    workingtime: data,
  });
  return response.data;
};

export const createWorkingTime = async (data: any): Promise<void> => {
  const response = await axios.post(`${BASE_URL}/workingtime/users`, data);
  return response.data;
};

export const showWorkingTime = async (
  userID: string,
  id: string
): Promise<any> => {
  const response = await axios.get(`${BASE_URL}/workingtime/${userID}/${id}`);
  return response.data;
};

export const getWorkingTimes = async (
  userID: string,
  start: string,
  end: string
): Promise<any[]> => {
  const response = await axios.get(
    `${BASE_URL}/workingtime/${userID}?start=${start}&end=${end}`
  );
  return response.data;
};
