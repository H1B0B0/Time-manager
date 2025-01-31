import axios from "axios";
import Cookies from "js-cookie";
import type { ClockType } from "../types/ClockType";

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

export const getClock = async (userId: number) => {
  const cacheKey = `clock_${userId}`;
  if (!navigator.onLine) {
    return getCachedData(cacheKey);
  }

  try {
    const response = await axios.get(`${BASE_URL}/clocks/${userId}`, {
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

export const getLatestClock = async (userId: number) => {
  const cacheKey = `latest_clock_${userId}`;
  if (!navigator.onLine) {
    return getCachedData(cacheKey);
  }

  try {
    const response = await axios.get(`${BASE_URL}/clocks/${userId}`, {
      headers: getAuthHeaders(),
    });
    const sortedData = response.data.data.sort((a: any, b: any) => a.id - b.id);
    const latestClock = sortedData[sortedData.length - 1];
    cacheData(cacheKey, latestClock);
    return latestClock;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const createClock = async (userId: string, data: ClockType) => {
  try {
    const config = {
      headers: {
        "Content-Type": "application/json",
        ...getAuthHeaders(),
      },
    };
    const response = await axios.post(
      `${BASE_URL}/clocks/${userId}`,
      JSON.stringify({ clock: data }),
      config
    );
    console.log(response);
    return response.data.data;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const getClocksDate = async (
  userId: number,
  start: string,
  end: string
) => {
  const cacheKey = `clocks_date_${userId}_${start}_${end}`;
  if (!navigator.onLine) {
    return getCachedData(cacheKey);
  }

  try {
    const response = await axios.get(`${BASE_URL}/clocks/${userId}`, {
      headers: getAuthHeaders(),
    });
    const clocks: ClockType[] = response.data.data;
    const clocksByDateArray: { date: string; clocks: ClockType[] }[] = [];

    const from = new Date(start).getTime();
    const to = new Date(end).getTime();

    clocks.forEach((clock) => {
      const clockTime = new Date(clock.time).getTime();
      const date = new Date(clock.time).toLocaleDateString();

      if (clockTime >= from && clockTime <= to) {
        let dateGroup = clocksByDateArray.find((group) => group.date === date);

        if (!dateGroup) {
          dateGroup = { date, clocks: [] };
          clocksByDateArray.push(dateGroup);
        }

        dateGroup.clocks.push(clock);
      }
    });

    cacheData(cacheKey, clocksByDateArray);
    return clocksByDateArray;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

export const hoursWorkedPerDay = (
  clocksByDateArray: { date: string; clocks: ClockType[] }[]
) => {
  const hoursWorkedPerDayArray: { date: string; hours: number }[] = [];

  clocksByDateArray.forEach((dateGroup) => {
    const clocks = dateGroup.clocks;
    let hoursWorked = 0;

    for (let i = 0; i < clocks.length; i = i + 2) {
      const clockIn = clocks[i];
      const clockOut = clocks[i + 1];

      if (clockIn && clockOut) {
        const clockInTime = new Date(clockIn.time);
        const clockOutTime = new Date(clockOut.time);

        const diff = clockOutTime.getTime() - clockInTime.getTime();
        const diffHours = diff / 1000 / 60 / 60;

        hoursWorked += diffHours;
      }
    }

    hoursWorkedPerDayArray.push({ date: dateGroup.date, hours: hoursWorked });
  });

  return hoursWorkedPerDayArray;
};
