import { crx } from '@crxjs/vite-plugin';
import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import manifest from './manifest.json';

export default defineConfig({
  server: {
    port: 5173,
    strictPort: true,
    hmr: {
      port: 5173,
    },
  },
  plugins: [svelte(), crx({ manifest })],
});
