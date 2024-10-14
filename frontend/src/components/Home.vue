<template>
  <div class="min-h-screen text-white">
    <div>
      <header class="absolute inset-x-0 top-0 z-50">
        <nav
          class="flex items-center justify-between p-6 lg:px-8"
          aria-label="Global"
        >
          <div class="flex lg:hidden">
            <button
              type="button"
              class="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-400"
              @click="mobileMenuOpen = true"
            >
              <span class="sr-only">Open main menu</span>
              <Bars3Icon class="h-6 w-6" aria-hidden="true" />
            </button>
          </div>
          <div class="hidden lg:flex lg:gap-x-12">
            <a
              v-for="item in navigation"
              :key="item.name"
              :href="item.href"
              class="text-sm font-semibold leading-6 text-white"
              >{{ item.name }}</a
            >
          </div>
          <div class="hidden lg:flex lg:flex-1 lg:justify-end">
            <a href="#" class="text-sm font-semibold leading-6 text-white"
              >Log in <span aria-hidden="true">&rarr;</span></a
            >
          </div>
        </nav>
        <Dialog
          class="lg:hidden"
          @close="mobileMenuOpen = false"
          :open="mobileMenuOpen"
        >
          <div class="fixed inset-0 z-50" />
          <DialogPanel
            class="fixed inset-y-0 right-0 z-50 w-full overflow-y-auto px-6 py-6 sm:max-w-sm sm:ring-1 sm:ring-white/10"
          >
            <div class="flex items-center justify-between">
              <button
                type="button"
                class="-m-2.5 rounded-md p-2.5 text-gray-400"
                @click="mobileMenuOpen = false"
              >
                <span class="sr-only">Close menu</span>
                <XMarkIcon class="h-6 w-6" aria-hidden="true" />
              </button>
            </div>
            <div class="mt-6 flow-root">
              <div class="-my-6 divide-y divide-gray-500/25">
                <div class="space-y-2 py-6">
                  <a
                    v-for="item in navigation"
                    :key="item.name"
                    :href="item.href"
                    class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-white hover:bg-gray-800"
                    >{{ item.name }}</a
                  >
                </div>
                <div class="py-6">
                  <a
                    href="#"
                    class="-mx-3 block rounded-lg px-3 py-2.5 text-base font-semibold leading-7 text-white hover:bg-gray-800"
                    >Log in</a
                  >
                </div>
              </div>
            </div>
          </DialogPanel>
        </Dialog>
      </header>

      <div class="relative isolate overflow-hidden pt-14">
        <div class="mx-auto max-w-2xl py-32 sm:py-48 lg:py-56">
          <div class="hidden sm:mb-8 sm:flex sm:justify-center">
            <div
              class="relative rounded-full px-3 py-1 text-sm leading-6 text-gray-400 ring-1 ring-white/10 hover:ring-white/20"
            >
              Announcing our next round of funding.
              <a href="/news" class="font-semibold text-white"
                ><span class="absolute inset-0" aria-hidden="true" />Read more
                <span aria-hidden="true">&rarr;</span></a
              >
            </div>
          </div>
          <div class="text-center">
            <h1
              class="text-balance text-4xl font-bold tracking-tight text-white sm:text-6xl"
            >
              Time Manger for your Projects / Company
            </h1>
            <p class="mt-6 text-lg leading-8 text-gray-300">
              Anim aute id magna aliqua ad ad non deserunt sunt. Qui irure qui
              lorem cupidatat commodo. Elit sunt amet fugiat veniam occaecat
              fugiat aliqua.
            </p>
            <div class="mt-10 flex items-center justify-center gap-x-6">
              <a
                href="/user"
                class="rounded-md bg-indigo-500 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-400"
                >Get started</a
              >
              <a href="/news" class="text-sm font-semibold leading-6 text-white"
                >Learn more <span aria-hidden="true">→</span></a
              >
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex flex-wrap gap-8 justify-center align-middle mb-20">
      <div
        class="bg-gray-800 p-6 rounded-lg flex flex-col items-center w-full md:w-5/12 opacity-0"
        id="chart1"
      >
        <h2 class="text-xl mb-4">Project Time Utilization</h2>
        <div class="flex justify-between text-center mb-4 w-full">
          <div>
            <p class="text-2xl font-bold">26,171</p>
            <p>Active Users</p>
          </div>
          <div>
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
        class="bg-gray-800 p-6 rounded-lg flex flex-col items-center w-full md:w-5/12 opacity-0"
        id="chart2"
      >
        <h2 class="text-xl mb-4">Productivity Trends</h2>
        <canvas id="horizontalBarChart" class="w-full"></canvas>
      </div>

      <div
        class="bg-gray-800 p-6 rounded-lg flex flex-col items-center w-full md:w-5/12 opacity-0"
        id="chart3"
      >
        <h2 class="text-xl mb-4">Monthly Time Distribution</h2>
        <canvas id="barChart" class="w-full"></canvas>
      </div>

      <div
        class="bg-gray-800 p-6 rounded-lg flex flex-col items-center w-full md:w-5/12 opacity-0"
        id="chart4"
      >
        <h2 class="text-xl mb-4">Tasks Over Time</h2>
        <canvas id="areaChart" class="w-full"></canvas>
      </div>
    </div>
    <div class="mx-auto max-w-7xl sm:px-6 lg:px-8 mb-40" id="avis">
      <div
        class="relative overflow-hidden bg-gray-900 px-6 py-20 shadow-xl sm:rounded-3xl sm:px-10 sm:py-24 md:px-12 lg:px-20"
      >
        <img
          class="absolute inset-0 h-full w-full object-cover brightness-150 saturate-0"
          src="https://images.unsplash.com/photo-1601381718415-a05fb0a261f3?ixid=MXwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8ODl8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1216&q=80"
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
                “Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo
                expedita voluptas culpa sapiente alias molestiae. Numquam
                corrupti in laborum sed rerum et corporis.”
              </p>
            </blockquote>
            <figcaption class="mt-6 text-base text-white">
              <div class="font-semibold">Judith Black</div>
              <div class="mt-1">CEO of Workcation</div>
            </figcaption>
          </figure>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { onMounted } from "vue";
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
  name: "Dashboard",
  setup() {
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
