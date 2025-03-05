FROM node:lts-alpine3.19
WORKDIR /app
COPY package.json package.json
RUN npm install
COPY . .
RUN npm run build
EXPOSE 8080 8081
HEALTHCHECK --interval=10s --timeout=1s --retries=10 CMD echo "fake healthcheck success"
CMD ["npm", "start"]
