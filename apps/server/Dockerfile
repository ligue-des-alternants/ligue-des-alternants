# ================================
# Strapi Dockerfile - Multi-stage build
# ================================

# Stage 1: Builder
FROM node:20-alpine AS builder
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@10 --activate

# Copy workspace configuration
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY packages/ ./packages/
COPY apps/server/ ./apps/server/

# Install all dependencies and build
RUN pnpm install --frozen-lockfile --filter @ligue-des-alternants/server...
WORKDIR /app/apps/server
ENV NODE_ENV=production
RUN pnpm build

# Stage 2: Production
FROM node:20-alpine AS runner
RUN apk add --no-cache libc6-compat

WORKDIR /app

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337

# Create non-root user for security
RUN addgroup --system --gid 1001 strapi
RUN adduser --system --uid 1001 strapi

# Copy package files for production install (remove devDependencies with workspace refs)
COPY --from=builder /app/apps/server/package.json ./package.json.orig
RUN node -e "const fs=require('fs'); const p=JSON.parse(fs.readFileSync('./package.json.orig','utf8')); delete p.devDependencies; fs.writeFileSync('package.json', JSON.stringify(p, null, 2));"

# Install production dependencies using npm (avoids pnpm workspace issues)
RUN npm install --omit=dev

# Copy built application
COPY --from=builder --chown=strapi:strapi /app/apps/server/dist ./dist
COPY --from=builder --chown=strapi:strapi /app/apps/server/public ./public
COPY --from=builder --chown=strapi:strapi /app/apps/server/config ./config
COPY --from=builder --chown=strapi:strapi /app/apps/server/src ./src
# Copy the admin build (required for Strapi v5)
COPY --from=builder --chown=strapi:strapi /app/apps/server/.cache ./.cache

# Create a standalone tsconfig.json (without workspace dependency)
RUN echo '{"compilerOptions":{"module":"CommonJS","moduleResolution":"Node","lib":["ES2020"],"target":"ES2019","strict":false,"skipLibCheck":true,"forceConsistentCasingInFileNames":true,"esModuleInterop":true,"resolveJsonModule":true,"outDir":"dist","rootDir":"."},"include":["./**/*.ts","./**/*.js","src/**/*.json"],"exclude":["node_modules/","build/","dist/",".cache/"]}' > tsconfig.json

# Create uploads directory and database migrations directory with correct permissions
RUN mkdir -p public/uploads database/migrations && chown -R strapi:strapi public/uploads database

USER strapi

EXPOSE 1337

CMD ["node", "node_modules/@strapi/strapi/bin/strapi.js", "start"]
