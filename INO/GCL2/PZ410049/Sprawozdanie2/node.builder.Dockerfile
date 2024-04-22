FROM node:19.5.0-alpine
RUN apk update && apk add --no-cache git curl
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR node-js-dummy-test
RUN npm install 
