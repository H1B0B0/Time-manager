import axios from 'axios';
import Cookies from "js-cookie";

const BASE_URL = "https://" + import.meta.env.VITE_BACKEND_DNS + "/api";

const getAuthHeaders = () => {
    const token = Cookies.get("token");
    return token ? { Authorization: `Bearer ${token}` } : {};
  };

export const getOneTeam = async (teamId: number) => {
    try {
        const response = await axios.get(`${BASE_URL}/teams/${teamId}`, {
        headers: getAuthHeaders(),
        });
        return response.data.data;
    } catch (error) {
        console.error(error);
        throw error;
    }
}

export const updateTeam = async (teamId: number, teamData: any) => {
    try {
        const response = await axios.put(`${BASE_URL}/teams/${teamId}`, {team: teamData}, {
        headers: getAuthHeaders(),
        });
        return response.data.data;
    } catch (error) {
        console.error(error);
        throw error;
    }
}
