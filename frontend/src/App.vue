<script setup lang="ts">
import { RouterView } from "vue-router";
import NavBar from "./components/NavBar.vue";

import "https://unpkg.com/@splinetool/viewer@1.9.30/build/spline-viewer.js"; // Spline Viewer

setTimeout(() => {
  let favicon_video_image_counter = 0;
  let favicon_video_icon_tag = document.querySelector(
    "link[rel='icon']"
  ) as HTMLLinkElement | null;
  let favicon_video_images: string[] = [
    "https://favicongenerator.s3.amazonaws.com/7cbcd118557f4.png",
    "https://favicongenerator.s3.amazonaws.com/6c245afde6856.png",
    "https://favicongenerator.s3.amazonaws.com/b3f2d946d4b5e.png",
    "https://favicongenerator.s3.amazonaws.com/c0c9303e3fb88.png",
    "https://favicongenerator.s3.amazonaws.com/e731852814abf.png",
    "https://favicongenerator.s3.amazonaws.com/b5f1eb24129be.png",
    "https://favicongenerator.s3.amazonaws.com/6e517279226a7.png",
    "https://favicongenerator.s3.amazonaws.com/0b6fc7a19e666.png",
    "https://favicongenerator.s3.amazonaws.com/1ea328f73b5f6.png",
    "https://favicongenerator.s3.amazonaws.com/ec4a31f30da88.png",
    "https://favicongenerator.s3.amazonaws.com/41ae8f668fde5.png",
  ];

  async function favicon_video_to_data_url(
    url: string,
    callback: (dataUrl: string | ArrayBuffer | null) => void
  ) {
    let xhr = new XMLHttpRequest();
    xhr.onload = function () {
      let reader = new FileReader();
      reader.onloadend = function () {
        callback(reader.result);
      };
      reader.readAsDataURL(xhr.response);
    };
    xhr.open("GET", url);
    xhr.responseType = "blob";
    xhr.send();
  }

  let favicon_video_loaded_images: (string | ArrayBuffer | null)[] = [];

  favicon_video_images.map((url, idx) => {
    favicon_video_to_data_url(url, function (dataUrl) {
      favicon_video_loaded_images[idx] = dataUrl;
    });
  });

  setInterval(function () {
    if (
      favicon_video_icon_tag &&
      favicon_video_loaded_images[favicon_video_image_counter]
    ) {
      favicon_video_icon_tag.href = (
        favicon_video_loaded_images[favicon_video_image_counter] as string
      ).replace("application/octet-stream", "image/png");
    }
    if (favicon_video_image_counter == favicon_video_loaded_images.length - 1)
      favicon_video_image_counter = 0;
    else favicon_video_image_counter++;
  }, 100);
}, 2000);
</script>

<template>
  <div class="min-h-screen flex flex-col relative bg-black">
    <header class="w-full z-20 bg-transparent">
      <NavBar />
    </header>

    <main
      class="flex-grow flex items-center justify-center bg-transparent z-10"
    >
      <spline-viewer
        class="absolute inset-0 w-full h-full"
        url="https://prod.spline.design/soRsUYV4PO0dCd6S/scene.splinecode"
        play="true"
      ></spline-viewer>
      <div class="z-20">
        <RouterView />
      </div>
    </main>
  </div>
</template>

<style>
#container #logo {
  display: none !important;
}
</style>
