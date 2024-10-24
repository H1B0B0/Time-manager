import axios from "axios";
import Cookies from "js-cookie";

const BASE_URL = "https://" + import.meta.env.VITE_BACKEND_DNS + "/api";

const getAuthHeaders = () => {
  const token = Cookies.get("token");
  return token ? { Authorization: `Bearer ${token}` } : {};
};

const cacheData = (key: string, data: any) => {
  localStorage.setItem(key, JSON.stringify(data));
};

const getCachedData = (key: string) => {
  const data = localStorage.getItem(key);
  return data ? JSON.parse(data) : null;
};

export const getOneTeam = async (teamId: number) => {
  const cacheKey = `team_${teamId}`;
  if (!navigator.onLine) {
    return getCachedData(cacheKey);
  }

  try {
    const response = await axios.get(`${BASE_URL}/teams/${teamId}`, {
      headers: getAuthHeaders(),
    });
    const data = response.data.data;
    cacheData(cacheKey, data);
    return data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const updateTeam = async (teamId: number, teamData: any) => {
  try {
    const response = await axios.put(
      `${BASE_URL}/teams/${teamId}`,
      { team: teamData },
      {
        headers: getAuthHeaders(),
      }
    );
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const createTeam = async (teamData: any) => {
  try {
    const response = await axios.post(
      `${BASE_URL}/teams`,
      { team: teamData },
      {
        headers: getAuthHeaders(),
      }
    );
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const deleteTeam = async (teamId: number) => {
  try {
    await axios.delete(`${BASE_URL}/teams/${teamId}`, {
      headers: getAuthHeaders(),
    });
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const getAllTeams = async () => {
  const cacheKey = `all_teams`;
  if (!navigator.onLine) {
    return getCachedData(cacheKey);
  }

  try {
    const response = await axios.get(`${BASE_URL}/teams`, {
      headers: getAuthHeaders(),
    });
    const data = response.data.data;
    cacheData(cacheKey, data);
    return data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const getTeamByUser = async (userId: number) => {
  const cacheKey = `teams_user_${userId}`;
  if (!navigator.onLine) {
    return getCachedData(cacheKey);
  }

  try {
    const response = await axios.get(`${BASE_URL}/user/${userId}/teams`, {
      headers: getAuthHeaders(),
    });
    const data = response.data;
    cacheData(cacheKey, data);
    return data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};
