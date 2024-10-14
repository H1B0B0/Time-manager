<template>
  <div class="mt-10 w-max p-10 bg-gray-900 rounded-lg shadow-xl max-h-96 overflow-y-auto">
    <h1 class="font-bold text-white text-xl mb-4 sticky top-0 bg-black/85 p-3 rounded border border-blue-800">The latest updates</h1>
    <div class="content">
      <div v-for="(article, index) in articles" :key="index" class="mb-4">
        <h2
          @click="toggleArticle(index)"
          class="cursor-pointer font-semibold text-lg text-white underline"
        >
          {{ article.title }}
        </h2>
        <div v-if="article.isOpen" v-html="article.content" class="mt-2 pl-4 border-l-2 border-gray-300 text-white"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { marked } from 'marked'

export default {
  name: 'App',
  setup() {
    const markdown = ref(`
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
    `)

    const articles = ref([])

    onMounted(() => {
      const parsedContent = marked.lexer(markdown.value)
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
