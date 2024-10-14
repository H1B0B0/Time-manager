<template>
  <div class="mt-10 w-[90%] p-6 bg-gray-900 rounded-lg shadow-xl max-h-[32rem] overflow-hidden flex flex-col">
    <h1 class="font-bold text-white text-2xl sticky top-0 bg-gray-900/95 p-3 rounded">
      The latest updates
    </h1>
    <p class="border-b border-blue-800 mb-6 p-3 text-white"><a href="https://www.instagram.com/gothamtimenews/" class="underline underline-offset-2">Follow us</a> on instagram to stay updated of the latest news.</p>
    <div class="overflow-y-auto pr-4 space-y-4">
      <div v-for="(article, index) in articles" :key="index" class="bg-gray-800 rounded-lg overflow-hidden transition-all duration-300 ease-in-out">
        <button
          @click="toggleArticle(index)"
          class="w-full p-4 flex justify-between items-center text-left focus:outline-none focus:ring-2 focus:ring-blue-600 focus:ring-opacity-50"
        >
          <h2 class="font-semibold text-lg text-white">{{ article.title }}</h2>
          <svg v-if="article.isOpen" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-blue-500" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z" clip-rule="evenodd" />
          </svg>
          <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-blue-500" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
        <div v-if="article.isOpen" class="p-4 bg-gray-700 text-white" v-html="article.content"></div>
      </div>
    </div>
  </div>


</template>

<script>
import { ref, onMounted } from 'vue'
import { marked } from 'marked'

export default {
  name: 'UpdatesComponent',
  setup() {
    const articles = ref([])

    const markdown = `
# Release 0.0
content lol
# Release 0.0.1
Content lol
# Release 0.0.2
content lol
# Release 0.0
Content lol
# Release 0.0.1
Content lol
# Release 0.0.2
content lol
# Release 0.0
Content lol
# Release 0.0.1
Content lol
# Release 0.0.2
content lol
`

    onMounted(() => {
      const parsedContent = marked.lexer(markdown)
      let currentArticle = null

      for (const token of parsedContent) {
        if (token.type === 'heading' && token.depth === 1) {
          if (currentArticle) {
            articles.value.push(currentArticle)
          }
          currentArticle = { title: token.text, content: '', isOpen: false }
        } else if (currentArticle) {
          currentArticle.content += marked.parseInline(token.raw)
        }
      }

      if (currentArticle) {
        articles.value.push(currentArticle)
      }
    })

    const toggleArticle = (index) => {
      articles.value[index].isOpen = !articles.value[index].isOpen
    }

    return {
      articles,
      toggleArticle
    }
  }
}
</script>
