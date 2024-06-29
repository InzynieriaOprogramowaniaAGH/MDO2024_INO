# Dockerfile
FROM node:14-alpine
WORKDIR /node-js-dummy-test
RUN apk add --no-cache git && \
    git clone https://github.com/devenes/node-js-dummy-test /node-js-dummy-test
RUN npm install
CMD ["node", "index.js"]
