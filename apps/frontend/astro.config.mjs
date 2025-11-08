// @ts-check
import react from '@astrojs/react';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig, envField } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  vite: {
    plugins: [tailwindcss()],
    server: {
      fs: {
        allow: ['../..'],
      },
    },
  },

  integrations: [react(), sitemap()],

  env: {
    schema: {
      STRAPI_URL: envField.string({
        context: 'client',
        access: 'public',
      }),
    },
  },
});
