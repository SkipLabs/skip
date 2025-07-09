FROM node:lts-alpine3.19
RUN npm install -g pnpm
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . .
RUN pnpm build
EXPOSE 8080 8081
HEALTHCHECK --interval=10s --timeout=1s --retries=10 CMD wget --spider http://localhost:8081/v1/healthcheck
CMD ["pnpm", "start"]
