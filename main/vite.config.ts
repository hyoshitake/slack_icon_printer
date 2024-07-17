import {defineConfig} from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  // 追加
  server: {
    host: true,
    watch: {
      usePolling: true
    }
  },
  resolve: {
    extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
    alias: {
      '@/': `${__dirname}/src/`,
      '~/': `${__dirname}/public/`
    },
  },
})
