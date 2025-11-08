import axios, { type AxiosError } from 'axios';

import type News from '@/interfaces/news';
import type { StrapiResponse } from '@/interfaces/news';

const strapiUrl = import.meta.env.STRAPI_URL;

if (!strapiUrl) {
  throw new Error('STRAPI_URL environment variable is not defined');
}

const strapiClient = axios.create({
  baseURL: strapiUrl,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 5000,
});

async function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export async function fetchNews(
  maxRetries: number = 3,
  retryDelay: number = 1000
): Promise<News[]> {
  let lastError: Error | null = null;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await strapiClient.get<StrapiResponse<News[]>>('/api/news', {
        params: {
          sort: 'publishedAt:desc',
          populate: '*',
        },
      });

      return response.data.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      lastError = new Error(`Failed to fetch news: ${axiosError.message}`);

      // eslint-disable-next-line no-console
      console.error(`Attempt ${attempt}/${maxRetries} - Error fetching news:`, axiosError.message);

      if (axiosError.response) {
        // eslint-disable-next-line no-console
        console.error('Status:', axiosError.response.status);
        // eslint-disable-next-line no-console
        console.error('Data:', axiosError.response.data);
      } else if (axiosError.code === 'ECONNREFUSED' || axiosError.code === 'ETIMEDOUT') {
        // eslint-disable-next-line no-console
        console.error('Strapi server appears to be unreachable.');
      }

      // If this is not the last attempt, wait before retrying
      if (attempt < maxRetries) {
        // eslint-disable-next-line no-console
        console.log(`Retrying in ${retryDelay}ms...`);
        await delay(retryDelay);
      }
    }
  }

  // If all attempts failed, log the error and return an empty array
  // instead of throwing an exception to prevent the application from crashing
  // eslint-disable-next-line no-console
  console.error(`Failed to fetch news after ${maxRetries} attempts.`, lastError);

  // eslint-disable-next-line no-console
  console.warn('The application will continue to work without news.');

  return [];
}
