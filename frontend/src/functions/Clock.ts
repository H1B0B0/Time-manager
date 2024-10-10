import axios from "axios";

const BASE_URL = "https://backend.traefik.me/api";

export const createClock = async(userId: string, data: any) => {
    try {
        await axios.post(`${BASE_URL}/clocks/${userId}`, data);
    } catch (error) {
        console.error(error);
    }
}

export const getClock = async(userId: string) => {
    try {
         const response = await axios.get(`${BASE_URL}/clocks/${userId}`);
         
         if (response.status != 200) {
            throw new Error("Failed to get clock");
         }
        
         return response.data;
    } catch (error) {
        console.error(error);
        throw error;
    }
}