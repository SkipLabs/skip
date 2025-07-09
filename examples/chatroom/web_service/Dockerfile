FROM node:lts-alpine3.19
RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

HEALTHCHECK --interval=10s --timeout=1s --retries=10 CMD wget --spider http://localhost:3031/healthcheck

EXPOSE 3031
CMD ["pnpm", "start"]
