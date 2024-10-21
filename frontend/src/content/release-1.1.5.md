---
title: Release 1.1.5
description: Release note of 21/10/2024
---

## Release 1.1.5 - 21/10/2024

### New Additions ✨

- Added a "My Schedule" title in the `ChartManager.vue` component.

### Improvements 🚀

- Separated working time (`Workingtime`) and clock (`Clock`) records to reflect independent data.
- Adjusted the order of the days of the week to ensure the first column is always Monday and the last is always Sunday.
- Converted total worked hours to hours and minutes in the `WorkedHoursPerMonth.vue` component.

### Fixes 🛠️

- Corrected the display order of the days of the week (Monday to Sunday) in the `WorkedHoursPerDayChart.vue` component.
- Fixed user redirection based on `role_id` in the `adminDashboard.vue` component.

### Detailed Changes 📋

#### Random Data Generation 🎲

- Generated random data for working hours and clocks in the `seeds.exs` file.
- Separated generation functions for working time (`Workingtime`) and clock (`Clock`) records.

#### Display Order of Days of the Week 📅

- Adjusted the index of the day of the week to ensure Monday is the first day and Sunday is the last day.
- Updated labels to ensure the days of the week are displayed in the correct order.

#### Conversion of Worked Hours ⏱️

- Added the `formatTotalHours` function to convert total worked hours to hours and minutes.
- Used `formatTotalHours` in the `WorkedHoursPerMonth.vue` component to display total worked hours in hours and minutes.

#### User Redirection 🔄

- Verified the `role_id` of the logged-in user and redirected accordingly in the `adminDashboard.vue` component.
- Added logs for debugging and verification of `roleId` and `loggedInUserId` values.
