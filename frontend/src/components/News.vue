<template>
  <div
    class="m-10 p-6 border backdrop-blur-2xl rounded-lg shadow-xl flex flex-col items-center"
  >
    <h1 class="font-bold text-white text-2xl sticky p-3 rounded">
      The latest updates
    </h1>
    <p class="mb-6 p-3 text-white items-center text-center">
      <a
        href="https://www.instagram.com/gothamtimenews/"
        class="neon-text text-lg hover:scale-105 follow-us-text"
      >
        Follow us
      </a>
      on Instagram to stay updated with the latest news.
    </p>
    <div class="space-y-4 w-full">
      <div
        v-for="(article, index) in articles"
        :key="index"
        class="rounded-lg relative p-4 shadow-xl bg-slate-800"
      >
        <button
          @click="toggleArticle(index)"
          class="w-full p-4 flex justify-between items-center text-left focus:outline-none focus:ring-2 focus:ring-blue-600 focus:ring-opacity-50"
        >
          <div class="flex-col">
            <h2 class="font-semibold text-lg text-purple-400">
              {{ article.title }}
            </h2>
            <h4 class="text-sm text-white">
              {{ article.description }}
            </h4>
          </div>
          <svg
            v-if="article.isOpen"
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-blue-500"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z"
              clip-rule="evenodd"
            />
          </svg>
          <svg
            v-else
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-blue-500"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
              clip-rule="evenodd"
            />
          </svg>
        </button>
        <div
          v-if="article.isOpen"
          class="p-4 border-indigo-500 border shadow-xl text-white rounded-lg markdown-content"
          v-html="article.content"
          :ref="(el) => (articleRefs[index] = el)"
        ></div>
        <span
          v-if="index === 0 && !article.isRead"
          class="absolute top-0 right-0 inline-block w-2 h-2 bg-red-500 rounded-full z-50"
        ></span>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, nextTick } from "vue";
import anime from "animejs";

const markdownFiles = import.meta.glob("../content/*.md");

export default {
  name: "UpdatesComponent",
  setup() {
    const articles = ref([]);
    const latestVersion = ref("");
    const articleRefs = ref([]);

    onMounted(async () => {
      for (const path in markdownFiles) {
        const fileContent = await markdownFiles[path]();
        const { attributes, html } = fileContent;
        const title = attributes.title;
        const description = attributes.description;
        const content = html;
        const versionMatch = title.match(/\d+(\.\d+)+/);
        const version = versionMatch ? versionMatch[0] : title;
        const isRead = localStorage.getItem(`article-${version}`) === "true";
        articles.value.push({
          title,
          description,
          content,
          version,
          isOpen: false,
          isRead,
        });
      }

      articles.value.sort((a, b) => {
        const versionA = a.version;
        const versionB = b.version;
        return versionB.localeCompare(versionA, undefined, { numeric: true });
      });

      if (articles.value.length > 0) {
        latestVersion.value = articles.value[0].version;
        localStorage.setItem("latest-news-version", latestVersion.value);
      }

      checkAllArticlesRead();
    });

    const toggleArticle = async (index) => {
      if (articles.value[index].isOpen) {
        // Animation for closing
        anime({
          targets: articleRefs.value[index],
          height: [articleRefs.value[index].scrollHeight, 0],
          opacity: [1, 0],
          padding: [articleRefs.value[index].style.padding, 0],
          duration: 1000,
          easing: "easeInOutQuad",
          complete: () => {
            articles.value[index].isOpen = false;
          },
        });
      } else {
        articles.value[index].isOpen = true;
        articles.value[index].isRead = true;
        localStorage.setItem(
          `article-${articles.value[index].version}`,
          "true"
        );
        checkAllArticlesRead();
        window.dispatchEvent(new Event("latest-news-read"));

        await nextTick();
        // Animation for opening
        anime({
          targets: articleRefs.value[index],
          height: [0, articleRefs.value[index].scrollHeight],
          opacity: [0, 1],
          padding: [0, "1rem"], // Adjust padding as needed
          duration: 1000,
        });
      }
    };

    const checkAllArticlesRead = () => {
      const allRead = articles.value.every((article) => article.isRead);
      if (allRead) {
        localStorage.setItem("latest-news-id", "true");
      } else {
        localStorage.removeItem("latest-news-id");
      }
    };

    return {
      articles,
      toggleArticle,
      articleRefs,
    };
  },
};
</script>

<style>
.neon-text {
  @apply text-transparent bg-clip-text bg-gradient-to-r from-purple-500 via-pink-500 to-blue-500;
  text-shadow: 0 0 5px #fff, 0 0 10px #fff, 0 0 20px #ff00ff, 0 0 30px #ff00ff,
    0 0 40px #ff00ff, 0 0 50px #ff00ff, 0 0 60px #ff00ff, 0 0 70px #ff00ff;
  animation: neon 1.5s ease-in-out infinite alternate;
}

@keyframes neon {
  from {
    text-shadow: 0 0 5px #fff, 0 0 10px #fff, 0 0 20px #ff00ff, 0 0 30px #ff00ff,
      0 0 40px #ff00ff, 0 0 50px #ff00ff, 0 0 60px #ff00ff, 0 0 70px #ff00ff;
  }
  to {
    text-shadow: 0 0 10px #fff, 0 0 20px #ff00ff, 0 0 30px #ff00ff,
      0 0 40px #ff00ff, 0 0 50px #ff00ff, 0 0 60px #ff00ff, 0 0 70px #ff00ff,
      0 0 80px #ff00ff;
  }
}

.follow-us-text {
  font-size: 1.25rem; /* Increase font size */
  color: #ffffff; /* Change text color */
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5); /* Add text shadow */
  background: linear-gradient(to right, #ff00ff, #00ffff);
  -webkit-background-clip: text;
  color: transparent;
  transition: background 0.3s ease-in-out;
}

.follow-us-text:hover {
  background: linear-gradient(to right, #ff0000, #ffff00);
  -webkit-background-clip: text;
  color: transparent;
}

.markdown-content h1,
.markdown-content h2,
.markdown-content h3,
.markdown-content h4,
.markdown-content h5,
.markdown-content h6 {
  color: #8b5cf6; /* Tailwind violet-500 */
  margin-top: 1rem;
  margin-bottom: 0.5rem;
}

.markdown-content p {
  color: #d1d5db; /* Tailwind cool-gray-300 */
  margin-bottom: 1rem;
}

.markdown-content ul {
  list-style-type: disc;
  margin-left: 1.5rem;
  color: #d1d5db; /* Tailwind cool-gray-300 */
}

.markdown-content li {
  margin-bottom: 0.5rem;
}

.markdown-content a {
  color: #60a5fa; /* Tailwind blue-400 */
  text-decoration: underline;
}

.markdown-content a:hover {
  color: #3b82f6; /* Tailwind blue-500 */
}

.markdown-content blockquote {
  border-left: 4px solid #8b5cf6; /* Tailwind violet-500 */
  padding-left: 1rem;
  color: #d1d5db; /* Tailwind cool-gray-300 */
  margin: 1rem 0;
}

.markdown-content code {
  background-color: #1f2937; /* Tailwind gray-800 */
  color: #f9fafb; /* Tailwind gray-50 */
  padding: 0.2rem 0.4rem;
  border-radius: 0.25rem;
}

.markdown-content pre {
  background-color: #1f2937; /* Tailwind gray-800 */
  color: #f9fafb; /* Tailwind gray-50 */
  padding: 1rem;
  border-radius: 0.5rem;
  overflow-x: auto;
}
</style>
