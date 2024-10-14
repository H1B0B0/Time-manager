<template>
  <div
    class="mt-10 p-6 backdrop-blur-2xl rounded-lg shadow-xl max-h-auto overflow-visible flex flex-col items-center mx-auto w-full align-middle items-center"
  >
    <h1 class="font-bold text-white text-2xl sticky top-0 p-3 rounded">
      The latest updates
    </h1>
    <p class="border-b mb-6 p-3 text-white items-center text-center">
      <a
        href="https://www.instagram.com/gothamtimenews/"
        class="underline underline-offset-2 bg-gradient-to-r from-purple-500 via-pink-500 to-blue-500 bg-clip-text text-transparent text-lg transition duration-300 ease-in-out transform hover:scale-105 hover:shadow-lg"
      >
        Follow us
      </a>
      on Instagram to stay updated with the latest news.
    </p>
    <div class="overflow-y-auto space-y-4 w-full">
      <div
        v-for="(article, index) in articles"
        :key="index"
        class="bg-gray-800 rounded-lg overflow-visible transition-all duration-300 ease-in-out relative"
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
          class="p-4 bg-gray-700 text-white prose prose-lg max-w-none"
          v-html="article.content"
        ></div>
        <span
          v-if="!article.isRead"
          class="absolute top-0 right-0 inline-block w-2 h-2 bg-red-500 rounded-full z-50"
        ></span>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";

// Utiliser import.meta.glob pour charger tous les fichiers Markdown dans le dossier 'content'
const markdownFiles = import.meta.glob("../content/*.md");

export default {
  name: "UpdatesComponent",
  setup() {
    const articles = ref([]);
    const latestVersion = ref("");

    onMounted(async () => {
      for (const path in markdownFiles) {
        const fileContent = await markdownFiles[path]();
        const { attributes, html } = fileContent;
        const title = attributes.title;
        const description = attributes.description; // Ajout de la description
        const content = html;
        const versionMatch = title.match(/\d+(\.\d+)+/);
        const version = versionMatch ? versionMatch[0] : title;
        const isRead = localStorage.getItem(`article-${version}`) === "true";
        articles.value.push({
          title,
          description, // Ajout de la description
          content,
          version,
          isOpen: false,
          isRead,
        });
      }

      // Trier les articles par version de release
      articles.value.sort((a, b) => {
        const versionA = a.version;
        const versionB = b.version;
        return versionB.localeCompare(versionA, undefined, { numeric: true });
      });

      // Mettre à jour la version la plus récente
      if (articles.value.length > 0) {
        latestVersion.value = articles.value[0].version;
        localStorage.setItem("latest-news-version", latestVersion.value);
      }

      // Vérifier si toutes les nouvelles ont été lues
      checkAllArticlesRead();
    });

    const toggleArticle = (index) => {
      articles.value[index].isOpen = !articles.value[index].isOpen;
      if (articles.value[index].isOpen) {
        articles.value[index].isRead = true;
        localStorage.setItem(
          `article-${articles.value[index].version}`,
          "true"
        );
        checkAllArticlesRead();
        // Émettre un événement global pour notifier le changement
        window.dispatchEvent(new Event("latest-news-read"));
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
    };
  },
};
</script>

<style>
/* Add styling for better readability of the markdown content */
.prose h2 {
  color: #8b5cf6; /* Tailwind violet-500 */
}
.prose ul {
  list-style-type: disc;
  margin-left: 1.5rem;
}
.prose li {
  color: #d1d5db; /* Tailwind cool-gray-300 */
}
</style>
