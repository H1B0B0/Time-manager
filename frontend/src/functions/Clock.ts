import axios from "axios";
import type { ClockType } from "../types/ClockType";

const BASE_URL = "https://backend.traefik.me/api";

export const getClock = async (userId: number) => {
  try {
    const response = await axios.get(`${BASE_URL}/clocks/${userId}`);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const getLatestClock = async (userId: number) => {
  try {
    const response = await axios.get(`${BASE_URL}/clocks/${userId}`);
    return response.data.data[response.data.data.length - 1];
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export const createClock = async (userId: number, data: ClockType) => {
  try {
    const config = {
      headers: {
        'Content-Type': 'application/json'
      }
    }
    const response = await axios.post(`${BASE_URL}/clocks/${userId}`, JSON.stringify({ clock: data }), config);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
}