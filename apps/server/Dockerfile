# ================================
# Strapi Dockerfile - Multi-stage build
# ================================

# Stage 1: Dependencies
FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@10 --activate

# Copy workspace configuration
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY packages/ ./packages/
COPY apps/server/package.json ./apps/server/

# Install dependencies
RUN pnpm install --frozen-lockfile --filter @ligue-des-alternants/server...

# Stage 2: Builder
FROM node:20-alpine AS builder
RUN apk add --no-cache libc6-compat
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@10 --activate

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/packages ./packages
COPY --from=deps /app/apps/server/node_modules ./apps/server/node_modules

# Copy source code
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY apps/server/ ./apps/server/

# Build Strapi
WORKDIR /app/apps/server
ENV NODE_ENV=production
RUN pnpm build

# Stage 3: Production
FROM node:20-alpine AS runner
RUN apk add --no-cache libc6-compat

WORKDIR /app

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337

# Create non-root user for security
RUN addgroup --system --gid 1001 strapi
RUN adduser --system --uid 1001 strapi

# Copy built application from apps/server
COPY --from=builder --chown=strapi:strapi /app/apps/server/dist ./dist
COPY --from=builder --chown=strapi:strapi /app/apps/server/public ./public
COPY --from=builder --chown=strapi:strapi /app/apps/server/config ./config
COPY --from=builder --chown=strapi:strapi /app/apps/server/src ./src
COPY --from=builder --chown=strapi:strapi /app/apps/server/package.json ./package.json

# Copy node_modules (both root and server-specific)
COPY --from=builder --chown=strapi:strapi /app/node_modules ./node_modules
COPY --from=builder --chown=strapi:strapi /app/apps/server/node_modules ./node_modules

# Create uploads directory
RUN mkdir -p public/uploads && chown -R strapi:strapi public/uploads

USER strapi

EXPOSE 1337

CMD ["node", "node_modules/@strapi/strapi/bin/strapi.js", "start"]
