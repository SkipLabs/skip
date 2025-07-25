FROM node:lts-alpine3.19 AS build
RUN npm install -g pnpm
WORKDIR /build
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . .
RUN pnpm build

FROM nginx:alpine
WORKDIR /app
COPY --from=build /build/dist /usr/share/nginx/html

HEALTHCHECK --interval=10s --timeout=1s --retries=10 CMD curl --fail http://localhost/ || exit 1