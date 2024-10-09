import axios from "axios";

const BASE_URL = "https://backend.treafik.me";

export const deleteWorkingTime = async (id: string): Promise<void> => {
  await axios.delete(`${BASE_URL}/workingtime/${id}`);
};

export const updateWorkingTime = async (
  userID: string,
  data: any
): Promise<void> => {
  await axios.put(`${BASE_URL}/workingtime/${userID}`, data);
};

export const createWorkingTime = async (data: any): Promise<void> => {
  await axios.post(`${BASE_URL}/workingtime/users`, data);
};

export const showWorkingTime = async (
  userID: string,
  id: string
): Promise<any> => {
  const response = await axios.get(`${BASE_URL}/workingtime/${userID}/${id}`);
  return response.data;
};

export const getAllWorkingTimes = async (userID: string): Promise<any[]> => {
  const response = await axios.get(`${BASE_URL}/workingtime/${userID}`);
  return response.data;
};
