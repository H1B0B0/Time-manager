

<template>
   <h1 class="font-bold text-white text-xl">The latest updates</h1>
   <div v-html="markdownToHtml"></div>
</template>

<script>
import { marked } from 'marked';

export default {
  name: "App",
  data() {
    return {
      markdown: "# Hello World",
    };
  },
  computed: {
    markdownToHtml() {
      return marked(this.markdown);
    }
  }
};
</script>
