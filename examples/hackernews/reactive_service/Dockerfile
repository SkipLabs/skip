FROM node:lts-alpine3.19
WORKDIR /app
COPY package.json package.json
RUN npm install
COPY . .
RUN npm run build
EXPOSE 80 8080
CMD ["npm", "start"]
