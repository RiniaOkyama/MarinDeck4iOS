import { defineConfig } from 'vite'
// import copy from 'rollup-plugin-copy'

const { resolve } = require('path')

// https://vitejs.dev/config/
export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'src/main.ts')
      },
      output: {
        entryFileNames: '[name].js',
      },
    },
  },

  // plugins: [
  //   reactRefresh(),
  //   copy({
  //     verbose: true,
  //     hook: 'writeBundle',
  //     targets: [
  //     ],
  //   }),
  // ]
})
