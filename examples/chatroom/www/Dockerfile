FROM node:22.13.1-alpine3.21 AS build
WORKDIR /build
COPY package.json package.json
RUN npm install
COPY . .
RUN npm run build

FROM nginx:1.27.3-alpine
WORKDIR /app
COPY --from=build /build/dist /usr/share/nginx/html

HEALTHCHECK --interval=10s --timeout=1s --retries=10 CMD curl --fail http://localhost/ || exit 1
