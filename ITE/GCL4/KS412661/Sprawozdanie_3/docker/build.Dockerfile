FROM node:16-alpine

RUN apk update
RUN apk add --no-cache git

RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test

RUN npm install