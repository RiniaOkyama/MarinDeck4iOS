import { defineConfig } from 'vite'
// import copy from 'rollup-plugin-copy'

const { resolve } = require('path')

// https://vitejs.dev/config/
export default defineConfig({
  esbuild: {
    minify: false
  },
  build: {
    rollupOptions: {
      input: 'src/main.ts',
      output: {
          entryFileNames: 'marindeck.js'
      }
    },
    outDir: '../Marindeck/js'
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
