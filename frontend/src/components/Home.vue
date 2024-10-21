<template>
  <div class="min-h-screen text-white flex flex-col">
    <div class="mb-40">
      <div class="relative isolate overflow-hidden pt-14">
        <div class="mx-auto max-w-2xl py-24 sm:py-32 lg:py-40">
          <div class="hidden sm:mb-8 sm:flex sm:justify-center">
            <div
              class="relative rounded-full px-3 py-1 text-sm leading-6 text-gray-400 ring-1 ring-white/10 hover:ring-white/20"
            >
              Announcing our next round of funding.
              <a href="/news" class="font-semibold text-white">
                <span class="absolute inset-0" aria-hidden="true" />Read more
                <span aria-hidden="true">&rarr;</span>
              </a>
            </div>
          </div>
          <div class="text-center px-0 sm:px-4">
            <h1
              class="text-balance text-4xl font-bold tracking-tight text-white sm:text-6xl"
            >
              Time Manager for your Projects / Company
            </h1>
            <p class="mt-6 text-lg leading-8 text-gray-300">
              Anim aute id magna aliqua ad ad non deserunt sunt. Qui irure qui
              lorem cupidatat commodo. Elit sunt amet fugiat veniam occaecat
              fugiat aliqua.
            </p>
            <div
              class="mt-10 flex flex-col sm:flex-row items-center justify-center gap-x-6 gap-y-4"
            >
              <a
                href="/login"
                class="rounded-md bg-indigo-500 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-400"
              >
                Get started
              </a>
              <a href="/news" class="text-sm font-semibold leading-6 text-white"
                >Learn more <span aria-hidden="true">→</span></a
              >
            </div>
          </div>
        </div>
      </div>
    </div>
    <div
      class="flex flex-wrap gap-8 justify-center align-middle mb-20 px-4 sm:px-0"
    >
      <div
        class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl flex flex-col items-center w-full md:w-5/12"
        id="chart1"
      >
        <h2 class="text-xl mb-4">Project Time Utilization</h2>
        <div
          class="flex flex-col sm:flex-row justify-between text-center mb-4 w-full"
        >
          <div class="mb-4 sm:mb-0">
            <p class="text-2xl font-bold">26,171</p>
            <p>Active Users</p>
          </div>
          <div class="mb-4 sm:mb-0">
            <p class="text-2xl font-bold">5,617</p>
            <p>Hours Tracked</p>
          </div>
          <div>
            <p class="text-2xl font-bold">54,172</p>
            <p>Completed Tasks</p>
          </div>
        </div>
        <canvas id="lineChart" class="w-full"></canvas>
      </div>

      <div
        class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl flex flex-col items-center w-full md:w-5/12"
        id="chart2"
      >
        <h2 class="text-xl mb-4">Productivity Trends</h2>
        <canvas id="horizontalBarChart" class="w-full"></canvas>
      </div>

      <div
        class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl flex flex-col items-center w-full md:w-5/12"
        id="chart3"
      >
        <h2 class="text-xl mb-4">Monthly Time Distribution</h2>
        <canvas id="barChart" class="w-full"></canvas>
      </div>

      <div
        class="backdrop-blur-2xl shadow-xl border p-6 rounded-3xl flex flex-col items-center w-full md:w-5/12"
        id="chart4"
      >
        <h2 class="text-xl mb-4">Tasks Over Time</h2>
        <canvas id="areaChart" class="w-full"></canvas>
      </div>
    </div>
    <div class="mx-auto w-11/12 lg:px-8 mb-40 px-4 sm:px-0" id="avis">
      <div
        class="relative overflow-hidden bg-gray-900 px-6 py-20 shadow-xl rounded-3xl sm:px-10 sm:py-24 md:px-12 lg:px-20"
      >
        <img
          class="absolute inset-0 h-full w-full object-cover brightness-150 saturate-0"
          src="https://img.lemde.fr/2012/07/07/4/0/1024/512/1342/671/60/0/ill_1729361_c0b3_201207071.0.988834193face_batman_ori.jpg"
          alt=""
        />
        <div class="absolute inset-0 bg-gray-900/90 mix-blend-multiply" />
        <div
          class="absolute -left-80 -top-56 transform-gpu blur-3xl"
          aria-hidden="true"
        >
          <div
            class="aspect-[1097/845] w-[68.5625rem] bg-gradient-to-r from-[#ff4694] to-[#776fff] opacity-[0.45]"
            style="
              clip-path: polygon(
                74.1% 44.1%,
                100% 61.6%,
                97.5% 26.9%,
                85.5% 0.1%,
                80.7% 2%,
                72.5% 32.5%,
                60.2% 62.4%,
                52.4% 68.1%,
                47.5% 58.3%,
                45.2% 34.5%,
                27.5% 76.7%,
                0.1% 64.9%,
                17.9% 100%,
                27.6% 76.8%,
                76.1% 97.7%,
                74.1% 44.1%
              );
            "
          />
        </div>
        <div
          class="hidden md:absolute md:bottom-16 md:left-[50rem] md:block md:transform-gpu md:blur-3xl"
          aria-hidden="true"
        >
          <div
            class="aspect-[1097/845] w-[68.5625rem] bg-gradient-to-r from-[#ff4694] to-[#776fff] opacity-25"
            style="
              clip-path: polygon(
                74.1% 44.1%,
                100% 61.6%,
                97.5% 26.9%,
                85.5% 0.1%,
                80.7% 2%,
                72.5% 32.5%,
                60.2% 62.4%,
                52.4% 68.1%,
                47.5% 58.3%,
                45.2% 34.5%,
                27.5% 76.7%,
                0.1% 64.9%,
                17.9% 100%,
                27.6% 76.8%,
                76.1% 97.7%,
                74.1% 44.1%
              );
            "
          />
        </div>
        <div class="relative mx-auto max-w-2xl lg:mx-0">
          <img
            class="h-12 w-auto"
            src="https://tailwindui.com/plus/img/logos/workcation-logo-white.svg"
            alt=""
          />
          <figure>
            <blockquote
              class="mt-6 text-lg font-semibold text-white sm:text-xl sm:leading-8"
            >
              <p>
                “As the protector of Gotham, managing my time efficiently is
                crucial. The TimeManager has been an invaluable tool in
                organizing my patrols, missions, and Wayne Enterprises meetings.
                It's like having Alfred's assistance, but in a digital form.
                Highly recommended for anyone who needs to keep their city safe
                and their business running smoothly.”
              </p>
            </blockquote>
            <figcaption class="mt-6 text-base text-white">
              <div class="font-semibold">Batman</div>
              <div class="mt-1">CEO of Gotham</div>
            </figcaption>
          </figure>
        </div>
      </div>
    </div>
  </div>
  <PwaPopup />
