FROM node:22-alpine

WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files
COPY stock-app/package.json stock-app/pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code (excluding node_modules)
COPY stock-app/src ./src
COPY stock-app/public ./public
COPY stock-app/next.config.ts ./
COPY stock-app/next-env.d.ts ./
COPY stock-app/tsconfig.json ./
COPY stock-app/commitlint.config.ts ./
COPY stock-app/eslint.config.mjs ./
COPY stock-app/.env* ./

EXPOSE 3000

CMD ["pnpm", "dev"]