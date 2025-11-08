import type { BlocksContent } from '@strapi/blocks-react-renderer';

export default interface News {
  id: number;
  documentId: string;
  title: string;
  slug: string;
  summary: string;
  content: BlocksContent;
  createdAt: string;
  updatedAt: string;
  publishedAt: string;
}

export interface StrapiResponse<T> {
  data: T;
  meta?: {
    pagination?: {
      page: number;
      pageSize: number;
      pageCount: number;
      total: number;
    };
  };
}
