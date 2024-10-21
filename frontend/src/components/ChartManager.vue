<template>
  <div class="p-4 rounded-lg w-full max-w-7xl mx-auto">
    <h1 class="text-2xl font-bold text-center text-white mb-4">My Schedule</h1>
    <p v-if="errorMessage" class="text-red-500 mb-2">{{ errorMessage }}</p>
    <div class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl w-full">
      <div class="relative w-full h-[600px]">
        <vue-cal
          :events="events"
          :time="true"
          :view="view"
          :special-hours="specialHours"
          :event-class="getEventClass"
          @view-change="handleViewChange"
          eventsCountOnYearView="dot"
        />
      </div>
    </div>
  </div>
</template>

<script>
import VueCal from "vue-cal";
import "vue-cal/dist/vuecal.css";
import { ref, onMounted } from "vue";
import { getWorkingTimes } from "../functions/WorkingTime";
import router from "@/router";

export default {
  name: "ScheduleCalendar",
  components: { VueCal },
  setup() {
    const events = ref([]);
    const errorMessage = ref("");
    const view = ref("week");
    const startDate = ref(new Date("2000-01-01T00:00:00Z"));
    const endDate = ref(new Date("2100-12-31T23:59:59Z"));

    const specialHours = ref({
      1: {
        from: 12 * 60,
        to: 13 * 60,
        class: "lunch-break",
        label: "Lunch Break",
      },
      2: {
        from: 12 * 60,
        to: 13 * 60,
        class: "lunch-break",
        label: "Lunch Break",
      },
      3: {
        from: 12 * 60,
        to: 13 * 60,
        class: "lunch-break",
        label: "Lunch Break",
      },
      4: {
        from: 12 * 60,
        to: 13 * 60,
        class: "lunch-break",
        label: "Lunch Break",
      },
      5: {
        from: 12 * 60,
        to: 13 * 60,
        class: "lunch-break",
        label: "Lunch Break",
      },
      6: {
        from: 0,
        to: 24 * 60 - 1,
        class: "lunch-break",
      },
      7: {
        from: 0,
        to: 24 * 60 - 1,
        class: "lunch-break",
      },
    });

    const getEventClass = (event) => {
      if (event.title === "Work") {
        return "work-event";
      }
      return "";
    };

    const fetchData = async () => {
      try {
        const response = await getWorkingTimes(
          router.currentRoute.value.params.userID,
          startDate.value.toISOString(),
          endDate.value.toISOString()
        );

        events.value = response.data.flatMap((element) => {
          const start = new Date(element.start);
          const end = new Date(element.end);
          const lunchStart = new Date(start);
          lunchStart.setHours(12, 0, 0, 0);
          const lunchEnd = new Date(start);
          lunchEnd.setHours(13, 0, 0, 0);

          if (start < lunchStart && end > lunchEnd) {
            return [
              {
                start: start,
                end: lunchStart,
                title: "Work",
              },
              {
                start: lunchEnd,
                end: end,
                title: "Work",
              },
            ];
          } else if (start < lunchStart && end > lunchStart) {
            return {
              start: start,
              end: lunchStart,
              title: "Work",
            };
          } else if (start < lunchEnd && end > lunchEnd) {
            return {
              start: lunchEnd,
              end: end,
              title: "Work",
            };
          } else {
            return {
              start: start,
              end: end,
              title: "Work",
            };
          }
        });
      } catch (error) {
        errorMessage.value = "Failed to fetch data";
        console.error(error);
      }
    };

    const handleViewChange = (newView) => {
      view.value = newView;
      fetchData();
    };

    onMounted(() => {
      fetchData();
    });

    return {
      events,
      errorMessage,
      view,
      specialHours,
      getEventClass,
      handleViewChange,
    };
  },
};
</script>

<style>
.vuecal {
  border-radius: 0.5rem;
  color: white;
}

.vuecal__cell-events-count {
  width: 0.5rem;
  min-width: 0;
  height: 0.5rem;
  padding: 0;
  background-color: #0bf5f1;
  color: transparent;
}

.vuecal__cell {
  border-radius: 0.5rem;
  padding-left: 0.15rem;
  padding-right: 0.15rem;
}

.vuecal__time,
.vuecal__header {
  color: white;
  border-radius: 0.5rem;
}

.vuecal__cell--selected:before {
  background-color: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.5);
  border-radius: 0.5rem;
}

.vuecal__time {
  font-size: 0.75rem;
  border-radius: 0.5rem;
}

.vuecal__header {
  font-size: 1rem;
  border-radius: 0.5rem;
}

.work-event:hover {
  background-color: #0bf5f1;
  color: white;
}

.vuecal__event {
  border-radius: 0.5rem;
  background-color: rgba(106, 76, 255, 0.75);
  padding: 0.5rem;
  color: white;
  border: 1px solid white;
  font-size: auto;
}

.vuecal__event--selected {
  border-radius: 0.5rem;
  background-color: #c736eb;
  color: white;
  border: 1px solid white;
}

.lunch-break {
  background: transparent
    repeating-linear-gradient(
      -45deg,
      rgba(207, 87, 255, 0.25),
      rgba(207, 87, 255, 0.25) 5px,
      rgba(255, 255, 255, 0) 5px,
      rgba(255, 255, 255, 0) 15px
    );
  color: white;
  padding: 0.5rem;
}

.vuecal__cell--today,
.vuecal__cell--current {
  background-color: rgba(255, 255, 255, 0.234);
}

.vuecal__cell--highlighted:not(.vuecal__cell--has-splits),
.vuecal__cell-split--highlighted {
  background-color: rgba(195, 255, 225, 0.25);
}

.vuecal__arrow.vuecal__arrow--highlighted,
.vuecal__view-btn.vuecal__view-btn--highlighted {
  background-color: rgba(136, 236, 191, 0.25);
}

/* Ensure month, year, and other text elements are white */
.vuecal__month,
.vuecal__year,
.vuecal__day,
.vuecal__weekday,
.vuecal__weeknumber {
  color: white !important;
}

.vuecal__year-view .vuecal__year,
.vuecal__year-view .vuecal__month {
  color: white !important;
}

.vuecal__month-view .vuecal__day,
.vuecal__month-view .vuecal__weekday {
  color: white !important;
}

.vuecal__week-view .vuecal__day,
.vuecal__week-view .vuecal__weekday {
  color: white !important;
}

.vuecal__day-view .vuecal__time {
  color: white !important;
}

/* Ensure grid lines and legends are white */
.vuecal__grid,
.vuecal__legend {
  color: white !important;
  border-color: white !important;
}
</style>
