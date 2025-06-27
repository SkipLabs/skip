FROM node:lts-alpine3.19
RUN npm install -g pnpm
WORKDIR /app
RUN apk add --no-cache bash
RUN apk add --no-cache socat
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build
EXPOSE 8080 8081
HEALTHCHECK --interval=10s --timeout=1s --retries=10 CMD wget --spider http://localhost:8081/v1/healthcheck
CMD ["pnpm", "start"]
