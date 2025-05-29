FROM node:lts-alpine3.19
WORKDIR /app
RUN apk add --no-cache bash
COPY package.json package.json
RUN npm install
COPY . .
RUN npm run build
EXPOSE 8080 8081
HEALTHCHECK --interval=10s --timeout=1s --retries=10 CMD wget --spider http://localhost:8081/v1/healthcheck
CMD ["npm", "start"]