</template>

<script>
import { onMounted } from "vue";
import { useRouter } from "vue-router";
import { useUserStore } from "@/stores/use-user-store";
import { GetUserByToken } from "@/functions/User";
import {
  Chart,
  LineElement,
  BarElement,
  PointElement,
  LineController,
  BarController,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import anime from "animejs/lib/anime.es.js";
import PwaPopup from "./PwaPopup.vue";

Chart.register(
  LineElement,
  BarElement,
  PointElement,
  LineController,
  BarController,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip,
  Legend
);

export default {
  name: "Home",
  setup() {
    const router = useRouter();
    const userStore = useUserStore();

    onMounted(async () => {
      try {
        const user = await GetUserByToken();
        if (user) {
          userStore.setUser(user);
          router.push(`/dashboard/${user.id}`); // Rediriger vers le tableau de bord si déjà connecté
        }
      } catch (error) {
        console.log("User not logged in");
      }
    });

    const animateOnScroll = (element, animationIn, animationOut) => {
      let threshold = 0.3;
      const observer = new IntersectionObserver(
        (entries) => {
          entries.forEach((entry) => {
            if (entry.isIntersecting) {
              threshold = 0.3;
              animationIn.play();
              animationOut.pause();
            } else {
              threshold = 0;
              animationOut.play();
              animationIn.pause();
            }
          });
        },
        { threshold: threshold }
      );
      observer.observe(element);
    };

    onMounted(() => {
      // Line Chart for card 1
      const lineCtx = document.getElementById("lineChart").getContext("2d");
      const lineChart = new Chart(lineCtx, {
        type: "line",
        data: {
          labels: [
            "Mar 2022",
            "May 2022",
            "Jul 2022",
            "Sep 2022",
            "Nov 2022",
            "Jan 2023",
          ],
          datasets: [
            {
              label: "Hours Tracked",
              data: [1000, 6000, 4000, 5000, 4500, 2000],
              borderColor: "#7B61FF", // Violet
              fill: false,
            },
          ],
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              labels: {
                color: "white",
              },
            },
            title: {
              display: true,
              color: "white",
            },
            tooltip: {
              backgroundColor: "rgba(255, 255, 255, 0.8)",
              titleColor: "black",
              bodyColor: "black",
            },
          },
          scales: {
            x: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
            y: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
          },
        },
      });

      // Horizontal Bar Chart for card 2
      const horizontalBarCtx = document
        .getElementById("horizontalBarChart")
        .getContext("2d");
      const horizontalBarChart = new Chart(horizontalBarCtx, {
        type: "bar",
        data: {
          labels: ["Productive Time", "Neutral Time", "Unproductive Time"],
          datasets: [
            {
              label: "Time Distribution",
              data: [40, 40, 20],
              backgroundColor: ["#7B61FF", "#4BC0C0", "#36A2EB"], // Violet, Teal, Blue
            },
          ],
        },
        options: {
          indexAxis: "y",
          responsive: true,
          plugins: {
            legend: {
              labels: {
                color: "white",
              },
            },
            title: {
              display: true,
              color: "white",
            },
            tooltip: {
              backgroundColor: "rgba(255, 255, 255, 0.8)",
              titleColor: "black",
              bodyColor: "black",
            },
          },
          scales: {
            x: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
            y: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
          },
        },
      });

      // Bar Chart for card 3
      const barCtx = document.getElementById("barChart").getContext("2d");
      const barChart = new Chart(barCtx, {
        type: "bar",
        data: {
          labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
          datasets: [
            {
              label: "Hours Tracked",
              data: [300, 400, 500, 200, 300, 500],
              backgroundColor: "#7B61FF", // Violet
            },
          ],
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              labels: {
                color: "white",
              },
            },
            title: {
              display: true,
              color: "white",
            },
            tooltip: {
              backgroundColor: "rgba(255, 255, 255, 0.8)",
              titleColor: "black",
              bodyColor: "black",
            },
          },
          scales: {
            x: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
            y: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
          },
        },
      });

      // Area Chart for card 4
      const areaCtx = document.getElementById("areaChart").getContext("2d");
      const areaChart = new Chart(areaCtx, {
        type: "line",
        data: {
          labels: ["Mar", "May", "Jul", "Sep", "Nov", "Jan"],
          datasets: [
            {
              label: "Completed Tasks",
              data: [1200, 2500, 1800, 2900, 3500, 4200],
              backgroundColor: "rgba(123, 97, 255, 0.2)", // Violet with transparency
              borderColor: "#7B61FF", // Violet
              fill: true,
            },
          ],
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              labels: {
                color: "white",
              },
            },
            title: {
              display: true,
              color: "white",
            },
            tooltip: {
              backgroundColor: "rgba(255, 255, 255, 0.8)",
              titleColor: "black",
              bodyColor: "black",
            },
          },
          scales: {
            x: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
            y: {
              ticks: {
                color: "white",
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
                lineWidth: 1,
                drawOnChartArea: true,
                drawTicks: true,
                tickColor: "white",
                tickLength: 10,
                tickWidth: 1,
              },
            },
          },
        },
      });

      // Animations for the charts
      const charts = [
        { element: document.getElementById("chart1"), index: 0 },
        { element: document.getElementById("chart2"), index: 2 },
        { element: document.getElementById("chart3"), index: 1 },
        { element: document.getElementById("chart4"), index: 3 },
      ];

      charts.forEach(({ element }, index) => {
        const direction = index % 2 === 0 ? "left" : "right";
        const animationIn = anime({
          targets: element,
          opacity: [0, 1],
          translateX: direction === "left" ? [-100, 0] : [100, 0],
          duration: 1500,
          autoplay: false,
        });

        const animationOut = anime({
          targets: element,
          opacity: [1, 0],
          duration: 2000,
          autoplay: false,
        });

        animateOnScroll(element, animationIn, animationOut);
      });

      // Animation for the #avis section
      const avisElement = document.getElementById("avis");
      const avisIn = anime({
        targets: avisElement,
        opacity: [0, 1],
        translateY: [100, 0], // Animate from bottom to top
        duration: 1000,
        autoplay: false,
      });

      const avisOut = anime({
        targets: avisElement,
        opacity: [1, 0],
        duration: 2000,
        autoplay: false,
      });

      // Apply scroll-triggered animation to avis section
      animateOnScroll(avisElement, avisIn, avisOut);
    });
  },
};
</script>
